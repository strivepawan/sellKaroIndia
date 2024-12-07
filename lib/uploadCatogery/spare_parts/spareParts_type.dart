import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization file
import 'package:sell_karo_india/uploadCatogery/generalForm/gen_form.dart';
import '../../components/button_special.dart';


class SparePartstype extends StatefulWidget {
  const SparePartstype({super.key});

  @override
  State<SparePartstype> createState() => _SparePartstypeState();
}

class _SparePartstypeState extends State<SparePartstype> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.sparePartsAdd), // Localized title
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenForm(
                    whichType: 'Spare Parts',
                    docName: 'SpareParts',
                  ),
                ),
              );
            },
            text: localization.spareParts, // Localized text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GenForm(
                    whichType: 'Commercial Vehicles & spare',
                    docName: 'SpareParts',
                  ),
                ),
              );
            },
            text: localization.commercialVehiclesAndSpare, // Localized text
          ),
        ],
      ),
    );
  }
}
