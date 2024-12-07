import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization file
import '../../components/button_special.dart';
import '../generalForm/gen_form.dart';
import 'from_service.dart';

class ServiceType extends StatefulWidget {
  const ServiceType({super.key});

  @override
  State<ServiceType> createState() => _ServiceTypeState();
}

class _ServiceTypeState extends State<ServiceType> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.services), // Localized title
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceForm(
                      whichType: localization.educationAndClasses,
                      serviceTypes: [
                        localization.tuition,
                        localization.hobbyClasses,
                        localization.skillDevelopment,
                        localization.other
                      ],
                    ),
                  ),
                );
              },
              text: localization.educationAndClasses, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceForm(
                      whichType: localization.tourAndTravel,
                      serviceTypes: [
                        localization.taxiServices,
                        localization.driverServices,
                        localization.travelAgent,
                        localization.hotel,
                        localization.homestays,
                        localization.other
                      ],
                    ),
                  ),
                );
              },
              text: localization.tourAndTravel, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceForm(
                      whichType: localization.electronicRepairAndServices,
                      serviceTypes: [
                        localization.ac,
                        localization.homeAppliances,
                        localization.tvVideoAudio,
                        localization.computerAndLaptop,
                        localization.roWaterPurifier,
                        localization.other
                      ],
                    ),
                  ),
                );
              },
              text: localization.electronicRepairAndServices, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceForm(
                      whichType: localization.healthAndBeauty,
                      serviceTypes: [
                        localization.fitnessAndWellness,
                        localization.salonsServices,
                        localization.healthAndSafety,
                        localization.other
                      ],
                    ),
                  ),
                );
              },
              text: localization.healthAndBeauty, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceForm(
                      whichType: localization.homeRenovationAndRepair,
                      serviceTypes: [
                        localization.builderAndContractor,
                        localization.plumber,
                        localization.electrician,
                        localization.carpenter,
                        localization.painter,
                        localization.other
                      ],
                    ),
                  ),
                );
              },
              text: localization.homeRenovationAndRepair, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceForm(
                      whichType: localization.cleaningAndPestControl,
                      serviceTypes: [
                        localization.homeCleaning,
                        localization.pestControl,
                        localization.carCleaning,
                        localization.other
                      ],
                    ),
                  ),
                );
              },
              text: localization.cleaningAndPestControl, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceForm(
                      whichType: localization.legalAndDocumentationServices,
                      serviceTypes: [
                        localization.rtoRelated,
                        localization.kycRelated,
                        localization.notaryServices,
                        localization.other
                      ],
                    ),
                  ),
                );
              },
              text: localization.legalAndDocumentationServices, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenForm(
                      whichType: 'Packers & Movies',
                      docName: 'Service',
                    ),
                  ),
                );
              },
              text: localization.packersAndMovers, // Localized text
            ),
            ButtonSpecial(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenForm(
                      whichType: 'Other Services',
                      docName: 'Service',
                    ),
                  ),
                );
              },
              text: localization.otherServices, // Localized text
            ),
          ],
        ),
      ),
    );
  }
}
