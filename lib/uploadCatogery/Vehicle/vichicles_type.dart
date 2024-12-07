import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file
import 'package:sell_karo_india/uploadCatogery/generalForm/gen_form.dart';
import '../../components/button_special.dart';
import 'bike.dart';
import 'cars.dart';
import 'truck.dart';

class VehicleType extends StatelessWidget {
  const VehicleType({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.vehicleType), // Localized title
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarsForm(
                    nextStep: (String collectionId, String documentId) {},
                  ),
                ),
              );
            },
            text: localization.cars, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BikesForm(
                    nextStep: (String collectionId, String documentId) {},
                  ),
                ),
              );
            },
            text: localization.bikes, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: 'Bicycle',
                    docName: 'Vehicle',
                  ),
                ),
              );
            },
            text: localization.bicycle, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TruckForm(
                    nextStep: (String collectionId, String documentId) {},
                  ),
                ),
              );
            },
            text: localization.busAndTruck, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: 'Vehicle',
                    docName: 'Vehicle',
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
