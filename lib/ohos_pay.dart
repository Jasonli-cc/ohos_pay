import 'package:ohos_pay/iap_data_model.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'iap_param.dart';
import 'ohos_pay_method_channel.dart';
export 'iap_data_model.dart';
export 'iap_param.dart';

abstract class OhosPay extends PlatformInterface {
  OhosPay() : super(token: _token);

  static final Object _token = Object();

  static OhosPay _instance = MethodChannelOhosPay();

  static OhosPay get instance => _instance;

  static set instance(OhosPay instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();

  Future<bool> isAvailable();

  Future<List<Product>> queryProducts(QueryProductsParameter parameter);

  Future<PurchaseData> buy(PurchaseParameter param);

  Future<void> finishPurchase(FinishPurchaseParameter param);

  Future<void> restore();

  Future<List<PurchaseData>> queryPurchases(QueryPurchasesParameter parameter);
}
