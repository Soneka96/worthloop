///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'WorthLoop'
	String get appTitle => 'WorthLoop';

	late final Translations$common$en common = Translations$common$en._(_root);
	late final Translations$home$en home = Translations$home$en._(_root);
	late final Translations$productDetails$en productDetails = Translations$productDetails$en._(_root);
	late final Translations$settings$en settings = Translations$settings$en._(_root);
	late final Translations$enums$en enums = Translations$enums$en._(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Refresh successful'
	String get refreshSuccessful => 'Refresh successful';

	/// en: 'Refresh completed with errors'
	String get refreshCompletedWithErrors => 'Refresh completed with errors';

	/// en: 'Refresh failed'
	String get refreshFailed => 'Refresh failed';
}

// Path: home
class Translations$home$en {
	Translations$home$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your watchlist, with the best current offer first.'
	String get subtitle => 'Your watchlist, with the best current offer first.';

	/// en: '$count tracked'
	String trackedProducts({required Object count}) => '${count} tracked';

	/// en: 'Updating prices · $completed of $total sources checked'
	String refreshProgress({required Object completed, required Object total}) => 'Updating prices · ${completed} of ${total} sources checked';

	/// en: 'Refresh all'
	String get refreshAll => 'Refresh all';

	/// en: 'Refreshing'
	String get refreshing => 'Refreshing';

	/// en: 'All sources checked.'
	String get refreshAllComplete => 'All sources checked.';

	/// en: 'Refresh finished; $failed sources couldn't be checked.'
	String refreshAllPartial({required Object failed}) => 'Refresh finished; ${failed} sources couldn\'t be checked.';

	/// en: 'A product is already being checked'
	String get refreshBlockedProduct => 'A product is already being checked';

	/// en: 'All products are being checked'
	String get refreshBlockedAllProducts => 'All products are being checked';

	/// en: 'Checking $count sources'
	String sourceRefreshChecking({required Object count}) => 'Checking ${count} sources';

	/// en: 'Couldn't check $merchant'
	String sourceRefreshFailed({required Object merchant}) => 'Couldn\'t check ${merchant}';

	/// en: '$count sources couldn't be checked'
	String sourceRefreshFailedCount({required Object count}) => '${count} sources couldn\'t be checked';

	/// en: 'Best price'
	String get bestPrice => 'Best price';

	/// en: 'No available price'
	String get noAvailablePrice => 'No available price';

	/// en: 'No store in stock'
	String get noStore => 'No store in stock';

	/// en: 'Offers: $count'
	String storeOffers({required Object count}) => 'Offers: ${count}';

	/// en: 'Updated $time'
	String updatedAt({required Object time}) => 'Updated ${time}';

	/// en: '↓ $amount since $date'
	String priceDrop({required Object amount, required Object date}) => '↓ ${amount} since ${date}';

	/// en: '↑ $amount since $date'
	String priceIncrease({required Object amount, required Object date}) => '↑ ${amount} since ${date}';

	/// en: 'No tracked products'
	String get emptyTitle => 'No tracked products';

	/// en: 'Products you track will appear here with their best available offer.'
	String get emptyDescription => 'Products you track will appear here with their best available offer.';

	/// en: 'Add a product'
	String get addProductTitle => 'Add a product';

	/// en: 'Paste a product link to start tracking it.'
	String get addProductDescription => 'Paste a product link to start tracking it.';

	/// en: 'Product name'
	String get productNameLabel => 'Product name';

	/// en: 'Enter a product name.'
	String get productNameRequired => 'Enter a product name.';

	/// en: 'Add product'
	String get addProductButton => 'Add product';

	/// en: 'Saving'
	String get addProductSaving => 'Saving';

	/// en: 'Search your tracked items'
	String get searchHint => 'Search your tracked items';

	/// en: 'Clear search'
	String get searchClearTooltip => 'Clear search';

	/// en: 'No matches'
	String get noSearchResultsTitle => 'No matches';

	/// en: 'No tracked items match "$query".'
	String noSearchResultsDescription({required Object query}) => 'No tracked items match "${query}".';
}

// Path: productDetails
class Translations$productDetails$en {
	Translations$productDetails$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Product details'
	String get title => 'Product details';

	/// en: 'Back'
	String get backTooltip => 'Back';

	/// en: 'Refresh'
	String get refresh => 'Refresh';

	/// en: 'Refreshing'
	String get refreshing => 'Refreshing';

	/// en: '$completed of $total sources checked'
	String refreshProgress({required Object completed, required Object total}) => '${completed} of ${total} sources checked';

	/// en: 'Other products refreshing'
	String get otherProductsRefreshing => 'Other products refreshing';

	/// en: 'This product is already being checked'
	String get refreshBlockedThisProduct => 'This product is already being checked';

	/// en: 'Another product is being checked'
	String get refreshBlockedOtherProduct => 'Another product is being checked';

	/// en: 'All products are being checked'
	String get refreshBlockedAllProducts => 'All products are being checked';

	/// en: 'Queued'
	String get queued => 'Queued';

	/// en: 'Checking'
	String get checking => 'Checking';

	/// en: 'Cannot access now'
	String get cannotAccessNow => 'Cannot access now';

	/// en: 'All $total sources checked.'
	String refreshComplete({required Object total}) => 'All ${total} sources checked.';

	/// en: '$completed of $total sources checked; $failed could not be accessed.'
	String refreshPartial({required Object completed, required Object total, required Object failed}) => '${completed} of ${total} sources checked; ${failed} could not be accessed.';

	/// en: 'Best price'
	String get bestPrice => 'Best price';

	/// en: 'Store offers: $count'
	String offers({required Object count}) => 'Store offers: ${count}';

	/// en: 'Available offers'
	String get availableOffers => 'Available offers';

	/// en: 'Unavailable offers'
	String get unavailableOffers => 'Unavailable offers';

	/// en: 'These stores currently report no stock.'
	String get unavailableDescription => 'These stores currently report no stock.';

	/// en: 'No offers yet.'
	String get noOffers => 'No offers yet.';

	/// en: 'In stock'
	String get available => 'In stock';

	/// en: 'Out of stock'
	String get unavailable => 'Out of stock';

	/// en: 'All'
	String get filterAll => 'All';

	/// en: 'Available'
	String get filterAvailable => 'Available';

	/// en: 'Unavailable'
	String get filterUnavailable => 'Unavailable';

	/// en: 'Checked at $time'
	String checkedAt({required Object time}) => 'Checked at ${time}';

	/// en: '↓ $amount since $date'
	String priceDrop({required Object amount, required Object date}) => '↓ ${amount} since ${date}';

	/// en: '↑ $amount since $date'
	String priceIncrease({required Object amount, required Object date}) => '↑ ${amount} since ${date}';

	/// en: 'Product not found'
	String get productNotFound => 'Product not found';

	/// en: 'Return to your tracked products and choose an item again.'
	String get productNotFoundDescription => 'Return to your tracked products and choose an item again.';

	/// en: 'Issues'
	String get filterIssues => 'Issues';

	/// en: 'This website blocked the refresh attempt. Try again later.'
	String get refreshBlocked => 'This website blocked the refresh attempt. Try again later.';

	/// en: 'This website does not provide a readable price yet.'
	String get refreshUnsupported => 'This website does not provide a readable price yet.';

	/// en: 'The website could not be reached. Your last price is still shown.'
	String get refreshNetworkError => 'The website could not be reached. Your last price is still shown.';

	/// en: 'The website returned an unreadable price. Your last price is still shown.'
	String get refreshInvalidData => 'The website returned an unreadable price. Your last price is still shown.';

	/// en: 'Sources'
	String get sourcesTitle => 'Sources';

	/// en: 'Could not open the merchant page.'
	String get openOfferFailed => 'Could not open the merchant page.';

	/// en: 'Opens in your browser'
	String get openOfferHint => 'Opens in your browser';

	/// en: 'Add source'
	String get addSourceTooltip => 'Add source';

	/// en: 'Add a source'
	String get addSourceTitle => 'Add a source';

	/// en: 'Edit source'
	String get editSourceTitle => 'Edit source';

	/// en: 'Website link'
	String get sourceUrlLabel => 'Website link';

	/// en: 'https://example.com/product'
	String get sourceUrlHint => 'https://example.com/product';

	/// en: 'Enter a website link.'
	String get sourceUrlRequired => 'Enter a website link.';

	/// en: 'Saving'
	String get savingSource => 'Saving';

	/// en: 'Add source'
	String get addSourceButton => 'Add source';

	/// en: 'Save'
	String get saveSourceButton => 'Save';

	/// en: 'No sources yet'
	String get noSourcesTitle => 'No sources yet';

	/// en: 'Add a merchant link to start comparing prices for this product.'
	String get noSourcesDescription => 'Add a merchant link to start comparing prices for this product.';

	/// en: 'Edit source'
	String get editSourceTooltip => 'Edit source';

	/// en: 'Delete source'
	String get deleteSourceTooltip => 'Delete source';

	/// en: 'Delete this source?'
	String get deleteSourceTitle => 'Delete this source?';

	/// en: 'This will remove $merchant and its offer from this product.'
	String deleteSourceMessage({required Object merchant}) => 'This will remove ${merchant} and its offer from this product.';

	/// en: 'Delete'
	String get deleteSourceConfirmLabel => 'Delete';

	/// en: 'Rename product'
	String get renameProductTooltip => 'Rename product';

	/// en: 'Rename product'
	String get renameProductTitle => 'Rename product';

	/// en: 'Product name'
	String get productNameLabel => 'Product name';

	/// en: 'Enter a product name.'
	String get renameProductRequired => 'Enter a product name.';

	/// en: 'Save'
	String get renameProductButton => 'Save';

	/// en: 'Saving'
	String get renameProductSaving => 'Saving';

	/// en: 'Delete product'
	String get deleteProductTooltip => 'Delete product';

	/// en: 'Delete this product?'
	String get deleteProductTitle => 'Delete this product?';

	/// en: 'This removes $name and all its saved sources and offers.'
	String deleteProductMessage({required Object name}) => 'This removes ${name} and all its saved sources and offers.';

	/// en: 'Delete'
	String get deleteProductConfirmLabel => 'Delete';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	late final Translations$settings$appearance$en appearance = Translations$settings$appearance$en._(_root);
	late final Translations$settings$general$en general = Translations$settings$general$en._(_root);
}

// Path: enums
class Translations$enums$en {
	Translations$enums$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$enums$cornerStyle$en cornerStyle = Translations$enums$cornerStyle$en._(_root);
	late final Translations$enums$spacingDensity$en spacingDensity = Translations$enums$spacingDensity$en._(_root);
	late final Translations$enums$settingsCategory$en settingsCategory = Translations$enums$settingsCategory$en._(_root);
}

// Path: settings.appearance
class Translations$settings$appearance$en {
	Translations$settings$appearance$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appearance'
	String get title => 'Appearance';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Corner style'
	String get cornerStyle => 'Corner style';

	/// en: 'Density'
	String get density => 'Density';

	/// en: 'Font'
	String get font => 'Font';

	/// en: 'Text Size'
	String get zoom => 'Text Size';

	/// en: 'Dark'
	String get dark => 'Dark';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Activate $label theme'
	String activateThemeSemantics({required Object label}) => 'Activate ${label} theme';

	/// en: 'Text size'
	String get zoomLevelSemantics => 'Text size';
}

// Path: settings.general
class Translations$settings$general$en {
	Translations$settings$general$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'General'
	String get title => 'General';

	late final Translations$settings$general$language$en language = Translations$settings$general$language$en._(_root);
	late final Translations$settings$general$refreshInterval$en refreshInterval = Translations$settings$general$refreshInterval$en._(_root);
	late final Translations$settings$general$browserRefresh$en browserRefresh = Translations$settings$general$browserRefresh$en._(_root);
	late final Translations$settings$general$priceAlerts$en priceAlerts = Translations$settings$general$priceAlerts$en._(_root);
	late final Translations$settings$general$priceIncreaseAlerts$en priceIncreaseAlerts = Translations$settings$general$priceIncreaseAlerts$en._(_root);
	late final Translations$settings$general$updates$en updates = Translations$settings$general$updates$en._(_root);
	late final Translations$settings$general$about$en about = Translations$settings$general$about$en._(_root);
}

// Path: enums.cornerStyle
class Translations$enums$cornerStyle$en {
	Translations$enums$cornerStyle$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rounded'
	String get rounded => 'Rounded';

	/// en: 'Square'
	String get square => 'Square';
}

// Path: enums.spacingDensity
class Translations$enums$spacingDensity$en {
	Translations$enums$spacingDensity$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Comfortable'
	String get comfortable => 'Comfortable';

	/// en: 'Compact'
	String get compact => 'Compact';
}

// Path: enums.settingsCategory
class Translations$enums$settingsCategory$en {
	Translations$enums$settingsCategory$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'General'
	String get general => 'General';

	/// en: 'Appearance'
	String get appearance => 'Appearance';
}

// Path: settings.general.language
class Translations$settings$general$language$en {
	Translations$settings$general$language$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Language'
	String get title => 'Language';
}

// Path: settings.general.refreshInterval
class Translations$settings$general$refreshInterval$en {
	Translations$settings$general$refreshInterval$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Refresh interval'
	String get title => 'Refresh interval';

	/// en: 'Saved now for automatic refresh support later. Background refresh is not active yet.'
	String get description => 'Saved now for automatic refresh support later. Background refresh is not active yet.';

	/// en: 'Every hour'
	String get hourly => 'Every hour';

	/// en: 'Every 3 hours'
	String get everyThreeHours => 'Every 3 hours';

	/// en: 'Every 6 hours'
	String get everySixHours => 'Every 6 hours';

	/// en: 'Every 12 hours'
	String get everyTwelveHours => 'Every 12 hours';
}

// Path: settings.general.browserRefresh
class Translations$settings$general$browserRefresh$en {
	Translations$settings$general$browserRefresh$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Browser refresh'
	String get title => 'Browser refresh';

	/// en: 'Many stores block simple requests. Enable a browser in the background to improve automatic price coverage.'
	String get description => 'Many stores block simple requests. Enable a browser in the background to improve automatic price coverage.';

	/// en: 'Browser refresh may use additional battery and data while checking stores in the background.'
	String get enabledDescription => 'Browser refresh may use additional battery and data while checking stores in the background.';

	/// en: 'Browser refresh is enabled. Android may still delay background work.'
	String get status => 'Browser refresh is enabled. Android may still delay background work.';

	/// en: 'Fix background restrictions'
	String get fixRestrictions => 'Fix background restrictions';
}

// Path: settings.general.priceAlerts
class Translations$settings$general$priceAlerts$en {
	Translations$settings$general$priceAlerts$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Price drop notifications'
	String get title => 'Price drop notifications';

	/// en: 'Get a phone notification when a tracked product reaches a new best price.'
	String get description => 'Get a phone notification when a tracked product reaches a new best price.';

	/// en: 'Notifications are enabled for new best prices. Android permission is required.'
	String get enabledDescription => 'Notifications are enabled for new best prices. Android permission is required.';

	/// en: '$name is cheaper'
	String notificationTitle({required Object name}) => '${name} is cheaper';

	/// en: 'Now $current, down from $previous.'
	String notificationBody({required Object current, required Object previous}) => 'Now ${current}, down from ${previous}.';

	/// en: 'Android notification permission was not granted, so price alerts remain off.'
	String get permissionDenied => 'Android notification permission was not granted, so price alerts remain off.';
}

// Path: settings.general.priceIncreaseAlerts
class Translations$settings$general$priceIncreaseAlerts$en {
	Translations$settings$general$priceIncreaseAlerts$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Price increase notifications'
	String get title => 'Price increase notifications';

	/// en: 'Get a phone notification when a tracked product's best price goes up.'
	String get description => 'Get a phone notification when a tracked product\'s best price goes up.';

	/// en: 'Notifications are enabled for price increases. Android permission is required.'
	String get enabledDescription => 'Notifications are enabled for price increases. Android permission is required.';

	/// en: '$name got more expensive'
	String notificationTitle({required Object name}) => '${name} got more expensive';

	/// en: 'Now $current, up from $previous.'
	String notificationBody({required Object current, required Object previous}) => 'Now ${current}, up from ${previous}.';

	/// en: 'Android notification permission was not granted, so price alerts remain off.'
	String get permissionDenied => 'Android notification permission was not granted, so price alerts remain off.';
}

// Path: settings.general.updates
class Translations$settings$general$updates$en {
	Translations$settings$general$updates$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Updates'
	String get title => 'Updates';

	/// en: 'Version $version'
	String version({required Object version}) => 'Version ${version}';

	/// en: 'Check for updates'
	String get checkForUpdates => 'Check for updates';

	/// en: 'Update checking will be added later.'
	String get description => 'Update checking will be added later.';

	/// en: 'Checking for updates is not implemented yet.'
	String get notImplemented => 'Checking for updates is not implemented yet.';
}

// Path: settings.general.about
class Translations$settings$general$about$en {
	Translations$settings$general$about$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'About'
	String get title => 'About';

	/// en: '© 2026 Soneka96'
	String get copyright => '© 2026 Soneka96';

	/// en: 'Privacy & data use'
	String get privacyPolicy => 'Privacy & data use';

	/// en: 'Privacy & data use is not implemented yet.'
	String get notImplemented => 'Privacy & data use is not implemented yet.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'WorthLoop',
			'common.cancel' => 'Cancel',
			'common.refreshSuccessful' => 'Refresh successful',
			'common.refreshCompletedWithErrors' => 'Refresh completed with errors',
			'common.refreshFailed' => 'Refresh failed',
			'home.subtitle' => 'Your watchlist, with the best current offer first.',
			'home.trackedProducts' => ({required Object count}) => '${count} tracked',
			'home.refreshProgress' => ({required Object completed, required Object total}) => 'Updating prices · ${completed} of ${total} sources checked',
			'home.refreshAll' => 'Refresh all',
			'home.refreshing' => 'Refreshing',
			'home.refreshAllComplete' => 'All sources checked.',
			'home.refreshAllPartial' => ({required Object failed}) => 'Refresh finished; ${failed} sources couldn\'t be checked.',
			'home.refreshBlockedProduct' => 'A product is already being checked',
			'home.refreshBlockedAllProducts' => 'All products are being checked',
			'home.sourceRefreshChecking' => ({required Object count}) => 'Checking ${count} sources',
			'home.sourceRefreshFailed' => ({required Object merchant}) => 'Couldn\'t check ${merchant}',
			'home.sourceRefreshFailedCount' => ({required Object count}) => '${count} sources couldn\'t be checked',
			'home.bestPrice' => 'Best price',
			'home.noAvailablePrice' => 'No available price',
			'home.noStore' => 'No store in stock',
			'home.storeOffers' => ({required Object count}) => 'Offers: ${count}',
			'home.updatedAt' => ({required Object time}) => 'Updated ${time}',
			'home.priceDrop' => ({required Object amount, required Object date}) => '↓ ${amount} since ${date}',
			'home.priceIncrease' => ({required Object amount, required Object date}) => '↑ ${amount} since ${date}',
			'home.emptyTitle' => 'No tracked products',
			'home.emptyDescription' => 'Products you track will appear here with their best available offer.',
			'home.addProductTitle' => 'Add a product',
			'home.addProductDescription' => 'Paste a product link to start tracking it.',
			'home.productNameLabel' => 'Product name',
			'home.productNameRequired' => 'Enter a product name.',
			'home.addProductButton' => 'Add product',
			'home.addProductSaving' => 'Saving',
			'home.searchHint' => 'Search your tracked items',
			'home.searchClearTooltip' => 'Clear search',
			'home.noSearchResultsTitle' => 'No matches',
			'home.noSearchResultsDescription' => ({required Object query}) => 'No tracked items match "${query}".',
			'productDetails.title' => 'Product details',
			'productDetails.backTooltip' => 'Back',
			'productDetails.refresh' => 'Refresh',
			'productDetails.refreshing' => 'Refreshing',
			'productDetails.refreshProgress' => ({required Object completed, required Object total}) => '${completed} of ${total} sources checked',
			'productDetails.otherProductsRefreshing' => 'Other products refreshing',
			'productDetails.refreshBlockedThisProduct' => 'This product is already being checked',
			'productDetails.refreshBlockedOtherProduct' => 'Another product is being checked',
			'productDetails.refreshBlockedAllProducts' => 'All products are being checked',
			'productDetails.queued' => 'Queued',
			'productDetails.checking' => 'Checking',
			'productDetails.cannotAccessNow' => 'Cannot access now',
			'productDetails.refreshComplete' => ({required Object total}) => 'All ${total} sources checked.',
			'productDetails.refreshPartial' => ({required Object completed, required Object total, required Object failed}) => '${completed} of ${total} sources checked; ${failed} could not be accessed.',
			'productDetails.bestPrice' => 'Best price',
			'productDetails.offers' => ({required Object count}) => 'Store offers: ${count}',
			'productDetails.availableOffers' => 'Available offers',
			'productDetails.unavailableOffers' => 'Unavailable offers',
			'productDetails.unavailableDescription' => 'These stores currently report no stock.',
			'productDetails.noOffers' => 'No offers yet.',
			'productDetails.available' => 'In stock',
			'productDetails.unavailable' => 'Out of stock',
			'productDetails.filterAll' => 'All',
			'productDetails.filterAvailable' => 'Available',
			'productDetails.filterUnavailable' => 'Unavailable',
			'productDetails.checkedAt' => ({required Object time}) => 'Checked at ${time}',
			'productDetails.priceDrop' => ({required Object amount, required Object date}) => '↓ ${amount} since ${date}',
			'productDetails.priceIncrease' => ({required Object amount, required Object date}) => '↑ ${amount} since ${date}',
			'productDetails.productNotFound' => 'Product not found',
			'productDetails.productNotFoundDescription' => 'Return to your tracked products and choose an item again.',
			'productDetails.filterIssues' => 'Issues',
			'productDetails.refreshBlocked' => 'This website blocked the refresh attempt. Try again later.',
			'productDetails.refreshUnsupported' => 'This website does not provide a readable price yet.',
			'productDetails.refreshNetworkError' => 'The website could not be reached. Your last price is still shown.',
			'productDetails.refreshInvalidData' => 'The website returned an unreadable price. Your last price is still shown.',
			'productDetails.sourcesTitle' => 'Sources',
			'productDetails.openOfferFailed' => 'Could not open the merchant page.',
			'productDetails.openOfferHint' => 'Opens in your browser',
			'productDetails.addSourceTooltip' => 'Add source',
			'productDetails.addSourceTitle' => 'Add a source',
			'productDetails.editSourceTitle' => 'Edit source',
			'productDetails.sourceUrlLabel' => 'Website link',
			'productDetails.sourceUrlHint' => 'https://example.com/product',
			'productDetails.sourceUrlRequired' => 'Enter a website link.',
			'productDetails.savingSource' => 'Saving',
			'productDetails.addSourceButton' => 'Add source',
			'productDetails.saveSourceButton' => 'Save',
			'productDetails.noSourcesTitle' => 'No sources yet',
			'productDetails.noSourcesDescription' => 'Add a merchant link to start comparing prices for this product.',
			'productDetails.editSourceTooltip' => 'Edit source',
			'productDetails.deleteSourceTooltip' => 'Delete source',
			'productDetails.deleteSourceTitle' => 'Delete this source?',
			'productDetails.deleteSourceMessage' => ({required Object merchant}) => 'This will remove ${merchant} and its offer from this product.',
			'productDetails.deleteSourceConfirmLabel' => 'Delete',
			'productDetails.renameProductTooltip' => 'Rename product',
			'productDetails.renameProductTitle' => 'Rename product',
			'productDetails.productNameLabel' => 'Product name',
			'productDetails.renameProductRequired' => 'Enter a product name.',
			'productDetails.renameProductButton' => 'Save',
			'productDetails.renameProductSaving' => 'Saving',
			'productDetails.deleteProductTooltip' => 'Delete product',
			'productDetails.deleteProductTitle' => 'Delete this product?',
			'productDetails.deleteProductMessage' => ({required Object name}) => 'This removes ${name} and all its saved sources and offers.',
			'productDetails.deleteProductConfirmLabel' => 'Delete',
			'settings.title' => 'Settings',
			'settings.appearance.title' => 'Appearance',
			'settings.appearance.theme' => 'Theme',
			'settings.appearance.cornerStyle' => 'Corner style',
			'settings.appearance.density' => 'Density',
			'settings.appearance.font' => 'Font',
			'settings.appearance.zoom' => 'Text Size',
			'settings.appearance.dark' => 'Dark',
			'settings.appearance.light' => 'Light',
			'settings.appearance.active' => 'Active',
			'settings.appearance.activateThemeSemantics' => ({required Object label}) => 'Activate ${label} theme',
			'settings.appearance.zoomLevelSemantics' => 'Text size',
			'settings.general.title' => 'General',
			'settings.general.language.title' => 'Language',
			'settings.general.refreshInterval.title' => 'Refresh interval',
			'settings.general.refreshInterval.description' => 'Saved now for automatic refresh support later. Background refresh is not active yet.',
			'settings.general.refreshInterval.hourly' => 'Every hour',
			'settings.general.refreshInterval.everyThreeHours' => 'Every 3 hours',
			'settings.general.refreshInterval.everySixHours' => 'Every 6 hours',
			'settings.general.refreshInterval.everyTwelveHours' => 'Every 12 hours',
			'settings.general.browserRefresh.title' => 'Browser refresh',
			'settings.general.browserRefresh.description' => 'Many stores block simple requests. Enable a browser in the background to improve automatic price coverage.',
			'settings.general.browserRefresh.enabledDescription' => 'Browser refresh may use additional battery and data while checking stores in the background.',
			'settings.general.browserRefresh.status' => 'Browser refresh is enabled. Android may still delay background work.',
			'settings.general.browserRefresh.fixRestrictions' => 'Fix background restrictions',
			'settings.general.priceAlerts.title' => 'Price drop notifications',
			'settings.general.priceAlerts.description' => 'Get a phone notification when a tracked product reaches a new best price.',
			'settings.general.priceAlerts.enabledDescription' => 'Notifications are enabled for new best prices. Android permission is required.',
			'settings.general.priceAlerts.notificationTitle' => ({required Object name}) => '${name} is cheaper',
			'settings.general.priceAlerts.notificationBody' => ({required Object current, required Object previous}) => 'Now ${current}, down from ${previous}.',
			'settings.general.priceAlerts.permissionDenied' => 'Android notification permission was not granted, so price alerts remain off.',
			'settings.general.priceIncreaseAlerts.title' => 'Price increase notifications',
			'settings.general.priceIncreaseAlerts.description' => 'Get a phone notification when a tracked product\'s best price goes up.',
			'settings.general.priceIncreaseAlerts.enabledDescription' => 'Notifications are enabled for price increases. Android permission is required.',
			'settings.general.priceIncreaseAlerts.notificationTitle' => ({required Object name}) => '${name} got more expensive',
			'settings.general.priceIncreaseAlerts.notificationBody' => ({required Object current, required Object previous}) => 'Now ${current}, up from ${previous}.',
			'settings.general.priceIncreaseAlerts.permissionDenied' => 'Android notification permission was not granted, so price alerts remain off.',
			'settings.general.updates.title' => 'Updates',
			'settings.general.updates.version' => ({required Object version}) => 'Version ${version}',
			'settings.general.updates.checkForUpdates' => 'Check for updates',
			'settings.general.updates.description' => 'Update checking will be added later.',
			'settings.general.updates.notImplemented' => 'Checking for updates is not implemented yet.',
			'settings.general.about.title' => 'About',
			'settings.general.about.copyright' => '© 2026 Soneka96',
			'settings.general.about.privacyPolicy' => 'Privacy & data use',
			'settings.general.about.notImplemented' => 'Privacy & data use is not implemented yet.',
			'enums.cornerStyle.rounded' => 'Rounded',
			'enums.cornerStyle.square' => 'Square',
			'enums.spacingDensity.comfortable' => 'Comfortable',
			'enums.spacingDensity.compact' => 'Compact',
			'enums.settingsCategory.general' => 'General',
			'enums.settingsCategory.appearance' => 'Appearance',
			_ => null,
		};
	}
}
