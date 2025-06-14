import asyncio
import hypercorn.asyncio
from hypercorn.config import Config
from app.main import app

# Cấu hình Hypercorn
config = Config()
config.bind = ["0.0.0.0:9006"]

async def main():
    await hypercorn.asyncio.serve(app, config)

if __name__ == "__main__":
    asyncio.run(main())