import 'package:ohos_pay/iap_data_model.dart';

class QueryProductsParameter {
  final ProductType type;
  final List<String> productIds;

  QueryProductsParameter({required this.type, required this.productIds});

  Map<String, dynamic> toJson() {
    return {
      'type': type.code,
      'productIds': productIds,
    };
  }
}

class PurchaseParameter {
  final String? productId;
  final ProductType? productType;
  final String? developerPayload;

  PurchaseParameter({this.productId, this.productType, this.developerPayload});

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productType': productType?.code,
      'developerPayload': developerPayload,
    };
  }
}

class FinishPurchaseParameter {
  final ProductType? productType;
  final String? purchaseToken;
  final String? purchaseOrderId;

  FinishPurchaseParameter({this.productType, this.purchaseToken, this.purchaseOrderId});

  Map<String, dynamic> toJson() {
    return {
      'productType': productType?.code,
      'purchaseToken': purchaseToken,
      'purchaseOrderId': purchaseOrderId,
    };
  }
}

class QueryPurchasesParameter {
  final PurchaseQueryType queryType;
  final ProductType productType;

  QueryPurchasesParameter({required this.queryType, required this.productType});

  Map<String, dynamic> toJson() {
    return {
      'purchaseQueryType': queryType.code,
      'productType': productType.code,
    };
  }
}
