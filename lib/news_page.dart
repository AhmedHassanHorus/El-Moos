import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_moos/news_card.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  @override
  Widget build(BuildContext context) {

      print("aaaaaaaaaaaaaa33333333");

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('news')
          .orderBy('time')
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if(snapshot.hasError){
          print("aaaaaaaaaaaaaa ${snapshot.error}");
        }else{
          print("${docs[0]['details']}");


        }

        return ListView.builder(

          itemBuilder: (ctx, ind) => NewsCard(
            websiteNameEn: docs[ind]["src_en"],
            id: docs[ind].id,
            like: docs[ind]["likes"],
            dislike: docs[ind]["dislikes"],
            title: docs[ind]["title"],
            titleEn: docs[ind]["title_en"],
            coverPhoto: docs[ind]["image_url"],
            body: docs[ind]["details"],
            bodyEn: docs[ind]["details_en"],
            websiteName: docs[ind]["src"],
            websiteImage: docs[ind]["src_image"],
            articlelink: docs[ind]["src_url"],
            key: ValueKey(docs[ind].id),
          ),
          itemCount: docs.length,
        );
      },
    );
  }
}
