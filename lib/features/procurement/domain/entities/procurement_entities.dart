// Clean Architecture: Procurement feature — Domain entities.
// Ports: MaterialOrder.kt, OpenMarketModels.kt, Models.kt (submittal/permit/order parts),
// SupplierMaterialEntity (market side).
export 'package:buildhub/features/home/domain/entities/home_entities.dart'
    show SubmittalDiscipline, SubmittalStatus, PermitAuthority;

enum OrderStatus { draft, submitted, approved, inTransit, outForDelivery, delivered, delayed, cancelled }
enum MarketplaceCategory { materials, equipment, manpower, services }

class MaterialOrderEntity {
  final String id;
  final String poNumber;
  final String projectId;
  final String materialNameAr;
  final String materialNameEn;
  final double quantity;
  final String unit;
  final OrderStatus status;
  final int progressPercent;
  final String supplierName;
  final String expectedDeliveryDate;
  final double subtotalAed;
  final double vatAed;
  final double grandTotalAed;
  final bool escrowLocked;
  const MaterialOrderEntity({
    required this.id, this.poNumber = '', required this.projectId,
    required this.materialNameAr, required this.materialNameEn,
    required this.quantity, this.unit = 'unit',
    this.status = OrderStatus.draft, this.progressPercent = 0,
    this.supplierName = '', this.expectedDeliveryDate = '',
    this.subtotalAed = 0, this.vatAed = 0, this.grandTotalAed = 0,
    this.escrowLocked = false,
  });
}

class MarketplaceListingEntity {
  final String id;
  final String titleAr;
  final String titleEn;
  final MarketplaceCategory category;
  final double priceAed;
  final String supplierId;
  final bool isVerifiedSupplier;
  const MarketplaceListingEntity({
    required this.id, required this.titleAr, required this.titleEn,
    required this.category, required this.priceAed,
    required this.supplierId, this.isVerifiedSupplier = false,
  });
}

class QuotationEntity {
  final String id;
  final String supplierId;
  final double totalAed;
  final int deliveryDays;
  final String notes;
  final double subtotalAed;
  final double vatAed;
  final double grandTotalAed;
  const QuotationEntity({
    required this.id, required this.supplierId,
    required this.totalAed, required this.deliveryDays, this.notes = '',
    this.subtotalAed = 0, this.vatAed = 0, this.grandTotalAed = 0,
  });
}

class TenderEntity {
  final String id;
  final String titleAr;
  final String titleEn;
  final String authority;
  final String deadline;
  final double estValueAed;
  const TenderEntity({
    required this.id, required this.titleAr, required this.titleEn,
    required this.authority, required this.deadline, required this.estValueAed,
  });
}

class BoqItem {
  final String itemCode;
  final String descriptionAr;
  final String descriptionEn;
  final String unit;
  final double quantity;
  final double unitRateAed;
  final double totalAed;
  final String linkedProcurementId;
  const BoqItem({
    required this.itemCode, required this.descriptionAr,
    required this.descriptionEn, required this.unit,
    required this.quantity, required this.unitRateAed,
    required this.totalAed, this.linkedProcurementId = '',
  });
}

class TenderBidPackage {
  final String packageId;
  final String titleAr;
  final String titleEn;
  final String scope;
  final double budgetAed;
  final String submissionDeadline;
  final String status;
  const TenderBidPackage({
    required this.packageId, required this.titleAr, required this.titleEn,
    required this.scope, required this.budgetAed,
    required this.submissionDeadline, this.status = 'OPEN',
  });
}
