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

	/// en: 'Tamagotchi'
	String get appName => 'Tamagotchi';

	late final TranslationsSplashEn splash = TranslationsSplashEn._(_root);
	late final TranslationsPermissionsEn permissions = TranslationsPermissionsEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsNavEn nav = TranslationsNavEn._(_root);
	late final TranslationsAchievementsEn achievements = TranslationsAchievementsEn._(_root);
	late final TranslationsGameEn game = TranslationsGameEn._(_root);
}

// Path: splash
class TranslationsSplashEn {
	TranslationsSplashEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading... $progress%'
	String loading({required Object progress}) => 'Loading... ${progress}%';

	/// en: 'Ready!'
	String get ready => 'Ready!';
}

// Path: permissions
class TranslationsPermissionsEn {
	TranslationsPermissionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Step Counter'
	String get activityTitle => 'Step Counter';

	/// en: 'Tamagotchi needs access to your physical activity to count your steps and keep your pet happy!'
	String get activityDescription => 'Tamagotchi needs access to your physical activity to count your steps and keep your pet happy!';

	/// en: 'Allow'
	String get allow => 'Allow';

	/// en: 'Not now'
	String get deny => 'Not now';

	/// en: 'Permission Denied'
	String get deniedTitle => 'Permission Denied';

	/// en: 'Step counting will not be available. You can enable it later in settings.'
	String get deniedMessage => 'Step counting will not be available. You can enable it later in settings.';

	/// en: 'OK'
	String get ok => 'OK';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsHomeStatsEn stats = TranslationsHomeStatsEn._(_root);

	/// en: 'Age: $age'
	String age({required Object age}) => 'Age: ${age}';

	late final TranslationsHomeCleaningEn cleaning = TranslationsHomeCleaningEn._(_root);
}

// Path: nav
class TranslationsNavEn {
	TranslationsNavEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'GAME'
	String get game => 'GAME';

	/// en: 'HOME'
	String get home => 'HOME';

	/// en: 'ACHIEVEMENTS'
	String get achievements => 'ACHIEVEMENTS';
}

// Path: achievements
class TranslationsAchievementsEn {
	TranslationsAchievementsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Achievements'
	String get title => 'Achievements';

	/// en: 'Achievements page - to implement'
	String get placeholder => 'Achievements page - to implement';
}

// Path: game
class TranslationsGameEn {
	TranslationsGameEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsGameRulesEn rules = TranslationsGameRulesEn._(_root);
	late final TranslationsGameHintsEn hints = TranslationsGameHintsEn._(_root);
	late final TranslationsGameWonEn won = TranslationsGameWonEn._(_root);
	late final TranslationsGameLostEn lost = TranslationsGameLostEn._(_root);
}

// Path: home.stats
class TranslationsHomeStatsEn {
	TranslationsHomeStatsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'HUNGER'
	String get hunger => 'HUNGER';

	/// en: 'ENERGY'
	String get energy => 'ENERGY';

	/// en: 'HAPPINESS'
	String get happiness => 'HAPPINESS';

	/// en: 'HYGIENE'
	String get hygiene => 'HYGIENE';
}

// Path: home.cleaning
class TranslationsHomeCleaningEn {
	TranslationsHomeCleaningEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Rub!'
	String get instruction => 'Rub!';

	/// en: 'Exit'
	String get exit => 'Exit';
}

// Path: game.rules
class TranslationsGameRulesEn {
	TranslationsGameRulesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '$name wants to play!'
	String title({required Object name}) => '${name} wants to play!';

	/// en: '$name will make you guess a number between 1 and 100 by giving you hints.'
	String description({required Object name}) => '${name} will make you guess a number between 1 and 100 by giving you hints.';

	/// en: 'You have 10 attempts to find it, will you succeed?'
	String get challenge => 'You have 10 attempts to find it, will you succeed?';

	/// en: 'Start'
	String get start => 'Start';
}

// Path: game.hints
class TranslationsGameHintsEn {
	TranslationsGameHintsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Higher!'
	String get higher => 'Higher!';

	/// en: 'Lower!'
	String get lower => 'Lower!';
}

// Path: game.won
class TranslationsGameWonEn {
	TranslationsGameWonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Yeah, correct answer!'
	String get title => 'Yeah, correct answer!';

	/// en: 'Congratulations! You found it in $attempts attempts!'
	String description({required Object attempts}) => 'Congratulations! You found it in ${attempts} attempts!';

	/// en: 'Return home'
	String get returnHome => 'Return home';
}

// Path: game.lost
class TranslationsGameLostEn {
	TranslationsGameLostEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Oh no... so close...'
	String get title => 'Oh no... so close...';

	/// en: 'You'll certainly succeed next time.'
	String get description => 'You\'ll certainly succeed next time.';

	/// en: 'Return home'
	String get returnHome => 'Return home';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'Tamagotchi',
			'splash.loading' => ({required Object progress}) => 'Loading... ${progress}%',
			'splash.ready' => 'Ready!',
			'permissions.activityTitle' => 'Step Counter',
			'permissions.activityDescription' => 'Tamagotchi needs access to your physical activity to count your steps and keep your pet happy!',
			'permissions.allow' => 'Allow',
			'permissions.deny' => 'Not now',
			'permissions.deniedTitle' => 'Permission Denied',
			'permissions.deniedMessage' => 'Step counting will not be available. You can enable it later in settings.',
			'permissions.ok' => 'OK',
			'home.stats.hunger' => 'HUNGER',
			'home.stats.energy' => 'ENERGY',
			'home.stats.happiness' => 'HAPPINESS',
			'home.stats.hygiene' => 'HYGIENE',
			'home.age' => ({required Object age}) => 'Age: ${age}',
			'home.cleaning.instruction' => 'Rub!',
			'home.cleaning.exit' => 'Exit',
			'nav.game' => 'GAME',
			'nav.home' => 'HOME',
			'nav.achievements' => 'ACHIEVEMENTS',
			'achievements.title' => 'Achievements',
			'achievements.placeholder' => 'Achievements page - to implement',
			'game.rules.title' => ({required Object name}) => '${name} wants to play!',
			'game.rules.description' => ({required Object name}) => '${name} will make you guess a number between 1 and 100 by giving you hints.',
			'game.rules.challenge' => 'You have 10 attempts to find it, will you succeed?',
			'game.rules.start' => 'Start',
			'game.hints.higher' => 'Higher!',
			'game.hints.lower' => 'Lower!',
			'game.won.title' => 'Yeah, correct answer!',
			'game.won.description' => ({required Object attempts}) => 'Congratulations! You found it in ${attempts} attempts!',
			'game.won.returnHome' => 'Return home',
			'game.lost.title' => 'Oh no... so close...',
			'game.lost.description' => 'You\'ll certainly succeed next time.',
			'game.lost.returnHome' => 'Return home',
			_ => null,
		};
	}
}
