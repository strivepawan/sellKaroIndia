import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  final String adDocRef;
  final String catDocId;

  WhatsAppService({required this.adDocRef, required this.catDocId});

  Future<void> openWhatsApp() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("category")
          .doc(catDocId)
          .collection("ads")
          .doc(adDocRef)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String whatsappNumber = data['whatsappNumber'];

        if (whatsappNumber.startsWith("+")) {
          whatsappNumber = whatsappNumber.substring(1);
        }

        String url = "https://wa.me/$whatsappNumber";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } else {
        throw Exception('Ad not found');
      }
    } catch (error) {
      print('Error fetching WhatsApp number: $error');
      rethrow;
    }
  }
}
