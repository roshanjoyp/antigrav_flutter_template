import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/features/auth/data/firebase_auth_error_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  final StackTrace trace = StackTrace.current;

  group('mapAuthError', () {
    test('maps FirebaseAuthException codes to friendly messages', () {
      final AppException e = mapAuthError(
        FirebaseAuthException(code: 'wrong-password'),
        trace,
      );
      expect(e.code, 'auth/wrong-password');
      expect(e.message, 'Incorrect email or password.');
    });

    test('maps email-already-in-use', () {
      final AppException e = mapAuthError(
        FirebaseAuthException(code: 'email-already-in-use'),
        trace,
      );
      expect(e.code, 'auth/email-already-in-use');
      expect(e.message, contains('already exists'));
    });

    test('unknown Firebase code falls back to a generic message', () {
      final AppException e = mapAuthError(
        FirebaseAuthException(code: 'some-new-code'),
        trace,
      );
      expect(e.code, 'auth/some-new-code');
      expect(e.message, 'Authentication failed. Please try again.');
    });

    test('maps cancelled Google sign-in to auth/cancelled', () {
      final AppException e = mapAuthError(
        const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
        trace,
      );
      expect(e.code, 'auth/cancelled');
      expect(e.message, 'Sign-in was cancelled.');
    });

    test('maps other Google sign-in failures', () {
      final AppException e = mapAuthError(
        const GoogleSignInException(
          code: GoogleSignInExceptionCode.clientConfigurationError,
        ),
        trace,
      );
      expect(e.code, 'auth/google-sign-in-failed');
    });

    test('passes an AppException through unchanged', () {
      const AppException original = AppException(
        message: 'custom',
        code: 'auth/custom',
      );
      expect(mapAuthError(original, trace), same(original));
    });

    test('wraps unknown errors as auth/unknown', () {
      final AppException e = mapAuthError(StateError('boom'), trace);
      expect(e.code, 'auth/unknown');
      expect(e.originalError, isA<StateError>());
      expect(e.stackTrace, same(trace));
    });
  });
}
