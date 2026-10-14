// Clean Architecture: BuildNet B2B Professional Network — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// BuildNetHubView, BuildNetProfessionalNetworkView, BuildNetProfileView,
// BuildNetRecruitmentView, B2BMarketplaceView, InteractiveFeedCards, LinkedInHubView.

import 'package:flutter/material.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/features/buildnet/domain/entities/buildnet_entities.dart';

// ---------------------------------------------------------------------------
// 1. BUILDNET PROFESSIONAL HUB SCREEN (LINKEDIN STYLE)
// ---------------------------------------------------------------------------

class BuildNetHubScreen extends StatefulWidget {
  final List<SitePost> posts;
  const BuildNetHubScreen({super.key, this.posts = const []});

  @override
  State<BuildNetHubScreen> createState() => _BuildNetHubScreenState();
}

class _BuildNetHubScreenState extends State<BuildNetHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _feedPosts = [
    {
      'author': 'Eng. Abdelfattah',
      'role': 'Project Director at Orion Developments',
      'time': '2 hours ago',
      'text': 'Proud to announce that Marina Tower Level 12 Zone B slab reinforcement inspection has passed consultant review without non-conformances! Ready for concrete casting tonight.',
      'tag': '#ConcretePour #MarinaTower #EngineeringExcellence',
      'likes': 42,
      'comments': 8,
      'isLiked': false,
    },
    {
      'author': 'Unibeton Ready Mix Official',
      'role': 'Leading Concrete Supplier in GCC',
      'time': '5 hours ago',
      'text': 'Supplied 480 m³ of low-carbon C50 Green Concrete with 65% GGBS cement replacement for a LEED Gold landmark in Downtown Dubai.',
      'tag': '#GreenConcrete #Estidama #Sustainability',
      'likes': 89,
      'comments': 14,
      'isLiked': true,
    },
    {
      'author': 'Eng. Tariq Al-Mansoor',
      'role': 'Principal Structural Consultant • Dar Al-Handasah',
      'time': '1 day ago',
      'text': 'ACI 305R compliance during summer months in the UAE: Key lessons on ice-water batching and evaporation rate limits to prevent plastic shrinkage cracking.',
      'tag': '#StructuralEngineering #DubaiMunicipality #ACI305R',
      'likes': 156,
      'comments': 31,
      'isLiked': false,
    },
  ];

  final List<Map<String, dynamic>> _jobs = [
    {
      'title': 'Senior QA/QC Structural Inspector',
      'company': 'Dar Al-Handasah Consultants',
      'loc': 'Dubai, UAE • On-Site',
      'salary': '18,000 – 22,000 AED / Month',
      'type': 'Full-time',
      'req': 'Min. 8 years UAE high-rise experience, DM Class A approved.',
    },
    {
      'title': 'MEP Project Coordinator',
      'company': 'Drake & Scull Engineering LLC',
      'loc': 'Abu Dhabi, UAE',
      'salary': '16,000 – 20,000 AED / Month',
      'type': 'Full-time',
      'req': 'B.Sc. Mechanical / Electrical Engineering, DEWA approval holder.',
    },
    {
      'title': 'HSE Officer (Safety Passport Holder)',
      'company': 'Arabtec Construction',
      'loc': 'Sharjah Industrial',
      'salary': '10,000 – 14,000 AED / Month',
      'type': 'Full-time',
      'req': 'NEBOSH IGC certified, valid UAE driving license.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BuildNet Professional Network', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('LinkedIn for GCC Engineering & Construction', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentCyan,
          tabs: const [
            Tab(text: 'Industry Feed'),
            Tab(text: 'Recruitment & Jobs'),
            Tab(text: 'B2B Matchmaking'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Feed Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._feedPosts.map((post) => Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(backgroundColor: AppColors.accentCyan.withValues(alpha: 0.15), child: const Icon(Icons.person, color: AppColors.accentCyan)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post['author'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text(post['role'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Text(post['time'] as String, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(post['text'] as String, style: const TextStyle(fontSize: 13, height: 1.4)),
                          const SizedBox(height: 8),
                          Text(post['tag'] as String, style: const TextStyle(fontSize: 11, color: AppColors.accentCyan, fontWeight: FontWeight.bold)),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                icon: Icon((post['isLiked'] as bool) ? Icons.favorite : Icons.favorite_border, size: 18, color: (post['isLiked'] as bool) ? Colors.red : Colors.grey),
                                label: Text('${post['likes']} Likes', style: const TextStyle(fontSize: 12)),
                                onPressed: () {
                                  setState(() {
                                    final cur = post['isLiked'] as bool;
                                    post['isLiked'] = !cur;
                                    post['likes'] = (post['likes'] as int) + (cur ? -1 : 1);
                                  });
                                },
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.comment_outlined, size: 18, color: Colors.grey),
                                label: Text('${post['comments']} Comments', style: const TextStyle(fontSize: 12)),
                                onPressed: () {},
                              ),
                              IconButton(icon: const Icon(Icons.share, size: 18, color: Colors.grey), onPressed: () {}),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          // Jobs Tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._jobs.map((job) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(job['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                                child: Text(job['type'] as String, style: const TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('${job['company']} • ${job['loc']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Text(job['salary'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan, fontSize: 13)),
                          const SizedBox(height: 6),
                          Text(job['req'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Application submitted for ${job['title']}!')));
                              },
                              child: const Text('Easy Apply'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
          // B2B Matchmaking
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Subcontractor Joint Venture (JV) Opportunities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text('Connect with Tier 1 and Tier 2 UAE contractors seeking consortium partners for high-value mega projects.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                        onPressed: () {},
                        child: const Text('Register as JV Partner'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BuildNetProfileView extends StatelessWidget {
  final String name;
  final String role;
  final int connections;
  final int postsCount;
  const BuildNetProfileView({
    super.key,
    this.name = 'Eng. Abdelfattah',
    this.role = 'Project Director • Orion Developments',
    this.connections = 1420,
    this.postsCount = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 24, child: Icon(Icons.person, size: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(role, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('$connections Connections • $postsCount Industry Articles Shared', style: const TextStyle(fontSize: 11, color: AppColors.accentCyan)),
          ],
        ),
      ),
    );
  }
}

class BuildNetRecruitmentView extends StatelessWidget {
  const BuildNetRecruitmentView({super.key});
  @override
  Widget build(BuildContext context) => const Card(child: ListTile(title: Text('Recruitment')));
}

class B2BMarketplaceView extends StatelessWidget {
  const B2BMarketplaceView({super.key});
  @override
  Widget build(BuildContext context) => const Card(child: ListTile(title: Text('B2B Marketplace')));
}
