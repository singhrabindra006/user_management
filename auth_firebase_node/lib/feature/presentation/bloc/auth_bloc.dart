import 'dart:io';
import 'package:auth_firebase_node/feature/domain/model/user_model.dart';
import 'package:auth_firebase_node/feature/domain/repo/auth_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo repo;

  AuthBloc(this.repo) : super(AuthState()) {
    on<RegisterEvent>(_register);
    on<LoginEvent>(_login);
    on<LogoutEvent>(_logout);
    on<ResetPasswordEvent>(_resetPassword);
    on<LoadCurrentUserEvent>(_loadUserEvent);
    on<CompleteProfileEvent>(_completeProfile);
  }

  Future<void> _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      final user = await repo.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          authStatus: AuthStatus.loaded,
          user: user,
          message: 'Registration successful',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      final user = await repo.login(event.email, event.password);
      emit(
        state.copyWith(
          authStatus: AuthStatus.loaded,
          user: user,
          message: 'Login successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      await repo.logout();
      emit(
        const AuthState(
          authStatus: AuthStatus.initial,
          message: 'Logged out Successfull!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _resetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      await repo.resetPassword(event.email);
      emit(
        state.copyWith(
          authStatus: AuthStatus.resetState,
          message: 'Password reset email sent!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _loadUserEvent(
    LoadCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      final user = await repo.getUser(event.uid);
      emit(
        state.copyWith(
          authStatus: AuthStatus.loaded,
          user: user,
          message: 'User loaded',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, message: e.toString()),
      );
    }
  }

  Future<void> _completeProfile(
    CompleteProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      final user = await repo.completeProfile(
        name: event.name,
        imageFile: event.imageFile,
      );
      emit(
        state.copyWith(
          authStatus: AuthStatus.loaded,
          user: user,
          message: 'Profile completed successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(authStatus: AuthStatus.failure, message: e.toString()),
      );
    }
  }
}
