import 'dart:async';
import 'package:flutter/material.dart';

class AgeCalculatorPage extends StatefulWidget {
  const AgeCalculatorPage({Key? key}) : super(key: key);

  @override
  State<AgeCalculatorPage> createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage> {
  static const Color _backgroundColor = Color(0xFF1A1A2E);
  static const Color _primaryColor = Color(0xFFE94560);
  static const Color _secondaryColor = Color(0xFF16213E);

  DateTime? _selectedDate;
  Timer? _timer;

  // Calculated values
  int _years = 0;
  int _months = 0;
  int _days = 0;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _totalDays = 0;
  int _totalHours = 0;
  int _totalMinutes = 0;
  int _totalSeconds = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateAge() {
    if (_selectedDate == null) return;

    final now = DateTime.now();
    final birth = _selectedDate!;

    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      months--;
      final lastMonth = DateTime(now.year, now.month, 0);
      days += lastMonth.day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    final diff = now.difference(birth);
    final totalDays = diff.inDays;
    final totalHours = diff.inHours;
    final totalMinutes = diff.inMinutes;
    final totalSeconds = diff.inSeconds;

    setState(() {
      _years = years;
      _months = months;
      _days = days;
      _hours = now.hour;
      _minutes = now.minute;
      _seconds = now.second;
      _totalDays = totalDays;
      _totalHours = totalHours;
      _totalMinutes = totalMinutes;
      _totalSeconds = totalSeconds;
    });
  }

  void _startLiveCounter() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateAge();
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Color(0xFF16213E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      _calculateAge();
      _startLiveCounter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _secondaryColor,
        title: const Text(
          'Age Calculator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Date Picker Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _secondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cake, color: _primaryColor, size: 50),
                  const SizedBox(height: 15),
                  const Text(
                    'জন্মতারিখ বেছে নাও',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: _primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            _selectedDate == null
                                ? 'তারিখ সিলেক্ট করো'
                                : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_selectedDate != null) ...[
              const SizedBox(height: 25),

              // Main Age Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE94560), Color(0xFFFF6B9D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'তোমার বয়স',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMainAgeBox('$_years', 'বছর'),
                        _buildMainAgeBox('$_months', 'মাস'),
                        _buildMainAgeBox('$_days', 'দিন'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Live Clock
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: _primaryColor, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Live Counter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLiveBox('$_hours', 'ঘণ্টা', const Color(0xFF4A5AFF)),
                        _buildLiveBox('$_minutes', 'মিনিট', const Color(0xFF00CED1)),
                        _buildLiveBox('$_seconds', 'সেকেন্ড', _primaryColor),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Total Stats
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'জন্মের পর থেকে মোট',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.4,
                children: [
                  _buildTotalCard(
                    '$_totalDays',
                    'দিন',
                    Icons.calendar_month,
                    const Color(0xFF4A5AFF),
                  ),
                  _buildTotalCard(
                    '$_totalHours',
                    'ঘণ্টা',
                    Icons.schedule,
                    const Color(0xFF00CED1),
                  ),
                  _buildTotalCard(
                    '$_totalMinutes',
                    'মিনিট',
                    Icons.timer,
                    const Color(0xFFFF6347),
                  ),
                  _buildTotalCard(
                    '$_totalSeconds',
                    'সেকেন্ড',
                    Icons.av_timer,
                    _primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMainAgeBox(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLiveBox(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            value.padLeft(2, '0'),
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}