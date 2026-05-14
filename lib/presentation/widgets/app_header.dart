import 'package:flutter/material.dart';
import 'package:venturepoint/core/theme/app_colors.dart';

class AppHeader extends StatelessWidget {
  final String logoPath;
  final String appName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final ImageProvider? profileImage;

  const AppHeader({
    super.key,
    required this.logoPath,
    required this.appName,
    this.onNotificationTap,
    this.onProfileTap,
    this.profileImage,
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
              color: AppColors.primary,
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
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ),
        if (onProfileTap != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              backgroundImage: profileImage,
              child: profileImage == null
                  ? Icon(Icons.person, color: AppColors.secondary, size: 20)
                  : null,
            ),
          ),
        ],
      ],
    );
  }
}
