import 'package:dic_app_flutter/components/img_view_dialog.dart';
import 'package:dic_app_flutter/components/vdo_viewer.dart';
import 'package:dic_app_flutter/models/product_model.dart';
import 'package:dic_app_flutter/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailScreen extends StatefulWidget {
  Product? product;
  Word? word;

  DetailScreen({Key? key, required this.product, required this.word})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
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
                              child: const Text('images')

                              // ListView.builder(
                              //   scrollDirection: Axis.horizontal,
                              //   itemCount: widget.product!.images.length,
                              //   itemBuilder: (BuildContext context, int index) {
                              //     return GestureDetector(
                              //       onTap: () {
                              //         showImageViewDialog(
                              //             context, widget.product!.images[index]);
                              //       },
                              //       child: Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: Image.network(
                              //           widget.product!.images[index],
                              //           width: 120, // Adjust the width as needed
                              //           fit: BoxFit.cover,
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // ),

                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),
                    Center(
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                              // VideoProgressIndicator(_controller,
                              //     allowScrubbing: true),
                            )
                          : const Text('fetching video data ...'),
                    ),
                  ],
                ),
              ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
