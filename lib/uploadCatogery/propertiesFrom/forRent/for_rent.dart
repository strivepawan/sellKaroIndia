import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization file
import '../../../components/button_special.dart';
import '../../generalForm/gen_form.dart';
import 'farmhouse.dart';
import 'flat_apart_builder.dart';
import 'land_plot.dart';
import 'property_fram.dart';
import 'shop_office_showroom.dart';

class ForRentProperty extends StatefulWidget {
  const ForRentProperty({super.key});

  @override
  State<ForRentProperty> createState() => _ForRentPropertyState();
}

class _ForRentPropertyState extends State<ForRentProperty> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.propertiesAdd), // Localized title
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PropertyForm()),
                );
              },
              text: localization.houseKothiVilla, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FlatApartBuilder()),
                );
              },
              text: localization.flatApartmentBuilder, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShoopOfficeShowroom()),
                );
              },
              text: localization.shopOfficeShowroom, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LandPlotFrom()),
                );
              },
              text: localization.landPlot, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FarmHouse()),
                );
              },
              text: localization.farmhouse, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenForm(whichType: 'Others ads', docName: 'Property')),
                );
              },
              text: localization.other, // Localized text
            ),
          ],
        ),
      ),
    );
  }
}
