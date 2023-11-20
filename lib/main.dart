import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(
    MaterialApp(
      home: SolarSystemApp(),
    ),
  );
}

class Planet {
  final double radius;
  final Color color;
  final double distance;
  final double rotationSpeed;

  Planet({
    required this.radius,
    required this.color,
    required this.distance,
    required this.rotationSpeed,
  });
}

class SolarSystemApp extends StatefulWidget {
  @override
  _SolarSystemAppState createState() => _SolarSystemAppState();
}

class _SolarSystemAppState extends State<SolarSystemApp> {
  final List<Planet> planets = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Солнечная Система'),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
            for (var i = 0; i < planets.length; i++)
              Positioned.fill(
                child: AnimatedPlanet(
                  planet: planets[i],
                  orbitRadius: (i + 1) * 75.0,
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddPlanetScreen(
                  onPlanetAdded: (Planet planet) {
                    setState(() {
                      planets.add(planet);
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class AnimatedPlanet extends StatefulWidget {
  final Planet planet;
  final double orbitRadius;

  AnimatedPlanet({required this.planet, required this.orbitRadius});

  @override
  _AnimatedPlanetState createState() => _AnimatedPlanetState();
}

class _AnimatedPlanetState extends State<AnimatedPlanet>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * pi,
          child: Stack(
            children: [
              Positioned(
                top: widget.orbitRadius,
                child: Container(
                  width: widget.planet.radius,
                  height: widget.planet.radius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.planet.color,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddPlanetScreen extends StatefulWidget {
  final Function(Planet) onPlanetAdded;

  AddPlanetScreen({required this.onPlanetAdded});

  @override
  _AddPlanetScreenState createState() => _AddPlanetScreenState();
}

class _AddPlanetScreenState extends State<AddPlanetScreen> {
  double _radius = 0;
  Color _color = Colors.transparent;
  double _distance = 0;
  double _rotationSpeed = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить планету'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Радиус'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _radius = double.parse(value);
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Цвет'),
                  onChanged: (value) {
                    setState(() {
                      _color = Color(int.parse(value, radix: 16));
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Расстояние'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _distance = double.parse(value);
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Скорость вращения'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _rotationSpeed = double.parse(value);
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    final planet = Planet(
                      radius: _radius,
                      color: _color,
                      distance: _distance,
                      rotationSpeed: _rotationSpeed,
                    );
                    widget.onPlanetAdded(planet);
                  },
                  child: Text('Добавить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
