// ignore_for_file: prefer_is_empty

import 'package:encrypt/encrypt.dart';

class ClsCrypto {
  late Key iv;
  late Key key;
  late Encrypter encrypter;
  late IV initializationVector;

  ClsCrypto(String strIV) {
    if (strIV.length > 16) {
      strIV = strIV.substring(0, 16);
    } else if (strIV.length < 16 && strIV.length != 0) {
      strIV = strIV.padRight(16, '*');
    } else {
      strIV = "\$@J@Y@_3RP\$Y\$T3M"; //Default IV
    }

    var keyString = "\$@J@Y@3NT3RPRI\$3R3\$OURC3PL@NNING";
    iv = Key.fromUtf8(strIV);
    key = Key.fromUtf8(keyString);
    encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    initializationVector = IV.fromUtf8(strIV);
  }

  String encrypt(String strPlainText) {
    if (strPlainText.isEmpty) {
      // Handle empty string. This could be returning an empty string,
      // a default value, or throwing a custom exception.
      return ''; // or any other appropriate handling
    }

    final encryptedText =
        encrypter.encrypt(strPlainText, iv: initializationVector);
    return encryptedText.base64;
  }

  String decrypt(String encryptedText) {
    final encryptedBytes = Encrypted.fromBase64(encryptedText);
    final decryptedText =
        encrypter.decrypt(encryptedBytes, iv: initializationVector);
    return decryptedText;
  }
}
