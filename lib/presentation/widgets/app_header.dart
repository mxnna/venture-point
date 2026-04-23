import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String logoPath;
  final String appName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const AppHeader({
    super.key,
    required this.logoPath,
    required this.appName,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            logoPath,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            appName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEA8A7E),
            ),
          ),
        ),
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF2E2B28),
              size: 24,
            ),
          ),
        ),
        if (onProfileTap != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEA8A7E),
              ),
              child: Icon(
                Icons.person,
                color: Color(0xFFF6F5F1),
                size: 20,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
