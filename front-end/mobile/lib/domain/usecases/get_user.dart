import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUser {
  final UserRepository _repository;

  GetUser(this._repository);

  Future<User> call(String userId) async {
    // Có thể thêm validation hoặc logic xử lý khác
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty');
    }
    return await _repository.getUserById(userId);
  }
}