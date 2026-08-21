class DomainException implements Exception {
  DomainException({this.message =  'An error occurred'});

  final String message;
  @override
  String toString() {
    return message;
  }
}