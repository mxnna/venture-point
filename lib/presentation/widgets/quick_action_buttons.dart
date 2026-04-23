import 'package:flutter/material.dart';

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
    this.buttonColor = const Color(0xFFEA8A7E),
    this.iconColor = const Color(0xFFF6F5F1),
    this.textColor = const Color(0xFF2E2B28),
    this.buttonSize = 72,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buttons
          .map((button) => _buildButton(context, button))
          .toList(),
    );
  }

  Widget _buildButton(BuildContext context, QuickActionButton button) {
    return GestureDetector(
      onTap: button.onPressed,
      child: SizedBox(
        width: 86,
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
                    color: buttonColor.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  button.icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              button.label.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

