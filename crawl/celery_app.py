import os
from dotenv import load_dotenv
from celery import Celery
from celery.schedules import crontab

# Tải biến môi trường từ file .env trong thư mục gốc
load_dotenv()

# Lấy URL Redis từ biến môi trường
REDIS_BROKER = os.getenv("REDIS_BROKER", "redis://redis:6379/0")  # Dùng "redis" thay vì "localhost" trong Docker
REDIS_BACKEND = os.getenv("REDIS_BACKEND", "redis://redis:6379/0")

# Cấu hình Celery
celery = Celery('law_crawler',
                broker=REDIS_BROKER,
                backend=REDIS_BACKEND,
                include=['tasks'])  # Thêm include để đảm bảo tasks được nhận diện

# Cấu hình cron job (chạy hàng ngày lúc 1h sáng)
celery.conf.beat_schedule = {
    'crawl-every-day': {
        'task': 'tasks.crawl_data',
        'schedule': crontab(hour=1, minute=0),
    },
}

# Cấu hình thêm để đảm bảo Celery hoạt động đúng
celery.conf.task_track_started = True
celery.conf.task_serializer = 'json'
celery.conf.result_serializer = 'json'
celery.conf.accept_content = ['json']