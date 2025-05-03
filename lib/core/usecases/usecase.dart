import 'package:dartz/dartz.dart';
import 'package:intentary_pro/core/error/failures.dart';

/// Interfaz base para todos los casos de uso (UseCases) en la capa de dominio.
/// Retorna un Either<Failure, Type>, donde Failure representa un error
/// y Type el resultado exitoso.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
