import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flow_api/models/model.dart';
import 'package:flow_api/services/source.dart';

import '../cubits/flow.dart';

class SourceDropdown<T> extends StatelessWidget {
  final String? value; // Changed to nullable
  final ValueChanged<ConnectedModel<String, T>?> onChanged;
  final T? Function(SourceService) buildService;

  const SourceDropdown({
    super.key,
    required this.value, // Now accepts null
    required this.onChanged,
    required this.buildService,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FlowCubit>();
    final services = Map.fromEntries(cubit
        .getCurrentServicesMap()
        .entries
        .map((e) {
          final service = buildService(e.value);
          if (service == null) return null;
          return MapEntry(e.key, service);
        })
        .nonNulls
        .toList());

    return Column(
      children: [
        const SizedBox(height: 16),
        DropdownMenu<String>(
          initialSelection: value,
          hintText:
              AppLocalizations.of(context).selectASource, // Added hint text
          dropdownMenuEntries: services.entries.map((entry) {
            final remote = cubit.sourcesService.getRemote(entry.key);
            return DropdownMenuEntry<String>(
              value: entry.key,
              label: entry.key == ''
                  ? AppLocalizations.of(context).local
                  : remote?.displayName ??
                      entry
                          .key, // Fallback to key if display name is null for non-local
            );
          }).toList(),
          onSelected: (selectedValue) {
            // selectedValue can be null if an entry with null value is somehow selected,
            // or if future Flutter versions allow clearing selection.
            if (selectedValue == null) {
              onChanged(null);
              return;
            }
            final service = services[selectedValue];
            onChanged(
              service == null
                  ? null
                  : ConnectedModel(
                      selectedValue,
                      service,
                    ),
            );
          },
          label: Text(AppLocalizations.of(context).source),
          leadingIcon: const PhosphorIcon(PhosphorIconsLight.cloud),
          expandedInsets: const EdgeInsets.all(4),
        ),
      ],
    );
  }
}
