// core/dependency_injection.dart
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Core services
import '../core/services/storage_service.dart';

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

// Books feature imports
import '../features/writenBook/data/datasources/books_api_service.dart';
import '../features/writenBook/data/repositories/books_repository_impl.dart';
import '../features/writenBook/domain/repositories/books_repository.dart';
import '../features/writenBook/domain/usecases/books_usecases.dart';
import '../features/writenBook/presentation/cubit/books_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External dependencies
  sl.registerLazySingleton(() => Dio());

  // Core services
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl());

  // Register feature
  _initRegisterFeature();
  
  // Login feature
  _initLoginFeature();
  
  // Books feature
  _initBooksFeature();
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
  sl.registerFactory(() => LoginCubit(
    loginUseCase: sl(),
    storageService: sl(),
  ));
}

void _initBooksFeature() {
  // Data sources
  sl.registerLazySingleton<BooksApiService>(
    () => BooksApiServiceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<BooksRepository>(
    () => BooksRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserBooksUseCase(sl()));
  sl.registerLazySingleton(() => CreateBookUseCase(sl()));
  sl.registerLazySingleton(() => GetAllGenresUseCase(sl()));
  sl.registerLazySingleton(() => CreateGenreUseCase(sl()));

  // Cubits
  sl.registerFactory(() => BooksCubit(
    getUserBooksUseCase: sl(),
    createBookUseCase: sl(),
    getAllGenresUseCase: sl(),
    createGenreUseCase: sl(),
    storageService: sl(),
  ));
}