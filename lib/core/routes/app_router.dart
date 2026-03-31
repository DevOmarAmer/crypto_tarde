import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/market/presentation/pages/market_screen.dart';
import '../../features/wallet/presentation/pages/wallet_screen.dart';





class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String market = '/market';
  static const String wallet = '/wallet';





  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => NotificationsScreen(),
      ),
      GoRoute(
        path: market,
        builder: (context, state) => const MarketScreen(),
      ),
      GoRoute(
        path: wallet,
        builder: (context, state) => const WalletScreen(),
      ),




    ],
  );
}
