import 'package:flow/api/storage/sources.dart';
import 'package:flow/cubits/settings.dart';
import 'db_test.dart'; // Importa a página de teste do banco de dados.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart'; // Importa o Provider para gerenciamento de estado.

// Adiciona a função main para o teste Flutter.
void main() {
  // Define um teste simples para verificar a configuração do arquivo de teste.
  test('Test for main_test', () {
    // Verifica se 'true' é de fato 'true'. Um teste básico de sanidade.
    expect(true, isTrue);
  });
}

// Define um widget de entrada para os testes, responsável por configurar dependências.
class TestingEntry extends StatelessWidget {
  const TestingEntry({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtém o SettingsCubit do contexto usando Provider.
    final settingsCubit = context.read<SettingsCubit>();
    // Cria uma instância de SourcesService, injetando o SettingsCubit.
    final sourcesService = SourcesService(settingsCubit);

    // Utiliza FutureBuilder para aguardar a configuração do SourcesService.
    return FutureBuilder(
      future: sourcesService
          .setup(), // Futuro que representa a conclusão da configuração.
      builder: (context, snapshot) {
        // Verifica o estado da conexão do Future.
        if (snapshot.connectionState == ConnectionState.done) {
          // Se a configuração estiver concluída, exibe a DatabaseTestPage.
          return DatabaseTestPage(sourcesService: sourcesService);
        } else {
          // Caso contrário, exibe um indicador de progresso.
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
