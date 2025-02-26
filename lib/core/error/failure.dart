abstract class Failure {
  final String message;

  Failure(this.message);
}

class CreateFailure extends Failure {
  CreateFailure() : super('Create Failure');
}

class JoinFailure extends Failure {
  JoinFailure() : super('Join Failure');
}

class FinishFailure extends Failure {
  FinishFailure() : super('Finish Failure');
}
