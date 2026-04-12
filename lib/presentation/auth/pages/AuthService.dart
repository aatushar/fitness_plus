import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up
  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }
  }

  // Login
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e.code);
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Error Messages বাংলায়
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'এই email ইতিমধ্যে ব্যবহৃত হচ্ছে';
      case 'invalid-email':
        return 'Email address সঠিক নয়';
      case 'weak-password':
        return 'Password আরো শক্তিশালী করো';
      case 'user-not-found':
        return 'এই email দিয়ে কোনো account নেই';
      case 'wrong-password':
        return 'Password ভুল হয়েছে';
      case 'too-many-requests':
        return 'অনেকবার চেষ্টা করা হয়েছে, কিছুক্ষণ পর try করো';
      default:
        return 'কিছু একটা সমস্যা হয়েছে, আবার try করো';
    }
  }
}