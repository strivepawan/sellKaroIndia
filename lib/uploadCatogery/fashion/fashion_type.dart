import 'package:flutter/material.dart';
import 'package:sell_karo_india/uploadCatogery/generalForm/gen_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file

import '../../components/button_special.dart';

class FashionType extends StatefulWidget {
  const FashionType({super.key});

  @override
  State<FashionType> createState() => _FashionTypeState();
}

class _FashionTypeState extends State<FashionType> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.fashion), // Localized title
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
                    whichType: localization.men,
                    docName: 'Fashion',
                  ),
                ),
              );
            },
            text: localization.men, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.women,
                    docName: 'Fashion',
                  ),
                ),
              );
            },
            text: localization.women, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.kids,
                    docName: 'Fashion',
                  ),
                ),
              );
            },
            text: localization.kids, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: localization.other,
                    docName: 'Fashion',
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
