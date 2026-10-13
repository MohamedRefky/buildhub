// Clean Architecture: BuildNet feature — Domain entities.
// Ports buildnet/: BuildNetModels, InteractiveFeedCards, LinkedInHubView models.
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
