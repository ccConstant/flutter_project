import 'package:flutter/material.dart';
import 'package:projet/DessinArbre.dart';
import 'package:projet/Octree.dart' ;


// String arbre = "DPVVPVVVP" ;
String arbre2 = "DPPPPVVVV" ;
String arbre1 = "DPPPVPVDVVVVVVPVV" ;
String arbre3 = "P" ;
String arbre4 = "V" ;
// String arbre2 = "DVVVVVVDVVVVVVPVV" ;

int theta = 45 ;
int phi = 45 ;
int rho = 50 ;

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Des cubes !!! Rien que des cubes !!')),
        body: Column(
          children: [
            Expanded(child: MyWorkingArea())
          ],
        ));
  }
}

class MyWorkingArea extends StatefulWidget {
  MyWorkingArea({Key? key}) : super(key: key);

  @override
  State<MyWorkingArea> createState() => _MyWorkingAreaState();
}
class _MyWorkingAreaState extends State<MyWorkingArea> {

  late Octree octree1, octree2, octreeResultant ;
  late DessinArbre da ;

  void initState() {
    octree1 = Octree.fromChaine(arbre1, 16) ;
    octree2 = Octree.fromChaine(arbre2, 16) ;
    // octreeResultant = octree1.intersection(octree2) ;
    octreeResultant = octree1.clone() ;
    //octreeResultant = octree1.complementaire() ;
    //octreeResultant = Octree.aleatoire(16) ;
    da = DessinArbre(octreeResultant, theta, phi, rho) ;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: MediaQuery.of(context).size,
        painter: Painter(da),
    );
  }
}

class Painter extends CustomPainter {
  final DessinArbre da;

  const Painter(this.da);

  @override
  void paint(Canvas canvas, Size size) {
    da.maxX = size.width ;
    da.maxY = size.height ;
    da.dessineArbre (canvas) ;
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => true;
}