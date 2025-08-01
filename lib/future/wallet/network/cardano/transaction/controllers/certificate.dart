import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:on_chain/ada/src/builder/builder/certificate_builder.dart';
import 'package:on_chain/ada/src/models/certificate/core/types.dart';
import 'package:on_chain/ada/src/provider/blockfrost/models/models/epoch_parameters.dart';
import 'package:on_chain_wallet/future/state_managment/state_managment.dart';
import 'package:on_chain_wallet/future/wallet/network/cardano/transaction/types/types.dart';
import 'package:on_chain_wallet/future/wallet/transaction/fields/fields.dart';

mixin ADATransactionCertificateController on BaseADATransactionController {
  ADAEpochParametersResponse get latestEpochParams;
  final LiveFormFields<ADATransactionCertificate> certificates = LiveFormFields(
      title: "certificates".tr, subtitle: "add_certificate_to_transaction".tr);
  List<ADATransactionDeposit> _deposit = [];
  List<ADATransactionDeposit> get deposit => _deposit;
  List<ADATransactionDeposit> _refund = [];
  List<ADATransactionDeposit> get refund => _refund;
  List<ADACertificateBuilder> _certificateBuilders = [];
  List<ADACertificateBuilder> get certificateBuilders => _certificateBuilders;
  void onUpdateCertificate(ADATransactionCertificate? newCertificate) {
    if (newCertificate == null) return;
    certificates.addValue(newCertificate);
    _buildDeposit();
    _buildBuilders();
  }

  void onRemoveCertificate(ADATransactionCertificate certificate) {
    certificates.removeValue(certificate);
    _buildDeposit();
    _buildBuilders();
  }

  void _buildDeposit() {
    final List<ADATransactionDeposit> deposits = [];
    final List<ADATransactionDeposit> refund = [];
    for (final i in certificates.value) {
      if (i.type == ADATransactionCertificateType.registraction) {
        deposits.add(ADATransactionDeposit.amount(
            type: ADACustomFeeTypes.stakeRegistration,
            fee: latestEpochParams.keyDeposit,
            network: network));
      } else if (i.type == ADATransactionCertificateType.deregistration) {
        refund.add(ADATransactionDeposit.amount(
            type: ADACustomFeeTypes.stakeRegistration,
            fee: latestEpochParams.keyDeposit,
            network: network));
      }
    }
    _deposit = deposits.immutable;
    _refund = refund.immutable;
  }

  void _buildBuilders() {
    final sortedCerificates =
        certificates.value.map((e) => e.certificate).toList()
          ..sort((a, b) {
            final aType = a.certificate.type;
            final bType = b.certificate.type;
            if (aType == CertificateType.stakeRegistration &&
                bType != CertificateType.stakeRegistration) {
              return -1;
            } else if (aType != CertificateType.stakeRegistration &&
                bType == CertificateType.stakeRegistration) {
              return 1;
            }
            return 0;
          });
    _certificateBuilders = sortedCerificates;
  }
}
