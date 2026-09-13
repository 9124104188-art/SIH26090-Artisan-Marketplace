import csv
import logging
import math
from functools import lru_cache
from pathlib import Path
from typing import Any, Dict

logger = logging.getLogger(__name__)

COMPLEXITY_MULTIPLIERS = {
    "simple": 1.0,
    "medium": 1.15,
    "complex": 1.30,
    "high_mastery": 1.50,
}
COMPLEXITY_CODES = {name: index for index, name in enumerate(COMPLEXITY_MULTIPLIERS)}
AI_ROOT = Path(__file__).resolve().parents[2]
DATASET_PATH = AI_ROOT / "data" / "pricing_training.csv"
MODEL_PATH = AI_ROOT / "data" / "pricing_model.joblib"


def _feature_row(
    material_cost: float,
    labour_hours: float,
    hourly_rate: float,
    labour_cost: float,
    overhead: float,
    margin_percent: float,
    craft_complexity: str,
) -> list[float]:
    return [
        material_cost,
        labour_hours,
        hourly_rate,
        labour_cost,
        overhead,
        margin_percent,
        float(COMPLEXITY_CODES[craft_complexity]),
    ]


def _train_model() -> Any:
    # Lazy import: scikit-learn is heavy and only needed when training/predicting.
    from sklearn.ensemble import RandomForestRegressor
    import joblib

    if not DATASET_PATH.is_file():
        raise RuntimeError(f"Pricing training dataset is missing: {DATASET_PATH}")

    features = []
    targets = []
    with DATASET_PATH.open(newline="", encoding="utf-8") as dataset:
        for row in csv.DictReader(dataset):
            complexity = row["craft_complexity"].strip().lower()
            if complexity not in COMPLEXITY_CODES:
                raise RuntimeError(f"Unsupported training complexity: {complexity}")
            features.append(
                _feature_row(
                    float(row["material_cost"]),
                    float(row["labour_hours"]),
                    float(row["hourly_rate"]),
                    float(row["labour_cost"]),
                    float(row["overhead"]),
                    float(row["margin_percent"]),
                    complexity,
                )
            )
            targets.append(float(row["price"]))

    if len(features) < 2:
        raise RuntimeError("Pricing training dataset must contain at least two rows.")

    model = RandomForestRegressor(
        n_estimators=200,
        random_state=42,
        min_samples_leaf=1,
    )
    model.fit(features, targets)
    MODEL_PATH.parent.mkdir(parents=True, exist_ok=True)
    joblib.dump(model, MODEL_PATH)
    return model


@lru_cache(maxsize=1)
def _load_model() -> Any:
    # Lazy import: joblib/sklearn are heavy and only needed when loading/predicting.
    import joblib
    from sklearn.ensemble import RandomForestRegressor

    if MODEL_PATH.is_file():
        try:
            model = joblib.load(MODEL_PATH)
            if isinstance(model, RandomForestRegressor):
                return model
            logger.warning("Ignoring invalid pricing model artifact: %s", MODEL_PATH)
        except (OSError, ValueError, EOFError) as error:
            logger.warning("Unable to load pricing model; retraining: %s", error)
    return _train_model()


def calculate_smart_price(
    material_cost: float,
    labour_hours: float = 0,
    hourly_rate: float = 0,
    labour_cost_override: float = None,
    overhead: float = 0,
    margin_percent: float = 20.0,
    craft_complexity: str = "medium",
) -> Dict[str, Any]:
    """Predict a fair price with a persisted RandomForestRegressor."""
    values = {
        "material cost": material_cost,
        "labour hours": labour_hours,
        "hourly rate": hourly_rate,
        "overhead": overhead,
        "margin percentage": margin_percent,
    }
    if labour_cost_override is not None:
        values["labour cost"] = labour_cost_override
    if any(not math.isfinite(float(value)) or float(value) < 0 for value in values.values()):
        raise ValueError("Pricing inputs must be finite and nonnegative")

    complexity_key = str(craft_complexity).lower().strip()
    if complexity_key not in COMPLEXITY_CODES:
        raise ValueError(
            "craftComplexity must be one of: simple, medium, complex, high_mastery"
        )

    labour_cost = (
        float(labour_cost_override)
        if labour_cost_override is not None
        else float(labour_hours) * float(hourly_rate)
    )
    row = _feature_row(
        float(material_cost),
        float(labour_hours),
        float(hourly_rate),
        labour_cost,
        float(overhead),
        float(margin_percent),
        complexity_key,
    )
    logger.info(
        "Smart pricing inputs=%s feature_row=%s labour_cost=%s base_cost=%s",
        values | {"craft complexity": complexity_key},
        row,
        labour_cost,
        float(material_cost) + labour_cost + float(overhead),
    )
    # Lazy import: numpy is heavy and only needed for prediction math.
    import numpy as np

    model = _load_model()
    tree_predictions = np.array([tree.predict([row])[0] for tree in model.estimators_])
    predicted_price = max(0, int(round(model.predict([row])[0])))
    minimum_price = max(0, int(round(np.percentile(tree_predictions, 10))))
    maximum_price = max(predicted_price, int(round(np.percentile(tree_predictions, 90))))
    minimum_price = min(minimum_price, predicted_price)
    base_cost = float(material_cost) + labour_cost + float(overhead)
    logger.info(
        "Smart pricing output suggested=%s minimum=%s maximum=%s",
        predicted_price,
        minimum_price,
        maximum_price,
    )

    return {
        "suggestedPrice": predicted_price,
        "minimumPrice": minimum_price,
        "maximumPrice": maximum_price,
        "breakdown": {
            "materialCost": round(float(material_cost), 2),
            "labourCost": round(labour_cost, 2),
            "overhead": round(float(overhead), 2),
            "margin": round(max(0.0, predicted_price - base_cost), 2),
            "complexityMultiplier": COMPLEXITY_MULTIPLIERS[complexity_key],
        },
    }
