import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:intentary_pro/features/auth/data/models/user_model.dart';
import 'package:intentary_pro/features/auth/domain/entities/user.dart';
import 'package:intentary_pro/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final UserModel? userModel = await localDataSource.getUser(username, password);
      if (userModel == null) {
        return Left(LocalFailure('Usuario o contraseña inválidos'));
      }
      return Right(User(id: userModel.id, username: userModel.username));
    } catch (e) {
      return Left(LocalFailure('Error en la base de datos'));
    }
  }
}
