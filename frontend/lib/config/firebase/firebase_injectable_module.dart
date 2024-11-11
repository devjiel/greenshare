import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import '../injectable.dart';
import '../specific_config.dart';

@module
abstract class FirebaseInjectableModule {

  @lazySingleton
  @Named('firebaseDatabase')
  FirebaseDatabase get firebaseDatabase => FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: getIt<IConfig>().databaseUrl);
}