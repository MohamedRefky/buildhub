// Clean Architecture: Finance — Data repository.
// Ports: EnterpriseReportingRepository (finance) + BuildHubRepository claims parts.
import 'package:flutter/material.dart';
import '../domain/entities/finance_entities.dart';

class FinanceRepository extends ChangeNotifier {
  final List<FinanceClaimEntity> claims = [];
  final List<PettyCashWalletEntity> wallets = [];

  void addClaim(FinanceClaimEntity c) {
    claims.add(c);
    notifyListeners();
  }

  void addWallet(PettyCashWalletEntity w) {
    wallets.add(w);
    notifyListeners();
  }
}
