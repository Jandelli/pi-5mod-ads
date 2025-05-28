import 'package:flow/api/storage/db/database.dart';
import 'package:flow/api/storage/sources.dart';
import 'package:flow_api/models/group/model.dart';
import 'package:flow_api/models/label/model.dart';
import 'package:flow_api/models/note/model.dart';
import 'package:flow_api/models/user/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common/sqlite_api.dart';

// Adiciona a função main para o teste Flutter.
void main() {
  // Define um teste simples para verificar a configuração do arquivo de teste.
  test('Test for db_test', () {
    // Verifica se 'true' é de fato 'true'. Um teste básico de sanidade.
    expect(true, isTrue);
  });
}

// Define um StatefulWidget para a página de teste do banco de dados.
class DatabaseTestPage extends StatefulWidget {
  final SourcesService
      sourcesService; // Serviço de fontes de dados a ser testado.

  const DatabaseTestPage({super.key, required this.sourcesService});

  @override
  State<DatabaseTestPage> createState() => _DatabaseTestPageState();
}

// Define o estado para DatabaseTestPage.
class _DatabaseTestPageState extends State<DatabaseTestPage> {
  String _testResults = ""; // Armazena os resultados dos testes.
  bool _isRunningTest = false; // Indica se um teste está em execução.

  // Adiciona uma string de resultado à exibição.
  void _addResult(String result) {
    setState(() {
      _testResults += "$result\n";
    });
  }

  // Limpa os resultados dos testes exibidos.
  void _clearResults() {
    setState(() {
      _testResults = "";
    });
  }

  // Testa a conexão com o banco de dados local e remotos (se configurados).
  Future<void> _testDatabaseConnection() async {
    _clearResults(); // Limpa resultados anteriores.
    setState(() {
      _isRunningTest = true; // Define o estado de execução do teste.
    });

    try {
      _addResult("Testando conexão com o banco de dados...");

      // Testa o banco de dados local.
      final local = widget
          .sourcesService.local; // Obtém a instância do banco de dados local.
      final version =
          await local.db.getVersion(); // Obtém a versão do banco de dados.
      final sqliteVersion =
          await local.getSqliteVersion(); // Obtém a versão do SQLite.

      _addResult("✓ Banco de dados local conectado com sucesso");
      _addResult("- Versão do banco de dados: $version");
      _addResult("- Versão do SQLite: $sqliteVersion");

      // Testa bancos de dados remotos, se houver.
      if (widget.sourcesService.remotes.isNotEmpty) {
        for (var remote in widget.sourcesService.remotes) {
          _addResult("\nTestando remoto: ${remote.remoteStorage.identifier}");
          try {
            final version = await remote.local.db.getVersion();
            final sqliteVersion = await remote.local.getSqliteVersion();
            _addResult("✓ Remoto conectado com sucesso");
            _addResult("- Versão do banco de dados: $version");
            _addResult("- Versão do SQLite: $sqliteVersion");
          } catch (e) {
            _addResult("✗ Erro na conexão remota: $e");
          }
        }
      } else {
        _addResult("\nNenhum banco de dados remoto configurado");
      }
    } catch (e) {
      _addResult("✗ Teste de conexão com o banco de dados falhou: $e");
    } finally {
      setState(() {
        _isRunningTest = false; // Reseta o estado de execução do teste.
      });
    }
  }

  // Testa operações básicas de CRUD (Criar, Ler, Atualizar, Deletar) para User, Label e Note.
  Future<void> _testBasicOperations() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testando operações básicas de CRUD...");
      final local = widget.sourcesService.local;

      // Testa operações de Usuário.
      _addResult("\n--- Operações de Usuário ---");
      final testUser = User(
        // Cria um usuário de teste.
        name: "Test User ${DateTime.now().millisecondsSinceEpoch}",
        email: "test@example.com",
        description: "Created for testing",
        phone: "123-456-7890",
      );

      final createdUser =
          await local.user.createUser(testUser); // Cria o usuário no banco.
      if (createdUser != null) {
        _addResult("✓ Usuário criado: ${createdUser.name}");

        // Testa a recuperação do usuário.
        final retrievedUser = await local.user.getUser(createdUser.id!);
        _addResult(retrievedUser != null
            ? "✓ Usuário recuperado com sucesso"
            : "✗ Falha ao recuperar usuário");

        // Testa a atualização do usuário.
        final updatedUser =
            createdUser.copyWith(name: "${createdUser.name} (Updated)");
        final updateResult = await local.user.updateUser(updatedUser);
        _addResult(updateResult
            ? "✓ Usuário atualizado com sucesso"
            : "✗ Falha ao atualizar usuário");

        // Testa a exclusão do usuário.
        final deleteResult = await local.user.deleteUser(createdUser.id!);
        _addResult(deleteResult
            ? "✓ Usuário excluído com sucesso"
            : "✗ Falha ao excluir usuário");
      } else {
        _addResult("✗ Falha ao criar usuário");
      }

      // Testa operações de Rótulo (Label).
      _addResult("\n--- Operações de Rótulo ---");
      final testLabel = Label(
        // Cria um rótulo de teste.
        name: "Test Label ${DateTime.now().millisecondsSinceEpoch}",
        description: "Created for testing",
      );

      final createdLabel =
          await local.label.createLabel(testLabel); // Cria o rótulo no banco.
      if (createdLabel != null) {
        _addResult("✓ Rótulo criado: ${createdLabel.name}");

        // Testa a recuperação do rótulo.
        final retrievedLabel = await local.label.getLabel(createdLabel.id!);
        _addResult(retrievedLabel != null
            ? "✓ Rótulo recuperado com sucesso"
            : "✗ Falha ao recuperar rótulo");

        // Testa a exclusão do rótulo.
        final deleteResult = await local.label.deleteLabel(createdLabel.id!);
        _addResult(deleteResult
            ? "✓ Rótulo excluído com sucesso"
            : "✗ Falha ao excluir rótulo");
      } else {
        _addResult("✗ Falha ao criar rótulo");
      }

      // Testa operações de Nota.
      _addResult("\n--- Operações de Nota ---");
      final testNote = Note(
        // Cria uma nota de teste.
        name: "Test Note ${DateTime.now().millisecondsSinceEpoch}",
        description: "Created for testing",
        status: NoteStatus.todo,
      );

      final createdNote =
          await local.note.createNote(testNote); // Cria a nota no banco.
      if (createdNote != null) {
        _addResult("✓ Nota criada: ${createdNote.name}");

        // Testa a recuperação da nota.
        final retrievedNote = await local.note.getNote(createdNote.id!);
        _addResult(retrievedNote != null
            ? "✓ Nota recuperada com sucesso"
            : "✗ Falha ao recuperar nota");

        // Testa a exclusão da nota.
        final deleteResult = await local.note.deleteNote(createdNote.id!);
        _addResult(deleteResult
            ? "✓ Nota excluída com sucesso"
            : "✗ Falha ao excluir nota");
      } else {
        _addResult("✗ Falha ao criar nota");
      }
    } catch (e) {
      _addResult("\n✗ Teste de operações básicas falhou: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  // Testa a funcionalidade de exportação do banco de dados.
  Future<void> _testDatabaseExport() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testando funcionalidade de exportação do banco de dados...");
      final local = widget.sourcesService.local;

      // Exporta o banco de dados.
      final exportedData = await exportDatabase(local.db);
      final sizeInKb =
          exportedData.lengthInBytes / 1024; // Calcula o tamanho em KB.

      _addResult("✓ Banco de dados exportado com sucesso");
      _addResult("- Tamanho da exportação: ${sizeInKb.toStringAsFixed(2)} KB");
      _addResult(
          "- Primeiros 10 bytes: ${exportedData.take(10).toList()}"); // Exibe os primeiros bytes para verificação.
    } catch (e) {
      _addResult("✗ Teste de exportação do banco de dados falhou: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  // Testa a funcionalidade de sincronização do banco de dados.
  Future<void> _testSynchronization() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testando sincronização do banco de dados...");

      // Verifica se a sincronização deve ocorrer.
      final shouldSync = await widget.sourcesService.shouldSync();
      _addResult("Deve sincronizar: $shouldSync");

      if (widget.sourcesService.remotes.isEmpty) {
        _addResult("Nenhum remoto configurado, pulando teste de sincronização");
      } else {
        _addResult("Iniciando sincronização manual...");
        await widget.sourcesService.synchronize(true); // Força a sincronização.
        _addResult(
            "Status da sincronização: ${widget.sourcesService.syncStatus.value}");
      }
    } catch (e) {
      _addResult("✗ Teste de sincronização falhou: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  // Testa os relacionamentos entre as entidades (User, Group, Note).
  Future<void> _testRelationships() async {
    _clearResults();
    setState(() {
      _isRunningTest = true;
    });

    try {
      _addResult("Testando relacionamentos entre entidades...");
      final local = widget.sourcesService.local;

      // Cria entidades de teste.
      _addResult("\nCriando entidades de teste...");

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
        _addResult("✓ Entidades de teste criadas com sucesso");

        // Testa o relacionamento Usuário-Grupo.
        await local.userGroup.connect(testGroup.id!, testUser.id!);
        final isUserInGroup =
            await local.userGroup.isConnected(testGroup.id!, testUser.id!);
        _addResult(isUserInGroup
            ? "✓ Relacionamento Usuário-Grupo criado com sucesso"
            : "✗ Falha ao criar relacionamento Usuário-Grupo");

        // Testa o relacionamento Usuário-Nota.
        await local.userNote.connect(testUser.id!, testNote.id!);
        final isUserConnectedToNote =
            await local.userNote.isConnected(testUser.id!, testNote.id!);
        _addResult(isUserConnectedToNote
            ? "✓ Relacionamento Usuário-Nota criado com sucesso"
            : "✗ Falha ao criar relacionamento Usuário-Nota");

        // Testa o relacionamento Grupo-Nota.
        await local.groupNote.connect(testGroup.id!, testNote.id!);
        final isGroupConnectedToNote =
            await local.groupNote.isConnected(testGroup.id!, testNote.id!);
        _addResult(isGroupConnectedToNote
            ? "✓ Relacionamento Grupo-Nota criado com sucesso"
            : "✗ Falha ao criar relacionamento Grupo-Nota");

        // Limpa as entidades de teste.
        _addResult("\nLimpando entidades de teste...");
        await local.userGroup.disconnect(testGroup.id!, testUser.id!);
        await local.userNote.disconnect(testUser.id!, testNote.id!);
        await local.groupNote.disconnect(testGroup.id!, testNote.id!);
        await local.user.deleteUser(testUser.id!);
        await local.group.deleteGroup(testGroup.id!);
        await local.note.deleteNote(testNote.id!);
        _addResult("✓ Limpeza concluída");
      } else {
        _addResult("✗ Falha ao criar entidades de teste");
      }
    } catch (e) {
      _addResult("✗ Teste de relacionamentos falhou: $e");
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constrói a interface do usuário para a página de teste.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Banco de Dados'), // Título da AppBar.
        actions: [
          // Botão para limpar os resultados dos testes.
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearResults,
            tooltip: 'Limpar resultados',
          ),
        ],
      ),
      body: Column(
        children: [
          // Área para exibir os resultados dos testes.
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                // Permite selecionar o texto dos resultados.
                _testResults.isEmpty
                    ? "Execute um teste para ver os resultados..."
                    : _testResults,
                style: const TextStyle(
                    fontFamily:
                        'monospace'), // Estilo monoespaçado para melhor leitura.
              ),
            ),
          ),
          const Divider(height: 1), // Divisor visual.
          // Área com botões para executar os diferentes testes.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              // Organiza os botões em múltiplas linhas se necessário.
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isRunningTest
                      ? null
                      : _testDatabaseConnection, // Desabilita se um teste estiver em execução.
                  child: const Text('Testar Conexão'),
                ),
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testBasicOperations,
                  child: const Text('Testar CRUD'),
                ),
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testDatabaseExport,
                  child: const Text('Testar Exportação'),
                ),
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testSynchronization,
                  child: const Text('Testar Sincronização'),
                ),
                ElevatedButton(
                  onPressed: _isRunningTest ? null : _testRelationships,
                  child: const Text('Testar Relacionamentos'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
