import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';

class PrimaryButtonWithIcon extends StatelessWidget {
  final String btnText;
  final IconData icon;
  final VoidCallback onTap;
  const PrimaryButtonWithIcon({
    super.key,
    required this.btnText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.gradientPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(
          btnText,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }
}
