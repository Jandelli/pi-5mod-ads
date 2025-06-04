import 'package:file_selector/file_selector.dart';
import 'package:flow/cubits/flow.dart';
import 'package:flow/pages/sources/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flow_api/converters/ical.dart';
import '../../api/storage/sources.dart';

class AddSourceDialog extends StatelessWidget {
  const AddSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).addSource),
      content: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 500,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Divider(),
                ListTile(
                    title: Text(AppLocalizations.of(context).importFile),
                    subtitle: Text(
                        AppLocalizations.of(context).importFileDescription),
                    leading: const PhosphorIcon(PhosphorIconsLight.file),
                    onTap: () async {
                      final cubit = context.read<FlowCubit>();
                      final result = await openFile(
                        acceptedTypeGroups: [
                          XTypeGroup(
                            extensions: ['ics', 'ical', 'icalendar'],
                            label: 'iCal',
                            uniformTypeIdentifiers: ['public.ics'],
                            mimeTypes: ['text/calendar'],
                          ),
                          XTypeGroup(
                            extensions: ['db'],
                            label: 'Database',
                            uniformTypeIdentifiers: ['public.database'],
                            mimeTypes: ['application/x-sqlite3'],
                          )
                        ],
                      );
                      if (result == null) return;

                      final extension =
                          result.name.split('.').last.toLowerCase();

                      if (context.mounted) {
                        if (extension == 'db') {
                          await _importDatabase(context, result);
                        } else {
                          await _importICalFile(context, cubit, result);
                        }
                      }

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }),
              ]),
        ),
      ),
      scrollable: true,
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel))
      ],
    );
  }

  Future<void> _importDatabase(BuildContext context, XFile file) async {
    // Show a confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).confirmImport),
        content:
            Text('Você tem certeza que deseja importar esse banco de dados?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).import),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Importando banco de dados...'),
              ],
            ),
          ),
        );
      }

      // Read the file
      final bytes = await file.readAsBytes();

      // Import the database using the new method
      final sourcesService = context.read<SourcesService>();
      final importedDbName =
          await sourcesService.importDatabase(bytes, file.name);

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (importedDbName != null) {
        // Show success dialog with option to switch to the new database
        if (context.mounted) {
          final shouldSwitch = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Importado com Sucesso'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('O banco de dados foi importado com sucesso.'),
                  const SizedBox(height: 16),
                  Text('Deseja usar este banco de dados como fonte principal?'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Não'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Sim'),
                ),
              ],
            ),
          );

          if (shouldSwitch == true) {
            // Switch to the imported database as the current source
            // This would typically involve updating the FlowCubit or similar state management
            // For now, we'll just show a message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Banco de dados importado está disponível nas fontes'),
                ),
              );
            }
          }
        }
      } else {
        // Show error dialog
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Erro na Importação'),
              content: Text(
                  'Ocorreu um erro ao importar o banco de dados. Verifique se o arquivo é válido.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context).close),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if it's open
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro na Importação'),
            content: Text('Erro: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).close),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _importICalFile(
      BuildContext context, FlowCubit cubit, XFile result) async {
    final data = await result.readAsString();
    final lines = data.split('\n');
    final converter = ICalConverter();
    converter.read(lines);
    final events = converter.data?.events ?? [];
    final items = converter.data?.items ?? [];

    if (context.mounted) {
      final success = await showDialog<bool>(
        context: context,
        builder: (context) => ImportDialog(events: events, items: items),
      );

      if (success != true) return;

      final service = cubit.getCurrentService().event;
      await Future.wait(
          events.map((event) async => service?.createEvent(event)));
      await Future.wait(items.map((item) async =>
          cubit.getCurrentService().calendarItem?.createCalendarItem(item)));
    }
  }
}
