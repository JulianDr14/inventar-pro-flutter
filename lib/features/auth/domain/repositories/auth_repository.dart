import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';
import 'package:intentary_pro/features/auth/domain/entities/user.dart';


abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
}
