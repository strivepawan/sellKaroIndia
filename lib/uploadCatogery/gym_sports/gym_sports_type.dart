import 'package:flutter/material.dart';
import 'package:sell_karo_india/uploadCatogery/generalForm/gen_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file

import '../../components/button_special.dart';

class GymSports extends StatefulWidget {
  const GymSports({super.key});

  @override
  State<GymSports> createState() => _GymSportsState();
}

class _GymSportsState extends State<GymSports> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.gymSportsAds), // Localized title
      ),
      body: Column(
        children: [
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.sportsEquipment,
                    docName: 'Sports and GYM',
                  ),
                ),
              );
            },
            text: localization.sportsEquipment, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.gymAndFitness,
                    docName: 'Sports and GYM',
                  ),
                ),
              );
            },
            text: localization.gymAndFitness, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.musicalEquipment,
                    docName: 'Sports and GYM',
                  ),
                ),
              );
            },
            text: localization.musicalEquipment, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.other,
                    docName: 'Sports and GYM',
                  ),
                ),
              );
            },
            text: localization.other, // Localized button text
          ),
        ],
      ),
    );
  }
}
