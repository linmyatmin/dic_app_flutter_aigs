import 'package:dic_app_flutter/components/img_view_dialog.dart';
import 'package:dic_app_flutter/components/video_viewer.dart';
import 'package:dic_app_flutter/models/media_file_model.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dic_app_flutter/components/media_view_dialog.dart';
import 'package:country_icons/country_icons.dart';

class WordDetail extends StatefulWidget {
  final Word? word;
  final double textSize;

  WordDetail({Key? key, required this.word, required this.textSize})
      : super(key: key);

  @override
  State<WordDetail> createState() => _WordDetailState();
}

class _WordDetailState extends State<WordDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  Word? word;
  List<Map<String, String>> descriptions = [];

  @override
  void initState() {
    super.initState();
    loadWordDetail();
  }

  Future<void> loadWordDetail() async {
    try {
      print('Loading word detail for ID: ${widget.word!.id}');
      List<Word> wordDetails = await API().getWordDetailById(widget.word!.id);

      if (wordDetails.isNotEmpty) {
        setState(() {
          word = wordDetails.first;
          isLoading = false;

          // Prepare descriptions, filtering out null values
          descriptions = [
            {
              'name': 'US',
              'title': 'English',
              'description': word!.despEn ?? ''
            },
            {'name': 'TH', 'title': 'Thai', 'description': word!.despTh ?? ''},
            {
              'name': 'CN',
              'title': 'Chinese',
              'description': word!.despCn ?? ''
            },
            {
              'name': 'FR',
              'title': 'French',
              'description': word!.despFr ?? ''
            },
            {
              'name': 'ES',
              'title': 'Spanish',
              'description': word!.despSp ?? ''
            },
            {
              'name': 'JP',
              'title': 'Japanese',
              'description': word!.despJp ?? ''
            },
          ]
              .where((desc) => desc['description']!.isNotEmpty)
              .toList(); // Filter out null descriptions

          // Initialize TabController with the number of valid descriptions
          _tabController =
              TabController(length: descriptions.length, vsync: this);
        });
      } else {
        setState(() {
          isLoading = false;
          word = null;
        });
        print('No word details found for ID: ${widget.word!.id}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        word = null;
      });
      print('Error loading word detail: $e');
    }
  }

  Widget _buildSwipeableDescriptions() {
    return TabBarView(
      controller: _tabController,
      children: descriptions.map((desc) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.blue[100], // Background color for the title
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  desc['title']!,
                  style: TextStyle(
                    fontSize: 14, // Slightly smaller font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Title text color
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Html(
                    data: desc['description'],
                    style: {
                      "p": Style(
                        fontSize: FontSize(widget.textSize),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (word == null) {
      return const Center(child: Text("Word not found!"));
    }

    List<MediaFile> mediaFiles = word?.mediaFiles ?? [];

    return DefaultTabController(
      length: descriptions.length, // Number of valid tabs
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              // TabBar for language selection
              TabBar(
                controller: _tabController,
                tabs: descriptions.map((desc) {
                  // return Tab(text: desc['name']);
                  return Tab(
                    icon:
                        // CountryIcons.getSvgFlag(
                        //     desc['name'].toString().toUpperCase()),
                        // CountryIcons.getSvgFlag('de'),
                        Image.asset(
                      'icons/flags/png100px/${desc['name'].toString().toLowerCase()}.png',
                      package: 'country_icons',
                      width: 24,
                      height: 24,
                    ),
                    //   Image.asset(
                    // 'assets/icons/${desc['name'].toString().toLowerCase()}.png', // Assuming you have flag icons in assets/icons/
                    // package: 'country_icons',
                    // width: 24,
                    // height: 24,
                    // ),
                  );
                }).toList(),
              ),
              // Swipeable Descriptions
              Expanded(child: _buildSwipeableDescriptions()),
              // Media Section
              if (mediaFiles.isNotEmpty) _buildMediaSection(mediaFiles),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection(List<MediaFile> mediaFiles) {
    return Card(
      elevation: 4, // Increased elevation for a more pronounced shadow
      margin: const EdgeInsets.only(bottom: 16), // Increased bottom margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.photo_library, color: Colors.blue[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Media Gallery',
                  style: TextStyle(
                    fontSize: widget.textSize * 0.9,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              height: 120, // Set a smaller height for the media section
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                itemCount: mediaFiles.length,
                itemBuilder: (context, index) {
                  final mediaFile = mediaFiles[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MediaViewDialog(
                            mediaFiles: mediaFiles,
                            initialIndex: index,
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 100, // Set a fixed width for each media item
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4), // Spacing between items
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Image.network(
                              mediaFile.filePath,
                              fit: BoxFit.cover, // Cover the entire area
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error),
                                );
                              },
                            ),
                            // Overlay effect to indicate clickability
                            if (mediaFile.fileType ==
                                'video') // Check if the media file is a video
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(
                                      0.3), // Semi-transparent overlay
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons
                                        .play_arrow, // Play icon for video indication
                                    color: Colors.white,
                                    size: 30, // Slightly smaller play icon
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showImageViewDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ImageViewDialog(imageUrl: imageUrl);
    },
  );
}
