import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.white)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.white),
            onPressed: () => context.push(AppRouter.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: 60,
                color: AppColors.darkBackground,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Senior Developer',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'senior@cryptotrade.com',
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),
            _buildBalanceCard(),
            const SizedBox(height: 30),
            _buildActionItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'My Wallet',
              onTap: () {},
            ),
            _buildActionItem(
              icon: Icons.history,
              title: 'Transaction History',
              onTap: () {},
            ),
            _buildActionItem(
              icon: Icons.security,
              title: 'Security',
              onTap: () {},
            ),
            _buildActionItem(
              icon: Icons.logout,
              title: 'Logout',
              color: AppColors.error,
              onTap: () => context.go(AppRouter.login),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              color: AppColors.darkBackground,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '\$42,500.00',
            style: TextStyle(
              color: AppColors.darkBackground,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(
                Icons.trending_up,
                color: AppColors.darkBackground,
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                '+ 5.23% (\$520.10)',
                style: TextStyle(
                  color: AppColors.darkBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.white,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.grey,
      ),
    );
  }
}
