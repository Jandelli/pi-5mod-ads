import 'package:flow/pages/calendar/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flow_api/models/event/item/model.dart';
import 'package:flow_api/models/event/model.dart';
import 'package:flow_api/models/model.dart';

import '../../cubits/flow.dart';
import '../../widgets/markdown_field.dart';

class DashboardEventsView extends StatefulWidget {
  const DashboardEventsView({super.key});

  @override
  State<DashboardEventsView> createState() => _DashboardEventsViewState();
}

class _DashboardEventsViewState extends State<DashboardEventsView> {
  Future<List<SourcedConnectedModel<CalendarItem, Event?>>> _getAppointments(
      BuildContext context) async {
    final sources = context.read<FlowCubit>().getCurrentServicesMap();
    final appointments = <SourcedConnectedModel<CalendarItem, Event?>>[];
    for (final source in sources.entries) {
      appointments.addAll((await source.value.calendarItem
                  ?.getCalendarItems(date: DateTime.now()) ??
              [])
          .map((e) => SourcedModel(source.key, e)));
    }
    return appointments;
  }

  @override
  void didUpdateWidget(covariant DashboardEventsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context).events,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsLight.arrowSquareOut),
              onPressed: () => GoRouter.of(context).go('/calendar'),
            )
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child:
              FutureBuilder<List<SourcedConnectedModel<CalendarItem, Event?>>>(
                  future: _getAppointments(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    final appointments = snapshot.data ??
                        <SourcedConnectedModel<CalendarItem, Event?>>[];
                    if (appointments.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context).indicatorEmpty,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                    return Column(
                      children: appointments
                          .map((e) => ListTile(
                                title: Text(e.main.name),
                                subtitle: MarkdownText(e.main.description),
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => CalendarItemDialog(
                                          event: e.sub,
                                          item: e.main,
                                          source: e.source,
                                        )).then((value) => setState(() {})),
                              ))
                          .toList(),
                    );
                  }),
        )
      ],
    );
  }
}
