abstract class CrashService {
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  });
  Future<void> log(String message);
  Future<void> setUserIdentifier(String identifier);
}
