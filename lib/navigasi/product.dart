import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController bornController = TextEditingController();

  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('users').snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshots.hasError) {
            return const Center(
              child: Text('ERROR'),
            );
          }
          if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Data'),
            );
          }
          var _data = snapshots.data!.docs;
          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              var userData = _data[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('${userData['first']} ${userData['last']}'),
                subtitle: Text('Born: ${userData['born']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, _data[index].id, userData);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        db.collection('users').doc(_data[index].id).delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Userss'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: bornController,
                decoration: InputDecoration(labelText: 'Year Born'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                final user = <String, dynamic>{
                  "first": firstController.text,
                  "last": lastController.text,
                  "born": int.tryParse(bornController.text) ?? 0,
                };
                db.collection("users").add(user).then((DocumentReference doc) {
                  print('DocumentSnapshot added with ID: ${doc.id}');
                  firstController.clear();
                  lastController.clear();
                  bornController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
      BuildContext context, String docId, Map<String, dynamic> userData) {
    firstController.text = userData['first'];
    lastController.text = userData['last'];
    bornController.text = userData['born'].toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: bornController,
                decoration: InputDecoration(labelText: 'Year Born'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                firstController.clear();
                lastController.clear();
                bornController.clear();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                final updatedUser = <String, dynamic>{
                  "first": firstController.text,
                  "last": lastController.text,
                  "born": int.tryParse(bornController.text) ?? 0,
                };
                db.collection("users").doc(docId).update(updatedUser).then((_) {
                  print('DocumentSnapshot updated with ID: $docId');
                  firstController.clear();
                  lastController.clear();
                  bornController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
