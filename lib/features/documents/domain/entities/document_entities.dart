// Clean Architecture: Documents feature — Domain entities.
// Ports: UserFileMetadata.kt, TenantOrganizationModel.kt,
// ConstructionSpecification.kt, EnterpriseMasterArchitectureModels (docs parts).
enum FileVisibility { private, project, public }

class UserFileMeta {
  final String id;
  final String ownerUid;
  final String fileName;
  final String storagePath;
  final String downloadUrl;
  final int sizeBytes;
  final FileVisibility visibility;
  const UserFileMeta({
    required this.id, required this.ownerUid, required this.fileName,
    this.storagePath = '', this.downloadUrl = '',
    this.sizeBytes = 0, this.visibility = FileVisibility.project,
  });
}

class TenantOrg {
  final String id;
  final String nameAr;
  final String nameEn;
  final String trn;
  const TenantOrg({
    required this.id, required this.nameAr,
    required this.nameEn, this.trn = '',
  });
}

class ConstructionSpec {
  final String id;
  final String code;
  final String titleAr;
  final String titleEn;
  final String authority;
  const ConstructionSpec({
    required this.id, required this.code,
    required this.titleAr, required this.titleEn,
    this.authority = '',
  });
}

class RfiEntity {
  final String id;
  final String rfiNo;
  final String titleAr;
  final String titleEn;
  final String status;
  const RfiEntity({
    required this.id, required this.rfiNo,
    required this.titleAr, required this.titleEn, this.status = 'OPEN',
  });
}
