import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:notes_app/services/note_service.dart';
import 'package:notes_app/components/note_item.dart';
import 'package:notes_app/components/note_input_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();

  List<Document> _notes = [];
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _noteController = TextEditingController();
  Document? _editingNote;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // ✅ Charger toutes les notes depuis Appwrite
  Future<void> _fetchNotes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final notes = await _noteService.getNotes();
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Erreur lors du chargement : $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ Créer ou mettre à jour une note
  Future<void> _saveNote() async {
    if (_noteController.text.trim().isEmpty) return;

    try {
      final noteData = {'content': _noteController.text};
      if (_editingNote != null) {
        // Mettre à jour (send a map)
        await _noteService.updateNote(_editingNote!.$id, noteData);
        await _fetchNotes();
      } else {
        // Créer
        final newNote = await _noteService.createNote(noteData);
        setState(() {
          _notes.insert(0, newNote);
        });
      }
    } catch (e) {
      print("Erreur lors de l’enregistrement : $e");
    }

    _noteController.clear();
    _editingNote = null;
  }

  // ✅ Supprimer une note
  Future<void> _deleteNote(String noteId) async {
    try {
      await _noteService.deleteNote(noteId);
      _handleNoteDeleted(noteId);
    } catch (e) {
      print("Erreur de suppression : $e");
    }
  }

  // ✅ Retirer la note supprimée de la liste locale
  void _handleNoteDeleted(String noteId) {
    setState(() {
      _notes = _notes.where((note) => note.$id != noteId).toList();
    });
  }

  // ✅ Ouvrir la boîte de dialogue pour ajouter ou modifier une note
  void _showNoteDialog({Document? note}) {
    if (note != null) {
      _editingNote = note;
      _noteController.text = note.data['content'];
    } else {
      _editingNote = null;
      _noteController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => NoteInputDialog(
        controller: _noteController,
        isEditing: _editingNote != null,
        onSave: _saveNote,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ✅ En-tête
          Container(
            height: 100,
            color: Colors.blue,
            padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => _showNoteDialog(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Corps : chargement / erreur / liste
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : RefreshIndicator(
                        onRefresh: _fetchNotes,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            final Map<String, dynamic> noteMap =
                                Map<String, dynamic>.from(note.data as Map);
                            noteMap['id'] = note.$id;
                            return NoteItem(
                              note: noteMap,
                              onEdit: (n) => _showNoteDialog(note: note),
                              onDelete: (id) => _deleteNote(id),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
