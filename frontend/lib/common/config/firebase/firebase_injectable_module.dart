import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenshare/common/business/services/firebase_service.dart';
import 'package:injectable/injectable.dart';
import '../injectable.dart';
import '../specific_config.dart';

@module
abstract class FirebaseInjectableModule {

  @preResolve
  Future<FirebaseService> get fireService => FirebaseService.init();

  @lazySingleton
  @Named('firebaseDatabase')
  FirebaseDatabase get firebaseDatabase {
    final database = FirebaseDatabase.instanceFor(app: Firebase.app());
    if (getIt<IConfig>().useEmulator) {
      database.useDatabaseEmulator('localhost', 9000);
    }
    return database;
  }

  @lazySingleton
  FirebaseAuth get firebaseAuth {
    final auth = FirebaseAuth.instanceFor(app: Firebase.app());
    if (getIt<IConfig>().useEmulator) {
      auth.useAuthEmulator('localhost', 9099);
    }
    return auth;
  }
}