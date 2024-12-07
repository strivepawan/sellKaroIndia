import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_karo_india/productview/sportsAndGyms/sports_gyms.dart';
import '../productview/Fashion_cloths/fashion_view.dart';
import '../productview/Furniture/furniture.dart';
import '../productview/electronic_appliences/electronoc_screen.dart';
import '../productview/houseView/HouseView.dart';
import '../productview/jobView/job_view.dart';
import '../productview/pets/pets.dart';
import '../productview/serviceView/service_view.dart';
import '../productview/smartdevice/smart_device.dart';
import '../productview/spareParts/spare_parts_view.dart';
import '../productview/vechile/vechile_view.dart';

class proDuctComponent extends StatelessWidget {
  const proDuctComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 27,),),
        backgroundColor: Colors.green,
        title: const Text(
          'Product List',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              _buildIconTextComponent(
                context,
                text: "Vehicle\n",
                iconData: FontAwesomeIcons.car,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VechilesView()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Properties\n",
                iconData: FontAwesomeIcons.house,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PropertiseView()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Phone\n& Gadgets",
                iconData: FontAwesomeIcons.mobile,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhoneAdCards()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Electronic\nAppli..",
                iconData: FontAwesomeIcons.desktop,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ElectronicAndAppliences()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Spare Parts",
                iconData: FontAwesomeIcons.gears,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SparePartsView()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Jobs\n",
                iconData: FontAwesomeIcons.headset,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JobViews()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Furniture\n",
                iconData: FontAwesomeIcons.chair,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Furniture()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Pets\n",
                iconData: FontAwesomeIcons.dog,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Pets()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Fashion\n",
                iconData: FontAwesomeIcons.shirt,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Fashion()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Sports\n& GYM",
                iconData: FontAwesomeIcons.dumbbell,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SportsAndGyms()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Books\n& Stati..",
                iconData: FontAwesomeIcons.book,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ElectronicAndAppliences()));
                },
              ),
              _buildIconTextComponent(
                context,
                text: "Service\n",
                iconData: FontAwesomeIcons.user,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServiceView()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconTextComponent(BuildContext context,
      {required String text,
      required IconData iconData,
      required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) /
            3, // Ensuring three items per row
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 4, // Blur radius
              offset: Offset(0, 1), // Offset for the shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      232, 244, 243, 243), // Example background color
                  shape: BoxShape.circle, // Circular shape
                  border: Border.all(
                    color: Colors.white, // Border color
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      iconData,
                      color: const Color(0xFF00BF63), // Icon color
                      size: 32, // Adjust the icon size as needed
                    ),
                  ),
                ),
              ),
            ),
            // Space between icon and text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                textAlign: TextAlign.center, // Center aligning the text
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Example text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
