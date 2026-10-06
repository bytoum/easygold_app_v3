part of 'rest_client.dart';

@RestApi()
abstract class AppClient {
  @factoryMethod
  factory AppClient(Dio dio, {String? baseUrl}) = _AppClient;

  @GET('/version')
  Future<VersionModel?> getVersion({@Query('version') String? version});

  @GET('/info')
  Future<VersionInfoModel?> getVersionInfo();

  @GET('/bill-background/detail')
  Future<BackgroundDetailModel?> getBackgroundDetail();

  @GET('/customer-service/title')
  Future<TitleModel> getTitle();

  @GET('/customer-service/contact-info/69a001ea749939c4c103a246')
  Future<ContactModel> getContact();

  @GET('/customer-service/social-media/69a00298749939c4c103a24c')
  Future<ContactModel> getSocialMedia();

  @GET('/customer-service/location/699d6d28b5608cc67d18bc44')
  Future<LocationModel> getLocation();
}
