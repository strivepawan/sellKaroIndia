import 'package:flutter/material.dart';

import '../general/electro_product_view.dart';
import '../houseView/property_details.dart';
import '../jobView/job_details.dart';
import '../serviceView/service_details_view.dart';
import '../smartdevice/product_details.dart';
import '../spareParts/spare_parts_details.dart';
import '../vechile/vechile_details.dart';

class AllProductDetailsScreen extends StatelessWidget {
  final String category;
  // final String docId;
  final String adId;

  AllProductDetailsScreen({
    required this.category,
    // required this.docId,
    required this.adId, 
    // required AdData adData,
  });

  @override
  Widget build(BuildContext context) {
    // Switch-case statement to determine which product details screen to navigate to based on the category
    switch (category) {
      case 'Device':
        return ElectronicProductView( adId: adId,catDocid: category);
      case 'ElectronicAndAppliences':
        return ElectroPrdouctView(adId: adId, catDocid: category);
      case 'Fashion':
        // Navigate to ElectroPrdouctView screen if the category is "Fashion"
        return ElectroPrdouctView(adId: adId, catDocid: category);
      case 'Furniture':
        return ElectroPrdouctView(adId: adId, catDocid: category);
      case 'BookS':
        return ElectroPrdouctView(adId: adId, catDocid: category);
      case 'Sports and GYM':
        return ElectroPrdouctView(adId: adId, catDocid: category);
      case 'Pets':
        return ElectroPrdouctView(adId: adId, catDocid: category);
      case 'Vehicle':
        return VichledetailsView(  adId: adId,catDocid: category);
      case 'Property':
        return PropertyDetailsView(adId: adId, catDocid: category);
      case 'SpareParts':
        return SparePartsDetailsView( adId: adId, catDocid: category);
      case 'Service':
        return ServiceDetailsView( adId: adId, catDocid: category);
      case 'Vacancies':
        return JobDetailsPage( adId: adId, catDocid: category);    
      default:
        return const Center(child: Text('No details available for this category'));
    }
  }
}
