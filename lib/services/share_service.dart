import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareAd(String catDocid, String adId) async {
    try {
      // Fetch ad details from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(catDocid)
          .collection('ads')
          .doc(adId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String adName = data['ad_name']; // Fetch ad name
        String adDescription = data['description']; // Fetch ad description

        // Generate deep link
        String deepLink = 'https://example.com/ads/$catDocid/ads/$adId'; // Replace with your deep link logic

        // Share deep link
        Share.share(
          'Check out this ad: $adName\n\n$adDescription\n\n$deepLink',
          subject: 'Check out this ad on SKI',
        );
      } else {
        throw Exception('Ad not found');
      }
    } catch (e) {
      print('Error sharing ad: $e');
      // Handle error as needed
    }
  }
}
