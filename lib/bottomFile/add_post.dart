import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_karo_india/uploadCatogery/pets/pets_type.dart';

import '../components/my_icon.dart';
import '../uploadCatogery/Phone/phone_type.dart';
import '../uploadCatogery/Vehicle/vichicles_type.dart';
import '../uploadCatogery/books/books_form.dart';
import '../uploadCatogery/electronicAndAppliences/Electronic_and_types.dart';
import '../uploadCatogery/fashion/fashion_type.dart';
import '../uploadCatogery/furniture/furniture_type.dart';
import '../uploadCatogery/gym_sports/gym_sports_type.dart';
import '../uploadCatogery/propertiesFrom/property_type.dart';
import '../uploadCatogery/services/service_type.dart';
import '../uploadCatogery/spare_parts/spareParts_type.dart';
import '../uploadCatogery/vacancies/vacancies_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  void _showCategoryDialog(Widget dialogContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.zero,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.choose,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Divider(
                color: Colors.green,
                thickness: 2.0,
              ),
            ],
          ),
          content: Container(
            width: 350, // Custom width for the dialog
            padding: const EdgeInsets.all(12.0),
            child: dialogContent,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.whatAreYouSelling,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.chooseCategoryToContinue,
                    style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: .7, // Adjust aspect ratio for better visuals
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      // Dynamic category icons and names
                      List<Widget> categoryWidgets = [
                        MyIcon(
                          onTap: () => _showCategoryDialog(const VehicleType()),
                          row2Text: localization.vehicle,
                          iconData: FontAwesomeIcons.car,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const PropetyType()),
                          row2Text: localization.properties,
                          iconData: FontAwesomeIcons.house,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const PhoneType()),
                          iconData: FontAwesomeIcons.mobileScreen,
                          row2Text: localization.phonesAndGadgets,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const ElectroicAndAppliences()),
                          row2Text: localization.electronicAndAppliances,
                          iconData: FontAwesomeIcons.desktop,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const SparePartstype()),
                          row2Text: localization.spareParts,
                          iconData: FontAwesomeIcons.gear,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const VacanciesType()),
                          row2Text: localization.vacancies,
                          iconData: FontAwesomeIcons.user,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const FurnitureSell()),
                          row2Text: localization.furnitures,
                          iconData: FontAwesomeIcons.chair,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const PetsFromType()),
                          iconData: FontAwesomeIcons.dog,
                          row2Text: localization.pets,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const FashionType()),
                          row2Text: localization.fashionAndClothings,
                          iconData: FontAwesomeIcons.shirt,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const GymSports()),
                          row2Text: localization.sportsAndGyms,
                          iconData: FontAwesomeIcons.dumbbell,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const BooksFrom()),
                          row2Text: localization.booksAndStationary,
                          iconData: FontAwesomeIcons.book,
                        ),
                        MyIcon(
                          onTap: () => _showCategoryDialog(const ServiceType()),
                          row2Text: localization.services,
                          iconData: FontAwesomeIcons.headset,
                        ),
                      ];
                      return categoryWidgets[index];
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
