import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user.dart' as app_user;

abstract class FirebaseAuthDataSource {
  // Define methods for authentication
  Future<app_user.User> signInWithEmail(String email, String password);
  Future<app_user.User> signUp(
    String email,
    String password,
    String name,
    String userType,
  );
  Future<void> signOut();
  bool isSignedIn();
  String getCurrentUserId();
  Future<app_user.User> getCurrentUser();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthDataSourceImpl({required this.firebaseAuth});

  @override
  String getCurrentUserId() {
    return firebaseAuth.currentUser?.uid ?? '';
  }

  @override
  bool isSignedIn() {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<app_user.User> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    return app_user.User(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      userType: '', // This would typically come from a user profile database
    );
  }

  @override
  Future<app_user.User> signInWithEmail(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw Exception('Authentication failed');
    }

    return app_user.User(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      userType: '', // This would typically come from a user profile database
    );
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<app_user.User> signUp(
    String email,
    String password,
    String name,
    String userType,
  ) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw Exception('Registration failed');
    }

    // Update user profile
    await user.updateDisplayName(name);

    return app_user.User(
      id: user.uid,
      email: email,
      name: name,
      userType: userType,
    );
  }
}
