import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Runs the federated (Google / Apple) sign-in flows and exchanges their
/// credentials with Firebase Auth.
///
/// Kept separate from `FirebaseAuthRepositoryImpl` so the repository stays
/// free of platform-flow branching:
///
/// - **Google** — native flow via `google_sign_in` on mobile/desktop,
///   browser popup via Firebase on web.
/// - **Apple** — Firebase's built-in [AppleAuthProvider]
///   (`signInWithProvider` natively, popup on web), which handles the
///   nonce exchange internally — no extra package needed.
///
/// Errors propagate to the repository, which maps them via
/// `mapAuthError`; this class never returns [Result] itself.
class FirebaseFederatedSignIn {
  /// Creates the helper.
  ///
  /// [auth] and [googleSignIn] default to their singletons; inject fakes
  /// in tests. See [googleServerClientId] for Android ID-token setup.
  FirebaseFederatedSignIn({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    this.googleServerClientId,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// The OAuth *web* client ID from the Firebase console, required on
  /// Android for Google sign-in to return the ID token Firebase needs.
  ///
  /// Find it under Firebase console → Authentication → Sign-in method →
  /// Google → Web SDK configuration. Not needed on iOS/macOS (configured
  /// via the plist) or web (popup flow). See docs/setup/FIREBASE_SETUP.md.
  final String? googleServerClientId;

  bool _googleInitialized = false;

  /// Signs in with Google and returns the Firebase [UserCredential].
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) return _auth.signInWithPopup(GoogleAuthProvider());

    if (!_googleInitialized) {
      await _googleSignIn.initialize(serverClientId: googleServerClientId);
      _googleInitialized = true;
    }
    final GoogleSignInAccount account = await _googleSignIn.authenticate();
    final String? idToken = account.authentication.idToken;
    if (idToken == null) {
      throw const AppException(
        message:
            'Google sign-in did not return an ID token. On Android, '
            'set googleServerClientId (see docs/setup/FIREBASE_SETUP.md).',
        code: 'auth/missing-google-id-token',
      );
    }
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  /// Signs in with Apple and returns the Firebase [UserCredential].
  Future<UserCredential> signInWithApple() async {
    final AppleAuthProvider provider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');
    if (kIsWeb) return _auth.signInWithPopup(provider);
    return _auth.signInWithProvider(provider);
  }

  /// Signs out of the provider-side Google session (if one was started)
  /// so the next sign-in shows the account picker again.
  Future<void> signOutProviders() async {
    if (_googleInitialized) await _googleSignIn.signOut();
  }
}
