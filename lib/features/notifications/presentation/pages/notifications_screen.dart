import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/notification_model.dart';
import '../widgets/notification_tile.dart';
import '../../../home/presentation/widgets/custom_bottom_nav.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  // قائمة وهمية بالبيانات (يفضل جلبها من API عبر BLoC/Cubit لاحقاً)
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
      extendBody: true, // ضرورية لجعل شريط التنقل يعوم فوق المحتوى
      bottomNavigationBar: const CustomBottomNav(), // إعادة استخدام شريط التنقل
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            _buildSectionHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  return NotificationTile(notification: _notifications[index]);
                },
              ),
            ),
            // مساحة إضافية في الأسفل حتى لا يغطي شريط التنقل على آخر عنصر
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // الشريط العلوي الذي يحوي الصورة والأيقونات
  Widget _buildTopAppBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/png/user.png'),
          ),
          Row(
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/svg/search.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                  width: 44,
                  height: 44,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/svg/scan.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/images/svg/notif.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                  width: 44,
                  height: 44,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // شريط عنوان الإشعارات وأزرار الفلتر
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
