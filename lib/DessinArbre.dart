import 'package:flutter/material.dart';
import 'dart:math' ;
import 'dart:ui' ;
import 'Octree.dart' ;
import 'Cube.dart' ;

Paint paint = Paint()..color = Colors.black;

class DessinArbre {
  late int region, de, nbfaces = 6, echelle=1;
  late double maxX,maxY;
  late int rho, theta, phi;
  late double aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8;
  late double o1, o2, o3;
  late Point<int> centre ;
  List<Offset> sommets = List<Offset>.filled(4, Offset.zero) ;

  static final parcours = [
  [0,1,2,3,4,5,6,7],
  [1,0,3,2,5,4,7,6],
  [2,3,0,1,6,7,4,5],
  [3,2,1,0,7,6,5,4],
  [4,5,6,7,0,1,2,3],
  [5,4,7,6,1,0,3,2],
  [6,7,4,5,2,3,0,1],
  [7,6,5,4,3,2,1,0]] ;

  static final calcCoord = [[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]] ;

  static final listeFaces =  [[0,3,2,1], [0,4,7,3],[0,1,5,4],[1,2,6,5],[6,2,3,7],[4,5,6,7]];
  
  var cubeSommets = List.generate(8, (i) => [0,0,0], growable: false) ;

  List<Point<int>?> facette = List.generate (4, (i) => null, growable: false) ;

//  var xFacette = List<int>.generate(4, (i) => 0, growable: false) ;
//  var yFacette = List<int>.generate(4, (i) => 0, growable: false) ;
  static int nbRepet=0;
  late Octree arbreUnivers;



  DessinArbre (this.arbreUnivers, this.theta, this.phi, int this.rho) ;

  void dessineArbre(Canvas canvas) {
    paint.color = Colors.black ;
    canvas.drawPaint(paint);
    //paint.color = Colors.black ;
    de = 400 ;
    initialiseProjection ();
    o1 = rho * aux7 ;
    o2 = rho * aux8 ;
    o3 = rho * aux2 ;
    region = determineRegion (arbreUnivers.retourneLongueurUnivers()) ;
    perspective (arbreUnivers.cubeUnivers(), 0, 0, 0, arbreUnivers.retourneLongueurUnivers(), canvas) ;
  }

  void initialiseProjection () {
    double th, ph ;
    th = (pi * theta / 180) ;
    ph = (pi  * phi / 180) ;
    aux1 = sin (th) ;
    aux2 = sin (ph) ;
    aux3 = cos (th) ;
    aux4 = cos (ph) ;
    aux5 = aux3 * aux2 ;
    aux6 = aux1 * aux2 ;
    aux7 = aux3 * aux4 ;
    aux8 = aux1 * aux4 ;
  }

  int determineRegion (int l) {
    int region ;
    double lsur2;
    region=0;
    lsur2= l/2;
    if (o1 < lsur2) region= region + 4 ;
    if (o2 < lsur2) region= region + 2 ;
    if (o3 < lsur2) region = region + 1 ;
    centre = projette (l ~/ 2, l ~/ 2, l ~/ 2) ;
    centre = new Point (maxX ~/ 2 - centre.x, maxY ~/ 2 - centre.y) ;
    return (region) ;
  }

  Point<int> projette (int x, int y, int z) {
    double xObs, yObs, zObs ;
    double calcXproj, calcYproj ;
    xObs = -x * aux1 + y * aux3 ;
    yObs = -x * aux5 - y * aux6 + z * aux4 ;
    zObs = -x * aux7 - y * aux8 - z * aux2 + rho ;
    calcXproj = (de * xObs / zObs) * echelle + maxX / 2 ;
    calcYproj = maxY / 2 - (de * yObs / zObs) ;
    return (Point (calcXproj.toInt() , calcYproj.toInt())) ;
  }

  void perspective (Voxel c, int x, int y, int z, int l, Canvas canvas){
    int i, lsur2 ;
    if (c is VoxelPlein) {
      cubeDessine(x, y, z, l, canvas);
    }
    else if (c is VoxelDivisible) {
        lsur2 = l ~/ 2 ;
        for (i = 0; i < 8; i += 1) {
          VoxelDivisible vd = c as VoxelDivisible ;
          perspective(vd.voxels[parcours[region][i]],
              x + calcCoord[parcours[region][i]][0] * lsur2,
              y + calcCoord[parcours[region][i]][1] * lsur2,
              z + calcCoord[parcours[region][i]][2] * lsur2,
              lsur2, canvas);
        }
    }
  }

  void cubeDessine (int x, int y, int z, int c, Canvas canvas) {
    int face, st1, st2, st3 ;
    double v1, v2, v3, n1, n2, n3 ;

    cubeSommets[0][0] = x ;    cubeSommets[0][1] = y ;    cubeSommets [0][2] = z ;
    cubeSommets[1][0] = x ;    cubeSommets[1][1] = y + c; cubeSommets [1][2] = z ;
    cubeSommets[2][0] = x ;    cubeSommets[2][1] = y + c; cubeSommets [2][2] = z + c;
    cubeSommets[3][0] = x ;    cubeSommets[3][1] = y ;    cubeSommets [3][2] = z + c;
    cubeSommets[4][0] = x + c; cubeSommets[4][1] = y ;    cubeSommets [4][2] = z ;
    cubeSommets[5][0] = x + c; cubeSommets[5][1] = y + c; cubeSommets [5][2] = z ;
    cubeSommets[6][0] = x + c; cubeSommets[6][1] = y + c; cubeSommets [6][2] = z + c;
    cubeSommets[7][0] = x + c; cubeSommets[7][1] = y ;    cubeSommets [7][2] = z + c;
    for ( face = 0; face < nbfaces; face += 1)
    {
      st1 = listeFaces[face][0] ;
      st2 = listeFaces[face][1] ;
      st3 = listeFaces[face][2] ;
      v1 = o1 - cubeSommets[st1][0] ;
      v2 = o2 - cubeSommets[st1][1] ;
      v3 = o3 - cubeSommets[st1][2] ;
      double p1, p2, p3, q1, q2, q3 ;
      p1 = (cubeSommets[st2][0] -cubeSommets[st1][0]).toDouble() ;
      p2 = (cubeSommets[st2][1] -cubeSommets[st1][1]).toDouble() ;
      p3 = (cubeSommets[st2][2] -cubeSommets[st1][2]).toDouble() ;
      q1 = (cubeSommets[st3][0] -cubeSommets[st1][0]).toDouble() ;
      q2 = (cubeSommets[st3][1] -cubeSommets[st1][1]).toDouble() ;
      q3 = (cubeSommets[st3][2] -cubeSommets[st1][2]).toDouble() ;

      n1 = p2*q3 - q2*p3 ;
      n2 = p3*q1 - q3*p1 ;
      n3 = p1*q2 - q1*p2 ;
      if (produitScalaire (v1, v2, v3, n1, n2, n3) > 0) {
        faceDessine (face, canvas);
      }
    }
  }

  void faceDessine (int face, Canvas canvas) {
    int sommet, no, xFacette, yFacette ;
    for (sommet = 0; sommet < 4; sommet += 1)
    {
      no = listeFaces[face][sommet] ;
      facette[sommet] = projette (cubeSommets[no][0], cubeSommets[no][1], cubeSommets[no][2]) ;
      xFacette = facette[sommet]!.x + centre.x ;
      yFacette = facette[sommet]!.y + centre.y ;
      sommets[sommet] = Offset(xFacette.toDouble(), yFacette.toDouble()) ;
    }

    switch (face)
    {
      case 0 : paint.color = Colors.deepPurpleAccent ; break ;
      case 5 : paint.color = Colors.amberAccent ; break ;
      case 2 : paint.color = Colors.black12 ; break ;
      case 4 : paint.color = Colors.pinkAccent ; break ;
      case 1 : paint.color = Colors.indigoAccent ; break ;
      case 3 : paint.color = Colors.greenAccent ;
    }
    // paint.style = PaintingStyle.fill ;
    canvas.drawVertices (Vertices(VertexMode.triangleFan,sommets), BlendMode.plus, paint) ; //(xFacette, yFacette, 4) ;
  }

  static double produitScalaire (double v1, double v2, double v3, double n1, double n2, double n3) {
    return (v1*n1 + v2*n2 + v3*n3) ;
  }
}