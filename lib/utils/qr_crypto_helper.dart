import 'dart:convert';
import 'package:encrypt/encrypt.dart' as enc;

class QrCryptoHelper {
  // 🔐 32 chars = AES-256
  static const String _secretKey = 'SUTJAN_CONTAINER';
  static const _ivString = "1234567890123456";

  /// Encrypt plain text → unreadable QR data
  static String encryptQR(String plainText) {
    final key = enc.Key.fromUtf8(_secretKey);

    // IV must be 16 chars = 128-bit
    final iv = enc.IV.fromUtf8(_ivString);

    final encrypter = enc.Encrypter(enc.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print('Encrypted: ${encrypted.base64}');

    // Combine IV + cipher text
    return encrypted.base64;
  }

  /// Decrypt scanned QR → original data
  static String decrypt(String encryptedText) {
    // Make sure key is exactly 16 bytes
    final keyString = _secretKey.padRight(16, '0').substring(0, 16);
    final key = enc.Key.fromUtf8(keyString);

    final iv = enc.IV.fromUtf8(_ivString); // 16 bytes
    final encrypter = enc.Encrypter(enc.AES(key));

    try {
      final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
      print("============decrypted===="+decrypted);
      return decrypted;
    } catch (e) {
      print("❌ Decryption failed: $e");
      return "";
    }
  }

  static bool isBase64(String str) {
    try {
      // Try to decode; if it fails, it's not Base64
      base64.decode(str);
      return true;
    } catch (_) {
      return false;
    }
  }

}
