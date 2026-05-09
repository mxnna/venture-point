import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInWithEmailRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpWithEmailRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthSignInWithGoogleRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthSendPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthSendPasswordResetRequested(this.email);

  @override
  List<Object> get props => [email];
}
