import 'package:flow/pages/calendar/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flow_api/models/event/item/model.dart';
import 'package:flow_api/models/event/model.dart';
import 'package:flow_api/models/model.dart';
import 'package:flow/pages/calendar/page.dart'; // Import the file containing showCalendarCreate

import '../../cubits/flow.dart';
import '../../widgets/markdown_field.dart';

class DashboardEventsView extends StatefulWidget {
  const DashboardEventsView({super.key});

  @override
  State<DashboardEventsView> createState() => _DashboardEventsViewState();
}

class _DashboardEventsViewState extends State<DashboardEventsView> {
  late Future<List<SourcedConnectedModel<CalendarItem, Event?>>>
      _appointmentsFuture;
  bool _isLoading = true;
  String? _debugInfo;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _debugInfo = null;
      _appointmentsFuture = _getAppointments(context);
    });
  }

  Future<List<SourcedConnectedModel<CalendarItem, Event?>>> _getAppointments(
      BuildContext context) async {
    final sources = context.read<FlowCubit>().getCurrentServicesMap();
    final appointments = <SourcedConnectedModel<CalendarItem, Event?>>[];

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      // Try multiple query strategies to ensure we get events
      for (final source in sources.entries) {
        if (source.value.calendarItem != null) {
          try {
            debugPrint('Fetching events for source: ${source.key}');

            // Strategy 1: Use date parameter
            var items = await source.value.calendarItem?.getCalendarItems(
                  date: startOfDay,
                  limit: 20,
                  status: [EventStatus.confirmed, EventStatus.draft],
                ) ??
                [];

            // Strategy 2: If no results, try with start and end
            if (items.isEmpty) {
              debugPrint(
                  'No events found using date parameter, trying with start/end');
              items = await source.value.calendarItem?.getCalendarItems(
                    start: startOfDay,
                    end: endOfDay,
                    limit: 20,
                    status: [EventStatus.confirmed, EventStatus.draft],
                  ) ??
                  [];
            }

            // Strategy 3: If still no results, try without status filter
            if (items.isEmpty) {
              debugPrint('No events found with status filter, trying without');
              items = await source.value.calendarItem?.getCalendarItems(
                    date: startOfDay,
                    limit: 20,
                  ) ??
                  [];
            }

            if (items.isNotEmpty) {
              debugPrint(
                  'Found ${items.length} events for source: ${source.key}');
              appointments
                  .addAll(items.map((e) => SourcedModel(source.key, e)));
            } else {
              debugPrint('No events found for source: ${source.key}');
            }
          } catch (e) {
            debugPrint('Error fetching events for source ${source.key}: $e');
            setState(() {
              _debugInfo = 'Error fetching events: $e';
            });
          }
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (appointments.isEmpty && _debugInfo == null) {
            _debugInfo = 'Nenhum evento para hoje.';
          }
        });
      }
      return appointments;
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _debugInfo = 'Error fetching events: $e';
        });
      }
      return [];
    }
  }

  @override
  void didUpdateWidget(covariant DashboardEventsView oldWidget) {
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
                AppLocalizations.of(context).events,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsLight.arrowSquareOut),
              onPressed: () => GoRouter.of(context).go('/calendar'),
            ),
            IconButton(
              icon: const PhosphorIcon(PhosphorIconsLight.arrowClockwise),
              onPressed: refreshData,
              tooltip: 'Atualizar Eventos',
            )
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child:
              FutureBuilder<List<SourcedConnectedModel<CalendarItem, Event?>>>(
                  future: _appointmentsFuture,
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
                              'Error loading events: ${snapshot.error}',
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
                    final appointments = snapshot.data ??
                        <SourcedConnectedModel<CalendarItem, Event?>>[];
                    if (appointments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context).indicatorEmpty,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            if (_debugInfo != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _debugInfo!,
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      );
                    }
                    return ListView(
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
                                        )).then((value) => refreshData()),
                              ))
                          .toList(),
                    );
                  }),
        )
      ],
    );
  }
}
