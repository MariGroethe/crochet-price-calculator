import 'package:flutter/material.dart';

void main() {
  runApp(const CrochetApp());
}

class CrochetApp extends StatelessWidget {
  const CrochetApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const OpeningPage());
  }
}

// home page where you can select calculator
class OpeningPage extends StatelessWidget {
  const OpeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crochet Price Tool',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Value your handmade art fairly.'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculatorScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Open Calculator"),
            ),
          ],
        ),
      ),
    );
  }
}

// calculator screen where you can use the calcualtor
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// calculator logic
class _CalculatorScreenState extends State<CalculatorScreen> {
  String hoursInput = '';
  String materialsInput = '';

  double totalPrice = 0.0;
  double markup = 1.0;
  double wage = 10.0;
  List<double> wageOptions = [for (double i = 10.0; i <= 20.0; i += 0.25) i];

  void _calculatePrice() {
    double hours = double.tryParse(hoursInput) ?? 0.0;
    double materials = double.tryParse(materialsInput) ?? 0.0;

    setState(() {
      totalPrice = (hours * wage) + (materials * markup);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crochet Price Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // hours input
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Hours Worked',
                hintText: 'Enter total hours (e.g. 5)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  hoursInput = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // materials input
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Material Costs',
                hintText: 'Enter total material costs (e.g. 15)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  materialsInput = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // markup Slider
            Text('Markup: ${markup.toStringAsFixed(1)}x'),
            Slider(
              value: markup,
              min: 1.0,
              max: 5.0,
              activeColor: const Color.fromARGB(255, 55, 93, 214),
              inactiveColor: Colors.blueGrey,
              thumbColor: const Color.fromARGB(255, 23, 60, 164),
              divisions: 8,
              label: markup.toStringAsFixed(1),
              onChanged: (double newValue) {
                setState(() {
                  markup = newValue;
                });
              },
            ),

            // hourly wage dropdown
            DropdownButton<double>(
              value: wage,
              focusColor: Colors.transparent,
              items: wageOptions.map((double value) {
                return DropdownMenuItem<double>(
                  value: value,
                  child: Text('\$$value per hour'),
                );
              }).toList(),
              onChanged: (double? newValue) {
                setState(() {
                  wage = newValue!;
                });
              },
            ),

            // calculate button
            ElevatedButton(
              onPressed: _calculatePrice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Calculate Price'),
            ),
            const SizedBox(height: 30),

            // display result
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
