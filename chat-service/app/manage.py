from flask_migrate import Migrate
from app import create_app, db
from models  import User, Log, Message, Conversation
import sys

app = create_app("dev")  # Hoặc "production"
migrate = Migrate(app, db)

if __name__ == "__main__":
    from flask.cli import main
    main()
