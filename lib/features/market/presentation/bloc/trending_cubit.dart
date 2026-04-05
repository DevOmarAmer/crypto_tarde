import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/trending_coin_item.dart';
import '../../data/models/trending_coin_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/exceptions.dart';

// ── States ────────────────────────────────────────────────────────────────────

abstract class TrendingState extends Equatable {
  const TrendingState();
  @override
  List<Object?> get props => [];
}

class TrendingInitial extends TrendingState {}

class TrendingLoading extends TrendingState {}

class TrendingLoaded extends TrendingState {
  final List<TrendingCoinItem> coins;
  const TrendingLoaded(this.coins);
  @override
  List<Object?> get props => [coins];
}

class TrendingError extends TrendingState {
  final String message;
  const TrendingError(this.message);
  @override
  List<Object?> get props => [message];
}

class TrendingRateLimited extends TrendingState {
  final int retryAfterSeconds;
  final List<TrendingCoinItem>? staleCoins;

  const TrendingRateLimited({
    required this.retryAfterSeconds,
    this.staleCoins,
  });

  @override
  List<Object?> get props => [retryAfterSeconds, staleCoins];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class TrendingCubit extends Cubit<TrendingState> {
  final DioClient _dioClient;

  TrendingCubit(this._dioClient) : super(TrendingInitial());

  static const List<int> _kRetryDelays = [30, 60, 90];
  int _retryCount = 0;
  Timer? _retryTimer;
  Timer? _countdownTimer;
  int _countdownSeconds = 0;
  List<TrendingCoinItem>? _staleCoins;

  @override
  Future<void> close() {
    _retryTimer?.cancel();
    _countdownTimer?.cancel();
    return super.close();
  }

  void _startRateLimitCountdown(int delaySeconds) {
    _retryTimer?.cancel();
    _countdownTimer?.cancel();

    _countdownSeconds = delaySeconds;
    emit(TrendingRateLimited(
      retryAfterSeconds: _countdownSeconds,
      staleCoins: _staleCoins,
    ));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      _countdownSeconds--;
      emit(TrendingRateLimited(
        retryAfterSeconds: _countdownSeconds,
        staleCoins: _staleCoins,
      ));
      if (_countdownSeconds <= 0) {
        timer.cancel();
      }
    });

    _retryTimer = Timer(Duration(seconds: delaySeconds), () {
      if (!isClosed) fetchTrending();
    });
  }

  Future<void> fetchTrending() async {
    _retryTimer?.cancel();
    _countdownTimer?.cancel();
    try {
      emit(TrendingLoading());

      final response =
          await _dioClient.coinGeckoDio.get('/search/trending');

      if (response.statusCode == 200) {
        final coinsJson =
            (response.data['coins'] as List<dynamic>? ?? []);
        final coins = coinsJson
            .map((e) =>
                TrendingCoinModel.fromJson(e as Map<String, dynamic>))
            .toList();
        _retryCount = 0;
        _staleCoins = coins;
        emit(TrendingLoaded(coins));
      } else if (response.statusCode == 429) {
        _handleRateLimit();
      } else {
        emit(const TrendingError('Failed to fetch trending coins.'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        _handleRateLimit();
      } else {
        emit(TrendingError(e.toString()));
      }
    } catch (e) {
      emit(TrendingError(e.toString()));
    }
  }

  void _handleRateLimit() {
    final delay = _retryCount < _kRetryDelays.length
        ? _kRetryDelays[_retryCount]
        : _kRetryDelays.last;
    _retryCount++;
    _startRateLimitCountdown(delay);
  }
}
