from celery import Celery
from celery.schedules import crontab

# Khởi tạo Celery app
celery_app = Celery('crawl_tasks',
                    broker='redis://redis:6379/0',
                    backend='redis://redis:6379/0',
                    include=['tasks'])  # Thêm tasks vào include

# Cấu hình Celery Beat schedule
celery_app.conf.beat_schedule = {
    # 'daily-crawl': {
    #     'task': 'tasks.crawl_data',
    #     'schedule': crontab(hour=1, minute=0, day_of_week=1),
    # },
    # Chạy task test_crawl_dat_tasks hàng tuân lúc 1 giờ sáng vào thứ 2 hàng tuần
    'daily-test-crawl': {
        'task': 'tasks.test_crawl_dat_tasks',
        'schedule': crontab(hour=1, minute=0, day_of_week=1),
    },
}

# Cấu hình timezone
celery_app.conf.timezone = 'Asia/Ho_Chi_Minh'

# Cấu hình task serialization
celery_app.conf.task_serializer = 'json'
celery_app.conf.accept_content = ['json']
celery_app.conf.result_serializer = 'json' 