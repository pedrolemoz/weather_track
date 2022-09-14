class HttpException implements Exception {
  final String? reason;

  const HttpException({this.reason});
}
