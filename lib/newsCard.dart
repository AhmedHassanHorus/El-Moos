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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SizedBox(
            height: 400,
            width: 350,
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                      flex: 2,
                      child: Padding(
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
                                  style: TextStyle(fontSize: 10),
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
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
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
