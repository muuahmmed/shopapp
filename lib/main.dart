import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop1/layout/home/cubit/cubit.dart';
import 'package:shop1/layout/onboarding.dart';
import 'package:shop1/network/local/cache_helper.dart';
import 'layout/home/home_screen.dart';
import 'layout/login/login_screen.dart';
import 'network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();

  Widget widget;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  String? token = CacheHelper.getData(key: 'token') as String?;

  print('onBoarding = $onBoarding');
  print('token = $token');

  if (onBoarding != null) {
    if (token != null) {
      widget = const HomeScreen();
    } else {
      widget = const Login();
    }
  } else {
    widget = const OnBoarding();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()
        ..getHomeData()
        ..getCategories()
        ..getFavorites()
        ..getUserData(),
      child: MaterialApp(
        home: startWidget,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            hoverColor: Colors.deepOrange,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.deepOrange,
            elevation: 200.0,
            type: BottomNavigationBarType.fixed,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            unselectedItemColor: Colors.white,
            backgroundColor: HexColor('333739'),
            selectedItemColor: Colors.blue,
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
          ),
          scaffoldBackgroundColor: HexColor('333739'),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          appBarTheme: AppBarTheme(
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.w200,
              letterSpacing: 1.0,
            ),
            backgroundColor: HexColor('333739'),
            elevation: 0.0,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
            ),
          ),
        ),
      ),
    );
  }
}
