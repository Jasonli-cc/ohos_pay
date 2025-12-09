class IAPErrorCode {
  static const String userCanceled = "1001860000";
  static const String systemError = "1001860001";
  static const String appNotAuthorized = "1001860002";
  static const String invalidProduct = "1001860003";
  static const String frequentCalls = "1001860004";
  static const String networkError = "1001860005";
  static const String accountNotLoggedIn = "1001860050";
  static const String productOwned = "1001860051";
  static const String purchaseNotPaid = "1001860052";
  static const String purchaseFinished = "1001860053";
  static const String accountTerritoryNotSupported = "1001860054";
  static const String userNotAllowed = "1001860056";
  static const String custom = "-1";
  static const String notAvailable = "-2";
}

class OhosPayException implements Exception {
  final String? code;
  final String? message;

  OhosPayException(this.code, this.message);

  @override
  String toString() => '$message($code)';
}
