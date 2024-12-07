import 'package:flutter/material.dart';
import 'package:sell_karo_india/uploadCatogery/generalForm/gen_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file

import '../../components/button_special.dart';

class FurnitureSell extends StatefulWidget {
  const FurnitureSell({super.key});

  @override
  State<FurnitureSell> createState() => _FurnitureSellState();
}

class _FurnitureSellState extends State<FurnitureSell> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.furnitureAds), // Localized title
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.sofaAndDining,
                    docName: 'Furniture',
                  ),
                ),
              );
            },
            text: localization.sofaAndDining, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.bedsAndWardrobes,
                    docName: 'Furniture',
                  ),
                ),
              );
            },
            text: localization.bedsAndWardrobes, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.homeDecors,
                    docName: 'Furniture',
                  ),
                ),
              );
            },
            text: localization.homeDecors, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.kidsFurniture,
                    docName: 'Furniture',
                  ),
                ),
              );
            },
            text: localization.kidsFurniture, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.otherHouseholdItems,
                    docName: 'Furniture',
                  ),
                ),
              );
            },
            text: localization.otherHouseholdItems, // Localized button text
          ),
        ],
      ),
    );
  }
}
