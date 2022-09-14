class NoInternetConnectionException implements Exception {
  const NoInternetConnectionException();

  @override
  String toString() => 'No internet connection avaliable';
}
