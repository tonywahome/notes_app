import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String text;
  final DateTime createdAt;

  Note({required this.id, required this.text, required this.createdAt});

  factory Note.fromMap(String id, Map<String, dynamic> data) {
    DateTime createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is DateTime) {
      createdAt = data['createdAt'] as DateTime;
    } else {
      createdAt = DateTime.now();
    }
    return Note(id: id, text: data['text'] ?? '', createdAt: createdAt);
  }

  Map<String, dynamic> toMap() {
    return {'text': text, 'createdAt': createdAt};
  }
}
