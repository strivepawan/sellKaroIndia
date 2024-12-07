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

class _AccountBottomState extends State<AccountBottom> {
  User? _user;
  Widget? _selectedContent;

  @override
  void initState() {
    super.initState();
    _getUser();
    _selectedContent = RecentAds(userId: _user!.uid, docIds: const ['Books','Device','ElectronicAndAppliences','Fashion','Furniture','Pets','Property','SpareParts','Sports and GYM','Vacancies','Vehicle','Service'],); // Initial content
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

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.yourAds),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User profile information (existing code)

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFDADDE5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedContent = RecentAds(userId: _user!.uid, docIds: const ['Books','Device','ElectronicAndAppliences','Fashion','Furniture','Pets','Property','Service','SpareParts','Sports and GYM','Vacancies','Vehicle'],);
                          });
                        },
                        child: Text(localizations.recentAds),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedContent = BoostedAds(userId: _user!.uid);
                          });
                        },
                        child: Text(localizations.boostedAds),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedContent = ExpiredAds(userId: _user!.uid);
                          });
                        },
                        child: Text(localizations.expiredAds),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Other widgets and profile information
            if (_selectedContent != null) _selectedContent!,
          ],
        ),
      ),
    );
  }
}
