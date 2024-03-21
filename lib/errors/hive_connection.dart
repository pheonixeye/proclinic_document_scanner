class HiveConnectionException implements Exception {
  final String message;

  HiveConnectionException(this.message);

  @override
  String toString() {
    return message;
  }
}
