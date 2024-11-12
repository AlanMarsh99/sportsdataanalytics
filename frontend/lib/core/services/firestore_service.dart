
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/core/shared/globals.dart';

class Document<T> {
  Document({required this.path}) {
    ref = _db.doc(path);
  }
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  late DocumentReference ref;

  Future<T> getData() {
    return ref.get().then((v) => Globals.models[T](v.data()) as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((v) => Globals.models[T](v.data()) as T);
  }

  Future<void> upsert(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }

  Future<void> delete() {
    return ref.delete();
  }
}

class Collection<T> {
  Collection({required this.path}) {
    ref = _db.collection(path);
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  late CollectionReference ref;

  Future<List<T>> getData() async {
    var snapshots = await ref.get();
    return snapshots.docs
        .map((doc) => Globals.models[T](doc.data()) as T)
        .toList();
  }

  Future<List<T>> getDataWhereFieldIsEqualTo(String field, Object value) async {
    return ref.where(field, isEqualTo: value).get().then((value) =>
        value.docs.map((doc) => Globals.models[T](doc.data()) as T).toList());
  }

  Stream<List<T>> streamData() {
    ref.snapshots().map((value) => value.docs.map((doc) {
          return Globals.models[T](doc.data()) as T;
        }).toList());
    return ref.snapshots().map((value) =>
        value.docs.map((doc) => Globals.models[T](doc.data()) as T).toList());
  }

  Future<void> upsert(Map data) {
    return ref.add(Map<String, dynamic>.from(data));
  }
}

String generatePushId(String collection) {
  return FirebaseFirestore.instance.collection(collection).doc().id;
}
