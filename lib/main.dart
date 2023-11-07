import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SolarSystemScreen(),
    );
  }
}

class SolarSystemScreen extends StatefulWidget {
  @override
  _SolarSystemScreenState createState() => _SolarSystemScreenState();
}

class _SolarSystemScreenState extends State<SolarSystemScreen> {
  List<Planet> planets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Солнечная система"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddPlanetScreen(onPlanetAdded: (planet) {
                  setState(() {
                    planets.add(planet);
                  });
                  Navigator.of(context).pop();
                }),
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Sun(),
            for (var planet in planets) PlanetWidget(planet: planet),
          ],
        ),
      ),
    );
  }
}

class Sun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.yellow,
      ),
    );
  }
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

class PlanetWidget extends StatefulWidget {
  final Planet planet;

  PlanetWidget({required this.planet});

  @override
  _PlanetWidgetState createState() => _PlanetWidgetState();
}

class _PlanetWidgetState extends State<PlanetWidget> {
  double angle = 0.0;

  @override
  void initState() {
    super.initState();
    rotatePlanet();
  }

  void rotatePlanet() {
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        angle += widget.planet.rotationSpeed;
        if (angle >= 360) angle = 0;
      });
      rotatePlanet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final x =
        widget.planet.distance * 100.0 * 2.0 * (angle / 360) * 3.14159265359;
    final y =
        widget.planet.distance * 100.0 * 2.0 * (angle / 360) * 3.14159265359;

    return Positioned(
      left: 200 + x,
      top: 200 + y,
      child: Container(
        width: widget.planet.radius,
        height: widget.planet.radius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.planet.color,
        ),
      ),
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
  double radius = 20.0;
  Color color = Colors.blue;
  double distance = 2.0;
  double rotationSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить планету"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(
              value: radius,
              min: 10.0,
              max: 50.0,
              onChanged: (value) {
                setState(() {
                  radius = value;
                });
              },
            ),
            Text("Радиус планеты: $radius"),
            SizedBox(height: 20.0),
            ColorPicker(
              pickerColor: color,
              onColorChanged: (newColor) {
                setState(() {
                  color = newColor;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
            SizedBox(height: 20.0),
            Slider(
              value: distance,
              min: 1.0,
              max: 4.0,
              onChanged: (value) {
                setState(() {
                  distance = value;
                });
              },
            ),
            Text("Удаленность: $distance"),
            SizedBox(height: 20.0),
            Slider(
              value: rotationSpeed,
              min: 0.1,
              max: 5.0,
              onChanged: (value) {
                setState(() {
                  rotationSpeed = value;
                });
              },
            ),
            Text("Скорость вращения: $rotationSpeed"),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                final newPlanet = Planet(
                  radius: radius,
                  color: color,
                  distance: distance,
                  rotationSpeed: rotationSpeed,
                );
                widget.onPlanetAdded(newPlanet);
              },
              child: Text("Добавить планету"),
            ),
          ],
        ),
      ),
    );
  }
}
