
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/core/shared/globals.dart';
import 'package:frontend/core/models/avatar.dart';

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

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Retrieves a list of Avatars from Firestore ordered by their level.
  Future<List<Avatar>> getAvatars() async {
    try {
      // Reference to the 'avatars' collection in Firestore
      CollectionReference avatarsCollection = _db.collection('avatars');

      // Query Firestore to get all avatars ordered by 'level'
      QuerySnapshot avatarsSnapshot = await avatarsCollection
          .orderBy('level')
          .get();

      // Check if any avatars were found
      if (avatarsSnapshot.docs.isNotEmpty) {
        // Convert each Firestore document to an Avatar instance
        List<Avatar> avatars = avatarsSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Include the document ID in the data
          return Avatar.fromMap(data);
        }).toList();

        return avatars;
      } else {
        // No avatars found, return an empty list
        return [];
      }
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching avatars: $e');
      return [];
    }
  }


  /// Update the avatar field in a user's document.
  Future<void> updateUserAvatar(String userId, String avatarName) async {
    final document = _db.collection('users').doc(userId);
    await document.update({'avatar': avatarName});
  }
}