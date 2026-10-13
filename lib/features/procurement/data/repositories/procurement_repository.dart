// Clean Architecture: Procurement — Data repository.
// Ports: FirestoreProcurementService.kt + MaterialOrderDao + Marketplace parts.
import 'package:flutter/material.dart';
import '../domain/entities/procurement_entities.dart';

class ProcurementRepository extends ChangeNotifier {
  final List<MaterialOrderEntity> orders = [];
  final List<MarketplaceListingEntity> marketplace = [];
  final List<QuotationEntity> quotations = [];
  final List<TenderEntity> tenders = [];

  void addOrder(MaterialOrderEntity o) {
    orders.add(o);
    notifyListeners();
  }

  void updateOrderProgress(String id, int progress) {
    final i = orders.indexWhere((e) => e.id == id);
    if (i == -1) return;
    final o = orders[i];
    orders[i] = MaterialOrderEntity(
      id: o.id, projectId: o.projectId,
      materialNameAr: o.materialNameAr, materialNameEn: o.materialNameEn,
      quantity: o.quantity, unit: o.unit,
      status: o.status, progressPercent: progress,
    );
    notifyListeners();
  }

  void addQuotation(QuotationEntity q) {
    quotations.add(q);
    notifyListeners();
  }
}
