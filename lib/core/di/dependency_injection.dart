import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../network/binance_websocket_service.dart';
import '../local_db/hive_setup.dart';

// Market Feature Imports
import '../../features/market/data/repositories/market_repository_impl.dart';
import '../../features/market/domain/repositories/market_repository.dart';
import '../../features/market/domain/usecases/get_market_coins_usecase.dart';
import '../../features/market/presentation/bloc/market_cubit.dart';

// Trade Feature Imports
import '../../features/trade/data/datasources/trade_local_datasource.dart';
import '../../features/trade/data/datasources/trade_remote_datasource.dart';
import '../../features/trade/data/repositories/trade_repository_impl.dart';
import '../../features/trade/domain/repositories/trade_repository.dart';
import '../../features/trade/presentation/bloc/trade_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Shared Preferences
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // Initialize Hive Setup
  await HiveSetup.init();

  // Core Plugins / Externals
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => BinanceWebSocketService());

  // Features - Blocs/Cubits
  sl.registerFactory(() => MarketCubit(getMarketCoinsUseCase: sl()));
  sl.registerFactory(
    () => TradeCubit(repository: sl(), webSocketService: sl()),
  );

  // Features - UseCases
  sl.registerLazySingleton(() => GetMarketCoinsUseCase(sl()));

  // Features - Repositories
  sl.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TradeRepository>(
    () => TradeRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Features - Data Sources
  sl.registerLazySingleton(() => MarketRemoteDataSource(dioClient: sl()));
  sl.registerLazySingleton(() => TradeRemoteDataSource(dioClient: sl()));
  sl.registerLazySingleton(() => TradeLocalDataSource());
}
