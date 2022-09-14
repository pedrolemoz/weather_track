import '../entities/http_response.dart';

abstract class HttpClient {
  Future<HttpResponse> get(String url);
}
