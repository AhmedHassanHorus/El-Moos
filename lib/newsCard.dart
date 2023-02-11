import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatelessWidget {
  String title, body, websiteName, websiteImage, coverPhoto, articlelink;
  NewsCard(
      {super.key,
      required this.title,
      required this.body,
      required this.coverPhoto,
      required this.websiteImage,
      required this.websiteName,
      required this.articlelink});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 350,
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Image.network(
                    coverPhoto,
                    fit: BoxFit.fill,
                  )),
              Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: Image.network(
                                    websiteImage,
                                  ),
                                ),
                                Text(
                                  websiteName,
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                            InkWell(
                              onTap: () => _launchUrl(Uri.parse(articlelink)),
                              child: Text(
                                title,
                                style: TextStyle(
                                    color: Colors.blue[700], fontSize: 23),
                              ),
                            ),
                            Text(
                              body,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Divider(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0)),
                              onPressed: () {},
                              child: Container(
                                height: 48,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Dislike',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.thumb_down,
                                      color: Colors.black54,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          Flexible(
                            flex: 2,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0)),
                              onPressed: () {},
                              child: Container(
                                height: 48,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Like',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.thumb_up,
                                      color: Colors.black54,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
