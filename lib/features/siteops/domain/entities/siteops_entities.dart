// Clean Architecture: SiteOps feature — Domain entities.
// Ports: DailySiteLog.kt, GCCAuthorityModel parts, GEO/attendance,
// WeatherBrain, WorkerWelfare, ESG, GreenWallet, market-intel, risk models.
class GeoAttendanceRecord {
  final String id;
  final String userId;
  final double lat;
  final double lng;
  final String timestamp;
  final bool insideGeofence;
  const GeoAttendanceRecord({
    required this.id, required this.userId, required this.lat,
    required this.lng, required this.timestamp,
    this.insideGeofence = true,
  });
}

class WeatherSnapshot {
  final double tempC;
  final int humidity;
  final double windMs;
  final String adviceAr;
  final String adviceEn;
  const WeatherSnapshot({
    required this.tempC, required this.humidity, required this.windMs,
    this.adviceAr = '', this.adviceEn = '',
  });
}

class RiskItem {
  final String id;
  final String titleAr;
  final String titleEn;
  final int probability; // 1-5
  final int impact; // 1-5
  int get score => probability * impact;
  const RiskItem({
    required this.id, required this.titleAr, required this.titleEn,
    required this.probability, required this.impact,
  });
}

class SitePost {
  final String id;
  final String author;
  final String bodyAr;
  final String bodyEn;
  final int likes;
  const SitePost({
    required this.id, required this.author,
    required this.bodyAr, required this.bodyEn, this.likes = 0,
  });
}

class EsgMetric {
  final String id;
  final String titleAr;
  final String titleEn;
  final double value;
  final String unit;
  const EsgMetric({
    required this.id, required this.titleAr, required this.titleEn,
    required this.value, required this.unit,
  });
}
