import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Feedbacks extends StatefulWidget {
  const Feedbacks({Key? key}) : super(key: key);

  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  var current_user = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var user = FirebaseAuth.instance.authStateChanges().listen((user) {
      print(user);
      setState(() {
        current_user = user!.email.toString();
      });
    });
  }

  void DeleteFeedback(String id) async {
    print("Delete Pressed ${id}");
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("feedbacks").doc(id);
    documentReference.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Feedbacks"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('feedbacks')
                  .where("email", isEqualTo: current_user)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Text("Fetching data...");
                }

                return DataTable(columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Message')),
                  DataColumn(label: Text(''))
                ], rows: _buildList(context, snapshot.data.docs));
              }),
        ),
      ),
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    return DataRow(cells: [
      DataCell(Text(data['name'])),
      DataCell(Text(data['email'])),
      DataCell(Text(data['phone'])),
      DataCell(Text(data['datetime'])),
      DataCell(Text(data['message'])),
      DataCell(IconButton(
        tooltip: 'Increase volume by 10',
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          DeleteFeedback(data['id']);
        },
      )),
    ]);
  }
}
