import 'package:flutter/material.dart';
import 'package:octrees/DessinArbre.dart';
import 'package:octrees/Painter.dart';
import 'package:octrees/Octree.dart';
import 'package:octrees/OctreesProvider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// on récupère la taille de la fenêtre pour dimensionner le dessin dans le canvas
// final size = window.physicalSize / window.devicePixelRatio;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
            create: (_) => OctreesProvider(),
            child: MyHomePage())
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Des cubes !!! Rien que des cubes !!')),
        body: Column(
          children: [Expanded(child: MyWorkingArea())],
        ));
  }
}

class MyWorkingArea extends StatelessWidget {
  MyWorkingArea({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Consumer<OctreesProvider>(builder: (context, OctreesProvider, child) {
      OctreesProvider.initState();
      return CustomPaint(
        size: MediaQuery
            .of(context)
            .size,
        painter: Painter(OctreesProvider.da),
      );
    });
  }
}
