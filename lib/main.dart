import 'package:flutter/material.dart';

List<CrochetProject> myGlobalProjects = [];

void main() {
  runApp(const CrochetApp());
}

class CrochetApp extends StatelessWidget {
  const CrochetApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const OpeningPage(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),

        // elevated button style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          ),
        ),

        // floating action button style
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
    );
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
              child: const Text("Open Calculator"),
            ),

            const SizedBox(height: 7),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProjectsPage()),
                );
              },
              child: const Text("View Past Projects"),
            ),
          ],
        ),
      ),
    );
  }
}

// calculator screen where you can use the calcualtor
class CalculatorScreen extends StatefulWidget {
  final bool startWithSave;
  const CalculatorScreen({super.key, this.startWithSave = false});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// calculator logic
class _CalculatorScreenState extends State<CalculatorScreen> {
  String hoursInput = '';
  String materialsInput = '';
  String projectNameInput = '';

  double totalPrice = 0.0;
  double markup = 1.0;
  double wage = 10.0;
  List<double> wageOptions = [for (double i = 10.0; i <= 20.0; i += 0.25) i];

  bool isSaveSelected = false;

  @override
  void initState() {
    super.initState();
    isSaveSelected = widget.startWithSave;
  }

  void _calculatePrice() {
    double hours = double.tryParse(hoursInput) ?? 0.0;
    double materials = double.tryParse(materialsInput) ?? 0.0;

    setState(() {
      totalPrice = (hours * wage) + (materials * markup);
    });
  }

  void _saveProject() {
    setState(() {
      myGlobalProjects.add(
        CrochetProject(
          name: projectNameInput,
          hours: double.tryParse(hoursInput) ?? 0.0,
          materials: double.tryParse(materialsInput) ?? 0.0,
          markup: markup,
          wage: wage,
        ),
      );
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crochet Price Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // save project checkbox
            Row(
              children: [
                Checkbox(
                  value: isSaveSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      isSaveSelected = value ?? false;
                    });
                  },
                ),
                const Text('Save Project'),
              ],
            ),
            if (isSaveSelected)
              TextField(
                decoration: const InputDecoration(labelText: 'Project Name'),
                onChanged: (value) => projectNameInput = value,
              ),
            const SizedBox(height: 20),

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
              onPressed: () {
                _calculatePrice();
                if (isSaveSelected) {
                  _saveProject();
                }
              },
              child: Text(
                isSaveSelected ? 'Calculate Price and Save' : 'Calculate Price',
              ),
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

// past projects page where you can view the past projects
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Projects')),
      body: myGlobalProjects.isEmpty
          ? const Center(child: Text('No projects saved yet!'))
          : ListView.builder(
              itemCount: myGlobalProjects.length,
              itemBuilder: (context, index) {
                final project = myGlobalProjects[index];
                return ListTile(
                  leading: const Icon(Icons.architecture),
                  title: Text(project.name),
                  subtitle: Text(
                    'Hours: ${project.hours} | Wage: \$${project.wage}',
                  ),
                  trailing: Text('\$${project.totalPrice.toStringAsFixed(2)}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CalculatorScreen(startWithSave: true),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// project object that will store required information
class CrochetProject {
  String name;
  double hours;
  double materials;
  double markup;
  double wage;
  CrochetProject({
    required this.name,
    required this.hours,
    required this.materials,
    required this.markup,
    required this.wage,
  });

  double get totalPrice => (hours * wage) + (materials * markup);
}
