import 'dart:convert';
import 'package:ohos_pay/jws_util.dart';

enum ProductType {
  unknown(code: -1),
  consumable(code: 0),
  nonConsumable(code: 1),
  autoRenewable(code: 2),
  noRenewable(code: 3);

  final int code;

  const ProductType({required this.code});
}

enum PurchaseQueryType {
  all(code: 0),
  unfinished(code: 1),
  currentEntitlement(code: 2);

  final int code;
  const PurchaseQueryType({required this.code});
}

class PurchaseData {
  final ProductType type;
  final String? jwtPurchaseOrder;
  final String? jwsSubscriptionStatus;

  PurchaseData({required this.type, required this.jwtPurchaseOrder, required this.jwsSubscriptionStatus});

  PurchaseOrderPayload? get purchaseOrderPayload =>
      jwtPurchaseOrder != null ? PurchaseOrderPayload.fromJson(jsonDecode(JWSUtil.decodeJwsObj(jwtPurchaseOrder!)) as Map<String, dynamic>) : null;

  SubGroupStatusPayload? get subscriptionStatusPayload =>
      jwsSubscriptionStatus != null ? SubGroupStatusPayload.fromJson(jsonDecode(JWSUtil.decodeJwsObj(jwsSubscriptionStatus!)) as Map<String, dynamic>) : null;

  PurchaseData.fromJson(Map<String, dynamic> json)
      : type = ProductType.values.where((e) => e.code == json['type']).firstOrNull ?? ProductType.unknown,
        jwtPurchaseOrder = json['jwtPurchaseOrder'],
        jwsSubscriptionStatus = json['jwsSubscriptionStatus'];
}

class PurchaseOrderPayload {
  final String productId;
  final ProductType productType;
  final String purchaseOrderId;
  final String purchaseToken;
  final FinishStatus? finishStatus;

  PurchaseOrderPayload({
    required this.productId,
    required this.productType,
    required this.purchaseOrderId,
    required this.purchaseToken,
    required this.finishStatus,
  });

  factory PurchaseOrderPayload.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderPayload(
      productId: json['productId'],
      productType: ProductType.values.firstWhere((e) => e.code == json['productType']),
      purchaseOrderId: json['purchaseOrderId'],
      purchaseToken: json['purchaseToken'],
      finishStatus: FinishStatus.fromCode(json['finishStatus']),
    );
  }
}

enum FinishStatus {
  finished('1'),
  unfinished('2');

  const FinishStatus(this.code);

  static FinishStatus? fromCode(String? code) {
    return FinishStatus.values.where((e) => e.code == code).firstOrNull;
  }

  final String code;
}

class SubGroupStatusPayload {
  final String subGroupGenerationId;
  final String subscriptionId;
  final String purchaseToken;
  final String status;
  final int expiresTime;
  final PurchaseOrderPayload? lastPurchaseOrder;
  final SubRenewalInfo? renewalInfo;

  SubGroupStatusPayload({
    required this.subGroupGenerationId,
    required this.subscriptionId,
    required this.purchaseToken,
    required this.status,
    required this.expiresTime,
    required this.lastPurchaseOrder,
    required this.renewalInfo,
  });

  factory SubGroupStatusPayload.fromJson(Map<String, dynamic> json) {
    return SubGroupStatusPayload(
      subGroupGenerationId: json['subGroupGenerationId'],
      subscriptionId: json['subscriptionId'],
      purchaseToken: json['purchaseToken'],
      status: json['status'],
      expiresTime: json['expiresTime'],
      lastPurchaseOrder: json['lastPurchaseOrder'] != null ? PurchaseOrderPayload.fromJson(json['lastPurchaseOrder']) : null,
      renewalInfo: json['renewalInfo'] != null ? SubRenewalInfo.fromJson(json['renewalInfo']) : null,
    );
  }
}

class SubRenewalInfo {
  final String productId;

  factory SubRenewalInfo.fromJson(Map<String, dynamic> json) {
    return SubRenewalInfo(
      productId: json['productId'],
    );
  }

  SubRenewalInfo({required this.productId});
}

enum SubStatus {
  active('1'),
  expired('2'),
  chargeAttempt('3'),
  revoked('5');

  final String code;

  const SubStatus(this.code);
}

enum ProductStatus {
  valid(code: 0),
  canceled(code: 1),
  offline(code: 3),
  ;

  final int code;

  const ProductStatus({required this.code});
}

class Product {
  final String id;
  final ProductType type;
  final String name;
  final String description;
  final String localPrice;
  final ProductStatus status;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      type: ProductType.values.firstWhere((e) => e.code == json['type']),
      name: json['name'],
      description: json['description'],
      localPrice: json['localPrice'],
      status: ProductStatus.values.firstWhere((e) => e.code == json['status']),
    );
  }

  Product({required this.id, required this.type, required this.name, required this.description, required this.localPrice, required this.status});
}
