// Project imports:
import 'package:worth_loop/shared/utils/home_widget_price.dto.dart';

/// Stores and retrieves home-widget price summaries.
abstract class HomeWidgetDataService {
  /// Stores [data] as the latest widget value for its product.
  void expose(HomeWidgetPriceDto data);

  /// Returns the latest widget value for [productId], or `null`.
  HomeWidgetPriceDto? latestFor(String productId);
}
