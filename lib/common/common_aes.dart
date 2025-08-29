import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class CommonAes {
  static const headerIdentifier = "laticifer";
  static const apiIdxKey = {true: "api_middle_idx", false: "api_no_middle_idx"};
  static const apiMap = {
    true: [
      "aHR0cHM6Ly9hcGkubWVkaXhzbzsd2kIFCHYWFzaHEuY29t",
      "aHR0cHM6Ly9hcGkubWVkaXhzsd2kIFCHYzcHJpbnRxLmNvbQ==",
    ],
    false: [
      "aHR0cHM6Ly9hcGkubWVkaXhjcnVzzsd2kIFCHYaC5jb20=",
      "aHR0cHM6Ly9zsd2kIFCHYhcGkubWVkaXhjb2NvbnV0LmNvbQ==",
    ],
  };

  static String getRequestUrl(bool isMiddle, int idx) {
    final desc = CommonAes.apiMap[isMiddle]![idx];
    return utf8.decode(base64Decode(desc.replaceAll("zsd2kIFCHY", "")));
  }

  static String getUrl(String sender) {
    final myKey = utf8.decode(
      base64Decode(
        "aGNqbEw4YmE5STB3Q3ZTifSnwFGACAdmpXQXo2QT09".replaceAll(
          "ifSnwFGACA",
          "",
        ),
      ),
    );
    final key = Key.fromBase64(myKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    return encrypter.decrypt(Encrypted.fromBase64(sender), iv: iv);
  }

  // background params aes
  static String getAes(Map<String, dynamic> param) {
    final myKey = utf8.decode(
      base64Decode(
        "Tm92SCqidh7aIkaGVxVFgxSGJ3VkhXSnlGR3kwR250M3FLVUJnR0Q=".replaceAll(
          "2SCqidh7aI",
          "",
        ),
      ),
    );

    final key = Key.fromUtf8(myKey);
    final iv = IV.fromUtf8(
      utf8.decode(
        base64Decode(
          "MlhrNGRMbzM4YzlaMlEyYolVuvkBNziQ==".replaceAll("olVuvkBNzi", ""),
        ),
      ),
    );

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.encrypt(jsonEncode([param]), iv: iv).base64;
  }
}
