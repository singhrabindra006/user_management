part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  const RegisterEvent(this.name, this.email, this.password);
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent(this.email, this.password);
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  const ResetPasswordEvent(this.email);
}

class LogoutEvent extends AuthEvent {}

class LoadCurrentUserEvent extends AuthEvent {
  final String uid;
  const LoadCurrentUserEvent(this.uid);
}

class CompleteProfileEvent extends AuthEvent {
  final String name;
  final File imageFile;
  const CompleteProfileEvent(this.name, this.imageFile);

  @override
  List<Object> get props => [name, imageFile];
}
