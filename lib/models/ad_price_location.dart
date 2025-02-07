import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/posetdByUsercard.dart';
import '../../services/share_service.dart';

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildImageSlider(),
        ),
        const SizedBox(height: 16),
        _buildText(adData['ad_name'] ?? 'No name', 22, FontWeight.w600, maxLines: 2),
        const SizedBox(height: 8),
        _buildRow(Icons.access_time_rounded, _formatDate(adData['timestamp']?.toDate() ?? DateTime.now())),
        const SizedBox(height: 4),
        _buildRow(Icons.location_pin, adData['userAddress'] ?? 'No address'),
        const SizedBox(height: 16),
        _buildPriceSection(),
        const SizedBox(height: 16),
        PostByUsercard(catDocid: catDocid, adId: adId),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => ShareService.shareAd(catDocid, adId),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FaIcon(FontAwesomeIcons.shareFromSquare, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                "Share",
                style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }

Widget _buildImageSlider() {
  return Stack(
    children: [
      SizedBox(
        height: 200,
        width: double.infinity,
        child: PageView.builder(
          itemCount: imageUrls.length,
          onPageChanged: (index) => currentImageIndex.value = index,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      Positioned(
        bottom: 10,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            imageUrls.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentImageIndex.value == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentImageIndex.value == index ? Colors.orange : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildText(String text, double fontSize, FontWeight fontWeight, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: GoogleFonts.montserrat(fontSize: fontSize, fontWeight: fontWeight, color: const Color(0xff191F33)),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey.shade800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey),
          Text(
            'Price: ₹${adData['price'] ?? 'N/A'}',
            style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Negotiable:',
                style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              Text(
                adData['negotiable'] ?? 'No',
                style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey.shade700),
              ),
            ],
          ),
          Divider(color: Colors.grey),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day} ${_getMonthName(date.month)}';

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}

class AdDescription extends StatelessWidget {
  final Map<String, dynamic> adData;

  const AdDescription({super.key, required this.adData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            adData['description'] ?? 'No description available',
            style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
