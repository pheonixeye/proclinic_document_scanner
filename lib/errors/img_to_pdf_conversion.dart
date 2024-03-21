class ImageToPdfConversionException implements Exception {
  final String message;

  ImageToPdfConversionException(this.message);

  @override
  String toString() {
    return message;
  }
}
