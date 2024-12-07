import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/date_time.dart';
import '../productview/all_product_details/all_product_details.dart';

class AdData {
  final String imageUrl;
  final String adname;
  final int price;
  final String userAddress;
  final Timestamp timestamp;
  final String category;
  final String docId;
  final String adId;
  final bool isFavorite;

  AdData({
    required this.imageUrl,
    required this.adname,
    required this.price,
    required this.userAddress,
    required this.timestamp,
    required this.category,
    required this.docId,
    required this.adId,
    required this.isFavorite,
  });
}

class LikeScreen extends StatelessWidget {
  Future<void> _removeFromFavorites(String adId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(adId)
          .delete();
    }
  }

  void _viewDetails(BuildContext context, AdData adData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllProductDetailsScreen(
          category: adData.category,
          adId: adData.adId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.myFavorites,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseAuth.instance.currentUser != null
            ? FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('favorites')
            .snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${localizations.error}: ${snapshot.error}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                localizations.noFavorites,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            List<AdData> favoriteAds = snapshot.data!.docs.map((document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return AdData(
                imageUrl: data['imageUrl'],
                adname: data['adname'],
                price: data['price'],
                userAddress: data['userAddress'],
                timestamp: data['timestamp'],
                category: data['category'],
                docId: document.id,
                adId: data['adId'],
                isFavorite: true,
              );
            }).toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteAds.length,
              itemBuilder: (context, index) {
                AdData ad = favoriteAds[index];
                FormattedDate formattedDate = FormattedDate(timestamp: ad.timestamp);
                String displayDate = formattedDate.getFormattedDate();
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: InkWell(
                    onTap: () => _viewDetails(context, ad),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.teal.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                ad.imageUrl,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ad.adname,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    displayDate,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${localizations.rs} ${ad.price}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          CupertinoIcons.heart_fill,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async =>
                                        await _removeFromFavorites(ad.adId),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
