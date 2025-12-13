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
class TranslationsFr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override 
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'Tamagotchi';
	@override late final _TranslationsSplashFr splash = _TranslationsSplashFr._(_root);
	@override late final _TranslationsPermissionsFr permissions = _TranslationsPermissionsFr._(_root);
	@override late final _TranslationsHomeFr home = _TranslationsHomeFr._(_root);
	@override late final _TranslationsNavFr nav = _TranslationsNavFr._(_root);
	@override late final _TranslationsAchievementsFr achievements = _TranslationsAchievementsFr._(_root);
	@override late final _TranslationsGameFr game = _TranslationsGameFr._(_root);
	@override late final _TranslationsGameOverFr gameOver = _TranslationsGameOverFr._(_root);
	@override late final _TranslationsNamingFr naming = _TranslationsNamingFr._(_root);
}

// Path: splash
class _TranslationsSplashFr implements TranslationsSplashEn {
	_TranslationsSplashFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String loading({required Object progress}) => 'Chargement... ${progress}%';
	@override String get ready => 'Prêt !';
}

// Path: permissions
class _TranslationsPermissionsFr implements TranslationsPermissionsEn {
	_TranslationsPermissionsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get activityTitle => 'Compteur de pas';
	@override String get activityDescription => 'Tamagotchi a besoin d\'accéder à votre activité physique pour compter vos pas et garder votre animal heureux !';
	@override String get allow => 'Autoriser';
	@override String get deny => 'Plus tard';
	@override String get deniedTitle => 'Permission refusée';
	@override String get deniedMessage => 'Le compteur de pas ne sera pas disponible. Vous pouvez l\'activer plus tard dans les paramètres.';
	@override String get ok => 'OK';
}

// Path: home
class _TranslationsHomeFr implements TranslationsHomeEn {
	_TranslationsHomeFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsHomeStatsFr stats = _TranslationsHomeStatsFr._(_root);
	@override String age({required Object age}) => 'Age: ${age}';
	@override late final _TranslationsHomeCleaningFr cleaning = _TranslationsHomeCleaningFr._(_root);
}

// Path: nav
class _TranslationsNavFr implements TranslationsNavEn {
	_TranslationsNavFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get game => 'JEU';
	@override String get home => 'CHAMBRE';
	@override String get achievements => 'SUCCÈS';
}

// Path: achievements
class _TranslationsAchievementsFr implements TranslationsAchievementsEn {
	_TranslationsAchievementsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Succès';
	@override String get placeholder => 'Page Succès - à implémenter';
}

// Path: game
class _TranslationsGameFr implements TranslationsGameEn {
	_TranslationsGameFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsGameRulesFr rules = _TranslationsGameRulesFr._(_root);
	@override late final _TranslationsGameHintsFr hints = _TranslationsGameHintsFr._(_root);
	@override late final _TranslationsGameWonFr won = _TranslationsGameWonFr._(_root);
	@override late final _TranslationsGameLostFr lost = _TranslationsGameLostFr._(_root);
}

// Path: gameOver
class _TranslationsGameOverFr implements TranslationsGameOverEn {
	_TranslationsGameOverFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Repose en paix';
	@override String lived({required Object age}) => 'A vécu ${age} jour(s)';
	@override String get message => 'Votre compagnon a rejoint les étoiles.\nMais un nouvel ami vous attend peut-être...';
	@override String get newGame => 'Adopter un nouveau Tamagotchi';
}

// Path: naming
class _TranslationsNamingFr implements TranslationsNamingEn {
	_TranslationsNamingFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get welcome => 'Bienvenue !';
	@override String get question => 'Comment voulez-vous appeler votre nouveau compagnon ?';
	@override String get placeholder => 'Nom du Tamagotchi';
	@override String get emptyError => 'Veuillez entrer un nom pour votre Tamagotchi';
	@override String get create => 'Créer mon Tamagotchi';
}

// Path: home.stats
class _TranslationsHomeStatsFr implements TranslationsHomeStatsEn {
	_TranslationsHomeStatsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get hunger => 'FAIM';
	@override String get energy => 'ÉNERGIE';
	@override String get happiness => 'JOIE';
	@override String get hygiene => 'HYGIÈNE';
}

// Path: home.cleaning
class _TranslationsHomeCleaningFr implements TranslationsHomeCleaningEn {
	_TranslationsHomeCleaningFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get instruction => 'Frotte !';
	@override String get exit => 'Quitter';
}

// Path: game.rules
class _TranslationsGameRulesFr implements TranslationsGameRulesEn {
	_TranslationsGameRulesFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String title({required Object name}) => '${name} souhaite jouer !';
	@override String description({required Object name}) => '${name} va vous faire deviner un nombre entre 1 et 100 en vous donnant des indices.';
	@override String get challenge => 'Vous avez 10 essais pour le trouver, y arriverez-vous ?';
	@override String get start => 'Démarrer';
}

// Path: game.hints
class _TranslationsGameHintsFr implements TranslationsGameHintsEn {
	_TranslationsGameHintsFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get higher => 'Plus grand !';
	@override String get lower => 'Plus petit !';
}

// Path: game.won
class _TranslationsGameWonFr implements TranslationsGameWonEn {
	_TranslationsGameWonFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Yeah, bonne réponse !';
	@override String description({required Object attempts}) => 'Félicitations ! Vous avez trouvé en ${attempts} coups !';
	@override String get returnHome => 'Retour à la maison';
}

// Path: game.lost
class _TranslationsGameLostFr implements TranslationsGameLostEn {
	_TranslationsGameLostFr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Oh non... si proche...';
	@override String get description => 'Vous réussirez certainement la prochaine fois.';
	@override String get returnHome => 'Retour à la maison';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Tamagotchi',
			'splash.loading' => ({required Object progress}) => 'Chargement... ${progress}%',
			'splash.ready' => 'Prêt !',
			'permissions.activityTitle' => 'Compteur de pas',
			'permissions.activityDescription' => 'Tamagotchi a besoin d\'accéder à votre activité physique pour compter vos pas et garder votre animal heureux !',
			'permissions.allow' => 'Autoriser',
			'permissions.deny' => 'Plus tard',
			'permissions.deniedTitle' => 'Permission refusée',
			'permissions.deniedMessage' => 'Le compteur de pas ne sera pas disponible. Vous pouvez l\'activer plus tard dans les paramètres.',
			'permissions.ok' => 'OK',
			'home.stats.hunger' => 'FAIM',
			'home.stats.energy' => 'ÉNERGIE',
			'home.stats.happiness' => 'JOIE',
			'home.stats.hygiene' => 'HYGIÈNE',
			'home.age' => ({required Object age}) => 'Age: ${age}',
			'home.cleaning.instruction' => 'Frotte !',
			'home.cleaning.exit' => 'Quitter',
			'nav.game' => 'JEU',
			'nav.home' => 'CHAMBRE',
			'nav.achievements' => 'SUCCÈS',
			'achievements.title' => 'Succès',
			'achievements.placeholder' => 'Page Succès - à implémenter',
			'game.rules.title' => ({required Object name}) => '${name} souhaite jouer !',
			'game.rules.description' => ({required Object name}) => '${name} va vous faire deviner un nombre entre 1 et 100 en vous donnant des indices.',
			'game.rules.challenge' => 'Vous avez 10 essais pour le trouver, y arriverez-vous ?',
			'game.rules.start' => 'Démarrer',
			'game.hints.higher' => 'Plus grand !',
			'game.hints.lower' => 'Plus petit !',
			'game.won.title' => 'Yeah, bonne réponse !',
			'game.won.description' => ({required Object attempts}) => 'Félicitations ! Vous avez trouvé en ${attempts} coups !',
			'game.won.returnHome' => 'Retour à la maison',
			'game.lost.title' => 'Oh non... si proche...',
			'game.lost.description' => 'Vous réussirez certainement la prochaine fois.',
			'game.lost.returnHome' => 'Retour à la maison',
			'gameOver.title' => 'Repose en paix',
			'gameOver.lived' => ({required Object age}) => 'A vécu ${age} jour(s)',
			'gameOver.message' => 'Votre compagnon a rejoint les étoiles.\nMais un nouvel ami vous attend peut-être...',
			'gameOver.newGame' => 'Adopter un nouveau Tamagotchi',
			'naming.welcome' => 'Bienvenue !',
			'naming.question' => 'Comment voulez-vous appeler votre nouveau compagnon ?',
			'naming.placeholder' => 'Nom du Tamagotchi',
			'naming.emptyError' => 'Veuillez entrer un nom pour votre Tamagotchi',
			'naming.create' => 'Créer mon Tamagotchi',
			_ => null,
		};
	}
}
