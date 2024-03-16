class ConnectionSettingsException implements Exception {
  final String message;

  ConnectionSettingsException(this.message);

  @override
  String toString() {
    return message;
  }
}
