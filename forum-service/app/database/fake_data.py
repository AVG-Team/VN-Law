import uuid
from datetime import datetime, timedelta
from typing import List, Dict, Any

# Fake keycloak_ids (đại diện cho người dùng từ auth-service)
fake_keycloak_ids = [
    "df695d34-a1af-4d48-b96d-7cafe437aff3",
    "31004923-dc43-4f81-bbd3-c89a288e98c0",
    "37f8286b-c601-4acd-9c31-1440e7c6685e",
    "d4842d2b-5a35-4680-bd4b-896361cc96ba",
    "df695d34-a1af-4d48-b96d-7cafe437aff3",
]

# Fake users (giả lập thông tin từ auth-service)
fake_users = [
    {"keycloak_id": fake_keycloak_ids[0], "name": "Nguyen Van A", "email": "nguyen@example.com"},
    {"keycloak_id": fake_keycloak_ids[1], "name": "Tran Thi B", "email": "tran@example.com"},
    {"keycloak_id": fake_keycloak_ids[2], "name": "Le Van C", "email": "le@example.com"},
    {"keycloak_id": fake_keycloak_ids[3], "name": "Pham Thi D", "email": "pham@example.com"},
    {"keycloak_id": fake_keycloak_ids[4], "name": "Hoang Van E", "email": "hoang@example.com"},
]

# Fake posts (10 bài viết)
fake_posts = [
    {
        "id": str(uuid.uuid4()),
        "title": "Tư vấn luật thừa kế đất đai",
        "content": "Tôi có mảnh đất đứng tên bố mẹ, giờ muốn chia cho anh chị em thì cần làm gì?",
        "keycloak_id": fake_keycloak_ids[0],  # Nguyen Van A
        "name": "Nguyen Van A",
        "created_at": datetime.now() - timedelta(days=10),
        "is_pinned": True,
        "is_deleted": False,
        "likes": 15
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Quy định về hợp đồng lao động",
        "content": "Hợp đồng lao động không thời hạn có cần gia hạn không? Quy định pháp luật thế nào?",
        "keycloak_id": fake_keycloak_ids[1],  # Tran Thi B
        "name": "Tran Thi B",
        "created_at": datetime.now() - timedelta(days=9),
        "is_pinned": False,
        "is_deleted": False,
        "likes": 8
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Xử lý vi phạm giao thông",
        "content": "Tôi bị phạt vì vượt đèn đỏ, làm sao để kháng cáo quyết định này?",
        "keycloak_id": fake_keycloak_ids[2],  # Le Van C
        "name": "Le Van C",
        "created_at": datetime.now() - timedelta(days=8),
        "is_pinned": False,
        "is_deleted": False,
        "likes": 12
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Luật bảo vệ người tiêu dùng",
        "content": "Mua hàng online bị lừa, tôi có thể kiện shop được không?",
        "keycloak_id": fake_keycloak_ids[3],  # Pham Thi D
        "name": "Pham Thi D",
        "created_at": datetime.now() - timedelta(days=7),
        "is_pinned": True,
        "is_deleted": False,
        "likes": 20
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Thủ tục đăng ký kết hôn",
        "content": "Cần chuẩn bị những giấy tờ gì để đăng ký kết hôn tại Việt Nam?",
        "keycloak_id": fake_keycloak_ids[4],  # Hoang Van E
        "name": "Hoang Van E",
        "created_at": datetime.now() - timedelta(days=6),
        "is_pinned": False,
        "is_deleted": False,
        "likes": 5
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Quyền lợi khi nghỉ việc",
        "content": "Tôi nghỉ việc thì có được hưởng trợ cấp thất nghiệp không?",
        "keycloak_id": fake_keycloak_ids[0],  # Nguyen Van A
        "name": "Nguyen Van A",
        "created_at": datetime.now() - timedelta(days=5),
        "is_pinned": False,
        "is_deleted": False,
        "likes": 7
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Tư vấn ly hôn đơn phương",
        "content": "Làm thế nào để ly hôn đơn phương khi vợ/chồng không đồng ý?",
        "keycloak_id": fake_keycloak_ids[1],  # Tran Thi B
        "name": "Tran Thi B",
        "created_at": datetime.now() - timedelta(days=4),
        "is_pinned": False,
        "is_deleted": False,
        "likes": 10
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Luật sở hữu trí tuệ",
        "content": "Làm sao để đăng ký bản quyền cho một sản phẩm sáng tạo?",
        "keycloak_id": fake_keycloak_ids[2],  # Le Van C
        "name": "Le Van C",
        "created_at": datetime.now() - timedelta(days=3),
        "is_pinned": False,
        "is_deleted": False,
        "likes": 9
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Quy định về thuế thu nhập cá nhân",
        "content": "Thu nhập bao nhiêu thì phải nộp thuế thu nhập cá nhân?",
        "keycloak_id": fake_keycloak_ids[3],  # Pham Thi D
        "name": "Pham Thi D",
        "created_at": datetime.now() - timedelta(days=2),
        "is_pinned": False,
        "is_deleted": False,
        "likes": 6
    },
    {
        "id": str(uuid.uuid4()),
        "title": "Tư vấn mua bán nhà đất",
        "content": "Cần lưu ý gì khi mua đất chưa có sổ đỏ?",
        "keycloak_id": fake_keycloak_ids[4],  # Hoang Van E
        "name": "Hoang Van E",
        "created_at": datetime.now() - timedelta(days=1),
        "is_pinned": False,
        "is_deleted": False,
        "likes": 11
    },
]

# Fake comments (10 bình luận)
fake_comments = [
    {
        "id": 1,
        "post_id": fake_posts[0]["id"],
        "keycloak_id": fake_keycloak_ids[1],  # Tran Thi B
        "name": "Tran Thi B",
        "content": "Bạn cần làm thủ tục phân chia di sản tại phòng công chứng.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(days=9)
    },
    {
        "id": 2,
        "post_id": fake_posts[0]["id"],
        "keycloak_id": fake_keycloak_ids[2],  # Le Van C
        "name": "Le Van C",
        "content": "Đúng vậy, cần có giấy tờ chứng minh quyền thừa kế.",
        "parent_id": 1,
        "created_at": datetime.now() - timedelta(days=8)
    },
    {
        "id": 3,
        "post_id": fake_posts[1]["id"],
        "keycloak_id": fake_keycloak_ids[0],  # Nguyen Van A
        "name": "Nguyen Van A",
        "content": "Không cần gia hạn, hợp đồng không thời hạn có hiệu lực liên tục.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(days=8)
    },
    {
        "id": 4,
        "post_id": fake_posts[3]["id"],
        "keycloak_id": fake_keycloak_ids[4],  # Hoang Van E
        "name": "Hoang Van E",
        "content": "Bạn có thể nộp đơn khiếu nại lên cơ quan bảo vệ người tiêu dùng.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(days=6)
    },
    {
        "id": 5,
        "post_id": fake_posts[4]["id"],
        "keycloak_id": fake_keycloak_ids[2],  # Le Van C
        "name": "Le Van C",
        "content": "Cần CMND/CCCD, giấy xác nhận tình trạng hôn nhân.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(days=5)
    },
    {
        "id": 6,
        "post_id": fake_posts[5]["id"],
        "keycloak_id": fake_keycloak_ids[3],  # Pham Thi D
        "name": "Pham Thi D",
        "content": "Cần đóng đủ bảo hiểm thất nghiệp trong 12 tháng gần nhất.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(days=4)
    },
    {
        "id": 7,
        "post_id": fake_posts[6]["id"],
        "keycloak_id": fake_keycloak_ids[0],  # Nguyen Van A
        "name": "Nguyen Van A",
        "content": "Nộp đơn ra tòa án, cần chứng minh mâu thuẫn không thể hòa giải.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(days=3)
    },
    {
        "id": 8,
        "post_id": fake_posts[7]["id"],
        "keycloak_id": fake_keycloak_ids[1],  # Tran Thi B
        "name": "Tran Thi B",
        "content": "Đăng ký tại Cục Sở hữu trí tuệ Việt Nam.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(days=2)
    },
    {
        "id": 9,
        "post_id": fake_posts[8]["id"],
        "keycloak_id": fake_keycloak_ids[4],  # Hoang Van E
        "name": "Hoang Van E",
        "content": "Thu nhập trên 11 triệu/tháng phải nộp thuế.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(days=1)
    },
    {
        "id": 10,
        "post_id": fake_posts[9]["id"],
        "keycloak_id": fake_keycloak_ids[2],  # Le Van C
        "name": "Le Van C",
        "content": "Nên kiểm tra pháp lý kỹ trước khi mua.",
        "parent_id": None,
        "created_at": datetime.now() - timedelta(hours=12)
    },
]

# Fake likes (10 lượt thích)
fake_likes = [
    {"id": 1, "post_id": fake_posts[0]["id"], "keycloak_id": fake_keycloak_ids[1]},
    {"id": 2, "post_id": fake_posts[0]["id"], "keycloak_id": fake_keycloak_ids[2]},
    {"id": 3, "post_id": fake_posts[1]["id"], "keycloak_id": fake_keycloak_ids[0]},
    {"id": 4, "post_id": fake_posts[2]["id"], "keycloak_id": fake_keycloak_ids[3]},
    {"id": 5, "post_id": fake_posts[3]["id"], "keycloak_id": fake_keycloak_ids[4]},
    {"id": 6, "post_id": fake_posts[4]["id"], "keycloak_id": fake_keycloak_ids[1]},
    {"id": 7, "post_id": fake_posts[5]["id"], "keycloak_id": fake_keycloak_ids[2]},
    {"id": 8, "post_id": fake_posts[6]["id"], "keycloak_id": fake_keycloak_ids[0]},
    {"id": 9, "post_id": fake_posts[7]["id"], "keycloak_id": fake_keycloak_ids[3]},
    {"id": 10, "post_id": fake_posts[8]["id"], "keycloak_id": fake_keycloak_ids[4]},
]

# Fake stars (10 lượt đánh dấu sao)
fake_stars = [
    {"id": 1, "post_id": fake_posts[0]["id"], "keycloak_id": fake_keycloak_ids[0]},
    {"id": 2, "post_id": fake_posts[1]["id"], "keycloak_id": fake_keycloak_ids[1]},
    {"id": 3, "post_id": fake_posts[2]["id"], "keycloak_id": fake_keycloak_ids[2]},
    {"id": 4, "post_id": fake_posts[3]["id"], "keycloak_id": fake_keycloak_ids[3]},
    {"id": 5, "post_id": fake_posts[4]["id"], "keycloak_id": fake_keycloak_ids[4]},
    {"id": 6, "post_id": fake_posts[5]["id"], "keycloak_id": fake_keycloak_ids[0]},
    {"id": 7, "post_id": fake_posts[6]["id"], "keycloak_id": fake_keycloak_ids[1]},
    {"id": 8, "post_id": fake_posts[7]["id"], "keycloak_id": fake_keycloak_ids[2]},
    {"id": 9, "post_id": fake_posts[8]["id"], "keycloak_id": fake_keycloak_ids[3]},
    {"id": 10, "post_id": fake_posts[9]["id"], "keycloak_id": fake_keycloak_ids[4]},
]

# Fake notifications (10 thông báo)
fake_notifications = [
    {
        "id": 1,
        "keycloak_id": fake_keycloak_ids[0],  # Nguyen Van A
        "message": "Tran Thi B đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=9)
    },
    {
        "id": 2,
        "keycloak_id": fake_keycloak_ids[0],  # Nguyen Van A
        "message": "Le Van C đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=8)
    },
    {
        "id": 3,
        "keycloak_id": fake_keycloak_ids[1],  # Tran Thi B
        "message": "Nguyen Van A đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=8)
    },
    {
        "id": 4,
        "keycloak_id": fake_keycloak_ids[3],  # Pham Thi D
        "message": "Hoang Van E đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=6)
    },
    {
        "id": 5,
        "keycloak_id": fake_keycloak_ids[4],  # Hoang Van E
        "message": "Le Van C đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=5)
    },
    {
        "id": 6,
        "keycloak_id": fake_keycloak_ids[0],  # Nguyen Van A
        "message": "Pham Thi D đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=4)
    },
    {
        "id": 7,
        "keycloak_id": fake_keycloak_ids[1],  # Tran Thi B
        "message": "Nguyen Van A đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=3)
    },
    {
        "id": 8,
        "keycloak_id": fake_keycloak_ids[2],  # Le Van C
        "message": "Tran Thi B đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=2)
    },
    {
        "id": 9,
        "keycloak_id": fake_keycloak_ids[3],  # Pham Thi D
        "message": "Hoang Van E đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(days=1)
    },
    {
        "id": 10,
        "keycloak_id": fake_keycloak_ids[4],  # Hoang Van E
        "message": "Le Van C đã bình luận bài của bạn",
        "is_read": False,
        "created_at": datetime.now() - timedelta(hours=12)
    },
]

def get_fake_users() -> List[Dict[str, Any]]:
    return fake_users

def get_fake_posts() -> List[Dict[str, Any]]:
    return fake_posts

def get_fake_comments() -> List[Dict[str, Any]]:
    return fake_comments

def get_fake_likes() -> List[Dict[str, Any]]:
    return fake_likes

def get_fake_stars() -> List[Dict[str, Any]]:
    return fake_stars

def get_fake_notifications() -> List[Dict[str, Any]]:
    return fake_notifications