import 'package:flutter/material.dart';
import 'package:on_chain_wallet/future/widgets/custom_widgets.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';

typedef PageProgressStatus = StreamWidgetStatus;

abstract class PageProgressBaseState<T extends StatefulWidget> extends State<T>
    with SafeState<T> {
  abstract PageProgressStatus _status;
  abstract Widget? _statusWidget;
  abstract final FuncWidgetContext child;
  Widget? get statusWidget => _statusWidget;
  Duration? get backToIdle;

  PageProgressStatus get status => _status;

  void _listen(PageProgressStatus status) async {
    if (backToIdle == null) return;
    if (status == PageProgressStatus.progress ||
        status == PageProgressStatus.idle) {
      return;
    }
    await Future.delayed(backToIdle ?? Duration.zero);
    updateStream(PageProgressStatus.idle, progressWidget: null);
  }

  void updateStream(PageProgressStatus status,
      {Widget? progressWidget, bool backToIdle = true}) {
    if (closed || !mounted) return;
    _status = status;
    _statusWidget = progressWidget;
    if (backToIdle) {
      _listen(status);
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _statusWidget = null;
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class PageProgressChildWidget extends StatelessWidget {
  const PageProgressChildWidget(this.statusWidget, {super.key});
  final Widget statusWidget;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstraintsBoxView(
            padding: WidgetConstant.paddingHorizontal20,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [statusWidget]),
          ),
        ),
      ],
    );
  }
}
