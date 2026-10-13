// Clean Architecture: Vendors — Data repository.
// Ports: ApprovedVendorFirestoreRepository.kt + VendorVerificationRepository.kt.
// Firestore wiring: inject CloudFirestore later; in-memory now for offline-first.
import 'package:flutter/material.dart';
import '../../domain/entities/vendor_entities.dart';
import '../../domain/repositories/vendors_repository.dart';

class VendorsRepository extends ChangeNotifier implements IVendorsRepository {
  @override
  final List<ApprovedVendorEntity> vendors = [
    const ApprovedVendorEntity(
      id: 'v-001', companyName: 'Gulf Steel LLC', companyNameAr: 'الخليج للصلب',
      category: 'Steel', location: 'JAFZA, Dubai', isVerified: true,
      status: ApprovedVendorStatus.verified,
    ),
  ];

  @override
  Future<void> submit(ApprovedVendorEntity v) async {
    vendors.add(v);
    notifyListeners();
    // TODO: FirebaseFirestore.instance.collection('vendors').doc(v.id).set(v.toJson());
  }

  @override
  Future<void> setVerified(String id, bool verified) async {
    final i = vendors.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final old = vendors[i];
    vendors[i] = ApprovedVendorEntity(
      id: old.id, companyName: old.companyName, companyNameAr: old.companyNameAr,
      category: old.category, location: old.location,
      contactEmail: old.contactEmail, contactPhone: old.contactPhone,
      tradeLicenseNumber: old.tradeLicenseNumber,
      tradeLicenseExpiry: old.tradeLicenseExpiry,
      status: verified ? ApprovedVendorStatus.verified : ApprovedVendorStatus.submitted,
      isVerified: verified, documents: old.documents,
      authorityApprovals: old.authorityApprovals,
    );
    notifyListeners();
  }
}
