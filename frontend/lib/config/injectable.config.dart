// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_database/firebase_database.dart' as _i345;
import 'package:get_it/get_it.dart' as _i174;
import 'package:greenshare/business/services/firebase_service.dart' as _i188;
import 'package:greenshare/config/app_injectable.dart' as _i748;
import 'package:greenshare/config/firebase/firebase_injectable_module.dart'
    as _i173;
import 'package:greenshare/config/specific_config.dart' as _i398;
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart'
    as _i853;
import 'package:greenshare/file_upload/ui/blocs/available_files_bloc.dart'
    as _i351;
import 'package:injectable/injectable.dart' as _i526;

const String _dev = 'dev';
const String _test = 'test';
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
    final appModule = _$AppModule();
    final firebaseInjectableModule = _$FirebaseInjectableModule();
    await gh.factoryAsync<_i188.FirebaseService>(
      () => appModule.fireService,
      preResolve: true,
    );
    gh.singleton<_i853.CarbonReductionBloc>(() => _i853.CarbonReductionBloc());
    gh.singleton<_i351.AvailableFilesBloc>(() => _i351.AvailableFilesBloc());
    gh.factory<_i398.IConfig>(
      () => _i398.DevConfig(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i345.FirebaseDatabase>(
      () => firebaseInjectableModule.firebaseDatabase,
      instanceName: 'firebaseDatabase',
    );
    gh.factory<_i398.IConfig>(
      () => _i398.TestConfig(),
      registerFor: {_test},
    );
    gh.factory<_i398.IConfig>(
      () => _i398.ProdConfig(),
      registerFor: {_prod},
    );
    return this;
  }
}

class _$AppModule extends _i748.AppModule {}

class _$FirebaseInjectableModule extends _i173.FirebaseInjectableModule {}
