class MongoDbConnectionException implements Exception {
  final String message;

  MongoDbConnectionException(this.message);

  @override
  String toString() {
    return message;
  }
}
