import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the localization file
import '../../components/button_special.dart';
import 'vacancies_.dart';

class VacanciesType extends StatefulWidget {
  const VacanciesType({super.key});

  @override
  State<VacanciesType> createState() => _VacanciesTypeState();
}

class _VacanciesTypeState extends State<VacanciesType> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.vacanciesType), // Localized title
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
                    builder: (context) => JobVacancies(
                      whichType: localization.dataEntryBackOffice,
                    ),
                  ),
                );
              },
              text: localization.dataEntryBackOffice, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.salesMarketing,
                    ),
                  ),
                );
              },
              text: localization.salesMarketing, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.bpoTelecaller,
                    ),
                  ),
                );
              },
              text: localization.bpoTelecaller, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.driver,
                    ),
                  ),
                );
              },
              text: localization.driver, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.officeAssistent,
                    ),
                  ),
                );
              },
              text: localization.officeAssistent, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.deliveryCollection,
                    ),
                  ),
                );
              },
              text: localization.deliveryCollection, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.teacher,
                    ),
                  ),
                );
              },
              text: localization.teacher, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.cook,
                    ),
                  ),
                );
              },
              text: localization.cook, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.receptionistFrontOffice,
                    ),
                  ),
                );
              },
              text: localization.receptionistFrontOffice, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.operationTechnician,
                    ),
                  ),
                );
              },
              text: localization.operationTechnician, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.itEngineerDeveloper,
                    ),
                  ),
                );
              },
              text: localization.itEngineerDeveloper, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.hotelTravelExecutive,
                    ),
                  ),
                );
              },
              text: localization.hotelTravelExecutive, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.accountant,
                    ),
                  ),
                );
              },
              text: localization.accountant, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.designer,
                    ),
                  ),
                );
              },
              text: localization.designer, // Localized button text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobVacancies(
                      whichType: localization.otherJob,
                    ),
                  ),
                );
              },
              text: localization.otherJob, // Localized button text
            ),
          ],
        ),
      ),
    );
  }
}
