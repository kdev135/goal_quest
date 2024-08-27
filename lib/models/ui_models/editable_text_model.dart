import 'package:flutter/material.dart';


class EditableTextModel extends StatelessWidget {
  const EditableTextModel({
    Key? key,
    required this.sampleTextController,
    this.fontStyle,
    this.maxLines = 1,
  }) : super(key: key);

  final TextEditingController sampleTextController;
  final TextStyle? fontStyle;
  final int maxLines;

  @override
  Widget build(BuildContext  
 context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),  

      color: theme.colorScheme.surface,
      elevation: 2, // Add elevation for depth
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Consistent padding
        child: EditableText(
          controller: sampleTextController,
          focusNode: FocusNode(canRequestFocus: true),
          scrollPhysics: const BouncingScrollPhysics(),
          style: fontStyle ?? theme.textTheme.bodyMedium!, // Use theme text style
          cursorColor: theme.colorScheme.primary,
          backgroundCursorColor: theme.colorScheme.onSurface,
          maxLines: maxLines,
          selectionColor: theme.colorScheme.primary.withOpacity(0.5), // Add selection color
        ),
      ),
    );
  }
}