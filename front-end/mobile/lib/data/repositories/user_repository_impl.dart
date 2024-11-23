import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/api_service.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<User> getUserById(String id) async {
    try {
      final response = await _apiService.get('/users/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user');
    }
  }

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final response = await _apiService.get('/users');
      return (response.data as List)
          .map((userData) => UserModel.fromJson(userData))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users');
    }
  }

  @override
  Future<User> createUser(User user) async {
    try {
      final response = await _apiService.post('/users', user);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user');
    }
  }

  @override
  Future<User> updateUser(User user) async {
    try {
      final response = await _apiService.put('/users/${user.id}', user);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user');
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await _apiService.delete('/users/$id');
    } catch (e) {
      throw Exception('Failed to delete user');
    }
  }
}