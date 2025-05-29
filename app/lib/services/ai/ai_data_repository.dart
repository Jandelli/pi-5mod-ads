import 'package:flow_api/models/event/item/model.dart';
import 'package:flow_api/models/event/model.dart';
import 'package:flow_api/models/note/model.dart';
import 'package:flow_api/services/source.dart';
import '../../models/ai/ai_models.dart';

class AIDataRepository {
  final SourceService _sourceService;

  AIDataRepository(this._sourceService);

  /// Collects relevant user data for AI summary generation
  Future<AISummaryRequest> collectUserData({
    required AISummaryTimeframe timeframe,
    DateTime? customStartDate,
    DateTime? customEndDate,
  }) async {
    final dateRange =
        _calculateDateRange(timeframe, customStartDate, customEndDate);

    try {
      // Collect calendar events and items
      final events = await _collectEvents(dateRange.start, dateRange.end);

      // Collect notes
      final notes = await _collectNotes(dateRange.start, dateRange.end);

      // Collect upcoming tasks
      final upcomingTasks = await _collectUpcomingTasks();

      return AISummaryRequest(
        timeframe: timeframe.promptName,
        events: events,
        notes: notes,
        upcomingTasks: upcomingTasks,
        fromDate: dateRange.start,
        toDate: dateRange.end,
      );
    } catch (e) {
      throw Exception('Failed to collect user data: $e');
    }
  }

  Future<List<String>> _collectEvents(DateTime start, DateTime end) async {
    final events = <String>[];

    try {
      // Get calendar items from the service
      final calendarItems = await _sourceService.calendarItem?.getCalendarItems(
            start: start,
            end: end,
            limit: 100,
          ) ??
          [];

      for (final item in calendarItems) {
        final calendarItem = item.source;
        final event = item.model;

        final eventString = _formatCalendarItemForAI(calendarItem, event);
        if (eventString.isNotEmpty) {
          events.add(eventString);
        }
      }
    } catch (e) {
      print('Error collecting events: $e');
    }

    return events;
  }

  Future<List<String>> _collectNotes(DateTime start, DateTime end) async {
    final notes = <String>[];

    try {
      final noteItems = await _sourceService.note?.getNotes(
            limit: 50,
          ) ??
          [];

      for (final note in noteItems) {
        // Filter notes by date if they have timestamps
        if (_isNoteInDateRange(note, start, end)) {
          final noteString = _formatNoteForAI(note);
          if (noteString.isNotEmpty) {
            notes.add(noteString);
          }
        }
      }
    } catch (e) {
      print('Error collecting notes: $e');
    }

    return notes;
  }

  Future<List<String>> _collectUpcomingTasks() async {
    final tasks = <String>[];

    try {
      final now = DateTime.now();
      final futureDate = now.add(const Duration(days: 30));

      // Get pending calendar items
      final pendingItems = await _sourceService.calendarItem?.getCalendarItems(
            pending: true,
            limit: 50,
          ) ??
          [];

      // Get upcoming appointments
      final upcomingItems = await _sourceService.calendarItem?.getCalendarItems(
            start: now,
            end: futureDate,
            limit: 50,
          ) ??
          [];

      // Format pending items
      for (final item in pendingItems) {
        final task = _formatTaskForAI(item.source, isPending: true);
        if (task.isNotEmpty) {
          tasks.add(task);
        }
      }

      // Format upcoming appointments
      for (final item in upcomingItems) {
        final task = _formatTaskForAI(item.source, isPending: false);
        if (task.isNotEmpty) {
          tasks.add(task);
        }
      }
    } catch (e) {
      print('Error collecting upcoming tasks: $e');
    }

    return tasks;
  }

  String _formatCalendarItemForAI(CalendarItem item, Event? event) {
    final buffer = StringBuffer();

    // Add item type
    buffer.write('${item.type.name.toUpperCase()}: ');

    // Add name (prefer event name if available)
    final name =
        (event != null && event.name.isNotEmpty) ? event.name : item.name;
    if (name.isNotEmpty) {
      buffer.write(name);
    }

    // Add description
    final description = (event != null && event.description.isNotEmpty)
        ? event.description
        : item.description;
    if (description.isNotEmpty) {
      buffer.write(' - $description');
    }

    // Add location
    final location = (event != null && event.location.isNotEmpty)
        ? event.location
        : item.location;
    if (location.isNotEmpty) {
      buffer.write(' at $location');
    }

    // Add timing information
    if (item.start != null) {
      buffer.write(' on ${_formatDateTime(item.start!)}');
      if (item.end != null && item.end != item.start) {
        buffer.write(' until ${_formatDateTime(item.end!)}');
      }
    }

    // Add status
    buffer.write(' (${item.status.name})');

    return buffer.toString();
  }

  String _formatNoteForAI(Note note) {
    final buffer = StringBuffer();

    buffer.write('NOTE: ');
    if (note.name.isNotEmpty) {
      buffer.write(note.name);
    }

    if (note.description.isNotEmpty) {
      if (note.name.isNotEmpty) {
        buffer.write(' - ');
      }
      buffer.write(note.description);
    }

    if (note.status != null) {
      buffer.write(' (${note.status!.name})');
    }

    return buffer.toString();
  }

  String _formatTaskForAI(CalendarItem item, {required bool isPending}) {
    final buffer = StringBuffer();

    if (isPending) {
      buffer.write('PENDING TASK: ');
    } else {
      buffer.write('UPCOMING: ');
    }

    if (item.name.isNotEmpty) {
      buffer.write(item.name);
    }

    if (item.description.isNotEmpty) {
      buffer.write(' - ${item.description}');
    }

    if (!isPending && item.start != null) {
      buffer.write(' on ${_formatDateTime(item.start!)}');
    }

    return buffer.toString();
  }

  bool _isNoteInDateRange(Note note, DateTime start, DateTime end) {
    // Since notes don't have explicit timestamps in the current model,
    // we'll include all notes for now. In a future version, you might
    // want to add createdAt/updatedAt fields to the Note model.
    return true;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  ({DateTime start, DateTime end}) _calculateDateRange(
    AISummaryTimeframe timeframe,
    DateTime? customStart,
    DateTime? customEnd,
  ) {
    final now = DateTime.now();

    switch (timeframe) {
      case AISummaryTimeframe.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return (
          start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          end: DateTime(
              endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
        );

      case AISummaryTimeframe.month:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return (start: startOfMonth, end: endOfMonth);

      case AISummaryTimeframe.custom:
        if (customStart == null || customEnd == null) {
          throw ArgumentError(
              'Custom start and end dates are required for custom timeframe');
        }
        return (start: customStart, end: customEnd);
    }
  }
}
