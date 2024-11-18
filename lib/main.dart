import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

void main() {
  tzdata.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ClockScreen(),
    );
  }
}

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late Timer _timer;
  late tz.Location _selectedLocation;
  String _timeString = '';
  String _dateString = '';
  bool _is24HourFormat = true;

  // Tạo danh sách các múi giờ
  final Map<String, List<String>> _groupedTimeZones = {
    'UTC -12:00': [
      'Pacific/Kwajalein',
      'Pacific/Eniwetok',
    ],
    'UTC -11:00': [
      'Pacific/Midway',
      'Pacific/Samoa',
    ],
    'UTC -10:00': [
      'Pacific/Honolulu',
    ],
    'UTC -09:30': [
      'Pacific/Marquesas',
    ],
    'UTC -09:00': [
      'America/Anchorage',
    ],
    'UTC -08:00': [
      'America/Los_Angeles',
      'America/Vancouver',
      'America/Tijuana',
    ],
    'UTC -07:00': [
      'America/Denver',
      'America/Phoenix',
    ],
    'UTC -06:00': [
      'America/Chicago',
      'America/Belize',
    ],
    'UTC -05:00': [
      'America/New_York',
      'America/Toronto',
      'America/Bogota',
    ],
    'UTC -04:00': [
      'America/Caracas',
      'America/Houston',
      'America/La_Paz',
    ],
    'UTC -03:30': [
      'America/St_Johns',
    ],
    'UTC -03:00': [
      'America/Argentina/Buenos_Aires',
      'America/Montevideo',
    ],
    'UTC -02:00': [
      'America/Noronha',
    ],
    'UTC -01:00': [
      'Atlantic/Azores',
      'Atlantic/Cape_Verde',
    ],
    'UTC +00:00': [
      'Europe/London',
      'Africa/Lagos',
      'UTC',
    ],
    'UTC +01:00': [
      'Europe/Paris',
      'Africa/Algiers',
    ],
    'UTC +02:00': [
      'Africa/Cairo',
      'Europe/Berlin',
    ],
    'UTC +03:00': [
      'Europe/Moscow',
      'Africa/Nairobi',
      'Asia/Riyadh',
    ],
    'UTC +03:30': [
      'Asia/Tehran',
    ],
    'UTC +04:00': [
      'Asia/Dubai',
      'Europe/Astrakhan',
    ],
    'UTC +04:30': [
      'Asia/Kabul',
    ],
    'UTC +05:00': [
      'Asia/Karachi',
      'Asia/Tashkent',
    ],
    'UTC +05:30': [
      'Asia/Kolkata',
      'Asia/Sri_Jayawardenepura',
    ],
    'UTC +05:45': [
      'Asia/Kathmandu',
    ],
    'UTC +06:00': [
      'Asia/Almaty',
      'Asia/Bishkek',
    ],
    'UTC +07:00': [
      'Asia/Ho_Chi_Minh',
      'Asia/Bangkok',
      'Asia/Jakarta',
    ],
    'UTC +08:00': [
      'Asia/Singapore',
      'Asia/Shanghai',
      'Australia/Perth',
    ],
    'UTC +08:45': [
      'Australia/Eucla',
    ],
    'UTC +09:00': [
      'Asia/Tokyo',
      'Asia/Seoul',
    ],
    'UTC +09:30': [
      'Australia/Darwin',
      'Australia/Adelaide',
    ],
    'UTC +10:00': [
      'Australia/Sydney',
      'Australia/Brisbane',
    ],
    'UTC +10:30': [
      'Australia/Lord_Howe',
    ],
    'UTC +11:00': [
      'Pacific/Guam',
      'Pacific/Saipan',
    ],
    'UTC +12:00': [
      'Pacific/Fiji',
      'Pacific/Kwajalein',
    ],
    'UTC +12:45': [
      'Pacific/Chatham',
    ],
    'UTC +13:00': [
      'Pacific/Tongatapu',
      'Pacific/Enderbury',
    ],
    'UTC +14:00': [
      'Pacific/Kiritimati',
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedLocation =
        tz.getLocation('Asia/Ho_Chi_Minh'); // Mặc định là Ho_Chi_Minh
    _updateDateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _updateDateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final now = tz.TZDateTime.now(_selectedLocation);
    setState(() {
      _timeString = _is24HourFormat
          ? DateFormat('HH:mm:ss').format(now)
          : DateFormat('hh:mm:ss a').format(now);
      _dateString = DateFormat('EEEE, MMMM d, yyyy').format(now);
    });
  }

  void _toggleFormat() {
    setState(() {
      _is24HourFormat = !_is24HourFormat;
    });
    _updateDateTime(); // Cập nhật thời gian ngay sau khi thay đổi định dạng
  }

  void _changeTimeZone(String locationName) {
    setState(() {
      _selectedLocation = tz.getLocation(locationName);
      _updateDateTime(); // Cập nhật thời gian ngay sau khi đổi múi giờ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Nhóm: Năm AE Siêu Nhân',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(221, 44, 51, 65),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              _timeString,
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _dateString,
              style: const TextStyle(fontSize: 24, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleFormat,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text(
                _is24HourFormat
                    ? 'Switch to 12-hour Format'
                    : 'Switch to 24-hour Format',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Time Zone:',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedLocation.name,
              dropdownColor: Colors.black87,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _changeTimeZone(newValue);
                }
              },
              items: _groupedTimeZones.entries.map((entry) {
                String utc = entry.key;
                List<String> locations = entry.value;

                return DropdownMenuItem<String>(
                  value: locations.first,
                  child: Text(
                    '$utc (${locations.map((e) => _getCustomName(e)).join(' / ')})',
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm để tùy chỉnh tên hiển thị
  String _getCustomName(String location) {
    switch (location) {
      case 'Asia/Ho_Chi_Minh':
        return 'Hanoi ';
      case 'America/New_York':
        return 'New York';
      case 'Europe/London':
        return 'London';
      case 'Asia/Tokyo':
        return 'Tokyo';
      case 'Australia/Sydney':
        return 'Sydney';
      // Add more custom names for other locations
      default:
        return location.split('/').last.replaceAll('_', ' ');
    }
  }
}
