import 'package:flutter/material.dart';
import 'package:flow/src/generated/i18n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownField extends StatefulWidget {
  final String? value;
  final InputDecoration decoration;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged, onChangeEnd;
  final List<Widget> actions;
  final SizedBox? toolbar;

  const MarkdownField(
      {super.key,
      this.value,
      this.controller,
      this.onChanged,
      this.onChangeEnd,
      this.toolbar,
      this.decoration = const InputDecoration(),
      this.actions = const []});

  @override
  State<MarkdownField> createState() => _MarkdownFieldState();
}

class _MarkdownFieldState extends State<MarkdownField> {
  late final TextEditingController _controller;
  bool _editMode = false;
  final FocusNode _focusNode = FocusNode();
  bool _isUserEditing = false; // Track if user is actively editing

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isUserEditing) {
        _exitEditMode();
      }
    });

    // Listen to text changes to track user editing
    _controller.addListener(() {
      if (_editMode) {
        widget.onChanged?.call(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(MarkdownField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update controller text if widget value changed AND user is not currently editing
    if (oldWidget.value != widget.value &&
        widget.value != null &&
        !_isUserEditing &&
        !_editMode &&
        widget.value != _controller.text) {
      _controller.text = widget.value!;
    }
  }

  void _enterEditMode() {
    if (!_editMode) {
      setState(() {
        _editMode = true;
        _isUserEditing = true;
      });
      // Use post-frame callback to ensure widget is built before requesting focus
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNode.canRequestFocus) {
          _focusNode.requestFocus();
        }
      });
    }
  }

  void _exitEditMode() {
    if (_editMode) {
      setState(() {
        _editMode = false;
      });
      widget.onChangeEnd?.call(_controller.text);
      // Delay resetting user editing flag to prevent conflicts
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _isUserEditing = false;
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.max, children: [
      Expanded(
        child: SizedBox(
          child: _editMode
              ? Column(
                  children: [
                    if (widget.toolbar != null) widget.toolbar!,
                    TextFormField(
                      key: const ValueKey('markdown_edit_field'), // Stable key
                      autofocus: false, // Let focus be handled manually
                      focusNode: _focusNode,
                      decoration: widget.decoration.copyWith(
                        helperText:
                            AppLocalizations.of(context).markdownIsSupported,
                      ),
                      maxLines: null,
                      minLines: 3,
                      controller: _controller,
                      onFieldSubmitted: (_) => _exitEditMode(),
                      onEditingComplete: _exitEditMode,
                      onTapOutside: (_) => _exitEditMode(),
                    ),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(height: widget.toolbar?.height),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _enterEditMode,
                      onDoubleTap: _enterEditMode,
                      child: InputDecorator(
                        decoration: widget.decoration,
                        child: MarkdownText(
                          _controller.text,
                          border: false,
                          onTap: _enterEditMode,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.actions,
        ],
      )
    ]);
  }
}

class MarkdownText extends StatelessWidget {
  final String value;
  final VoidCallback? onTap;
  final bool border;

  const MarkdownText(this.value, {super.key, this.onTap, this.border = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: border && value.isNotEmpty
          ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
              ),
              borderRadius: BorderRadius.circular(4),
            )
          : null,
      padding: border && value.isNotEmpty ? const EdgeInsets.all(8) : null,
      child: MarkdownBody(
        data: value,
        onTapText: onTap,
        extensionSet: md.ExtensionSet(
          md.ExtensionSet.gitHubFlavored.blockSyntaxes,
          [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
        ),
        onTapLink: (text, href, title) async {
          if (href != null && await canLaunchUrlString(href)) {
            launchUrlString(href);
          }
        },
      ),
    );
  }
}
