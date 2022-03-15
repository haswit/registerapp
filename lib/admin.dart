import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedbacks Admin"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('feedbacks')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text("Fetching data...")],
                  );
                }

                return DataTable(columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Message')),
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
    ]);
  }
}





// Container(
//             height: 95,
//             padding: EdgeInsets.all(25),
//             margin: EdgeInsets.only(bottom: 20),
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children: <Widget>[
//                 Tile(
//                   name: "Test 0",
//                   action1: () {
//                     print("Pressed item");
//                     Get.to(() => (Login()));
//                   },
//                 ),
//                 Tile(
//                     name: "Test 2",
//                     action1: () {
//                       print("Pressed item");
//                     })
//               ],
//             ),
//           ),
          
// class Tile extends StatefulWidget {
//   final name;
//   final action1;
//   const Tile({Key? key, this.name, this.action1}) : super(key: key);

//   @override
//   _TileState createState() => _TileState(Name: this.name);
// }

// class _TileState extends State<Tile> {
//   var Name;

//   _TileState({this.Name});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(right: 15),
//       decoration: BoxDecoration(
//         border: Border.all(
//             color: Color.fromARGB(40, 67, 68, 70),
//             width: 1.0,
//             style: BorderStyle.solid), //Border.all

//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30.0),
//           topRight: Radius.circular(30.0),
//           bottomLeft: Radius.circular(30.0),
//           bottomRight: Radius.circular(30.0),
//         ),
//       ),
//       width: 140,
//       child: Center(
//           child: TextButton(
//         child: Text(Name),
//         onPressed: () {
//           widget.action1;
//         },
//       )),
//     );
//   }
// }
