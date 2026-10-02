import 'package:dio/dio.dart';
import 'package:easygold_app_v3/core/constants/enums/version_type.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:easygold_app_v3/core/network/rest_client.dart';
import 'package:injectable/injectable.dart';

abstract class AppRemoteDataSource {
  Future<BackgroundDetailModel?> getBillBackground();
  Future<bool> checkVersionAvailable({required VersionAvailableType version});
  Future<VersionInfoModel?> getVersionDetail();
  // Customer service
  Future<TitleModel> getTitle();
  Future<ContactModel> getContact();
  Future<ContactModel> getSocialMedia();
  Future<LocationModel> getLocation();
}

@LazySingleton(as: AppRemoteDataSource)
class AppRemoteDataSourceImpl implements AppRemoteDataSource {
  final AppClient _appClient;
  AppRemoteDataSourceImpl(this._appClient);

  @override
  Future<bool> checkVersionAvailable({
    required VersionAvailableType version,
  }) async {
    try {
      final response = await _appClient.getVersion(version: version.name);
      if (response != null && response.isOpen == true) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? e.response?.statusMessage ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BackgroundDetailModel?> getBillBackground() async {
    try {
      final response = await _appClient.getBackgroundDetail();
      return response;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? e.response?.statusMessage ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ContactModel> getContact() async {
    try {
      final response = await _appClient.getContact();
      return response;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? e.response?.statusMessage ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LocationModel> getLocation() async {
    try {
      final response = await _appClient.getLocation();
      return response;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? e.response?.statusMessage ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ContactModel> getSocialMedia() async {
    try {
      final response = await _appClient.getSocialMedia();
      return response;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? e.response?.statusMessage ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TitleModel> getTitle() async {
    try {
      final response = await _appClient.getTitle();
      return response;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? e.response?.statusMessage ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<VersionInfoModel?> getVersionDetail() async {
    try {
      final response = await _appClient.getVersionInfo();
      return response;
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? e.response?.statusMessage ?? 'Unknown error',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
