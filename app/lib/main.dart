import 'dart:convert';
import 'package:args/args.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flow/cubits/flow.dart';
import 'package:flow/api/storage/sources.dart';
import 'package:flow/pages/alarm/countdown.dart';
import 'package:flow/pages/alarm/page.dart';
import 'package:flow/pages/calendar/filter.dart';
import 'package:flow/pages/settings/data.dart';
import 'package:flow/pages/settings/home.dart';
import 'package:flow/pages/settings/personalization.dart';
import 'package:flow/theme.dart';
import 'package:flow/widgets/navigation.dart';
import 'package:flow_api/helpers/setup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:material_leap/l10n/leap_localizations.dart';
import 'package:flow_api/models/model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flow/cubits/settings.dart';
import 'package:flow/cubits/auth.dart';
import 'package:flow/services/auth_service.dart';
import 'package:flow/services/auth_database_service.dart';
import 'package:flow/setup/service_locator.dart' as setup_locator;
import 'package:flow/blocs/ai/ai_bloc.dart';
import 'package:flow/widgets/auth_guard.dart';
import 'pages/events/page.dart';
import 'pages/calendar/page.dart';
import 'pages/dashboard/page.dart';
import 'pages/sources/page.dart';
import 'pages/resources/page.dart';
import 'pages/groups/page.dart';
import 'pages/users/filter.dart';
import 'pages/users/page.dart';
import 'pages/ai/page.dart';
import 'pages/notes/page.dart';
import 'setup.dart'
    if (dart.library.html) 'setup_web.dart'
    if (dart.library.io) 'setup_io.dart';

String? dataPath;

Future<void> main(List<String> args) async {
  setupAPI();

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  usePathUrlStrategy();
  final argParser = ArgParser();
  argParser.addOption('path', abbr: 'p');
  final result = argParser.parse(args);
  dataPath = result['path'];

  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  final settingsCubit = SettingsCubit(prefs);
  final sourcesService = SourcesService(settingsCubit);
  await sourcesService.setup();

  // Initialize authentication with database service
  final authDatabaseService =
      AuthDatabaseService(sourcesService.local, secureStorage);
  final authService = AuthService(authDatabaseService, prefs);
  final authBloc = AuthBloc(authService);

  await setup(settingsCubit, sourcesService);

  // Initialize proper AI service locator
  setup_locator.setupServiceLocator();

  // Initialize authentication
  authBloc.add(AuthCheckRequested());

  FlutterNativeSplash.remove();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: settingsCubit),
        BlocProvider.value(value: authBloc),
        RepositoryProvider.value(value: sourcesService),
        RepositoryProvider.value(value: authService),
        BlocProvider(
          create: (context) => FlowCubit(context.read<SourcesService>()),
        ),
        BlocProvider(
          create: (context) {
            final sourcesService = context.read<SourcesService>();
            // Get the local source service for AI operations
            final sourceService = sourcesService.getSource('');
            return setup_locator.serviceLocator<AiBloc>(
              param1: sourceService,
            );
          },
        ),
      ],
      child: FlowApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
      routes: [
        GoRoute(
          path: 'data',
          builder: (context, state) => const DataSettingsPage(),
        ),
        GoRoute(
          path: 'personalization',
          builder: (context, state) => const PersonalizationSettingsPage(),
        ),
      ],
    ),
    ShellRoute(
        builder: (context, state, child) => FlowRootNavigation(child: child),
        routes: [
          GoRoute(
              path: '/',
              builder: (context, state) => const DashboardPage(),
              routes: [
                GoRoute(
                  path: 'calendar',
                  builder: (context, state) => CalendarPage(
                    filter: state.extra is CalendarFilter
                        ? state.extra as CalendarFilter
                        : const CalendarFilter(),
                  ),
                ),
                GoRoute(
                  path: 'alarm',
                  builder: (context, state) => const AlarmPage(),
                  routes: [
                    GoRoute(
                      path: ':index',
                      name: 'alarm-countdown',
                      builder: (context, state) => AlarmCountdownPage(
                        index: int.parse(state.pathParameters['index']!),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'events',
                  builder: (context, state) => const EventsPage(),
                ),
                GoRoute(
                  path: 'groups',
                  builder: (context, state) => const GroupsPage(),
                ),
                GoRoute(
                    path: 'notes',
                    builder: (context, state) => const NotesPage(),
                    routes: [
                      GoRoute(
                        path: ':source/:id',
                        name: 'subnote',
                        builder: (context, state) => NotesPage(
                          parent: SourcedModel(
                            state.pathParameters['source']!,
                            base64Decode(state.pathParameters['id']!),
                          ),
                        ),
                      ),
                      GoRoute(
                        path: ':id',
                        name: 'subnote-local',
                        builder: (context, state) => NotesPage(
                          parent: SourcedModel(
                            '',
                            base64Decode(state.pathParameters['id']!),
                          ),
                        ),
                      ),
                    ]),
                GoRoute(
                  path: 'resources',
                  builder: (context, state) => const ResourcesPage(),
                ),
                GoRoute(
                  path: 'users',
                  builder: (context, state) => UsersPage(
                    filter: state.extra is UserFilter
                        ? state.extra as UserFilter
                        : const UserFilter(),
                  ),
                ),
                GoRoute(
                  path: 'sources',
                  builder: (context, state) => const SourcesPage(),
                ),
                GoRoute(
                  path: 'ai',
                  builder: (context, state) => const AIPage(),
                ),
              ]),
        ]),
  ],
);

class FlowApp extends StatelessWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return _buildApp(null, null);
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) =>
          _buildApp(lightDynamic, darkDynamic),
    );
  }

  Widget _buildApp(ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
    final virtualWindowFrameBuilder = VirtualWindowFrameInit();
    return BlocBuilder<SettingsCubit, FlowSettings>(
        buildWhen: (previous, current) =>
            previous.design != current.design ||
            previous.themeMode != current.themeMode ||
            previous.locale != current.locale ||
            previous.density != current.density ||
            previous.highContrast != current.highContrast,
        builder: (context, state) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: _router,
              title: applicationName,
              theme: getThemeData(state.design, false,
                  state.density.toFlutter(), lightDynamic, state.highContrast),
              darkTheme: getThemeData(state.design, true,
                  state.density.toFlutter(), darkDynamic, state.highContrast),
              themeMode: state.themeMode,
              locale: state.locale.isEmpty ? null : Locale(state.locale),
              localizationsDelegates: const [
                ...AppLocalizations.localizationsDelegates,
                LeapLocalizations.delegate,
                LocaleNamesLocalizationsDelegate(),
              ],
              builder: (context, child) {
                if (!state.nativeTitleBar) {
                  child = virtualWindowFrameBuilder(context, child);
                }
                // Wrap with AuthGuard to protect the entire app
                child = AuthGuard(child: child ?? Container());
                return child;
              },
              supportedLocales: AppLocalizations.supportedLocales,
            ));
  }
}

const flavor = String.fromEnvironment('flavor');
const isNightly =
    flavor == 'nightly' || flavor == 'dev' || flavor == 'development';
const shortApplicationName = isNightly ? 'Momentum Nightly' : 'Momentum';
const applicationMinorVersion = "0.4.3";
const applicationName = shortApplicationName;

Future<String> getCurrentVersion() async {
  const envVersion = String.fromEnvironment('version');
  if (envVersion.isNotEmpty) return envVersion;
  final info = await PackageInfo.fromPlatform();
  return info.version;
}
