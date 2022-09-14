class HttpResponse {
  final String data;
  final int statusCode;

  const HttpResponse(this.data, this.statusCode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HttpResponse && other.data == data && other.statusCode == statusCode;
  }

  @override
  int get hashCode => data.hashCode ^ statusCode.hashCode;
}
