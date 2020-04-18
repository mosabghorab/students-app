import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:students_app/providers/app/app_provider.dart';
import 'package:students_app/utils/theme.dart' as utils;
import 'package:students_app/views/screens/details_screen.dart';
import 'package:students_app/views/screens/home_screen.dart';
import 'package:students_app/views/screens/login_screen.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (BuildContext context) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, value, _) {
          if (value.appConfig.isFirstTime) {
            print('/......................................./First time');
            value.appConfig.checkAuth();
            value.appConfig.checkTheme();
            value.appConfig.isFirstTime = false;
          }
          return MaterialApp(
            navigatorObservers: [BotToastNavigatorObserver()],
            theme: value.appConfig.isDark ? utils.darkTheme : utils.lightTheme,
            debugShowCheckedModeBanner: false,
            title: 'Students App',
            initialRoute: 'home',
            routes: {
              'home': (context) => HomeScreen(),
              'login': (context) => LoginScreen(),
              'details': (context) => DetailsScreen(),
            },
          );
        },
      ),
    );
  }
}
