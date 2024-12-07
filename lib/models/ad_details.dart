import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../productview/fullScreen_image_view.dart';

class AdImageViewer extends StatelessWidget {
  final List<String> imageUrls;
  final ValueNotifier<int> currentImageIndex;

  const AdImageViewer({super.key, required this.imageUrls, required this.currentImageIndex});

  @override
  Widget build(BuildContext context) {
    return ValueListenableProvider<int>.value(
      value: currentImageIndex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 12, 7, 7), // Adjust the color as needed
              width: 1.0, // Adjust the border width as needed
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: [
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageView(
                            images: imageUrls,
                            initialIndex: index,
                          ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.0), // Add circular radius
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  onPageChanged: (int page) {
                    currentImageIndex.value = page + 1;
                  },
                ),
              ),
              Positioned(
                bottom: 8.0,
                right: 8.0,
                child: ValueListenableBuilder<int>(
                  valueListenable: currentImageIndex,
                  builder: (context, value, child) {
                    return Text(
                      '$value/${imageUrls.length}', // Display current & total
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
