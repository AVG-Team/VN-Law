import 'package:get_it/get_it.dart';
import '../../data/datasources/remote/api_service.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_user.dart';
import '../../presentation/blocs/user/user_bloc.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      apiService: getIt(),
    ),
  );

  // Use Cases
  getIt.registerFactory(() => GetUser(getIt()));

  // Blocs
  getIt.registerFactory(
        () => UserBloc(getIt()),
  );
}