import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/note.dart';

class NoteRepository {
  final FirebaseFirestore firestore;
  NoteRepository({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Note>> notesStream(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Note.fromMap(doc.id, doc.data()))
                  .toList(),
        );
  }

  Future<void> addNote(String uid, String text) async {
    final docRef = await firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .add({'text': text, 'createdAt': FieldValue.serverTimestamp()});
    // Wait for Firestore to set the server timestamp
    while (true) {
      final snap = await docRef.get();
      final data = snap.data();
      if (data != null && data['createdAt'] != null) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> updateNote(String uid, String id, String text) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .doc(id)
        .update({'text': text});
  }

  Future<void> deleteNote(String uid, String id) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('notes')
        .doc(id)
        .delete();
  }
}
