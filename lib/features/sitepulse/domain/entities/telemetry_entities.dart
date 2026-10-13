// Clean Architecture: SitePulse feature — Domain telemetry entities.
// Ports: OrionTelemetryModels.kt (reactor/comms/fleet/AI assessment DTOs).
// Labels are bilingual (labelAr/labelEn) so UI stays JSON-driven.

enum ReactorStatus { nominal, elevated, critical }

enum CommsStatus { locked, degraded, searching }

class OrionTelemetryPacket {
  final double coreTemperature;
  final ReactorStatus reactorStatus;
  final double powerGridEfficiency;
  final double signalToNoiseRatio;
  final CommsStatus commsStatus;
  final double packetThroughput;
  final double chamberPressure;
  final String timestamp;
  const OrionTelemetryPacket({
    required this.coreTemperature,
    required this.reactorStatus,
    required this.powerGridEfficiency,
    required this.signalToNoiseRatio,
    required this.commsStatus,
    required this.packetThroughput,
    required this.chamberPressure,
    this.timestamp = '',
  });
}

class FleetAsset {
  final String id;
  final String callsign;
  final String sector;
  final String status;
  final int batteryPercent;
  const FleetAsset({
    required this.id, required this.callsign,
    required this.sector, required this.status,
    required this.batteryPercent,
  });
}

class OrionDirective {
  final String code;
  final String titleAr;
  final String titleEn;
  final String priority;
  final String assignee;
  final String phase;
  const OrionDirective({
    required this.code, required this.titleAr, required this.titleEn,
    required this.priority, required this.assignee, required this.phase,
  });
}

class OrionAiAssessment {
  final String status;
  final int defconLevel;
  final double confidence;
  final String tacticalSummaryAr;
  final String tacticalSummaryEn;
  final OrionDirective? recommendedDirective;
  final String rawAiResponse;
  final String timestamp;
  const OrionAiAssessment({
    required this.status, required this.defconLevel,
    required this.confidence,
    required this.tacticalSummaryAr, required this.tacticalSummaryEn,
    this.recommendedDirective,
    this.rawAiResponse = '', this.timestamp = '',
  });
}
