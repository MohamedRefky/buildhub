// Clean Architecture: Vendors feature — Domain repository contracts.
// Implemented by features/vendors/data/repositories/vendors_repository.dart
// (Firestore wiring later; in-memory now for offline-first).
import '../entities/vendor_entities.dart';

abstract class IVendorsRepository {
  List<ApprovedVendorEntity> get vendors;
  Future<void> submit(ApprovedVendorEntity v);
  Future<void> setVerified(String id, bool verified);
}
