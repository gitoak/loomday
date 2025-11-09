Riverpod 3.x Case Study for a Large Flutter App
Project Structure for a Scalable App
Organizing code by feature and layer is crucial in a large (~60k LOC) app. A feature-first folder structure
ensures separation of concerns and scalability :
lib/core/ – Shared services and cross-cutting concerns (e.g. logging, theming, routing, localization).
Example: core/logging/logger.dart for logging utilities, core/di/providers.dart for
global providers, core/theme/ for theming, etc.
lib/features/ – Each feature in its own folder, encapsulating its layers:
presentation/ – UI widgets, screens, and Riverpod providers specific to UI state or controllers.
domain/ – Business logic (e.g. entities, use-cases, repository interfaces). Pure Dart code with no
Flutter dependencies.
data/ – Data sources, models (DTOs), and repository implementations (e.g. API clients, database
access).
lib/l10n/ – Localization ARB files and the generated app*localizations.dart (as produced by
Flutter’s gen-l10n).
lib/main.dart – App entry point; sets up the ProviderScope and runs MyApp .
This feature-based, layered architecture yields clear separation of concerns . Each feature is isolated,
making it easy to add or refactor features without breaking others. Business logic is decoupled from UI,
improving testability and maintainability. For example, providers that handle core logic (e.g. a settings
controller) live within the feature or core layer appropriate to their scope, rather than a single global file
. Global services (like logging or theme) reside in core, while feature-specific state (like a
HomeScreenController ) resides in that feature’s presentation layer. This organization aligns with Clean
Architecture principles (UI -> providers -> domain -> data) and makes the app scalable and team-friendly.
Using Riverpod 3 with Hooks and Code Generation
Riverpod 3.x (hooks_riverpod ^3.0.3) offers an optional code generation system to streamline provider
definitions. We will leverage:
hooks_riverpod: Integrates Riverpod with Flutter Hooks for more ergonomic UI code (allowing
HookConsumerWidget and hooks like useState , useEffect in widgets). This avoids verbose
StatefulWidget boilerplate for local state or side effects in the UI. For example, you can use
HookConsumerWidget and call ref.watch(...) or ref.listen(...) directly alongside
hook functions, making widget code concise.
riverpod_annotation + build_runner: Enables the @riverpod annotation to auto-generate
providers. Instead of writing Provider / StateNotifierProvider classes by hand, you
annotate functions or classes and run the build runner to generate the code in \*.g.dart files .
1 2
•
•
•
•
•
•
•
•
3
4
•
•
5 6
1
Setting up code generation: Add riverpod_annotation (and riverpod_generator ) to
pubspec.yaml (as a dev dependency), and ensure build_runner is listed as a dev tool. For example:
dependencies:
hooks_riverpod: ^3.0.3
riverpod_annotation: ^3.0.3
dev_dependencies:
build_runner: ^2.3.3
riverpod_generator: ^3.0.3
Also add part directives to your Dart files where you use @riverpod so the generated code will merge
in. For instance, in providers.dart :
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'providers.g.dart'; // generated code
Now you can define providers using the new syntax. Functional providers (annotated top-level functions)
are great for read-only or computed values, and class-based providers (annotated classes extending
*$Name ) allow state and methods (like Notifiers).
Example of an auto-generated provider from a function:
@riverpod
Future<User> fetchUser(FetchUserRef ref, {required int userId}) async {
// This will generate a FutureProvider automatically
final api = ref.watch(apiClientProvider);
final response = await api.getUser(userId);
return User.fromJson(response);
}
Here, the code generator will create a fetchUserProvider (a FutureProvider ) for us, inferring the
types and using autoDispose by default. We can use
ref.watch(fetchUserProvider(userId: 42)) in the UI without manually writing the provider class
. We also avoid the old .family syntax – parameters can be regular function arguments (named or
positional) .
For stateful logic, we use Riverpod’s new Notifier classes. Notifiers were introduced in Riverpod 2+ to
replace legacy StateNotifier with a simpler API . You define a class extending _$YourClass with
a build() method (to initialize state) and any number of methods to mutate state or perform side
effects. The generator creates the corresponding NotifierProvider automatically . For example:
7
8
9
10
2
@riverpod
class Counter extends _$Counter {
@override
int build() {
// initial state
return 0;
}
void increment() {
state++;
// We can use ref inside Notifier classes if needed for side effects
ref.read(loggerProvider).d('Counter incremented to $state');
}
}
This generates a counterProvider of type NotifierProvider<Counter, int> under the hood. In
the UI, we can do final count = ref.watch(counterProvider); to get the current count, and call
ref.read(counterProvider.notifier).increment() to trigger a change. The Notifier approach has
multiple benefits: we no longer need to pass Ref into the constructor or function (the base class provides
ref ), and we avoid manually writing the provider declaration, reducing boilerplate . It also supports
stateful hot-reload – when you modify the provider’s code, Riverpod can hot-reload just that provider’s
state without losing the rest of the app’s state .
Auto-disposal: By default, all providers generated with @riverpod are autoDispose, meaning they
release resources when no longer listened to . This is sensible for large apps to avoid memory leaks. If
you have truly global singletons (like an AppLogger or configuration), you can opt-out by setting
keepAlive: true on the annotation so the provider lives for the app lifetime.
Build runner workflow: One trade-off of using code generation is the overhead of running build_runner.
Even a simple provider produces ~15 lines of generated code, which can clutter diffs and slow build times
. In a team setting, you must ensure everyone runs dart run build_runner watch during
development or include the generated files in version control . This adds some complexity to CI/CD as
well (e.g. running codegen on CI) . If your project already uses codegen (e.g. Freezed for model classes,
JSON serialization), adding Riverpod’s generator is usually worth it for the productivity gains . But if not,
consider the build cost. In practice, on a modern machine codegen is fast (sub-second on incremental
changes) , and the benefits in clarity and reduction of boilerplate can outweigh the drawbacks for large
apps.
Summary of patterns: With Riverpod 3 + codegen, you will primarily use @riverpod for all providers.
Use functional providers for simple derived values or read-only dependencies, and Notifier (class)
providers for any state you need to modify (which replaces the older StateNotifier pattern) . Continue to
use ConsumerWidget/HookConsumerWidget in the UI to listen to providers. The hooks integration is
optional but helpful; for example, in a HookConsumerWidget you might use useEffect to perform an
action when a provider’s value changes, or use useState for local transient state (like controlling a
TextField). Hooks can simplify UI code by eliminating the need for separate State classes or manual
didUpdateWidget logic. Overall, Riverpod’s newest APIs let you write less boilerplate and organize state
logically by feature, which is ideal in a large-scale app architecture.
11
12
13
14
15
16
17
18
19
20
3
Example: Global Logging with Riverpod
In a large app, a logging utility is often needed across UI and business logic. We set up a global AppLogger
service and expose it via a Riverpod provider. This ensures any part of the app can request a logger instance
via ref.read , rather than using global singletons or passing dependencies manually.
Logger service: In lib/core/logging/logger.dart , define a simple logger. For illustration, we’ll create
a basic logger that prints messages (in a real app, this could wrap a package like logger for colored logs,
or send logs to a server in production):
// core/logging/logger.dart
import 'dart:developer'; // or use Flutter's debugPrint
class AppLogger {
void d(String message) {
debugPrint(' $message'); // debug log
}
void i(String message) {
debugPrint('ℹ $message'); // info log
}
void e(String message, [Object? error]) {
debugPrint('⛔ $message ${error ?? ''}');
}
}
Providing the logger: In our dependency injection setup ( core/di/providers.dart ), we create a
provider for AppLogger . Using the code-gen approach, it could look like:
// core/di/providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../logging/logger.dart';
part 'providers.g.dart';
@Riverpod(keepAlive: true) // not auto-disposed; persists for app lifetime
AppLogger logger(LoggerRef ref) => AppLogger();
This will generate a loggerProvider . (In a simpler form, without codegen, you could also do final
loggerProvider = Provider((ref) => AppLogger()); – our approach above achieves the same
but aligns with the unified codegen style.)
Now, any widget or provider can obtain the logger. For example, in the root MyApp (inside build ):
21
4
final env = ref.watch(envProvider); // environment config
ref.read(loggerProvider).d('Booting app with env: ${env.name}');【36†L18-L25】
Here we log an app start message including the current environment (perhaps dev , prod , etc.). Because
loggerProvider is global, we call ref.read to use it without making the UI rebuild on log calls (we
don’t need to rebuild the widget just because a log was written) .
Using Logger in UI components: For a UI example, suppose we have a button that when pressed should
log an event (e.g., user clicked a feature). In a ConsumerWidget or HookConsumerWidget, you can do:
class PurchaseButton extends ConsumerWidget {
@override
Widget build(BuildContext context, WidgetRef ref) {
return ElevatedButton(
onPressed: () {
ref.read(loggerProvider).i("Purchase button clicked");
// ... handle button action ...
},
child: Text('Buy'),
);
}
}
We use ref.read inside the onPressed callback to log an info message. Using Riverpod here means we
didn’t have to pass a Logger instance into this widget; any Consumer can grab it from the container. This
also makes testing easier – in tests, you could override loggerProvider with a mock logger that asserts
certain messages are logged.
Using Logger inside other providers: One of Riverpod’s strengths is dependency injection via providers.
Providers can read other providers. This means our business logic or state objects can also log events. For
example, inside a Notifier that handles some state, we can use the logger:
@riverpod
class CartManager extends _$CartManager {
@override
List<Item> build() {
return []; // initial cart empty
}
void addItem(Item item) {
state = [...state, item];
// Log the update
ref.read(loggerProvider).d('Added item ${item.id} to cart (total $
{state.length})');
22
5
}
void checkout() async {
try {
// ... perform checkout
ref.read(loggerProvider).i('Checkout started');
// ...
ref.read(loggerProvider).i('Checkout successful');
} catch (e, stack) {
ref.read(loggerProvider).e('Checkout failed', e);
// handle error...
}
}
}
In this CartManager example, the logger is accessed via ref.read(loggerProvider) within the
provider’s methods. This is possible because Riverpod passes a ref to Notifiers (and to functional
providers) that allows them to read or watch other providers as dependencies. Logging within providers is
useful for debugging state changes or errors in lower layers of the app (similar to how one might use print
statements, but now we have a centralized logger).
Benefits: By using a Riverpod provider for logging, we ensure there is a single instance (or at least a single
interface) for logging throughout the app. We could swap out the implementation easily (for instance, use a
no-op logger in tests or a different logger in production) by overriding loggerProvider if needed. Also,
because providers follow scope, you could even have environment-specific logging (e.g., override
loggerProvider in a ProviderScope for a subtree). In a large app, this pattern keeps logging consistent and
easily accessible in both UI and business logic, without tight coupling.
Example: Dynamic Localization Settings with Riverpod
For internationalization, Flutter’s built-in localization (via arb files and the flutter_localizations
package) can be integrated with Riverpod to allow runtime language switching. The user’s provided code
snippet for AppLocalizations (with English and German support) indicates the app uses Flutter’s
gen_l10n tool, producing an AppLocalizations class and delegates. We will create a Riverpod state
to track the selected locale and update the app’s UI when it changes.
MaterialApp setup: First, ensure your MaterialApp (or MaterialApp.router ) is configured to use
the generated localizations. In MyApp.build , include the delegates and supported locales, and bind the
app’s locale to a Riverpod provider:
class MyApp extends ConsumerWidget {
@override
Widget build(BuildContext context, WidgetRef ref) {
final router = ref.watch(appRouterProvider);
final themeSet = ref.watch(appThemeProvider);
6
final locale = ref.watch(localeControllerProvider); // current locale (or
null)
return MaterialApp.router(
routerConfig: router,
theme: themeSet.light,
darkTheme: themeSet.dark,
locale: locale, // use the locale from provider (null = system default)
supportedLocales: AppLocalizations.supportedLocales,
localizationsDelegates: AppLocalizations.localizationsDelegates,
debugShowCheckedModeBanner: false,
);
}
}
Here we watch a localeControllerProvider to obtain the current app locale (more on this provider
next). If locale is null , the MaterialApp will fall back to the device’s locale (“System default”). If
locale is set to a specific Locale , the app will render in that language. We pass the supported locales
and delegates as generated by Flutter (so AppLocalizations.delegate plus the global material/
cupertino delegates are included via localizationsDelegates list). This matches the Flutter
internationalization setup requirements .
Locale controller provider: Next, we define a Riverpod Notifier to hold the user’s language choice. This will
allow the user to change the locale at runtime. We put this in, for example, core/di/providers.dart or
a dedicated settings_provider.dart (since it’s a core app setting, either is fine; keeping it in core
makes sense as it affects multiple features).
@riverpod
class LocaleController extends _$LocaleController {
@override
Locale? build() {
// Initialize with system locale (null means no override)
return null;
}
void changeLocale(Locale? newLocale) {
state = newLocale;
// You could also persist this setting here if desired (e.g., save to
SharedPreferences).
}
}
This will generate a localeControllerProvider of type NotifierProvider<LocaleController,
Locale?> . The state is a Locale? : we use null to represent “system default” and a concrete Locale to
represent a chosen language. By default, we start with null (meaning use the device locale). The
23 24
7
changeLocale method updates the state, causing any listeners (like MyApp ) to rebuild with the new
locale.
Note: Because localeControllerProvider is watched at the top of the widget tree
(MyApp), it will not be disposed during app lifetime. It’s autoDispose by default, but since
MyApp is always listening, it stays alive. If needed, you could mark
@Riverpod(keepAlive:true) for clarity, but it’s not required in this usage.
UI Component – Language Selector: Now we create a reusable widget that allows the user to select a
language. We want this to be a self-contained UI component we can drop into the Settings screen without
extra wiring. Let’s call it LanguageSelector and put it in features/settings/presentation/
language_selector.dart :
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:your_app/l10n/app_localizations.dart';
import 'package:your_app/core/di/providers.dart'; // for
localeControllerProvider
class LanguageSelector extends ConsumerWidget {
const LanguageSelector({Key? key}) : super(key: key);
@override
Widget build(BuildContext context, WidgetRef ref) {
final currentLocale = ref.watch(localeControllerProvider);
final loc = AppLocalizations.of(context)!;
// Construct the list of locale options: null for system default + supported
locales
final options = <Locale?>[null, ...AppLocalizations.supportedLocales];
return ListTile(
title: Text(loc.settingsLanguage), // e.g. "Language"
subtitle: Text(loc.settingsLanguageSubtitle),// e.g. "Choose the
language..."
trailing: DropdownButton<Locale?>(
value: currentLocale,
onChanged: (Locale? newLocale) {
ref.read(localeControllerProvider.notifier).changeLocale(newLocale);
},
items: options.map((localeOption) {
late String label;
if (localeOption == null) {
label = loc.settingsLanguageSystem; // "System default"
} else if (localeOption.languageCode == 'en') {
label = loc.settingsLanguageEnglish; // "English"
} else if (localeOption.languageCode == 'de') {
label = loc.settingsLanguageGerman; // "German"
8
} else {
// Fallback: use languageCode if unexpected locale appears
label = localeOption.languageCode;
}
return DropdownMenuItem<Locale?>(
value: localeOption,
child: Text(label),
);
}).toList(),
),
);
}
}
In this widget, we watch the current locale setting via Riverpod. We then display a ListTile (you could
use any layout; here we show a label and a dropdown). The dropdown’s items include a System default
option (represented by null locale) and one item for each supported locale (English and German). We
leverage the generated AppLocalizations to get user-friendly labels:
loc.settingsLanguageEnglish might be "English" in English UI, and in German UI it would
automatically be "Englisch" (assuming the arb file is translated), etc. This way, the language names are
also localized. The onChanged callback calls localeControllerProvider.notifier.changeLocale ,
updating the app’s state. Because MyApp is listening to localeControllerProvider , the entire
MaterialApp will rebuild with the new locale, and Flutter’s localization system will reload strings accordingly
– the UI text changes immediately to the selected language.
This LanguageSelector component requires no external arguments or state; you can simply insert
LanguageSelector() into your Settings screen UI. For example, in SettingsScreen (within
features/settings/presentation/settings_screen.dart ):
class SettingsScreen extends StatelessWidget {
const SettingsScreen({Key? key}) : super(key: key);
@override
Widget build(BuildContext context) {
final loc = AppLocalizations.of(context)!;
return Scaffold(
appBar: AppBar(title: Text(loc.settingsTitle)), // "Settings"
body: ListView(
children: [
// ... other settings items ...
LanguageSelector(), // our dropdown for language
],
),
);
}
}
9
Now the user can open the Settings screen and change the language on the fly. The app will reflect the new
locale instantly (no restart needed) because Riverpod rebuilds the MaterialApp with the updated locale. The
“System default” option allows reverting to following the device’s language.
Note on persistence: The above solution keeps the language choice in memory (Riverpod state). If you
want the choice to persist across app launches, you can integrate a persistence mechanism. A common
approach is to use SharedPreferences . For instance, on app startup, you could read a saved locale code
and initialize LocaleController ’s state with it, and whenever changeLocale is called, also save the
choice to preferences. This is exactly what some implementations do – e.g., using SharedPreferences
inside the notifier to save the language_code . This way, the selected language remains even
after the app is closed. In our case study, persistence is an enhancement to consider as the app grows.
Initialization in main.dart
Finally, to wire everything up, ensure main.dart wraps the app with a ProviderScope so Riverpod is
active:
void main() {
WidgetsFlutterBinding.ensureInitialized();
// Any other initialization like setting up licenses, system preferences, etc.
runApp(const ProviderScope(child: MyApp()));
}
The ProviderScope is essential – it’s the container that holds all the provider states. By placing it above
MyApp , all descendants (the whole app) can use ref.watch and other Riverpod functions . You
typically only need a single ProviderScope at the root (unless you intentionally create nested scopes for
specific overrides).
Inside MyApp (as shown earlier), we've already set up providers for theme, router, logger, and locale. For
completeness, if there are other global providers (like envProvider for environment config, or
appRouterProvider as in your case), those should also be defined in core and consumed in MyApp . In
the provided example, MyApp watches appRouterProvider to get the GoRouter configuration and
appThemeProvider for theming, and reads loggerProvider to log the startup . These providers
would be defined similarly via @riverpod in their respective modules (e.g. core/routing/
app_router.dart defines appRouterProvider returning a GoRouter , core/theme/
app_theme.dart defines appThemeProvider returning theme data ). Make sure to include any
needed initialization (for example, if using FlutterLocalizations , add Intl.defaultLocale if
necessary, or ensure the localizations delegates are properly added – which we did).
Conclusion
By using Riverpod 3 with hooks and code generation, we achieve a clean and scalable architecture for a
large Flutter app. Our folder structure keeps feature code organized into presentation/domain/data
layers , and global concerns in a core module. Riverpod’s generators reduce boilerplate by autocreating providers from simple annotations, letting us focus on logic instead of tedious wiring . We
25 26
27 28
29
30
31
1
32
10
discussed how to inject and use a global AppLogger from anywhere in the app via providers, which
improves consistency and testability of logging. We also implemented a localization setting using Riverpod
state: the app’s language can be changed at runtime with a few lines of code, thanks to provider-driven
reactivity.
This approach scales well for large apps because:
Maintainability: Each feature’s state is encapsulated in providers and Notifiers that can be reasoned
about in isolation. The codegen ensures the syntax is concise and less error-prone (no need to
remember specific Provider types or family syntax) .
Performance: Riverpod’s fine-grained providers and auto-disposal free unused resources, and the
hook integration helps minimize rebuilds to only impacted UI parts. We can also use ref.listen
and ref.select to optimize rebuilds if needed.
Testability: Providers can be overridden in tests, and Notifiers (which replace StateNotifier ) can
be unit tested easily since they are just classes with logic. The separation of UI (ConsumerWidgets)
from logic (providers) means you can test business logic without Flutter, and widget tests can supply
stub providers.
Extensibility: Adding a new feature means creating a new folder under features/ , and defining
its data/domain/presentation. With Riverpod, you might create new providers or Notifiers for that
feature’s state. Thanks to the feature-first organization, this won’t tangle with other features.
Providers are organized by feature, not by type (we don’t have a giant file of all StateProviders,
another of all FutureProviders, etc., but rather each feature or module has the providers it needs)
. This makes the codebase navigable even as it grows.
By following these patterns and using the latest Riverpod capabilities, you get a robust, modern Flutter app
architecture. It provides the benefits of clean architecture (clear layering and dependency rules) while
leveraging Riverpod for efficient state management and dependency injection. The result is an app
structure that can handle scale and complexity, with maintainable code and a responsive UI that’s easy to
internationalize, test, and extend.
Flutter Riverpod Clean Architecture: The Ultimate Production-Ready Template for Scalable
Apps - DEV Community
https://dev.to/ssoad/flutter-riverpod-clean-architecture-the-ultimate-production-ready-template-for-scalable-apps-gdh
How to Auto-Generate your Providers with Flutter Riverpod Generator
https://codewithandrea.com/articles/flutter-riverpod-generator/
About code generation | Riverpod
https://riverpod.dev/docs/concepts/about_code_generation
How to use Notifier and AsyncNotifier with the new Flutter Riverpod Generator : r/FlutterDev
https://www.reddit.com/r/FlutterDev/comments/yfo60w/how_to_use_notifier_and_asyncnotifier_with_the/
providers.dart
https://github.com/gitoak/loomday/blob/c69d111236846dff26f3ae8b58b15fc40bc601fb/lib/core/di/providers.dart
app.dart
https://github.com/gitoak/loomday/blob/c69d111236846dff26f3ae8b58b15fc40bc601fb/lib/app.dart
•
7
•
•
•
2
33 11
1 2 3 4 33
5 6 7 12 15 16 17 19 32
8 13 14 18 20
9 10 11
21
22 29
11
Flutter Localization with Riverpod and SharedPreferences. | by Eman Yaqoob | Medium
https://medium.com/@emanyaqoob/flutter-localization-with-riverpod-and-sharedpreferences-d3919fb9bb02
Flutter Riverpod Architecture and Riverpod State Management | by Malshani Wijekoon | Medium
https://malshani-wijekoon.medium.com/flutter-riverpod-architecture-and-riverpod-state-management-56f7c3fa4bd6
app_router.dart
https://github.com/gitoak/loomday/blob/c69d111236846dff26f3ae8b58b15fc40bc601fb/lib/core/routing/app_router.dart
app_theme.dart
https://github.com/gitoak/loomday/blob/c69d111236846dff26f3ae8b58b15fc40bc601fb/lib/core/theme/app_theme.dart
23 24 25 26
27 28
30
31
12
