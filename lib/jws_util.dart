import 'dart:convert';

class JWSUtil {
  static String decodeJwsObj(String data) {
    final parts = data.split('.');
    if (parts.length < 3) {
      return '';
    }
    String payload = parts[1];
    payload = payload.replaceAll('-', '+').replaceAll('_', '/');
    final pad = payload.length % 4;
    if (pad != 0) {
      if (pad == 1) {
        return '';
      }
      payload += '=' * (4 - pad);
    }
    try {
      final bytes = base64.decode(payload);
      return utf8.decode(bytes);
    } catch (_) {
      return '';
    }
  }
}
