# Cardifly — Flutter Starter

A production-ready Flutter starter with a **miniature-first design system**,
a **custom pull-to-refresh** (wave → orbit → wave), a **Provider + ViewState**
state layer, and a repository-based networking stack built on Dio.

No third-party UI packages: loader, shimmer, skeleton, pull-to-refresh,
drawer icon, empty/error states — everything is painted and animated in-repo.

---

## Getting started

```bash
flutter pub get
flutter run       # launches the HomeScreen showcase
flutter analyze   # zero-issue baseline
flutter test      # smoke tests
```

Target: **Flutter ≥ 3.38.4**, **Dart SDK ^3.11**.

Point the API base at your environment by editing
`lib/utils/constants.dart` → `Constants.baseUrl`.

---

## Architecture at a glance

```
lib/
├── main.dart                        # Bootstraps providers, theme, router, overlay support
├── anims/
│   └── page_route_anim.dart         # Custom PageRouteBuilders (fade, slide, size…)
├── config/
│   ├── net/
│   │   ├── base_api.dart            # Dio subclass + header interceptor + timeouts
│   │   └── api.dart                 # App-scoped Http instance + response envelope
│   ├── provider/
│   │   ├── provider_request.dart    # Base ChangeNotifier w/ ViewState + Dio error mapping
│   │   ├── provider_widget.dart     # Generic ProviderWidget / 2 / 3 helpers
│   │   └── view/                    # ViewState machine + list/refresh view-models + widgets
│   ├── provider_manager.dart        # Global MultiProvider list
│   ├── router_manager.dart          # Route names + onGenerateRoute
│   └── storage_manager.dart         # SharedPreferences + LocalStorage bootstrap
├── core/
│   ├── models/                      # Plain-old data classes (User, QueryParameters, …)
│   ├── services/                    # Static repositories (UserService, …)
│   └── viewmodels/                  # UserModel, ThemeModel, LocaleModel, QueryParametersModel
├── generated/                       # Intl generated code — do not edit
├── helper/
│   └── theme_helper.dart            # InputDecorationTheme factory
├── l10n/                            # ARB translation sources
├── screens/
│   └── home_screen.dart             # Reference screen (AppBar + Drawer + refresh + list)
├── ui/
│   ├── components/                  # Custom widget library (loader, skeleton, refresh, …)
│   └── theme/
│       └── app_text.dart            # Typography design tokens + semantic styles
└── utils/
    ├── constants.dart               # Palette, keys, URLs, shadows
    ├── util.dart                    # Formatters, validators, notifications, sharing
    ├── enums/                       # Domain enums
    ├── extensions/                  # BuildContext / int extensions
    └── types/                       # Type-alias / feedback types
```

### Layer responsibilities

| Layer | Owns | Depends on |
|---|---|---|
| **Screens** | Composition of widgets, screen-local state | ui/, core/viewmodels/, config/provider/view |
| **UI components** | Reusable presentation, no business logic | ui/theme/, utils/constants |
| **View models** | State + orchestration of services | services/, models/, ProviderRequest |
| **Services** | Networking via `http` (Dio) | config/net/, models/ |
| **Config** | Wiring: providers, router, storage, network | utils/, core/viewmodels |

---

## State management

**Provider** (`ChangeNotifier` + `MultiProvider`) with a shared base:

```dart
class MyModel extends ProviderRequest {
  User? user;

  Future<void> load() async {
    setBusy();
    try {
      user = await UserService.getUser();
      setSuccess();
    } on DioException catch (e, s) {
      setError(e, s);   // maps 401/403/422/etc → notifications + state
    }
  }
}
```

`ProviderRequest` exposes:

- **State setters**: `setBusy()`, `setSuccess()`, `setUnAuthorized()`, `setUnAuthenticated()`.
- **Getters**: `busy`, `success`, `serverError`, `errorValidate`, `errorNetwork`, `unAuthorized`, `unAuthenticated`.
- **Error mapping**: `setError(e, s)` decodes Dio exceptions, shows a notification,
  handles auto-logout on 401.

Register a new model in `lib/config/provider_manager.dart`:

```dart
final providers = [
  ChangeNotifierProvider(create: (_) => LocaleModel()),
  ChangeNotifierProvider(create: (_) => ThemeModel()),
  ChangeNotifierProvider(create: (_) => UserModel()),
  ChangeNotifierProvider(create: (_) => MyModel()), // ← here
];
```

Consume it in a widget:

```dart
final myModel = context.watch<MyModel>();
if (myModel.busy) return const AppLoaderCentered();
```

---

## Networking

`Http` (in `config/net/api.dart`) is the app-scoped Dio instance:

```dart
final response = await http.post<Object?>(
  'auth/login',
  data: {'email': email, 'password': password},
);
```

- **HeaderInterceptor** (`base_api.dart`) injects `Authorization`, `Accept`,
  `platform`, `App-Version`, `language`. Timeouts hard-capped to 30 s.
- **ApiInterceptor** (`api.dart`) wraps every response through `ResponseData`,
  auto-throws `UnAuthorizedException`/`NotSuccessException`.
- **On 401** — HeaderInterceptor clears local session, and `ProviderRequest`
  navigates back to `HomeScreen` with a session-expired toast.

Add a new service (`lib/core/services/foo_service.dart`):

```dart
class FooService extends BaseService {
  static Future<List<Foo>> list() async {
    final res = await http.get<Object?>('foo');
    final payload = res.data! as Map<String, dynamic>;
    return (payload['data'] as List<dynamic>)
        .map((raw) => Foo.fromJson(raw as Map<String, dynamic>))
        .toList();
  }
}
```

---

## Paginated lists

Extend `ViewStateRefreshListModel<T>`, implement `loadData({int? pageNum})`:

```dart
class FooListModel extends ViewStateRefreshListModel<Foo> {
  @override
  Future<List<Foo>> loadData({int? pageNum}) =>
      FooService.list(page: pageNum ?? 1);
}
```

Then in the screen:

```dart
AppPullToRefresh(
  controller: model.refreshController,
  onRefresh: () => model.refresh(),
  onLoadMore: () => model.loadMore().then((_) {}),
  child: CustomScrollView(
    controller: model.refreshController.scrollController,
    slivers: [
      SliverList.builder(
        itemCount: model.list.length,
        itemBuilder: (_, i) => FooTile(model.list[i]),
      ),
      SliverToBoxAdapter(
        child: AppLoadMoreFooter(controller: model.refreshController),
      ),
    ],
  ),
)
```

---

## Design system

### Colors — `Constants` (`utils/constants.dart`)

| Token | Value |
|---|---|
| `appPrimaryColor` | `#0F70B7` |
| `appSecondaryColor` | `#EDD13A` |
| `scaffoldBackgroundColor` | `#FAFBFD` (light) / `#1A2037` (dark) |
| `appDarkCardColor` | `#283151` |
| `softShadow` / `floatingShadow` | Pre-baked box shadows |

### Typography — `AppText` (`ui/theme/app_text.dart`)

Three layers:

1. **Tokens** — `AppTextSize`, `AppFontWeight`, `AppLineHeight`, `AppTracking`.
2. **Styles** — `AppTextStyle.display / h1 / h2 / h3 / h4 / body / bodySm / caption / overline / button / label / mono / link`.
3. **Bridge** — `AppTextTheme.textThemeFor(color)` wires the styles into
   Flutter's `TextTheme` (already used by `ThemeModel`).

Use in widgets:

```dart
Text('Vos cartes', style: AppTextStyle.h3())
Text('Mise à jour il y a 2h', style: AppTextStyle.caption())
Text('Continuer', style: AppTextStyle.button())
```

Miniature scale (default): `xxs 9` · `xs 10` · `sm 11` · `base 12` ·
`md 13` · `lg 15` · `xl 18` · `xxl 22` · `display 28`.

### Theme — `ThemeModel`

Runtime dark-mode toggle:

```dart
context.read<ThemeModel>().switchTheme();       // toggle
context.read<ThemeModel>().switchTheme(userDarkMode: true); // force
```

The theme sets a Material 3 `ColorScheme.fromSeed(seedColor: appPrimaryColor)`
and normalises `CardTheme` / `DialogTheme` / `TabBarTheme` to the current API
(`*Data` classes).

---

## Custom widget library (`lib/ui/components/`)

| File | Description |
|---|---|
| `app_loader.dart` | Typing "…" dots (bouncing sinusoidal wave) |
| `app_shimmer.dart` | Zero-dependency shimmer wrapper (`ShaderMask`) |
| `skeleton.dart` | `Skeleton`, `CircleSkeleton`, `SkeletonTextBlock` |
| `app_list_skeleton.dart` | Ready-made list-loading skeleton |
| `app_pull_to_refresh.dart` | `AppRefreshController`, `AppPullToRefresh`, `AppLoadMoreFooter` — with the wave→orbit→wave header animation |
| `app_empty_state.dart` | Compact halo-icon empty state |
| `app_error_state.dart` | Compact error state with retry |
| `app_button_widget.dart` | Gradient primary button (`small` variant available) |
| `app_confirmation_dialog.dart` | Compact modal with badge, loading state, dual CTA |
| `app_input.dart` | Text input with animated focus halo |
| `app_drawer_icon.dart` | Custom drawer trigger (3 bars + accent dot) |
| `app_drawer.dart` | Compact side navigation drawer |

None of these depend on packages beyond `flutter/material.dart`.

---

## Localization

- Sources live in `lib/l10n/*.arb`, generated code in `lib/generated/`.
- `LocaleModel` persists the chosen locale via `SharedPreferences`.
- Delegates already wired in `main.dart`; add `S.delegate.supportedLocales`
  entries as you grow.

Regenerate after editing ARB files:

```bash
dart run intl_utils:generate
```

---

## Adding a new screen — checklist

1. Create `lib/screens/foo_screen.dart` as a `StatefulWidget`.
2. Register in `lib/config/router_manager.dart` (`RouteName.foo` + `case`).
3. If it needs state, add a `FooModel extends ProviderRequest` in
   `lib/core/viewmodels/` and register in `provider_manager.dart`.
4. Wrap remote fetches in a `FooService` (`lib/core/services/`).
5. Compose the UI from `ui/components/` (avoid inline styles).
6. Use `AppTextStyle` for text and `Constants` for colors.

---

## Testing

`flutter test` runs the widget smoke test in `test/widget_test.dart`.
Extend it by mocking `SharedPreferences` (already done in `setUp`) and
pumping specific view models with `ChangeNotifierProvider.value`.

---

## Code quality

- `analysis_options.yaml` enables **strict-casts** and **strict-raw-types**
  plus opinionated lints (`prefer_single_quotes`, `require_trailing_commas`,
  `use_super_parameters`, `directives_ordering`, `sort_child_properties_last`, …).
- Generated code is excluded from analysis.
- CI target: `flutter analyze` → **No issues found**.

---

## License / Ownership

`Constants.authorName`, `authorEmail`, `authorPhone` and package IDs in
`Constants` are placeholders — swap them for your own before shipping.
