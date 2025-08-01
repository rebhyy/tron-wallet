import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'conditional_widget.dart';
import 'copy_icon_widget.dart';
import 'text_view.dart';

class LargeTextContainer extends StatelessWidget {
  final String text;
  final int maxLines;
  final Color? color;
  final bool copyable;

  const LargeTextContainer(
      {required this.color,
      required this.text,
      this.maxLines = 3,
      this.copyable = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int getMaxLine() {
          if (text.length > 1000) {
            return maxLines + 1;
          }
          final span =
              TextSpan(text: text, style: context.textTheme.bodyMedium);
          final tp = TextPainter(
              text: span,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start);
          tp.layout(maxWidth: constraints.maxWidth);
          return tp.computeLineMetrics().length;
        }

        final lines = getMaxLine();

        if (lines > maxLines) {
          return Row(
            children: [
              Expanded(
                  child: Text(
                text,
                style: context.textTheme.bodyMedium?.copyWith(color: color),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              )),
              IconButton(
                  onPressed: () {
                    context.openDialogPage('',
                        child: (context) => APPTextView(text: text, title: ''));
                  },
                  icon: Icon(Icons.open_in_full_sharp, color: color))
            ],
          );
        }
        return ConditionalWidget(
          enable: copyable,
          onActive: (context) => CopyableTextWidget(
            text: text,
            maxLines: maxLines,
            color: color,
          ),
          onDeactive: (context) => Text(
            text,
            style: context.textTheme.bodyMedium?.copyWith(color: color),
            maxLines: maxLines,
          ),
        );
      },
    );
  }
}
