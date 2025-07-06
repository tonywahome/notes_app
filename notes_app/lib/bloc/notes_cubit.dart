import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/note_repository.dart';
import '../domain/note.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;
  NotesLoaded(this.notes);
}

class NotesError extends NotesState {
  final String message;
  NotesError(this.message);
}

class NotesCubit extends Cubit<NotesState> {
  final NoteRepository noteRepository;
  final String uid;
  Stream<List<Note>>? _notesStream;
  NotesCubit(this.noteRepository, this.uid) : super(NotesInitial()) {
    _notesStream = noteRepository.notesStream(uid);
    _notesStream!.listen(
      (notes) {
        emit(NotesLoaded(notes));
      },
      onError: (e) {
        emit(NotesError(e.toString()));
      },
    );
  }

  Future<void> addNote(String text) async {
    try {
      await noteRepository.addNote(uid, text);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await noteRepository.updateNote(uid, id, text);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await noteRepository.deleteNote(uid, id);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
