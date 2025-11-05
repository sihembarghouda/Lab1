// lib/services/notes_screen.dart
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:notes_app/services/note_service.dart';
import 'package:notes_app/components/note_item.dart';
import 'package:notes_app/widgets/add_note_modal.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();
  List<Document> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // Function to fetch notes from the database
  Future<void> _fetchNotes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final fetchedNotes = await _noteService.getNotes();

      setState(() {
        _notes = fetchedNotes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() {
        _error = 'Failed to load notes. Please try again.';
        _isLoading = false;
      });
    }
  }

  // Show the add note dialog
  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteModal(
        onNoteAdded: _handleNoteAdded,
      ),
    );
  }

  // Add the new note to the state and avoid refetching
  void _handleNoteAdded(Map<String, dynamic> noteData) {
    // After adding a note on the server, refresh the list
    // (AddNoteModal already created the note via the service)
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Notes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton(
                  onPressed: _showAddNoteDialog,
                  child: const Text('+ Add Note'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show loading indicator
            if (_isLoading && _notes.isEmpty)
              const Center(child: CircularProgressIndicator()),

            // Show error message
            if (_error != null && _notes.isEmpty)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

            // Show the notes list
            if (!_isLoading || _notes.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchNotes,
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final doc = _notes[index];
                      // Convert Document data to a Map and include the id
                      final Map<String, dynamic> noteMap =
                          Map<String, dynamic>.from(doc.data as Map);
                      // Appwrite Document exposes the id as $id
                      // Add document id to the map (Appwrite Document has $id)
                      noteMap['id'] = doc.$id;

                      return NoteItem(
                        note: noteMap,
                        onEdit: (note) async {
                          // TODO: implement edit flow
                        },
                        onDelete: (id) async {
                          try {
                            await _noteService.deleteNote(id);
                            await _fetchNotes();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to delete note')),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
