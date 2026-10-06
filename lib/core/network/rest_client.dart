import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/base_response.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/login_data_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:easygold_app_v3/core/models/version_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'rest_client.g.dart';
part 'app_client.dart';
part 'auth_client.dart';



@RestApi() // Replace with your API base URL
abstract class RestClient {
  @factoryMethod
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  //TODO: Define your API endpoints here using Retrofit annotations
}