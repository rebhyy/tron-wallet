import 'dart:async';
import 'package:blockchain_utils/exception/exception/exception.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/future.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/transaction/types/types.dart';
import 'package:on_chain_wallet/wallet/models/chain/chain/chain.dart';
import 'package:on_chain_wallet/wallet/web3/core/exception/exception.dart';
import 'package:on_chain_wallet/wallet/web3/core/request/web_request.dart';

enum Web3ProgressStatus {
  progress(true),
  error(true),
  idle(true),
  successResponse(false),
  errorResponse(false),
  successRequest(false),
  failedRequest(false);

  final bool canUpdate;
  const Web3ProgressStatus(this.canUpdate);

  static Web3ProgressStatus fromWeb3Status(
      Web3RequestCompleterEventType? status) {
    switch (status) {
      case Web3RequestCompleterEventType.response:
        return Web3ProgressStatus.successResponse;
      case Web3RequestCompleterEventType.error:
        return Web3ProgressStatus.errorResponse;
      case Web3RequestCompleterEventType.closed:
        return Web3ProgressStatus.failedRequest;
      case Web3RequestCompleterEventType.success:
        return Web3ProgressStatus.successRequest;
      default:
        return Web3ProgressStatus.idle;
    }
  }
}

class StreamWeb3PageProgressController extends StreamValue<Web3ProgressStatus> {
  final Web3ProgressStatus initialStatus;
  StreamWeb3PageProgressController(
      {this.initialStatus = Web3ProgressStatus.idle,
      this.idleTimeout = APPConst.oneSecoundDuration})
      : super(initialStatus);
  final Duration idleTimeout;

  Widget? _responseWidget;

  Widget? getWidget() {
    return _responseWidget;
  }

  void _updateStream(Web3ProgressStatus status) {
    value = status;
  }

  void _update({required Web3ProgressStatus status, Widget? widget}) {
    if (value.canUpdate) {
      _responseWidget = widget;
      _updateStream(status);
    }
  }

  void response({String? text, Widget? widget}) {
    _update(
        status: Web3ProgressStatus.successResponse,
        widget: widget ??
            PageProgressChildWidget(ProgressWithTextView(
                text: text ?? "request_has_been_processed_successfully".tr,
                icon: WidgetConstant.checkCircleLarge)));
  }

  void responseTx(
      {required List<SubmitTransactionResult> txIds, required Chain account}) {
    response(
        widget: ProgressMultipleTextView(
            account: account,
            texts: txIds.map((e) {
              if (e.status.isFailed) {
                return ProgressTxStatusErrorView(
                    message: e.cast<SubmitTransactionFailed>().error);
              }
              final txId = e.cast<SubmitTransactionSuccess>();
              return ProgressTxStatusSuccessView(
                  txId: txId.txId,
                  warning: txId.warning,
                  openUrl: account.network.getTransactionExplorer(txId.txId),
                  transaction: account.addresses
                      .firstWhereOrNull((e) =>
                          e == txId.signedTransaction.transaction.account)
                      ?.transactions
                      .firstWhereOrNull((e) => e.txId == txId.txId));
            }).toList(),
            logo: account.network.token.assetLogo,
            title: account.network.networkName));
  }

  void processs({String? text}) {
    _update(
        status: Web3ProgressStatus.progress,
        widget:
            PageProgressChildWidget(ProgressWithTextView(text: text ?? "")));
  }

  void error({
    Object? error,
    String? message,
    Duration backToIdle = APPConst.twoSecoundDuration,
    bool showBackButton = false,
  }) {
    _errorResponseFromException(
        status: Web3ProgressStatus.error,
        showBackButton: showBackButton,
        backToIdle: backToIdle,
        error: error,
        message: message);
  }

  void errorResponse({Object? error, String? message}) {
    _errorResponseFromException(
        status: Web3ProgressStatus.errorResponse,
        error: error,
        message: message,
        backToIdle: null);
  }

  void _errorResponseFromException(
      {Object? error,
      String? message,
      Duration? backToIdle = APPConst.twoSecoundDuration,
      bool showBackButton = false,
      required Web3ProgressStatus status}) {
    showBackButton = showBackButton && status.canUpdate;
    if (error == WalletExceptionConst.rejectSigning) {
      showBackButton = false;
      backToIdle = APPConst.oneSecoundDuration;
    }
    if (showBackButton) {
      backToIdle = null;
    }
    if (!status.canUpdate) {
      backToIdle = null;
      showBackButton = false;
    }
    final key = showBackButton ? this : null;

    if (error is WalletException) {
      _error(
          widget: _Web3ErrorMessageView(null, key, message: error.message.tr),
          backToIdle: backToIdle,
          status: status);
    } else if (error is Web3InternalError) {
      _error(
          backToIdle: backToIdle,
          widget: _Web3ErrorMessageView(error.message, key),
          status: status);
    } else if (error is Web3RequestException) {
      _error(
          backToIdle: backToIdle,
          widget: _Web3ErrorMessageView(error.message, key),
          status: status);
    } else if (error is ApiProviderException) {
      _error(
          backToIdle: backToIdle,
          widget: _Web3ErrorMessageView(error.message.toString().tr, key),
          status: status);
    } else if (error is BlockchainUtilsException) {
      _error(
          backToIdle: backToIdle,
          widget: _Web3ErrorMessageView(error.message, key),
          status: status);
    } else {
      _error(
          widget: _Web3ErrorMessageView(null, key, message: message),
          backToIdle: backToIdle,
          status: status);
    }
  }

  void _error(
      {String? text,
      Widget? widget,
      Duration? backToIdle = APPConst.twoSecoundDuration,
      required Web3ProgressStatus status}) {
    _update(
        status: status,
        widget: widget ??
            PageProgressChildWidget(ProgressWithTextView(
                text: text ?? "", icon: WidgetConstant.errorIconLarge)));
    if (backToIdle != null) {
      Future.delayed(
          backToIdle, () => _update(status: Web3ProgressStatus.idle));
    }
  }

  void closedRequest({String? error}) {
    if (_responseWidget == null || value == Web3ProgressStatus.progress) {
      _responseWidget = PageProgressChildWidget(ProgressWithTextView(
          text: error?.tr ?? "client_closed_durning_request".tr,
          icon: WidgetConstant.errorIconLarge));
    }

    _updateStream(Web3ProgressStatus.failedRequest);
  }

  void successRequest() {
    if (value != Web3ProgressStatus.successResponse &&
        value != Web3ProgressStatus.errorResponse) {
      if (_responseWidget == null || value == Web3ProgressStatus.progress) {
        _responseWidget = PageProgressChildWidget(ProgressWithTextView(
            text: "web3_response_successfully_desc".tr,
            icon: WidgetConstant.checkCircleLarge));
      }
    }
    _updateStream(Web3ProgressStatus.successRequest);
  }

  void idle() {
    _update(status: Web3ProgressStatus.idle);
  }

  void setInitialState() {
    _responseWidget = null;
    silent = initialStatus;
  }
}

class StreamWeb3PageProgress extends StatefulWidget {
  final StreamWeb3PageProgressController controller;
  final FuncWidgetContext builder;

  final Widget? initialWidget;
  const StreamWeb3PageProgress(
      {required this.controller,
      required this.builder,
      this.initialWidget,
      super.key});
  @override
  State<StreamWeb3PageProgress> createState() => _StreamWeb3PageProgressState();
}

class _StreamWeb3PageProgressState extends State<StreamWeb3PageProgress>
    with SafeState<StreamWeb3PageProgress> {
  StreamWeb3PageProgressController get controller => widget.controller;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      scaffoldMessageController;
  ScaffoldMessengerState? key;
  StreamSubscription<Web3ProgressStatus>? _listener;
  Web3ProgressStatus status = Web3ProgressStatus.idle;
  Widget? child;
  Widget? currentWidget;

  void onChangeStatus(Web3ProgressStatus status) {
    this.status = status;
    currentWidget = controller.getWidget();
    updateState();
    if (status.canUpdate) return;
    scaffoldMessageController ??= key?.showSnackBar(_buildRequestSnackBar(
      context: context,
      status: controller,
      onHide: () {
        scaffoldMessageController?.close();
        scaffoldMessageController = null;
      },
    ));
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    status = controller.value;
    _listener = controller.stream.listen(onChangeStatus);
    currentWidget = widget.initialWidget;
    key = ScaffoldMessenger.maybeOf(context);
    key?.clearSnackBars();
  }

  @override
  void safeDispose() {
    super.safeDispose();
    controller.setInitialState();
    currentWidget = null;
    child = null;
    _listener?.cancel();
    _listener = null;
    MethodUtils.after(() async {
      key?.clearSnackBars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return APPAnimatedSwitcher<Web3ProgressStatus>(
      duration: APPConst.animationDuraion,
      enable: status,
      widgets: {
        Web3ProgressStatus.idle: (c) => FutureBuilder(
              future: MethodUtils.after(() async => widget.builder(c)),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetConstant.errorIcon,
                      Text(snapshot.error?.toString() ?? "")
                    ],
                  );
                }
                if (snapshot.hasData) {
                  child = snapshot.data!;
                }
                return child ?? WidgetConstant.sizedBox;
              },
            ),
        Web3ProgressStatus.progress: (c) => currentWidget,
        Web3ProgressStatus.error: (c) => currentWidget,
        Web3ProgressStatus.errorResponse: (c) => currentWidget,
        Web3ProgressStatus.successResponse: (c) => currentWidget,
        Web3ProgressStatus.failedRequest: (c) => currentWidget,
        Web3ProgressStatus.successRequest: (c) => currentWidget
      },
    );
  }
}

SnackBar _buildRequestSnackBar(
    {required BuildContext context,
    required StreamValue<Web3ProgressStatus> status,
    required DynamicVoid onHide}) {
  return SnackBar(
      duration: switch (status.value) {
        Web3ProgressStatus.successRequest => APPConst.tenSecoundDuration,
        Web3ProgressStatus.failedRequest => APPConst.tenSecoundDuration,
        _ => const Duration(minutes: 10)
      },
      action: SnackBarAction(label: 'close'.tr, onPressed: onHide),
      content: APPStreamBuilder(
        value: status,
        builder: (context, status) => Row(
          children: [
            switch (status) {
              Web3ProgressStatus.successResponse ||
              Web3ProgressStatus.errorResponse =>
                APPCircularProgressIndicator(
                    color: context.colors.onInverseSurface),
              Web3ProgressStatus.failedRequest =>
                Icon(Icons.error, color: context.colors.onInverseSurface),
              _ =>
                Icon(Icons.check_circle, color: context.colors.onInverseSurface)
            },
            WidgetConstant.width8,
            Flexible(
                child: switch (status) {
              Web3ProgressStatus.successResponse ||
              Web3ProgressStatus.errorResponse =>
                OneLineTextWidget(
                    maxLine: 2,
                    "web3_sending_response_to_client".tr,
                    style: context.textTheme.labelLarge
                        ?.copyWith(color: context.colors.onInverseSurface)),
              Web3ProgressStatus.failedRequest => OneLineTextWidget(
                  maxLine: 2,
                  "web3_sending_response_error_desc".tr,
                  style: context.textTheme.labelLarge
                      ?.copyWith(color: context.colors.onInverseSurface)),
              _ => OneLineTextWidget(
                  maxLine: 2,
                  "web3_response_successfully_desc".tr,
                  style: context.textTheme.labelLarge
                      ?.copyWith(color: context.colors.onInverseSurface)),
            }),
          ],
        ),
      ));
}

class _Web3ErrorMessageView extends StatelessWidget {
  const _Web3ErrorMessageView(this.error, this.progressKey, {this.message});
  final String? message;
  final String? error;
  final StreamWeb3PageProgressController? progressKey;

  @override
  Widget build(BuildContext context) {
    return PageProgressChildWidget(_Web3ProgressWithTextView(
      progressKey: progressKey,
      text: message ?? "request_error".tr,
      icon: WidgetConstant.errorIconLarge,
      bottomWidget:
          ErrorTextContainer(error: error, enableTap: false, copyable: true),
    ));
  }
}

class _Web3ProgressWithTextView extends StatelessWidget {
  const _Web3ProgressWithTextView(
      {required this.text,
      required this.progressKey,
      this.icon,
      this.bottomWidget});
  final String text;
  final Widget? icon;
  final Widget? bottomWidget;
  final StreamWeb3PageProgressController? progressKey;

  @override
  Widget build(BuildContext context) {
    final canUpdate = progressKey?.value.canUpdate ?? false;
    return _ProgressWithTextView(
        text: Column(
          children: [
            LargeTextView([text], maxLine: 3, textAligen: TextAlign.center),
            if (bottomWidget != null) bottomWidget!,
            if (canUpdate) ...[
              WidgetConstant.height20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                      onPressed: () {
                        progressKey?.idle();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: Text("back_to_the_page".tr))
                ],
              )
            ]
          ],
        ),
        icon: icon);
  }
}

class _ProgressWithTextView extends StatelessWidget {
  const _ProgressWithTextView({required this.text, this.icon});
  final Widget text;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon ?? const CircularProgressIndicator(),
        WidgetConstant.height8,
        text
      ],
    );
  }
}
