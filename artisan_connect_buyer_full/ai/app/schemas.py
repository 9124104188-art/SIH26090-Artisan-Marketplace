from typing import Generic, TypeVar, Optional, List, Any, Literal
from pydantic import BaseModel, Field

T = TypeVar("T")

class ApiResponse(BaseModel, Generic[T]):
    success: bool
    data: Optional[T] = None
    message: Optional[str] = None

class HealthData(BaseModel):
    status: str = "healthy"
    service: str = "artisan-ai-service"
    version: str = "1.0.0"

class ImageProcessResponseData(BaseModel):
    imageUrl: str
    originalName: Optional[str] = None
    width: Optional[int] = None
    height: Optional[int] = None
    enhanced: bool = True
    bgRemoved: bool = False

class VoiceTranscribeResponseData(BaseModel):
    text: str

class CatalogGenerateRequest(BaseModel):
    text: Optional[str] = Field(None, description="Voice transcribed text or raw description")
    voiceText: Optional[str] = Field(None, description="Alternative field for transcription")
    category: Optional[str] = Field(None, description="Optional hint for category")
    artisanInfo: Optional[str] = Field(None, description="Optional artisan background context")
    imageUrl: Optional[str] = Field(None, description="Processed image URL returned by the image endpoint")

class CatalogGenerateData(BaseModel):
    title: str
    description: str
    category: str
    craftType: str
    materials: List[str]
    tags: List[str]
    price: Optional[int] = None
    quantity: Optional[int] = None
    confidence: Optional[float] = 0.90

class ClassifyRequest(BaseModel):
    text: Optional[str] = None
    description: Optional[str] = None

class ClassifyData(BaseModel):
    category: str
    confidence: float

class TagsRequest(BaseModel):
    text: Optional[str] = None
    category: Optional[str] = None
    materials: Optional[List[str]] = None

class TagsData(BaseModel):
    category: str
    craftType: str
    materials: List[str]
    tags: List[str]

class PricingRequest(BaseModel):
    materialCost: float = Field(..., ge=0, description="Cost of raw materials in INR")
    labourHours: float = Field(0, ge=0, description="Labor hours spent")
    hourlyRate: float = Field(0, ge=0, description="Hourly labor rate in INR")
    labourCost: Optional[float] = Field(None, ge=0, description="Direct labor cost override")
    overhead: float = Field(0, ge=0, description="Transport, tools, utilities cost")
    marginPercent: float = Field(20.0, ge=0, description="Desired profit margin percentage")
    craftComplexity: Literal["simple", "medium", "complex", "high_mastery"] = Field(
        "medium", description="simple, medium, complex, high_mastery"
    )

class PricingBreakdown(BaseModel):
    materialCost: float
    labourCost: float
    overhead: float
    margin: float
    complexityMultiplier: float

class PricingData(BaseModel):
    suggestedPrice: int
    minimumPrice: int
    maximumPrice: int
    breakdown: Optional[PricingBreakdown] = None

class RecommendationProduct(BaseModel):
    productId: str
    category: str = ""
    tags: List[str] = []
    materials: List[str] = []
    price: float = 0
    rating: float = 0
    reviews: int = 0
    description: str = ""

class RecommendationsRequest(BaseModel):
    products: List[RecommendationProduct] = Field(..., min_length=1)
    preferredCategories: List[str] = []
    preferredTags: List[str] = []
    limit: int = Field(8, ge=1, le=20)

class RecommendationItem(BaseModel):
    productId: str
    score: float
    reason: str

class RecommendationsData(BaseModel):
    recommendations: List[RecommendationItem]
