part of 'drawer.dart';

class _NotebooksView extends StatelessWidget {
  final SourcedModel<Uint8List?>? model;
  final ValueChanged<SourcedModel<Uint8List>?> onChanged;

  const _NotebooksView({
    this.model,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SelectTile(
      source: model?.source,
      value: model?.model,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onChanged: onChanged,
      onModelFetch: (source, service, id) async =>
          service.note?.getNotebook(id),
      title: AppLocalizations.of(context).notebooks,
      leadingBuilder: (context, model) => PhosphorIcon(
        model?.model == null ? PhosphorIconsLight.book : PhosphorIconsFill.book,
      ),
      dialogBuilder: (context, model) => NotebookDialog(
        source: model?.source,
        notebook: model?.model,
        create: model?.model == null,
      ),
      selectBuilder: (context, model) => _NotebooksSelectDialog(
        selected: model?.toIdentifierModel(),
      ),
    );
  }
}

class _NotebooksSelectDialog extends StatelessWidget {
  final SourcedModel<Uint8List>? selected;

  const _NotebooksSelectDialog({
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SelectDialog(
      onFetch: (source, service, search, offset, limit) async =>
          service.note?.getNotebooks(
        offset: offset,
        limit: limit,
        search: search,
      ),
      title: AppLocalizations.of(context).notebooks,
      selected: selected,
    );
  }
}
