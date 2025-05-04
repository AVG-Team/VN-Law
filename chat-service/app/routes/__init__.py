def register_routes(api):
    # import các route modules nếu cần
    from .chat_routes import ChatRoutes  # ví dụ nếu bạn có file chat_routes.py

    # Nếu bạn dùng Flask-Restful:
    # api_or_app.add_resource(ChatRoutes, '/chat')

    # Nếu bạn dùng Flask Blueprint:
    # from .chat_routes import chat_bp
    # api_or_app.register_blueprint(chat_bp)
