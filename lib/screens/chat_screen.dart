import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc('KVdmehM2bFDLqsWgNhQw')
            .collection('messages')
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> streamsNapshot) {
          if (streamsNapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents = streamsNapshot.data!.docs;
          return ListView.builder(
            itemBuilder: (ctx, index) {
              return Text(documents[index]['text']);
            },
            itemCount: streamsNapshot.data!.size,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats')
                .doc('KVdmehM2bFDLqsWgNhQw')
                .collection('messages')
                .add({'text': 'This add by clicking button'});
          }),
    );
  }
}
