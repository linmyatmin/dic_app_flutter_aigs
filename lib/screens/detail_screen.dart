import 'package:dic_app_flutter/components/img_view_dialog.dart';
import 'package:dic_app_flutter/components/video_viewer.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  // Product? product;
  Word? word;

  DetailScreen({Key? key, required this.word}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final List<String> images = [
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN06.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN15.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN17.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN24.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN34.jpg",
    "https://www.aigsthailand.com/aigsschool//Inclusion/8/SYN37.jpg"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: const Color.fromARGB(255, 48, 148, 34),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            widget.word!.nameEn,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: widget.word == null
            ? const Text(
                'Please search first...',
                // style: TextStyle(color: Colors.white)
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Scrollbar(
                  thumbVisibility: false,
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.word!.nameEn,
                        // style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Text(
                        widget.word!.despEn,
                        // style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 120, // Adjust the height as needed
                              child:
                                  //  const Text('images')

                                  ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showImageViewDialog(
                                          context, images[index]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        images[index],
                                        width:
                                            180, // Adjust the width as needed
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      Center(
                        child: VideoViewer(
                            videoUrl:
                                // 'https://videos.pexels.com/video-files/5413531/5413531-hd_1280_720_30fps.mp4',
                                'https://d3bh4clrfrmqaj.cloudfront.net/vids/qm_myanmar_ruby.mp4'),
                      ),
                    ],
                  )),
                ),
              ));
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
