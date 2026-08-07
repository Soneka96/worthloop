// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/features/home/presentation/widgets/add_product_dialog.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/foreground_refresh_observer.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/home_header.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/home_products_header.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_list.section.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// Displays tracked products and their best current offers.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeScreenViewModel>(
      distinct: true,
      onInit: (store) {
        store.dispatch(const LoadProductsAction());
        store.dispatch(const LoadRefreshSettingsAction());
      },
      converter: (store) => sl<HomeScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        return ForegroundRefreshObserver(
          interval: Duration(minutes: viewmodel.refreshIntervalMinutes),
          onRefresh: viewmodel.onRefreshAll,
          lastUpdatedAt: viewmodel.oldestUpdatedAt,
          child: Scaffold(
            floatingActionButton: FloatingActionButton.small(
              key: const Key('home-add-product-button'),
              tooltip: t.home.addProductButton,
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => const AddProductDialog(),
              ),
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  viewmodel.onRefreshAll();
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(context.spacing.md),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          HomeHeader(onOpenSettings: viewmodel.onOpenSettings),
                          HomeProductsHeader(
                            productCount: viewmodel.products.length,
                            isRefreshing: viewmodel.isRefreshing,
                            refreshCompletedCount:
                                viewmodel.refreshCompletedCount,
                            refreshTotalCount: viewmodel.refreshTotalCount,
                            latestUpdatedAt: viewmodel.latestUpdatedAt,
                          ),
                        ]),
                      ),
                    ),
                    TrackedProductsListSection(
                      products: viewmodel.products,
                      isLoading: viewmodel.isLoading,
                      sourceRefreshStatuses: viewmodel.sourceRefreshStatuses,
                      onProductTap: viewmodel.onOpenProduct,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
