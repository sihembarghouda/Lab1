import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:notes_app/services/note_service.dart';
import 'package:notes_app/widgets/note_item.dart';
import 'package:notes_app/widgets/add_note_modal.dart';
import 'package:notes_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Document> notes = [];
  bool isLoading = true;
  final NoteService _noteService = NoteService();

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    String? userId;

    try {
      userId = user?.$id;
    } catch (_) {
      try {
        userId = user?['\$id'] ?? user?['id'];
      } catch (_) {
        userId = null;
      }
    }

    if (userId == null) return;

    setState(() => isLoading = true);

    try {
      final fetchedNotes = await _noteService.getNotes(userId: userId);
      setState(() {
        notes = fetchedNotes;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch notes: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteNote(String noteId) async {
    try {
      await _noteService.deleteNote(noteId);
      setState(() {
        notes.removeWhere((d) => d.$id == noteId);
      });
    } catch (e) {
      print('Failed to delete note: $e');
    }
  }

  Future<void> _addNote(Map<String, dynamic> noteData) async {
    // Après ajout réussi dans AddNoteModal, on recharge la liste
    await _fetchNotes();
  }

  Future<void> _updateNote(String noteId, Map<String, dynamic> newData) async {
    // Update on server then refresh list to keep state consistent.
    setState(() => isLoading = true);
    try {
      // Try to update via the service (if implemented). If your NoteService
      // exposes an `updateNote` method this will call it; otherwise the
      // service can be extended to perform the server update.
      await _noteService.updateNote(noteId, newData);
      // Refresh notes from server to reflect the latest data.
      await _fetchNotes();
    } catch (e) {
      print('Failed to update note: $e');
      setState(() => isLoading = false);
    }
  }

  // ✅ Affichage amélioré de l’état vide
  Widget _buildEmptyNotesView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You don't have any notes yet.",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Tap the + button to create your first note!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notes.isEmpty
                ? _buildEmptyNotesView()
                : RefreshIndicator(
                    onRefresh: _fetchNotes,
                    child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final doc = notes[index];
                        return NoteItem(
                          note: doc,
                          onNoteDeleted: (id) => _deleteNote(id),
                        );
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddNoteModal(onNoteAdded: _addNote),
          );
        },
      ),
    );
  }
}
