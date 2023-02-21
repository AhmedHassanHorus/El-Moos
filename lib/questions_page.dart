import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:el_moos/question_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class QuestionsPage extends StatelessWidget {

 Function fun;

 QuestionsPage({super.key,required this.fun});

  @override
  Widget build(BuildContext context) {

    print("aaaaaaaaaaaaaa");
    return SingleChildScrollView(
      child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('questions')
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              if(snapshot.hasError){
                print("aaaaaaaaaaaaaa ${snapshot.error}");
              }else{



              }

                for(int i = 0 ; i < docs.length;i++){
                if(!docs[i]['solved'].contains(FirebaseAuth.instance.currentUser!.uid)){

                  return QuestionCard(question: docs[i]['question'],ans0: docs[i]['ans0'],ans1: docs[i]['ans1'],ans2: docs[i]['ans2'],ans3: docs[i]['ans3'],id: docs[i].id,key: Key(docs[i].id),real: docs[i]['real'],real_ans: docs[i]['real_ans'],src: docs[i]['src'],fun: fun,);
                }
              }

              return Text('wait_for_more_questions_soon').tr();
            },
        ),

    );
  }
}
