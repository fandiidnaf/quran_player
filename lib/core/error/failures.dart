import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure from a remote server (non-2xx response).
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure due to no network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure when audio cannot be loaded or played.
class AudioFailure extends Failure {
  const AudioFailure(super.message);
}
