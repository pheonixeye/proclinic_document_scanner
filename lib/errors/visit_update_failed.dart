class VisitUpdateFailedException implements Exception {
  final String message;

  VisitUpdateFailedException(this.message);

  @override
  String toString() {
    return message;
  }
}
