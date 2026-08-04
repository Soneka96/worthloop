// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_empty.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_list.widget.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/widgets/illustrative_price_notice.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays tracked products and their best current offers.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return StoreConnector<AppState, HomeScreenViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(const LoadProductsAction()),
      converter: (store) => sl<HomeScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(t.appTitle, style: textTheme.headlineSmall),
                    ),
                    IconButton(
                      key: const Key('home-settings-button'),
                      onPressed: viewmodel.onOpenSettings,
                      tooltip: t.settings.title,
                      icon: Icon(
                        Icons.settings_outlined,
                        size: IconSizes.md,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text(t.home.subtitle, style: textTheme.bodyMedium),
                SizedBox(height: context.spacing.sm),
                const IllustrativePriceNotice(),
                SizedBox(height: context.spacing.lg),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: context.spacing.md,
                  runSpacing: context.spacing.sm,
                  children: [
                    Text(
                      t.home.trackedProducts(count: viewmodel.products.length),
                      style: textTheme.labelSmall,
                    ),
                    FilledButton.icon(
                      key: const Key('home-refresh-all-button'),
                      onPressed:
                          viewmodel.isRefreshingAll ||
                              viewmodel.isLoading ||
                              viewmodel.products.isEmpty
                          ? null
                          : viewmodel.onRefreshAll,
                      icon: viewmodel.isRefreshingAll
                          ? const SizedBox.square(
                              dimension: IconSizes.md,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(
                        viewmodel.isRefreshingAll
                            ? t.home.refreshing
                            : t.home.refreshAll,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.spacing.md),
                Expanded(
                  child: viewmodel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : viewmodel.products.isEmpty
                      ? const TrackedProductsEmptyWidget()
                      : TrackedProductsListWidget(
                          products: viewmodel.products,
                          onProductTap: viewmodel.onOpenProduct,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
