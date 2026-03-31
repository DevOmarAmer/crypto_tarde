import 'package:flutter/material.dart';
import '../../features/home/presentation/widgets/custom_bottom_nav.dart';
import '../theme/app_colors.dart';


class MainScaffold extends StatelessWidget {
  final Widget child;
  final String location;

  const MainScaffold({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBody: true,
      body: child,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _getCurrentIndex(location),
      ),
    );
  }

  int _getCurrentIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/market')) return 1;
    if (location.startsWith('/trades')) return 2;
    if (location.startsWith('/notifications')) return 3;
    if (location.startsWith('/wallet')) return 4;
    return 0;
  }
}
