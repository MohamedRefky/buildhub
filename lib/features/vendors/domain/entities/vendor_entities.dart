// Clean Architecture: Vendors feature — Domain entities.
// Ports: ApprovedVendor.kt, VendorVerificationModels.kt,
// GCCAuthorityModel.kt, SupplierMaterialEntity.kt, LinkedInIntegration.kt

enum ApprovedVendorStatus { draft, submitted, verified, rejected }
enum VendorVerificationStatus { selfDeclared, underReview, orionbVerified, rejected, expired }
enum AuthorityType { rta, dewa, dubaiMunicipality, trakhees, adnoc, etihadWe, civilDefense, other }

class VendorDocumentReference {
  final String id;
  final String documentType;
  final String title;
  final String documentNumber;
  final String issuer;
  final String expiryDate;
  final String downloadUrl;
  const VendorDocumentReference({
    required this.id, this.documentType = 'CERTIFICATION',
    this.title = '', this.documentNumber = '', this.issuer = '',
    this.expiryDate = '', this.downloadUrl = '',
  });
}

class AuthorityApprovalRecord {
  final String id;
  final AuthorityType authority;
  final String approvalNumber;
  final String approvalScope;
  final String issueDate;
  final String expiryDate;
  const AuthorityApprovalRecord({
    required this.id, required this.authority,
    this.approvalNumber = '', this.approvalScope = '',
    this.issueDate = '', this.expiryDate = '',
  });
}

class ApprovedVendorEntity {
  final String id;
  final String companyName;
  final String companyNameAr;
  final String category;
  final String location;
  final String contactEmail;
  final String contactPhone;
  final String tradeLicenseNumber;
  final String tradeLicenseExpiry;
  final ApprovedVendorStatus status;
  final bool isVerified;
  final List<VendorDocumentReference> documents;
  final List<AuthorityApprovalRecord> authorityApprovals;
  const ApprovedVendorEntity({
    required this.id, this.companyName = '', this.companyNameAr = '',
    this.category = 'Building Materials', this.location = 'Dubai, UAE',
    this.contactEmail = '', this.contactPhone = '',
    this.tradeLicenseNumber = '', this.tradeLicenseExpiry = '',
    this.status = ApprovedVendorStatus.draft, this.isVerified = false,
    this.documents = const [], this.authorityApprovals = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'companyName': companyName, 'companyNameAr': companyNameAr,
    'category': category, 'status': status.name, 'isVerified': isVerified,
  };

  static ApprovedVendorEntity fromJson(Map<String, dynamic> j) =>
      ApprovedVendorEntity(
        id: (j['id'] ?? '').toString(),
        companyName: (j['companyName'] ?? '').toString(),
        companyNameAr: (j['companyNameAr'] ?? '').toString(),
        category: (j['category'] ?? 'Building Materials').toString(),
        isVerified: j['isVerified'] == true,
      );
}

class SupplierMaterialEntity {
  final String id;
  final String supplierId;
  final String materialNameAr;
  final String materialNameEn;
  final double unitPriceAed;
  final String unit;
  const SupplierMaterialEntity({
    required this.id, required this.supplierId,
    required this.materialNameAr, required this.materialNameEn,
    required this.unitPriceAed, this.unit = 'unit',
  });
}

class GccAuthorityEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final String serviceUrl;
  const GccAuthorityEntity({
    required this.id, required this.nameAr,
    required this.nameEn, this.serviceUrl = '',
  });
}
