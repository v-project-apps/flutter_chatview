import 'package:chatview/src/widgets/image_container.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final List<String> imagesUrls;

  const ImagePreview({Key? key, required this.imagesUrls}) : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
        ),
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.3),
                  shape: const CircleBorder(),
                ),
              ),
            ),
            // Counter (only show if more than 1 image)
            if (widget.imagesUrls.length > 1)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${_currentIndex + 1} of ${widget.imagesUrls.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            // Image content
            Center(
              child: Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height / 8),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.imagesUrls.length,
                  allowImplicitScrolling: true,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ImageContainer(
                      imageUrl: widget.imagesUrls[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
