import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itoju_mobile/features/auth/pages/first_time.dart';
import 'package:itoju_mobile/core/Storage/storage_class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(HiveKeys.appBox);
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 3));
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

//Global Key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final NavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return navigatorKey;
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        minTextAdapt: true,
        designSize: const Size(375, 812),
        builder: (context, _) => GestureDetector(
              onTap: () {
                unfocus();
              },
              child: MaterialApp(
                navigatorKey: navigatorKey,
                initialRoute: '/',
                routes: {
                  '/': (context) => FirstTimeScreen(),
                },
                debugShowCheckedModeBanner: false,
                title: 'Health Tracker Health',
                theme: ThemeData(
                  fontFamily: 'Axiforma',
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                // home: FirstTimeScreen(),
              ),
            ));
  }
}

void unfocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}
