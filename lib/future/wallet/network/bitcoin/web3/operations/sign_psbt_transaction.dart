import 'package:bitcoin_base/bitcoin_base.dart';
import 'package:flutter/material.dart';
import 'package:on_chain_wallet/app/core.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/controllers/signer.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/web3/controllers/controllers.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/web3/controllers/provider.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/web3/pages/sign_transaction.dart';
import 'package:on_chain_wallet/future/wallet/network/bitcoin/web3/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/core/web3.dart';
import 'package:on_chain_wallet/wallet/api/client/networks/bitcoin/core/core.dart';
import 'package:on_chain_wallet/wallet/chain/account.dart';
import 'package:on_chain_wallet/wallet/models/others/models/receipt_address.dart';
import 'package:on_chain_wallet/wallet/models/transaction/core/transaction.dart';
import 'package:on_chain_wallet/wallet/models/transaction/networks/bitcoin.dart';
import 'package:on_chain_wallet/wallet/web3/constant/constant/exception.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/constant/constants/exception.dart';
import 'package:on_chain_wallet/wallet/web3/networks/bitcoin/params/models/transaction.dart';

class Web3BitcoinSignTransactionStateController
    extends Web3BitcoinTransactionStateController<
        String,
        BaseWeb3BitcoinSignTransaction,
        IWeb3BitcoinSignPsbtTransactionData,
        IWeb3BitcoinPsbtTransaction,
        IWeb3BitcoinSignedPSBTTransaction>
    with
        BitcoinWeb3TransactionApiController,
        BitcoinTransactionSignerController {
  IWeb3BitcoinSignPsbtTransactionData? _transactionData;
  IWeb3BitcoinSignPsbtTransactionData get transactionData => _transactionData!;
  BasedUtxoNetwork get utxoNetwork => network.coinParam.transacationNetwork;

  Web3BitcoinSignTransactionStateController(
      {required super.walletProvider, required super.request});

  @override
  Future<IWeb3BitcoinPsbtTransaction> buildTransaction(
      {bool simulate = false}) async {
    final transactionData = await buildTransactionData(simulate: simulate);
    return IWeb3BitcoinPsbtTransaction(
        account: defaultAccount,
        transactionData: transactionData,
        accounts: transactionData.accountInputs
            .map((e) => e.ownerAddress)
            .whereType<IBitcoinAddress>()
            .toList());
  }

  int _getInputSigHash(int? sighash, BitcoinBaseAddress address) {
    if (sighash != null) return sighash;
    switch (utxoNetwork) {
      case BitcoinSVNetwork.mainnet:
      case BitcoinSVNetwork.testnet:
      case BitcoinCashNetwork.testnet:
      case BitcoinCashNetwork.mainnet:
        return BitcoinOpCodeConst.sighashAll | BitcoinOpCodeConst.sighashForked;
      default:
        if (address.type.isP2tr) return BitcoinOpCodeConst.sighashDefault;
        return BitcoinOpCodeConst.sighashAll;
    }
  }

  ReceiptAddress<BitcoinBaseAddress>? _getReceiptAddress(
      BitcoinBaseAddress? address) {
    if (address == null) return null;
    final addressStr = address.toAddress(utxoNetwork);
    return account.getReceiptAddress(addressStr) ??
        ReceiptAddress(view: addressStr, networkAddress: address);
  }

  @override
  Future<IWeb3BitcoinSignPsbtTransactionData> buildTransactionData(
      {bool simulate = false}) async {
    return _transactionData ??= await () async {
      final Psbt psbt = request.params.psbt;
      final builder = PsbtBuilder.fromPsbt(psbt);
      final List<IBitcoinAddress> activeAccount = request.accounts;
      final inputLength = psbt.input.length;
      List<BitcoinPsbtInputWithAccount> inputs = [];
      List<PsbtBitcoinOutputWithBalance> outputs = [];
      final sighashes =
          PsbtUtils.getAllExistsSighashType(psbt.input, builder.txType());
      for (int i = 0; i < inputLength; i++) {
        final signash = sighashes.firstWhereOrNull((e) => e.inputIndex == i);

        final psbtInput = builder.psbtInput(i);
        final psbtAddress = psbtInput.address;
        IBitcoinAddress? address;
        final accountAddress =
            this.account.findAddressFromScript(psbtAddress.toScriptPubKey());
        if (accountAddress != null) {
          address =
              this.account.getAddress(accountAddress.toAddress(utxoNetwork));
        }
        final inputSighash =
            _getInputSigHash(signash?.sighashType, psbtAddress);
        final account = activeAccount.firstWhereOrNull(
            (e) => e.networkAddress.toScriptPubKey() == psbtInput.scriptPubKey);
        if (account != null) {
          if (address == null) {
            throw Web3RequestExceptionConst.missingPermission;
          }
        }
        final inputWithAccount = BitcoinPsbtInputWithAccount(
            owner: address?.toUtxoRequest,
            input: psbtInput.txInput,
            index: i,
            address: _getReceiptAddress(accountAddress ?? psbtAddress)!,
            sighash: inputSighash,
            ownerAddress: address,
            network: network);
        inputs.add(inputWithAccount);
      }
      if (inputs.isEmpty || inputs.every((e) => e.owner == null)) {
        throw Web3BitcoinExceptionConstant.noRelatedInput;
      }
      inputs = await readAccountPsbtUtxos(inputs);
      final outputLength = psbt.output.length;
      for (int i = 0; i < outputLength; i++) {
        final psbtOutput = builder.psbtOutput(i);
        final currentAddress =
            account.findAddressFromScript(psbtOutput.scriptPubKey);
        final output = PsbtBitcoinOutputWithBalance(
          address: _getReceiptAddress(currentAddress ?? psbtOutput.address),
          network: network,
          scriptPubKey: psbtOutput.scriptPubKey,
          balance: psbtOutput.amount,
        );
        outputs.add(output);
      }

      final totalAccountInput = inputs.fold<BigInt>(BigInt.zero, (p, c) {
        if (c.owner == null) return p;
        return p + c.balance.balance;
      });
      final totalInput =
          inputs.fold<BigInt>(BigInt.zero, (p, c) => p + c.balance.balance);
      final totalOutput =
          outputs.fold<BigInt>(BigInt.zero, (p, c) => p + c.balance.balance);
      return IWeb3BitcoinSignPsbtTransactionData(
          inputs: inputs,
          accountInputs: inputs.where((e) => e.owner != null).toList(),
          psbt: psbt,
          totalOutput: IntegerBalance.token(totalOutput, network.token,
              allowNegative: false, immutable: true),
          fee: IntegerBalance.token(totalInput - totalOutput, network.token,
              allowNegative: true, immutable: true),
          builder: builder,
          totalInput: IntegerBalance.token(totalInput, network.token,
              allowNegative: false, immutable: true),
          totalAccountInput: IntegerBalance.token(
              totalAccountInput, network.token,
              allowNegative: false, immutable: true),
          outputs: outputs);
    }();
  }

  @override
  Future<List<IWalletTransaction<BitcoinWalletTransaction, IBitcoinAddress>>>
      buildWalletTransaction(
          {required IWeb3BitcoinSignedPSBTTransaction signedTx,
          required SubmitTransactionSuccess? txId}) async {
    // if (txId == null) return [];
    final String? txHash = txId?.txId ??
        MethodUtils.nullOnException(() {
          final builder = PsbtBuilder.fromBase64(signedTx.finalTransactionData);
          final finalTx = builder.finalizeAll();
          final txId = finalTx.txId();
          return txId;
        });
    if (txHash == null) return [];
    List<IWalletTransaction<BitcoinWalletTransaction, IBitcoinAddress>>
        transactions = [];
    final accounts = signedTx.transaction.accounts.toSet();
    for (final i in accounts) {
      final totalInputs = signedTx.transaction.transactionData.accountInputs
          .where((e) => e.ownerAddress == i)
          .map((e) => e.balance.balance)
          .sum;
      if (totalInputs == BigInt.zero) continue;
      final tx = BitcoinWalletTransaction(
          txId: txHash,
          totalOutput: WalletTransactionIntegerAmount(
              amount: totalInputs, network: network),
          scriptHash: i.networkAddress.pubKeyHash(),
          web3Client: web3ClientInfo(),
          type: WalletTransactionType.web3Sign,
          network: network);
      transactions.add(IWalletTransaction(transaction: tx, account: i));
    }
    return transactions;
  }

  @override
  Future<
          Web3RequestTransactionResponseData<String,
              SubmitTransactionSuccess<IWeb3BitcoinSignedPSBTTransaction>>>
      getResponse() async {
    final transaction = await buildTransaction();
    final signedTx = await signTransaction(transaction);
    return Web3RequestTransactionResponseData(
        response: signedTx.finalTransactionData);
  }

  @override
  Future<IWeb3BitcoinSignedPSBTTransaction> signTransaction(
      IWeb3BitcoinPsbtTransaction transaction,
      {bool fakeSignature = false}) async {
    final transactionData = transaction.transactionData;
    final accountInputs = transactionData.accountInputs;
    final psbt = transactionData.builder.clone();
    final signers = accountInputs
        .map((e) => e.ownerAddress)
        .whereType<IBitcoinAddress>()
        .toList();
    final signedTx = await signPsbtTransaction(
        psbt: psbt,
        signers: signers,
        accountInputs: accountInputs,
        fakeSignature: fakeSignature);
    return IWeb3BitcoinSignedPSBTTransaction(
        transaction: transaction,
        signatures: signedTx.signatures,
        finalTransactionData: signedTx.psbt);
  }

  @override
  Widget widgetBuilder(BuildContext context) {
    return Web3BitcoinSignPSBTTransactionStateView(this);
  }

  @override
  Future<SubmitTransactionResult> submitTransaction(
      {required IWeb3BitcoinSignedPSBTTransaction signedTransaction}) async {
    final builder =
        PsbtBuilder.fromBase64(signedTransaction.finalTransactionData);
    final finalTx = builder.finalizeAll();
    final serialize = finalTx.serialize();
    final txId = await client.sendTransaction(serialize);
    return SubmitTransactionSuccess(
        txId: txId, signedTransaction: signedTransaction);
  }

  @override
  Future<void> initForm(BitcoinClient<IBitcoinAddress> client) async {
    await super.initForm(client);
    _transactionData = await buildTransactionData();
  }
}
