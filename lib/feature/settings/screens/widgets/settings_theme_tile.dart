import 'package:flutter/material.dart';
import 'package:habit/core/constants/app_colors.dart';

class SettingsThemeTile extends StatelessWidget {
  const SettingsThemeTile({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.overlayColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.brightness_4, color: AppColors.primaryText, size: 24),
              const SizedBox(width: 12),
              Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          Switch(
            value: isDarkMode,
            onChanged: onToggle,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}
