import 'package:payment_tracking/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payment_tracking/models/app_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _dataService = DataService();
  final _firestoreService = FirestoreService();

  Stream<AppUser> get user {
    return _auth
      .authStateChanges()
      .map(_userFromFirebaseUser);
  }

  User? get currentUser {
    return _auth.currentUser;
  }

  Future<void> signUpWithEmail(email, password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    if (_auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;
      
      final user = <String, dynamic>{
        "uid": uid,
        "email": email,
        "resources": {},
        "_resources": {}
      };

      _firestoreService.insertUser(user);
    }
  }

  Future<void> signInWithEmail(email, password) async {
    await _auth.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }

  Future<void> signInWithGoogle(GoogleSignInAccount? googleAccount) async {
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleAccount?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    Map<String, dynamic> googleUser = {
      "displayName": googleAccount!.displayName,
      "email": googleAccount.email,
      "id": googleAccount.id,
      "photoUrl": googleAccount.photoUrl,
    };

    dynamic loggedInUserDocId = await _firestoreService.insertUser(googleUser);
  }


  logOut() { _auth.signOut(); }
}