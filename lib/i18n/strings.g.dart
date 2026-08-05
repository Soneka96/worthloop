/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 146 (73 per locale)
///
/// Built on 2026-08-04 at 17:32 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	pt(languageCode: 'pt', build: _StringsPt.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get appTitle => 'WorthLoop';
	late final _StringsHomeEn home = _StringsHomeEn._(_root);
	late final _StringsProductDetailsEn productDetails = _StringsProductDetailsEn._(_root);
	late final _StringsSettingsEn settings = _StringsSettingsEn._(_root);
	late final _StringsEnumsEn enums = _StringsEnumsEn._(_root);
}

// Path: home
class _StringsHomeEn {
	_StringsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'Your watchlist, with the best current offer first.';
	String get sampleDataNotice => 'Demo prices — local sample data, not live offers.';
	String trackedProducts({required Object count}) => '${count} tracked';
	String get refreshAll => 'Refresh all';
	String get refreshing => 'Refreshing';
	String get bestPrice => 'Best price';
	String get noAvailablePrice => 'No available price';
	String get noStore => 'No store in stock';
	String storeOffers({required Object count}) => 'Offers: ${count}';
	String updatedAt({required Object time}) => 'Updated ${time}';
	String get emptyTitle => 'No tracked products';
	String get emptyDescription => 'Products you track will appear here with their best available offer.';
	String get addProductTitle => 'Add a product';
	String get addProductDescription => 'Paste a product link to start tracking it.';
	String get productNameLabel => 'Product name';
	String get productUrlLabel => 'Product website link';
	String get productUrlHint => 'https://example.com/product';
	String get productNameRequired => 'Enter a product name.';
	String get productUrlInvalid => 'Enter a valid HTTPS website link.';
	String get addProductButton => 'Add product';
	String get addProductSaving => 'Saving';
	String get productSourceSupportDescription => 'Links can be saved now. Automatic price updates are available only for supported websites.';
}

// Path: productDetails
class _StringsProductDetailsEn {
	_StringsProductDetailsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Product details';
	String get backTooltip => 'Back';
	String get refresh => 'Refresh';
	String get refreshing => 'Refreshing';
	String get bestPrice => 'Best price';
	String offers({required Object count}) => 'Store offers: ${count}';
	String get availableOffers => 'Available offers';
	String get unavailableOffers => 'Unavailable offers';
	String get unavailableDescription => 'These stores currently report no stock.';
	String get noOffers => 'No offers yet.';
	String get available => 'In stock';
	String get unavailable => 'Out of stock';
	String checkedAt({required Object time}) => 'Checked at ${time}';
	String get productNotFound => 'Product not found';
	String get productNotFoundDescription => 'Return to your tracked products and choose an item again.';
}

// Path: settings
class _StringsSettingsEn {
	_StringsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	late final _StringsSettingsAppearanceEn appearance = _StringsSettingsAppearanceEn._(_root);
	late final _StringsSettingsGeneralEn general = _StringsSettingsGeneralEn._(_root);
}

// Path: enums
class _StringsEnumsEn {
	_StringsEnumsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsEnumsCornerStyleEn cornerStyle = _StringsEnumsCornerStyleEn._(_root);
	late final _StringsEnumsSpacingDensityEn spacingDensity = _StringsEnumsSpacingDensityEn._(_root);
	late final _StringsEnumsSettingsCategoryEn settingsCategory = _StringsEnumsSettingsCategoryEn._(_root);
}

// Path: settings.appearance
class _StringsSettingsAppearanceEn {
	_StringsSettingsAppearanceEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Appearance';
	String get theme => 'Theme';
	String get cornerStyle => 'Corner style';
	String get density => 'Density';
	String get font => 'Font';
	String get zoom => 'Text Size';
	String get dark => 'Dark';
	String get light => 'Light';
	String get active => 'Active';
	String activateThemeSemantics({required Object label}) => 'Activate ${label} theme';
	String get zoomLevelSemantics => 'Text size';
}

// Path: settings.general
class _StringsSettingsGeneralEn {
	_StringsSettingsGeneralEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'General';
	late final _StringsSettingsGeneralLanguageEn language = _StringsSettingsGeneralLanguageEn._(_root);
	late final _StringsSettingsGeneralRefreshIntervalEn refreshInterval = _StringsSettingsGeneralRefreshIntervalEn._(_root);
	late final _StringsSettingsGeneralUpdatesEn updates = _StringsSettingsGeneralUpdatesEn._(_root);
	late final _StringsSettingsGeneralAboutEn about = _StringsSettingsGeneralAboutEn._(_root);
}

// Path: enums.cornerStyle
class _StringsEnumsCornerStyleEn {
	_StringsEnumsCornerStyleEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get rounded => 'Rounded';
	String get square => 'Square';
}

// Path: enums.spacingDensity
class _StringsEnumsSpacingDensityEn {
	_StringsEnumsSpacingDensityEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get comfortable => 'Comfortable';
	String get compact => 'Compact';
}

// Path: enums.settingsCategory
class _StringsEnumsSettingsCategoryEn {
	_StringsEnumsSettingsCategoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get general => 'General';
	String get appearance => 'Appearance';
}

// Path: settings.general.language
class _StringsSettingsGeneralLanguageEn {
	_StringsSettingsGeneralLanguageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Language';
}

// Path: settings.general.refreshInterval
class _StringsSettingsGeneralRefreshIntervalEn {
	_StringsSettingsGeneralRefreshIntervalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Refresh interval';
	String get description => 'Saved now for automatic refresh support later. Background refresh is not active yet.';
	String get hourly => 'Every hour';
	String get everyThreeHours => 'Every 3 hours';
	String get everySixHours => 'Every 6 hours';
	String get everyTwelveHours => 'Every 12 hours';
}

// Path: settings.general.updates
class _StringsSettingsGeneralUpdatesEn {
	_StringsSettingsGeneralUpdatesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Updates';
	String version({required Object version}) => 'Version ${version}';
	String get checkForUpdates => 'Check for updates';
	String get description => 'Update checking will be added later.';
	String get notImplemented => 'Checking for updates is not implemented yet.';
}

// Path: settings.general.about
class _StringsSettingsGeneralAboutEn {
	_StringsSettingsGeneralAboutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'About';
	String get copyright => '© 2026 Soneka96';
	String get privacyPolicy => 'Privacy & data use';
	String get notImplemented => 'Privacy & data use is not implemented yet.';
}

// Path: <root>
class _StringsPt implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsPt.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.pt,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pt>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsPt _root = this; // ignore: unused_field

	// Translations
	@override String get appTitle => 'WorthLoop';
	@override late final _StringsHomePt home = _StringsHomePt._(_root);
	@override late final _StringsProductDetailsPt productDetails = _StringsProductDetailsPt._(_root);
	@override late final _StringsSettingsPt settings = _StringsSettingsPt._(_root);
	@override late final _StringsEnumsPt enums = _StringsEnumsPt._(_root);
}

// Path: home
class _StringsHomePt implements _StringsHomeEn {
	_StringsHomePt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'A sua lista, com a melhor oferta atual em primeiro lugar.';
	@override String get sampleDataNotice => 'Preços de demonstração — dados de exemplo locais, não são ofertas em tempo real.';
	@override String trackedProducts({required Object count}) => '${count} acompanhados';
	@override String get refreshAll => 'Atualizar todos';
	@override String get refreshing => 'A atualizar';
	@override String get bestPrice => 'Melhor preço';
	@override String get noAvailablePrice => 'Sem preço disponível';
	@override String get noStore => 'Nenhuma loja com stock';
	@override String storeOffers({required Object count}) => 'Ofertas: ${count}';
	@override String updatedAt({required Object time}) => 'Atualizado às ${time}';
	@override String get emptyTitle => 'Nenhum produto acompanhado';
	@override String get emptyDescription => 'Os produtos acompanhados aparecem aqui com a melhor oferta disponível.';
	@override String get addProductTitle => 'Adicionar produto';
	@override String get addProductDescription => 'Cole um link de produto para comeÃ§ar a acompanhÃ¡-lo.';
	@override String get productNameLabel => 'Nome do produto';
	@override String get productUrlLabel => 'Link do produto';
	@override String get productUrlHint => 'https://exemplo.com/produto';
	@override String get productNameRequired => 'Introduza o nome do produto.';
	@override String get productUrlInvalid => 'Introduza um link HTTPS vÃ¡lido.';
	@override String get addProductButton => 'Adicionar produto';
	@override String get addProductSaving => 'A guardar';
	@override String get productSourceSupportDescription => 'Os links podem ser guardados agora. A atualização automática só está disponível para sites suportados.';
}

// Path: productDetails
class _StringsProductDetailsPt implements _StringsProductDetailsEn {
	_StringsProductDetailsPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Detalhes do produto';
	@override String get backTooltip => 'Voltar';
	@override String get refresh => 'Atualizar';
	@override String get refreshing => 'A atualizar';
	@override String get bestPrice => 'Melhor preço';
	@override String offers({required Object count}) => 'Ofertas em lojas: ${count}';
	@override String get availableOffers => 'Ofertas disponíveis';
	@override String get unavailableOffers => 'Ofertas sem stock';
	@override String get unavailableDescription => 'Estas lojas indicam que não têm stock neste momento.';
	@override String get noOffers => 'Ainda não existem ofertas.';
	@override String get available => 'Em stock';
	@override String get unavailable => 'Sem stock';
	@override String checkedAt({required Object time}) => 'Verificado às ${time}';
	@override String get productNotFound => 'Produto não encontrado';
	@override String get productNotFoundDescription => 'Volte aos produtos acompanhados e escolha novamente um artigo.';
}

// Path: settings
class _StringsSettingsPt implements _StringsSettingsEn {
	_StringsSettingsPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Definições';
	@override late final _StringsSettingsAppearancePt appearance = _StringsSettingsAppearancePt._(_root);
	@override late final _StringsSettingsGeneralPt general = _StringsSettingsGeneralPt._(_root);
}

// Path: enums
class _StringsEnumsPt implements _StringsEnumsEn {
	_StringsEnumsPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override late final _StringsEnumsCornerStylePt cornerStyle = _StringsEnumsCornerStylePt._(_root);
	@override late final _StringsEnumsSpacingDensityPt spacingDensity = _StringsEnumsSpacingDensityPt._(_root);
	@override late final _StringsEnumsSettingsCategoryPt settingsCategory = _StringsEnumsSettingsCategoryPt._(_root);
}

// Path: settings.appearance
class _StringsSettingsAppearancePt implements _StringsSettingsAppearanceEn {
	_StringsSettingsAppearancePt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Aparência';
	@override String get theme => 'Tema';
	@override String get cornerStyle => 'Estilo de cantos';
	@override String get density => 'Densidade';
	@override String get font => 'Tipo de letra';
	@override String get zoom => 'Tamanho do texto';
	@override String get dark => 'Escuro';
	@override String get light => 'Claro';
	@override String get active => 'Ativo';
	@override String activateThemeSemantics({required Object label}) => 'Ativar tema ${label}';
	@override String get zoomLevelSemantics => 'Tamanho do texto';
}

// Path: settings.general
class _StringsSettingsGeneralPt implements _StringsSettingsGeneralEn {
	_StringsSettingsGeneralPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Geral';
	@override late final _StringsSettingsGeneralLanguagePt language = _StringsSettingsGeneralLanguagePt._(_root);
	@override late final _StringsSettingsGeneralRefreshIntervalPt refreshInterval = _StringsSettingsGeneralRefreshIntervalPt._(_root);
	@override late final _StringsSettingsGeneralUpdatesPt updates = _StringsSettingsGeneralUpdatesPt._(_root);
	@override late final _StringsSettingsGeneralAboutPt about = _StringsSettingsGeneralAboutPt._(_root);
}

// Path: enums.cornerStyle
class _StringsEnumsCornerStylePt implements _StringsEnumsCornerStyleEn {
	_StringsEnumsCornerStylePt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get rounded => 'Arredondado';
	@override String get square => 'Quadrado';
}

// Path: enums.spacingDensity
class _StringsEnumsSpacingDensityPt implements _StringsEnumsSpacingDensityEn {
	_StringsEnumsSpacingDensityPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get comfortable => 'Confortável';
	@override String get compact => 'Compacto';
}

// Path: enums.settingsCategory
class _StringsEnumsSettingsCategoryPt implements _StringsEnumsSettingsCategoryEn {
	_StringsEnumsSettingsCategoryPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get general => 'Geral';
	@override String get appearance => 'Aparência';
}

// Path: settings.general.language
class _StringsSettingsGeneralLanguagePt implements _StringsSettingsGeneralLanguageEn {
	_StringsSettingsGeneralLanguagePt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idioma';
}

// Path: settings.general.refreshInterval
class _StringsSettingsGeneralRefreshIntervalPt implements _StringsSettingsGeneralRefreshIntervalEn {
	_StringsSettingsGeneralRefreshIntervalPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Intervalo de atualização';
	@override String get description => 'Guardado agora para suportar a atualização automática mais tarde. A atualização em segundo plano ainda não está ativa.';
	@override String get hourly => 'A cada hora';
	@override String get everyThreeHours => 'A cada 3 horas';
	@override String get everySixHours => 'A cada 6 horas';
	@override String get everyTwelveHours => 'A cada 12 horas';
}

// Path: settings.general.updates
class _StringsSettingsGeneralUpdatesPt implements _StringsSettingsGeneralUpdatesEn {
	_StringsSettingsGeneralUpdatesPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Atualizações';
	@override String version({required Object version}) => 'Versão ${version}';
	@override String get checkForUpdates => 'Verificar atualizações';
	@override String get description => 'A verificação de atualizações será adicionada mais tarde.';
	@override String get notImplemented => 'Verificar atualizações ainda não está implementado.';
}

// Path: settings.general.about
class _StringsSettingsGeneralAboutPt implements _StringsSettingsGeneralAboutEn {
	_StringsSettingsGeneralAboutPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Acerca';
	@override String get copyright => '© 2026 Soneka96';
	@override String get privacyPolicy => 'Privacidade e utilização de dados';
	@override String get notImplemented => 'Privacidade e utilização de dados ainda não está implementado.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'WorthLoop';
			case 'home.subtitle': return 'Your watchlist, with the best current offer first.';
			case 'home.sampleDataNotice': return 'Demo prices — local sample data, not live offers.';
			case 'home.trackedProducts': return ({required Object count}) => '${count} tracked';
			case 'home.refreshAll': return 'Refresh all';
			case 'home.refreshing': return 'Refreshing';
			case 'home.bestPrice': return 'Best price';
			case 'home.noAvailablePrice': return 'No available price';
			case 'home.noStore': return 'No store in stock';
			case 'home.storeOffers': return ({required Object count}) => 'Offers: ${count}';
			case 'home.updatedAt': return ({required Object time}) => 'Updated ${time}';
			case 'home.emptyTitle': return 'No tracked products';
			case 'home.emptyDescription': return 'Products you track will appear here with their best available offer.';
			case 'home.addProductTitle': return 'Add a product';
			case 'home.addProductDescription': return 'Paste a product link to start tracking it.';
			case 'home.productNameLabel': return 'Product name';
			case 'home.productUrlLabel': return 'Product website link';
			case 'home.productUrlHint': return 'https://example.com/product';
			case 'home.productNameRequired': return 'Enter a product name.';
			case 'home.productUrlInvalid': return 'Enter a valid HTTPS website link.';
			case 'home.addProductButton': return 'Add product';
			case 'home.addProductSaving': return 'Saving';
			case 'home.productSourceSupportDescription': return 'Links can be saved now. Automatic price updates are available only for supported websites.';
			case 'productDetails.title': return 'Product details';
			case 'productDetails.backTooltip': return 'Back';
			case 'productDetails.refresh': return 'Refresh';
			case 'productDetails.refreshing': return 'Refreshing';
			case 'productDetails.bestPrice': return 'Best price';
			case 'productDetails.offers': return ({required Object count}) => 'Store offers: ${count}';
			case 'productDetails.availableOffers': return 'Available offers';
			case 'productDetails.unavailableOffers': return 'Unavailable offers';
			case 'productDetails.unavailableDescription': return 'These stores currently report no stock.';
			case 'productDetails.noOffers': return 'No offers yet.';
			case 'productDetails.available': return 'In stock';
			case 'productDetails.unavailable': return 'Out of stock';
			case 'productDetails.checkedAt': return ({required Object time}) => 'Checked at ${time}';
			case 'productDetails.productNotFound': return 'Product not found';
			case 'productDetails.productNotFoundDescription': return 'Return to your tracked products and choose an item again.';
			case 'settings.title': return 'Settings';
			case 'settings.appearance.title': return 'Appearance';
			case 'settings.appearance.theme': return 'Theme';
			case 'settings.appearance.cornerStyle': return 'Corner style';
			case 'settings.appearance.density': return 'Density';
			case 'settings.appearance.font': return 'Font';
			case 'settings.appearance.zoom': return 'Text Size';
			case 'settings.appearance.dark': return 'Dark';
			case 'settings.appearance.light': return 'Light';
			case 'settings.appearance.active': return 'Active';
			case 'settings.appearance.activateThemeSemantics': return ({required Object label}) => 'Activate ${label} theme';
			case 'settings.appearance.zoomLevelSemantics': return 'Text size';
			case 'settings.general.title': return 'General';
			case 'settings.general.language.title': return 'Language';
			case 'settings.general.refreshInterval.title': return 'Refresh interval';
			case 'settings.general.refreshInterval.description': return 'Saved now for automatic refresh support later. Background refresh is not active yet.';
			case 'settings.general.refreshInterval.hourly': return 'Every hour';
			case 'settings.general.refreshInterval.everyThreeHours': return 'Every 3 hours';
			case 'settings.general.refreshInterval.everySixHours': return 'Every 6 hours';
			case 'settings.general.refreshInterval.everyTwelveHours': return 'Every 12 hours';
			case 'settings.general.updates.title': return 'Updates';
			case 'settings.general.updates.version': return ({required Object version}) => 'Version ${version}';
			case 'settings.general.updates.checkForUpdates': return 'Check for updates';
			case 'settings.general.updates.description': return 'Update checking will be added later.';
			case 'settings.general.updates.notImplemented': return 'Checking for updates is not implemented yet.';
			case 'settings.general.about.title': return 'About';
			case 'settings.general.about.copyright': return '© 2026 Soneka96';
			case 'settings.general.about.privacyPolicy': return 'Privacy & data use';
			case 'settings.general.about.notImplemented': return 'Privacy & data use is not implemented yet.';
			case 'enums.cornerStyle.rounded': return 'Rounded';
			case 'enums.cornerStyle.square': return 'Square';
			case 'enums.spacingDensity.comfortable': return 'Comfortable';
			case 'enums.spacingDensity.compact': return 'Compact';
			case 'enums.settingsCategory.general': return 'General';
			case 'enums.settingsCategory.appearance': return 'Appearance';
			default: return null;
		}
	}
}

extension on _StringsPt {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'WorthLoop';
			case 'home.subtitle': return 'A sua lista, com a melhor oferta atual em primeiro lugar.';
			case 'home.sampleDataNotice': return 'Preços de demonstração — dados de exemplo locais, não são ofertas em tempo real.';
			case 'home.trackedProducts': return ({required Object count}) => '${count} acompanhados';
			case 'home.refreshAll': return 'Atualizar todos';
			case 'home.refreshing': return 'A atualizar';
			case 'home.bestPrice': return 'Melhor preço';
			case 'home.noAvailablePrice': return 'Sem preço disponível';
			case 'home.noStore': return 'Nenhuma loja com stock';
			case 'home.storeOffers': return ({required Object count}) => 'Ofertas: ${count}';
			case 'home.updatedAt': return ({required Object time}) => 'Atualizado às ${time}';
			case 'home.emptyTitle': return 'Nenhum produto acompanhado';
			case 'home.emptyDescription': return 'Os produtos acompanhados aparecem aqui com a melhor oferta disponível.';
			case 'home.addProductTitle': return 'Adicionar produto';
			case 'home.addProductDescription': return 'Cole um link de produto para comeÃ§ar a acompanhÃ¡-lo.';
			case 'home.productNameLabel': return 'Nome do produto';
			case 'home.productUrlLabel': return 'Link do produto';
			case 'home.productUrlHint': return 'https://exemplo.com/produto';
			case 'home.productNameRequired': return 'Introduza o nome do produto.';
			case 'home.productUrlInvalid': return 'Introduza um link HTTPS vÃ¡lido.';
			case 'home.addProductButton': return 'Adicionar produto';
			case 'home.addProductSaving': return 'A guardar';
			case 'home.productSourceSupportDescription': return 'Os links podem ser guardados agora. A atualização automática só está disponível para sites suportados.';
			case 'productDetails.title': return 'Detalhes do produto';
			case 'productDetails.backTooltip': return 'Voltar';
			case 'productDetails.refresh': return 'Atualizar';
			case 'productDetails.refreshing': return 'A atualizar';
			case 'productDetails.bestPrice': return 'Melhor preço';
			case 'productDetails.offers': return ({required Object count}) => 'Ofertas em lojas: ${count}';
			case 'productDetails.availableOffers': return 'Ofertas disponíveis';
			case 'productDetails.unavailableOffers': return 'Ofertas sem stock';
			case 'productDetails.unavailableDescription': return 'Estas lojas indicam que não têm stock neste momento.';
			case 'productDetails.noOffers': return 'Ainda não existem ofertas.';
			case 'productDetails.available': return 'Em stock';
			case 'productDetails.unavailable': return 'Sem stock';
			case 'productDetails.checkedAt': return ({required Object time}) => 'Verificado às ${time}';
			case 'productDetails.productNotFound': return 'Produto não encontrado';
			case 'productDetails.productNotFoundDescription': return 'Volte aos produtos acompanhados e escolha novamente um artigo.';
			case 'settings.title': return 'Definições';
			case 'settings.appearance.title': return 'Aparência';
			case 'settings.appearance.theme': return 'Tema';
			case 'settings.appearance.cornerStyle': return 'Estilo de cantos';
			case 'settings.appearance.density': return 'Densidade';
			case 'settings.appearance.font': return 'Tipo de letra';
			case 'settings.appearance.zoom': return 'Tamanho do texto';
			case 'settings.appearance.dark': return 'Escuro';
			case 'settings.appearance.light': return 'Claro';
			case 'settings.appearance.active': return 'Ativo';
			case 'settings.appearance.activateThemeSemantics': return ({required Object label}) => 'Ativar tema ${label}';
			case 'settings.appearance.zoomLevelSemantics': return 'Tamanho do texto';
			case 'settings.general.title': return 'Geral';
			case 'settings.general.language.title': return 'Idioma';
			case 'settings.general.refreshInterval.title': return 'Intervalo de atualização';
			case 'settings.general.refreshInterval.description': return 'Guardado agora para suportar a atualização automática mais tarde. A atualização em segundo plano ainda não está ativa.';
			case 'settings.general.refreshInterval.hourly': return 'A cada hora';
			case 'settings.general.refreshInterval.everyThreeHours': return 'A cada 3 horas';
			case 'settings.general.refreshInterval.everySixHours': return 'A cada 6 horas';
			case 'settings.general.refreshInterval.everyTwelveHours': return 'A cada 12 horas';
			case 'settings.general.updates.title': return 'Atualizações';
			case 'settings.general.updates.version': return ({required Object version}) => 'Versão ${version}';
			case 'settings.general.updates.checkForUpdates': return 'Verificar atualizações';
			case 'settings.general.updates.description': return 'A verificação de atualizações será adicionada mais tarde.';
			case 'settings.general.updates.notImplemented': return 'Verificar atualizações ainda não está implementado.';
			case 'settings.general.about.title': return 'Acerca';
			case 'settings.general.about.copyright': return '© 2026 Soneka96';
			case 'settings.general.about.privacyPolicy': return 'Privacidade e utilização de dados';
			case 'settings.general.about.notImplemented': return 'Privacidade e utilização de dados ainda não está implementado.';
			case 'enums.cornerStyle.rounded': return 'Arredondado';
			case 'enums.cornerStyle.square': return 'Quadrado';
			case 'enums.spacingDensity.comfortable': return 'Confortável';
			case 'enums.spacingDensity.compact': return 'Compacto';
			case 'enums.settingsCategory.general': return 'Geral';
			case 'enums.settingsCategory.appearance': return 'Aparência';
			default: return null;
		}
	}
}
