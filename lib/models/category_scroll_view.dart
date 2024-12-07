import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../productview/Fashion_cloths/fashion_view.dart';
import '../productview/Furniture/furniture.dart';
import '../productview/books_stationary.dart/books_stationary.dart';
import '../productview/electronic_appliences/electronoc_screen.dart';
import '../productview/houseView/HouseView.dart';
import '../productview/jobView/job_view.dart';
import '../productview/pets/pets.dart';
import '../productview/serviceView/service_view.dart';
import '../productview/smartdevice/smart_device.dart';
import '../productview/spareParts/spare_parts_view.dart';
import '../productview/sportsAndGyms/sports_gyms.dart';
import '../productview/vechile/vechile_view.dart';

class CategoryScrollView extends StatelessWidget {
  const CategoryScrollView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildCategory(
            context,
            localizations.vehicle,
            FontAwesomeIcons.car,
            const VechilesView(),
          ),
          buildCategory(
            context,
            localizations.properties,
            FontAwesomeIcons.house,
            const PropertiseView(),
          ),
          buildCategory(
            context,
            localizations.phoneGadgets,
            FontAwesomeIcons.mobileScreen,
            const PhoneAdCards(),
          ),
          buildCategory(
            context,
            localizations.electronicAppliances,
            FontAwesomeIcons.desktop,
            const ElectronicAndAppliences(),
          ),
          buildCategory(
            context,
            localizations.spareParts,
            FontAwesomeIcons.gear,
            const SparePartsView(),
          ),
          buildCategory(
            context,
            localizations.jobs,
            FontAwesomeIcons.user,
            const JobViews(),
          ),
          buildCategory(
            context,
            localizations.furniture,
            FontAwesomeIcons.chair,
            const Furniture(),
          ),
          buildCategory(
            context,
            localizations.pets,
            FontAwesomeIcons.dog,
            const Pets(),
          ),
          buildCategory(
            context,
            localizations.fashion,
            FontAwesomeIcons.shirt,
            const Fashion(),
          ),
          buildCategory(
            context,
            localizations.sportsGym,
            FontAwesomeIcons.dumbbell,
            const SportsAndGyms(),
          ),
          buildCategory(
            context,
            localizations.booksStationery,
            FontAwesomeIcons.book,
            const BooksAndStationery(),
          ),
          buildCategory(
            context,
            localizations.services,
            FontAwesomeIcons.headset,
            const ServiceView(),
          ),
        ],
      ),
    );
  }

  Widget buildCategory(
      BuildContext context, String label, IconData icon, Widget targetPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        },
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xffE7F7FF),
                radius: 30.0,
                child: Icon(
                  icon,
                  color: Colors.green,
                  size: 27.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: label.split(' ')[0], // First word or part of the string
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                maxLines: 2,  // Limit text to 2 lines
                overflow: TextOverflow.ellipsis,  // Add ellipsis for overflowing text
              ),

            ],
          ),
        ),
      ),
    );
  }
}