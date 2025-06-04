import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Register feature imports
import '../features/register/data/datasources/register_api_service.dart';
import '../features/register/data/repositories/register_repository_impl.dart';
import '../features/register/domain/repositories/register_repository.dart';
import '../features/register/domain/usecases/register_usecase.dart';
import '../features/register/presentation/cubit/register_cubit.dart';

// Login feature imports
import '../features/login/data/datasources/login_api_service.dart';
import '../features/login/data/repositories/login_repository_impl.dart';
import '../features/login/domain/repositories/login_repository.dart';
import '../features/login/domain/usecases/login_usecase.dart';
import '../features/login/presentation/cubit/login_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton(() => Dio());

  // Register feature
  _initRegisterFeature();
  
  // Login feature
  _initLoginFeature();
}

void _initRegisterFeature() {
  // Data sources
  sl.registerLazySingleton<RegisterApiService>(
    () => RegisterApiServiceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Cubits
  sl.registerFactory(() => RegisterCubit(registerUseCase: sl()));
}

void _initLoginFeature() {
  // Data sources
  sl.registerLazySingleton<LoginApiService>(
    () => LoginApiServiceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Cubits
  sl.registerFactory(() => LoginCubit(loginUseCase: sl()));
}