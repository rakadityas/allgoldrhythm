/// Single source of truth for app metadata shown in UI (About and Licenses
/// dialogs). Keep [appVersion] in sync with the `version:` field in
/// pubspec.yaml when bumping releases.
class AppInfo {
  static const String appName = 'AllGoldRhythm';
  static const String appVersion = '1.1.0';
  static const String description =
      'A Data Structures & Algorithms and System Design interview-prep app.';
}
