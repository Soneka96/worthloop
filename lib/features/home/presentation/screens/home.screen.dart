// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/features/home/presentation/widgets/add_product_dialog.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/home_header.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/home_products_header.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/tracked_products_list.section.dart';
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_refresh_status_notice.widget.dart';
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
      onInit: (store) => store.dispatch(const LoadProductsAction()),
      converter: (store) => sl<HomeScreenViewModel>(param1: store),
      builder: (context, viewmodel) {
        return Scaffold(
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
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(context.spacing.md),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      HomeHeader(onOpenSettings: viewmodel.onOpenSettings),
                      ProductRefreshStatusNotice(
                        status: viewmodel.refreshStatus,
                      ),
                      SizedBox(height: context.spacing.lg),
                      HomeProductsHeader(
                        productCount: viewmodel.products.length,
                        isRefreshingAll: viewmodel.isRefreshingAll,
                        isLoading: viewmodel.isLoading,
                        onRefreshAll: viewmodel.onRefreshAll,
                      ),
                    ]),
                  ),
                ),
                TrackedProductsListSection(
                  products: viewmodel.products,
                  isLoading: viewmodel.isLoading,
                  onProductTap: viewmodel.onOpenProduct,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
