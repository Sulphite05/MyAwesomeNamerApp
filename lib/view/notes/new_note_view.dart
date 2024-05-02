import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_services.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

// new note creation is a Future work as per CRUD
// every time we hot reload, a new note is created but we don't want that so hold th current note
class _NewNotesViewState extends State<NewNotesView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    // TODO: implement initState

    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase()
        .currentUser!; // current user must exist; if it doesn't then your app must crash
    final email = currentUser.email!;
    final DatabaseUser owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.UpdateNote(
        note: note,
        text: text,
      );
    }
  }

  void _textControllerListener() async {
    // to listen to our note's changes and keep updating as we write
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.UpdateNote(
      note: note,
      text: text,
    );
  }

  void setUpTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _saveNoteIfTextIsNotEmpty();
    _deleteNoteIfTextIsEmpty(); // runs when we move back
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createNewNote(), // returns databaseNote in snapshot
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // TODO: Handle this case.
              _note = snapshot.data as DatabaseNote;
              setUpTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
