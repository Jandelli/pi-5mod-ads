import 'dart:io';
import 'package:flow/api/storage/remote/model.dart';
import 'package:flow/cubits/settings.dart';
import 'package:flow/cubits/flow.dart';
import 'package:flow/pages/sources/dialog.dart';
import 'package:flow/visualizer/storage.dart';
import 'package:flow/visualizer/sync.dart';
import 'package:flow/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:lw_sysapi/lw_sysapi.dart';
import 'package:collection/collection.dart';

import '../../api/storage/sources.dart';
import 'local.dart';

class SourcesPage extends StatelessWidget {
  const SourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowNavigation(
      title: AppLocalizations.of(context).sources,
      actions: [
        StreamBuilder<SyncStatus>(
            stream: context.read<SourcesService>().syncStatus,
            builder: (context, snapshot) {
              return IconButton(
                icon:
                    PhosphorIcon(snapshot.data.icon(PhosphorIconsStyle.light)),
                onPressed: () =>
                    context.read<SourcesService>().synchronize(true),
              );
            }),
      ],
      body: SingleChildScrollView(
        child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(children: [
                // Show current source in use
                BlocBuilder<FlowCubit, FlowState>(
                  builder: (context, state) {
                    final flowCubit = context.read<FlowCubit>();
                    final currentSources = flowCubit.getCurrentSources();
                    final sourcesService = context.read<SourcesService>();

                    String displayName = 'Nenhuma fonte selecionada';
                    IconData iconData = PhosphorIconsLight.warning;

                    if (currentSources.isNotEmpty) {
                      final currentSource = currentSources.first;

                      if (currentSource.isEmpty) {
                        // Main local database
                        displayName = 'Banco Local Principal';
                        iconData = PhosphorIconsLight.laptop;
                      } else {
                        // Check if it's an imported database
                        bool isImported = false;
                        for (int i = 0;
                            i < sourcesService.localDatabases.length;
                            i++) {
                          final dbService = sourcesService.localDatabases[i];
                          String dbFileName = '';
                          try {
                            dbFileName = dbService.db.path
                                .split(Platform.pathSeparator)
                                .last
                                .replaceAll('.db', '');
                          } catch (_) {}

                          if (dbFileName == currentSource) {
                            displayName =
                                sourcesService.localDatabaseNames.length > i
                                    ? sourcesService.localDatabaseNames[i]
                                    : 'Banco Importado ${i + 1}';
                            iconData = PhosphorIconsLight.database;
                            isImported = true;
                            break;
                          }
                        }

                        // If not imported, check if it's a remote source
                        if (!isImported) {
                          final remotes = sourcesService.getRemotes();
                          final remote = remotes.firstWhereOrNull(
                            (r) => r.identifier == currentSource,
                          );
                          if (remote != null) {
                            displayName = remote.displayName;
                            iconData = remote.icon(PhosphorIconsStyle.light);
                          } else {
                            displayName = 'Fonte Desconhecida';
                            iconData = PhosphorIconsLight.question;
                          }
                        }
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              PhosphorIcon(
                                PhosphorIconsLight.checkCircle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Fonte Atual',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              PhosphorIcon(iconData),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  displayName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(),
                // Show main local database
                ListTile(
                  title: Text(AppLocalizations.of(context).local),
                  leading: const PhosphorIcon(PhosphorIconsLight.laptop),
                  onTap: () {
                    // Show dialog for local database options
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(AppLocalizations.of(context).local),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text('Usar como fonte principal'),
                              leading:
                                  const PhosphorIcon(PhosphorIconsLight.check),
                              onTap: () {
                                // Switch to main local database
                                final flowCubit = context.read<FlowCubit>();
                                flowCubit.setSources(['']);

                                Navigator.of(context)
                                    .pop(); // Only close the dialog

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Agora usando: Banco Local Principal'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Configurações'),
                              leading:
                                  const PhosphorIcon(PhosphorIconsLight.gear),
                              onTap: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const LocalSourceDialog(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Show imported local databases
                AnimatedBuilder(
                  animation: context.watch<SourcesService>(),
                  builder: (context, child) {
                    final sourcesService = context.watch<SourcesService>();
                    final importedDatabases = sourcesService.localDatabases;
                    final localDatabaseNames =
                        sourcesService.localDatabaseNames;

                    if (importedDatabases.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                'Bancos Importados',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        ...importedDatabases.asMap().entries.map((entry) {
                          final index = entry.key;
                          final dbService = entry.value;
                          final displayName = localDatabaseNames.length > index
                              ? localDatabaseNames[index]
                              : 'Banco Importado ${index + 1}';

                          String underlyingDbFileName = 'unknown_filename';
                          try {
                            {
                              underlyingDbFileName = dbService.db.path
                                  .split(Platform.pathSeparator)
                                  .last
                                  .replaceAll('.db', '');
                            }
                          } catch (_) {
                            // Ignore if path is not available or other errors
                          }

                          return ListTile(
                            title: Text(displayName),
                            leading:
                                const PhosphorIcon(PhosphorIconsLight.database),
                            trailing: IconButton(
                              icon:
                                  const PhosphorIcon(PhosphorIconsLight.trash),
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Remover Banco'),
                                    content: Text(
                                        'Deseja remover este banco de dados importado?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text('Cancelar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text('Remover'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  sourcesService.removeImportedDatabase(index);
                                }
                              },
                            ),
                            onTap: () {
                              // Show options dialog for the imported database
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      displayName), // Use current display name
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title:
                                            Text('Usar como fonte principal'),
                                        leading: const PhosphorIcon(
                                            PhosphorIconsLight.check),
                                        onTap: () {
                                          // Switch to use this imported database as the current source
                                          final flowCubit =
                                              context.read<FlowCubit>();
                                          // Use the underlying filename as the consistent identifier
                                          flowCubit.setSources(
                                              [underlyingDbFileName]);

                                          Navigator.of(context)
                                              .pop(); // Close options dialog

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Agora usando: $displayName'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Renomear'),
                                        leading: const PhosphorIcon(
                                            PhosphorIconsLight.textT),
                                        onTap: () {
                                          // Get the database filename
                                          String dbFileNameToRename = 'unknown';
                                          try {
                                            dbFileNameToRename = dbService
                                                .db.path
                                                .split(Platform.pathSeparator)
                                                .last
                                                .replaceAll('.db', '');
                                          } catch (e) {
                                            // Handle error silently
                                          }

                                          // Close the options dialog
                                          Navigator.of(context).pop();

                                          // Perform rename using a simple callback approach
                                          _performRename(
                                              context,
                                              sourcesService,
                                              dbFileNameToRename);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('Exportar'),
                                        leading: const PhosphorIcon(
                                            PhosphorIconsLight.export),
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                          await _exportImportedDatabase(
                                              context, sourcesService, index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ],
                    );
                  },
                ),
                BlocBuilder<SettingsCubit, FlowSettings>(
                    builder: (context, state) {
                  final remotes = List<RemoteStorage>.from(state.remotes);
                  if (remotes.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              'Fontes Remotas',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) => ListView.builder(
                          shrinkWrap: true,
                          itemCount: remotes.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final remote = remotes[index];
                            return Dismissible(
                              key: ValueKey(remote),
                              onDismissed: (_) {
                                setState(() => remotes.removeAt(index));
                                context
                                    .read<SourcesService>()
                                    .removeRemote(remote.toFilename());
                              },
                              child: ListTile(
                                title: Text(remote.displayName),
                                leading: PhosphorIcon(
                                    remote.icon(PhosphorIconsStyle.light)),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ]),
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
            context: context, builder: (context) => const AddSourceDialog()),
        label: Text(AppLocalizations.of(context).create),
        icon: const PhosphorIcon(PhosphorIconsLight.plus),
      ),
    );
  }

  static Future<void> _exportImportedDatabase(
      BuildContext context, SourcesService sourcesService, int index) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Exportando banco de dados...'),
            ],
          ),
        ),
      );

      final bytes = await sourcesService.exportImportedDatabase(index);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        if (bytes != null) {
          final databaseName = sourcesService.localDatabaseNames.length > index
              ? sourcesService.localDatabaseNames[index]
              : 'imported_database_$index';

          await exportFile(
            context: context,
            fileName: databaseName,
            fileExtension: 'db',
            bytes: bytes,
            mimeType: 'application/x-sqlite3',
            uniformTypeIdentifier: 'public.database',
            label: 'Database',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Banco exportado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao exportar banco'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static void _performRename(BuildContext context,
      SourcesService sourcesService, String dbFileNameToRename) {
    // Use SchedulerBinding to ensure this runs after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.mounted) {
        await _showRenameDialog(context, sourcesService, dbFileNameToRename);
      }
    });
  }

  static Future<void> _showRenameDialog(BuildContext context,
      SourcesService sourcesService, String dbFileNameToRename) async {
    int index = -1;
    for (int i = 0; i < sourcesService.localDatabases.length; i++) {
      final dbService = sourcesService.localDatabases[i];
      String currentDbFileName = '';
      try {
        currentDbFileName = dbService.db.path
            .split(Platform.pathSeparator)
            .last
            .replaceAll('.db', '');
      } catch (_) {}

      if (currentDbFileName == dbFileNameToRename) {
        index = i;
        break;
      }
    }

    if (index == -1) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erro: Banco de dados não encontrado para renomear.')),
        );
      }
      return;
    }

    final controller = TextEditingController();
    final currentDisplayName = sourcesService.localDatabaseNames.length > index
        ? sourcesService.localDatabaseNames[index]
        : dbFileNameToRename;
    controller.text = currentDisplayName;

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Renomear Banco'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Nome do banco',
            hintText: 'Digite o novo nome',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text.trim());
            },
            child: Text('Renomear'),
          ),
        ],
      ),
    );

    if (newName != null &&
        newName.isNotEmpty &&
        newName != currentDisplayName) {
      // Perform the rename operation without waiting to avoid context issues
      sourcesService.renameImportedDatabase(index, newName);
    }
  }
}
