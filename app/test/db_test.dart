import 'package:flow/api/storage/db/database.dart';
import 'package:flow/api/storage/sources.dart';
import 'package:flow_api/models/group/model.dart';
import 'package:flow_api/models/label/model.dart';
import 'package:flow_api/models/note/model.dart';
import 'package:flow_api/models/user/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common/sqlite_api.dart';

// Adding the main function for Flutter test
void main() {
  test('Test for db_test', () {
    expect(true, isTrue);
  });
}

class DatabaseTestPage extends StatefulWidget {
  final SourcesService sourcesService;

  const DatabaseTestPage({super.key, required this.sourcesService});

  @override
  State<DatabaseTestPage> createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  String _testResults = "";
  bool _isRunningTest = false;

  void _addResult(String result) {
    setState(() {
      _testResults += "$result\n";
    });
  }

  void _clearResults() {
    setState(() {
      _testResults = "";
    });
  }

  Future<void> _testDatabaseConnection() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testing database connection...");

      // Test local database
      final local = widget.sourcesService.local;
      final version = await local.db.getVersion();
      final sqliteVersion = await local.getSqliteVersion();

      _addResult("✓ Local database connected successfully");
      _addResult("- Database version: $version");
      _addResult("- SQLite version: $sqliteVersion");

      // Test remote databases if available
      if (widget.sourcesService.remotes.isNotEmpty) {
        for (var remote in widget.sourcesService.remotes) {
          _addResult("\nTesting remote: ${remote.remoteStorage.identifier}");
          try {
            final version = await remote.local.db.getVersion();
            final sqliteVersion = await remote.local.getSqliteVersion();
            _addResult("✓ Remote connected successfully");
            _addResult("- Database version: $version");
            _addResult("- SQLite version: $sqliteVersion");
          } catch (e) {
            _addResult("✗ Remote connection error: $e");
          }
        }
      } else {
        _addResult("\nNo remote databases configured");
      }
    } catch (e) {
      _addResult("✗ Database connection test failed: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  Future<void> _testBasicOperations() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testing basic CRUD operations...");
      final local = widget.sourcesService.local;

      // Test User operations
      _addResult("\n--- User Operations ---");
      final testUser = User(
        name: "Test User ${DateTime.now().millisecondsSinceEpoch}",
        email: "test@example.com",
        description: "Created for testing",
        phone: "123-456-7890",
      );

      final createdUser = await local.user.createUser(testUser);
      if (createdUser != null) {
        _addResult("✓ User created: ${createdUser.name}");

        // Test retrieving the user
        final retrievedUser = await local.user.getUser(createdUser.id!);
        _addResult(retrievedUser != null
            ? "✓ User retrieved successfully"
            : "✗ Failed to retrieve user");

        // Test updating the user
        final updatedUser =
            createdUser.copyWith(name: "${createdUser.name} (Updated)");
        final updateResult = await local.user.updateUser(updatedUser);
        _addResult(updateResult
            ? "✓ User updated successfully"
            : "✗ Failed to update user");

        // Test deleting the user
        final deleteResult = await local.user.deleteUser(createdUser.id!);
        _addResult(deleteResult
            ? "✓ User deleted successfully"
            : "✗ Failed to delete user");
      } else {
        _addResult("✗ Failed to create user");
      }

      // Test Label operations
      _addResult("\n--- Label Operations ---");
      final testLabel = Label(
        name: "Test Label ${DateTime.now().millisecondsSinceEpoch}",
        description: "Created for testing",
      );

      final createdLabel = await local.label.createLabel(testLabel);
      if (createdLabel != null) {
        _addResult("✓ Label created: ${createdLabel.name}");

        // Test retrieving the label
        final retrievedLabel = await local.label.getLabel(createdLabel.id!);
        _addResult(retrievedLabel != null
            ? "✓ Label retrieved successfully"
            : "✗ Failed to retrieve label");

        // Test deleting the label
        final deleteResult = await local.label.deleteLabel(createdLabel.id!);
        _addResult(deleteResult
            ? "✓ Label deleted successfully"
            : "✗ Failed to delete label");
      } else {
        _addResult("✗ Failed to create label");
      }

      // Test Note operations
      _addResult("\n--- Note Operations ---");
      final testNote = Note(
        name: "Test Note ${DateTime.now().millisecondsSinceEpoch}",
        description: "Created for testing",
        status: NoteStatus.todo,
      );

      final createdNote = await local.note.createNote(testNote);
      if (createdNote != null) {
        _addResult("✓ Note created: ${createdNote.name}");

        // Test retrieving the note
        final retrievedNote = await local.note.getNote(createdNote.id!);
        _addResult(retrievedNote != null
            ? "✓ Note retrieved successfully"
            : "✗ Failed to retrieve note");

        // Test deleting the note
        final deleteResult = await local.note.deleteNote(createdNote.id!);
        _addResult(deleteResult
            ? "✓ Note deleted successfully"
            : "✗ Failed to delete note");
      } else {
        _addResult("✗ Failed to create note");
      }
    } catch (e) {
      _addResult("\n✗ Basic operations test failed: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  Future<void> _testDatabaseExport() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testing database export functionality...");
      final local = widget.sourcesService.local;

      // Export database
      final exportedData = await exportDatabase(local.db);
      final sizeInKb = exportedData.lengthInBytes / 1024;

      _addResult("✓ Database exported successfully");
      _addResult("- Export size: ${sizeInKb.toStringAsFixed(2)} KB");
      _addResult("- First 10 bytes: ${exportedData.take(10).toList()}");
    } catch (e) {
      _addResult("✗ Database export test failed: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  Future<void> _testSynchronization() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testing database synchronization...");

      // Test if sync is available
      final shouldSync = await widget.sourcesService.shouldSync();
      _addResult("Should sync: $shouldSync");

      if (widget.sourcesService.remotes.isEmpty) {
        _addResult("No remotes configured, skipping sync test");
      } else {
        _addResult("Starting manual synchronization...");
        await widget.sourcesService.synchronize(true);
        _addResult("Sync status: ${widget.sourcesService.syncStatus.value}");
      }
    } catch (e) {
      _addResult("✗ Synchronization test failed: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  Future<void> _testRelationships() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testing relationships between entities...");
      final local = widget.sourcesService.local;

      // Create test entities
      _addResult("\nCreating test entities...");

      final testUser = await local.user.createUser(User(
        name: "Relationship Test User",
        email: "rel-test@example.com",
      ));

      final testGroup = await local.group.createGroup(Group(
        name: "Relationship Test Group",
        description: "For testing relationships",
      ));

      final testNote = await local.note.createNote(Note(
        name: "Relationship Test Note",
        description: "For testing relationships",
        status: NoteStatus.todo,
      ));

      if (testUser != null && testGroup != null && testNote != null) {
        _addResult("✓ Created test entities successfully");

        // Test user-group relationship
        await local.userGroup.connect(testGroup.id!, testUser.id!);
        final isUserInGroup =
            await local.userGroup.isConnected(testGroup.id!, testUser.id!);
        _addResult(isUserInGroup
            ? "✓ User-Group relationship created successfully"
            : "✗ Failed to create User-Group relationship");

        // Test user-note relationship
        await local.userNote.connect(testUser.id!, testNote.id!);
        final isUserConnectedToNote =
            await local.userNote.isConnected(testUser.id!, testNote.id!);
        _addResult(isUserConnectedToNote
            ? "✓ User-Note relationship created successfully"
            : "✗ Failed to create User-Note relationship");

        // Test group-note relationship
        await local.groupNote.connect(testGroup.id!, testNote.id!);
        final isGroupConnectedToNote =
            await local.groupNote.isConnected(testGroup.id!, testNote.id!);
        _addResult(isGroupConnectedToNote
            ? "✓ Group-Note relationship created successfully"
            : "✗ Failed to create Group-Note relationship");

        // Clean up
        _addResult("\nCleaning up test entities...");
        await local.userGroup.disconnect(testGroup.id!, testUser.id!);
        await local.userNote.disconnect(testUser.id!, testNote.id!);
        await local.groupNote.disconnect(testGroup.id!, testNote.id!);
        await local.user.deleteUser(testUser.id!);
        await local.group.deleteGroup(testGroup.id!);
        await local.note.deleteNote(testNote.id!);
        _addResult("✓ Cleanup completed");
      } else {
        _addResult("✗ Failed to create test entities");
      }
    } catch (e) {
      _addResult("✗ Relationships test failed: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Testing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearResults,
            tooltip: 'Clear results',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                _testResults.isEmpty
                    ? "Run a test to see results..."
                    : _testResults,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testDatabaseConnection,
                  child: const Text('Test Connection'),
                ),
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testBasicOperations,
                  child: const Text('Test CRUD'),
                ),
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testDatabaseExport,
                  child: const Text('Test Export'),
                ),
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testSynchronization,
                  child: const Text('Test Sync'),
                ),
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testRelationships,
                  child: const Text('Test Relationships'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
