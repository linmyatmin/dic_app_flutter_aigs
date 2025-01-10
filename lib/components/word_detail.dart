import 'package:dic_app_flutter/components/img_view_dialog.dart';
import 'package:dic_app_flutter/components/video_viewer.dart';
import 'package:dic_app_flutter/models/media_file_model.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dic_app_flutter/components/media_view_dialog.dart';
import 'package:country_icons/country_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dic_app_flutter/providers/language_settings_provider.dart'; // Import language settings provider

class WordDetail extends ConsumerStatefulWidget {
  final Word? word;
  final double textSize;

  WordDetail({Key? key, required this.word, required this.textSize})
      : super(key: key);

  @override
  ConsumerState<WordDetail> createState() => _WordDetailState();
}

class _WordDetailState extends ConsumerState<WordDetail>
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

          // Get enabled languages from provider
          final enabledLanguages =
              ref.read(languageSettingsProvider).enabledLanguages;

          // Filter descriptions based on enabled languages
          descriptions = [
            {
              'name': 'GB',
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
              .where((desc) =>
                  desc['description']!.isNotEmpty &&
                  enabledLanguages[desc['name']]!)
              .toList();

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

  void _navigateToWordDetail(BuildContext context, int wordId) async {
    try {
      List<Word> wordDetails = await API().getWordDetailById(wordId);
      if (wordDetails.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Html(
                  data: wordDetails.first.nameEn ?? '',
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(20),
                      color: Colors.white,
                    ),
                  },
                ),
                backgroundColor: Theme.of(context).primaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: WordDetail(
                word: wordDetails.first,
                textSize: widget.textSize,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error navigating to word detail: $e');
    }
  }

  Widget _buildReferencesSection() {
    if (word?.wordReferences == null || word!.wordReferences!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Initial number of references to show
    const int initialDisplayCount = 2;

    // State variable to track if all references are shown
    final ValueNotifier<bool> showAll = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
      valueListenable: showAll,
      builder: (context, isExpanded, child) {
        final displayedRefs = isExpanded
            ? word!.wordReferences!
            : word!.wordReferences!.take(initialDisplayCount).toList();

        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Card(
            elevation: 4,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with diamond icon
                GestureDetector(
                  onTap: () {
                    showAll.value = !showAll.value;
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.link, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'References (${word!.wordReferences!.length})',
                          style: TextStyle(
                            fontSize: widget.textSize * 0.9,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        const Spacer(),
                        // Diamond icon that rotates based on expanded state
                        Transform.rotate(
                          angle: isExpanded
                              ? 0
                              : 3.14159 / 4, // 45 degrees when not expanded
                          child: Icon(
                            Icons.diamond_outlined,
                            color: Colors.blue[700],
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // References content
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    maxHeight: isExpanded ? 200 : 80,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: displayedRefs.map((ref) {
                        return InkWell(
                          onTap: () => _navigateToWordDetail(context, ref.id),
                          child: Html(
                            data: ref.name,
                            style: {
                              "p": Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                fontSize: FontSize(widget.textSize * 0.9),
                                color: Colors.blue[700],
                                textDecoration: TextDecoration.underline,
                              ),
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    bool hasReferences =
        word?.wordReferences != null && word!.wordReferences!.isNotEmpty;

    return DefaultTabController(
      length: descriptions.length,
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: descriptions.map((desc) {
                      return Tab(
                        icon: Image.asset(
                          'icons/flags/png100px/${desc['name'].toString().toLowerCase()}.png',
                          package: 'country_icons',
                          width: 24,
                          height: 24,
                        ),
                      );
                    }).toList(),
                  ),
                  Expanded(child: _buildSwipeableDescriptions()),
                  if (mediaFiles.isNotEmpty) _buildMediaSection(mediaFiles),
                  if (hasReferences) const SizedBox(height: 100),
                ],
              ),
            ),
            if (hasReferences) _buildReferencesSection(),
          ],
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
