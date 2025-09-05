import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/widgets/widgets/button.dart';
import 'package:on_chain_wallet/future/widgets/widgets/widget_constant.dart';

class StupWalletTerms extends StatelessWidget {
  const StupWalletTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RichText(
          text: TextSpan(children: [
        TextSpan(style: context.textTheme.bodySmall, children: [
          TextSpan(text: "- "),
          TextSpan(text: "p_note1".tr),
          TextSpan(text: "\n\n"),
          TextSpan(text: "- "),
          TextSpan(text: "p_note2".tr),
          TextSpan(text: "\n\n"),
          TextSpan(text: "- "),
          TextSpan(text: "p_note3".tr),
          TextSpan(text: "\n\n"),
          TextSpan(text: "- "),
          TextSpan(text: "p_note4".tr),
          TextSpan(text: "\n\n"),
          TextSpan(text: "- "),
          TextSpan(text: "p_note5".tr),
          TextSpan(text: "\n\n"),
        ])
      ])),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FixedElevatedButton(
              padding: WidgetConstant.paddingVertical20,
              onPressed: () {
                context.pop(true);
              },
              child: Text("agree_to_terms".tr))
        ],
      )
    ]);
  }
}
