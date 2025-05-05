import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/core/usecases/usecase.dart';
import 'package:intentary_pro/features/auth/domain/entities/user.dart';
import 'package:intentary_pro/features/auth/domain/repositories/auth_repository.dart';

/// Parámetros para el login
class LoginParams {
  final String username;
  final String password;
  LoginParams({required this.username, required this.password});
}

/// UseCase genérico
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.username, params.password);
  }
}
