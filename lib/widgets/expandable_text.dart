import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.maxLines = 4});   // (A)

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(                                     // (B)
          text: TextSpan(text: widget.text, style: DefaultTextStyle.of(context).style),
          maxLines: widget.maxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);                       // (C)
        final isLong = painter.didExceedMaxLines;                        // (D)

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: isExpanded ? null : widget.maxLines,             // (E)
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),
            if (isLong)
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () => setState(() => isExpanded = !isExpanded),
                child: Text(isExpanded ? 'Less' : 'More'),
              ),
          ],
        );
      },
    );
  }
}