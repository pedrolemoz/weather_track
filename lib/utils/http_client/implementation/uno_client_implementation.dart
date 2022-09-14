import 'package:uno/uno.dart';

import '../abstraction/http_client.dart';
import '../entities/http_response.dart';
import '../exceptions/http_exception.dart';

class UnoClientImplementation implements HttpClient {
  final Uno uno;

  const UnoClientImplementation(this.uno);

  @override
  Future<HttpResponse> get(String url) async {
    try {
      final response = await uno.get(url, responseType: ResponseType.plain);
      return HttpResponse(response.data, response.status);
    } catch (exception) {
      throw HttpException(reason: exception.toString());
    }
  }
}
