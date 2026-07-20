import 'package:flutter/material.dart';

/// Centralized design tokens so spacing/radius/color decisions live in one
/// place instead of being repeated (and drifting) across every widget.
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class AppRadius {
  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 20.0;
}

class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFFE8A33D); // warm amber, less saturated than Colors.amber
  static const _brandDark = Color(0xFF12100C);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );
    return _base(colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ).copyWith(surface: _brandDark);
    return _base(colorScheme);
  }

  static ThemeData _base(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final textTheme = _textTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: 'Roboto',
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surfaceContainerHigh,
        labelStyle: textTheme.labelLarge,
        side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm + 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colorScheme.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm + 4),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      brightness: colorScheme.brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      extensions: [
        AppSemanticColors(
          success: isDark ? const Color(0xFF7FD99A) : const Color(0xFF2E7D46),
          codeBackground: isDark ? const Color(0xFF16140F) : const Color(0xFF1E1B14),
          codeForeground: const Color(0xFFF5EFE3),
        ),
      ],
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    return TextTheme(
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: colorScheme.onSurface, height: 1.25),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colorScheme.onSurface, height: 1.3),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: colorScheme.onSurface, height: 1.3),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
      bodyLarge: TextStyle(fontSize: 16, color: colorScheme.onSurface, height: 1.45),
      bodyMedium: TextStyle(fontSize: 14.5, color: colorScheme.onSurfaceVariant, height: 1.45),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
      labelMedium: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant),
    );
  }
}

/// Semantic colors that don't map cleanly onto Material's ColorScheme roles
/// (e.g. a fixed dark background for code blocks regardless of app theme).
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color success;
  final Color codeBackground;
  final Color codeForeground;

  const AppSemanticColors({
    required this.success,
    required this.codeBackground,
    required this.codeForeground,
  });

  @override
  AppSemanticColors copyWith({Color? success, Color? codeBackground, Color? codeForeground}) {
    return AppSemanticColors(
      success: success ?? this.success,
      codeBackground: codeBackground ?? this.codeBackground,
      codeForeground: codeForeground ?? this.codeForeground,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      codeBackground: Color.lerp(codeBackground, other.codeBackground, t)!,
      codeForeground: Color.lerp(codeForeground, other.codeForeground, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppSemanticColors get appColors => Theme.of(this).extension<AppSemanticColors>()!;
}
