// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_database/firebase_database.dart' as _i345;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:greenshare/authentication/repositories/authentication_repository.dart'
    as _i763;
import 'package:greenshare/common/business/services/firebase_service.dart'
    as _i875;
import 'package:greenshare/common/config/firebase/firebase_injectable_module.dart'
    as _i752;
import 'package:greenshare/common/config/specific_config.dart' as _i632;
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart'
    as _i853;
import 'package:greenshare/file_upload/repositories/storage_repository.dart'
    as _i576;
import 'package:greenshare/file_upload/ui/blocs/available_files/available_files_bloc.dart'
    as _i306;
import 'package:greenshare/file_upload/ui/blocs/file_upload/file_upload_bloc.dart'
    as _i21;
import 'package:greenshare/user/repositories/users_repository.dart' as _i398;
import 'package:greenshare/user/ui/blocs/user_bloc.dart' as _i814;
import 'package:injectable/injectable.dart' as _i526;

const String _test = 'test';
const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseInjectableModule = _$FirebaseInjectableModule();
    await gh.factoryAsync<_i875.FirebaseService>(
      () => firebaseInjectableModule.fireService,
      preResolve: true,
    );
    gh.singleton<_i306.AvailableFilesBloc>(() => _i306.AvailableFilesBloc());
    gh.singleton<_i853.CarbonReductionBloc>(() => _i853.CarbonReductionBloc());
    gh.lazySingleton<_i59.FirebaseAuth>(
        () => firebaseInjectableModule.firebaseAuth);
    gh.lazySingleton<_i457.FirebaseStorage>(
        () => firebaseInjectableModule.firebaseStorage);
    gh.lazySingleton<_i345.FirebaseDatabase>(
      () => firebaseInjectableModule.firebaseDatabase,
      instanceName: 'firebaseDatabase',
    );
    gh.lazySingleton<_i576.StorageRepository>(
        () => _i576.FirebaseStorageRepository(gh<_i457.FirebaseStorage>()));
    gh.factory<_i632.IConfig>(
      () => _i632.TestConfig(),
      registerFor: {_test},
    );
    gh.factory<_i632.IConfig>(
      () => _i632.DevConfig(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i398.UsersRepository>(() => _i398.FirebaseUsersRepository(
        gh<_i345.FirebaseDatabase>(instanceName: 'firebaseDatabase')));
    gh.lazySingleton<_i763.AuthenticationRepository>(
        () => _i763.AuthenticationRepository(gh<_i59.FirebaseAuth>()));
    gh.factory<_i632.IConfig>(
      () => _i632.ProdConfig(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i21.FileUploadBloc>(
        () => _i21.FileUploadBloc(gh<_i576.StorageRepository>()));
    gh.lazySingleton<_i814.UserBloc>(
        () => _i814.UserBloc(userRepository: gh<_i398.UsersRepository>()));
    return this;
  }
}

class _$FirebaseInjectableModule extends _i752.FirebaseInjectableModule {}
