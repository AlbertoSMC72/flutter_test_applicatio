import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/firebase_service.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final StorageService storageService;
  final FirebaseService firebaseService;

  LoginCubit({
    required this.loginUseCase,
    required this.storageService,
    required this.firebaseService,
  }) : super(const LoginInitial());

  // Campos del formulario
  String _email = '';
  String _password = '';

  // Getters para acceder a los valores
  String get email => _email;
  String get password => _password;

  // Métodos para actualizar los campos
  void updateEmail(String value) {
    _email = value;
    _validateFields();
  }

  void updatePassword(String value) {
    _password = value;
    _validateFields();
  }

  // Validación en tiempo real
  void _validateFields() {
    String? emailError;
    String? passwordError;

    // Validar email
    if (_email.isNotEmpty && !_isValidEmail(_email)) {
      emailError = 'Correo electrónico inválido';
    }

    // Validar password
    if (_password.isNotEmpty && _password.length < 4) {
      passwordError = 'La contraseña debe tener al menos 4 caracteres';
    }

    // Emitir estado de validación solo si hay errores
    if (emailError != null || passwordError != null) {
      emit(LoginValidationError(
        emailError: emailError,
        passwordError: passwordError,
      ));
    } else if (state is LoginValidationError) {
      emit(const LoginInitial());
    }
  }

  // Método principal para hacer login (ACTUALIZADO)
  Future<void> loginUser() async {
    if (!_canSubmit()) {
      return;
    }

    emit(const LoginLoading());

    try {
      // Obtener Firebase token
      String? firebaseToken = await firebaseService.getFirebaseToken();
      print('[DEBUG_LOGIN_CUBIT] Firebase token obtenido: ${firebaseToken != null}');

      // Realizar login
      final user = await loginUseCase.call(
        email: _email,
        password: _password,
        firebaseToken: firebaseToken, // NUEVO
      );

      // Guardar datos en storage
      await storageService.saveUserData(
        userId: user.id?.toString() ?? '',
        username: user.username ?? '',
        email: _email,
        token: user.token,
        firebaseToken: firebaseToken, // NUEVO
      );

      print('[DEBUG_LOGIN_CUBIT] Datos guardados - userId: ${user.id}, username: ${user.username}');
      
      // Mostrar información sobre Firebase token si está disponible
      if (user.firebaseTokenSaved != null) {
        print('[DEBUG_LOGIN_CUBIT] Firebase token guardado: ${user.firebaseTokenSaved}');
        print('[DEBUG_LOGIN_CUBIT] Mensaje: ${user.notificationMessage}');
      }

      emit(LoginSuccess(user: user));
    } catch (e) {
      print('[DEBUG_LOGIN_CUBIT] Error en login: $e');
      emit(LoginError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Método para solicitar permisos de notificaciones
  Future<void> requestNotificationPermissions() async {
    try {
      await firebaseService.requestPermission();
      await firebaseService.setupTokenRefreshListener();
    } catch (e) {
      print('[DEBUG_LOGIN_CUBIT] Error configurando Firebase: $e');
    }
  }

  // Verificar si se puede enviar el formulario
  bool _canSubmit() {
    return _email.trim().isNotEmpty &&
           _password.isNotEmpty &&
           _isValidEmail(_email) &&
           _password.length >= 4;
  }

  // Validación de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Limpiar formulario
  void clearForm() {
    _email = '';
    _password = '';
    emit(const LoginInitial());
  }

  // Resetear a estado inicial
  void resetToInitial() {
    emit(const LoginInitial());
  }
}