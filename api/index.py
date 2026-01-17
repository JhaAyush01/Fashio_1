from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import numpy as np
from sentence_transformers import SentenceTransformer
import faiss
import pandas as pd

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables for caching (reused across function invocations)
_df = None
_model = None
_index = None
_sentences = None

def load_data():
    """Load and return the preprocessed dataset"""
    global _df
    if _df is None:
        _df = pd.read_csv("Preprocessed data.csv")
    return _df

def load_model():
    """Load and return the SentenceTransformer model"""
    global _model
    if _model is None:
        _model = SentenceTransformer('ShauryaNova/autotrain-ShauryaNova')
    return _model

def create_faiss_index(model, sentences):
    """Create and return FAISS index from embeddings"""
    global _index
    if _index is None:
        embeddings = model.encode(sentences)
        embeddings = np.array(embeddings)
        d = embeddings.shape[1]  # Dimensionality of embeddings
        _index = faiss.IndexFlatIP(d)  # Inner product for similarity search
        _index.add(embeddings)
    return _index

# Request model for POST requests
class SearchRequest(BaseModel):
    query: str
    k: Optional[int] = 5

# Initialize on startup
@app.on_event("startup")
async def startup_event():
    global _df, _model, _index, _sentences
    _df = load_data()
    _sentences = _df['description'].tolist()
    _model = load_model()
    _index = create_faiss_index(_model, _sentences)

@app.get("/search")
async def search_get(
    query: str = Query(..., description="Search query"),
    k: int = Query(5, ge=1, le=20, description="Number of results")
):
    """Search endpoint - GET method"""
    return perform_search(query, k)

@app.post("/search")
async def search_post(request: SearchRequest):
    """Search endpoint - POST method"""
    return perform_search(request.query, request.k)

def perform_search(query: str, k: int):
    """Perform the actual search - same logic as original Streamlit app"""
    global _df, _model, _index
    
    if not query:
        raise HTTPException(status_code=400, detail="Query parameter is required")
    
    # Ensure k is within valid range
    k = max(1, min(k, 20))
    
    # Encoding query into our embedding
    query_embedding = _model.encode([query])[0]
    
    # Performing similarity search using FAISS
    query_embedding = query_embedding.reshape(1, -1).astype(np.float32)
    distances, indices = _index.search(query_embedding, k)
    
    # Building results
    results = []
    for i in range(k):
        idx = indices[0][i]
        name = _df.iloc[idx]['title']
        description = _df.iloc[idx]['description']
        url = _df.iloc[idx]['url']
        distance = distances[0][i]
        results.append({
            'name': name,
            'description': description,
            'url': url,
            'likeness': float(distance * 100)
        })
    
    return {
        'query': query,
        'results': results
    }
