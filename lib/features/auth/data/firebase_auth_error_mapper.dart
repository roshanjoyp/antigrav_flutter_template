import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Maps any error thrown during an auth operation into an [AppException].
///
/// Understands [FirebaseAuthException] and [GoogleSignInException];
/// anything else becomes a generic `auth/unknown` failure. Never throws.
///
/// Messages are user-presentable; the machine-readable code always has
/// the form `auth/<backend-code>`.
AppException mapAuthError(Object error, StackTrace stackTrace) {
  if (error is AppException) return error;
  if (error is FirebaseAuthException) {
    return _mapFirebaseAuthException(error, stackTrace);
  }
  if (error is GoogleSignInException) {
    return _mapGoogleSignInException(error, stackTrace);
  }
  return AppException(
    message: 'Unexpected authentication error. Please try again.',
    code: 'auth/unknown',
    originalError: error,
    stackTrace: stackTrace,
  );
}

/// Maps a [FirebaseAuthException] to an [AppException] with a
/// user-presentable message.
AppException _mapFirebaseAuthException(
  FirebaseAuthException error,
  StackTrace stackTrace,
) {
  final String message = switch (error.code) {
    'invalid-email' => 'The email address is badly formatted.',
    'user-disabled' => 'This account has been disabled.',
    'user-not-found' ||
    'wrong-password' ||
    'invalid-credential' ||
    'INVALID_LOGIN_CREDENTIALS' => 'Incorrect email or password.',
    'email-already-in-use' => 'An account already exists with this email.',
    'weak-password' => 'The password is too weak — use at least 6 characters.',
    'operation-not-allowed' =>
      'This sign-in method is not enabled in the Firebase console.',
    'too-many-requests' => 'Too many attempts. Please try again later.',
    'network-request-failed' =>
      'Network error. Check your connection and try again.',
    'requires-recent-login' => 'Please sign in again to complete this action.',
    'account-exists-with-different-credential' =>
      'An account already exists with this email using a different '
          'sign-in method.',
    'popup-closed-by-user' ||
    'cancelled-popup-request' ||
    'web-context-canceled' ||
    'user-cancelled' ||
    'canceled' => 'Sign-in was cancelled.',
    _ => 'Authentication failed. Please try again.',
  };
  return AppException(
    message: message,
    code: 'auth/${error.code}',
    originalError: error,
    stackTrace: stackTrace,
  );
}

/// Maps a [GoogleSignInException] (thrown by the native Google sign-in
/// flow) to an [AppException].
AppException _mapGoogleSignInException(
  GoogleSignInException error,
  StackTrace stackTrace,
) {
  final bool cancelled =
      error.code == GoogleSignInExceptionCode.canceled ||
      error.code == GoogleSignInExceptionCode.interrupted;
  return AppException(
    message: cancelled
        ? 'Sign-in was cancelled.'
        : 'Google sign-in failed. Please try again.',
    code: cancelled ? 'auth/cancelled' : 'auth/google-sign-in-failed',
    originalError: error,
    stackTrace: stackTrace,
  );
}
