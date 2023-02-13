import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCard extends StatefulWidget {
  String title, body, websiteName, websiteImage, coverPhoto, articlelink, websiteNameEn, titleEn, bodyEn, id;
  int like,dislike;
  NewsCard(
      {super.key,
        required this.title,
        required this.like,
        required this.dislike,
        required this.id,
        required this.titleEn,
        required this.body,
        required this.bodyEn,
        required this.coverPhoto,
        required this.websiteImage,
        required this.websiteName,
        required this.websiteNameEn,
        required this.articlelink});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
bool likeState = false;
bool dislikeState = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Center(
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
                    child: Container(
                      decoration:const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10))),

                      width: 350,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight:Radius.circular(10)),
                        child: Image.network(
                          widget.coverPhoto,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        widget.websiteImage,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    context.locale == Locale('ar') ? widget.websiteName  : widget.websiteNameEn ,
                                    style: const TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () => _launchUrl(Uri.parse(widget.articlelink)),
                                child: Text(
                                  context.locale == Locale('ar') ? widget.title  : widget.titleEn ,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.blue[700], fontSize: 23),
                                ),
                              ),
                              Text(
                                context.locale == Locale('ar') ? widget.body  : widget.bodyEn,
                                maxLines: 3,
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
                                onPressed: () async {
                                  int change = dislikeState ? widget.dislike-1 : widget.dislike+1;
                                  try {

                                    final userData = await FirebaseFirestore.instance
                                        .collection('news')
                                        .doc(widget.id)
                                        .update({"dislikes": change });
                                    setState(() {
                                      dislikeState = !dislikeState;
                                    });

                                  } catch (error) {
                                    print('oh error $error');
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Text(
                                        'Dislike',
                                        style: TextStyle(color: dislikeState ? Theme.of(context).accentColor : Colors.black),
                                      ),
                                  const    SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.thumb_down,
                                        color: dislikeState ? Theme.of(context).accentColor : Colors.black54,
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
                                onPressed: () async {
                                  int change = likeState ? widget.dislike-1 : widget.dislike+1;
                                  try {

                                     await FirebaseFirestore.instance
                                        .collection('news')
                                        .doc(widget.id)
                                        .update({"likes": change });
                                    setState(() {
                                      likeState = !likeState;
                                    });

                                  } catch (error) {
                                    print('oh error $error');
                                  }
                                },
                                child: Container(
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      Text(
                                        'Like',
                                        style: TextStyle(color: likeState ? Theme.of(context).accentColor : Colors.black),
                                      ),
                                    const  SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.thumb_up,
                                        color: likeState ? Theme.of(context).accentColor : Colors.black54,
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
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}