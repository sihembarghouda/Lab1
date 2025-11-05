// services/note_service.dart
import 'package:appwrite/appwrite.dart' as aw;
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notes_app/services/appwrite_config.dart';

class NoteService {
  late final aw.Databases _databases;

  NoteService() {
    final client = getClient();
    _databases = aw.Databases(client);
  }

  /// List documents (notes). If [userId] is provided, filter by that user.
  Future<List<Document>> getNotes({String? userId}) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        queries: userId != null ? [aw.Query.equal('userId', userId)] : null,
      );

      return response.documents;
    } catch (e) {
      print('Error fetching notes: $e');
      return <Document>[];
    }
  }

  /// Create a new note. `data` should be a Map<String, dynamic> containing note fields.
  Future<Document> createNote(Map<String, dynamic> data) async {
    try {
      final response = await _databases.createDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: aw.ID.unique(),
        data: data,
      );

      return response;
    } catch (e) {
      print('Error creating note: $e');
      rethrow;
    }
  }

  /// Update an existing note by id with the provided data map.
  Future<Document> updateNote(String noteId, Map<String, dynamic> data) async {
    try {
      final response = await _databases.updateDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: noteId,
        data: data,
      );
      return response;
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  /// Delete a note by id.
  Future<void> deleteNote(String noteId) async {
    try {
      await _databases.deleteDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: noteId,
      );
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }
}
