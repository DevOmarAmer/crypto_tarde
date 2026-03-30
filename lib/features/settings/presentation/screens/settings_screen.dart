import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_action_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          AppStrings.settings,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16.0),
        children: [
          CustomActionTile(
            title: AppStrings.language,
            trailingText: 'English',
            leadingIcon: Icons.language,
            onTap: () {},
          ),
          CustomActionTile(
            title: AppStrings.currency,
            trailingText: 'USD',
            leadingIcon: Icons.monetization_on_outlined,
            onTap: () {},
          ),
          CustomActionTile(
            title: AppStrings.appearance,
            trailingText: 'Use Device Settings',
            leadingIcon: Icons.dark_mode_outlined,
            onTap: () {},
          ),
          CustomActionTile(
            title: AppStrings.preference,
            trailingText: 'Customize',
            leadingIcon: Icons.tune,
            onTap: () {},
          ),
          CustomActionTile(
            title: AppStrings.aboutUs,
            trailingText: 'v1.2.3',
            leadingIcon: Icons.people_outline,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
