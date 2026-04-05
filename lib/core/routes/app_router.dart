// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/dependency_injection.dart';
import '../../features/market/presentation/bloc/market_cubit.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/search/logic/search_cubit.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/market/presentation/pages/market_screen.dart';
import '../../features/wallet/presentation/pages/wallet_screen.dart';
import '../../features/trade/presentation/pages/trade_screen.dart';
import '../../features/activity/presentation/pages/activity_screen.dart';
import '../widgets/main_scaffold.dart';
import '../../features/favorites/presentation/pages/favorites_screen.dart';
import '../../features/favorites/presentation/bloc/favorites_cubit.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String home = '/home';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String market = '/market';
  static const String wallet = '/wallet';
  static const String trades = '/trade_screen'; // Full trade screen
  static const String myTrades = '/my_trades'; // Activity feed
  static const String favorites = '/favorites';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Routes without bottom navigation
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: auth,
        builder: (context, state) => BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>(),
          child: const AuthScreen(),
        ),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>(),
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: search,
        builder: (context, state) => BlocProvider<SearchCubit>(
          create: (_) => sl<SearchCubit>()..loadSearchHistory(),
          child: const SearchScreen(),
        ),
      ),

      // Routes with persistent bottom navigation bar
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider<FavoritesCubit>(
            create: (_) => sl<FavoritesCubit>(),
            child: MainScaffold(location: state.matchedLocation, child: child),
          );
        },
        routes: [
          GoRoute(path: home, builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: market,
            builder: (context, state) => BlocProvider<MarketCubit>(
              create: (_) => sl<MarketCubit>()..fetchMarketCoins(),
              child: const MarketScreen(),
            ),
          ),
          GoRoute(
            path: notifications,
            builder: (context, state) => NotificationsScreen(),
          ),
          GoRoute(
            path: wallet,
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: myTrades,
            builder: (context, state) => const ActivityScreen(),
          ),
          GoRoute(
            path: favorites,
            builder: (context, state) => BlocProvider<MarketCubit>(
              create: (_) => sl<MarketCubit>()..fetchMarketCoins(),
              child: const FavoritesScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: trades,
        builder: (context, state) {
          final extras = state.extra as Map?;
          final symbol = (extras?['symbol'] as String?)?.toUpperCase() ?? 'BTC';
          return TradeScreen(
            coinId: extras?['coinId'] as String? ?? 'bitcoin',
            symbol: symbol,
            name: extras?['name'] as String? ?? 'Bitcoin',
            logoUrl: extras?['logoUrl'] as String? ?? '',
          );
        },
      ),
    ],
  );
}
