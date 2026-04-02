import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../network/binance_websocket_service.dart';
import '../local_db/hive_setup.dart';

// Market Feature Imports
import '../../features/market/data/repositories/market_repository_impl.dart';
import '../../features/market/domain/repositories/market_repository.dart';
import '../../features/market/domain/usecases/get_market_coins_usecase.dart';
import '../../features/market/presentation/bloc/market_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize Hive Setup
  await HiveSetup.init();

  // Core Plugins / Externals
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => BinanceWebSocketService());

  // Features - Blocs/Cubits
  sl.registerFactory(() => MarketCubit(getMarketCoinsUseCase: sl()));

  // Features - UseCases
  sl.registerLazySingleton(() => GetMarketCoinsUseCase(sl()));

  // Features - Repositories
  sl.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(remoteDataSource: sl()),
  );

  // Features - Data Sources
  sl.registerLazySingleton(
    () => MarketRemoteDataSource(dioClient: sl()),
  );
}
