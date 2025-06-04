import 'package:equatable/equatable.dart';
import '../../domain/entities/login_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final LoginEntity user;
  final String message;

  const LoginSuccess({
    required this.user,
    this.message = 'Inicio de sesión exitoso',
  });

  @override
  List<Object?> get props => [user, message];
}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estados adicionales para validación en tiempo real
class LoginValidationError extends LoginState {
  final String? emailError;
  final String? passwordError;

  const LoginValidationError({
    this.emailError,
    this.passwordError,
  });

  @override
  List<Object?> get props => [emailError, passwordError];

  bool get hasErrors => emailError != null || passwordError != null;
}