import 'package:adrash/core/constants/app_enums.dart';
import 'package:adrash/features/Home/view/pages/home_page.dart';
import 'package:adrash/features/auth/view/auth_page.dart';
import 'package:adrash/features/auth/view/register_page.dart';
import 'package:adrash/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:adrash/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/web.dart';
import 'package:nb_utils/nb_utils.dart';

Logger logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initialize();
  // objectbox = await ObjectBox.create();

  //* Firebase config start -----------------------------------------------------
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Disable Firebase Analytics & Crashlytics in debug mode
  if (kDebugMode) {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  if (kReleaseMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  //* Firebase config end -----------------------------------------------------
  // Create a ProviderContainer to use providers before ProviderScope
  final container = ProviderContainer();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: "AdRash",
          debugShowCheckedModeBanner: false,
          theme: FlexColorScheme.light(scheme: FlexScheme.blumineBlue, useMaterial3: true, fontFamily: 'Poppins').toTheme,
          darkTheme: FlexColorScheme.dark(scheme: FlexScheme.blumineBlue, useMaterial3: true, fontFamily: 'Poppins').toTheme,
          themeMode: ThemeMode.system,
          home: Root(),
        );
      },
    );
  }
}

class Root extends ConsumerStatefulWidget {
  const Root({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootState();
}

class _RootState extends ConsumerState<Root> with TickerProviderStateMixin {
  //Anim
  late AnimationController controller;
  Tween<double> tween = Tween(begin: 0.8, end: 1);

  @override
  void initState() {
    super.initState();
    //Anim
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    controller.repeat(reverse: true);

    afterBuildCreated(() {
      _init();
    });
  }

  _init() async {
    UserAuthStatus userAuthStatus = await ref.read(authViewmodelProvider.notifier).getUserAuthStatus();
    if (mounted) {
      if (userAuthStatus == UserAuthStatus.registered) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      if (userAuthStatus == UserAuthStatus.unregistered) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage()));
      }
      if (userAuthStatus == UserAuthStatus.initial) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage()));
      }
    }
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xff2D336B) : const Color(0xff2D336B),
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: ScaleTransition(
            scale: tween.animate(CurvedAnimation(parent: controller, curve: Curves.ease)),
            child: Image(
              height: 100.h,
              width: 100.w,
              image: const AssetImage('assets/icon/icon_round.png'),
            ),
          ),
        ),
      ),
    );
  }
}
