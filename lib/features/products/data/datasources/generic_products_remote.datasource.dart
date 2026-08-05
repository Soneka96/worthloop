// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

// Project imports:
import 'package:worth_loop/features/products/data/datasources/price_response_detector.datasource.dart';
import 'package:worth_loop/features/products/data/datasources/products_remote.datasource.dart';
import 'package:worth_loop/features/products/data/models/store_price.model.dart';
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/domain/value_objects/money.value-object.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Fetches product prices from standard JSON-LD product markup.
class GenericProductsRemoteDatasource implements ProductsRemoteDatasource {
  final Dio _dio;
  final PriceResponseDetector _detector;
  final LoggerService _loggerService;
  final DateTime Function() _now;
  final Map<String, DateTime> _blockedUntilByUrl = {};

  /// Creates a generic remote datasource with HTTP and response detection.
  GenericProductsRemoteDatasource(
    this._dio,
    this._detector,
    this._loggerService, {
    DateTime Function() now = DateTime.now,
  }) : _now = now;

  @override
  Future<Either<Failure, List<StorePriceModel>>> fetchPrices(
    ProductSource source,
  ) async {
    final DateTime? blockedUntil = _blockedUntilByUrl[source.url];
    if (blockedUntil != null && _now().isBefore(blockedUntil)) {
      final Failure failure = _failureFor(PriceFetchStatus.blocked);
      _loggerService.e(failure.message);
      return Left(failure);
    }
    try {
      final Response<String> response = await _dio.get<String>(
        source.url,
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                '(KHTML, like Gecko) Chrome/120 Safari/537.36',
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'pt-PT,pt;q=0.9,en;q=0.8',
            'Connection': 'keep-alive',
          },
        ),
      );
      final String responseBody = response.data ?? '';
      final ({int minorUnits, String currencyCode, bool isAvailable})? offer =
          _parseOffer(responseBody);
      final PriceFetchStatus status = _detector.detect(
        statusCode: response.statusCode,
        responseBody: responseBody,
        hasUsablePrice: offer != null,
      );
      if (status != PriceFetchStatus.success || offer == null) {
        final Failure failure = _failureFor(status);
        if (status == PriceFetchStatus.blocked) {
          _blockedUntilByUrl[source.url] = _now().add(const Duration(hours: 1));
        }
        _loggerService.e(failure.message);
        return Left(failure);
      }
      return Right([
        StorePriceModel(
          storeName: source.merchantDomain,
          productUrl: source.url,
          currentPrice: Money(
            minorUnits: offer.minorUnits,
            currencyCode: offer.currencyCode,
          ),
          isAvailable: offer.isAvailable,
          lastCheckedAt: DateTime.now(),
        ),
      ]);
    } on DioException catch (error) {
      final PriceFetchStatus status = _detector.detect(
        statusCode: error.response?.statusCode,
        responseBody: error.response?.data?.toString() ?? '',
        hasUsablePrice: false,
      );
      if (status == PriceFetchStatus.blocked) {
        _blockedUntilByUrl[source.url] = _now().add(const Duration(hours: 1));
      }
      _loggerService.e(error.toString());
      return Left(_failureFor(status));
    }
  }

  ({int minorUnits, String currencyCode, bool isAvailable})? _parseOffer(
    String responseBody,
  ) {
    for (final Match match in _jsonLdPattern.allMatches(responseBody)) {
      final String json = match.group(1)?.trim() ?? '';
      if (json.isEmpty) {
        continue;
      }
      try {
        final dynamic decoded = jsonDecode(json);
        for (final Map<String, dynamic> offer in _findOffers(decoded)) {
          final num? amount = _parseNumber(offer['price'] ?? offer['lowPrice']);
          final String? currencyValue = offer['priceCurrency']?.toString();
          if (amount == null ||
              currencyValue == null ||
              currencyValue.trim().isEmpty) {
            continue;
          }
          final String currencyCode = currencyValue.trim().toUpperCase();
          final String availability =
              offer['availability']?.toString().toLowerCase() ?? '';
          return (
            minorUnits: (amount.toDouble() * 100).round(),
            currencyCode: currencyCode,
            isAvailable:
                !availability.contains('outofstock') &&
                !availability.contains('soldout') &&
                !availability.contains('unavailable'),
          );
        }
      } on FormatException {
        continue;
      }
    }
    return null;
  }

  Iterable<Map<String, dynamic>> _findOffers(dynamic value) sync* {
    if (value is List) {
      for (final dynamic item in value) {
        yield* _findOffers(item);
      }
      return;
    }
    if (value is! Map) {
      return;
    }
    final Map<dynamic, dynamic> map = value;
    if (map['price'] != null || map['lowPrice'] != null) {
      yield Map<String, dynamic>.from(map);
    }
    yield* _findOffers(map['offers']);
    yield* _findOffers(map['@graph']);
  }

  num? _parseNumber(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value == null) {
      return null;
    }
    String normalized = value.toString().trim();
    final int commaIndex = normalized.lastIndexOf(',');
    final int periodIndex = normalized.lastIndexOf('.');
    if (commaIndex >= 0 && periodIndex >= 0) {
      normalized = commaIndex > periodIndex
          ? normalized.replaceAll('.', '').replaceFirst(',', '.')
          : normalized.replaceAll(',', '');
    } else if (commaIndex >= 0) {
      final int fractionalDigits = normalized.length - commaIndex - 1;
      normalized = fractionalDigits == 3
          ? normalized.replaceAll(',', '')
          : normalized.replaceFirst(',', '.');
    }
    return num.tryParse(normalized);
  }

  Failure _failureFor(PriceFetchStatus status) => switch (status) {
    PriceFetchStatus.blocked => const PriceFetchFailure(
      status: PriceFetchStatus.blocked,
      message: 'Website blocked the price request',
    ),
    PriceFetchStatus.networkError => const PriceFetchFailure(
      status: PriceFetchStatus.networkError,
      message: 'Unable to fetch the product price',
    ),
    PriceFetchStatus.invalidData => const PriceFetchFailure(
      status: PriceFetchStatus.invalidData,
      message: 'Website returned invalid price data',
    ),
    PriceFetchStatus.unsupported => const PriceFetchFailure(
      status: PriceFetchStatus.unsupported,
      message: 'Website does not expose supported price data',
    ),
    PriceFetchStatus.success => const ValidationFailure(
      'Price fetch unexpectedly succeeded',
    ),
    PriceFetchStatus.none => const NetworkFailure('Price fetch did not run'),
  };

  static final RegExp _jsonLdPattern = RegExp(
    r'''<script[^>]+type=["']application/ld\+json["'][^>]*>(.*?)</script>''',
    caseSensitive: false,
    dotAll: true,
  );
}
