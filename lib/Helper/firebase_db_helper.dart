import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDbHelper {
  FireStoreDbHelper._();

  static final FireStoreDbHelper fireStoreDbHelper = FireStoreDbHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insert({required Map<String, dynamic> data}) async {
    //fetch id
    DocumentSnapshot<Map<String, dynamic>> counter =
    await db.collection('counter').doc('task_counter').get();
    int id = counter['id'];
    int length = counter['length'];

    //increment of id
    await db.collection('notes').doc('${++id}').set(data);

    //update id of student_counter document
    await db.collection('counter').doc('task_counter').update({'id': id});

    //update length of student_counter document
    await db
        .collection('counter')
        .doc('task_counter')
        .update({'length': ++length});
  }

  Future<void> delete({required String id}) async {
    await db.collection('notes').doc(id).delete();

    //fetch length of student_counter document
    DocumentSnapshot<Map<String, dynamic>> counter =
    await db.collection('counter').doc('task_counter').get();
    int length = counter['length'];

    //update length of student_counter document
    await db
        .collection('counter')
        .doc('task_counter')
        .update({'length': --length});
  }

  Future<void> update(
      {required String id, required Map<String, dynamic> data}) async {
    await db.collection('notes').doc(id).update(data);
  }
}
