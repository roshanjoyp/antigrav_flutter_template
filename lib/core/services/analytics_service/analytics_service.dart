/// Contract for app-wide analytics and event tracking.
///
/// Implementations should forward events to the configured analytics backend
/// (e.g. Firebase Analytics, Mixpanel, Amplitude).
///
/// Use [AnalyticsService] via the `analyticsServiceProvider` Riverpod provider.
abstract class AnalyticsService {
  /// Tracks a named event with optional parameters.
  ///
  /// [name] should be a consistent snake_case identifier, e.g. `'button_tapped'`.
  /// [parameters] are optional key-value pairs providing event context.
  Future<void> logEvent(String name, {Map<String, Object>? parameters});

  /// Records a screen view with the given [screenName].
  ///
  /// Call this in each screen's [initState] or on route change to track
  /// navigation flow.
  Future<void> logScreenView(String screenName);

  /// Sets a persistent user property by [name] to [value].
  ///
  /// User properties persist across sessions and are attached to all
  /// subsequent events from this user.
  Future<void> setUserProperty(String name, String value);
}
