import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sell_karo_india/userAdds/edit_data.dart';
import '../BoostPage/BoostPage.dart';
import '../bottomFile/add_post.dart';
import '../models/date_time.dart';
import '../productview/all_product_details/all_product_details.dart';
import '../services/share_service.dart';

class RecentAds extends StatefulWidget {
  final String userId;
  final List<String> docIds;

  RecentAds({required this.userId, required this.docIds});

  @override
  _RecentAdsState createState() => _RecentAdsState();
}

class _RecentAdsState extends State<RecentAds> {
  Map<String, List<DocumentSnapshot>> adsData = {};
  final numberFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
  bool allCategoriesEmpty = true;

  @override
  void initState() {
    super.initState();
    _fetchAllRecentAds();
  }

  Future<void> _fetchAllRecentAds() async {
    for (var docId in widget.docIds) {
      var ads = await _getRecentAds(docId);
      if (ads.isNotEmpty) {
        allCategoriesEmpty = false;
      }
      setState(() {
        adsData[docId] = ads;
      });
    }
  }

  Future<List<DocumentSnapshot>> _getRecentAds(String docId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(docId)
          .collection('ads')
          .where('userId', isEqualTo: widget.userId)
          .get();

      return snapshot.docs;
    } catch (error) {
      print('Error fetching recent ads for docId $docId: $error');
      throw error;
    }
  }

  Future<void> _deleteAd(String docId, String adId) async {
    try {
      await FirebaseFirestore.instance
          .collection('category')
          .doc(docId)
          .collection('ads')
          .doc(adId)
          .delete();
      setState(() {
        adsData[docId]?.removeWhere((doc) => doc.id == adId);
        // Recalculate if all categories are empty
        allCategoriesEmpty = adsData.values.every((ads) => ads.isEmpty);
      });
      print('Ad $adId deleted successfully');
    } catch (error) {
      print('Error deleting ad $adId: $error');
    }
  }


  void _confirmDelete(BuildContext context, String docId, String adId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this ad?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAd(docId, adId);
              },
            ),
          ],
        );
      },
    );
  }

  void _checkBoostStatusAndNavigate(BuildContext context, String docId, DocumentSnapshot doc) async {
    try {
      final adId = doc.id;
      final adData = await FirebaseFirestore.instance
          .collection('category')
          .doc(docId)
          .collection('ads')
          .doc(adId)
          .get();

      if (adData.exists) {
        final data = adData.data() as Map<String, dynamic>;

        // Check if the ad is boosted
        if (data['boosted'] == true) {
          final boostedUntil = (data['boostedUntil'] as Timestamp?)?.toDate();
          final now = DateTime.now();

          if (boostedUntil != null && boostedUntil.isAfter(now)) {
            final timeLeft = boostedUntil.difference(now);

            // Show popup with remaining time and reset date
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Ad Boost Active'),
                  content: Text(
                    'This ad is currently boosted. Time remaining: ${timeLeft.inDays} days, ${timeLeft.inHours % 24} hours.\n'
                        'Boost will reset on: ${DateFormat.yMMMd().format(boostedUntil)}.',
                  ),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // Boost period expired; navigate to BoostPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BoostPage(
                  productName: data['ad_name'] ?? 'No Ad Name',

                  desc: data['description'] ?? '', userId: widget.userId, imageUrl:data['images']?.first ?? '',
                ),
              ),
            );
          }
        } else {
          // Ad is not boosted; navigate to BoostPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoostPage(
                userId: widget.userId,
                productName: data['ad_name'] ?? 'No Ad Name',
                imageUrl: data['images']?.first ?? '',
                desc: data['description'] ?? '',
              ),
            ),
          );
        }
      }
    } catch (error) {
      print('Error checking boost status: $error');
    }
  }


  void _navigateToPostAd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPost(),
      ),
    );
  }

  void _viewDetails(BuildContext context, String category, String adId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllProductDetailsScreen(
          category: category,
          adId: adId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (allCategoriesEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No ads yet. Post now'),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _navigateToPostAd(context),
              child: const Text('Post Ad'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.docIds.map((docId) {
        return FutureBuilder<List<DocumentSnapshot>>(
          future: _getRecentAds(docId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            adsData[docId] = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    '$docId',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: adsData[docId]!.map((doc) {
                    FormattedDate formattedDate = FormattedDate(timestamp: doc['timestamp']);

                    return GestureDetector(
                      onTap: () => _viewDetails(context, docId, doc.id),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FC),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            if (doc['images'] != null && doc['images'].isNotEmpty)
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  image: DecorationImage(
                                    image: NetworkImage(doc['images'][0]),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc['ad_name'] ?? 'No Ad Name',
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      formattedDate.getFormattedDate(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      (doc.data() as Map<String, dynamic>).containsKey('price') &&
                                          doc['price'] != null &&
                                          doc['price'].toString().isNotEmpty
                                          ? numberFormat.format(double.parse(doc['price'].toString()))
                                          : 'N/A',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          _buildActionIcon(
                                            icon: Icons.call_missed_outgoing_outlined,
                                            color: Colors.green,
                                            onTap: () => _checkBoostStatusAndNavigate(context, docId, doc),
                                          ),
                                          _buildActionIcon(
                                            icon: Icons.share,
                                            color: Colors.green,
                                            onTap: () => ShareService.shareAd(docId, doc.id),
                                          ),
                                          _buildActionIcon(
                                            icon: Icons.delete,
                                            color: Colors.red,
                                            onTap: () => _confirmDelete(context, docId, doc.id),
                                          ),
                                          _buildActionIcon(
                                            icon: FontAwesomeIcons.pen,
                                            color: Colors.green,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EditData(
                                                    whichType: docId,
                                                    docName: doc.id,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )

              ],
            );
          },
        );
      }).toList(),
    );
  }
  Widget _buildActionIcon({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
