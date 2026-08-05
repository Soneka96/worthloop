// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/entities/product_source.entity.dart';
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_source_row.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources.section.dart';
import 'package:worth_loop/features/products/presentation/widgets/product_sources_empty.widget.dart';
import 'package:worth_loop/features/products/presentation/widgets/source_form_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/product_source.fixture.dart';

class MockProductDetailsViewModel extends Mock
    implements ProductDetailsViewModel {}

void main() {
  late MockProductDetailsViewModel mockViewModel;
  late Store<AppState> store;
  final List<ProductSource> sources = [
    buildProductSource(id: 'source-1', url: 'https://example.com/products/1'),
    buildProductSource(id: 'source-2', url: 'https://another.com/products/2'),
  ];

  setUp(() {
    mockViewModel = MockProductDetailsViewModel();
    when(() => mockViewModel.isAddingSource).thenReturn(false);
    when(() => mockViewModel.addSourceError).thenReturn(null);
    when(() => mockViewModel.editingSourceId).thenReturn(null);
    when(() => mockViewModel.editSourceError).thenReturn(null);
    when(() => mockViewModel.onAddSource).thenReturn((_) {});
    when(() => mockViewModel.onEditSource).thenReturn((_, _) {});

    sl.registerFactoryParam<ProductDetailsViewModel, Store<AppState>, String>(
      (store, productId) => mockViewModel,
    );

    store = Store<AppState>(
      (AppState state, dynamic action) => state,
      initialState: AppState.initial(),
    );
  });

  tearDown(() async {
    await sl.reset();
    reset(mockViewModel);
  });

  Widget buildWidget({
    List<ProductSource> sources = const [],
    bool isLoadingSources = false,
    Set<String> deletingSourceIds = const {},
    void Function(String sourceId)? onDeleteSource,
  }) => TranslationProvider(
    child: StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              ProductSourcesSection(
                productId: 'product-1',
                sources: sources,
                isLoadingSources: isLoadingSources,
                deletingSourceIds: deletingSourceIds,
                onDeleteSource: onDeleteSource ?? (_) {},
              ),
            ],
          ),
        ),
      ),
    ),
  );

  group('ProductSourcesSection contains widgets', () {
    testWidgets(
      'ProductSourcesSection contains a "product-details-add-source-button" FilledButton with the correct parameters',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('product-details-add-source-button')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'ProductSourcesSection contains a CircularProgressIndicator with the correct parameters when isLoadingSources = true',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(sources: sources, isLoadingSources: true),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(ProductSourceRow), findsNothing);
        expect(find.byType(ProductSourcesEmptyWidget), findsNothing);
      },
    );

    testWidgets(
      'ProductSourcesSection contains a ProductSourcesEmptyWidget with the correct parameters when sources is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(ProductSourcesEmptyWidget), findsOneWidget);
      },
    );

    testWidgets(
      'ProductSourcesSection contains a ProductSourceRow per source with the correct parameters when sources is not empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        expect(
          find.byKey(const Key('product-source-source-1')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('product-source-source-2')),
          findsOneWidget,
        );
      },
    );

    testWidgets('ProductSourcesSection uses a lazy source list', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildWidget(sources: sources));

      final SliverList sliverList = tester.widget(find.byType(SliverList));

      expect(sliverList.delegate, isA<SliverChildBuilderDelegate>());
    });

    testWidgets(
      'ProductSourcesSection contains a ProductSourceRow with isDeleting = true only for the source id in deletingSourceIds',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          buildWidget(sources: sources, deletingSourceIds: const {'source-1'}),
        );

        final ProductSourceRow deletingRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is ProductSourceRow && widget.source.id == 'source-1',
          ),
        );
        final ProductSourceRow otherRow = tester.widget(
          find.byWidgetPredicate(
            (widget) =>
                widget is ProductSourceRow && widget.source.id == 'source-2',
          ),
        );
        expect(deletingRow.isDeleting, isA<bool>());
        expect(deletingRow.isDeleting, isTrue);
        expect(otherRow.isDeleting, isA<bool>());
        expect(otherRow.isDeleting, isFalse);
      },
    );
  });

  group("ProductSourcesSection's elements behavior", () {
    testWidgets(
      'ProductSourcesSection contains a "product-details-add-source-button" FilledButton with the correct behavior',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(
          find.byKey(const Key('product-details-add-source-button')),
        );
        await tester.pumpAndSettle();

        final SourceFormDialog dialog = tester.widget(
          find.byType(SourceFormDialog),
        );
        expect(dialog.productId, 'product-1');
        expect(dialog.source, isNull);
      },
    );

    testWidgets(
      'ProductSourcesSection contains a "product-source-source-1-edit-button" IconButton with the correct behavior',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(sources: sources));

        await tester.tap(
          find.byKey(const Key('product-source-source-1-edit-button')),
        );
        await tester.pumpAndSettle();

        final SourceFormDialog dialog = tester.widget(
          find.byType(SourceFormDialog),
        );
        expect(dialog.source, isA<ProductSource>());
        expect(dialog.source?.id, 'source-1');
      },
    );

    testWidgets(
      'ProductSourcesSection calls onDeleteSource when the delete confirmation is confirmed',
      (WidgetTester tester) async {
        String? deletedId;
        await tester.pumpWidget(
          buildWidget(sources: sources, onDeleteSource: (id) => deletedId = id),
        );

        await tester.tap(
          find.byKey(const Key('product-source-source-1-delete-button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const Key('confirm-dialog-confirm-button')),
        );
        await tester.pumpAndSettle();

        expect(deletedId, isA<String>());
        expect(deletedId, 'source-1');
      },
    );

    testWidgets(
      'ProductSourcesSection does not call onDeleteSource when the delete confirmation is cancelled',
      (WidgetTester tester) async {
        String? deletedId;
        await tester.pumpWidget(
          buildWidget(sources: sources, onDeleteSource: (id) => deletedId = id),
        );

        await tester.tap(
          find.byKey(const Key('product-source-source-1-delete-button')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('confirm-dialog-cancel-button')));
        await tester.pumpAndSettle();

        expect(deletedId, isNull);
      },
    );
  });

  group("ProductSourcesSection's translations", () {
    testWidgets('ProductSourcesSection displays the Portuguese translations', (
      WidgetTester tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(find.text(t.productDetails.sourcesTitle), findsOneWidget);
        expect(find.text(t.productDetails.addSourceButton), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
