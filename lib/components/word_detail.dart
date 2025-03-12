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
import 'package:dic_app_flutter/theme/app_theme.dart';
import 'package:dic_app_flutter/screens/detail_screen.dart';

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
  int currentTabIndex = 0;

  // Add scroll controller
  final ScrollController _scrollController = ScrollController();

  // Add keys for sections
  final GlobalKey _mediaKey = GlobalKey();
  final GlobalKey _referencesKey = GlobalKey();

  // Scroll to section helper method
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0, // Align to top
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadWordDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
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

          // Create descriptions for all enabled languages, even if empty
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
              .where((desc) => enabledLanguages[desc['name']]!)
              .toList(); // Only filter by enabled languages

          _tabController = TabController(
            length: descriptions.length,
            vsync: this,
          );

          // Add listener for tab changes
          _tabController.addListener(() {
            if (!_tabController.indexIsChanging) {
              setState(() {
                currentTabIndex = _tabController.index;
              });
            }
          });
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
        ),
      );
    }

    if (word == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Word not found!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Language Selection and Info Bar - More Compact
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Info Chips - Reduced padding
              if ((word?.mediaFiles?.isNotEmpty ?? false) ||
                  (word?.wordReferences!.isNotEmpty ?? false))
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (word?.mediaFiles?.isNotEmpty ?? false)
                        _buildInfoChip(
                          icon: Icons.photo_library,
                          label: '${word!.mediaFiles!.length} Media',
                          onTap: () => _scrollToSection(_mediaKey),
                        ),
                      if (word?.wordReferences?.isNotEmpty ?? false)
                        _buildInfoChip(
                          icon: Icons.link,
                          label: '${word!.wordReferences!.length} References',
                          onTap: () => _scrollToSection(_referencesKey),
                        ),
                    ],
                  ),
                ),
              // Language Selector - More compact
              _buildLanguageSelector(),
            ],
          ),
        ),

        // Main Content
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            children: [
              // Description Card
              _buildDescriptionCard(descriptions[currentTabIndex]),
              const SizedBox(height: 12),

              // Media Gallery Section
              if (word?.mediaFiles?.isNotEmpty ?? false) ...[
                Container(
                  key: _mediaKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Media Gallery', Icons.photo_library),
                      _buildMediaGrid(word!.mediaFiles!),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // References Section
              if (word?.wordReferences?.isNotEmpty ?? false)
                Container(
                  key: _referencesKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Related Terms', Icons.link),
                      _buildReferenceList(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: descriptions.length,
        itemBuilder: (context, index) {
          final desc = descriptions[index];
          final isSelected = currentTabIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                currentTabIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? AppTheme.secondaryDark
                        : AppTheme.secondaryLight)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: isDark ? 1 : 0.5,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset(
                      'icons/flags/png100px/${desc['name'].toString().toLowerCase()}.png',
                      package: 'country_icons',
                      width: 20,
                      height: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isDark ? Colors.white : AppTheme.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white : AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(Map<String, String> desc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      color: isDark ? Theme.of(context).cardColor : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: ValueKey(desc['name']),
          padding: const EdgeInsets.all(12),
          child: desc['description']!.isEmpty
              ? Center(
                  child: Text(
                    'No description available for ${desc['title']}',
                    style: TextStyle(
                      fontSize: widget.textSize,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Html(
                  data: desc['description'],
                  style: {
                    "body": Style(
                      fontSize: FontSize(widget.textSize),
                      lineHeight: LineHeight.number(1.4),
                      color: isDark ? Colors.white : Colors.black87,
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    "p": Style(
                      margin: Margins.only(bottom: 8),
                    ),
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDark ? Colors.white : Theme.of(context).primaryColor,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: widget.textSize * 0.9,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceList() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 2,
      color: isDark ? Theme.of(context).cardColor : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: word!.wordReferences!.map((ref) {
            return InkWell(
              onTap: () => _navigateToWordDetail(context, ref.id),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isDark ? AppTheme.secondaryDark : AppTheme.secondaryLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.3)
                        : Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.link,
                      size: 16,
                      color: isDark
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Html(
                        data: ref.name,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(widget.textSize * 0.9),
                            color: isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMediaGrid(List<MediaFile> mediaFiles) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: mediaFiles.length,
      itemBuilder: (context, index) {
        final mediaFile = mediaFiles[index];

        return GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (context) => MediaViewDialog(
              mediaFiles: mediaFiles,
              initialIndex: index,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    mediaFile.filePath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: isDarkMode
                            ? Theme.of(context).cardColor
                            : Colors.grey[100],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDarkMode
                            ? Theme.of(context).cardColor
                            : Colors.grey[100],
                        child: const Center(
                          child: Icon(Icons.error_outline, color: Colors.red),
                        ),
                      );
                    },
                  ),
                  if (mediaFile.fileType == 'video')
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => MediaViewDialog(
                          mediaFiles: mediaFiles,
                          initialIndex: index,
                        ),
                      ),
                      splashColor: Colors.white.withOpacity(0.1),
                      highlightColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToWordDetail(BuildContext context, int wordId) async {
    try {
      List<Word> wordDetails = await API().getWordDetailById(wordId);
      if (wordDetails.isNotEmpty && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(word: wordDetails.first),
          ),
        );
      }
    } catch (e) {
      print('Error navigating to word detail: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load word details'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
