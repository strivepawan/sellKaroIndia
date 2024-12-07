// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> copyAdDataToChatData({
//     required String adDocRef,
//     required String catDocId,
//   }) async {
//     try {
//       // Source document reference
//       DocumentReference adDocReference = _firestore
//           .collection('category')
//           .doc(catDocId)
//           .collection('ads')
//           .doc(adDocRef);

//       // Fetch the document data
//       DocumentSnapshot adDocSnapshot = await adDocReference.get();

//       if (adDocSnapshot.exists) {
//         Map<String, dynamic> adData = adDocSnapshot.data() as Map<String, dynamic>;

//         // Extract required fields
//         String image = adData['images'][0]; // Assuming 'images' is a list and we need the first image
//         String adName = adData['adName'];
//         String userId = adData['userId'];

//         // Prepare the data to be stored in the new collection
//         Map<String, dynamic> chatData = {
//           'image': image,
//           'adName': adName,
//           'userId': userId,
//         };

//         // Destination collection reference
//         CollectionReference chatDataCollection = _firestore.collection('chatData');

//         // Store the data in a new document in the destination collection
//         await chatDataCollection.add(chatData);
//         print('Data copied successfully to chatData collection.');
//       } else {
//         print('Ad document does not exist.');
//       }
//     } catch (e) {
//       print('Error copying data: $e');
//     }
//   }
// }
