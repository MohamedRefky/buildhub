// Clean Architecture: Documents — Data auth manager.
// Ports: FirebaseAuthManager.kt — Google Sign-In (silent + interactive),
// permanent-login prefs, users/{uid} profile sync and demo profiles.
// All Firebase calls are guarded: without Firebase.initializeApp they
// report an error state instead of crashing.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/firestore_paths.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final String roleAr;
  final String roleEn;
  final String organization;
  final String licenseNumber;
  final String phone;
  final String joinedDateStr;
  final bool isAuthenticated;
  final bool isAnonymous;
  const UserProfile({
    required this.uid, required this.displayName, required this.email,
    this.photoUrl = '', this.roleAr = '', this.roleEn = '',
    this.organization = '', this.licenseNumber = '', this.phone = '',
    this.joinedDateStr = '', this.isAuthenticated = false,
    this.isAnonymous = false,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid, 'email': email, 'displayName': displayName,
        'roleEn': roleEn, 'roleAr': roleAr, 'organization': organization,
        'licenseNumber': licenseNumber, 'phone': phone,
        'lastActive': DateTime.now().toIso8601String(),
      };
}

sealed class AuthUiState {
  const AuthUiState();
}

class AuthIdle extends AuthUiState {
  const AuthIdle();
}

class AuthLoading extends AuthUiState {
  const AuthLoading();
}

class AuthSuccess extends AuthUiState {
  final UserProfile profile;
  final String messageAr;
  final String messageEn;
  const AuthSuccess(this.profile,
      {required this.messageAr, required this.messageEn});
}

class AuthError extends AuthUiState {
  final String messageAr;
  final String messageEn;
  const AuthError({required this.messageAr, required this.messageEn});
}

class AuthManager extends ChangeNotifier {
  static const _prefsKey = 'stay_logged_in_permanently';
  final GoogleSignIn _google = GoogleSignIn(scopes: ['email', 'profile']);

  UserProfile? currentUser;
  AuthUiState authUiState = const AuthIdle();

  static const demoProfiles = [
    UserProfile(uid: 'eng-abdelfattah-01', displayName: 'م. عبد الفتاح',
        email: 'demo.pm@orionb.ae', roleAr: 'مدير مشروع',
        roleEn: 'Project Manager', organization: 'OrionB'),
    UserProfile(uid: 'eng-tariq-02', displayName: 'م. طارق',
        email: 'demo.site@orionb.ae', roleAr: 'مهندس موقع',
        roleEn: 'Site Engineer', organization: 'OrionB'),
    UserProfile(uid: 'cons-keo-03', displayName: 'KEO Consultant',
        email: 'demo.cons@orionb.ae', roleAr: 'استشاري',
        roleEn: 'Consultant', organization: 'KEO'),
  ];

  Future<void> initialize() async {
    try {
      final silent = await _google.signInSilently();
      if (silent != null) _applyGoogleAccount(silent);
    } catch (_) {}
  }

  Future<bool> trySilentSignIn() async {
    try {
      final account = await _google.signInSilently();
      if (account == null) return false;
      _applyGoogleAccount(account);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> signInWithGoogle({bool stayLoggedInPermanently = false}) async {
    authUiState = const AuthLoading();
    notifyListeners();
    try {
      var account = await _google.signInSilently();
      account ??= await _google.signIn();
      if (account == null) {
        authUiState = const AuthError(
            messageAr: 'تم إلغاء تسجيل الدخول',
            messageEn: 'Sign-in cancelled');
        notifyListeners();
        return;
      }
      final googleAuth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = result.user;
      final profile = UserProfile(
        uid: user?.uid ?? account.id,
        displayName: account.displayName ?? '',
        email: account.email,
        photoUrl: account.photoUrl ?? '',
        joinedDateStr: DateTime.now().toIso8601String().substring(0, 10),
        isAuthenticated: true,
      );
      currentUser = profile;
      await setPermanentLoginEnabled(stayLoggedInPermanently);
      await saveProfileToFirestore(profile);
      authUiState = AuthSuccess(profile,
          messageAr: 'تم تسجيل الدخول بنجاح',
          messageEn: 'Signed in successfully');
    } catch (_) {
      authUiState = const AuthError(
          messageAr: 'تعذر تسجيل الدخول — تحقق من إعداد Firebase',
          messageEn: 'Sign-in failed — check Firebase setup');
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _google.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    currentUser = null;
    authUiState = const AuthIdle();
    notifyListeners();
  }

  Future<bool> isPermanentLoginEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  Future<void> setPermanentLoginEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }

  void switchToDemoProfile(int index) {
    if (index < 0 || index >= demoProfiles.length) return;
    currentUser = demoProfiles[index];
    authUiState = AuthSuccess(currentUser!,
        messageAr: 'تم التبديل للملف التجريبي',
        messageEn: 'Switched to demo profile');
    notifyListeners();
  }

  void resetAuthState() {
    currentUser = null;
    authUiState = const AuthIdle();
    notifyListeners();
  }

  Future<void> saveProfileToFirestore(UserProfile profile) async {
    try {
      await FirebaseFirestore.instance
          .doc(FirestorePaths.userProfile(profile.uid))
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (_) {}
  }

  void _applyGoogleAccount(GoogleSignInAccount account) {
    currentUser = UserProfile(
      uid: account.id,
      displayName: account.displayName ?? '',
      email: account.email,
      photoUrl: account.photoUrl ?? '',
      isAuthenticated: true,
    );
    notifyListeners();
  }
}
