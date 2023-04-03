import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Helper/firebase_db_helper.dart';
import '../../Helper/firebase_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> insertKey = GlobalKey<FormState>();
  GlobalKey<FormState> updateKey = GlobalKey<FormState>();

  TextEditingController writerController = TextEditingController();
  TextEditingController bookController = TextEditingController();

  String? writer;
  String? book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
        leading: Container(),
        actions: [
          GestureDetector(
            onTap: () async {
              FirebaseHelper.firebaseHelper.signOut();
              SharedPreferences prfs = await SharedPreferences.getInstance();
              prfs.setBool('isLogged', false);
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: Icon(
              Icons.power_settings_new_sharp,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder(
        stream: FireStoreDbHelper.db.collection('notes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>> data =
                snapshot.data as QuerySnapshot<Map<String, dynamic>>;

            List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                data.docs;

            return ListView.builder(
              itemCount: allDocs.length,
              padding: const EdgeInsets.all(5),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, i) => Card(
                elevation: 3,
                child: ListTile(
                  title: Text("Writer:${allDocs[i].data()['title']}"),
                  subtitle: Text("Book: ${allDocs[i].data()['task']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            updateData(allDocs: allDocs, index: i);
                          });
                        },
                        icon: const Icon(Icons.edit, color: Colors.green),
                      ),
                      IconButton(
                        onPressed: () async {
                          await FireStoreDbHelper.fireStoreDbHelper
                              .delete(id: allDocs[i].id);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addData();
        },
        label: const Text("Add"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  addData() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("Insert Data")),
        content: Form(
          key: insertKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: writerController,
                onSaved: (val) {
                  setState(() {
                    writer = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your Writer";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your Writer",
                  labelText: "Writer",
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              TextFormField(
                controller: bookController,
                onSaved: (val) {
                  setState(() {
                    book = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your book name";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your book",
                  labelText: "Book",
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (insertKey.currentState!.validate()) {
                insertKey.currentState!.save();

                Map<String, dynamic> data = {
                  'title': book!,
                  'task': writer!,
                };

                FireStoreDbHelper.fireStoreDbHelper.insert(data: data);

                Navigator.pop(context);
              }
              setState(() {
                bookController.clear();
                writerController.clear();
                writer = null;
                book = null;
              });
            },
            child: const Text("Insert"),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                writerController.clear();
                bookController.clear();
                writer = null;
                book = null;
              });
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  updateData(
      {required List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs,
      required int index}) {
    writerController.text = allDocs[index].data()['title'];
    bookController.text = allDocs[index].data()['task'];

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(child: Text("Update Data")),
        content: Form(
          key: updateKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: writerController,
                onSaved: (val) {
                  setState(() {
                    writer = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your writer";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Update your Writer",
                  labelText: "Writer",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: bookController,
                onSaved: (val) {
                  setState(() {
                    book = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter your book";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Update your book",
                  labelText: "Book",
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (updateKey.currentState!.validate()) {
                updateKey.currentState!.save();

                Map<String, dynamic> data = {
                  'title': writer!,
                  'task': book!,
                };

                FireStoreDbHelper.fireStoreDbHelper
                    .update(data: data, id: allDocs[index].id);

                Navigator.pop(context);
              }
              setState(() {
                writerController.clear();
                bookController.clear();
                writer = null;
                book = null;
              });
            },
            child: const Text("Update"),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                writerController.clear();
                bookController.clear();
                writer = null;
                book = null;
              });
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
