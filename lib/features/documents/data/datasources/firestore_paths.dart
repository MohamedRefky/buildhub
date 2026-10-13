// Cloud Firestore collection layout — mirrors the reference
// (FirestoreRepository.kt + RecordSyncRepository.kt + auth/storage services).
// Used by sync/account/storage services; no Firebase import needed here.
class FirestorePaths {
  static String projectDoc(String projectId) => 'projects/$projectId';
  static String dailyLog(String projectId, String reportId) =>
      'projects/$projectId/dailyLogs/$reportId';
  static String record(String recordId) => 'records/$recordId';
  static String typedRecord(String projectId, String collection, String id) =>
      'projects/$projectId/$collection/$id';

  /// RFI → rfis, SUBMITTED → submittals, VO → variationOrders, SNAG → snags.
  static String collectionForType(String type) => switch (type) {
        'RFI' => 'rfis',
        'SUBMITTED' => 'submittals',
        'VO' => 'variationOrders',
        'SNAG' => 'snags',
        _ => 'records',
      };

  static String userProfile(String uid) => 'users/$uid';
  static String userFile(String fileId) => 'user_files/$fileId';
  static String userFileOwned(String uid, String fileId) =>
      'users/$uid/files/$fileId';
  static String safetyTicket(String ticketId) => 'safety_tickets/$ticketId';
  static String walkieTalkieLog(String logId) =>
      'walkie_talkie_logs/$logId';
  static String activityEntry(
          String projectId, String activityId, String entryId) =>
      'projects/$projectId/activities/$activityId/entries/$entryId';
  static String autonomousInput(String projectId, String actionId) =>
      'projects/$projectId/autonomous_inputs/$actionId';
  static String agentAction(String projectId, String logId) =>
      'projects/$projectId/ai_agent_actions/$logId';
  static String snagDoc(String snagId) => 'snags/$snagId';
}
