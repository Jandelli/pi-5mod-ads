import 'package:flow/cubits/settings.dart';
import 'main_test.dart'; // Importa o widget de entrada para os testes.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa o Provider para gerenciamento de estado.
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences para persistência de dados.

// Função principal da aplicação de teste do banco de dados.
void main() async {
  // Garante que o Flutter esteja inicializado antes de executar código assíncrono.
  WidgetsFlutterBinding.ensureInitialized();

  // Obtém uma instância de SharedPreferences.
  final prefs = await SharedPreferences.getInstance();

  // Executa a aplicação de teste, passando a instância de SharedPreferences.
  runApp(DatabaseTestApp(prefs: prefs));
}

// Define o widget principal da aplicação de teste do banco de dados.
class DatabaseTestApp extends StatelessWidget {
  final SharedPreferences prefs; // Instância de SharedPreferences.

  const DatabaseTestApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    // Utiliza MultiProvider para fornecer dependências à árvore de widgets.
    return MultiProvider(
      providers: [
        // Fornece uma instância de SettingsCubit, inicializada com SharedPreferences.
        Provider<SettingsCubit>(
          create: (_) => SettingsCubit(prefs),
        ),
      ],
      // Define o MaterialApp, que é a raiz da interface do usuário.
      child: MaterialApp(
        title: 'Flow Database Testing', // Título da aplicação.
        theme: ThemeData(
          // Define o tema da aplicação.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true, // Habilita o Material 3.
        ),
        home:
            const TestingEntry(), // Define o widget de entrada como a tela inicial.
      ),
    );
  }
}
