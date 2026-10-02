import 'package:dartz/dartz.dart';
import 'package:easygold_app_v3/core/constants/enums/version_type.dart';
import 'package:easygold_app_v3/core/errors/exceptions.dart';
import 'package:easygold_app_v3/core/errors/failures.dart';
import 'package:easygold_app_v3/core/models/background_detail_model.dart';
import 'package:easygold_app_v3/core/models/contact_model.dart';
import 'package:easygold_app_v3/core/models/version_info_model.dart';
import 'package:easygold_app_v3/features/home/data/datasources/app_remote_datasource.dart';
import 'package:easygold_app_v3/features/home/domain/repositories/app_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppRepository)
class AppRepositoryImpl implements AppRepository {
  final AppRemoteDataSource _appRemoteDataSource;
  AppRepositoryImpl(this._appRemoteDataSource);

  @override
  Future<Either<Failure, bool>> checkVersionAvailable({
    required VersionAvailableType version,
  }) async {
    try {
      final result = await _appRemoteDataSource.checkVersionAvailable(
        version: version,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, BackgroundDetailModel?>> getBillBackground() async {
    try {
      final result = await _appRemoteDataSource.getBillBackground();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ContactModel>> getContact() async {
    try {
      final result = await _appRemoteDataSource.getContact();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LocationModel>> getLocation() async {
    try {
      final result = await _appRemoteDataSource.getLocation();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ContactModel>> getSocialMedia() async {
    try {
      final result = await _appRemoteDataSource.getSocialMedia();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TitleModel>> getTitle() async {
    try {
      final result = await _appRemoteDataSource.getTitle();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, VersionInfoModel?>> getVersionDetail() async {
    try {
      final result = await _appRemoteDataSource.getVersionDetail();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
