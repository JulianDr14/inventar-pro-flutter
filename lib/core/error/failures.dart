abstract class Failure {
  final String message;
  Failure(this.message);
}

class LocalFailure extends Failure {
  LocalFailure(super.message);
}