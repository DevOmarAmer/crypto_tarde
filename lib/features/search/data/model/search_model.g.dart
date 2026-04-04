// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchCoinModel _$SearchCoinModelFromJson(Map<String, dynamic> json) =>
    SearchCoinModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
      thumb: json['thumb'] as String,
      large: json['large'] as String,
    );

Map<String, dynamic> _$SearchCoinModelToJson(SearchCoinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'market_cap_rank': instance.marketCapRank,
      'thumb': instance.thumb,
      'large': instance.large,
    };
