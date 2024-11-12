import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class IConfig {
  bool get useEmulator => false;
}

@Injectable(as: IConfig, env: [Environment.dev])
class DevConfig extends IConfig {

  @override
  bool get useEmulator => kDebugMode;

}

@Injectable(as: IConfig, env: [Environment.test])
class TestConfig extends DevConfig { }

@Injectable(as: IConfig, env: [Environment.prod])
class ProdConfig extends IConfig { }