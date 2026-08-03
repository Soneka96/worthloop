/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 146 (73 per locale)
///
/// Built on 2026-07-11 at 19:44 UTC

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
	String get appTitle => 'Clean Architecture Starter';
	late final _StringsHomeEn home = _StringsHomeEn._(_root);
	late final _StringsGithubExplorerEn githubExplorer = _StringsGithubExplorerEn._(_root);
	late final _StringsSettingsEn settings = _StringsSettingsEn._(_root);
	late final _StringsEnumsEn enums = _StringsEnumsEn._(_root);
}

// Path: home
class _StringsHomeEn {
	_StringsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get subtitle => 'A GitHub Explorer demo, ready to search.';
	String get startSearching => 'Start searching';
}

// Path: githubExplorer
class _StringsGithubExplorerEn {
	_StringsGithubExplorerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'GitHub Explorer';
	String get searchHint => 'Search a GitHub username';
	String get searchButton => 'Search';
	String get noResultYet => 'Search a username to see their profile and top repositories.';
	String publicRepos({required Object count}) => '${count} public repos';
	String followers({required Object count}) => '${count} followers';
	String get topRepos => 'Top repositories';
	String get noRepos => 'This user has no public repositories.';
	String get recentSearches => 'Recent searches';
	String get noRecentSearches => 'Nothing searched yet.';
	String get favoriteSemantics => 'Toggle favorite';
	String get settingsTooltip => 'Settings';
	String get goHomeTooltip => 'Home';
	String errorPrefix({required Object username}) => 'Couldn\'t load ${username}:';
}

// Path: settings
class _StringsSettingsEn {
	_StringsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	late final _StringsSettingsAppearanceEn appearance = _StringsSettingsAppearanceEn._(_root);
	late final _StringsSettingsGeneralEn general = _StringsSettingsGeneralEn._(_root);
	late final _StringsSettingsLogsEn logs = _StringsSettingsLogsEn._(_root);
}

// Path: enums
class _StringsEnumsEn {
	_StringsEnumsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsEnumsCornerStyleEn cornerStyle = _StringsEnumsCornerStyleEn._(_root);
	late final _StringsEnumsSpacingDensityEn spacingDensity = _StringsEnumsSpacingDensityEn._(_root);
	late final _StringsEnumsSettingsCategoryEn settingsCategory = _StringsEnumsSettingsCategoryEn._(_root);
	late final _StringsEnumsLogLevelEn logLevel = _StringsEnumsLogLevelEn._(_root);
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
	late final _StringsSettingsGeneralDefaultSaveLocationEn defaultSaveLocation = _StringsSettingsGeneralDefaultSaveLocationEn._(_root);
	late final _StringsSettingsGeneralLanguageEn language = _StringsSettingsGeneralLanguageEn._(_root);
	late final _StringsSettingsGeneralUpdatesEn updates = _StringsSettingsGeneralUpdatesEn._(_root);
	late final _StringsSettingsGeneralAboutEn about = _StringsSettingsGeneralAboutEn._(_root);
}

// Path: settings.logs
class _StringsSettingsLogsEn {
	_StringsSettingsLogsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Logs';
	late final _StringsSettingsLogsLocationEn location = _StringsSettingsLogsLocationEn._(_root);
	late final _StringsSettingsLogsSearchEn search = _StringsSettingsLogsSearchEn._(_root);
	String get filterAll => 'All';
	String get export => 'Export logs';
	String exportSucceeded({required Object path}) => 'Logs exported to ${path}';
	String get clear => 'Clear logs';
	String get empty => 'No log entries match your filters.';
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
	String get profile => 'Profile';
	String get appearance => 'Appearance';
	String get editor => 'Editor';
	String get logs => 'Logs';
}

// Path: enums.logLevel
class _StringsEnumsLogLevelEn {
	_StringsEnumsLogLevelEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get info => 'Info';
	String get warning => 'Warning';
	String get error => 'Error';
	String get success => 'Success';
}

// Path: settings.general.defaultSaveLocation
class _StringsSettingsGeneralDefaultSaveLocationEn {
	_StringsSettingsGeneralDefaultSaveLocationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Default save location';
	String get noFolderSelected => 'No folder selected';
	String pendingMove({required Object path}) => 'The app will move your data to ${path} on next restart.';
	String get browse => 'Browse';
	String get restartNow => 'Restart now';
	String get notEmptyFolder => 'This folder isn\'t empty. Choose an empty folder — the app will move its data here.';
	String get stayMessage => 'Your data will stay in its current folder.';
	late final _StringsSettingsGeneralDefaultSaveLocationRestartNotificationEn restartNotification = _StringsSettingsGeneralDefaultSaveLocationRestartNotificationEn._(_root);
	late final _StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationEn moveFailedNotification = _StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationEn._(_root);
}

// Path: settings.general.language
class _StringsSettingsGeneralLanguageEn {
	_StringsSettingsGeneralLanguageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Language';
}

// Path: settings.general.updates
class _StringsSettingsGeneralUpdatesEn {
	_StringsSettingsGeneralUpdatesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Updates';
	String version({required Object version}) => 'Version ${version}';
	String get checkForUpdates => 'Check for updates';
	String get description => 'The app checks for updates on launch. Downloads open in your browser — nothing installs automatically.';
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

// Path: settings.logs.location
class _StringsSettingsLogsLocationEn {
	_StringsSettingsLogsLocationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Location';
	String get openFolder => 'Open logs folder';
}

// Path: settings.logs.search
class _StringsSettingsLogsSearchEn {
	_StringsSettingsLogsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get hint => 'Search log messages';
}

// Path: settings.general.defaultSaveLocation.restartNotification
class _StringsSettingsGeneralDefaultSaveLocationRestartNotificationEn {
	_StringsSettingsGeneralDefaultSaveLocationRestartNotificationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Restart pending';
	String get body => 'Restart the app to finish moving your data to the new folder.';
}

// Path: settings.general.defaultSaveLocation.moveFailedNotification
class _StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationEn {
	_StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Couldn\'t move your data';
	String get body => 'Make sure every app window is closed, then reopen the app to try again.';
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
	@override String get appTitle => 'Clean Architecture Starter';
	@override late final _StringsHomePt home = _StringsHomePt._(_root);
	@override late final _StringsGithubExplorerPt githubExplorer = _StringsGithubExplorerPt._(_root);
	@override late final _StringsSettingsPt settings = _StringsSettingsPt._(_root);
	@override late final _StringsEnumsPt enums = _StringsEnumsPt._(_root);
}

// Path: home
class _StringsHomePt implements _StringsHomeEn {
	_StringsHomePt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'Uma demonstração do GitHub Explorer, pronta a pesquisar.';
	@override String get startSearching => 'Começar a pesquisar';
}

// Path: githubExplorer
class _StringsGithubExplorerPt implements _StringsGithubExplorerEn {
	_StringsGithubExplorerPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Explorador do GitHub';
	@override String get searchHint => 'Pesquisar um nome de utilizador do GitHub';
	@override String get searchButton => 'Pesquisar';
	@override String get noResultYet => 'Pesquise um nome de utilizador para ver o perfil e os principais repositórios.';
	@override String publicRepos({required Object count}) => '${count} repositórios públicos';
	@override String followers({required Object count}) => '${count} seguidores';
	@override String get topRepos => 'Principais repositórios';
	@override String get noRepos => 'Este utilizador não tem repositórios públicos.';
	@override String get recentSearches => 'Pesquisas recentes';
	@override String get noRecentSearches => 'Ainda não pesquisou nada.';
	@override String get favoriteSemantics => 'Alternar favorito';
	@override String get settingsTooltip => 'Definições';
	@override String get goHomeTooltip => 'Início';
	@override String errorPrefix({required Object username}) => 'Não foi possível carregar ${username}:';
}

// Path: settings
class _StringsSettingsPt implements _StringsSettingsEn {
	_StringsSettingsPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Definições';
	@override late final _StringsSettingsAppearancePt appearance = _StringsSettingsAppearancePt._(_root);
	@override late final _StringsSettingsGeneralPt general = _StringsSettingsGeneralPt._(_root);
	@override late final _StringsSettingsLogsPt logs = _StringsSettingsLogsPt._(_root);
}

// Path: enums
class _StringsEnumsPt implements _StringsEnumsEn {
	_StringsEnumsPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override late final _StringsEnumsCornerStylePt cornerStyle = _StringsEnumsCornerStylePt._(_root);
	@override late final _StringsEnumsSpacingDensityPt spacingDensity = _StringsEnumsSpacingDensityPt._(_root);
	@override late final _StringsEnumsSettingsCategoryPt settingsCategory = _StringsEnumsSettingsCategoryPt._(_root);
	@override late final _StringsEnumsLogLevelPt logLevel = _StringsEnumsLogLevelPt._(_root);
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
	@override late final _StringsSettingsGeneralDefaultSaveLocationPt defaultSaveLocation = _StringsSettingsGeneralDefaultSaveLocationPt._(_root);
	@override late final _StringsSettingsGeneralLanguagePt language = _StringsSettingsGeneralLanguagePt._(_root);
	@override late final _StringsSettingsGeneralUpdatesPt updates = _StringsSettingsGeneralUpdatesPt._(_root);
	@override late final _StringsSettingsGeneralAboutPt about = _StringsSettingsGeneralAboutPt._(_root);
}

// Path: settings.logs
class _StringsSettingsLogsPt implements _StringsSettingsLogsEn {
	_StringsSettingsLogsPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Registos';
	@override late final _StringsSettingsLogsLocationPt location = _StringsSettingsLogsLocationPt._(_root);
	@override late final _StringsSettingsLogsSearchPt search = _StringsSettingsLogsSearchPt._(_root);
	@override String get filterAll => 'Todos';
	@override String get export => 'Exportar registos';
	@override String exportSucceeded({required Object path}) => 'Registos exportados para ${path}';
	@override String get clear => 'Limpar registos';
	@override String get empty => 'Nenhuma entrada de registo corresponde aos filtros.';
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
	@override String get profile => 'Perfil';
	@override String get appearance => 'Aparência';
	@override String get editor => 'Editor';
	@override String get logs => 'Registos';
}

// Path: enums.logLevel
class _StringsEnumsLogLevelPt implements _StringsEnumsLogLevelEn {
	_StringsEnumsLogLevelPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get info => 'Informação';
	@override String get warning => 'Aviso';
	@override String get error => 'Erro';
	@override String get success => 'Sucesso';
}

// Path: settings.general.defaultSaveLocation
class _StringsSettingsGeneralDefaultSaveLocationPt implements _StringsSettingsGeneralDefaultSaveLocationEn {
	_StringsSettingsGeneralDefaultSaveLocationPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Localização de guardar predefinida';
	@override String get noFolderSelected => 'Nenhuma pasta selecionada';
	@override String pendingMove({required Object path}) => 'A aplicação vai mover os seus dados para ${path} no próximo reinício.';
	@override String get browse => 'Procurar';
	@override String get restartNow => 'Reiniciar agora';
	@override String get notEmptyFolder => 'Esta pasta não está vazia. Escolha uma pasta vazia — a aplicação vai mover os dados para aqui.';
	@override String get stayMessage => 'Os seus dados vão continuar na pasta atual.';
	@override late final _StringsSettingsGeneralDefaultSaveLocationRestartNotificationPt restartNotification = _StringsSettingsGeneralDefaultSaveLocationRestartNotificationPt._(_root);
	@override late final _StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationPt moveFailedNotification = _StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationPt._(_root);
}

// Path: settings.general.language
class _StringsSettingsGeneralLanguagePt implements _StringsSettingsGeneralLanguageEn {
	_StringsSettingsGeneralLanguagePt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idioma';
}

// Path: settings.general.updates
class _StringsSettingsGeneralUpdatesPt implements _StringsSettingsGeneralUpdatesEn {
	_StringsSettingsGeneralUpdatesPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Atualizações';
	@override String version({required Object version}) => 'Versão ${version}';
	@override String get checkForUpdates => 'Verificar atualizações';
	@override String get description => 'A aplicação verifica atualizações ao iniciar. As transferências abrem no seu navegador — nada é instalado automaticamente.';
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

// Path: settings.logs.location
class _StringsSettingsLogsLocationPt implements _StringsSettingsLogsLocationEn {
	_StringsSettingsLogsLocationPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Localização';
	@override String get openFolder => 'Abrir pasta de registos';
}

// Path: settings.logs.search
class _StringsSettingsLogsSearchPt implements _StringsSettingsLogsSearchEn {
	_StringsSettingsLogsSearchPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get hint => 'Pesquisar mensagens de registo';
}

// Path: settings.general.defaultSaveLocation.restartNotification
class _StringsSettingsGeneralDefaultSaveLocationRestartNotificationPt implements _StringsSettingsGeneralDefaultSaveLocationRestartNotificationEn {
	_StringsSettingsGeneralDefaultSaveLocationRestartNotificationPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Reinício pendente';
	@override String get body => 'Reinicie a aplicação para concluir a transferência dos seus dados para a nova pasta.';
}

// Path: settings.general.defaultSaveLocation.moveFailedNotification
class _StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationPt implements _StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationEn {
	_StringsSettingsGeneralDefaultSaveLocationMoveFailedNotificationPt._(this._root);

	@override final _StringsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Não foi possível mover os seus dados';
	@override String get body => 'Certifique-se de que todas as janelas da aplicação estão fechadas e depois reabra a aplicação para tentar novamente.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'Clean Architecture Starter';
			case 'home.subtitle': return 'A GitHub Explorer demo, ready to search.';
			case 'home.startSearching': return 'Start searching';
			case 'githubExplorer.title': return 'GitHub Explorer';
			case 'githubExplorer.searchHint': return 'Search a GitHub username';
			case 'githubExplorer.searchButton': return 'Search';
			case 'githubExplorer.noResultYet': return 'Search a username to see their profile and top repositories.';
			case 'githubExplorer.publicRepos': return ({required Object count}) => '${count} public repos';
			case 'githubExplorer.followers': return ({required Object count}) => '${count} followers';
			case 'githubExplorer.topRepos': return 'Top repositories';
			case 'githubExplorer.noRepos': return 'This user has no public repositories.';
			case 'githubExplorer.recentSearches': return 'Recent searches';
			case 'githubExplorer.noRecentSearches': return 'Nothing searched yet.';
			case 'githubExplorer.favoriteSemantics': return 'Toggle favorite';
			case 'githubExplorer.settingsTooltip': return 'Settings';
			case 'githubExplorer.goHomeTooltip': return 'Home';
			case 'githubExplorer.errorPrefix': return ({required Object username}) => 'Couldn\'t load ${username}:';
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
			case 'settings.general.defaultSaveLocation.title': return 'Default save location';
			case 'settings.general.defaultSaveLocation.noFolderSelected': return 'No folder selected';
			case 'settings.general.defaultSaveLocation.pendingMove': return ({required Object path}) => 'The app will move your data to ${path} on next restart.';
			case 'settings.general.defaultSaveLocation.browse': return 'Browse';
			case 'settings.general.defaultSaveLocation.restartNow': return 'Restart now';
			case 'settings.general.defaultSaveLocation.notEmptyFolder': return 'This folder isn\'t empty. Choose an empty folder — the app will move its data here.';
			case 'settings.general.defaultSaveLocation.stayMessage': return 'Your data will stay in its current folder.';
			case 'settings.general.defaultSaveLocation.restartNotification.title': return 'Restart pending';
			case 'settings.general.defaultSaveLocation.restartNotification.body': return 'Restart the app to finish moving your data to the new folder.';
			case 'settings.general.defaultSaveLocation.moveFailedNotification.title': return 'Couldn\'t move your data';
			case 'settings.general.defaultSaveLocation.moveFailedNotification.body': return 'Make sure every app window is closed, then reopen the app to try again.';
			case 'settings.general.language.title': return 'Language';
			case 'settings.general.updates.title': return 'Updates';
			case 'settings.general.updates.version': return ({required Object version}) => 'Version ${version}';
			case 'settings.general.updates.checkForUpdates': return 'Check for updates';
			case 'settings.general.updates.description': return 'The app checks for updates on launch. Downloads open in your browser — nothing installs automatically.';
			case 'settings.general.updates.notImplemented': return 'Checking for updates is not implemented yet.';
			case 'settings.general.about.title': return 'About';
			case 'settings.general.about.copyright': return '© 2026 Soneka96';
			case 'settings.general.about.privacyPolicy': return 'Privacy & data use';
			case 'settings.general.about.notImplemented': return 'Privacy & data use is not implemented yet.';
			case 'settings.logs.title': return 'Logs';
			case 'settings.logs.location.title': return 'Location';
			case 'settings.logs.location.openFolder': return 'Open logs folder';
			case 'settings.logs.search.hint': return 'Search log messages';
			case 'settings.logs.filterAll': return 'All';
			case 'settings.logs.export': return 'Export logs';
			case 'settings.logs.exportSucceeded': return ({required Object path}) => 'Logs exported to ${path}';
			case 'settings.logs.clear': return 'Clear logs';
			case 'settings.logs.empty': return 'No log entries match your filters.';
			case 'enums.cornerStyle.rounded': return 'Rounded';
			case 'enums.cornerStyle.square': return 'Square';
			case 'enums.spacingDensity.comfortable': return 'Comfortable';
			case 'enums.spacingDensity.compact': return 'Compact';
			case 'enums.settingsCategory.general': return 'General';
			case 'enums.settingsCategory.profile': return 'Profile';
			case 'enums.settingsCategory.appearance': return 'Appearance';
			case 'enums.settingsCategory.editor': return 'Editor';
			case 'enums.settingsCategory.logs': return 'Logs';
			case 'enums.logLevel.info': return 'Info';
			case 'enums.logLevel.warning': return 'Warning';
			case 'enums.logLevel.error': return 'Error';
			case 'enums.logLevel.success': return 'Success';
			default: return null;
		}
	}
}

extension on _StringsPt {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'appTitle': return 'Clean Architecture Starter';
			case 'home.subtitle': return 'Uma demonstração do GitHub Explorer, pronta a pesquisar.';
			case 'home.startSearching': return 'Começar a pesquisar';
			case 'githubExplorer.title': return 'Explorador do GitHub';
			case 'githubExplorer.searchHint': return 'Pesquisar um nome de utilizador do GitHub';
			case 'githubExplorer.searchButton': return 'Pesquisar';
			case 'githubExplorer.noResultYet': return 'Pesquise um nome de utilizador para ver o perfil e os principais repositórios.';
			case 'githubExplorer.publicRepos': return ({required Object count}) => '${count} repositórios públicos';
			case 'githubExplorer.followers': return ({required Object count}) => '${count} seguidores';
			case 'githubExplorer.topRepos': return 'Principais repositórios';
			case 'githubExplorer.noRepos': return 'Este utilizador não tem repositórios públicos.';
			case 'githubExplorer.recentSearches': return 'Pesquisas recentes';
			case 'githubExplorer.noRecentSearches': return 'Ainda não pesquisou nada.';
			case 'githubExplorer.favoriteSemantics': return 'Alternar favorito';
			case 'githubExplorer.settingsTooltip': return 'Definições';
			case 'githubExplorer.goHomeTooltip': return 'Início';
			case 'githubExplorer.errorPrefix': return ({required Object username}) => 'Não foi possível carregar ${username}:';
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
			case 'settings.general.defaultSaveLocation.title': return 'Localização de guardar predefinida';
			case 'settings.general.defaultSaveLocation.noFolderSelected': return 'Nenhuma pasta selecionada';
			case 'settings.general.defaultSaveLocation.pendingMove': return ({required Object path}) => 'A aplicação vai mover os seus dados para ${path} no próximo reinício.';
			case 'settings.general.defaultSaveLocation.browse': return 'Procurar';
			case 'settings.general.defaultSaveLocation.restartNow': return 'Reiniciar agora';
			case 'settings.general.defaultSaveLocation.notEmptyFolder': return 'Esta pasta não está vazia. Escolha uma pasta vazia — a aplicação vai mover os dados para aqui.';
			case 'settings.general.defaultSaveLocation.stayMessage': return 'Os seus dados vão continuar na pasta atual.';
			case 'settings.general.defaultSaveLocation.restartNotification.title': return 'Reinício pendente';
			case 'settings.general.defaultSaveLocation.restartNotification.body': return 'Reinicie a aplicação para concluir a transferência dos seus dados para a nova pasta.';
			case 'settings.general.defaultSaveLocation.moveFailedNotification.title': return 'Não foi possível mover os seus dados';
			case 'settings.general.defaultSaveLocation.moveFailedNotification.body': return 'Certifique-se de que todas as janelas da aplicação estão fechadas e depois reabra a aplicação para tentar novamente.';
			case 'settings.general.language.title': return 'Idioma';
			case 'settings.general.updates.title': return 'Atualizações';
			case 'settings.general.updates.version': return ({required Object version}) => 'Versão ${version}';
			case 'settings.general.updates.checkForUpdates': return 'Verificar atualizações';
			case 'settings.general.updates.description': return 'A aplicação verifica atualizações ao iniciar. As transferências abrem no seu navegador — nada é instalado automaticamente.';
			case 'settings.general.updates.notImplemented': return 'Verificar atualizações ainda não está implementado.';
			case 'settings.general.about.title': return 'Acerca';
			case 'settings.general.about.copyright': return '© 2026 Soneka96';
			case 'settings.general.about.privacyPolicy': return 'Privacidade e utilização de dados';
			case 'settings.general.about.notImplemented': return 'Privacidade e utilização de dados ainda não está implementado.';
			case 'settings.logs.title': return 'Registos';
			case 'settings.logs.location.title': return 'Localização';
			case 'settings.logs.location.openFolder': return 'Abrir pasta de registos';
			case 'settings.logs.search.hint': return 'Pesquisar mensagens de registo';
			case 'settings.logs.filterAll': return 'Todos';
			case 'settings.logs.export': return 'Exportar registos';
			case 'settings.logs.exportSucceeded': return ({required Object path}) => 'Registos exportados para ${path}';
			case 'settings.logs.clear': return 'Limpar registos';
			case 'settings.logs.empty': return 'Nenhuma entrada de registo corresponde aos filtros.';
			case 'enums.cornerStyle.rounded': return 'Arredondado';
			case 'enums.cornerStyle.square': return 'Quadrado';
			case 'enums.spacingDensity.comfortable': return 'Confortável';
			case 'enums.spacingDensity.compact': return 'Compacto';
			case 'enums.settingsCategory.general': return 'Geral';
			case 'enums.settingsCategory.profile': return 'Perfil';
			case 'enums.settingsCategory.appearance': return 'Aparência';
			case 'enums.settingsCategory.editor': return 'Editor';
			case 'enums.settingsCategory.logs': return 'Registos';
			case 'enums.logLevel.info': return 'Informação';
			case 'enums.logLevel.warning': return 'Aviso';
			case 'enums.logLevel.error': return 'Erro';
			case 'enums.logLevel.success': return 'Sucesso';
			default: return null;
		}
	}
}
