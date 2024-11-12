import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable.config.dart';

GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies(String environment) {
  if (environment == Environment.test) {
    getIt.allowReassignment = true;
  }
  getIt.init(environment: environment);
}