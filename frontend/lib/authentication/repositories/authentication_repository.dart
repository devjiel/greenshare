
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenshare/authentication/repositories/models/auth_user_entity_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthenticationRepository {

  Stream<AuthUserEntityModel> get user;

  Future<void> logout();

  Future<void> loginWithEmailAndPassword({required String email, required String password});

}

@LazySingleton(as: AuthenticationRepository)
class FirebaseAuthenticationRepository extends AuthenticationRepository {

  FirebaseAuthenticationRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<AuthUserEntityModel> get user => _firebaseAuth.authStateChanges().map((user) {
    return user == null
        ? AuthUserEntityModel.empty
        : AuthUserEntityModel(id: user.uid, email: user.email, name: user.displayName);
  });

  @override
  Future<void> loginWithEmailAndPassword({required String email, required String password}) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password); // TODO : handle errors
  }

  @override
  Future<void> logout() {
    return _firebaseAuth.signOut(); // TODO : handle errors
  }

}
