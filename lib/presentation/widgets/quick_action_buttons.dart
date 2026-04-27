import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class QuickActionButton {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  QuickActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
}

class QuickActionButtons extends StatelessWidget {
  final List<QuickActionButton> buttons;
  final Color buttonColor;
  final Color iconColor;
  final Color textColor;
  final double buttonSize;
  final double iconSize;

  const QuickActionButtons({
    super.key,
    required this.buttons,
    this.buttonColor = AppColors.primary,
    this.iconColor = AppColors.white,
    this.textColor = AppColors.textPrimary,
    this.buttonSize = 56,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttons.map((button) => _buildButton(button)).toList(),
    );
  }

  Widget _buildButton(QuickActionButton button) {
    return GestureDetector(
      onTap: button.onPressed,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor,
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(button.icon, size: iconSize, color: iconColor),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              button.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
