// Clean Architecture: BuildNet — Presentation.
// Covers buildnet/: BuildNetHubView, BuildNetProfessionalNetworkView,
// BuildNetProfileView, BuildNetRecruitmentView, B2BMarketplaceView,
// InteractiveFeedCards, LinkedInHubView, BuildNetModels.
// Titles resolve from JSON keys — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/features/buildnet/domain/entities/buildnet_entities.dart';

class BuildNetHubScreen extends StatelessWidget {
  final List<SitePost> posts;
  const BuildNetHubScreen({super.key, this.posts = const []});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('bn.hub'))),
      body: posts.isEmpty
        ? Center(child: Text(loc.t('bn.no_posts')))
        : ListView(children: posts.map((p) => Card(
          child: ListTile(
            title: Text(loc.tr(p.bodyAr, p.bodyEn)),
            subtitle: Text(p.author),
            trailing: Text('♥ ${p.likes}'),
          ))).toList()),
    );
  }
}

class BuildNetRecruitmentView extends StatelessWidget {
  const BuildNetRecruitmentView({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(child: ListTile(
      leading: const Icon(Icons.work),
      title: Text(loc.t('bn.recruitment')),
    ));
  }
}

class B2BMarketplaceView extends StatelessWidget {
  const B2BMarketplaceView({super.key});
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(child: ListTile(
      leading: const Icon(Icons.business),
      title: Text(loc.t('bn.b2b')),
    ));
  }
}

/// Port of BuildNetProfileView.kt: professional profile header.
class BuildNetProfileView extends StatelessWidget {
  final String name;
  final String role;
  final int connections;
  final int postsCount;
  const BuildNetProfileView({
    super.key,
    this.name = '',
    this.role = '',
    this.connections = 0,
    this.postsCount = 0,
  });
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 8),
                Expanded(
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                      Text(name.isEmpty
                          ? loc.t('bn.profile_title')
                          : name),
                      Text(role.isEmpty
                          ? loc.t('bn.profile_role')
                          : role),
                    ])),
              ]),
              const SizedBox(height: 6),
              Text(
                  '$connections ${loc.t('bn.profile_connections')} • '
                  '$postsCount ${loc.t('bn.profile_posts')}'),
            ]),
      ),
    );
  }
}

/// Port of BuildNetProfessionalNetworkView.kt: network directory entry.
class BuildNetProfessionalNetworkView extends StatelessWidget {
  final List<String> members;
  final void Function(String member)? onConnect;
  const BuildNetProfessionalNetworkView({
    super.key,
    this.members = const [],
    this.onConnect,
  });
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.t('bn.network_title'),
                  style: Theme.of(context).textTheme.titleSmall),
              if (members.isEmpty)
                Text(loc.t('bn.network_empty'))
              else
                ...members.map((m) => ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: Text(m),
                      trailing: TextButton(
                          onPressed: () => onConnect?.call(m),
                          child:
                              Text(loc.t('bn.network_connect'))),
                    )),
            ]),
      ),
    );
  }
}

/// Port of LinkedInHubView.kt: cross-post composer to LinkedIn.
class LinkedInHubView extends StatefulWidget {
  final void Function(String text)? onPost;
  const LinkedInHubView({super.key, this.onPost});
  @override
  State<LinkedInHubView> createState() => _LinkedInHubViewState();
}

class _LinkedInHubViewState extends State<LinkedInHubView> {
  final _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.t('bn.linkedin_title'),
                  style: Theme.of(context).textTheme.titleSmall),
              TextField(
                  controller: _ctrl,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                      hintText: loc.t('bn.linkedin_hint'))),
              const SizedBox(height: 6),
              ElevatedButton(
                  onPressed: () {
                    if (_ctrl.text.trim().isEmpty) return;
                    widget.onPost?.call(_ctrl.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                loc.t('bn.linkedin_posted'))));
                    _ctrl.clear();
                  },
                  child: Text(loc.t('bn.linkedin_post'))),
            ]),
      ),
    );
  }
}
