import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final UserEntity user;
  final String message;

  const RegisterSuccess({
    required this.user,
    this.message = 'Usuario registrado exitosamente',
  });

  @override
  List<Object?> get props => [user, message];
}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estados adicionales para validación en tiempo real
class RegisterValidationError extends RegisterState {
  final String? usernameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;

  const RegisterValidationError({
    this.usernameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
  });

  @override
  List<Object?> get props => [
    usernameError,
    emailError,
    passwordError,
    confirmPasswordError,
  ];

  bool get hasErrors =>
      usernameError != null ||
      emailError != null ||
      passwordError != null ||
      confirmPasswordError != null;
}