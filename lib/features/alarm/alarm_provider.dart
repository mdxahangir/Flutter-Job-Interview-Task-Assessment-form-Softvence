import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_alarm_app/constants/app_constants.dart';
import 'package:travel_alarm_app/models/alarm_model.dart';
import 'package:travel_alarm_app/helpers/notification_helper.dart';

class AlarmProvider extends ChangeNotifier {
  List<Alarm> _alarms = [];
  String _currentLocation = 'Add your location';

  List<Alarm> get alarms => _alarms;
  String get currentLocation => _currentLocation;

  AlarmProvider() {
    _loadAlarms();
    _loadLocation();
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsString = prefs.getString(AppConstants.alarmsKey);

    if (alarmsString != null && alarmsString.isNotEmpty) {
      List<dynamic> alarmsJson = json.decode(alarmsString);
      _alarms = alarmsJson.map((json) => Alarm.fromMap(json)).toList();

      for (var alarm in _alarms.where((a) => a.isActive)) {
        await _scheduleAlarmNotification(alarm);
      }

      notifyListeners();
    }
  }

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final location = prefs.getString(AppConstants.locationKey);
    if (location != null && location.isNotEmpty) {
      _currentLocation = location;
      notifyListeners();
    }
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = _alarms.map((alarm) => alarm.toMap()).toList();
    await prefs.setString(AppConstants.alarmsKey, json.encode(alarmsJson));
  }

  Future<void> _scheduleAlarmNotification(Alarm alarm) async {
    await NotificationHelper.scheduleAlarmNotification(
      id: alarm.id,
      title: 'Travel Alarm',
      body: alarm.label,
      scheduledTime: alarm.time,
    );
  }

  Future<void> addAlarm(Alarm alarm) async {
    _alarms.add(alarm);
    _alarms.sort((a, b) => a.time.compareTo(b.time));
    await _saveAlarms();

    if (alarm.isActive) {
      await _scheduleAlarmNotification(alarm);
    }

    notifyListeners();
  }

  Future<void> updateAlarm(Alarm updatedAlarm) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
    if (index != -1) {

      await NotificationHelper.cancelNotification(_alarms[index].id);

      _alarms[index] = updatedAlarm;
      _alarms.sort((a, b) => a.time.compareTo(b.time));
      await _saveAlarms();


      if (updatedAlarm.isActive) {
        await _scheduleAlarmNotification(updatedAlarm);
      }

      notifyListeners();
    }
  }

  Future<void> deleteAlarm(int id) async {
    _alarms.removeWhere((alarm) => alarm.id == id);
    await NotificationHelper.cancelNotification(id);
    await _saveAlarms();
    notifyListeners();
  }

  Future<void> toggleAlarm(int id) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      _alarms[index].isActive = !_alarms[index].isActive;
      await _saveAlarms();

      if (_alarms[index].isActive) {
        await _scheduleAlarmNotification(_alarms[index]);
      } else {
        await NotificationHelper.cancelNotification(id);
      }

      notifyListeners();
    }
  }

  int generateAlarmId() {
    return DateTime.now().millisecondsSinceEpoch;
  }


  void updateLocationFromProvider(String location) {
    _currentLocation = location;
    notifyListeners();
  }
}