import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit({required this.registerUseCase}) : super(const RegisterInitial());

  // Campos del formulario
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  // Getters para acceder a los valores
  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  // Métodos para actualizar los campos
  void updateUsername(String value) {
    _username = value;
    _validateFields();
  }

  void updateEmail(String value) {
    _email = value;
    _validateFields();
  }

  void updatePassword(String value) {
    _password = value;
    _validateFields();
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    _validateFields();
  }

  // Validación en tiempo real
  void _validateFields() {
    String? usernameError;
    String? emailError;
    String? passwordError;
    String? confirmPasswordError;

    // Validar username
    if (_username.isNotEmpty && _username.trim().length < 3) {
      usernameError = 'El usuario debe tener al menos 3 caracteres';
    }

    // Validar email
    if (_email.isNotEmpty && !_isValidEmail(_email)) {
      emailError = 'Correo electrónico inválido';
    }

    // Validar password
    if (_password.isNotEmpty && _password.length < 4) {
      passwordError = 'La contraseña debe tener al menos 4 caracteres';
    }

    // Validar confirmPassword
    if (_confirmPassword.isNotEmpty && _password != _confirmPassword) {
      confirmPasswordError = 'Las contraseñas no coinciden';
    }

    // Emitir estado de validación solo si hay errores
    if (usernameError != null || emailError != null || 
        passwordError != null || confirmPasswordError != null) {
      emit(RegisterValidationError(
        usernameError: usernameError,
        emailError: emailError,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
      ));
    } else if (state is RegisterValidationError) {
      // Si no hay errores y el estado anterior era de error, volver a inicial
      emit(const RegisterInitial());
    }
  }

  // Método principal para registrar usuario
  Future<void> registerUser() async {
    if (!_canSubmit()) {
      return;
    }

    emit(const RegisterLoading());

    try {
      final user = await registerUseCase.call(
        username: _username,
        email: _email,
        password: _password,
        confirmPassword: _confirmPassword,
      );

      emit(RegisterSuccess(user: user));
    } catch (e) {
      emit(RegisterError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Verificar si se puede enviar el formulario
  bool _canSubmit() {
    return _username.trim().isNotEmpty &&
           _email.trim().isNotEmpty &&
           _password.isNotEmpty &&
           _confirmPassword.isNotEmpty &&
           _isValidEmail(_email) &&
           _password.length >= 4 &&
           _password == _confirmPassword;
  }

  // Validación de email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Limpiar formulario
  void clearForm() {
    _username = '';
    _email = '';
    _password = '';
    _confirmPassword = '';
    emit(const RegisterInitial());
  }

  // Resetear a estado inicial
  void resetToInitial() {
    emit(const RegisterInitial());
  }
}