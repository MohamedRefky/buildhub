// Clean Architecture: Procurement feature — Domain entities.
// Ports: MaterialOrder.kt, OpenMarketModels.kt, Models.kt (submittal/permit/order parts),
// SupplierMaterialEntity (market side).
export 'package:buildhub/features/home/domain/entities/home_entities.dart'
    show SubmittalDiscipline, SubmittalStatus, PermitAuthority;

enum OrderStatus { draft, submitted, approved, inTransit, delivered, cancelled }
enum MarketplaceCategory { materials, equipment, manpower, services }

class MaterialOrderEntity {
  final String id;
  final String projectId;
  final String materialNameAr;
  final String materialNameEn;
  final double quantity;
  final String unit;
  final OrderStatus status;
  final int progressPercent;
  const MaterialOrderEntity({
    required this.id, required this.projectId,
    required this.materialNameAr, required this.materialNameEn,
    required this.quantity, this.unit = 'unit',
    this.status = OrderStatus.draft, this.progressPercent = 0,
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
  const QuotationEntity({
    required this.id, required this.supplierId,
    required this.totalAed, required this.deliveryDays, this.notes = '',
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
