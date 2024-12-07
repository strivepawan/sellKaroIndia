import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file
import '../../components/button_special.dart';
import 'forRent/for_rent.dart';
import 'forSale/for_sale.dart';

class PropetyType extends StatefulWidget {
  const PropetyType({super.key});

  @override
  State<PropetyType> createState() => _PropetyTypeState();
}

class _PropetyTypeState extends State<PropetyType> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.propertiesAdd), // Localized title
      ),
      body: Column(
        children: [
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForSaleProperty()),
              );
            },
            text: localization.forSale, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForRentProperty()),
              );
            },
            text: localization.forRent, // Localized button text
          ),
        ],
      ),
    );
  }
}
