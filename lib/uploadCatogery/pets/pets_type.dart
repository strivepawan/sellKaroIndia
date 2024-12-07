import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file
import '../../components/button_special.dart';
import '../generalForm/gen_form.dart';

class PetsFromType extends StatefulWidget {
  const PetsFromType({super.key});

  @override
  State<PetsFromType> createState() => _PetsFromTypeState();
}

class _PetsFromTypeState extends State<PetsFromType> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.petsAdd), // Localized title
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
                    whichType: localization.fishesAndAquarium,
                    docName: 'Pets',
                  ),
                ),
              );
            },
            text: localization.fishesAndAquarium, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.petsFood,
                    docName: 'Pets',
                  ),
                ),
              );
            },
            text: localization.petsFood, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.dogs,
                    docName: 'Pets',
                  ),
                ),
              );
            },
            text: localization.dogs, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.otherPets,
                    docName: 'Pets',
                  ),
                ),
              );
            },
            text: localization.otherPets, // Localized button text
          ),
        ],
      ),
    );
  }
}
