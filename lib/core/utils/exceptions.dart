class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({required this.message, this.code, this.originalException});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException({String? message})
    : super(
        message: message ?? 'Network connection error',
        code: 'NETWORK_ERROR',
      );
}

class AuthException extends AppException {
  AuthException({String? message})
    : super(message: message ?? 'Authentication failed', code: 'AUTH_ERROR');
}

class LocationException extends AppException {
  LocationException({String? message})
    : super(message: message ?? 'Location error', code: 'LOCATION_ERROR');
}

class ServerException extends AppException {
  final int statusCode;

  ServerException({required this.statusCode, String? message})
    : super(
        message: message ?? 'Server error',
        code: 'SERVER_ERROR_$statusCode',
      );
}

class ValidationException extends AppException {
  ValidationException({String? message})
    : super(message: message ?? 'Validation error', code: 'VALIDATION_ERROR');
}

// Exception handler
String getErrorMessage(Exception e) {
  if (e is AppException) {
    return e.message;
  }
  return e.toString().replaceAll('Exception: ', '');
}
