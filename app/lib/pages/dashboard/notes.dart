import 'package:flow/pages/notes/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flow_api/models/note/model.dart';

import '../../cubits/flow.dart';

class DashboardNotesView extends StatefulWidget {
  const DashboardNotesView({super.key});

  @override
  State<DashboardNotesView> createState() => _DashboardNotesViewState();
}

class _DashboardNotesViewState extends State<DashboardNotesView> {
  late Future<List<(Note, String)>> _notesFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _notesFuture = _getNotes(context);
    });
  }

  Future<List<(Note, String)>> _getNotes(BuildContext context) async {
    final sources = context.read<FlowCubit>().getCurrentServicesMap();
    final notes = <(Note, String)>[];

    try {
      for (final source in sources.entries) {
        if (source.value.note != null) {
          try {
            final sourceNotes =
                await source.value.note?.getNotes(limit: 5) ?? [];
            notes.addAll(sourceNotes.map((e) => (e, source.key)).toList());
          } catch (e) {
            debugPrint('Error fetching notes for source ${source.key}: $e');
          }
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return notes;
    } catch (e) {
      debugPrint('Error fetching notes: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return [];
    }
  }

  @override
  void didUpdateWidget(covariant DashboardNotesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    refreshData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context).notes,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsLight.arrowSquareOut),
              onPressed: () => GoRouter.of(context).go('/notes'),
            ),
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsLight.arrowClockwise),
              onPressed: refreshData,
              tooltip: 'Atualizar Notas',
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: FutureBuilder<List<(Note, String)>>(
              future: _notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done ||
                    _isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error loading notes: ${snapshot.error}',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          onPressed: refreshData,
                        ),
                      ],
                    ),
                  );
                }
                final notes = snapshot.data ?? <(Note, String)>[];
                if (notes.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).indicatorEmpty,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                return ListView(
                  children: notes
                      .map((e) => NoteListTile(
                            note: e.$1,
                            source: e.$2,
                          ))
                      .toList(),
                );
              }),
        ),
      ],
    );
  }
}
