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
                            subtitle:
                                Text(underlyingDbFileName), // Updated subtitle
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
                                          print('DEBUG: Rename button tapped!');

                                          // Get the database filename
                                          String dbFileNameToRename = 'unknown';
                                          try {
                                            dbFileNameToRename = dbService
                                                .db.path
                                                .split(Platform.pathSeparator)
                                                .last
                                                .replaceAll('.db', '');
                                            print(
                                                'DEBUG: Found dbFileNameToRename: $dbFileNameToRename');
                                          } catch (e) {
                                            print(
                                                'DEBUG: Error getting db filename: $e');
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

  static Future<void> _showRenameDialog(BuildContext context,
      SourcesService sourcesService, String dbFileNameToRename) async {
    print(
        'DEBUG: _showRenameDialog called with dbFileNameToRename: $dbFileNameToRename');

    int index = -1;
    for (int i = 0; i < sourcesService.localDatabases.length; i++) {
      final dbService = sourcesService.localDatabases[i];
      String currentDbFileName = '';
      try {
        {
          currentDbFileName = dbService.db.path
              .split(Platform.pathSeparator)
              .last
              .replaceAll('.db', '');
        }
      } catch (_) {}

      print(
          'DEBUG: Checking database $i: $currentDbFileName vs $dbFileNameToRename');
      if (currentDbFileName == dbFileNameToRename) {
        index = i;
        print('DEBUG: Found matching database at index $i');
        break;
      }
    }

    if (index == -1) {
      print('DEBUG: No matching database found for $dbFileNameToRename');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erro: Banco de dados "$dbFileNameToRename" não encontrado para renomear.')),
        );
      }
      return;
    }

    print('DEBUG: Found database at index $index, showing rename dialog');

    final controller = TextEditingController();
    // Use the display name from localDatabaseNames for the current name in the dialog
    final currentDisplayName = sourcesService.localDatabaseNames.length > index
        ? sourcesService.localDatabaseNames[index]
        // Fallback to the filename if display name isn't available for some reason (should not happen)
        : dbFileNameToRename;
    controller.text = currentDisplayName;

    print('DEBUG: Current display name: $currentDisplayName');

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
              print(
                  'DEBUG: Save button pressed with text: ${controller.text.trim()}');
              Navigator.of(context).pop(controller.text.trim());
            },
            child: Text('Renomear'),
          ),
        ],
      ),
    );

    print('DEBUG: Dialog returned newName: $newName');

    if (newName != null &&
        newName.isNotEmpty &&
        newName != currentDisplayName) {
      print(
          'DEBUG: Proceeding with rename operation: "$currentDisplayName" -> "$newName"');

      // Check if context is still mounted before showing loading dialog
      if (!context.mounted) {
        print('DEBUG: Context is no longer mounted, aborting rename operation');
        return;
      }

      try {
        // Show loading indicator with a separate navigator context
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => WillPopScope(
            onWillPop: () async => false,
            child: const AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Renomeando banco de dados...'),
                ],
              ),
            ),
          ),
        );

        print(
            'DEBUG: Calling sourcesService.renameImportedDatabase with index $index and name "$newName"');
        final success = await sourcesService.renameImportedDatabase(
            index, newName); // Pass the found index

        print('DEBUG: Rename operation result: $success');

        // Check if context is still mounted before closing dialog and showing snackbar
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success
                  ? 'Banco renomeado para: $newName'
                  : 'Erro ao renomear banco'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        } else {
          print('DEBUG: Context no longer mounted after rename operation');
        }
      } catch (e) {
        print('DEBUG: Exception during rename: $e');
        // Check if context is still mounted before showing error
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog if open
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao renomear: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          print('DEBUG: Context no longer mounted when handling exception');
        }
      }
    } else {
      print(
          'DEBUG: Not proceeding with rename - newName: "$newName", currentDisplayName: "$currentDisplayName"');
    }
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

  static Future<void> _showRenameDialogDirect(BuildContext context,
      SourcesService sourcesService, String dbFileNameToRename) async {
    print(
        'DEBUG: _showRenameDialogDirect called with dbFileNameToRename: $dbFileNameToRename');

    int index = -1;
    for (int i = 0; i < sourcesService.localDatabases.length; i++) {
      final dbService = sourcesService.localDatabases[i];
      String currentDbFileName = '';
      try {
        {
          currentDbFileName = dbService.db.path
              .split(Platform.pathSeparator)
              .last
              .replaceAll('.db', '');
        }
      } catch (_) {}

      print(
          'DEBUG: Checking database $i: $currentDbFileName vs $dbFileNameToRename');
      if (currentDbFileName == dbFileNameToRename) {
        index = i;
        print('DEBUG: Found matching database at index $i');
        break;
      }
    }

    if (index == -1) {
      print('DEBUG: No matching database found for $dbFileNameToRename');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Erro: Banco de dados "$dbFileNameToRename" não encontrado para renomear.')),
        );
      }
      return;
    }

    print('DEBUG: Found database at index $index, showing rename dialog');

    final controller = TextEditingController();
    // Use the display name from localDatabaseNames for the current name in the dialog
    final currentDisplayName = sourcesService.localDatabaseNames.length > index
        ? sourcesService.localDatabaseNames[index]
        // Fallback to the filename if display name isn't available for some reason (should not happen)
        : dbFileNameToRename;
    controller.text = currentDisplayName;

    print('DEBUG: Current display name: $currentDisplayName');

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
              print(
                  'DEBUG: Save button pressed with text: ${controller.text.trim()}');
              Navigator.of(context).pop(controller.text.trim());
            },
            child: Text('Renomear'),
          ),
        ],
      ),
    );

    print('DEBUG: Dialog returned newName: $newName');

    if (newName != null &&
        newName.isNotEmpty &&
        newName != currentDisplayName) {
      print(
          'DEBUG: Proceeding with rename operation: "$currentDisplayName" -> "$newName"');

      // Check if context is still mounted before showing loading dialog
      if (!context.mounted) {
        print('DEBUG: Context is no longer mounted, aborting rename operation');
        return;
      }

      try {
        // Show loading indicator with a separate navigator context
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => WillPopScope(
            onWillPop: () async => false,
            child: const AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Renomeando banco de dados...'),
                ],
              ),
            ),
          ),
        );

        print(
            'DEBUG: Calling sourcesService.renameImportedDatabase with index $index and name "$newName"');
        final success = await sourcesService.renameImportedDatabase(
            index, newName); // Pass the found index

        print('DEBUG: Rename operation result: $success');

        // Check if context is still mounted before closing dialog and showing snackbar
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success
                  ? 'Banco renomeado para: $newName'
                  : 'Erro ao renomear banco'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        } else {
          print('DEBUG: Context no longer mounted after rename operation');
        }
      } catch (e) {
        print('DEBUG: Exception during rename: $e');
        // Check if context is still mounted before showing error
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog if open
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao renomear: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          print('DEBUG: Context no longer mounted when handling exception');
        }
      }
    } else {
      print(
          'DEBUG: Not proceeding with rename - newName: "$newName", currentDisplayName: "$currentDisplayName"');
    }
  }

  static void _performRename(BuildContext context,
      SourcesService sourcesService, String dbFileNameToRename) {
    print(
        'DEBUG: _performRename called with dbFileNameToRename: $dbFileNameToRename');

    // Use SchedulerBinding to ensure this runs after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.mounted) {
        print('DEBUG: Context is mounted, proceeding with rename');
        await _showRenameDialogSimple(
            context, sourcesService, dbFileNameToRename);
      } else {
        print('DEBUG: Context is not mounted in _performRename');
      }
    });
  }

  static Future<void> _showRenameDialogSimple(BuildContext context,
      SourcesService sourcesService, String dbFileNameToRename) async {
    print(
        'DEBUG: _showRenameDialogSimple called with dbFileNameToRename: $dbFileNameToRename');

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

      print(
          'DEBUG: Checking database $i: $currentDbFileName vs $dbFileNameToRename');
      if (currentDbFileName == dbFileNameToRename) {
        index = i;
        print('DEBUG: Found matching database at index $i');
        break;
      }
    }

    if (index == -1) {
      print('DEBUG: No matching database found for $dbFileNameToRename');
      return;
    }

    print('DEBUG: Found database at index $index, showing rename dialog');

    final controller = TextEditingController();
    final currentDisplayName = sourcesService.localDatabaseNames.length > index
        ? sourcesService.localDatabaseNames[index]
        : dbFileNameToRename;
    controller.text = currentDisplayName;

    print('DEBUG: Current display name: $currentDisplayName');

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
              final text = controller.text.trim();
              print('DEBUG: Save button pressed with text: $text');
              Navigator.of(context).pop(text);
            },
            child: Text('Renomear'),
          ),
        ],
      ),
    );

    print('DEBUG: Dialog returned newName: $newName');

    if (newName != null &&
        newName.isNotEmpty &&
        newName != currentDisplayName) {
      print(
          'DEBUG: Proceeding with rename operation: "$currentDisplayName" -> "$newName"');

      // Perform the rename operation synchronously without await to avoid context issues
      _performActualRename(sourcesService, index, newName, currentDisplayName);
    } else {
      print(
          'DEBUG: Not proceeding with rename - newName: "$newName", currentDisplayName: "$currentDisplayName"');
    }
  }

  static void _performActualRename(SourcesService sourcesService, int index,
      String newName, String currentDisplayName) {
    print(
        'DEBUG: _performActualRename called with index: $index, newName: $newName');

    // Perform the rename operation without waiting for the result
    sourcesService.renameImportedDatabase(index, newName).then((success) {
      print('DEBUG: Rename operation completed with result: $success');
      // The SourcesService will handle notifying listeners, so the UI will update automatically
    }).catchError((error) {
      print('DEBUG: Rename operation failed with error: $error');
    });
  }
}
