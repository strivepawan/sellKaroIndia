import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sell_karo_india/models/city_selction.dart';
import 'package:sell_karo_india/models/price_fromat_output.dart';
import '../chatApp/api/apis.dart';
import '../chatApp/screens/profile_screen.dart';
import '../models/category_scroll_view.dart';
import '../models/date_time_helper.dart';
import '../models/notification badges.dart';
import '../productview/all_product_details/all_product_details.dart';
import '../services/location_service.dart';
import 'search_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String currentCity = 'Loading...';
  String? _userImageUrl;
  List<AdData> adsData = []; // Declare adsData here
  List<String> citySuggestions = [];

  @override
  void initState() {
    super.initState();
    _fetchCity();
    _getUser(); // Fetch location on app launch
  }

  Future<void> _fetchCity() async {
    final city = await LocationService.getCurrentCity();
    setState(() {
      currentCity = city;
      cityController.text = city;
      _cityController.text = city;
    });
  }

  Future<void> _getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user signed in with Google
      if (user.providerData
          .any((userInfo) => userInfo.providerId == 'google.com')) {
        // If signed in with Google, fetch the user's photoURL
        String? imageUrl = user.photoURL;
        if (imageUrl != null) {
          setState(() {
            _userImageUrl = imageUrl; // Set the user's image URL
          });
        }
      }
    }
  }

  // Function to toggle favorite status
  Future<void> toggleFavorite(AdData adData) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userFavsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(adData.adId);

      try {
        DocumentSnapshot docSnapshot = await userFavsRef.get();

        if (docSnapshot.exists) {
          // Remove from favorites
          await userFavsRef.delete();
        } else {
          // Add to favorites
          await userFavsRef.set({
            'imageUrl': adData.imageUrl,
            'adname': adData.adname,
            'price': adData.price,
            'userAddress': adData.userAddress,
            'timestamp': adData.timestamp,
            'category': adData.category,
            'docId': adData.docId,
            'adId': adData.adId,
          });
        }

        // Update the favorite status locally
        setState(() {
          int index = adsData.indexWhere((ad) => ad.adId == adData.adId);
          if (index != -1) {
            adsData[index].isFavorite = !adsData[index].isFavorite;
          }
        });
      } catch (e) {
        print('Error toggling favorite: $e');
        // Handle error
      }
    }
  }

  void updateCitySuggestions(String query) async {
    List<String> suggestions = await LocationService.getCitySuggestions(query);
    setState(() {
      citySuggestions = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0), // Add padding for spacing
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.contain, // Scale the image appropriately
              ),
            ),
          ),
        ),
        title: GestureDetector(
          onTap: () async {
            final selectedCity = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CitySelectionScreen(),
              ),
            );
            if (selectedCity != null) {
              setState(() {
                currentCity = selectedCity;
                cityController.text = selectedCity;
                _cityController.text = selectedCity;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Ensure it doesn't take excessive space
                children: [
                  const Icon(Icons.location_on, color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    currentCity.length > 15
                        ? '${currentCity.substring(0, 15)}...'
                        : currentCity,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
        actions: [
          if (_userImageUrl != null)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: APIs.me),
                  ),
                );
              },
              icon: CircleAvatar(
                backgroundImage: NetworkImage(
                  _userImageUrl!,
                ),
                radius: 20,
              ),
            )
          else
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: APIs.me),
                  ),
                );
              },
              icon: const Icon(CupertinoIcons.person,
                  size: 32.5, color: Colors.green),
            ),
          SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 270,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/sajsadjsakd.png"))),
              width: double.infinity,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Buy, Sell & Find \nJust About Anything & Everything.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchItem()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search_rounded,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  localization.searchAnything,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16, color: Colors.green),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00BF63),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child:
                                        Icon(Icons.search, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const CategoryScrollView(),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: fetchAdsDataStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<AdData> adsData = snapshot.data!.docs.map((document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    List<String> images =
                        data['images'] != null ? List.from(data['images']) : [];
                    String imageUrl = images.isNotEmpty ? images[0] : '';
                    String title = data['ad_name'] ?? '';
                    dynamic priceValue = data['price'];
                    int price = priceValue is int
                        ? priceValue
                        : int.tryParse(priceValue ?? '') ?? 0;
                    String userAddress = data['userAddress'] ?? '';
                    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                    String category = document.reference.parent.parent?.id ??
                        ''; // Get the category
                    String docId = document.id; // Get the document ID
                    String adId = document.id; // Get the ad ID
                    return AdData(
                      imageUrl: imageUrl,
                      adname: title,
                      price: price,
                      userAddress: userAddress,
                      timestamp: timestamp,
                      category: category,
                      docId: docId,
                      adId: adId,
                      isFavorite: true,
                    );
                  }).toList();

                  if (adsData.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: adsData.length,
                      itemBuilder: (context, index) {
                        AdData adData = adsData[index];
                        return KeyedSubtree(
                          key: ValueKey(adData.adId),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllProductDetailsScreen(
                                    category: adData.category,
                                    adId: adData.adId,
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
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8)),
                                            child: Image.network(
                                              adData.imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => toggleFavorite(adData),
                                            child: FutureBuilder<bool>(
                                              future: isFavorite(adData),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Icon(
                                                    Icons.favorite,
                                                    color: snapshot.data!
                                                        ? Colors.red
                                                        : Colors.grey,
                                                    size: 24,
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return const Text(
                                                      'Error checking favorite');
                                                }
                                                return const CircularProgressIndicator();
                                              },
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                    child: Text(adData.adname,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.nunito(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        )),
                                  ),
                                  const Divider(
                                    height: 2,
                                    color: Color(0xFFEBEEF7),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.,
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Color(0xFF767E94), size: 14),
                                      Expanded(
                                        child: Text(
                                          adData.userAddress.length > 8
                                              ? '${adData.userAddress.substring(0, 8)}..'
                                              : adData.userAddress,
                                          style: const TextStyle(
                                            color: Color(0xFF767E94),
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        DateTimeHelper.formatTimestamp(
                                            adData.timestamp),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF767E94),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
      ),
    );
  }

  Stream<QuerySnapshot> fetchAdsDataStream() {
    try {
      List<String> categories = [
        'Device',
        'ElectronicAndAppliences',
        'Pets',
        'Property',
        'Service',
        'Vacancies',
        'Vehicle',
        'Fashion',
        'Furniture',
        'BookS',
        'Sports and GYM',
        'SpareParts',
      ];

      List<Stream<QuerySnapshot>> streams = [];

      for (String category in categories) {
        CollectionReference adsCollectionReference = FirebaseFirestore.instance
            .collection('category')
            .doc(category)
            .collection('ads');

        Stream<QuerySnapshot> categoryStream = adsCollectionReference
            .orderBy('timestamp', descending: true)
            .snapshots();

        streams.add(categoryStream);
      }

      return FirebaseFirestore.instance.collectionGroup('ads').snapshots();
    } catch (error) {
      print('Error fetching ads data: $error');
      throw error;
    }
  }

  Future<bool> isFavorite(AdData adData) async {
    // Ensure the user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    // Get the current user's UID
    String userId = user.uid;

    // Reference to the user's favorites collection
    DocumentReference favoriteDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(adData.adId);

    DocumentSnapshot doc = await favoriteDocRef.get();
    return doc.exists;
  }
}

class AdData {
  final String imageUrl;
  final String adname;
  final int price;
  final String userAddress;
  final Timestamp timestamp;
  final String category;
  final String docId;
  final String adId;
  bool isFavorite;

  AdData(
      {required this.imageUrl,
      required this.adname,
      required this.price,
      required this.userAddress,
      required this.timestamp,
      required this.category,
      required this.docId,
      required this.adId,
      required this.isFavorite});
  String get formattedPrice => PriceFormatter.formatPrice(price);
}
