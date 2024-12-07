// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sell_karo_india/uploadCatogery/pets/pets_type.dart';

// import '../components/my_icon.dart';
// import '../uploadCatogery/Phone/phone_type.dart';
// import '../uploadCatogery/Vehicle/vichicles_type.dart';
// import '../uploadCatogery/books/books_form.dart';
// import '../uploadCatogery/electronicAndAppliences/Electronic_and_types.dart';
// import '../uploadCatogery/fashion/fashion_type.dart';
// import '../uploadCatogery/furniture/furniture_type.dart';
// import '../uploadCatogery/gym_sports/gym_sports_type.dart';
// import '../uploadCatogery/propertiesFrom/property_type.dart';
// import '../uploadCatogery/services/service_type.dart';
// import '../uploadCatogery/spare_parts/spareParts_type.dart';
// import '../uploadCatogery/vacancies/vacancies_type.dart';

// class AddPost extends StatefulWidget {
//   const AddPost({super.key});

//   @override
//   State<AddPost> createState() => _AddPostState();
// }

// class _AddPostState extends State<AddPost> {
//   void _showCategoryDialog(Widget dialogContent) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Choose'),
//               Divider(
//                 color: Colors.green,
//                 thickness: 4.0,
//               ),
//             ],
//           ),
//           content: dialogContent,
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Post Your Ad'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Text(
//                 'What are you Selling?',
//                 style: GoogleFonts.nunito(
//                   textStyle: const TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Choose a category to continue',
//                 style: GoogleFonts.nunito(
//                   textStyle: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.all(1.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const VehicleType()),
//                             row2Text: 'Vehicle\n',
//                             iconData: FontAwesomeIcons.car,
//                           ),
//                         ),
//                         const SizedBox(width: 4,),
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const PropetyType()),
//                             row2Text: 'Properties\n',
//                             iconData: FontAwesomeIcons.house,
//                           ),
//                         ),
//                         const SizedBox(width: 4,),
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const PhoneType()),
//                             iconData: FontAwesomeIcons.mobileScreen,
//                             row2Text: 'Phones & \n Gadgets',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const ElectroicAndAppliences()),
//                             row2Text: 'Electronic &\n Appliances',
//                             iconData: FontAwesomeIcons.desktop,
//                           ),
//                         ),
//                         const SizedBox(width: 4,),
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const SparePartstype()),
//                             row2Text: 'Spare Parts\n',
//                             iconData: FontAwesomeIcons.gear,
//                           ),
//                         ),
//                         const SizedBox(width: 4,),
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const VacanciesType()),
//                             row2Text: 'Vacancies\n',
//                             iconData: FontAwesomeIcons.user,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const FurnitureSell()),
//                             row2Text: 'Furnitures\n',
//                             iconData: FontAwesomeIcons.chair,
//                           ),
//                         ),
//                         const SizedBox(width: 4,),
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const PetsFromType()),
//                             iconData: FontAwesomeIcons.dog,
//                             row2Text: 'Pets\n',
//                           ),
//                         ),
//                         const SizedBox(width: 4,),
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const FashionType()),
//                             row2Text: 'Fashion &\n Clothings',
//                             iconData: FontAwesomeIcons.shirt,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const GymSports()),
//                             row2Text: 'Sports &\n Gyms',
//                             iconData: FontAwesomeIcons.dumbbell,
//                           ),
//                         ),
//                         const SizedBox(width: 4,),
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const BooksFrom()),
//                             row2Text: 'Books &\nstationary',
//                             iconData: FontAwesomeIcons.book,
//                           ),
//                         ),
//                         const SizedBox(width: 4,),
//                         Expanded(
//                           child: MyIcon(
//                             onTap: () => _showCategoryDialog(const ServiceType()),
//                             row2Text: 'Services\n',
//                             iconData: FontAwesomeIcons.headset,
//                           ),
//                         ),
                       
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


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
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization file

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
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.choose),
              Divider(
                color: Colors.green,
                thickness: 4.0,
              ),
            ],
          ),
          content: dialogContent,
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
      appBar: AppBar(
        title: Text(localization.postYourAd),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                localization.whatAreYouSelling,
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                localization.chooseCategoryToContinue,
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const VehicleType()),
                            row2Text: localization.vehicle,
                            iconData: FontAwesomeIcons.car,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const PropetyType()),
                            row2Text: localization.properties,
                            iconData: FontAwesomeIcons.house,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const PhoneType()),
                            iconData: FontAwesomeIcons.mobileScreen,
                            row2Text: localization.phonesAndGadgets,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const ElectroicAndAppliences()),
                            row2Text: localization.electronicAndAppliances,
                            iconData: FontAwesomeIcons.desktop,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const SparePartstype()),
                            row2Text: localization.spareParts,
                            iconData: FontAwesomeIcons.gear,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const VacanciesType()),
                            row2Text: localization.vacancies,
                            iconData: FontAwesomeIcons.user,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const FurnitureSell()),
                            row2Text: localization.furnitures,
                            iconData: FontAwesomeIcons.chair,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const PetsFromType()),
                            iconData: FontAwesomeIcons.dog,
                            row2Text: localization.pets,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const FashionType()),
                            row2Text: localization.fashionAndClothings,
                            iconData: FontAwesomeIcons.shirt,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const GymSports()),
                            row2Text: localization.sportsAndGyms,
                            iconData: FontAwesomeIcons.dumbbell,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const BooksFrom()),
                            row2Text: localization.booksAndStationary,
                            iconData: FontAwesomeIcons.book,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: MyIcon(
                            onTap: () => _showCategoryDialog(const ServiceType()),
                            row2Text: localization.services,
                            iconData: FontAwesomeIcons.headset,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
