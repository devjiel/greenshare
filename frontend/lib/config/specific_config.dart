import 'package:injectable/injectable.dart';

abstract class IConfig {
  String get databaseUrl => 'https://sophrology-default-rtdb.europe-west1.firebasedatabase.app/';
}

@Injectable(as: IConfig, env: [Environment.dev])
class DevConfig extends IConfig {

  @override
  String get databaseUrl => 'https://sophrology-default-rtdb.europe-west1.firebasedatabase.app/';

}

@Injectable(as: IConfig, env: [Environment.test])
class TestConfig extends DevConfig { }

@Injectable(as: IConfig, env: [Environment.prod])
class ProdConfig extends IConfig { }