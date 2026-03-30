import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_action_tile.dart';
import '../../../../core/routes/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1E282E),
        elevation: 0,
        title: const Text(
          AppStrings.profile,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.white),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 32.0, top: 16.0),
            decoration: const BoxDecoration(
              color: Color(0xFF1E282E),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Colors.blueAccent.withOpacity(0.5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'User1234',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                CustomActionTile(
                  title: AppStrings.username,
                  trailingText: 'Username1234',
                  onTap: () {},
                ),
                CustomActionTile(
                  title: AppStrings.email,
                  trailingText: 'example@mail.com',
                  onTap: () {},
                ),
                CustomActionTile(
                  title: AppStrings.mobileNumber,
                  trailingText: '+1 234 567 8900',
                  onTap: () {},
                ),
                CustomActionTile(
                  title: AppStrings.password,
                  trailingText: '********',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
