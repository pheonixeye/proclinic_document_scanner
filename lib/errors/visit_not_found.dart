class VisitNotFoundException implements Exception {
  final String message;

  VisitNotFoundException(this.message);

  @override
  String toString() {
    return message;
  }
}
