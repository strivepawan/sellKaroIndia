import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/Text_component.dart';
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
          TextComponent(
            text: localizations.vehicle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VechilesView()),
              );
            },
            iconData: FontAwesomeIcons.car,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.properties,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PropertiseView()),
              );
            },
            iconData: FontAwesomeIcons.house,
          ),
          const SizedBox(width: 16),
          TextComponent(
            text: localizations.phoneGadgets,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PhoneAdCards()),
              );
            },
            iconData: FontAwesomeIcons.mobileScreen,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.electronicAppliances,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ElectronicAndAppliences()),
              );
            },
            iconData: FontAwesomeIcons.desktop,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.spareParts,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SparePartsView()),
              );
            },
            iconData: FontAwesomeIcons.gear,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.jobs,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JobViews()),
              );
            },
            iconData: FontAwesomeIcons.user,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.furniture,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Furniture()),
              );
            },
            iconData: FontAwesomeIcons.chair,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.pets,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pets()),
              );
            },
            iconData: FontAwesomeIcons.dog,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.fashion,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Fashion()),
              );
            },
            iconData: FontAwesomeIcons.shirt,
          ),
          TextComponent(
            text: localizations.sportsGym,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SportsAndGyms()),
              );
            },
            iconData: FontAwesomeIcons.dumbbell,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.booksStationery,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BooksAndStationery()),
              );
            },
            iconData: FontAwesomeIcons.book,
          ),
          const SizedBox(width: 8),
          TextComponent(
            text: localizations.services,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServiceView()),
              );
            },
            iconData: FontAwesomeIcons.headset,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
