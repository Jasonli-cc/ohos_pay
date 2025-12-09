enum IAPErrorCode {
  userCanceled(code: '1001860000'),
  systemError(code: '1001860001'),
  appNotAuthorized(code: '1001860002'),
  invalidProduct(code: '1001860003'),
  frequentCalls(code: '1001860004'),
  networkError(code: '1001860005'),
  accountNotLoggedIn(code: '1001860050'),
  productOwned(code: '1001860051'),
  purchaseNotPaid(code: '1001860052'),
  purchaseFinished(code: '1001860053'),
  accountTerritoryNotSupported(code: '1001860054'),
  userNotAllowed(code: '1001860056'),
  custom(code: '-1'),
  notAvailable(code: '-2'),
  ;

  final String code;

  const IAPErrorCode({required this.code});
}

class OhosPayException implements Exception {
  final String? code;
  final String? message;

  OhosPayException(this.code, this.message);

  @override
  String toString() => '$message($code)';
}
