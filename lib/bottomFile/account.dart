import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../userAdds/bosste_ads.dart';
import '../userAdds/expired_ads.dart';
import '../userAdds/recent_ads.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountBottom extends StatefulWidget {
  const AccountBottom({super.key});

  @override
  _AccountBottomState createState() => _AccountBottomState();
}

class _AccountBottomState extends State<AccountBottom>
    with SingleTickerProviderStateMixin {
  User? _user;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getUser();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // User Profile Section
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.green.shade100,
                            backgroundImage: NetworkImage(
                              _user?.photoURL ?? 'https://via.placeholder.com/150',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _user?.displayName ?? 'User Name',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "4.5 Rating",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
          
                  // Contact Information Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "CONTACT INFORMATION",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone,
                                  color: Colors.green, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                _user?.phoneNumber ?? 'User Phone Number',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.email,
                                  color: Colors.green, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                _user?.email ?? 'user@example.com',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 16),
                   TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.green,
                    indicatorWeight: 3,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(text: localizations.recentAds),
                      Tab(text: localizations.boostedAds),
                      Tab(text: localizations.expiredAds),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // TabBarView
                  SizedBox(
                    height: 400, // Set appropriate height
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        RecentAds(
                          userId: _user!.uid,
                          docIds: const [
                            'Books',
                            'Device',
                            'ElectronicAndAppliences',
                            'Fashion',
                            'Furniture',
                            'Pets',
                            'Property',
                            'Service',
                            'SpareParts',
                            'Sports and GYM',
                            'Vacancies',
                            'Vehicle'
                          ],
                        ),
                        BoostedAds(userId: _user!.uid),
                        ExpiredAds(userId: _user!.uid),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
