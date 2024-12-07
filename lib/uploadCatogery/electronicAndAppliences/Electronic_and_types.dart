import 'package:flutter/material.dart';
import 'package:sell_karo_india/uploadCatogery/generalForm/gen_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file

import '../../components/button_special.dart';

class ElectroicAndAppliences extends StatefulWidget {
  const ElectroicAndAppliences({super.key});

  @override
  State<ElectroicAndAppliences> createState() => _ElectroicAndAppliencesState();
}

class _ElectroicAndAppliencesState extends State<ElectroicAndAppliences> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.electronicAndAppliances), // Localized title
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.tvsVideoAudio,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.tvsVideoAudio, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.kitchenAndAppliances,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.kitchenAndAppliances, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.cameraAndLenses,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.cameraAndLenses, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.gameAndEntertainment,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.gameAndEntertainment, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.fridge,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.fridge, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.computerAccessories,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.computerAccessories, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.hardDiskPrinterAndMonitor,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.hardDiskPrinterAndMonitor, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.acs,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.acs, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.washingMachine,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.washingMachine, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenForm(
                      whichType: localization.other,
                      docName: 'ElectronicAndAppliences',
                    ),
                  ),
                );
              },
              text: localization.other, // Localized button text
            ),
          ],
        ),
      ),
    );
  }
}
