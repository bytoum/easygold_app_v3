part of 'rest_client.dart';

@RestApi()
abstract class AuthClient {
  @factoryMethod
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST('/signin')
  Future<BaseResponse<LoginDataModel>> signInWithPassword(
    @Query('code') String? code,
    @Header('EasyGoldToken') String? fmcToken,
    @Header('IsAllowPushNotification') String isAllowPushNoti,
    @Header('UUID') String uuid,
    @Body() Map<String, dynamic> body,
  );
}
