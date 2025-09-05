import 'package:blockchain_utils/utils/numbers/rational/big_rational.dart';

class BtcConst {
  static const int decimal = 8;
  static final BigInt minFeePerKb = BigInt.from(1024);
  static final BigRational minMultiSigThresholdRational =
      BigRational.from(minMultiSigThreshold);
  static final BigRational maxMultiSigThresholdRational =
      BigRational.from(maxMultiSigThreshold);
  static final int minMultiSigThreshold = 2;
  static final int maxMultiSigThreshold = 16;
}
