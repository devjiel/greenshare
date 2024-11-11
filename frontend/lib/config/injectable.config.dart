// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_database/firebase_database.dart' as _i345;
import 'package:get_it/get_it.dart' as _i174;
import 'package:greenshare/config/firebase/firebase_injectable_module.dart'
    as _i173;
import 'package:greenshare/config/specific_config.dart' as _i398;
import 'package:injectable/injectable.dart' as _i526;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseInjectableModule = _$FirebaseInjectableModule();
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

class _$FirebaseInjectableModule extends _i173.FirebaseInjectableModule {}
