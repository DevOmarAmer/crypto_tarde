import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppColors.white)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingTile(
            icon: Icons.person_outline,
            title: 'Personal Info',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            onTap: () {},
          ),
          _buildSectionHeader('Preferences'),
          _buildSettingTile(
            icon: Icons.language,
            title: 'Language',
            trailingText: 'English',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: Switch(
              value: true,
              onChanged: (v) {},
              activeColor: AppColors.primary,
            ),
            onTap: () {},
          ),
          _buildSectionHeader('Other'),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w500),
      ),
      trailing: trailing ?? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          const SizedBox(width: 5),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.grey),
        ],
      ),
    );
  }
}
