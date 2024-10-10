import 'package:dic_app_flutter/components/img_view_dialog.dart';
import 'package:dic_app_flutter/components/video_viewer.dart';
import 'package:dic_app_flutter/models/media_file_model.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/network/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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

  // Function to load word details by ID
  Future<void> loadWordDetail() async {
    try {
      // Fetch the word detail by ID
      List<Word> wordDetails = await API().getWordDetailById(widget.word!.id);

      setState(() {
        word =
            wordDetails.first; // Assuming there's only one word in the result
        // print(word);
        isLoading = false; // Data loaded, stop loading indicator
      });
    } catch (e) {
      // Handle any errors here
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
      // print('Error fetching word details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // Show loading indicator
    }

    if (word == null) {
      return const Center(
          child:
              Text("Word not found!")); // Handle case where word is not found
    }

// Extract media files from the word model
    // List<String> mediaImages = word?.mediaFiles
    //         ?.where((mediaFile) => mediaFile.fileType == 'image')
    //         .map<String>((mediaFile) => mediaFile.filePath)
    //         .toList() ??
    //     [];
    List<MediaFile> mediaFiles = word?.mediaFiles ?? [];
    // print(word?.mediaFiles);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.word!.nameEn!,
              style: TextStyle(fontSize: widget.textSize),
            ),
            SizedBox(height: size.height * 0.03),
            // Text(widget.word!.despEn),
            Html(
              data: widget.word!.despEn,
              style: {
                // Customize any HTML tags' styles here, e.g., <sub> or <p>
                "p": Style(
                  fontSize: FontSize(widget.textSize),
                ),
              },
            ),
            SizedBox(height: size.height * 0.03),

            // Display media (both images and videos) with descriptions
            if (mediaFiles.isNotEmpty)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mediaFiles.length,
                  itemBuilder: (context, index) {
                    final mediaFile = mediaFiles[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (mediaFile.fileType == 'image')
                            GestureDetector(
                              onTap: () {
                                showImageViewDialog(
                                    context, mediaFile.filePath);
                              },
                              child: Image.network(
                                mediaFile.filePath,
                                width: 150,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            )
                          else if (mediaFile.fileType == 'video')
                            SizedBox(
                              width: 150,
                              height: 100,
                              child: VideoViewer(videoUrl: mediaFile.filePath),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            mediaFile.description,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                    // return GestureDetector(
                    //   onTap: () {
                    //     showImageViewDialog(context, mediaImages[index]);
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8),
                    //     child: Image.network(
                    //       mediaImages[index],
                    //       width: 100,
                    //       fit: BoxFit.contain,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ),
            SizedBox(height: size.height * 0.03),

            // Row(
            //   children: <Widget>[
            //     Expanded(
            //       child: SizedBox(
            //         height: 120,
            //         child: ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: images.length,
            //           itemBuilder: (context, i) {
            //             return GestureDetector(
            //               onTap: () {
            //                 showImageViewDialog(context, images[i]);
            //               },
            //               child: Padding(
            //                 padding: const EdgeInsets.all(8),
            //                 child: Image.network(
            //                   images[i],
            //                   width: 250,
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // SizedBox(height: size.height * 0.03),
            // const Center(
            //   child: VideoViewer(
            //       videoUrl:
            //           'https://d3bh4clrfrmqaj.cloudfront.net/vids/qm_myanmar_ruby.mp4'),
            // ),
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
