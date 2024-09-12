import 'package:dic_app_flutter/models/word_model.dart';
import 'package:dic_app_flutter/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WordList extends StatefulWidget {
  List<Word> list;

  WordList({Key? key, required this.list}) : super(key: key);

  @override
  State<WordList> createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.list.length,
      itemBuilder: (ctx, i) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                          word: widget.list[i],
                        )));
          },
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  widget.list[i].nameEn,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                )),
                Expanded(
                  child: Html(
                    data: widget.list[i]
                        .despEn, // Assuming nameEn contains HTML content
                    style: {
                      // Customize any HTML tags' styles here, e.g., <sub> or <p>
                      "p": Style(
                        fontSize: FontSize(12.0),
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.left,
                        maxLines: 1, // Limit to one line
                      ),
                      "sub": Style(
                        fontSize: FontSize(
                            9.0), // Slightly smaller font for subscript
                      ),
                    },
                  ),
                  //     child: Text(
                  //   widget.list[i].despEn,
                  //   textAlign: TextAlign.right,
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.normal,
                  //     fontSize: 12.0,
                  //   ),
                  // )
                )
              ],
              // title: Text(post.title),
              // subtitle: Text(post.body),
            ),
            // leading: CircleAvatar(
            //   backgroundImage: NetworkImage(
            //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEbU7_44vb0L45FVVdJ69vbG7eUatiAAbEpacifjBnHcoPaFjvhMA_H-WpVO_yMXMIBc0&usqp=CAU'),
            //   // NetworkImage(widget.list[i].images[0]),
            //   // widget.list[i].thumbnail),
            // ),
            // leading: CircleAvatar(
            //   child: FadeInImage.assetNetwork(
            //     placeholder:
            //         'assets/placeholder_image.png', // Placeholder image asset path
            //     image: products![i].images[0],
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // title: Text(
            //   widget.list[i].nameEn,
            //   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            // ),
            // subtitle: Text(
            //   // "${users![idx].users[0].address}, ${users![idx].company.catchPhrase}, ${users![idx].company.bs}",
            //   widget.list[i].despEn,
            //   style: const TextStyle(fontSize: 14),
            // ),
            // trailing: IconButton(
            //   icon: const Icon(Icons.favorite_border),
            //   onPressed: () {
            //     // Add logic to handle adding product to favorites
            //     print('added fav');
            //   },
            // ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
