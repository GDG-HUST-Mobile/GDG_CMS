sealed class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends CustomException {
  NetworkException(super.message);
}

class ServerException extends CustomException {
  ServerException(super.message);
}

class UnauthorizedException extends CustomException {
  UnauthorizedException() : super("Unauthorized access");
}

class ParsingException extends CustomException {
  ParsingException(super.message);
}

class UnknownException extends CustomException {
  UnknownException(super.message);
}
