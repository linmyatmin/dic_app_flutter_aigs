import 'package:flutter/material.dart';
import 'package:dic_app_flutter/models/media_file_model.dart';
import 'package:dic_app_flutter/components/video_viewer.dart';

class MediaViewDialog extends StatefulWidget {
  final List<MediaFile> mediaFiles;
  final int initialIndex;

  const MediaViewDialog({
    Key? key,
    required this.mediaFiles,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<MediaViewDialog> createState() => _MediaViewDialogState();
}

class _MediaViewDialogState extends State<MediaViewDialog> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Stack(
        children: [
          // Media PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.mediaFiles.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final mediaFile = widget.mediaFiles[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Media content
                  Expanded(
                    child: mediaFile.fileType == 'image'
                        ? InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Hero(
                              tag: mediaFile.filePath,
                              child: Image.network(
                                mediaFile.filePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : VideoViewer(videoUrl: mediaFile.filePath),
                  ),
                  // Description
                  if (mediaFile.description.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.black.withOpacity(0.5),
                      width: double.infinity,
                      child: Text(
                        mediaFile.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              );
            },
          ),
          // Close button
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          // Counter
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${_currentIndex + 1}/${widget.mediaFiles.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
