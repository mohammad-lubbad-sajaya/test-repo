import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import 'core/services/app_translations/app_translations.dart';
import 'core/services/local_repo/local_repository.dart';
import 'core/services/notifications/notifications_manager.dart';
import 'core/services/routing/navigation_service.dart';
import 'core/services/routing/router.dart' as router;
import 'core/services/routing/routes.dart';
import 'core/services/service_locator/dependency_injection.dart';
import 'core/utils/theme/app_colors.dart';
import 'features/shared_screens/allTabs/settings/settings_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await NotificationManager().initlize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppTranslationsDelegate _appTranslationsDelegate;

  @override
  void initState() {
    super.initState();
    initLocale();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(settingsViewModelProvider).getTheme();
      return Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          title: 'Sajaya',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            _appTranslationsDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          theme: ThemeData(
            useMaterial3: false,
            colorScheme: ColorScheme.fromSwatch(
              accentColor: primaryColor
                  .withOpacity(0.1), // but now it should be declared like this
            ),
            primaryColor: primaryColor,
            inputDecorationTheme: const InputDecorationTheme(
              floatingLabelStyle: TextStyle(color: secondaryColor),
            ),
            secondaryHeaderColor: secondaryColor,
            fontFamily: isEnglish() ? 'Poppins' : "NotoKufiArabic",
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: ref.watch(
                    settingsViewModelProvider.select((value) => value.isDark))
                ? darkModeBackGround
                : Colors.white,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
            appBarTheme: AppBarTheme(
              centerTitle: false,
              elevation: 0,
              //scrolledUnderElevation: 1,
              titleTextStyle: TextStyle(
                fontFamily: isEnglish() ? 'Poppins' : "NotoKufiArabic",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              titleSpacing: 15,
              backgroundColor: ref.watch(
                      settingsViewModelProvider.select((value) => value.isDark))
                  ? darkModeBackGround
                  : Colors.white,
              iconTheme: IconThemeData(
                color: ref.watch(settingsViewModelProvider
                        .select((value) => value.isDark))
                    ? backGroundColor
                    : Colors.black,
              ),
            ),
          ),
          builder: (_, child) {
            return Directionality(
              textDirection: _appTranslationsDelegate.getLanguageCode() == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },
          navigatorKey: sl<NavigationService>().navigatorKey,
          initialRoute: preAppScreen,
          onGenerateRoute: router.Router.generateRoute,
        ),
      );
    });
  }

  void initLocale() {
    String? lang = sl<LocalRepo>().getLanguage();
    _appTranslationsDelegate = AppTranslationsDelegate(
      locale: lang == null ? null : Locale(lang, ''),
    );
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    sl<Dio>().options.headers.addAll({'lang': locale.languageCode});
    setState(
      () {
        _appTranslationsDelegate = AppTranslationsDelegate(locale: locale);
      },
    );
  }
}
