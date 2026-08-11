///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsPt with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPt({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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

	late final TranslationsPt _root = this; // ignore: unused_field

	@override 
	TranslationsPt $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPt(meta: meta ?? this.$meta);

	// Translations
	@override String get appTitle => 'WorthLoop';
	@override late final _Translations$common$pt common = _Translations$common$pt._(_root);
	@override late final _Translations$home$pt home = _Translations$home$pt._(_root);
	@override late final _Translations$productDetails$pt productDetails = _Translations$productDetails$pt._(_root);
	@override late final _Translations$settings$pt settings = _Translations$settings$pt._(_root);
	@override late final _Translations$enums$pt enums = _Translations$enums$pt._(_root);
}

// Path: common
class _Translations$common$pt implements Translations$common$en {
	_Translations$common$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get refreshSuccessful => 'Atualização concluída';
	@override String get refreshCompletedWithErrors => 'Atualização concluída com erros';
	@override String get refreshFailed => 'Falha na atualização';
}

// Path: home
class _Translations$home$pt implements Translations$home$en {
	_Translations$home$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get subtitle => 'A sua lista, com a melhor oferta atual em primeiro lugar.';
	@override String trackedProducts({required Object count}) => '${count} acompanhados';
	@override String refreshProgress({required Object completed, required Object total}) => 'A atualizar preços · ${completed} de ${total} fontes verificadas';
	@override String get refreshAll => 'Atualizar todos';
	@override String get refreshing => 'A atualizar';
	@override String get refreshAllComplete => 'Todas as fontes foram verificadas.';
	@override String refreshAllPartial({required Object failed}) => 'Atualização concluída; não foi possível verificar ${failed} fontes.';
	@override String get refreshBlockedProduct => 'Já está a ser verificado um produto';
	@override String get refreshBlockedAllProducts => 'Todos os produtos estão a ser verificados';
	@override String sourceRefreshChecking({required Object count}) => 'A verificar ${count} fontes';
	@override String sourceRefreshFailed({required Object merchant}) => 'Não foi possível verificar ${merchant}';
	@override String sourceRefreshFailedCount({required Object count}) => 'Não foi possível verificar ${count} fontes';
	@override String get bestPrice => 'Melhor preço';
	@override String get noAvailablePrice => 'Sem preço disponível';
	@override String get noStore => 'Nenhuma loja com stock';
	@override String storeOffers({required Object count}) => 'Ofertas: ${count}';
	@override String updatedAt({required Object time}) => 'Atualizado às ${time}';
	@override String priceDrop({required Object amount, required Object date}) => '↓ ${amount} desde ${date}';
	@override String priceIncrease({required Object amount, required Object date}) => '↑ ${amount} desde ${date}';
	@override String get emptyTitle => 'Nenhum produto acompanhado';
	@override String get emptyDescription => 'Os produtos acompanhados aparecem aqui com a melhor oferta disponível.';
	@override String get addProductTitle => 'Adicionar produto';
	@override String get addProductDescription => 'Cole um link de produto para começar a acompanhá-lo.';
	@override String get productNameLabel => 'Nome do produto';
	@override String get productNameRequired => 'Introduza o nome do produto.';
	@override String get addProductButton => 'Adicionar produto';
	@override String get addProductSaving => 'A guardar';
	@override String get searchHint => 'Pesquisar nos seus produtos acompanhados';
	@override String get searchClearTooltip => 'Limpar pesquisa';
	@override String get noSearchResultsTitle => 'Sem resultados';
	@override String noSearchResultsDescription({required Object query}) => 'Nenhum produto acompanhado corresponde a "${query}".';
}

// Path: productDetails
class _Translations$productDetails$pt implements Translations$productDetails$en {
	_Translations$productDetails$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String priceDrop({required Object amount, required Object date}) => '↓ ${amount} desde ${date}';
	@override String priceIncrease({required Object amount, required Object date}) => '↑ ${amount} desde ${date}';
	@override String get title => 'Detalhes do produto';
	@override String get backTooltip => 'Voltar';
	@override String get refresh => 'Atualizar';
	@override String get refreshing => 'A atualizar';
	@override String refreshProgress({required Object completed, required Object total}) => '${completed} de ${total} fontes verificadas';
	@override String get otherProductsRefreshing => 'Outros produtos a atualizar';
	@override String get refreshBlockedThisProduct => 'Este produto já está a ser verificado';
	@override String get refreshBlockedOtherProduct => 'Outro produto está a ser verificado';
	@override String get refreshBlockedAllProducts => 'Todos os produtos estão a ser verificados';
	@override String get queued => 'Em fila';
	@override String get checking => 'A verificar';
	@override String get cannotAccessNow => 'Não é possível aceder agora';
	@override String refreshComplete({required Object total}) => 'As ${total} fontes foram verificadas.';
	@override String refreshPartial({required Object completed, required Object total, required Object failed}) => '${completed} de ${total} fontes verificadas; não foi possível aceder a ${failed}.';
	@override String get bestPrice => 'Melhor preço';
	@override String offers({required Object count}) => 'Ofertas em lojas: ${count}';
	@override String get availableOffers => 'Ofertas disponíveis';
	@override String get unavailableOffers => 'Ofertas sem stock';
	@override String get unavailableDescription => 'Estas lojas indicam que não têm stock neste momento.';
	@override String get noOffers => 'Ainda não existem ofertas.';
	@override String get available => 'Em stock';
	@override String get unavailable => 'Sem stock';
	@override String get filterAll => 'Todas';
	@override String get filterAvailable => 'Disponível';
	@override String get filterUnavailable => 'Indisponível';
	@override String get filterIssues => 'Problemas';
	@override String checkedAt({required Object time}) => 'Verificado às ${time}';
	@override String get productNotFound => 'Produto não encontrado';
	@override String get productNotFoundDescription => 'Volte aos produtos acompanhados e escolha novamente um artigo.';
	@override String get refreshBlocked => 'Este site bloqueou a tentativa de atualização. Tente novamente mais tarde.';
	@override String get refreshUnsupported => 'Este site ainda não fornece um preço legível.';
	@override String get refreshNetworkError => 'Não foi possível contactar o site. O último preço continua visível.';
	@override String get refreshInvalidData => 'O site devolveu um preço ilegível. O último preço continua visível.';
	@override String get sourcesTitle => 'Fontes';
	@override String get openOfferFailed => 'Não foi possível abrir a página da loja.';
	@override String get openOfferHint => 'Abre no seu navegador';
	@override String get addSourceTooltip => 'Adicionar fonte';
	@override String get addSourceTitle => 'Adicionar uma fonte';
	@override String get editSourceTitle => 'Editar fonte';
	@override String get sourceUrlLabel => 'Link do site';
	@override String get sourceUrlHint => 'https://exemplo.com/produto';
	@override String get sourceUrlRequired => 'Introduza um link do site.';
	@override String get savingSource => 'A guardar';
	@override String get addSourceButton => 'Adicionar fonte';
	@override String get saveSourceButton => 'Guardar';
	@override String get noSourcesTitle => 'Ainda sem fontes';
	@override String get noSourcesDescription => 'Adicione o link de uma loja para começar a comparar preços deste produto.';
	@override String get editSourceTooltip => 'Editar fonte';
	@override String get deleteSourceTooltip => 'Eliminar fonte';
	@override String get deleteSourceTitle => 'Eliminar esta fonte?';
	@override String deleteSourceMessage({required Object merchant}) => 'Isto remove ${merchant} e a sua oferta deste produto.';
	@override String get deleteSourceConfirmLabel => 'Eliminar';
	@override String get renameProductTooltip => 'Renomear produto';
	@override String get renameProductTitle => 'Renomear produto';
	@override String get productNameLabel => 'Nome do produto';
	@override String get renameProductRequired => 'Introduza o nome do produto.';
	@override String get renameProductButton => 'Guardar';
	@override String get renameProductSaving => 'A guardar';
	@override String get deleteProductTooltip => 'Eliminar produto';
	@override String get deleteProductTitle => 'Eliminar este produto?';
	@override String deleteProductMessage({required Object name}) => 'Isto remove ${name} e todas as suas fontes e ofertas guardadas.';
	@override String get deleteProductConfirmLabel => 'Eliminar';
}

// Path: settings
class _Translations$settings$pt implements Translations$settings$en {
	_Translations$settings$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Definições';
	@override late final _Translations$settings$appearance$pt appearance = _Translations$settings$appearance$pt._(_root);
	@override late final _Translations$settings$general$pt general = _Translations$settings$general$pt._(_root);
	@override late final _Translations$settings$notifications$pt notifications = _Translations$settings$notifications$pt._(_root);
}

// Path: enums
class _Translations$enums$pt implements Translations$enums$en {
	_Translations$enums$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override late final _Translations$enums$cornerStyle$pt cornerStyle = _Translations$enums$cornerStyle$pt._(_root);
	@override late final _Translations$enums$spacingDensity$pt spacingDensity = _Translations$enums$spacingDensity$pt._(_root);
	@override late final _Translations$enums$settingsCategory$pt settingsCategory = _Translations$enums$settingsCategory$pt._(_root);
}

// Path: settings.appearance
class _Translations$settings$appearance$pt implements Translations$settings$appearance$en {
	_Translations$settings$appearance$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

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
class _Translations$settings$general$pt implements Translations$settings$general$en {
	_Translations$settings$general$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Geral';
	@override late final _Translations$settings$general$language$pt language = _Translations$settings$general$language$pt._(_root);
	@override late final _Translations$settings$general$refreshInterval$pt refreshInterval = _Translations$settings$general$refreshInterval$pt._(_root);
	@override late final _Translations$settings$general$browserRefresh$pt browserRefresh = _Translations$settings$general$browserRefresh$pt._(_root);
	@override late final _Translations$settings$general$updates$pt updates = _Translations$settings$general$updates$pt._(_root);
	@override late final _Translations$settings$general$about$pt about = _Translations$settings$general$about$pt._(_root);
}

// Path: settings.notifications
class _Translations$settings$notifications$pt implements Translations$settings$notifications$en {
	_Translations$settings$notifications$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificações';
	@override String get priceAlertsSectionLabel => 'Alertas de preço';
	@override String get refreshActivitySectionLabel => 'Atividade de atualização';
	@override late final _Translations$settings$notifications$priceAlerts$pt priceAlerts = _Translations$settings$notifications$priceAlerts$pt._(_root);
	@override late final _Translations$settings$notifications$priceIncreaseAlerts$pt priceIncreaseAlerts = _Translations$settings$notifications$priceIncreaseAlerts$pt._(_root);
	@override late final _Translations$settings$notifications$refreshCompletedAlerts$pt refreshCompletedAlerts = _Translations$settings$notifications$refreshCompletedAlerts$pt._(_root);
	@override late final _Translations$settings$notifications$showRefreshProgress$pt showRefreshProgress = _Translations$settings$notifications$showRefreshProgress$pt._(_root);
}

// Path: enums.cornerStyle
class _Translations$enums$cornerStyle$pt implements Translations$enums$cornerStyle$en {
	_Translations$enums$cornerStyle$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get rounded => 'Arredondado';
	@override String get square => 'Quadrado';
}

// Path: enums.spacingDensity
class _Translations$enums$spacingDensity$pt implements Translations$enums$spacingDensity$en {
	_Translations$enums$spacingDensity$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get comfortable => 'Confortável';
	@override String get compact => 'Compacto';
}

// Path: enums.settingsCategory
class _Translations$enums$settingsCategory$pt implements Translations$enums$settingsCategory$en {
	_Translations$enums$settingsCategory$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get general => 'Geral';
	@override String get appearance => 'Aparência';
	@override String get notifications => 'Notificações';
}

// Path: settings.general.language
class _Translations$settings$general$language$pt implements Translations$settings$general$language$en {
	_Translations$settings$general$language$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Idioma';
}

// Path: settings.general.refreshInterval
class _Translations$settings$general$refreshInterval$pt implements Translations$settings$general$refreshInterval$en {
	_Translations$settings$general$refreshInterval$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Intervalo de atualização';
	@override String get description => 'Guardado agora para suportar a atualização automática mais tarde. A atualização em segundo plano ainda não está ativa.';
	@override String get hourly => 'A cada hora';
	@override String get everyThreeHours => 'A cada 3 horas';
	@override String get everySixHours => 'A cada 6 horas';
	@override String get everyTwelveHours => 'A cada 12 horas';
}

// Path: settings.general.browserRefresh
class _Translations$settings$general$browserRefresh$pt implements Translations$settings$general$browserRefresh$en {
	_Translations$settings$general$browserRefresh$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Atualização pelo navegador';
	@override String get description => 'Muitas lojas bloqueiam pedidos simples. Ative um navegador em segundo plano para melhorar a cobertura automática de preços.';
	@override String get enabledDescription => 'A atualização pelo navegador pode usar mais bateria e dados ao verificar lojas em segundo plano.';
	@override String get status => 'A atualização pelo navegador está ativa. O Android pode atrasar o trabalho em segundo plano.';
	@override String get fixRestrictions => 'Corrigir restrições de segundo plano';
}

// Path: settings.general.updates
class _Translations$settings$general$updates$pt implements Translations$settings$general$updates$en {
	_Translations$settings$general$updates$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Atualizações';
	@override String version({required Object version}) => 'Versão ${version}';
	@override String get checkForUpdates => 'Verificar atualizações';
	@override String get description => 'A verificação de atualizações será adicionada mais tarde.';
	@override String get notImplemented => 'Verificar atualizações ainda não está implementado.';
}

// Path: settings.general.about
class _Translations$settings$general$about$pt implements Translations$settings$general$about$en {
	_Translations$settings$general$about$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Acerca';
	@override String get copyright => '© 2026 Soneka96';
	@override String get privacyPolicy => 'Privacidade e utilização de dados';
	@override String get notImplemented => 'Privacidade e utilização de dados ainda não está implementado.';
}

// Path: settings.notifications.priceAlerts
class _Translations$settings$notifications$priceAlerts$pt implements Translations$settings$notifications$priceAlerts$en {
	_Translations$settings$notifications$priceAlerts$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificações de descida de preço';
	@override String get description => 'Receba uma notificação quando um produto atingir um novo melhor preço.';
	@override String get enabledDescription => 'As notificações estão ativas para novos melhores preços. É necessária permissão do Android.';
	@override String notificationTitle({required Object name}) => '${name} está mais barato';
	@override String notificationBody({required Object current, required Object previous}) => 'Agora ${current}, antes ${previous}.';
	@override String get permissionDenied => 'A permissão de notificações do Android não foi concedida, por isso os alertas permanecem desligados.';
}

// Path: settings.notifications.priceIncreaseAlerts
class _Translations$settings$notifications$priceIncreaseAlerts$pt implements Translations$settings$notifications$priceIncreaseAlerts$en {
	_Translations$settings$notifications$priceIncreaseAlerts$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificações de subida de preço';
	@override String get description => 'Receba uma notificação quando o melhor preço de um produto seguido subir.';
	@override String get enabledDescription => 'As notificações estão ativas para subidas de preço. É necessária permissão do Android.';
	@override String notificationTitle({required Object name}) => '${name} ficou mais caro';
	@override String notificationBody({required Object current, required Object previous}) => 'Agora ${current}, antes ${previous}.';
	@override String get permissionDenied => 'A permissão de notificações do Android não foi concedida, por isso os alertas permanecem desligados.';
}

// Path: settings.notifications.refreshCompletedAlerts
class _Translations$settings$notifications$refreshCompletedAlerts$pt implements Translations$settings$notifications$refreshCompletedAlerts$en {
	_Translations$settings$notifications$refreshCompletedAlerts$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Notificações de atualização concluída';
	@override String get description => 'Receba uma notificação sempre que uma atualização em segundo plano terminar, mesmo sem alterações.';
	@override String get enabledDescription => 'As notificações estão ativas para todas as atualizações em segundo plano concluídas. É necessária permissão do Android.';
	@override String get permissionDenied => 'A permissão de notificações do Android não foi concedida, por isso as notificações de atualização permanecem desligadas.';
}

// Path: settings.notifications.showRefreshProgress
class _Translations$settings$notifications$showRefreshProgress$pt implements Translations$settings$notifications$showRefreshProgress$en {
	_Translations$settings$notifications$showRefreshProgress$pt._(this._root);

	final TranslationsPt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Mostrar progresso da atualização';
	@override String get description => 'Mostra uma barra de progresso na notificação de atualização em segundo plano enquanto os preços são verificados.';
}

/// The flat map containing all translations for locale <pt>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPt {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appTitle' => 'WorthLoop',
			'common.cancel' => 'Cancelar',
			'common.refreshSuccessful' => 'Atualização concluída',
			'common.refreshCompletedWithErrors' => 'Atualização concluída com erros',
			'common.refreshFailed' => 'Falha na atualização',
			'home.subtitle' => 'A sua lista, com a melhor oferta atual em primeiro lugar.',
			'home.trackedProducts' => ({required Object count}) => '${count} acompanhados',
			'home.refreshProgress' => ({required Object completed, required Object total}) => 'A atualizar preços · ${completed} de ${total} fontes verificadas',
			'home.refreshAll' => 'Atualizar todos',
			'home.refreshing' => 'A atualizar',
			'home.refreshAllComplete' => 'Todas as fontes foram verificadas.',
			'home.refreshAllPartial' => ({required Object failed}) => 'Atualização concluída; não foi possível verificar ${failed} fontes.',
			'home.refreshBlockedProduct' => 'Já está a ser verificado um produto',
			'home.refreshBlockedAllProducts' => 'Todos os produtos estão a ser verificados',
			'home.sourceRefreshChecking' => ({required Object count}) => 'A verificar ${count} fontes',
			'home.sourceRefreshFailed' => ({required Object merchant}) => 'Não foi possível verificar ${merchant}',
			'home.sourceRefreshFailedCount' => ({required Object count}) => 'Não foi possível verificar ${count} fontes',
			'home.bestPrice' => 'Melhor preço',
			'home.noAvailablePrice' => 'Sem preço disponível',
			'home.noStore' => 'Nenhuma loja com stock',
			'home.storeOffers' => ({required Object count}) => 'Ofertas: ${count}',
			'home.updatedAt' => ({required Object time}) => 'Atualizado às ${time}',
			'home.priceDrop' => ({required Object amount, required Object date}) => '↓ ${amount} desde ${date}',
			'home.priceIncrease' => ({required Object amount, required Object date}) => '↑ ${amount} desde ${date}',
			'home.emptyTitle' => 'Nenhum produto acompanhado',
			'home.emptyDescription' => 'Os produtos acompanhados aparecem aqui com a melhor oferta disponível.',
			'home.addProductTitle' => 'Adicionar produto',
			'home.addProductDescription' => 'Cole um link de produto para começar a acompanhá-lo.',
			'home.productNameLabel' => 'Nome do produto',
			'home.productNameRequired' => 'Introduza o nome do produto.',
			'home.addProductButton' => 'Adicionar produto',
			'home.addProductSaving' => 'A guardar',
			'home.searchHint' => 'Pesquisar nos seus produtos acompanhados',
			'home.searchClearTooltip' => 'Limpar pesquisa',
			'home.noSearchResultsTitle' => 'Sem resultados',
			'home.noSearchResultsDescription' => ({required Object query}) => 'Nenhum produto acompanhado corresponde a "${query}".',
			'productDetails.priceDrop' => ({required Object amount, required Object date}) => '↓ ${amount} desde ${date}',
			'productDetails.priceIncrease' => ({required Object amount, required Object date}) => '↑ ${amount} desde ${date}',
			'productDetails.title' => 'Detalhes do produto',
			'productDetails.backTooltip' => 'Voltar',
			'productDetails.refresh' => 'Atualizar',
			'productDetails.refreshing' => 'A atualizar',
			'productDetails.refreshProgress' => ({required Object completed, required Object total}) => '${completed} de ${total} fontes verificadas',
			'productDetails.otherProductsRefreshing' => 'Outros produtos a atualizar',
			'productDetails.refreshBlockedThisProduct' => 'Este produto já está a ser verificado',
			'productDetails.refreshBlockedOtherProduct' => 'Outro produto está a ser verificado',
			'productDetails.refreshBlockedAllProducts' => 'Todos os produtos estão a ser verificados',
			'productDetails.queued' => 'Em fila',
			'productDetails.checking' => 'A verificar',
			'productDetails.cannotAccessNow' => 'Não é possível aceder agora',
			'productDetails.refreshComplete' => ({required Object total}) => 'As ${total} fontes foram verificadas.',
			'productDetails.refreshPartial' => ({required Object completed, required Object total, required Object failed}) => '${completed} de ${total} fontes verificadas; não foi possível aceder a ${failed}.',
			'productDetails.bestPrice' => 'Melhor preço',
			'productDetails.offers' => ({required Object count}) => 'Ofertas em lojas: ${count}',
			'productDetails.availableOffers' => 'Ofertas disponíveis',
			'productDetails.unavailableOffers' => 'Ofertas sem stock',
			'productDetails.unavailableDescription' => 'Estas lojas indicam que não têm stock neste momento.',
			'productDetails.noOffers' => 'Ainda não existem ofertas.',
			'productDetails.available' => 'Em stock',
			'productDetails.unavailable' => 'Sem stock',
			'productDetails.filterAll' => 'Todas',
			'productDetails.filterAvailable' => 'Disponível',
			'productDetails.filterUnavailable' => 'Indisponível',
			'productDetails.filterIssues' => 'Problemas',
			'productDetails.checkedAt' => ({required Object time}) => 'Verificado às ${time}',
			'productDetails.productNotFound' => 'Produto não encontrado',
			'productDetails.productNotFoundDescription' => 'Volte aos produtos acompanhados e escolha novamente um artigo.',
			'productDetails.refreshBlocked' => 'Este site bloqueou a tentativa de atualização. Tente novamente mais tarde.',
			'productDetails.refreshUnsupported' => 'Este site ainda não fornece um preço legível.',
			'productDetails.refreshNetworkError' => 'Não foi possível contactar o site. O último preço continua visível.',
			'productDetails.refreshInvalidData' => 'O site devolveu um preço ilegível. O último preço continua visível.',
			'productDetails.sourcesTitle' => 'Fontes',
			'productDetails.openOfferFailed' => 'Não foi possível abrir a página da loja.',
			'productDetails.openOfferHint' => 'Abre no seu navegador',
			'productDetails.addSourceTooltip' => 'Adicionar fonte',
			'productDetails.addSourceTitle' => 'Adicionar uma fonte',
			'productDetails.editSourceTitle' => 'Editar fonte',
			'productDetails.sourceUrlLabel' => 'Link do site',
			'productDetails.sourceUrlHint' => 'https://exemplo.com/produto',
			'productDetails.sourceUrlRequired' => 'Introduza um link do site.',
			'productDetails.savingSource' => 'A guardar',
			'productDetails.addSourceButton' => 'Adicionar fonte',
			'productDetails.saveSourceButton' => 'Guardar',
			'productDetails.noSourcesTitle' => 'Ainda sem fontes',
			'productDetails.noSourcesDescription' => 'Adicione o link de uma loja para começar a comparar preços deste produto.',
			'productDetails.editSourceTooltip' => 'Editar fonte',
			'productDetails.deleteSourceTooltip' => 'Eliminar fonte',
			'productDetails.deleteSourceTitle' => 'Eliminar esta fonte?',
			'productDetails.deleteSourceMessage' => ({required Object merchant}) => 'Isto remove ${merchant} e a sua oferta deste produto.',
			'productDetails.deleteSourceConfirmLabel' => 'Eliminar',
			'productDetails.renameProductTooltip' => 'Renomear produto',
			'productDetails.renameProductTitle' => 'Renomear produto',
			'productDetails.productNameLabel' => 'Nome do produto',
			'productDetails.renameProductRequired' => 'Introduza o nome do produto.',
			'productDetails.renameProductButton' => 'Guardar',
			'productDetails.renameProductSaving' => 'A guardar',
			'productDetails.deleteProductTooltip' => 'Eliminar produto',
			'productDetails.deleteProductTitle' => 'Eliminar este produto?',
			'productDetails.deleteProductMessage' => ({required Object name}) => 'Isto remove ${name} e todas as suas fontes e ofertas guardadas.',
			'productDetails.deleteProductConfirmLabel' => 'Eliminar',
			'settings.title' => 'Definições',
			'settings.appearance.title' => 'Aparência',
			'settings.appearance.theme' => 'Tema',
			'settings.appearance.cornerStyle' => 'Estilo de cantos',
			'settings.appearance.density' => 'Densidade',
			'settings.appearance.font' => 'Tipo de letra',
			'settings.appearance.zoom' => 'Tamanho do texto',
			'settings.appearance.dark' => 'Escuro',
			'settings.appearance.light' => 'Claro',
			'settings.appearance.active' => 'Ativo',
			'settings.appearance.activateThemeSemantics' => ({required Object label}) => 'Ativar tema ${label}',
			'settings.appearance.zoomLevelSemantics' => 'Tamanho do texto',
			'settings.general.title' => 'Geral',
			'settings.general.language.title' => 'Idioma',
			'settings.general.refreshInterval.title' => 'Intervalo de atualização',
			'settings.general.refreshInterval.description' => 'Guardado agora para suportar a atualização automática mais tarde. A atualização em segundo plano ainda não está ativa.',
			'settings.general.refreshInterval.hourly' => 'A cada hora',
			'settings.general.refreshInterval.everyThreeHours' => 'A cada 3 horas',
			'settings.general.refreshInterval.everySixHours' => 'A cada 6 horas',
			'settings.general.refreshInterval.everyTwelveHours' => 'A cada 12 horas',
			'settings.general.browserRefresh.title' => 'Atualização pelo navegador',
			'settings.general.browserRefresh.description' => 'Muitas lojas bloqueiam pedidos simples. Ative um navegador em segundo plano para melhorar a cobertura automática de preços.',
			'settings.general.browserRefresh.enabledDescription' => 'A atualização pelo navegador pode usar mais bateria e dados ao verificar lojas em segundo plano.',
			'settings.general.browserRefresh.status' => 'A atualização pelo navegador está ativa. O Android pode atrasar o trabalho em segundo plano.',
			'settings.general.browserRefresh.fixRestrictions' => 'Corrigir restrições de segundo plano',
			'settings.general.updates.title' => 'Atualizações',
			'settings.general.updates.version' => ({required Object version}) => 'Versão ${version}',
			'settings.general.updates.checkForUpdates' => 'Verificar atualizações',
			'settings.general.updates.description' => 'A verificação de atualizações será adicionada mais tarde.',
			'settings.general.updates.notImplemented' => 'Verificar atualizações ainda não está implementado.',
			'settings.general.about.title' => 'Acerca',
			'settings.general.about.copyright' => '© 2026 Soneka96',
			'settings.general.about.privacyPolicy' => 'Privacidade e utilização de dados',
			'settings.general.about.notImplemented' => 'Privacidade e utilização de dados ainda não está implementado.',
			'settings.notifications.title' => 'Notificações',
			'settings.notifications.priceAlertsSectionLabel' => 'Alertas de preço',
			'settings.notifications.refreshActivitySectionLabel' => 'Atividade de atualização',
			'settings.notifications.priceAlerts.title' => 'Notificações de descida de preço',
			'settings.notifications.priceAlerts.description' => 'Receba uma notificação quando um produto atingir um novo melhor preço.',
			'settings.notifications.priceAlerts.enabledDescription' => 'As notificações estão ativas para novos melhores preços. É necessária permissão do Android.',
			'settings.notifications.priceAlerts.notificationTitle' => ({required Object name}) => '${name} está mais barato',
			'settings.notifications.priceAlerts.notificationBody' => ({required Object current, required Object previous}) => 'Agora ${current}, antes ${previous}.',
			'settings.notifications.priceAlerts.permissionDenied' => 'A permissão de notificações do Android não foi concedida, por isso os alertas permanecem desligados.',
			'settings.notifications.priceIncreaseAlerts.title' => 'Notificações de subida de preço',
			'settings.notifications.priceIncreaseAlerts.description' => 'Receba uma notificação quando o melhor preço de um produto seguido subir.',
			'settings.notifications.priceIncreaseAlerts.enabledDescription' => 'As notificações estão ativas para subidas de preço. É necessária permissão do Android.',
			'settings.notifications.priceIncreaseAlerts.notificationTitle' => ({required Object name}) => '${name} ficou mais caro',
			'settings.notifications.priceIncreaseAlerts.notificationBody' => ({required Object current, required Object previous}) => 'Agora ${current}, antes ${previous}.',
			'settings.notifications.priceIncreaseAlerts.permissionDenied' => 'A permissão de notificações do Android não foi concedida, por isso os alertas permanecem desligados.',
			'settings.notifications.refreshCompletedAlerts.title' => 'Notificações de atualização concluída',
			'settings.notifications.refreshCompletedAlerts.description' => 'Receba uma notificação sempre que uma atualização em segundo plano terminar, mesmo sem alterações.',
			'settings.notifications.refreshCompletedAlerts.enabledDescription' => 'As notificações estão ativas para todas as atualizações em segundo plano concluídas. É necessária permissão do Android.',
			'settings.notifications.refreshCompletedAlerts.permissionDenied' => 'A permissão de notificações do Android não foi concedida, por isso as notificações de atualização permanecem desligadas.',
			'settings.notifications.showRefreshProgress.title' => 'Mostrar progresso da atualização',
			'settings.notifications.showRefreshProgress.description' => 'Mostra uma barra de progresso na notificação de atualização em segundo plano enquanto os preços são verificados.',
			'enums.cornerStyle.rounded' => 'Arredondado',
			'enums.cornerStyle.square' => 'Quadrado',
			'enums.spacingDensity.comfortable' => 'Confortável',
			'enums.spacingDensity.compact' => 'Compacto',
			'enums.settingsCategory.general' => 'Geral',
			'enums.settingsCategory.appearance' => 'Aparência',
			'enums.settingsCategory.notifications' => 'Notificações',
			_ => null,
		};
	}
}
