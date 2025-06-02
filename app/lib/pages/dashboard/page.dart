import 'package:flow/pages/dashboard/notes.dart';
import 'package:flow/widgets/clock.dart';
import 'package:flow/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:material_leap/helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow/cubits/flow.dart';

import 'events.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Use State<Widget> generic type instead of private state types
  final _notesKey = GlobalKey<State<DashboardNotesView>>();
  final _eventsKey = GlobalKey<State<DashboardEventsView>>();

  @override
  void initState() {
    super.initState();
    // Delay refresh to ensure the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshDashboard();
    });
  }

  void _refreshDashboard() {
    // Cast to dynamic to access the refreshData method from both state classes
    (_notesKey.currentState as dynamic)?.refreshData();
    (_eventsKey.currentState as dynamic)?.refreshData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will refresh the dashboard when dependencies change (like FlowCubit)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlowNavigation(
      title: AppLocalizations.of(context).dashboard,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                    child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                            minHeight: 300,
                            minWidth: 300,
                            maxWidth: 600,
                            maxHeight: 600),
                        child: const ClockView(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context).welcome,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.go('/ai');
                  },
                  child: const Text('Resumo de IA'),
                ),
                const SizedBox(height: 16),
                BlocBuilder<FlowCubit, FlowState>(
                  builder: (context, state) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth >=
                                LeapBreakpoints.medium) {
                              return SizedBox(
                                height: 250,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        child:
                                            DashboardNotesView(key: _notesKey)),
                                    const SizedBox(width: 8),
                                    const VerticalDivider(),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: DashboardEventsView(
                                            key: _eventsKey)),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 250,
                                      minWidth: 300,
                                      maxWidth: 600,
                                      maxHeight: 300,
                                    ),
                                    child: DashboardNotesView(key: _notesKey)),
                                const Divider(),
                                ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 250,
                                      minWidth: 300,
                                      maxWidth: 600,
                                      maxHeight: 300,
                                    ),
                                    child:
                                        DashboardEventsView(key: _eventsKey)),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
