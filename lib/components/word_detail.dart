import 'package:dic_app_flutter/components/img_view_dialog.dart';
import 'package:dic_app_flutter/components/video_viewer.dart';
import 'package:dic_app_flutter/models/media_file_model.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dic_app_flutter/components/media_view_dialog.dart';

class WordDetail extends StatefulWidget {
  Word? word;
  double textSize;

  WordDetail({Key? key, required this.word, required this.textSize})
      : super(key: key);

  @override
  State<WordDetail> createState() => _WordDetailState();
}

class _WordDetailState extends State<WordDetail> {
  Word? word;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWordDetail();
  }

  Future<void> loadWordDetail() async {
    try {
      List<Word> wordDetails = await API().getWordDetailById(widget.word!.id);
      setState(() {
        word = wordDetails.first;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildLanguageSection({
    required String title,
    required String name,
    required String description,
    required IconData icon,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue[700], size: 14),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: widget.textSize * 0.8,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(
                  data: name,
                  style: {
                    "p": Style(
                      fontSize: FontSize(widget.textSize),
                      fontWeight: FontWeight.bold,
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                  },
                ),
                if (description.isNotEmpty) ...[
                  const Divider(height: 12),
                  Html(
                    data: description,
                    style: {
                      "p": Style(
                        fontSize: FontSize(widget.textSize),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection(List<MediaFile> mediaFiles) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.photo_library, color: Colors.blue[700], size: 14),
                const SizedBox(width: 4),
                Text(
                  'Media Gallery',
                  style: TextStyle(
                    fontSize: widget.textSize * 0.8,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),

          // Media Content
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mediaFiles.length,
                itemBuilder: (context, index) {
                  final mediaFile = mediaFiles[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(right: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: GestureDetector(
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
                                child: Hero(
                                  tag: mediaFile.filePath,
                                  child: Image.network(
                                    mediaFile.filePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (mediaFile.description.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              mediaFile.description,
                              style: TextStyle(
                                fontSize: widget.textSize * 0.7,
                                color: Colors.grey[700],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (word == null) {
      return const Center(child: Text("Word not found!"));
    }

    List<MediaFile> mediaFiles = word?.mediaFiles ?? [];

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // English Section
            _buildLanguageSection(
              title: 'English',
              name: widget.word!.nameEn ?? '',
              description: widget.word!.despEn ?? '',
              icon: Icons.language,
            ),

            // Thai Section (if available)
            if (widget.word!.nameTh?.isNotEmpty == true ||
                widget.word!.despTh?.isNotEmpty == true)
              _buildLanguageSection(
                title: 'Thai',
                name: widget.word!.nameTh ?? '',
                description: widget.word!.despTh ?? '',
                icon: Icons.translate,
              ),

            // Chinese Section (if available)
            if (widget.word!.nameCn?.isNotEmpty == true ||
                widget.word!.despCn?.isNotEmpty == true)
              _buildLanguageSection(
                title: 'Chinese',
                name: widget.word!.nameCn ?? '',
                description: widget.word!.despCn ?? '',
                icon: Icons.translate,
              ),

            // Media Section
            if (mediaFiles.isNotEmpty) _buildMediaSection(mediaFiles),
          ],
        ),
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
