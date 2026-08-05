// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/features/home/presentation/widgets/add_product_dialog.widget.dart';
import 'package:worth_loop/features/home/presentation/widgets/product_form_field.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';

class MockHomeScreenViewModel extends Mock implements HomeScreenViewModel {}

void main() {
  late MockHomeScreenViewModel mockViewModel;
  late Store<AppState> store;

  setUp(() {
    mockViewModel = MockHomeScreenViewModel();
    when(() => mockViewModel.isCreatingProduct).thenReturn(false);
    when(() => mockViewModel.productCreationError).thenReturn(null);
    when(() => mockViewModel.createdProductId).thenReturn(null);
    when(() => mockViewModel.onCreateProduct).thenReturn((_) {});

    sl.registerFactoryParam<HomeScreenViewModel, Store<AppState>, void>(
      (store, _) => mockViewModel,
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
                builder: (context) => const AddProductDialog(),
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
  /// — used when `isCreatingProduct = true` is already stubbed at open time,
  /// since the submit button's indeterminate [CircularProgressIndicator]
  /// animates forever and would make pumpAndSettle time out.
  Future<void> openDialogWhileSubmitting(WidgetTester tester) async {
    await tester.pumpWidget(buildWidget());
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  group('AddProductDialog contains widgets', () {
    testWidgets(
      'AddProductDialog contains the name field and actions with the correct parameters',
      (tester) async {
        await openDialog(tester);

        expect(find.byKey(const Key('add-product-name-field')), findsOneWidget);
        expect(
          find.byKey(const Key('add-product-cancel-button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('add-product-submit-button')),
          findsOneWidget,
        );
        expect(find.text(t.home.addProductTitle), findsOneWidget);
        expect(find.text(t.home.addProductButton), findsOneWidget);
        final ProductFormField nameField = tester.widget(
          find.byKey(const Key('add-product-name-field')),
        );
        expect(nameField.autofocus, isA<bool>());
        expect(nameField.autofocus, isTrue);
      },
    );

    testWidgets(
      'AddProductDialog contains an "add-product-error" Text with the correct parameters when productCreationError != null',
      (tester) async {
        when(
          () => mockViewModel.productCreationError,
        ).thenReturn('Something failed');

        await openDialog(tester);

        expect(find.byKey(const Key('add-product-error')), findsOneWidget);
        expect(find.text('Something failed'), findsOneWidget);
      },
    );
  });

  group("AddProductDialog's elements behavior", () {
    testWidgets(
      'AddProductDialog contains a "add-product-submit-button" FilledButton with the correct behavior',
      (tester) async {
        when(
          () => mockViewModel.onCreateProduct,
        ).thenReturn((name) => print('created $name'));

        await openDialog(tester);
        await tester.enterText(
          find.byKey(const Key('add-product-name-field')),
          'Example Product',
        );

        await expectLater(() async {
          await tester.tap(find.byKey(const Key('add-product-submit-button')));
          await tester.pump();
        }, prints('created Example Product\n'));
      },
    );

    testWidgets(
      'AddProductDialog contains a "add-product-name-field" ProductFormField with the correct behavior',
      (tester) async {
        when(
          () => mockViewModel.onCreateProduct,
        ).thenReturn((name) => print('created $name'));

        await openDialog(tester);
        await tester.enterText(
          find.byKey(const Key('add-product-name-field')),
          'Example Product',
        );

        await expectLater(
          () => tester.testTextInput.receiveAction(TextInputAction.done),
          prints('created Example Product\n'),
        );
      },
    );

    testWidgets(
      'AddProductDialog does not call onCreateProduct via keyboard submit when isCreatingProduct = true',
      (tester) async {
        when(() => mockViewModel.isCreatingProduct).thenReturn(true);
        bool called = false;
        when(
          () => mockViewModel.onCreateProduct,
        ).thenReturn((_) => called = true);

        await openDialogWhileSubmitting(tester);
        await tester.enterText(
          find.byKey(const Key('add-product-name-field')),
          'Example Product',
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);

        expect(called, isFalse);
      },
    );

    testWidgets(
      'AddProductDialog does not call onCreateProduct when the name is blank',
      (tester) async {
        bool called = false;
        when(
          () => mockViewModel.onCreateProduct,
        ).thenReturn((_) => called = true);

        await openDialog(tester);
        await tester.tap(find.byKey(const Key('add-product-submit-button')));
        await tester.pumpAndSettle();

        expect(called, isFalse);
        expect(find.text(t.home.productNameRequired), findsOneWidget);
      },
    );

    testWidgets(
      'AddProductDialog contains a "add-product-cancel-button" TextButton with the correct behavior',
      (tester) async {
        await openDialog(tester);

        await tester.tap(find.byKey(const Key('add-product-cancel-button')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('add-product-dialog')), findsNothing);
      },
    );

    testWidgets(
      'AddProductDialog contains a disabled "add-product-submit-button" FilledButton when isCreatingProduct = true',
      (tester) async {
        when(() => mockViewModel.isCreatingProduct).thenReturn(true);

        await openDialogWhileSubmitting(tester);

        final FilledButton button = tester.widget(
          find.byKey(const Key('add-product-submit-button')),
        );
        expect(button.onPressed, isNull);
        expect(find.text(t.home.addProductSaving), findsOneWidget);
      },
    );

    testWidgets(
      'AddProductDialog contains a disabled "add-product-cancel-button" TextButton when isCreatingProduct = true',
      (tester) async {
        when(() => mockViewModel.isCreatingProduct).thenReturn(true);

        await openDialogWhileSubmitting(tester);

        final TextButton button = tester.widget(
          find.byKey(const Key('add-product-cancel-button')),
        );
        expect(button.onPressed, isNull);
      },
    );
  });

  group("AddProductDialog's translations", () {
    testWidgets('AddProductDialog displays the Portuguese translations', (
      tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await openDialog(tester);

        // addProductTitle and addProductButton share the same Portuguese
        // string ("Adicionar produto"), so both widgets match this finder.
        expect(find.text(t.home.addProductTitle), findsWidgets);
        expect(find.text(t.home.productNameLabel), findsOneWidget);
        expect(find.text(t.common.cancel), findsOneWidget);
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
