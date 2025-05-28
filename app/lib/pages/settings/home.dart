import 'package:flow/cubits/settings.dart';
import 'package:flow/pages/settings/data.dart';
import 'package:flow/pages/settings/personalization.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_leap/material_leap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum SettingsView {
  data,
  personalization;

  bool get isEnabled => true;

  String getLocalizedName(BuildContext context) => switch (this) {
        SettingsView.data => AppLocalizations.of(context).data,
        SettingsView.personalization =>
          AppLocalizations.of(context).personalization,
      };

  IconGetter get icon => switch (this) {
        SettingsView.data => PhosphorIcons.database,
        SettingsView.personalization => PhosphorIcons.monitor,
      };
  String get path => '/settings/$name';
}

class SettingsPage extends StatefulWidget {
  final bool isDialog;
  const SettingsPage({super.key, this.isDialog = false});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsView _view = SettingsView.data;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < LeapBreakpoints.compact;
    final body = _buildBody(context, isMobile);
    if (widget.isDialog) {
      return body;
    }
    return Scaffold(
      appBar: WindowTitleBar<SettingsCubit, FlowSettings>(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: body,
    );
  }

  Widget _buildBody(BuildContext context, bool isMobile) {
    void navigateTo(SettingsView view) {
      if (isMobile) {
        context.push(view.path);
      } else {
        setState(() {
          _view = view;
        });
      }
    }

    var navigation = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isDialog)
          Header(
            title: Text(AppLocalizations.of(context).settings),
            leading: IconButton.outlined(
              icon: const PhosphorIcon(PhosphorIconsLight.x),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            ),
          ),
        Flexible(
          child: Material(
            type: MaterialType.transparency,
            child: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              children: [
                ...SettingsView.values.where((e) => e.isEnabled).map((view) {
                  final selected = _view == view && !isMobile;
                  return ListTile(
                    leading: PhosphorIcon(
                      view.icon(
                        selected
                            ? PhosphorIconsStyle.fill
                            : PhosphorIconsStyle.light,
                      ),
                    ),
                    title: Text(view.getLocalizedName(context)),
                    onTap: () => navigateTo(view),
                    selected: selected,
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
    if (isMobile) {
      return navigation;
    }
    final Widget content;
    if (_view == SettingsView.data) {
      content = const DataSettingsPage(inView: true);
    } else if (_view == SettingsView.personalization) {
      content = const PersonalizationSettingsPage(inView: true);
    } else {
      content = const SizedBox.shrink();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: 300, child: navigation),
        Expanded(child: content),
      ],
    );
  }
}
