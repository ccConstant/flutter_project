abstract class Voxel {
  Voxel clone();

  Voxel intersection(Voxel voxel) {
    if ((this is VoxelVide) || (voxel is VoxelVide)) return VoxelVide();
    if ((this is VoxelPlein) && (voxel is VoxelPlein)) return VoxelPlein();
    //if ((this is VoxelDivisible) && (voxel is VoxelDivisible)) {
    if ((this is VoxelDivisible) && (voxel is VoxelDivisible)) {
      List<Voxel> voxels = <Voxel>[];
      VoxelDivisible vdThis = this as VoxelDivisible;
      for (int i = 0; i < 8; i += 1) {
        voxels.add(vdThis.voxels[i].intersection(voxel.voxels[i]));
      }
      return VoxelDivisible(voxels);
    } else {
      // this is VoxelDivisible et voxel is VoxelPlein
      return this.clone();
    }
  }

  Voxel union(Voxel voxel) {
    if ((this is VoxelPlein) || (voxel is VoxelPlein)) return VoxelPlein();
    if ((this is VoxelVide) && (voxel is VoxelVide)) return VoxelVide();
    if ((this is VoxelDivisible) && (voxel is VoxelDivisible)) {
      List<Voxel> voxels = <Voxel>[];
      VoxelDivisible vdThis = this as VoxelDivisible;
      VoxelDivisible vdVoxel = voxel as VoxelDivisible;
      for (int i = 0; i < 8; i += 1) {
        voxels.add(vdThis.voxels[i].union(vdVoxel.voxels[i]));
      }
      return VoxelDivisible(voxels);
    }
    return this.clone() ; // this VoxelDivisible && voxel VoxelVide
  }

  Voxel difference(Voxel voxel) {
    if ((this is VoxelVide) || ((voxel is VoxelPlein))) return VoxelVide();
    if (voxel is VoxelVide) return this;
    if ((this is VoxelPlein)) return voxel.complementaire();
    List<Voxel> voxels = <Voxel>[];
    VoxelDivisible vdThis = this as VoxelDivisible;
    VoxelDivisible vdVoxel = voxel as VoxelDivisible;
    for (int i = 0; i < 8; i += 1) {
      voxels.add(vdThis.voxels[i].difference(vdVoxel.voxels[i]));
    }
    return VoxelDivisible(voxels);
  }

  Voxel complementaire() {
    if (this is VoxelVide) return VoxelPlein();
    if (this is VoxelPlein) return VoxelVide();
    List<Voxel> voxels = <Voxel>[];
    VoxelDivisible vdThis = this as VoxelDivisible;
    for (int i = 0; i < 8; i += 1) {
      voxels.add(vdThis.voxels[i].complementaire());
    }
    return VoxelDivisible(voxels);
  }
}

class VoxelVide extends Voxel {
  @override
  Voxel clone() => VoxelVide();
}

class VoxelPlein extends Voxel {
  @override
  Voxel clone() => VoxelPlein();
}

class VoxelDivisible extends Voxel {
  List<Voxel> voxels = [];
  VoxelDivisible(this.voxels);
  @override
  Voxel clone() {
    List<Voxel> voxels = <Voxel>[];
    for (int i = 0; i < 8; i += 1) {
      voxels.add(this.voxels[i].clone());
    }
    return VoxelDivisible(voxels);
  }
}
