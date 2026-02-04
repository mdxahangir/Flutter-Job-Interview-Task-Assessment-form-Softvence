import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:travel_alarm_app/constants/colors.dart';
import 'package:travel_alarm_app/features/alarm/alarm_provider.dart';
import 'package:travel_alarm_app/features/alarm/add_alarm_screen.dart';
import 'package:travel_alarm_app/features/location/location_screen.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.backgroundBottom,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 10),


                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Section
                      Text("Selected Location",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LocationScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.inputDark,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Consumer<AlarmProvider>(
                            builder: (context, provider, child) {
                              return Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      color: AppColors.textGrey),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      provider.currentLocation,
                                      style: GoogleFonts.poppins(
                                          color: AppColors.textGrey),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Alarms",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),


                Expanded(
                  child: Consumer<AlarmProvider>(
                    builder: (context, provider, child) {
                      if (provider.alarms.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.alarm,
                                  color: AppColors.textGrey, size: 60),
                              const SizedBox(height: 20),
                              Text('No alarms set',
                                  style: GoogleFonts.poppins(
                                      color: AppColors.textGrey)),
                              const SizedBox(height: 10),
                              Text('Tap + to add an alarm',
                                  style: GoogleFonts.poppins(
                                      color: AppColors.textGrey, fontSize: 14)),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: provider.alarms.length,
                        itemBuilder: (context, index) {
                          final alarm = provider.alarms[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.cardDark.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(alarm.formattedTime.toLowerCase(),
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 4),
                                    Text(alarm.label,
                                        style: GoogleFonts.poppins(
                                            color: AppColors.textGrey,
                                            fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(alarm.formattedDate,
                                        style: GoogleFonts.poppins(
                                            color: AppColors.textGrey,
                                            fontSize: 13)),
                                    const SizedBox(width: 10),
                                    Switch(
                                      value: alarm.isActive,
                                      onChanged: (_) =>
                                          provider.toggleAlarm(alarm.id),
                                      activeColor: Colors.white,
                                      activeTrackColor: AppColors.primaryPurple,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddAlarmScreen(),
              ),
            );
          },
          backgroundColor: AppColors.primaryPurple,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}