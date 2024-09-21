import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final String message;

  const Failures({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failures {
  const ServerFailure({String message = 'Server error occurred'})
      : super(message: message);
}

class NetworkFailure extends Failures {
  const NetworkFailure({String message = 'Network error occurred'})
      : super(message: message);
}

class CacheFailure extends Failures {
  const CacheFailure({String message = 'Cache error occurred'})
      : super(message: message);
}

class ValidationFailure extends Failures {
  const ValidationFailure({String message = 'Validation error occurred'})
      : super(message: message);
}

class UnauthorizedFailure extends Failures {
  const UnauthorizedFailure({String message = 'Unauthorized access'})
      : super(message: message);
}

class NotFoundFailure extends Failures {
  const NotFoundFailure({String message = 'Resource not found'})
      : super(message: message);
}
