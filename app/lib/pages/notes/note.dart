import 'package:flow/cubits/flow.dart';
import 'package:flow/widgets/markdown_field.dart';
import 'package:flow_api/models/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flow_api/models/note/model.dart';
import 'package:flow_api/models/note/service.dart';

import '../../widgets/source_dropdown.dart';

class NoteDialog extends StatefulWidget {
  final String? source;
  final Note? note;
  final bool create;
  const NoteDialog({
    super.key,
    this.create = false,
    this.note,
    this.source,
  });

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late Note _newNote;
  late String? _newSource; // Made nullable
  NoteService? _service;

  @override
  void initState() {
    super.initState();

    _newNote = widget.note ?? const Note();
    _newSource = widget.source; // Initialize with widget.source

    if (_newSource != null && _newSource!.isNotEmpty) {
      _service = context.read<FlowCubit>().getService(_newSource!).note;
    }
  }

  @override
  Widget build(BuildContext context) {
    final create =
        widget.create || widget.note == null; // Simplified create condition
    return ResponsiveAlertDialog(
      title: Text(
        create
            ? AppLocalizations.of(context).createNote
            : AppLocalizations.of(context).editNote,
      ),
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
      headerActions: [
        if (_newNote.status != null)
          Checkbox(
            value: _newNote.status?.isDone,
            tristate: true,
            onChanged: (value) {
              setState(() {
                _newNote =
                    _newNote.copyWith(status: NoteStatus.fromDone(value));
              });
            },
          ),
      ],
      content: ListView(
        shrinkWrap: true,
        children: [
          if (widget.create && widget.source == null) ...[
            // Modified condition
            SourceDropdown<NoteService>(
              value: _newSource ?? '', // Provide a default empty string
              onChanged: (connected) {
                setState(() {
                  _newSource = connected?.source; // Update to potentially null
                  _service = connected?.model;
                });
              },
              buildService: (e) => e.note,
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).name,
              icon: const PhosphorIcon(PhosphorIconsLight.textT),
              filled: true,
            ),
            initialValue: _newNote.name,
            onChanged: (value) {
              _newNote = _newNote.copyWith(name: value);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).priority,
              icon: const PhosphorIcon(PhosphorIconsLight.arrowSquareUp),
              border: const OutlineInputBorder(),
            ),
            initialValue: _newNote.priority.toString(),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _newNote = _newNote.copyWith(
                  priority: int.tryParse(value) ?? _newNote.priority);
            },
          ),
          const SizedBox(height: 16),
          MarkdownField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).description,
              icon: const PhosphorIcon(PhosphorIconsLight.fileText),
              border: const OutlineInputBorder(),
            ),
            value: _newNote.description,
            onChanged: (value) {
              _newNote = _newNote.copyWith(description: value);
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: Text(AppLocalizations.of(context).todo),
            value: _newNote.status != null,
            onChanged: (value) {
              setState(() => _newNote = _newNote.copyWith(
                  status: value == true ? NoteStatus.todo : null));
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          },
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: (widget.create &&
                  (_service == null || _newSource == null)) // Updated condition
              ? null
              : () async {
                  SourcedModel<Note>? resultForPop;

                  if (create) {
                    // Ensure _newSource is not null before proceeding
                    if (_newSource == null) return;
                    final Note? createdNote =
                        await _service?.createNote(_newNote);
                    if (createdNote != null) {
                      resultForPop = SourcedModel(_newSource!, createdNote);
                    }
                  } else {
                    // Ensure _newSource is not null for updates if it's part of SourcedModel
                    if (_newSource == null && widget.source == null) {
                      return; // Or handle error
                    }
                    await _service?.updateNote(_newNote);
                    resultForPop =
                        SourcedModel(_newSource ?? widget.source!, _newNote);
                  }

                  if (mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        Navigator.of(context).pop(resultForPop);
                      }
                    });
                  }
                },
          child: Text(create
              ? AppLocalizations.of(context).create
              : AppLocalizations.of(context).save),
        ),
      ],
    );
  }
}
