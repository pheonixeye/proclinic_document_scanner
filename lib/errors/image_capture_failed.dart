class ImageCaptreFailedException implements Exception {
  final String message;

  ImageCaptreFailedException(this.message);

  @override
  String toString() {
    return message;
  }
}
