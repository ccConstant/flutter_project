import 'dart:math';

import 'Cube.dart';

class Octree {
  late Voxel univers;
  late int longueurUnivers;
  static int _indexCreation = 0;
  static Random random = Random() ;

  // Constructeurs
  Octree() {
    univers = VoxelVide();
    longueurUnivers = 0;
  }
  Octree.fromChaine(String scene, int longueur) {
    _indexCreation = 0;
    longueurUnivers = longueur;
    univers = creationFromTexte(scene);
    // decompile (univers) ;
  }

  void decompile(Voxel v) {
    if (v is VoxelPlein) {print ('P') ;}
    else if (v is VoxelVide) {print ('V') ;}
    else {
      VoxelDivisible vd = v as VoxelDivisible ;
      print('D');
      for (Voxel voxel in vd.voxels) {
        decompile(voxel);
      }
    }
  }

  Octree.aleatoire(int longueur) {
    longueurUnivers = longueur;
    univers = creationAleatoire(longueur);
  }
/*
  Octree.fromMatrice(List<List<List<Voxel>>> matrice) {
    longueurUnivers = matrice[0][0].length;
    univers = creationFromMatrice(matrice, 0, 0, 0, longueurUnivers);
  }

  static Voxel creationFromMatrice(List<List<List<Voxel>>> matrice, int x, int y, int z, int longueur) {
    if (longueur==1)
      cubeEtat=matrice[x][y][z]==0  ? 'V' : 'P';
    else{
      int i=longueur/2;
      cubeEtat='D';
      filsDuCube[0]=new Cube(matrice,x,y,z+i,i);
      filsDuCube[1]=new Cube(matrice,x,y,z,i);
      filsDuCube[2]=new Cube(matrice,x,y+i,z+i,i);
      filsDuCube[3]=new Cube(matrice,x,y+i,z,i);
      filsDuCube[4]=new Cube(matrice,x+i,y,z+i,i);
      filsDuCube[5]=new Cube(matrice,x+i,y,z,i);
      filsDuCube[6]=new Cube(matrice,x+i,y+i,z+i,i);
      filsDuCube[7]=new Cube(matrice,x+i,y+i,z,i);
    }
    return VoxelVide() ;
  }
*/
  static Voxel creationAleatoire(int profondeur) {
      var valeursPossibles = ['P','V','D'];
      int randomNumber ;
      if (profondeur != 1)
        randomNumber = random.nextInt(3);
      else
        randomNumber = random.nextInt(2);
      if (valeursPossibles[randomNumber]=='P') {
        return VoxelPlein() ;
      } else if (valeursPossibles[randomNumber]=='V') {
        return VoxelVide() ;
      } else {
        List<Voxel> voxels = <Voxel>[];
        for (int i = 0; i < 8; i += 1) {
          voxels.add(creationAleatoire(profondeur ~/ 2));
        }
        return VoxelDivisible(voxels);
      }

      /*
      if (plein==8 || vide==8){
        cubeEtat= plein==8 ? 'P' : 'V';
        for (i = 0; i < 8; i += 1)
          filsDuCube[i] = null ;
      }
      */
    }

  static Voxel creationFromTexte(String octreeTexte) {
    final Voxel voxel;
    switch (octreeTexte[_indexCreation]) {
      case 'D':
        List<Voxel> voxels = <Voxel>[];
        for (int i = 0; i < 8; i += 1) {
       // for (Voxel voxel in voxels) {
          _indexCreation += 1;
          voxels.add(creationFromTexte(octreeTexte));
        }
        voxel = VoxelDivisible(voxels);
        break;
      case 'P':
        voxel = VoxelPlein();
        break;
      case 'V':
        voxel = VoxelVide();
        break;
      default:
        voxel = VoxelVide();
    }
    return (voxel);
  }

  void modifie(Octree octree) {
    longueurUnivers = octree.longueurUnivers;
    univers = octree.univers;
  }

  // Sélecteurs
  Voxel cubeUnivers() {
    return univers;
  }

  int retourneLongueurUnivers() {
    return longueurUnivers;
  }

  bool vide() {
    return (univers == null);
  }

  String toString() {
    return '$longueurUnivers+$univers';
  }

  Octree clone() {
    Octree resultat = Octree();
    resultat.longueurUnivers = longueurUnivers;
    resultat.univers = univers.clone();
    return resultat ;
  }

  Octree intersection(Octree octree) {
    Octree resultat = Octree();
    resultat.longueurUnivers = longueurUnivers;
    resultat.univers = univers.intersection(octree.univers);
    return resultat;
  }

  Octree union(Octree octree) {
    Octree resultat = Octree();
    resultat.longueurUnivers = longueurUnivers;
    resultat.univers = univers.union(octree.univers);
    return resultat;
  }

  Octree difference(Octree octree) {
    Octree resultat = Octree();
    resultat.longueurUnivers = longueurUnivers;
    resultat.univers = univers.difference(octree.univers);
    return resultat;
  }

  Octree complementaire() {
    Octree resultat = Octree();
    resultat.longueurUnivers = longueurUnivers;
    resultat.univers = univers.complementaire();
    return resultat;
  }
}
