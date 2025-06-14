import 'package:flow/blocs/sourced_paging.dart';
import 'package:flow/pages/notes/navigator/drawer.dart';
import 'package:flow/pages/notes/note.dart';
import 'package:flow/widgets/navigation.dart';
import 'package:flow_api/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'dart:typed_data';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flow_api/models/note/model.dart';
import 'package:flow_api/models/model.dart';

import '../../cubits/flow.dart';
import 'filter.dart';
import 'details.dart';

class NotesPage extends StatelessWidget {
  final NoteFilter filter;
  final SourcedModel<Uint8List>? parent;

  const NotesPage({
    super.key,
    this.parent,
    this.filter = const NoteFilter(),
  });

  @override
  Widget build(BuildContext context) {
    return NotesBodyView(
      search:
          '', // Assuming search is handled by _NotesSearchDelegate pushing a new NotesBodyView
      filter: filter,
      parent: parent,
      onParentNoteDeleted: parent != null
          ? () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
          : null,
    );
  }
}

class _NotesSearchDelegate extends SearchDelegate {
  final NoteFilter filter;
  final SourcedModel<Uint8List>? parent;

  _NotesSearchDelegate(this.filter, this.parent);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const PhosphorIcon(PhosphorIconsLight.x),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const PhosphorIcon(PhosphorIconsLight.arrowLeft),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return NotesBodyView(
      search: query,
      filter: filter,
      parent: parent,
      showAppBar: false,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class NotesBodyView extends StatefulWidget {
  final String search;
  final NoteFilter filter;
  final SourcedModel<Uint8List>? parent;
  final bool showAppBar;
  final VoidCallback? onParentNoteDeleted; // Added callback

  const NotesBodyView({
    super.key,
    this.search = '',
    this.filter = const NoteFilter(),
    this.parent,
    this.showAppBar = true,
    this.onParentNoteDeleted, // Added callback
  });

  @override
  State<NotesBodyView> createState() => _NotesBodyViewState();
}

class _NotesBodyViewState extends State<NotesBodyView> {
  late final FlowCubit _flowCubit;
  late final SourcedPagingBloc<Note> _bloc;
  late Future<Note?> _parent; // Not final, to be updated
  late NoteFilter _filter;

  @override
  void initState() {
    super.initState();
    _flowCubit = context.read<FlowCubit>();
    _parent = _fetchParent(); // Initialize _parent
    _bloc = SourcedPagingBloc.item(
        cubit: _flowCubit,
        fetch: (source, service, offset, limit) async {
          if (_filter.source != null && _filter.source != source) return null;
          final notes = _filter.selectedLabel != null
              ? await service.labelNote?.getItems(
                  _filter.selectedLabel!,
                  offset: offset,
                  limit: limit,
                  notebook: _filter.notebook,
                  statuses: _filter.statuses,
                  parent: widget.parent?.source == source
                      ? widget.parent?.model
                      : createEmptyUint8List(),
                  search: widget.search,
                )
              : await service.note?.getNotes(
                  offset: offset,
                  limit: limit,
                  notebook: _filter.notebook,
                  statuses: _filter.statuses,
                  parent: widget.parent?.source == source
                      ? widget.parent?.model
                      : createEmptyUint8List(),
                  search: widget.search);
          if (notes == null) return null;
          if (source != widget.parent?.source) return notes;
          return notes;
        });
    _filter = widget.filter;
  }

  Future<Note?> _fetchParent() async {
    if (widget.parent == null) return null;
    final parentNote = await _flowCubit
        .getService(widget.parent!.source)
        .note
        ?.getNote(widget.parent!.model);
    return parentNote;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant NotesBodyView oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsBlocRefresh = false;

    if (oldWidget.search != widget.search) {
      needsBlocRefresh = true;
    }

    if (oldWidget.parent != widget.parent) {
      setState(() {
        // Update _parent future when widget.parent changes
        _parent = _fetchParent();
      });
      needsBlocRefresh = true;
    }

    if (oldWidget.filter != widget.filter) {
      setState(() {
        _filter = widget.filter;
      });
      needsBlocRefresh = true;
    }

    if (needsBlocRefresh) {
      _bloc.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlowNavigation(
      title: widget.showAppBar ? AppLocalizations.of(context).notes : null,
      endDrawer: NotesNavigatorDrawer(
        note: widget.parent?.model,
        filter: _filter,
        bloc: _bloc,
        isSearching: widget.search.isNotEmpty,
        onFilterChanged: (value) {
          setState(() {
            _filter = value;
            _bloc.refresh();
          });
        },
      ),
      actions: [
        IconButton(
          icon: const PhosphorIcon(PhosphorIconsLight.magnifyingGlass),
          onPressed: () => showSearch(
            context: context,
            delegate: _NotesSearchDelegate(
              _filter,
              widget.parent,
            ),
          ),
        ),
      ],
      body: Column(
        children: [
          NoteFilterView(
            initialFilter: _filter,
            onChanged: (filter) {
              setState(() {
                _filter = filter;
                _bloc.refresh();
              });
            },
          ),
          FutureBuilder<Note?>(
              future: _parent,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data == null) return Container();
                return Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    NoteDetailsView(
                      bloc: _bloc,
                      source: widget.parent!.source,
                      note: data,
                      onNoteDeleted:
                          widget.onParentNoteDeleted, // Pass the callback
                    ),
                  ],
                );
              }),
          if (widget.parent == null || widget.search.isNotEmpty) ...[
            const SizedBox(height: 8),
            Expanded(
              child: NotesListView(
                bloc: _bloc,
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<SourcedModel<Note>>(
            context: context,
            builder: (context) => NoteDialog(
                  note: Note(
                    parentId: widget.parent?.model,
                    notebookId: _filter.notebook,
                  ),
                  source: widget.parent
                      ?.source, // Changed: Do not fallback to _filter.source
                  create: true,
                )).then((newlyCreatedSourcedNote) {
          _bloc.refresh();
        }),
        label: Text(AppLocalizations.of(context).create),
        icon: const PhosphorIcon(PhosphorIconsLight.plus),
      ),
    );
  }
}
