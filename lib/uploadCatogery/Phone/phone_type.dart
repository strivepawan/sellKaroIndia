import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file
import 'package:sell_karo_india/uploadCatogery/generalForm/gen_form.dart';
import '../../components/button_special.dart';
import 'laptop.dart';
import 'phone.dart';
import 'tablate.dart';

class PhoneType extends StatelessWidget {
  const PhoneType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.phone), // Localized title
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
                  builder: (context) => MobilesForm(
                    nextStep: (String collectionId, String documentId) {
                      // Do something after form submission if needed
                    },
                  ),
                ),
              );
            },
            text: localization.phone, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LaptopForm(
                    nextStep: (String collectionId, String documentId) {
                      // Do something after form submission if needed
                    },
                  ),
                ),
              );
            },
            text: localization.laptop, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TabletsForm(
                    nextStep: (String collectionId, String documentId) {
                      // Do something after form submission if needed
                    },
                  ),
                ),
              );
            },
            text: localization.tablet, // Localized button text
          ),
          ButtonSpecial(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenForm(
                    whichType: 'Other Smart device',
                    docName: 'Device',
                  ),
                ),
              );
            },
            text: localization.otherSmartDevice, // Localized button text
          ),
        ],
      ),
    );
  }
}
