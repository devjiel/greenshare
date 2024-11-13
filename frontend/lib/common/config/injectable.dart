import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injectable.config.dart';

GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies(String environment) async {
  if (environment == Environment.test) {
    getIt.allowReassignment = true;
  }
  await getIt.init(environment: environment);
}