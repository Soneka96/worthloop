// Project imports:
import 'package:worth_loop/shared/utils/home_widget_data_service.dart';
import 'package:worth_loop/shared/utils/home_widget_price.dto.dart';

/// Keeps home-widget price data available in the current app process.
class LocalHomeWidgetDataService implements HomeWidgetDataService {
  final Map<String, HomeWidgetPriceDto> _prices = {};

  @override
  void expose(HomeWidgetPriceDto data) {
    _prices[data.productId] = data;
  }

  @override
  HomeWidgetPriceDto? latestFor(String productId) => _prices[productId];
}
