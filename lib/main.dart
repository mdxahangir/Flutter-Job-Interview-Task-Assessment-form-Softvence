import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_constants.dart';
import 'features/alarm/add_alarm_screen.dart';
import 'features/alarm/alarm_provider.dart';
import 'features/alarm/alarm_screen.dart';
import 'features/location/location_provider.dart';
import 'features/location/location_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'helpers/notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications
  await NotificationHelper.initialize();

  final prefs = await SharedPreferences.getInstance();
  final isOnboardingComplete =
      prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;

  runApp(
    TravelAlarmApp(isOnboardingComplete: isOnboardingComplete),
  );
}

/// ✅ ROOT APP WIDGET
class TravelAlarmApp extends StatelessWidget {
  final bool isOnboardingComplete;

  const TravelAlarmApp({
    super.key,
    required this.isOnboardingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Travel Alarm',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.black,
        ),
        home: isOnboardingComplete
            ? const AlarmScreen()
            : const OnboardingScreen(),
        routes: {
          '/alarms': (_) => const AlarmScreen(),
          '/location': (_) => const LocationScreen(),
          '/add-alarm': (_) => const AddAlarmScreen(),
        },
      ),
    );
  }
}