class AppException implements Exception {
  const AppException(this.message);
  final String message;
  @override
  String toString() {
    return message;
  }
}

class AppSerializationException extends AppException {
  final String? objectName;
  final StackTrace trace;
  AppSerializationException({this.objectName, StackTrace? trace})
      : trace = trace ?? StackTrace.current,
        super("invalid_serialization_data");
}

class AppCryptoException extends AppException {
  const AppCryptoException(super.message);
}
