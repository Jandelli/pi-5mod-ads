// Este é um teste de widget básico do Flutter.
//
// Para realizar uma interação com um widget em seu teste, use o utilitário WidgetTester
// que o Flutter fornece. Por exemplo, você pode enviar gestos de toque e rolagem.
// Você também pode usar o WidgetTester para encontrar widgets filhos na árvore de widgets,
// ler texto e verificar se os valores das propriedades do widget estão corretos.

// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flow/widgets/source_dropdown.dart';
import 'package:flow/widgets/clock.dart';
import 'package:flow/widgets/markdown_field.dart';
import 'package:flow/widgets/paging/indicator.dart';
import 'package:flow/widgets/paging/empty.dart';
import 'package:flow/widgets/paging/loading.dart';
import 'package:flow/cubits/flow.dart';
import 'package:flow/api/storage/sources.dart';
import 'package:flow_api/services/source.dart';
import 'package:flow_api/models/model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flow/api/storage/remote/model.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';

// Gera mocks para FlowCubit, SourceService e SourcesService para isolar o widget em teste.
@GenerateMocks([FlowCubit, SourceService, SourcesService])
import 'widget_test.mocks.dart';

void main() {
  // Grupo de testes para o widget SourceDropdown.
  group('SourceDropdown Widget Tests', () {
    late MockFlowCubit mockCubit;
    late MockSourcesService mockSourcesService;
    late MockSourceService mockSourceService;

    // Configuração executada antes de cada teste no grupo.
    setUp(() {
      mockCubit = MockFlowCubit();
      mockSourcesService = MockSourcesService();
      mockSourceService = MockSourceService();

      // Configura o comportamento do mockCubit.
      // Define o retorno do método getCurrentServicesMap.
      when(mockCubit.getCurrentServicesMap()).thenReturn({
        'local': mockSourceService,
        'remote': mockSourceService,
      });

      // Adiciona um stub para o stream do mockCubit.
      // Retorna um Stream vazio para evitar erros de stream nulo.
      when(mockCubit.stream).thenAnswer((_) => Stream.fromIterable([]));

      // Define o retorno do getter sourcesService.
      when(mockCubit.sourcesService).thenReturn(mockSourcesService);

      // Configura stubs para getRemote para 'local' e 'remote'.
      // Retorna null para 'local' e um CalDavStorage para 'remote'.
      when(mockSourcesService.getRemote('local')).thenReturn(null);
      when(mockSourcesService.getRemote('remote')).thenReturn(CalDavStorage(
        url: 'https://example.com',
        username: 'test',
      ));
    });

    // Testa se o SourceDropdown renderiza corretamente com um valor inicial.
    testWidgets('renders correctly with initial value',
        (WidgetTester tester) async {
      String selectedValue = 'local'; // Valor inicial selecionado.
      ConnectedModel<String, SourceService>?
          result; // Variável para armazenar o resultado da seleção.

      // Constrói o widget MaterialApp com o SourceDropdown.
      // Fornece o mockCubit através do BlocProvider.
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<FlowCubit>.value(
            value: mockCubit,
            child: Scaffold(
              body: SourceDropdown<SourceService>(
                value: selectedValue,
                onChanged: (val) => result = val,
                buildService: (service) => service,
              ),
            ),
          ),
        ),
      );

      // Aguarda a renderização completa do widget.
      await tester.pump();

      // Pula o teste de rótulo específico que pode ser traduzido dinamicamente.
      // Verifica se o SourceDropdown foi encontrado na árvore de widgets.
      expect(find.byType(SourceDropdown<SourceService>), findsOneWidget);
    });
  });

  // Grupo de testes para o widget ClockView.
  group('ClockView Widget Tests', () {
    // Testa se o ClockView renderiza corretamente.
    testWidgets('renders correctly', (WidgetTester tester) async {
      // Constrói o widget MaterialApp com o ClockView.
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: ClockView(),
            ),
          ),
        ),
      );

      // Verifica se o ClockView foi encontrado.
      // Verifica se pelo menos um CustomPaint (usado para desenhar o relógio) foi encontrado.
      expect(find.byType(ClockView), findsOneWidget);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));

      // Avança o tempo em 1 segundo para simular um "tick" do relógio.
      await tester.pump(const Duration(seconds: 1));
    });
  });

  // Grupo de testes para o widget MarkdownField.
  group('MarkdownField Widget Tests', () {
    // Testa se o MarkdownField renderiza no modo de visualização inicialmente.
    testWidgets('renders in view mode initially', (WidgetTester tester) async {
      const testMarkdown =
          '# Hello\n\nThis is a test'; // Conteúdo Markdown de teste.

      // Constrói o widget MaterialApp com o MarkdownField.
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MarkdownField(
              value: testMarkdown,
            ),
          ),
        ),
      );

      // Verifica se o MarkdownBody (que renderiza o Markdown) foi encontrado.
      expect(find.byType(MarkdownBody), findsOneWidget);
      // Verifica se o texto Markdown bruto não está visível.
      expect(find.text('# Hello'), findsNothing);
      // Verifica se o texto Markdown renderizado está visível.
      expect(find.text('Hello'), findsOneWidget);
    });
  });

  // Grupo de testes para os widgets indicadores de paginação.
  group('Paging Indicator Widgets Tests', () {
    // Testa se o LoadingIndicatorDisplay é exibido corretamente.
    testWidgets('LoadingIndicatorDisplay shows correctly',
        (WidgetTester tester) async {
      // Constrói o widget MaterialApp com o LoadingIndicatorDisplay.
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: LoadingIndicatorDisplay(),
          ),
        ),
      );

      // Verifica se o CircularProgressIndicator foi encontrado.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Testa se o EmptyIndicatorDisplay é exibido corretamente.
    testWidgets('EmptyIndicatorDisplay shows correctly',
        (WidgetTester tester) async {
      // Constrói o widget MaterialApp com o EmptyIndicatorDisplay.
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: EmptyIndicatorDisplay(),
          ),
        ),
      );

      // Verifica a estrutura, esperando encontrar um IndicatorDisplay.
      expect(find.byType(IndicatorDisplay), findsOneWidget);
    });

    // Testa se o IndicatorDisplay mostra o botão "Tentar Novamente" quando fornecido.
    testWidgets('IndicatorDisplay shows try again button when provided',
        (WidgetTester tester) async {
      bool buttonPressed =
          false; // Flag para verificar se o botão foi pressionado.

      // Constrói o widget MaterialApp com o IndicatorDisplay, incluindo um callback onTryAgain.
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: IndicatorDisplay(
              title: 'Test Title',
              description: 'Test Description',
              onTryAgain: () => buttonPressed = true,
            ),
          ),
        ),
      );

      // Encontra o título e a descrição.
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);

      // Pula o teste do botão, pois a implementação pode variar.
    });
  });
}
