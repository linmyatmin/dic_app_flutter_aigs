import 'package:dic_app_flutter/components/img_view_dialog.dart';
import 'package:dic_app_flutter/components/video_viewer.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WordDetail extends StatefulWidget {
  Word? word;
  WordDetail({Key? key, required this.word}) : super(key: key);

  @override
  State<WordDetail> createState() => _WordDetailState();
}

class _WordDetailState extends State<WordDetail> {
  final List<String> images = [
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN06.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN15.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN17.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN24.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN34.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN37.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.word!.nameEn),
            SizedBox(height: size.height * 0.03),
            // Text(widget.word!.despEn),
            Html(data: widget.word!.despEn),
            SizedBox(height: size.height * 0.03),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            showImageViewDialog(context, images[i]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.network(
                              images[i],
                              width: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.03),
            const Center(
              child: VideoViewer(
                  videoUrl:
                      'https://d3bh4clrfrmqaj.cloudfront.net/vids/qm_myanmar_ruby.mp4'),
            ),
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
