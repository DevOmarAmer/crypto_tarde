import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/models/notification_model.dart';
import '../widgets/notification_tile.dart';


class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final List<NotificationItemModel> _notifications = [
    NotificationItemModel(
      title: 'Withdrawal Successful',
      message: 'You have successfully withdrawn lorem ipsum dolor sit...',
      type: NotificationType.success,
    ),
    NotificationItemModel(
      title: 'Deposit Successful',
      message: 'You have successfully deposited lorem ipsum dolor sit...',
      type: NotificationType.warning,
    ),
    NotificationItemModel(
      title: 'Login From An Unknown Device',
      message: 'Your account was logged from an unknown device lorem...',
      type: NotificationType.error,
    ),
    NotificationItemModel(
      title: 'Withdrawal Successful',
      message: 'You have successfully withdrawn lorem ipsum dolor sit...',
      type: NotificationType.success,
    ),
    NotificationItemModel(
      title: 'Withdrawal Successful',
      message: 'You have successfully withdrawn lorem ipsum dolor sit...',
      type: NotificationType.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(

        child: Column(
          children: [
            const CustomAppBar(),
            _buildSectionHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return NotificationTile(notification: _notifications[index]);
                },
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Mark Read All',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/svg/filter.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
