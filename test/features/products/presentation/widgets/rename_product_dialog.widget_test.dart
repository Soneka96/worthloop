// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/state/viewmodels/product_details.viewmodel.dart';
import 'package:worth_loop/features/products/presentation/widgets/rename_product_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/features/product_form_field.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';

class MockProductDetailsViewModel extends Mock
    implements ProductDetailsViewModel {}

void main() {
  late MockProductDetailsViewModel mockViewModel;
  late Store<AppState> store;

  setUp(() {
    mockViewModel = MockProductDetailsViewModel();
    when(() => mockViewModel.isRenamingProduct).thenReturn(false);
    when(() => mockViewModel.renameProductError).thenReturn(null);
    when(() => mockViewModel.onRenameProduct).thenReturn((_) {});

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

  Widget buildWidget() => TranslationProvider(
    child: StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              key: const Key('trigger'),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => const RenameProductDialog(
                  productId: 'product-1',
                  currentName: 'Example Product',
                ),
              ),
              child: const Text('trigger'),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(buildWidget());
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
  }

  /// Opens the dialog with bounded pumps instead of [WidgetTester.pumpAndSettle]
  /// — used when `isRenamingProduct = true` is already stubbed at open time,
  /// since the submit button's indeterminate [CircularProgressIndicator]
  /// animates forever and would make pumpAndSettle time out.
  Future<void> openDialogWhileSubmitting(WidgetTester tester) async {
    await tester.pumpWidget(buildWidget());
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  group('RenameProductDialog contains widgets', () {
    testWidgets(
      'RenameProductDialog contains the name field prefilled with currentName and actions with the correct parameters',
      (tester) async {
        await openDialog(tester);

        expect(
          find.byKey(const Key('rename-product-name-field')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('rename-product-cancel-button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('rename-product-submit-button')),
          findsOneWidget,
        );
        expect(find.text(t.productDetails.renameProductTitle), findsOneWidget);
        expect(find.text(t.productDetails.renameProductButton), findsOneWidget);
        final ProductFormField nameField = tester.widget(
          find.byKey(const Key('rename-product-name-field')),
        );
        expect(nameField.autofocus, isA<bool>());
        expect(nameField.autofocus, isTrue);
        expect(
          tester
              .widget<TextFormField>(find.byType(TextFormField))
              .controller
              ?.text,
          'Example Product',
        );
      },
    );

    testWidgets(
      'RenameProductDialog contains a "rename-product-error" Text with the correct parameters when renameProductError != null',
      (tester) async {
        when(
          () => mockViewModel.renameProductError,
        ).thenReturn('Something failed');

        await openDialog(tester);

        expect(find.byKey(const Key('rename-product-error')), findsOneWidget);
        expect(find.text('Something failed'), findsOneWidget);
      },
    );
  });

  group("RenameProductDialog's elements behavior", () {
    testWidgets(
      'RenameProductDialog contains a "rename-product-submit-button" FilledButton with the correct behavior',
      (tester) async {
        when(
          () => mockViewModel.onRenameProduct,
        ).thenReturn((name) => print('renamed $name'));

        await openDialog(tester);
        await tester.enterText(
          find.byKey(const Key('rename-product-name-field')),
          'New Name',
        );

        await expectLater(() async {
          await tester.tap(
            find.byKey(const Key('rename-product-submit-button')),
          );
          await tester.pump();
        }, prints('renamed New Name\n'));
      },
    );

    testWidgets(
      'RenameProductDialog contains a "rename-product-name-field" ProductFormField with the correct behavior',
      (tester) async {
        when(
          () => mockViewModel.onRenameProduct,
        ).thenReturn((name) => print('renamed $name'));

        await openDialog(tester);
        await tester.enterText(
          find.byKey(const Key('rename-product-name-field')),
          'New Name',
        );

        await expectLater(
          () => tester.testTextInput.receiveAction(TextInputAction.done),
          prints('renamed New Name\n'),
        );
      },
    );

    testWidgets(
      'RenameProductDialog does not call onRenameProduct via keyboard submit when isRenamingProduct = true',
      (tester) async {
        when(() => mockViewModel.isRenamingProduct).thenReturn(true);
        bool called = false;
        when(
          () => mockViewModel.onRenameProduct,
        ).thenReturn((_) => called = true);

        await openDialogWhileSubmitting(tester);
        await tester.enterText(
          find.byKey(const Key('rename-product-name-field')),
          'New Name',
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);

        expect(called, isFalse);
      },
    );

    testWidgets(
      'RenameProductDialog does not call onRenameProduct when the name is blank',
      (tester) async {
        bool called = false;
        when(
          () => mockViewModel.onRenameProduct,
        ).thenReturn((_) => called = true);

        await openDialog(tester);
        await tester.enterText(
          find.byKey(const Key('rename-product-name-field')),
          '',
        );
        await tester.tap(find.byKey(const Key('rename-product-submit-button')));
        await tester.pumpAndSettle();

        expect(called, isFalse);
        expect(
          find.text(t.productDetails.renameProductRequired),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'RenameProductDialog contains a "rename-product-cancel-button" TextButton with the correct behavior',
      (tester) async {
        await openDialog(tester);

        await tester.tap(find.byKey(const Key('rename-product-cancel-button')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('rename-product-dialog')), findsNothing);
      },
    );

    testWidgets(
      'RenameProductDialog contains a disabled "rename-product-submit-button" FilledButton when isRenamingProduct = true',
      (tester) async {
        when(() => mockViewModel.isRenamingProduct).thenReturn(true);

        await openDialogWhileSubmitting(tester);

        final FilledButton button = tester.widget(
          find.byKey(const Key('rename-product-submit-button')),
        );
        expect(button.onPressed, isNull);
        expect(find.text(t.productDetails.renameProductSaving), findsOneWidget);
      },
    );

    testWidgets(
      'RenameProductDialog contains a disabled "rename-product-cancel-button" TextButton when isRenamingProduct = true',
      (tester) async {
        when(() => mockViewModel.isRenamingProduct).thenReturn(true);

        await openDialogWhileSubmitting(tester);

        final TextButton button = tester.widget(
          find.byKey(const Key('rename-product-cancel-button')),
        );
        expect(button.onPressed, isNull);
      },
    );
  });

  group("RenameProductDialog's translations", () {
    testWidgets('RenameProductDialog displays the Portuguese translations', (
      tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await openDialog(tester);

        expect(find.text(t.productDetails.renameProductTitle), findsOneWidget);
        expect(find.text(t.productDetails.productNameLabel), findsOneWidget);
        expect(find.text(t.common.cancel), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
