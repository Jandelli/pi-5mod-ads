import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'dart:typed_data';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flow_api/models/group/model.dart';
import 'package:flow_api/models/model.dart';

import '../groups/select.dart';

part 'filter.mapper.dart';

@MappableClass()
class UserFilter with UserFilterMappable {
  final String? source;
  final Uint8List? group;

  const UserFilter({
    this.source,
    this.group,
  });
}

class UserFilterView extends StatefulWidget {
  final UserFilter? initialFilter;
  final ValueChanged<UserFilter> onChanged;
  const UserFilterView(
      {super.key, this.initialFilter, required this.onChanged});

  @override
  State<UserFilterView> createState() => _UserFilterViewState();
}

class _UserFilterViewState extends State<UserFilterView> {
  final ScrollController _scrollController = ScrollController();
  late UserFilter _filter;

  @override
  void initState() {
    _filter = widget.initialFilter ?? const UserFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InputChip(
              label: Text(AppLocalizations.of(context).group),
              avatar: const PhosphorIcon(PhosphorIconsLight.fileText),
              selected: _filter.group != null,
              showCheckmark: false,
              onDeleted: _filter.group == null
                  ? null
                  : () {
                      setState(() {
                        _filter = _filter.copyWith(group: null, source: null);
                      });
                      widget.onChanged(_filter);
                    },
              onSelected: (value) async {
                final groupId = await showDialog<SourcedModel<Group>>(
                  context: context,
                  builder: (context) => GroupSelectDialog(
                    selected: _filter.source != null && _filter.group != null
                        ? SourcedModel(_filter.source!, _filter.group!)
                        : null,
                  ),
                );
                if (groupId != null) {
                  setState(() {
                    _filter = _filter.copyWith(
                        group: groupId.model.id, source: groupId.source);
                  });
                  widget.onChanged(_filter);
                }
              },
            ),
          ]
              .map((e) => Padding(padding: const EdgeInsets.all(8.0), child: e))
              .toList(),
        ),
      ),
    );
  }
}
