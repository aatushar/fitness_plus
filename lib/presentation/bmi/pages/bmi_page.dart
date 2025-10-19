// ==================== BMI CALCULATOR PAGE ====================
// Save as: bmi_calculator_page.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({Key? key}) : super(key: key);

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> with SingleTickerProviderStateMixin {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String _selectedGender = 'Male';
  double _bmi = 0.0;
  String _bmiCategory = '';
  Color _bmiColor = Colors.grey;
  double _healthyWeightMin = 0.0;
  double _healthyWeightMax = 0.0;
  double _bmiPrime = 0.0;
  double _ponderalIndex = 0.0;
  bool _showResult = false;

  late AnimationController _animationController;
  late Animation<double> _animation;
  double _targetAngle = -math.pi;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -math.pi, end: -math.pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _calculateBMI() {
    if (_feetController.text.isEmpty || _inchController.text.isEmpty || _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final double feet = double.tryParse(_feetController.text) ?? 0;
    final double inches = double.tryParse(_inchController.text) ?? 0;
    final double weight = double.tryParse(_weightController.text) ?? 0;

    if ((feet > 0 || inches > 0) && weight > 0) {
      final double totalInches = (feet * 12) + inches;
      final double heightInMeters = totalInches * 0.0254;

      setState(() {
        _showResult = true;
        _bmi = weight / (heightInMeters * heightInMeters);

        // Calculate healthy weight range
        _healthyWeightMin = 18.5 * (heightInMeters * heightInMeters);
        _healthyWeightMax = 25 * (heightInMeters * heightInMeters);

        // Calculate BMI Prime
        _bmiPrime = _bmi / 25;

        // Calculate Ponderal Index
        _ponderalIndex = weight / math.pow(heightInMeters, 3);

        // Determine category
        if (_bmi < 18.5) {
          _bmiCategory = 'Underweight';
          _bmiColor = const Color(0xFF2196F3);
        } else if (_bmi >= 18.5 && _bmi < 25) {
          _bmiCategory = 'Normal';
          _bmiColor = const Color(0xFF4CAF50);
        } else if (_bmi >= 25 && _bmi < 30) {
          _bmiCategory = 'Overweight';
          _bmiColor = const Color(0xFFFFEB3B);
        } else {
          _bmiCategory = 'Obese';
          _bmiColor = const Color(0xFFF44336);
        }

        // Calculate needle angle for animation
        double needleAngle;
        if (_bmi < 16.5) {
          needleAngle = -math.pi;
        } else if (_bmi >= 40) {
          needleAngle = 0;
        } else {
          needleAngle = -math.pi + ((_bmi - 16.5) * (math.pi / 23.5));
        }

        // Animate needle
        _animation = Tween<double>(
          begin: -math.pi,
          end: needleAngle,
        ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

        _animationController.forward(from: 0);
      });
    }
  }

  void _clearFields() {
    setState(() {
      _ageController.clear();
      _feetController.clear();
      _inchController.clear();
      _weightController.clear();
      _bmi = 0.0;
      _showResult = false;
      _animationController.reset();
    });
  }

  void _saveBMI() {
    if (_bmi > 0) {
      final feet = _feetController.text;
      final inches = _inchController.text;
      final weight = double.parse(_weightController.text);

      Navigator.pop(context, {
        'bmi': _bmi,
        'weight': weight,
        'height': '$feet\'$inches"',
      });
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _feetController.dispose();
    _inchController.dispose();
    _weightController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'BMI Calculator',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Age Input
              _buildInputField(
                controller: _ageController,
                label: 'Age',
                hint: 'ages: 2 - 120',
              ),
              const SizedBox(height: 20),

              // Gender Selection
              const Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderButton('Male', Icons.male),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildGenderButton('Female', Icons.female),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Height Input
              const Text(
                'Height',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: _feetController,
                      label: 'Feet',
                      hint: '',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildInputField(
                      controller: _inchController,
                      label: 'Inches',
                      hint: '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Weight Input
              _buildInputField(
                controller: _weightController,
                label: 'Weight',
                hint: 'kg',
              ),
              const SizedBox(height: 30),

              // Calculate and Clear Buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _calculateBMI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF558B2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow),
                          SizedBox(width: 8),
                          Text(
                            'Calculate',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _clearFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Result Section
              if (_showResult)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      // Result Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Result',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF558B2F),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.bookmark_border, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  'save',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // BMI Value and Category
                      Row(
                        children: [
                          Text(
                            'BMI = ${_bmi.toStringAsFixed(1)} kg/m²',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _bmiColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '($_bmiCategory)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _bmiColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Animated BMI Gauge
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CustomPaint(
                            size: const Size(300, 160),
                            painter: BMIGaugePainter(_bmi, _animation.value),
                          );
                        },
                      ),
                      const SizedBox(height: 25),

                      // Additional Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Healthy BMI range:', '18.5 kg/m² - 25 kg/m²'),
                          _buildInfoRow('Healthy weight for the height:',
                              '${_healthyWeightMin.toStringAsFixed(1)} kg - ${_healthyWeightMax.toStringAsFixed(1)} kg'),
                          _buildInfoRow('BMI Prime:', _bmiPrime.toStringAsFixed(1)),
                          _buildInfoRow('Ponderal Index:', '${_ponderalIndex.toStringAsFixed(1)} kg/m³'),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveBMI,
                          icon: const Icon(Icons.save),
                          label: const Text(
                            'Save BMI Data',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94560),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF558B2F), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderButton(String gender, IconData icon) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' $value'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Animated BMI Gauge
class BMIGaugePainter extends CustomPainter {
  final double bmi;
  final double needleAngle;

  BMIGaugePainter(this.bmi, this.needleAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final radius = size.width / 2.5;
    final strokeWidth = 30.0;

    // Define BMI ranges with colors
    final ranges = [
      {'start': -math.pi, 'sweep': 0.5, 'color': const Color(0xFF2196F3)},
      {'start': -math.pi + 0.5, 'sweep': 0.8, 'color': const Color(0xFF4CAF50)},
      {'start': -math.pi + 1.3, 'sweep': 0.8, 'color': const Color(0xFFFFEB3B)},
      {'start': -math.pi + 2.1, 'sweep': 0.9, 'color': const Color(0xFFF44336)},
    ];

    // Draw gauge sections
    for (var range in ranges) {
      final paint = Paint()
        ..color = range['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        range['start'] as double,
        range['sweep'] as double,
        false,
        paint,
      );
    }

    // Draw BMI value labels
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final bmiValues = [16.5, 18.5, 25, 30, 35, 40];
    for (var i = 0; i < bmiValues.length; i++) {
      final angle = -math.pi + (i * math.pi / 5);
      final labelRadius = radius + 40;
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);

      textPainter.text = TextSpan(
        text: bmiValues[i].toStringAsFixed(0),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // Draw category labels on the gauge
    final categories = [
      {'text': 'Underweight', 'angle': -2.6},
      {'text': 'Normal', 'angle': -1.8},
      {'text': 'Overweight', 'angle': -0.9},
      {'text': 'Obese', 'angle': -0.2},
    ];

    for (var category in categories) {
      final angle = category['angle'] as double;
      final labelRadius = radius - 20;
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);

      textPainter.text = TextSpan(
        text: category['text'] as String,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + math.pi / 2);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }

    // Draw animated needle
    final needlePaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;

    final needleLength = radius + 15;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(needleAngle),
      center.dy + needleLength * math.sin(needleAngle),
    );

    // Draw needle shadow for depth
    canvas.drawLine(
      center,
      needleEnd,
      needlePaint..strokeWidth = 5..color = Colors.black26,
    );

    canvas.drawLine(
      center,
      needleEnd,
      needlePaint..strokeWidth = 3..color = Colors.grey[800]!,
    );

    // Draw center circle
    canvas.drawCircle(center, 10, Paint()..color = Colors.grey[800]!);
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);

    // Draw BMI value in center
    textPainter.text = TextSpan(
      text: 'BMI = ${bmi.toStringAsFixed(1)}',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - 50),
    );
  }

  @override
  bool shouldRepaint(covariant BMIGaugePainter oldDelegate) {
    return oldDelegate.needleAngle != needleAngle || oldDelegate.bmi != bmi;
  }
}