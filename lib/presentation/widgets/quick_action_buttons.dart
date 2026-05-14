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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(button.icon, size: 32, color: buttonColor),
            const SizedBox(height: 12),
            Text(
              button.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
