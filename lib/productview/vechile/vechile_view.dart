import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_karo_india/models/price_fromat_output.dart';

import '../../models/date_time_helper.dart';
import 'vechile_details.dart';

class VechilesView extends StatefulWidget {
  const VechilesView({super.key});

  @override
  State<VechilesView> createState() => _ElectronicAndAppliencesState();
}

class _ElectronicAndAppliencesState extends State<VechilesView> {
  late List<AdData> adsData = []; // Declare adsData outside the build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vechiles'),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: fetchAdsDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<AdData> adsData = snapshot.data!.docs.map((DocumentSnapshot document) {
                      String id = document.id;
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      List<String> images = data['images'] != null ? List.from(data['images']) : [];
                      String imageUrl = images.isNotEmpty ? images[0] : '';
                      String title = data['ad_name'] ?? '';
                      dynamic priceValue = data['price'];
                      int price = priceValue is int ? priceValue : int.tryParse(priceValue ?? '') ?? 0;
                      String userAddress = data['userAddress'] ?? '';
                      Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
        
                      return AdData(
                        id: id ,
                        imageUrl: imageUrl,
                        adname: title,
                        price: price,
                        userAddress: userAddress,
                        timestamp: timestamp,
                                            
                      );
                    }).toList();
        
                    if (adsData.isEmpty) {
                      return const  Center(child: Text('No data available'));
                    }
        
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                       GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.7
                          ),
                          itemCount: adsData.length,
                          itemBuilder: (context, index) {
                            AdData adData = adsData[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VichledetailsView( adId: adsData[index].id, catDocid: 'Vehicle',
                                     
                                     
                                    ),
                                  ),
                                );
                              },
                              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFEBEEF7),
                width: 1.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 176, 176, 176),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius:const  BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                          child: Image.network(
                            adData.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        adData.formattedPrice,
                          style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                           fontWeight: FontWeight.bold,
                            fontSize: 16,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    adData.adname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(textStyle:  const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),)
                  ),
                ),
                const Divider( height: 2,
                color:Color(0xFFEBEEF7) ,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF767E94), size: 14),
                    Expanded(
                      child: Text(
                        adData.userAddress.length > 8
                            ? '${adData.userAddress.substring(0, 8)}..'
                            : adData.userAddress,
                        style:const  TextStyle(
                          color: Color(0xFF767E94),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      DateTimeHelper.formatTimestamp(adData.timestamp),
                      style:const  TextStyle(
                        fontSize: 12,
                        color: Color(0xFF767E94),
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
                            );
                          },
                        ),
        
                    );
                  }
                },
              ),
          ],
        ),
      ) ,
    );
  }

  Stream<QuerySnapshot> fetchAdsDataStream() {
  try {
    // Directly specify the category name
    CollectionReference adsCollectionReference =
        FirebaseFirestore.instance.collection('category').doc('Vehicle').collection('ads');

    Stream<QuerySnapshot> categoryStream = adsCollectionReference.orderBy('timestamp', descending: true).snapshots();

    return categoryStream;
  } catch (error) {
    print('Error fetching ads data: $error');
    throw error;
  }
}

}

class AdData {
   final String id;
  final String imageUrl;
  final String adname;
  final int price;
  final String userAddress;
  final Timestamp timestamp;

  AdData({
    required this.id,
    required this.imageUrl,
    required this.adname,
    required this.price,
    required this.userAddress,
    required this.timestamp,
  });
   String get formattedPrice => PriceFormatter.formatPrice(price);
}