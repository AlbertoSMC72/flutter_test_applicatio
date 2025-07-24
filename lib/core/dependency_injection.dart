// core/dependency_injection.dart
import 'package:flutter_application_1/core/consts/api_urls.dart';
import 'package:flutter_application_1/features/profile/data/datasourcers/profile_api_service.dart';
import 'package:flutter_application_1/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_application_1/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_application_1/features/profile/domain/usecases/profile_usecases.dart';
import 'package:flutter_application_1/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// Core services
import '../core/services/storage_service.dart';
import '../core/services/firebase_service.dart';
import '../core/services/download_service.dart';

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
import '../features/writenBook/domain/usecases/books_usecases.dart' as writen_book_usecases;
import '../features/writenBook/presentation/cubit/books_cubit.dart';

// Home feature imports
import '../features/home/data/datasources/home_api_service.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_all_books_usecase.dart';
import '../features/home/presentation/cubit/home_cubit.dart';

// Content Chapter feature imports
import '../features/contentChapter/data/datasources/chapter_api_service.dart';
import '../features/contentChapter/data/repositories/chapter_repository_impl.dart';
import '../features/contentChapter/domain/repositories/chapter_repository.dart';
import '../features/contentChapter/domain/usecases/chapter_usecases.dart';
import '../features/contentChapter/presentation/cubit/chapter_cubit.dart';

// Fav Books feature imports
import '../features/favBooks/data/datasources/fav_books_api_service.dart';
import '../features/favBooks/data/repositories/fav_books_repository_impl.dart';
import '../features/favBooks/domain/repositories/fav_books_repository.dart';
import '../features/favBooks/domain/usecases/fav_books_usecases.dart' as fav_books_usecases;
import '../features/favBooks/presentation/cubit/fav_books_cubit.dart';

// Book Likes feature imports
import '../features/book/data/datasources/book_likes_api_service.dart';
import '../features/book/data/repositories/book_likes_repository_impl.dart';
import '../features/book/domain/repositories/book_likes_repository.dart';
import '../features/book/domain/usecases/book_likes_usecases.dart' as book_likes_usecases;
import '../features/book/presentation/cubit/book_likes_cubit.dart';

// Book Detail feature imports
import '../features/book/data/datasources/book_detail_api_service.dart';
import '../features/book/data/repositories/book_detail_repository_impl.dart';
import '../features/book/domain/repositories/book_detail_repository.dart';
import '../features/book/domain/usecases/book_detail_usecases.dart' as book_detail_usecases;
import '../features/book/presentation/cubit/book_detail_cubit.dart';

// Downloaded Books feature imports
import '../features/downloadedBooks/data/repositories/downloaded_books_repository_impl.dart';
import '../features/downloadedBooks/domain/repositories/downloaded_books_repository.dart';
import '../features/downloadedBooks/domain/usecases/get_downloaded_books_usecase.dart';
import '../features/downloadedBooks/presentation/cubit/downloaded_books_cubit.dart';
import '../features/downloadedBooks/data/repositories/downloaded_chapters_repository_impl.dart';
import '../features/downloadedBooks/domain/repositories/downloaded_chapters_repository.dart';
import '../features/downloadedBooks/domain/usecases/get_downloaded_chapters_usecase.dart';
import '../features/downloadedBooks/presentation/cubit/downloaded_chapters_cubit.dart';

// Search Books feature
import '../features/search/data/datasources/book_search_api_service.dart';
import '../features/search/data/repositories/book_search_repository_impl.dart';
import '../features/search/domain/repositories/book_search_repository.dart';
import '../features/search/domain/usecases/search_books_usecase.dart';
import '../features/search/presentation/cubit/book_search_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<Dio>(() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.apiUrlAuth,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
    logPrint: (log) => print('[LOGIN_DIO] $log'),
  ));
  return dio;
}, instanceName: 'authDio');

sl.registerLazySingleton<Dio>(() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.apiUrlBooks,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
    logPrint: (log) => print('[BOOKS_DIO] $log'),
  ));
  return dio;
}, instanceName: 'booksDio');

sl.registerLazySingleton<Dio>(() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.apiUrlProfile,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
    logPrint: (log) => print('[PROFILE_DIO] $log'),
  ));
  return dio;
}, instanceName: 'profileDio');

sl.registerLazySingleton<Dio>(() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.apiUrlFavorites,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
    logPrint: (log) => print('[FAVORITES_DIO] $log'),
  ));
  return dio;
}, instanceName: 'favoritesDio');

  // Core services
  sl.registerLazySingleton<StorageService>(() => StorageServiceImpl());
  sl.registerLazySingleton<DownloadService>(() => DownloadService());

  // Register feature
  _initRegisterFeature();
  
  // Login feature
  _initLoginFeature();
  
  // Books feature
  _initBooksFeature();
  
  // Home feature
  _initHomeFeature();

  // Profile feature
  _initProfileFeature();

  // Content Chapter feature
  _initContentChapterFeature();

  // Fav Books feature
  _initFavBooksFeature();

  // Book Likes feature
  _initBookLikesFeature();
  // Book Detail feature
  _initBookDetailFeature();

  // Downloaded Books feature
  _initDownloadedBooksFeature();

  // Search Books feature
  _initBookSearchFeature();

  // Inyectar el usecase de capítulo en DownloadService
  sl<DownloadService>().setChapterDetailUseCase(sl<GetChapterDetailUseCase>());
}

void _initRegisterFeature() {
  // Data sources
  sl.registerLazySingleton<RegisterApiService>(
    () => RegisterApiServiceImpl(dio: sl(instanceName: 'authDio')),
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
    () => LoginApiServiceImpl(dio: sl(instanceName: 'authDio')),
  );

  // Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Cubits
  sl.registerFactory(() => LoginCubit(loginUseCase: sl(), storageService: StorageServiceImpl(), firebaseService: FirebaseServiceImpl()));
}

void _initBooksFeature() {
  // Data sources
  sl.registerLazySingleton<BooksApiService>(
    () => BooksApiServiceImpl(dio: sl( instanceName: 'booksDio')),
  );

  // Repositories
  sl.registerLazySingleton<BooksRepository>(
    () => BooksRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => writen_book_usecases.GetUserBooksUseCase(sl()));
  sl.registerLazySingleton(() => writen_book_usecases.GetUserWritingBooksUseCase(sl()));
  sl.registerLazySingleton(() => writen_book_usecases.CreateBookUseCase(sl()));
  sl.registerLazySingleton(() => writen_book_usecases.UpdateBookUseCase(sl()));
  sl.registerLazySingleton(() => writen_book_usecases.PublishBookUseCase(sl()));
  sl.registerLazySingleton(() => writen_book_usecases.DeleteBookUseCase(sl()));
  sl.registerLazySingleton(() => writen_book_usecases.GetAllGenresUseCase(sl()));
  sl.registerLazySingleton(() => writen_book_usecases.CreateGenreUseCase(sl()));

  // Cubits
  sl.registerFactory(() => BooksCubit(
    getUserBooksUseCase: sl(),
    getUserWritingBooksUseCase: sl(),
    createBookUseCase: sl(),
    updateBookUseCase: sl(),
    publishBookUseCase: sl(),
    deleteBookUseCase: sl(),
    getAllGenresUseCase: sl(),
    createGenreUseCase: sl(),
    storageService: sl(),
  ));
}

void _initHomeFeature() {
  // Data sources
  sl.registerLazySingleton<HomeApiService>(
    () => HomeApiServiceImpl(dio: sl( instanceName: 'booksDio')),
  );

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllBooksUseCase(sl()));

  // Cubits
  sl.registerFactory(() => HomeCubit(getAllBooksUseCase: sl()));
}

void _initProfileFeature() {

  // Data sources
  sl.registerLazySingleton<ProfileApiService>(
    () => ProfileApiServiceImpl(dio: sl( instanceName: 'profileDio')),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfilePictureUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateBannerUseCase(repository: sl()));

  // Cubit
  sl.registerFactory(() => ProfileCubit(
    storageService: sl(),
    getProfileUseCase: sl(),
    getAllGenresUseCase: sl(),
    profileApiService: sl(),
    updateProfilePictureUseCase: sl(),
    updateBannerUseCase: sl()
  ));
}

void _initContentChapterFeature() {
  // Data sources
  sl.registerLazySingleton<ChapterApiService>(
    () => ChapterApiServiceImpl(dio: sl(instanceName: 'booksDio')),
  );

  // Repositories
  sl.registerLazySingleton<ChapterRepository>(
    () => ChapterRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetChapterDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddParagraphsUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddCommentUseCase(repository: sl()));

  // Cubit
  sl.registerFactory(() => ChapterCubit(
    getChapterDetailUseCase: sl(),
    addParagraphsUseCase: sl(),
    addCommentUseCase: sl(),
  ));
}

void _initFavBooksFeature() {
  // Data sources
  sl.registerLazySingleton<FavBooksApiService>(
    () => FavBooksApiServiceImpl(dio: sl(instanceName: 'favoritesDio')),
  );

  // Repositories
  sl.registerLazySingleton<FavBooksRepository>(
    () => FavBooksRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => fav_books_usecases.GetUserFavBooksUseCase(sl()));
  sl.registerLazySingleton(() => fav_books_usecases.GetBookLikeStatusUseCase(sl()));
  sl.registerLazySingleton(() => fav_books_usecases.ToggleBookLikeUseCase(sl()));
  sl.registerLazySingleton(() => fav_books_usecases.GetBookDetailsUseCase(sl()));

  // Cubits
  sl.registerFactory(() => FavBooksCubit(
    getUserFavBooksUseCase: sl(),
    getBookLikeStatusUseCase: sl(),
    toggleBookLikeUseCase: sl(),
  ));
}

void _initBookLikesFeature() {
  // Data source
  sl.registerLazySingleton<BookLikesApiService>(
    () => BookLikesApiService(sl<Dio>(instanceName: 'favoritesDio')),
  );
  // Repository
  sl.registerLazySingleton<BookLikesRepository>(
    () => BookLikesRepositoryImpl(sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => book_likes_usecases.GetBookLikeStatusUseCase(sl()));
  sl.registerLazySingleton(() => book_likes_usecases.ToggleBookLikeUseCase(sl()));
  sl.registerLazySingleton(() => book_likes_usecases.GetChaptersLikeStatusUseCase(sl()));
  sl.registerLazySingleton(() => book_likes_usecases.ToggleChapterLikeUseCase(sl()));
  // Cubit
  sl.registerFactory(() => BookLikesCubit(
    getBookLikeStatus: sl(),
    toggleBookLike: sl(),
    getChaptersLikeStatus: sl(),
    toggleChapterLike: sl(),
  ));
}

void _initBookDetailFeature() {
  // Data source
  sl.registerLazySingleton<BookDetailApiService>(
    () => BookDetailApiServiceImpl(),
  );
  // Repository
  sl.registerLazySingleton<BookDetailRepository>(
    () => BookDetailRepositoryImpl(apiService: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => book_detail_usecases.GetBookDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => book_detail_usecases.UpdateBookUseCase(repository: sl()));
  sl.registerLazySingleton(() => book_detail_usecases.PublishBookUseCase(repository: sl()));
  sl.registerLazySingleton(() => book_detail_usecases.AddChapterUseCase(repository: sl()));
  sl.registerLazySingleton(() => book_detail_usecases.ToggleChapterPublishUseCase(repository: sl()));
  sl.registerLazySingleton(() => book_detail_usecases.DeleteChapterUseCase(repository: sl()));
  sl.registerLazySingleton(() => book_detail_usecases.DeleteBookUseCase(repository: sl()));
  sl.registerLazySingleton(() => book_detail_usecases.AddCommentUseCase(repository: sl()));
  // Cubit
  sl.registerFactory(() => BookDetailCubit(
    getBookDetailUseCase: sl(),
    updateBookUseCase: sl(),
    publishBookUseCase: sl(),
    addChapterUseCase: sl(),
    toggleChapterPublishUseCase: sl(),
    deleteChapterUseCase: sl(),
    deleteBookUseCase: sl(),
    addCommentUseCase: sl(),
    storageService: sl(),
  ));
}

void _initDownloadedBooksFeature() {
  // Repositorio libros
  sl.registerLazySingleton<DownloadedBooksRepository>(
    () => DownloadedBooksRepositoryImpl(sl()),
  );
  // Usecase libros
  sl.registerLazySingleton(() => GetDownloadedBooksUseCase(sl()));
  // Cubit libros
  sl.registerFactory(() => DownloadedBooksCubit(sl()));

  // Repositorio capítulos
  sl.registerLazySingleton<DownloadedChaptersRepository>(
    () => DownloadedChaptersRepositoryImpl(sl()),
  );
  // Usecase capítulos
  sl.registerLazySingleton(() => GetDownloadedChaptersUseCase(sl()));
  // Cubit capítulos
  sl.registerFactory(() => DownloadedChaptersCubit(sl()));
}

void _initBookSearchFeature() {
  // Data source
  sl.registerLazySingleton<BookSearchApiService>(() => BookSearchApiService());
  // Repository
  sl.registerLazySingleton<BookSearchRepository>(() => BookSearchRepositoryImpl(sl()));
  // Usecase
  sl.registerLazySingleton(() => SearchBooksUseCase(sl()));
  // Cubit
  sl.registerFactory(() => BookSearchCubit(searchBooksUseCase: sl()));
}
