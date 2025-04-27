from fastapi import FastAPI, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from tasks import crawl_data, test_crawl_dat_tasks

app = FastAPI()

# Cấu hình CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/api/crawl")
async def trigger_crawl(background_tasks: BackgroundTasks):
    background_tasks.add_task(crawl_data)
    return {"message": "Crawl task started"}

@app.post("/api/test-crawl")
async def trigger_test_crawl(background_tasks: BackgroundTasks):
    background_tasks.add_task(test_crawl_dat_tasks)
    return {"message": "Test crawl task started"} 