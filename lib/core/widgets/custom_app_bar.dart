import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;

  const CustomAppBar({super.key, this.title, this.showBackButton = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (title != null || showBackButton) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton 
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              )
            : null,
        title: title != null ? Text(title!, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)) : null,
        centerTitle: true,
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                onPressed: () => context.push(AppRouter.notifications),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
