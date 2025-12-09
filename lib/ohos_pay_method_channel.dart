import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ohos_pay/exception.dart';
import 'ohos_pay.dart';

class MethodChannelOhosPay extends OhosPay {
  @visibleForTesting
  final methodChannel = const MethodChannel('chanwind_ohos_pay');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> isAvailable() async {
    final available = await methodChannel.invokeMethod<bool>('isAvailable');
    return available ?? false;
  }

  @override
  Future<List<Product>> queryProducts(QueryProductsParameter parameter) async {
    try {
      final productStr = await methodChannel.invokeMethod<String>('queryProducts', parameter.toJson());
      print("MethodChannelOhosPay queryProducts: $productStr");
      final products = json.decode(productStr!) as List;
      return (products).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    } on PlatformException catch (e) {
      throw OhosPayException(e.code, e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PurchaseData> buy(PurchaseParameter param) async {
    try {
      final purchaseData = await methodChannel.invokeMethod<String>('buy', param.toJson());
      print("MethodChannelOhosPay buy: $purchaseData");
      final jsonData = json.decode(purchaseData!) as Map<String, dynamic>;
      print("MethodChannelOhosPay buy: $jsonData");
      return PurchaseData.fromJson(jsonData);
    } on PlatformException catch (e) {
      throw OhosPayException(e.code, e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> finishPurchase(FinishPurchaseParameter param) async {
    try {
      await methodChannel.invokeMethod<void>('finishPurchase', param.toJson());
    } on PlatformException catch (e) {
      throw OhosPayException(e.code, e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> restore() async {
    try {
      await methodChannel.invokeMethod<void>('restore');
    } on PlatformException catch (e) {
      throw OhosPayException(e.code, e.message);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PurchaseData>> queryPurchases(QueryPurchasesParameter parameter) async {
    try {
      final purchases = await methodChannel.invokeMethod<String>('queryPurchases', parameter.toJson());
      print("MethodChannelOhosPay queryPurchases: $purchases");
      final jsonData = json.decode(purchases!) as List;
      return (jsonData).map((e) => PurchaseData.fromJson(json.decode(e) as Map<String, dynamic>)).toList();
    } on PlatformException catch (e) {
      throw OhosPayException(e.code, e.message);
    } catch (e) {
      rethrow;
    }
  }
}
