abstract class Failure {
  final String message;

  Failure(this.message);
}

class CreateFailure extends Failure {
  CreateFailure(super.message);
}

class JoinFailure extends Failure {
  JoinFailure() : super('Join Failure');
}

class FinishFailure extends Failure {
  FinishFailure() : super('Finish Failure');
}

class StartFailure extends Failure {
  StartFailure() : super('Start Failure');
}

class ErrorFailure extends Failure {
  ErrorFailure() : super('Ups! algo salió mal');
}
