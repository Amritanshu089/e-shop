import 'package:equatable/equatable.dart';

enum AuthStatus {
  unauthenticated,
  loading,
  authenticated,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? userName;
  final String? userEmail;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unauthenticated,
    this.userName,
    this.userEmail,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userName,
    String? userEmail,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userName,
        userEmail,
        errorMessage,
      ];
}