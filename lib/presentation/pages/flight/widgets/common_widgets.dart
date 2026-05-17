import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

// ─── App Colors shortcut ───────────────────────────────────────────────────
// ─── Navy rounded button ───────────────────────────────────────────────────
class NavyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double height;
  final Widget? icon;

  const NavyButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 48,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}

// ─── Field box (beige background) ─────────────────────────────────────────
class FieldBox extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  const FieldBox({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.beige,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

// ─── Badge (code chip) ─────────────────────────────────────────────────────
class CodeBadge extends StatelessWidget {
  final String code;
  const CodeBadge(this.code, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
    );
  }
}

// ─── Toggle chip ──────────────────────────────────────────────────────────
class FilterChip2 extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const FilterChip2({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.lightBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.blue.withOpacity(.5) : AppColors.beige3,
          ),
        ),
        child: Text(
          active ? '✓  $label' : label,
          style: TextStyle(
            fontSize: 11,
            color: active ? AppColors.navy : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─── Route line with plane ─────────────────────────────────────────────────
class RouteLine extends StatelessWidget {
  final String fromCode;
  final String toCode;
  final String duration;
  final bool isDirect;
  final double fontSize;

  const RouteLine({
    super.key,
    required this.fromCode,
    required this.toCode,
    required this.duration,
    required this.isDirect,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              fromCode,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                duration,
                style: TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.beige3,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.beige3,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.flight, size: 14, color: AppColors.blue),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.beige3,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.beige3,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                decoration: BoxDecoration(
                  color: isDirect ? AppColors.greenBg : AppColors.amberBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isDirect ? 'Direct' : '1 stop',
                  style: TextStyle(
                    fontSize: 8,
                    color: isDirect ? AppColors.green : AppColors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          toCode,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

// ─── Airline logo badge ────────────────────────────────────────────────────
class AirlineBadge extends StatelessWidget {
  final String code;
  final double size;

  const AirlineBadge(this.code, {super.key, this.size = 32});

  static final _colors = {
    'EK': [const Color(0xFFEBF2FC), const Color(0xFF1B3A6B)],
    'MS': [const Color(0xFFEDE6D6), const Color(0xFF7A8BAA)],
    'FZ': [const Color(0xFFFEF3E2), const Color(0xFF9A6100)],
  };

  @override
  Widget build(BuildContext context) {
    final col =
        _colors[code] ?? [const Color(0xFFEBF2FC), const Color(0xFF1B3A6B)];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: col[0],
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      alignment: Alignment.center,
      child: Text(
        code,
        style: TextStyle(
          fontSize: size * 0.3,
          fontWeight: FontWeight.w600,
          color: col[1],
        ),
      ),
    );
  }
}

// ─── Section header ────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: TextStyle(fontSize: 11, color: AppColors.blue),
            ),
          ),
      ],
    );
  }
}

// ─── Screen header (navy) ──────────────────────────────────────────────────
class NavyHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final Widget? trailing;
  final List<Widget>? extra;

  const NavyHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: extra != null ? 44 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.navyLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.white,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          if (extra != null) ...extra!,
        ],
      ),
    );
  }
}

// ─── Info box ─────────────────────────────────────────────────────────────
class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoBox({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 9, color: AppColors.textMuted),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(icon, size: 13, color: AppColors.blue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
