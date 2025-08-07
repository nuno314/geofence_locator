import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'blocs/location/location_bloc.dart';
import 'blocs/location/location_event.dart';
import 'blocs/geofence/geofence_bloc.dart';
import 'blocs/geofence/geofence_event.dart';
import 'blocs/language/language_bloc.dart';
import 'blocs/language/language_event.dart';
import 'blocs/language/language_state.dart';
import 'repositories/location_repository.dart';
import 'repositories/geofence_repository.dart';
import 'routes/app_router.dart';
import 'extensions/localization_extension.dart';
import 'services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize background service for the entire app
  await BackgroundService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String locale = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    // Load saved language preference
    // For now, default to English
    setState(() {
      locale = 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(
          create: (context) => LanguageBloc()..add(const LoadLanguage()),
        ),
        BlocProvider<LocationBloc>(
          create: (context) =>
              LocationBloc(locationRepository: LocationRepositoryImpl()),
        ),
        BlocProvider<GeofenceBloc>(
          create: (context) =>
              GeofenceBloc(geofenceRepository: GeofenceRepositoryImpl()),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          if (languageState is LanguageLoaded) {
            locale = languageState.currentLanguage;
          }

          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Employee Geofence',
            locale: Locale(locale),
            supportedLocales: const [Locale('en'), Locale('vi'), Locale('ms')],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            initialRoute: AppRouter.home,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
