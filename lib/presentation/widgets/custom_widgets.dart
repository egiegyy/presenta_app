import 'package:flutter/material.dart';

class AppPalette {
  static const Color brandBlue = Color(0xFF0A6CFF);
  static const Color brandBlueDark = Color(0xFF0A4ED2);
  static const Color brandBlueSoft = Color(0xFF92C7FF);
  static const Color backgroundTint = Color(0xFFF5FAFF);

  static const Color pastelGreen = Color(0xFFE7F8EF);
  static const Color pastelGreenBorder = Color(0xFFB7E8CB);
  static const Color pastelGreenText = Color(0xFF169B62);

  static const Color pastelYellow = Color(0xFFFFF4D9);
  static const Color pastelYellowBorder = Color(0xFFF4D58D);
  static const Color pastelYellowText = Color(0xFFC98308);

  static const Color pastelRed = Color(0xFFFDE7E7);
  static const Color pastelRedBorder = Color(0xFFF4B8B8);
  static const Color pastelRedText = Color(0xFFD94A4A);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundTintFor(BuildContext context) => isDark(context)
      ? const Color(0xFF0F172A)
      : backgroundTint;

  static Color surfaceFor(BuildContext context) => isDark(context)
      ? const Color(0xFF162033)
      : Colors.white;

  static Color borderFor(BuildContext context) => isDark(context)
      ? const Color(0xFF263245)
      : const Color(0xFFDCE7FF);

  static Color textPrimaryFor(BuildContext context) => isDark(context)
      ? const Color(0xFFF8FAFC)
      : textPrimary;

  static Color textSecondaryFor(BuildContext context) => isDark(context)
      ? const Color(0xFF94A3B8)
      : textSecondary;
}

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = AppPalette.isDark(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [
                  Color(0xFF08101E),
                  Color(0xFF10203B),
                  Color(0xFF0F172A),
                ]
              : const [
                  AppPalette.brandBlue,
                  AppPalette.brandBlueSoft,
                  AppPalette.backgroundTint,
                ],
        ),
      ),
      child: child,
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final Color startColor;
  final Color endColor;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.startColor = AppPalette.brandBlueDark,
    this.endColor = AppPalette.brandBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: startColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading || !enabled ? null : onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.inputType,
          obscureText: _obscureText,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon)
                : null,
            prefixIconColor: AppPalette.brandBlueDark,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppPalette.brandBlueDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppPalette.brandBlueDark,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFFDCE7FF)),
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.opacity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppPalette.isDark(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: (isDark ? const Color(0xFF162033) : Colors.white).withValues(
          alpha: isDark ? 0.96 : 0.95,
        ),
        border: Border.all(color: AppPalette.borderFor(context), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  final String message;

  const LoadingDialog({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: GlassmorphicCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppPalette.brandBlueDark),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.brandBlueDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AppSnackbarType { success, error, info }

class AppSnackbar {
  static void show(
    BuildContext context,
    String message, {
    AppSnackbarType type = AppSnackbarType.info,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: _backgroundColor(type),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  static Color _backgroundColor(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return const Color(0xFF169B62);
      case AppSnackbarType.error:
        return const Color(0xFFD94A4A);
      case AppSnackbarType.info:
        return AppPalette.brandBlueDark;
    }
  }
}

class ErrorSnackbar {
  static void show(BuildContext context, String message) {
    AppSnackbar.show(context, message, type: AppSnackbarType.error);
  }
}

class SuccessSnackbar {
  static void show(BuildContext context, String message) {
    AppSnackbar.show(context, message, type: AppSnackbarType.success);
  }
}

class AttendanceSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const AttendanceSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppPalette.isDark(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? backgroundColor.withValues(alpha: 0.18) : backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
