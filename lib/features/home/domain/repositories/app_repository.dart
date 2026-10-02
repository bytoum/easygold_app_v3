import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/constants/enums/version_type.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';

abstract class AppRepository {
  Future<Either<Failure, BackgroundDetailModel?>> getBillBackground();
  Future<Either<Failure, bool>> checkVersionAvailable({
    required VersionAvailableType version,
  });
  Future<Either<Failure, VersionInfoModel?>> getVersionDetail();

  // Customer service
  Future<Either<Failure, TitleModel>> getTitle();
  Future<Either<Failure, ContactModel>> getContact();
  Future<Either<Failure, ContactModel>> getSocialMedia();
  Future<Either<Failure, LocationModel>> getLocation();
}
