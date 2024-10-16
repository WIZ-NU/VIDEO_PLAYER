import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save additional user information to the database
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('Users');
    Map<String, String> user = {
      'name': name,
      'email': email,
      'password': password,
    };
    await dbRef.child(userCredential.user!.uid).set(user);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
