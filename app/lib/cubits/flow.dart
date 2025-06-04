import 'package:dart_mappable/dart_mappable.dart';
import 'package:flow/api/storage/remote/model.dart';
import 'package:flow/api/storage/sources.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow_api/services/source.dart';
import 'package:collection/collection.dart';
import 'dart:io';

part 'flow.mapper.dart';

@MappableClass()
class FlowState with FlowStateMappable {
  final List<String> disabledSources;
  const FlowState({
    this.disabledSources = const [],
  });
}

class FlowCubit extends Cubit<FlowState> {
  final SourcesService sourcesService;

  FlowCubit(this.sourcesService) : super(const FlowState());

  String getCurrentSource() {
    return getCurrentSources().firstOrNull ?? '';
  }

  List<String> getCurrentSources() {
    // Include main local database, imported databases, and remote sources
    final sources = <String>[''];

    // Add imported database identifiers using their actual database filenames
    for (int i = 0; i < sourcesService.localDatabases.length; i++) {
      final db = sourcesService.localDatabases[i];
      try {
        final dbFileName =
            db.db.path.split(Platform.pathSeparator).last.replaceAll('.db', '');
        sources.add(dbFileName);
      } catch (e) {
        // Fallback to index-based identifier if path extraction fails
        sources.add('imported_$i');
      }
    }

    // Add remote sources
    sources.addAll(sourcesService.getRemotes().map((e) => e.identifier));

    return sources
        .whereNot((source) => state.disabledSources.contains(source))
        .toList();
  }

  List<RemoteStorage> getCurrentRemotes() {
    final currentSources = getCurrentSources();
    return sourcesService
        .getRemotes()
        .where((e) => currentSources.contains(e.identifier))
        .toList();
  }

  SourceService getCurrentService() {
    return sourcesService.local;
  }

  List<SourceService> getCurrentServices() {
    return getCurrentSources().map((e) => getService(e)).toList();
  }

  void removeSource(String source) {
    emit(state.copyWith(disabledSources: [...state.disabledSources, source]));
  }

  void addSource(String source) {
    emit(state.copyWith(
        disabledSources:
            state.disabledSources.where((s) => s != source).toList()));
  }

  void setSources(List<String> sources) {
    setDisabledSources(
        getCurrentSources().whereNot((e) => sources.contains(e)).toList());
  }

  void setDisabledSources(List<String> sources) {
    emit(state.copyWith(disabledSources: sources));
  }

  SourceService getService(String source) {
    return sourcesService.getSource(source);
  }

  Map<String, SourceService> getCurrentServicesMap() {
    return Map.fromIterables(getCurrentSources(), getCurrentServices());
  }
}
