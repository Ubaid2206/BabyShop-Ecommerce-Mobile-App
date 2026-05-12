import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class AppTheme {
  // ── Gradient Palette ──────────────────────────────────────────
  static const Color bg1 = Color(0xFF0F0C29);
  static const Color bg2 = Color(0xFF302B63);
  static const Color bg3 = Color(0xFF24243E);

  static const Color primary   = Color(0xFF9B59FF);
  static const Color primary2  = Color(0xFFE040FB);
  static const Color accent    = Color(0xFF00E5FF);
  static const Color gold      = Color(0xFFFFD700);

  static const Color surface   = Color(0x22FFFFFF);
  static const Color surfaceHi = Color(0x33FFFFFF);
  static const Color border    = Color(0x44FFFFFF);

  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xAAFFFFFF);
  static const Color textHint      = Color(0x66FFFFFF);

  static const Color success = Color(0xFF00E676);
  static const Color error   = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFD740);

  // ── Gradients ─────────────────────────────────────────────────
  static const LinearGradient bgGradient = LinearGradient(
    colors: [bg1, bg2, bg3],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primary2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x11FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF8F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Spacing ───────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // ── Radius ────────────────────────────────────────────────────
  static const double r8  = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;

  // ── Glass card decoration ─────────────────────────────────────
  static BoxDecoration glassCard({double radius = r16, Color? color}) =>
      BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x33FFFFFF), Color(0x11FFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  // ── Shadows ───────────────────────────────────────────────────
  static List<BoxShadow> get glow => [
        BoxShadow(
          color: primary.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  // ── Theme ─────────────────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg1,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        foregroundColor: textPrimary,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: lg, vertical: md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0x22FFFFFF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: md, vertical: md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r16),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r16),
          borderSide: const BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r16),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        hintStyle: const TextStyle(color: textHint, fontSize: 14),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary.withOpacity(0.3),
        labelStyle:
            const TextStyle(color: textPrimary, fontSize: 12),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r32),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        displayLarge:  TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
        displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        displaySmall:  TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
        headlineMedium:TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleLarge:    TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium:   TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        titleSmall:    TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge:     TextStyle(color: textPrimary),
        bodyMedium:    TextStyle(color: textSecondary),
        bodySmall:     TextStyle(color: textHint, fontSize: 12),
        labelLarge:    TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Reusable Glass Widget ─────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;

  const GlassCard({
    Key? key,
    required this.child,
    this.radius,
    this.padding,
    this.margin,
    this.blur = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: AppTheme.glassCard(radius: radius ?? AppTheme.r16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? AppTheme.r16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ── Gradient Background Scaffold ──────────────────────────────────
class GradientScaffold extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  const GradientScaffold({
    Key? key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: body,
      ),
    );
  }
}

// ── Gradient Button ───────────────────────────────────────────────
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final IconData? icon;

  const GradientButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? const LinearGradient(
                  colors: [Colors.grey, Colors.grey])
              : AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(AppTheme.r16),
          boxShadow: onPressed == null ? [] : AppTheme.glow,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
