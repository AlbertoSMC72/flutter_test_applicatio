import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final StorageService storageService;

  LoginCubit({
    required this.loginUseCase,
    required this.storageService,
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
      // Si no hay errores y el estado anterior era de error, volver a inicial
      emit(const LoginInitial());
    }
  }

  // Método principal para hacer login
  Future<void> loginUser() async {
    if (!_canSubmit()) {
      return;
    }

    emit(const LoginLoading());

    try {
      final user = await loginUseCase.call(
        email: _email,
        password: _password,
      );

      // Guardar datos del usuario en storage
      await storageService.saveUserData(
        userId: user.id ?? '',
        username: user.username ?? '',
        email: user.email,
        token: user.token,
      );

      emit(LoginSuccess(user: user));
    } catch (e) {
      emit(LoginError(message: e.toString().replaceFirst('Exception: ', '')));
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