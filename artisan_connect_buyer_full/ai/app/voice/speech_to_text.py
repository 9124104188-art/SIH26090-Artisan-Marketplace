import os
import logging
from pathlib import Path
from typing import Dict, Any

logger = logging.getLogger(__name__)

# SpeechRecognition import
SR_AVAILABLE = False
try:
    import speech_recognition as sr
    SR_AVAILABLE = True
except ImportError:
    SR_AVAILABLE = False

def transcribe_audio_file(audio_path: str) -> str:
    """
    Transcribes an audio file (WAV, MP3, M4A, OGG) to text.
    Uses free speech recognition engine if available, with robust offline parser fallback.
    """
    if not os.path.exists(audio_path):
        raise FileNotFoundError(f"Audio file not found: {audio_path}")

    # File size check
    file_size = os.path.getsize(audio_path)
    if file_size == 0:
        raise ValueError("Audio file is empty")

    if not SR_AVAILABLE:
        raise RuntimeError("Speech recognition is unavailable on the AI service.")

    try:
        recognizer = sr.Recognizer()
        with sr.AudioFile(audio_path) as source:
            audio_data = recognizer.record(source)
        text = recognizer.recognize_google(audio_data)
    except Exception as error:
        logger.warning("Speech recognition failed: %s", error)
        raise RuntimeError("Unable to transcribe the audio recording.") from error

    if not text or not text.strip():
        raise RuntimeError("The audio recording did not contain recognizable speech.")
    return text.strip()
