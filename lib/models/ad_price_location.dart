
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/posetdByUsercard.dart';
import '../../services/share_service.dart';
import 'ad_details.dart'; // Ensure the import path is correct

class AdDetails extends StatelessWidget {
  final Map<String, dynamic> adData;
  final List<String> imageUrls;
  final ValueNotifier<int> currentImageIndex;
  final String catDocid;
  final String adId;

  const AdDetails({
    super.key,
    required this.adData,
    required this.imageUrls,
    required this.currentImageIndex,
    required this.catDocid,
    required this.adId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdImageViewer(
          imageUrls: imageUrls,
          currentImageIndex: currentImageIndex,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white, // Adjust the color as needed
                width: 1.0, // Adjust the border width as needed
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Flexible(
                            child: Text(
                              adData['ad_name'] ?? 'No name',
                              
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => ShareService.shareAd(catDocid, adId),
                          child: const FaIcon(FontAwesomeIcons.shareFromSquare),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const FaIcon(Icons.location_on_outlined),
                       Flexible(
                        child: Text(
                          adData['userAddress'] ?? 'No address',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                          ),
                        ),
                      ),


                        // const Spacer(),
                        // const SizedBox(width: 4),
                        Text(
                          _formatDate(adData['timestamp']?.toDate() ?? DateTime.now()),
                          style: GoogleFonts.montserrat(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RS: ${adData['price'] ?? 'N/A'}',
                    style: GoogleFonts.montserrat(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Negotiate : ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        adData['negotiable'] ?? 'No',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        PostByUsercard(catDocid: catDocid, adId: adId),
      ],
    );
  }

  String _formatDate(DateTime date) {
    // Format the date as per your requirement, for example: "4 March"
    return '${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    // Map month number to month name
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

// Desription
class AdDescription extends StatelessWidget {
  final Map<String, dynamic> adData;

  const AdDescription({super.key, required this.adData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Description",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  adData['description'] ?? 'No description available',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
