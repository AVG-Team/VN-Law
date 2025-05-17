class ChatRoutes:
    def __init__(self, app):
        self.app = app
        self.setup_routes()

    def setup_routes(self):
        @self.app.route('/chat', methods=['GET'])
        def chat():
            return "Chat route is working!"