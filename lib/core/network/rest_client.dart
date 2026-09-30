import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'rest_client.g.dart';

@RestApi(baseUrl: 'https://api.example.com') // Replace with your API base URL
abstract class RestClient {
  @factoryMethod
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  //TODO: Define your API endpoints here using Retrofit annotations
}