part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, loaded, failure, resetState }

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final UserModel? user;
  final String? message;

  const AuthState({
    this.authStatus = AuthStatus.initial,
    this.user,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    UserModel? user,
    String? message,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [authStatus, user, message];
}
