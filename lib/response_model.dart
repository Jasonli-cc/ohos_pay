class ChannelResponseModel {
  final String code;
  final String? msg;
  final String? data;

  bool get isOk => code == "0";

  ChannelResponseModel({required this.code, required this.msg, required this.data});
}
