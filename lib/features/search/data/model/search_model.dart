import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@JsonSerializable()
class SearchCoinModel {
  final String id;
  final String name;
  final String symbol;
  @JsonKey(name: 'market_cap_rank')
  final int? marketCapRank;
  final String thumb;
  final String large;

  SearchCoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    this.marketCapRank,
    required this.thumb,
    required this.large,
  });

  factory SearchCoinModel.fromJson(Map<String, dynamic> json) =>
      _$SearchCoinModelFromJson(json);
}