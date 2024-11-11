import 'package:injectable/injectable.dart';

import '../business/services/firebase_service.dart';

@module
abstract class AppModule {

  // @preResolve
  // Future<FirebaseService> get fireService => FirebaseService.init();
}