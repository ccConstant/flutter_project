import 'package:flutter/material.dart';
import 'package:octrees/DessinArbre.dart';
import 'package:octrees/Octree.dart' ;

class OctreesProvider with ChangeNotifier {

  int theta = 45 ;
  int phi = 45 ;
  int rho = 50 ;

  // String arbre = "DPVVPVVVP" ;
  String arbre2 = "DPPPPVVVV" ;
  String arbre1 = "DPPPVPVDVVVVVVPVV" ;
  String arbre3 = "P" ;
  String arbre4 = "V" ;
// String arbre2 = "DVVVVVVDVVVVVVPVV" ;

  late Octree octree1, octree2, octreeResultant ;
  late DessinArbre da ;

  void initState() {
    octree1 = Octree.fromChaine(arbre1, 16) ;
    octree2 = Octree.fromChaine(arbre2, 16) ;
    // octreeResultant = octree1.intersection(octree2) ;
    octreeResultant = octree1.clone() ;
    // octreeResultant = octree1.complementaire() ;
    // octree = Octree.aleatoire(16) ;
    da = DessinArbre(octreeResultant, theta, phi, rho) ;
  }

  void dispose() {
    super.dispose();
  }
}