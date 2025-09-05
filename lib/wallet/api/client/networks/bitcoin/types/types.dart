class BitcoinBlockTransactionInfo {
  final bool confirmed;
  final DateTime? blockTime;
  final String txId;
  const BitcoinBlockTransactionInfo(
      {required this.confirmed, required this.blockTime, required this.txId});
}
