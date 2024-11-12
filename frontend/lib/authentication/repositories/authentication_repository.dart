
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthenticationRepository {

  AuthenticationRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

}
