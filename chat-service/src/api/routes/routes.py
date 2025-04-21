# File: src/api/routes/todo_routes.py
from flask import Blueprint, request, jsonify
from src.services.todo_service import TodoService

# Khởi tạo Blueprint cho to-do
todo_bp = Blueprint('todo', __name__, url_prefix='/todos')

# Khởi tạo service
todo_service = TodoService()

# GET /todos: Lấy tất cả to-do
@todo_bp.route('/', methods=['GET'])
def get_todos():
    try:
        todos = todo_service.get_all()
        return jsonify(todos), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# POST /todos: Tạo to-do mới
@todo_bp.route('/', methods=['POST'])
def create_todo():
    try:
        data = request.get_json()
        if not data or 'title' not in data:
            return jsonify({"error": "Title is required"}), 400
        
        todo_id = todo_service.create(
            title=data['title'],
            description=data.get('description', '')
        )
        return jsonify({"id": todo_id, "message": "Todo created successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# GET /todos/<id>: Lấy to-do theo ID
@todo_bp.route('/<int:todo_id>', methods=['GET'])
def get_todo(todo_id):
    try:
        todo = todo_service.get_by_id(todo_id)
        if not todo:
            return jsonify({"error": "Todo not found"}), 404
        return jsonify(todo), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# PUT /todos/<id>: Cập nhật to-do
@todo_bp.route('/<int:todo_id>', methods=['PUT'])
def update_todo(todo_id):
    try:
        data = request.get_json()
        if not data or 'title' not in data:
            return jsonify({"error": "Title is required"}), 400
        
        success = todo_service.update(
            todo_id=todo_id,
            title=data['title'],
            description=data.get('description', ''),
            completed=data.get('completed', False)
        )
        if not success:
            return jsonify({"error": "Todo not found"}), 404
        return jsonify({"message": "Todo updated successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# DELETE /todos/<id>: Xóa to-do
@todo_bp.route('/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    try:
        success = todo_service.delete(todo_id)
        if not success:
            return jsonify({"error": "Todo not found"}), 404
        return jsonify({"message": "Todo deleted successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500