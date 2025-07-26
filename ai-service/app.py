from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import os
from dotenv import load_dotenv
from ai_processor import AIProcessor
from database import get_database

load_dotenv()

app = FastAPI(title="AI Service", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize AI processor
ai_processor = AIProcessor()

# Pydantic models
class ProcessRequest(BaseModel):
    text: str
    type: str
    userId: Optional[str] = None

class ProcessResponse(BaseModel):
    result: str
    type: str
    metadata: Optional[dict] = None

@app.get("/")
async def root():
    return {"message": "AI Service is running!"}

@app.get("/health")
async def health():
    return {"status": "healthy", "service": "ai-service"}

@app.post("/process", response_model=ProcessResponse)
async def process_text(request: ProcessRequest):
    try:
        # Process the text based on type
        if request.type == "summarize":
            result = ai_processor.summarize_text(request.text)
        elif request.type == "analyze":
            result = ai_processor.analyze_sentiment(request.text)
        elif request.type == "extract":
            result = ai_processor.extract_keywords(request.text)
        elif request.type == "translate":
            result = ai_processor.translate_text(request.text)
        else:
            raise HTTPException(status_code=400, detail="Invalid processing type")

        # Store in database if userId is provided
        if request.userId:
            db = get_database()
            content_collection = db.content
            content_collection.insert_one({
                "userId": request.userId,
                "originalText": request.text,
                "processedText": result,
                "type": request.type,
                "timestamp": ai_processor.get_current_timestamp()
            })

        return ProcessResponse(
            result=result,
            type=request.type,
            metadata={"processing_time": "0.5s"}
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/models")
async def get_available_models():
    return {
        "models": [
            {"name": "summarize", "description": "Text summarization"},
            {"name": "analyze", "description": "Sentiment analysis"},
            {"name": "extract", "description": "Keyword extraction"},
            {"name": "translate", "description": "Text translation"}
        ]
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 