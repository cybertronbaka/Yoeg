import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
      (FirebaseUser user)=>user?.uid,
  );

  Future<String> getCurrentUID() async{
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password, String name) async{
    final currentUser = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    //update the username
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
  //do stuffs
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    return currentUser.uid;
  }

  Future<String> signInWithEmailAndPassWord(String email, String password) async{
    return (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user.uid;
  }

  signOut(){
    return _firebaseAuth.signOut();
  }

  Future sendPasswordResetEmail(String email) async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

}

