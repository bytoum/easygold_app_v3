part of 'rest_client.dart';

@RestApi()
abstract class AuthClient {
  @factoryMethod
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;
}
