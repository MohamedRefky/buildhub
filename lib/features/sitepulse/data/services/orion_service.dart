// Clean Architecture: SitePulse — Data service (tactical ORION B CORE).
// Ports: OrionAiService.kt — deterministic telemetry assessment.
// Thresholds mirror the reference: temp>54 alert, grid<92 degraded,
// temp>=60 or grid<85 critical. No LLM involved (offline-capable).
import '../../domain/entities/telemetry_entities.dart';

class OrionAiService {
  const OrionAiService();

  OrionAiAssessment analyzeTelemetryAndSuggestDirectives(
    OrionTelemetryPacket packet,
    List<FleetAsset> fleet,
  ) {
    final temp = packet.coreTemperature;
    final grid = packet.powerGridEfficiency;
    final now = DateTime.now().toIso8601String();

    if (temp >= 60 || grid < 85) {
      return OrionAiAssessment(
        status: 'CRITICAL', defconLevel: 1, confidence: 0.93,
        tacticalSummaryAr:
            'حرارة حرجة ($temp°) أو شبكة منهارة ($grid%) — تفعيل تبريد الطوارئ وإيقاف الأحمال غير الحرجة.',
        tacticalSummaryEn:
            'Critical temperature ($temp°) or collapsing grid ($grid%) — engage emergency cooling and shed non-critical loads.',
        recommendedDirective: const OrionDirective(
          code: 'OB-909', titleAr: 'تبريد طارئ وإسقاط أحمال',
          titleEn: 'Emergency cooling & load shed',
          priority: 'P0', assignee: 'Site Command', phase: 'Immediate',
        ),
        timestamp: now,
      );
    }
    if (temp > 54 || grid < 92) {
      return OrionAiAssessment(
        status: 'WATCH', defconLevel: 2, confidence: 0.87,
        tacticalSummaryAr:
            'حرارة مرتفعة ($temp°) أو تدهور الشبكة ($grid%) — فحص دورة التبريد ومراجعة الأحمال خلال الوردية.',
        tacticalSummaryEn:
            'Elevated temperature ($temp°) or degraded grid ($grid%) — inspect cooling cycle and review loads this shift.',
        recommendedDirective: const OrionDirective(
          code: 'OB-204', titleAr: 'فحص الشبكة والتبريد',
          titleEn: 'Grid & cooling inspection',
          priority: 'P1', assignee: 'MEP Lead', phase: 'This shift',
        ),
        timestamp: now,
      );
    }
    return OrionAiAssessment(
      status: 'STABLE', defconLevel: 3, confidence: 0.96,
      tacticalSummaryAr:
          'كل القياسات ضمن الحدود (${fleet.length} أصول مراقبة) — استمرار المراقبة الروتينية.',
      tacticalSummaryEn:
          'All readings nominal (${fleet.length} assets monitored) — continue routine watch.',
      recommendedDirective: const OrionDirective(
        code: 'OB-118', titleAr: 'مراقبة روتينية',
        titleEn: 'Routine watch', priority: 'P2',
        assignee: 'Control Room', phase: 'Ongoing',
      ),
      timestamp: now,
    );
  }
}
