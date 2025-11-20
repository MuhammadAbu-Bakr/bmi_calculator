import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BMICalculator());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const BMICalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> with SingleTickerProviderStateMixin {
  final TextEditingController cmController = TextEditingController();
  final TextEditingController feetController = TextEditingController();
  final TextEditingController inchesController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  
  double bmiResult = 0;
  String bmiCategory = '';
  String bmiDescription = '';
  int selectedHeightUnit = 0;
  bool isWeightInKg = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void calculateBMI() {
    double heightInMeters = 0;
    double weightInKg = double.tryParse(weightController.text) ?? 0;
    
    if (!isWeightInKg && weightInKg > 0) {
      weightInKg = weightInKg * 0.453592;
    }

    if (selectedHeightUnit == 0) {
      double cm = double.tryParse(cmController.text) ?? 0;
      if (cm > 0) heightInMeters = cm / 100;
    } else {
      double feet = double.tryParse(feetController.text) ?? 0;
      double inches = double.tryParse(inchesController.text) ?? 0;
      if (feet > 0 || inches > 0) {
        heightInMeters = (feet * 12 + inches) * 0.0254;
      }
    }

    if (heightInMeters > 0 && weightInKg > 0) {
      final double bmi = weightInKg / (heightInMeters * heightInMeters);
      
      setState(() {
        bmiResult = bmi;
        if (bmi < 18.5) {
          bmiCategory = 'Underweight';
          bmiDescription = 'You may need to gain weight. Consider consulting a nutritionist.';
        } else if (bmi < 25) {
          bmiCategory = 'Normal weight';
          bmiDescription = 'Great! You have a healthy body weight. Maintain it!';
        } else if (bmi < 30) {
          bmiCategory = 'Overweight';
          bmiDescription = 'Consider some lifestyle changes to reach a healthier weight.';
        } else {
          bmiCategory = 'Obese';
          bmiDescription = 'Consult with a healthcare provider for weight management strategies.';
        }
        _animationController.forward(from: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'BMI Calculator',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.indigo[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Calculate your Body Mass Index',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              
              // Height Card
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Height',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<int>(
                      style: SegmentedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        selectedBackgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      segments: const [
                        ButtonSegment(
                          value: 0,
                          label: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('cm'),
                          ),
                        ),
                        ButtonSegment(
                          value: 1,
                          label: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('ft + in'),
                          ),
                        ),
                      ],
                      selected: {selectedHeightUnit},
                      onSelectionChanged: (Set<int> newSelection) {
                        setState(() {
                          selectedHeightUnit = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (selectedHeightUnit == 0)
                      TextField(
                        controller: cmController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Height in cm',
                          prefixIcon: Icon(Icons.height, color: Colors.indigo[300]),
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: feetController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Feet',
                                prefixIcon: Icon(Icons.straighten, color: Colors.indigo[300]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: inchesController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Inches',
                                prefixIcon: Icon(Icons.straighten, color: Colors.indigo[300]),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Weight Card
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: isWeightInKg ? 'Weight in kg' : 'Weight in lbs',
                              prefixIcon: Icon(Icons.monitor_weight, color: Colors.indigo[300]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(10),
                            isSelected: [isWeightInKg, !isWeightInKg],
                            onPressed: (int index) {
                              setState(() {
                                isWeightInKg = index == 0;
                              });
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('kg'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text('lbs'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'CALCULATE BMI',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Result Card
              if (bmiResult > 0)
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _getBMIColor(bmiResult),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _getBMIColor(bmiResult).withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'YOUR BMI RESULT',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          bmiResult.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bmiCategory.toUpperCase(),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          bmiDescription,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Normal BMI range: 18.5 - 25 kg/m²',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue[400]!;
    if (bmi < 25) return Colors.green[400]!;
    if (bmi < 30) return Colors.orange[400]!;
    return Colors.red[400]!;
  }

  @override
  void dispose() {
    _animationController.dispose();
    cmController.dispose();
    feetController.dispose();
    inchesController.dispose();
    weightController.dispose();
    super.dispose();
  }
}