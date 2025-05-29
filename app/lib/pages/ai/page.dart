import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../blocs/ai/ai_bloc.dart';
import '../../models/ai/ai_models.dart';
import '../../widgets/ai/ai_summary_display.dart';
import '../../widgets/ai/api_key_config_dialog.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  AISummaryTimeframe _selectedTimeframe = AISummaryTimeframe.week;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo de IA'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.gear()),
            onPressed: _showSettings,
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: BlocBuilder<AiBloc, AiState>(
        builder: (context, state) {
          return switch (state) {
            AiInitial() => _buildInitialState(),
            AiLoading() => _buildLoadingState(state.message),
            AiLoaded() => _buildLoadedState(state.summary),
            AiError() => _buildErrorState(state.message, state.hasApiKey),
            AiApiKeyConfigured() => _buildConfiguredState(state.hasApiKey),
            _ => _buildInitialState(), // Default case for any other state
          };
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildLoadingState(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadedState(AISummaryResponse summary) {
    return AiSummaryDisplay(
      summary: summary,
      onRefresh: _generateSummary,
    );
  }

  Widget _buildErrorState(String message, bool hasApiKey) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.warning(),
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              'Ops! Algo deu errado',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (!hasApiKey)
              ElevatedButton.icon(
                onPressed: _configureApiKey,
                icon: Icon(PhosphorIcons.key()),
                label: const Text('Configurar API do OpenAI'),
              )
            else
              ElevatedButton.icon(
                onPressed: _generateSummary,
                icon: Icon(PhosphorIcons.arrowClockwise()),
                label: const Text('Tentar Novamente'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfiguredState(bool hasApiKey) {
    if (!hasApiKey) {
      return _buildWelcomeScreen();
    }

    return _buildGenerateScreen();
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.brain(),
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Bem-vindo ao Resumo de IA!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Obtenha insights inteligentes sobre suas atividades, eventos e notas. '
              'Configure sua chave da API do OpenAI para começar.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _configureApiKey,
              icon: Icon(PhosphorIcons.key()),
              label: const Text('Configurar API do OpenAI'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateScreen() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gerar Resumo Inteligente',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Selecione o período para análise:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildTimeframeSelector(),
                  if (_selectedTimeframe == AISummaryTimeframe.custom) ...[
                    const SizedBox(height: 16),
                    _buildCustomDatePicker(),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _generateSummary,
                      icon: Icon(PhosphorIcons.brain()),
                      label: const Text('Gerar Resumo com IA'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          PhosphorIcons.info(),
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Como funciona',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildInfoItem(
                            PhosphorIcons.database(),
                            'Coleta de Dados',
                            'Analisamos seus eventos, notas e tarefas do período selecionado.',
                          ),
                          _buildInfoItem(
                            PhosphorIcons.brain(),
                            'Processamento IA',
                            'Utilizamos inteligência artificial para criar insights personalizados.',
                          ),
                          _buildInfoItem(
                            PhosphorIcons.chartLine(),
                            'Análise Inteligente',
                            'Identificamos padrões, destaques e prioridades futuras.',
                          ),
                          _buildInfoItem(
                            PhosphorIcons.heart(),
                            'Motivação',
                            'Fornecemos uma mensagem motivacional baseada em seu progresso.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return Column(
      children: AISummaryTimeframe.values.map((timeframe) {
        return RadioListTile<AISummaryTimeframe>(
          title: Text(timeframe.displayName),
          value: timeframe,
          groupValue: _selectedTimeframe,
          onChanged: (value) {
            setState(() {
              _selectedTimeframe = value!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCustomDatePicker() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(true),
            icon: Icon(PhosphorIcons.calendar()),
            label: Text(
              _customStartDate != null
                  ? 'De: ${_formatDate(_customStartDate!)}'
                  : 'Data de Início',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDate(false),
            icon: Icon(PhosphorIcons.calendar()),
            label: Text(
              _customEndDate != null
                  ? 'Até: ${_formatDate(_customEndDate!)}'
                  : 'Data de Fim',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final initialDate = isStartDate ? _customStartDate : _customEndDate;
    final firstDate = DateTime.now().subtract(const Duration(days: 365));
    final lastDate = DateTime.now().add(const Duration(days: 365));

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _customStartDate = selectedDate;
        } else {
          _customEndDate = selectedDate;
        }
      });
    }
  }

  void _generateSummary() {
    context.read<AiBloc>().add(
          AiGenerateSummaryRequested(
            timeframe: _selectedTimeframe,
            customStartDate: _customStartDate,
            customEndDate: _customEndDate,
          ),
        );
  }

  void _configureApiKey() {
    showDialog(
      context: context,
      builder: (context) => const ApiKeyConfigDialog(),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildSettingsSheet(),
    );
  }

  Widget _buildSettingsSheet() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações do Resumo de IA',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: Icon(PhosphorIcons.key()),
            title: const Text('Configurar API do OpenAI'),
            subtitle: const Text('Alterar ou configurar sua chave da API'),
            onTap: () {
              Navigator.pop(context);
              _configureApiKey();
            },
          ),
          ListTile(
            leading: Icon(PhosphorIcons.trash()),
            title: const Text('Remover API Key'),
            subtitle: const Text('Excluir a chave da API armazenada'),
            onTap: () {
              Navigator.pop(context);
              _showRemoveApiKeyDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showRemoveApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover API Key'),
        content: const Text(
          'Tem certeza que deseja remover a chave da API do OpenAI? '
          'Você precisará configurá-la novamente para usar o resumo de IA.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AiBloc>().add(AiClearApiKeyRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
