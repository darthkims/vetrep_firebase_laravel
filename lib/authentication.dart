import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //SIGN UP METHOD
  Future signUp({required String email, required String password, String? name, required String phoneNum}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access the user from the userCredential
      User? user = userCredential.user;

      if (user != null) {
        try {
          await user.updateDisplayName(name!);
          final docRef = firestore.collection('users').doc(user.uid);
          await docRef.set({
            'fullName': name,
            'uid': user.uid,
            'phoneNum': phoneNum,
          });
        } catch (e) {
          print("Error updating display name: $e");
          // Handle the error appropriately, e.g., inform the user
        }
      }


      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }


  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }

  String? getUserEmail() {
    return _auth.currentUser?.email;
  }
}