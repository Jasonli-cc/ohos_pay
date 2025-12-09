import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';

import { common, Context } from '@kit.AbilityKit';
import Logger from './Logger';
import { iap } from '@kit.IAPKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'OhosPayPlugin';

/** OhosPayPlugin **/
export default class OhosPayPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "OhosPayPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "chanwind_ohos_pay");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getPlatformVersion") {
      result.success("OpenHarmony ^ ^ ")
    }else if(call.method == "isAvailable"){
       iap.queryEnvironmentStatus(getContext(this)  as common.UIAbilityContext).then(() => {
        Logger.info(TAG, 'Succeeded in querying environment status.');
        result.success(true)
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to query environment status. Code is ${err.code}, message is ${err.message}`);
        result.success(false)
      })
    }
    else if(call.method == "queryProducts"){
      this.queryProducts(call, result);
    }
    else if(call.method == "buy"){
      this.buy(call, result);
    }
    else if(call.method == "finishPurchase"){
      this.finishPurchase(call,result)
    }else if(call.method == "restore"){
      this.restore(call, result)
    }else if(call.method == "queryPurchases"){
      this.queryPurchase(call, result)
    }
     else {
      result.notImplemented()
    }
  }


  queryProducts(call:MethodCall, result: MethodResult):void{
    let productType = call.argument("type") as number
    let productIds = call.argument("productIds") as string[]
    Logger.info(TAG, `queryProducts begin productType=${productType}  productIds=${productIds}`);
    const queryProductParam: iap.QueryProductsParameter = {
      productType: productType,
      productIds: productIds,
    };
    iap.queryProducts(getContext(this) as common.UIAbilityContext, queryProductParam).then((res) => {
      Logger.info(TAG, 'Succeeded in querying products.');
      result.success(JSON.stringify(res));
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to query products. Code is ${err.code}, message is ${err.message}`);
      result.error(err.code.toString(), err.message, err);
    });
  }

  buy(call:MethodCall, result: MethodResult):void{
    try {
      let productId = call.argument("productId") as string
      let productType = call.argument("productType") as number
      let developerPayload = call.argument("developerPayload") as string
      const createPurchaseParam: iap.PurchaseParameter = {
        productId: productId,
        productType: productType,
        developerPayload: developerPayload,
      }
      iap.createPurchase(getContext(this) as common.UIAbilityContext, createPurchaseParam).then((res) => {
        const msg: string = 'Succeeded in creating purchase.';
        Logger.info(TAG, msg);
        result.success(JSON.stringify(res))
      }).catch((err: BusinessError) => {
        const msg: string = `Failed to create purchase. Code is ${err.code}, message is ${err.message}`;
        Logger.error(TAG, msg);
        result.error(err.code.toString(), err.message, msg)
      })
    } catch (err) {
      const e: BusinessError = err as BusinessError;
      const msg: string = `Failed to create purchase. Code is ${e.code}, message is ${e.message}`;
      Logger.error(TAG, msg);
      result.error(e.code.toString(), e.message, msg)
    }
  }

  finishPurchase(call:MethodCall, result: MethodResult):void{
    Logger.info(TAG, 'finishPurchase begin');
    let productType = call.argument("productType") as number
    let purchaseToken = call.argument("purchaseToken") as string
    let purchaseOrderId = call.argument("purchaseOrderId") as string

    const finishPurchaseParam: iap.FinishPurchaseParameter = {
      productType: productType,
      purchaseToken: purchaseToken,
      purchaseOrderId: purchaseOrderId
    };
    iap.finishPurchase(getContext(this) as common.UIAbilityContext, finishPurchaseParam).then(() => {
      Logger.info(TAG, 'Succeeded in finishing purchase.');
      result.success(true)
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to finish purchase. Code is ${err.code}, message is ${err.message}`);
      result.error(err.code.toString(), err.message, err.message)
    });
  }

  restore(call:MethodCall, result: MethodResult):void{
    let context = getContext(this) as common.UIAbilityContext;
    let param: iap.UIWindowParameter = {
      windowScreenMode: iap.WindowScreenMode.FULLSCREEN
    };
    iap.showManagedSubscriptions(context, param);
  }

  queryPurchase(call:MethodCall, result: MethodResult):void{
    let productType = call.argument("productType") as number
    let queryType = call.argument("purchaseQueryType") as number
    const param: iap.QueryPurchasesParameter = {
      productType: productType,
      queryType: queryType
    }
    iap.queryPurchases(getContext(this) as common.UIAbilityContext, param).then((res: iap.QueryPurchaseResult) => {
      Logger.info(TAG, 'Succeeded in querying purchases.');
      const purchaseDataList: string[] = res.purchaseDataList;
      result.success(JSON.stringify(purchaseDataList))
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to query purchases. Code is ${err.code}, message is ${err.message}`);
      result.error(err.code.toString(), err.message, err.message)
    })
  }



}