# app/core/fakerRedis.py
import datetime
import random
import uuid
from faker import Faker
from app.core.redisClient import redis_client

fake = Faker()


def iso_to_datetime(iso_string):
    return datetime.datetime.fromisoformat(iso_string)


def clean_dict(d):
    return {k: v if v is not None else '' for k, v in d.items()}


async def populate_data_if_empty():
    if await redis_client.dbsize() == 0:
        print("Redis is empty. Inserting data...")

        for _ in range(20):
            conversation_id = str(uuid.uuid4())
            created_at = fake.date_time_between(start_date='-1y', end_date='now', tzinfo=datetime.timezone.utc)
            conversation = {
                "id": conversation_id,
                "user_id": "5bd83d5b-343d-49da-a37c-479f98b68c57",
                "title": fake.sentence(nb_words=3),
                "created_at": created_at.isoformat(),
                "updated_at": fake.date_time_between(start_date=created_at, end_date='now',
                                                     tzinfo=datetime.timezone.utc).isoformat(),
                "deleted_at": fake.date_time_this_year(tzinfo=datetime.timezone.utc).isoformat() if random.choice(
                    [True, False]) else ''
            }
            await redis_client.hmset(f"conversation:{conversation_id}", clean_dict(conversation))
            await redis_client.sadd(f"user:{conversation['user_id']}:conversations", conversation_id)

            for _ in range(random.randint(1, 10)):
                message_id = str(uuid.uuid4())
                message = {
                    "id": message_id,
                    "conversation_id": conversation_id,
                    "message": fake.text(),
                    "reply": fake.text() if random.choice([True, False]) else '',
                    "timestamp": fake.date_time_between(start_date=iso_to_datetime(conversation["created_at"]),
                                                        end_date='now', tzinfo=datetime.timezone.utc).isoformat()
                }
                await redis_client.hmset(f"message:{message_id}", clean_dict(message))
                await redis_client.lpush(f"conversation:{conversation_id}:messages", message_id)

        print("Data inserted successfully into Redis.")
    else:
        print("Redis already contains data. No insertion performed.")
