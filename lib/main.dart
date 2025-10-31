import 'package:flutter/material.dart';
import 'package:hotel_finder/providers/settings_provider.dart';
import 'package:hotel_finder/widgets/gradient_background.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/hotel_provider.dart';
import 'providers/device_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HotelProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()), // Add this line

      ],
      child: GradientBackground(
        child: MaterialApp(
          title: 'MyTravaly',
          debugShowCheckedModeBanner: false,
          // theme: AppTheme.lightTheme,
          // darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}