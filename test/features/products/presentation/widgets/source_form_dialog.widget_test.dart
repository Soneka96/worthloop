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
import 'package:worth_loop/features/products/presentation/widgets/source_form_dialog.widget.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/features/product_form_field.widget.dart';
import 'package:worth_loop/shared/state/app.state.dart';
import '../../fixtures/product_source.fixture.dart';

class MockProductDetailsViewModel extends Mock
    implements ProductDetailsViewModel {}

void main() {
  late MockProductDetailsViewModel mockViewModel;
  late Store<AppState> store;
  final ProductSource source = buildProductSource(
    id: 'source-1',
    url: 'https://example.com/products/1',
  );

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

  Widget buildWidget({ProductSource? source}) => TranslationProvider(
    child: StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              key: const Key('trigger'),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) =>
                    SourceFormDialog(productId: 'product-1', source: source),
              ),
              child: const Text('trigger'),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> openDialog(WidgetTester tester, {ProductSource? source}) async {
    await tester.pumpWidget(buildWidget(source: source));
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pumpAndSettle();
  }

  /// Opens the dialog with bounded pumps instead of [WidgetTester.pumpAndSettle]
  /// — used when a submitting state is already stubbed at open time, since
  /// the submit button's indeterminate [CircularProgressIndicator] animates
  /// forever and would make pumpAndSettle time out.
  Future<void> openDialogWhileSubmitting(
    WidgetTester tester, {
    ProductSource? source,
  }) async {
    await tester.pumpWidget(buildWidget(source: source));
    await tester.tap(find.byKey(const Key('trigger')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  group('SourceFormDialog contains widgets', () {
    testWidgets(
      'SourceFormDialog contains the url field and actions with the correct parameters when adding',
      (tester) async {
        await openDialog(tester);

        expect(find.byKey(const Key('source-form-url-field')), findsOneWidget);
        expect(
          find.byKey(const Key('source-form-cancel-button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('source-form-submit-button')),
          findsOneWidget,
        );
        expect(find.text(t.productDetails.addSourceTitle), findsOneWidget);
        expect(find.text(t.productDetails.addSourceButton), findsOneWidget);
        final ProductFormField urlField = tester.widget(
          find.byKey(const Key('source-form-url-field')),
        );
        expect(urlField.autofocus, isA<bool>());
        expect(urlField.autofocus, isTrue);
        expect(
          tester
              .widget<TextFormField>(find.byType(TextFormField))
              .controller
              ?.text,
          '',
        );
      },
    );

    testWidgets(
      'SourceFormDialog contains the url field and actions with the correct parameters when editing',
      (tester) async {
        await openDialog(tester, source: source);

        expect(find.text(t.productDetails.editSourceTitle), findsOneWidget);
        expect(find.text(t.productDetails.saveSourceButton), findsOneWidget);
        expect(
          tester
              .widget<TextFormField>(find.byType(TextFormField))
              .controller
              ?.text,
          source.url,
        );
      },
    );

    testWidgets(
      'SourceFormDialog contains a "source-form-error" Text with the correct parameters when addSourceError != null',
      (tester) async {
        when(() => mockViewModel.addSourceError).thenReturn('Something failed');

        await openDialog(tester);

        expect(find.byKey(const Key('source-form-error')), findsOneWidget);
        expect(find.text('Something failed'), findsOneWidget);
      },
    );

    testWidgets(
      'SourceFormDialog contains a "source-form-error" Text with the correct parameters when editSourceError != null',
      (tester) async {
        when(
          () => mockViewModel.editSourceError,
        ).thenReturn('Something failed');

        await openDialog(tester, source: source);

        expect(find.byKey(const Key('source-form-error')), findsOneWidget);
        expect(find.text('Something failed'), findsOneWidget);
      },
    );
  });

  group("SourceFormDialog's elements behavior", () {
    testWidgets(
      'SourceFormDialog contains a "source-form-submit-button" FilledButton with the correct behavior when adding',
      (tester) async {
        when(
          () => mockViewModel.onAddSource,
        ).thenReturn((url) => print('added $url'));

        await openDialog(tester);
        await tester.enterText(
          find.byKey(const Key('source-form-url-field')),
          'https://example.com/products/2',
        );

        await expectLater(() async {
          await tester.tap(find.byKey(const Key('source-form-submit-button')));
          await tester.pump();
        }, prints('added https://example.com/products/2\n'));
      },
    );

    testWidgets(
      'SourceFormDialog contains a "source-form-submit-button" FilledButton with the correct behavior when editing',
      (tester) async {
        when(
          () => mockViewModel.onEditSource,
        ).thenReturn((sourceId, url) => print('edited $sourceId $url'));

        await openDialog(tester, source: source);
        await tester.enterText(
          find.byKey(const Key('source-form-url-field')),
          'https://example.com/products/2',
        );

        await expectLater(() async {
          await tester.tap(find.byKey(const Key('source-form-submit-button')));
          await tester.pump();
        }, prints('edited source-1 https://example.com/products/2\n'));
      },
    );

    testWidgets(
      'SourceFormDialog contains a "source-form-url-field" ProductFormField with the correct behavior',
      (tester) async {
        when(
          () => mockViewModel.onAddSource,
        ).thenReturn((url) => print('added $url'));

        await openDialog(tester);
        await tester.enterText(
          find.byKey(const Key('source-form-url-field')),
          'https://example.com/products/2',
        );

        await expectLater(
          () => tester.testTextInput.receiveAction(TextInputAction.done),
          prints('added https://example.com/products/2\n'),
        );
      },
    );

    testWidgets(
      'SourceFormDialog does not call onAddSource via keyboard submit when isAddingSource = true',
      (tester) async {
        when(() => mockViewModel.isAddingSource).thenReturn(true);
        bool called = false;
        when(() => mockViewModel.onAddSource).thenReturn((_) => called = true);

        await openDialogWhileSubmitting(tester);
        await tester.enterText(
          find.byKey(const Key('source-form-url-field')),
          'https://example.com/products/2',
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);

        expect(called, isFalse);
      },
    );

    testWidgets(
      'SourceFormDialog does not call onEditSource via keyboard submit when editingSourceId = source.id',
      (tester) async {
        when(() => mockViewModel.editingSourceId).thenReturn(source.id);
        bool called = false;
        when(
          () => mockViewModel.onEditSource,
        ).thenReturn((_, _) => called = true);

        await openDialogWhileSubmitting(tester, source: source);
        await tester.enterText(
          find.byKey(const Key('source-form-url-field')),
          'https://example.com/products/2',
        );
        await tester.testTextInput.receiveAction(TextInputAction.done);

        expect(called, isFalse);
      },
    );

    testWidgets(
      'SourceFormDialog calls onEditSource when editingSourceId = a different source id',
      (tester) async {
        when(() => mockViewModel.editingSourceId).thenReturn('source-2');
        bool called = false;
        when(
          () => mockViewModel.onEditSource,
        ).thenReturn((_, _) => called = true);

        await openDialog(tester, source: source);
        await tester.enterText(
          find.byKey(const Key('source-form-url-field')),
          'https://example.com/products/2',
        );
        await tester.tap(find.byKey(const Key('source-form-submit-button')));
        await tester.pump();

        expect(called, isTrue);
      },
    );

    testWidgets(
      'SourceFormDialog does not call onAddSource when the url is blank',
      (tester) async {
        bool called = false;
        when(() => mockViewModel.onAddSource).thenReturn((_) => called = true);

        await openDialog(tester);
        await tester.tap(find.byKey(const Key('source-form-submit-button')));
        await tester.pumpAndSettle();

        expect(called, isFalse);
        expect(find.text(t.productDetails.sourceUrlRequired), findsOneWidget);
      },
    );

    testWidgets(
      'SourceFormDialog does not call onEditSource when the url is blank',
      (tester) async {
        bool called = false;
        when(
          () => mockViewModel.onEditSource,
        ).thenReturn((_, _) => called = true);

        await openDialog(tester, source: source);
        await tester.enterText(
          find.byKey(const Key('source-form-url-field')),
          '',
        );
        await tester.tap(find.byKey(const Key('source-form-submit-button')));
        await tester.pumpAndSettle();

        expect(called, isFalse);
        expect(find.text(t.productDetails.sourceUrlRequired), findsOneWidget);
      },
    );

    testWidgets(
      'SourceFormDialog contains a "source-form-cancel-button" TextButton with the correct behavior',
      (tester) async {
        await openDialog(tester);

        await tester.tap(find.byKey(const Key('source-form-cancel-button')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('source-form-dialog')), findsNothing);
      },
    );

    testWidgets(
      'SourceFormDialog contains a disabled "source-form-submit-button" FilledButton when isAddingSource = true',
      (tester) async {
        when(() => mockViewModel.isAddingSource).thenReturn(true);

        await openDialogWhileSubmitting(tester);

        final FilledButton button = tester.widget(
          find.byKey(const Key('source-form-submit-button')),
        );
        expect(button.onPressed, isNull);
        expect(find.text(t.productDetails.savingSource), findsOneWidget);
      },
    );

    testWidgets(
      'SourceFormDialog contains a disabled "source-form-cancel-button" TextButton when isAddingSource = true',
      (tester) async {
        when(() => mockViewModel.isAddingSource).thenReturn(true);

        await openDialogWhileSubmitting(tester);

        final TextButton button = tester.widget(
          find.byKey(const Key('source-form-cancel-button')),
        );
        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'SourceFormDialog contains a disabled "source-form-submit-button" FilledButton when editingSourceId matches source.id',
      (tester) async {
        when(() => mockViewModel.editingSourceId).thenReturn(source.id);

        await openDialogWhileSubmitting(tester, source: source);

        final FilledButton button = tester.widget(
          find.byKey(const Key('source-form-submit-button')),
        );
        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'SourceFormDialog contains a disabled "source-form-cancel-button" TextButton when editingSourceId matches source.id',
      (tester) async {
        when(() => mockViewModel.editingSourceId).thenReturn(source.id);

        await openDialogWhileSubmitting(tester, source: source);

        final TextButton button = tester.widget(
          find.byKey(const Key('source-form-cancel-button')),
        );
        expect(button.onPressed, isNull);
      },
    );
  });

  group("SourceFormDialog's translations", () {
    testWidgets('displays the correct translations', (
      tester,
    ) async {
      await openDialog(tester);

      expect(find.text(t.productDetails.addSourceTitle), findsOneWidget);
      expect(find.text(t.productDetails.sourceUrlLabel), findsOneWidget);
      expect(find.text(t.common.cancel), findsOneWidget);
    });
  });
}
