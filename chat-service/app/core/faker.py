from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from app.models.message import Message
from app.models.conversation import Conversation
from faker import Faker
import uuid
import datetime
import random

fake = Faker()


async def populate_data_if_empty(db: AsyncSession):
    # Kiểm tra bảng Conversation có dữ liệu hay không
    result = await db.execute(select(Conversation).limit(1))
    if not result.scalars().first():
        print("Tables are empty. Inserting data...")

        # Tạo dữ liệu cho Conversation
        conversations = []

        for _ in range(20):  # Tạo 20 cuộc hội thoại
            conversation = Conversation(
                id=str(uuid.uuid4()),
                user_id=str(uuid.uuid4()),  # Giả định một user_id ngẫu nhiên
                title=fake.sentence(nb_words=3),
                created_at=fake.date_time_between(start_date='-1y', end_date='now', tzinfo=datetime.timezone.utc),
                updated_at=fake.date_time_between(start_date='-1m', end_date='now', tzinfo=datetime.timezone.utc),
                deleted_at=fake.date_time_this_year(tzinfo=datetime.timezone.utc) if random.choice(
                    [True, False]) else None
            )
            conversations.append(conversation)

        # Tạo dữ liệu cho Message
        messages = []
        for conversation in conversations:
            for _ in range(random.randint(1, 10)):  # Mỗi cuộc hội thoại có 1-10 tin nhắn
                message = Message(
                    id=str(uuid.uuid4()),
                    conversation_id=conversation.id,
                    message=fake.text().replace("'", "''"),
                    reply=fake.text().replace("'", "''") if random.choice([True, False]) else None,
                    timestamp=fake.date_time_between(start_date=conversation.created_at, end_date='now',
                                                     tzinfo=datetime.timezone.utc)
                )
                messages.append(message)

        # Thêm dữ liệu vào database
        try:
            db.add_all(conversations)
            db.add_all(messages)
            await db.commit()
            print("Data inserted successfully.")
        except Exception as e:
            await db.rollback()
            print(f"An error occurred: {e}")
    else:
        print("Tables already contain data. No insertion performed.")
