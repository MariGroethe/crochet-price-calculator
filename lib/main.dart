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
  final CrochetProject? projectToEdit;
  const CalculatorScreen({
    super.key,
    this.startWithSave = false,
    this.projectToEdit,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// calculator logic
class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formkey = GlobalKey<FormState>();
  String hoursInput = '';
  String materialsInput = '';
  String projectNameInput = '';

  // controllers for auto filling in fields when editing project
  late TextEditingController nameController;
  late TextEditingController hoursController;
  late TextEditingController materialsController;

  double totalPrice = 0.0;
  double markup = 1.0;
  double wage = 10.0;
  List<double> wageOptions = [for (double i = 10.0; i <= 20.0; i += 0.25) i];

  bool isSaveSelected = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    hoursController = TextEditingController();
    materialsController = TextEditingController();

    if (widget.projectToEdit != null) {
      nameController.text = widget.projectToEdit!.name;
      hoursController.text = widget.projectToEdit!.hours.toString();
      materialsController.text = widget.projectToEdit!.materials.toString();

      isSaveSelected = true;
      projectNameInput = widget.projectToEdit!.name;
      hoursInput = widget.projectToEdit!.hours.toString();
      materialsInput = widget.projectToEdit!.materials.toString();
      markup = widget.projectToEdit!.markup;
      wage = widget.projectToEdit!.wage;
    } else {
      isSaveSelected = widget.startWithSave;
    }
  }

  void _calculatePrice() {
    double hours = double.tryParse(hoursInput) ?? 0.0;
    double materials = double.tryParse(materialsInput) ?? 0.0;

    setState(() {
      totalPrice = (hours * wage) + (materials * markup);
    });
  }

  void _saveProject() {
    if (_formkey.currentState!.validate()) {
      CrochetProject projectToDisplay;

      if (widget.projectToEdit != null) {
        setState(() {
          widget.projectToEdit!.name = projectNameInput;
          widget.projectToEdit!.hours = double.tryParse(hoursInput) ?? 0.0;
          widget.projectToEdit!.materials =
              double.tryParse(materialsInput) ?? 0.0;
          widget.projectToEdit!.markup = markup;
          widget.projectToEdit!.wage = wage;
        });
        projectToDisplay = widget.projectToEdit!;
      } else {
        final newProject = CrochetProject(
          name: projectNameInput,
          hours: double.tryParse(hoursInput) ?? 0.0,
          materials: double.tryParse(materialsInput) ?? 0.0,
          markup: markup,
          wage: wage,
        );
        setState(() {
          myGlobalProjects.add(newProject);
        });
        projectToDisplay = newProject;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectDetailScreen(project: projectToDisplay),
        ),
      );
    } else {
      debugPrint("Validation Failed");
    }
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
            Form(
              key: _formkey,
              child: Column(
                children: [
                  if (isSaveSelected)
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Project Name',
                        border: OutlineInputBorder(),
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a name';
                        }
                        return null;
                      },
                      onChanged: (value) => projectNameInput = value,
                    ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // hours input
            TextField(
              controller: hoursController,
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
              controller: materialsController,
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

  @override
  void dispose() {
    nameController.dispose();
    hoursController.dispose();
    materialsController.dispose();

    super.dispose();
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
                  subtitle: Text('\$${project.totalPrice.toStringAsFixed(2)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetailScreen(project: project),
                      ),
                    );
                  },
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

// screen where project details will be displayed after being click on in project screen or after creating new project
class ProjectDetailScreen extends StatelessWidget {
  final CrochetProject project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CalculatorScreen(projectToEdit: project),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total price: \$${project.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Text('Hours: ${project.hours}'),
            Text('Hourly Wage: \$${project.wage}'),
            Text('Material Cost: \$${project.materials}'),
            Text('Markup: ${project.markup.toStringAsFixed(2)}x'),
          ],
        ),
      ),
    );
  }
}
