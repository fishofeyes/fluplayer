import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:fluplayer/common/common.dart';

class CommonAes {
  static const headerIdentifier = "umbonal";
  static const apiIdxKey = {true: "api_middle_idx", false: "api_no_middle_idx"};
  static const apiMap = {
    true: [
      "YXBpLmZsdXBsYXkN8nDPCbd6RR2bzllcmlvLmNvbQ==",
      "YXBpLkN8nDPCbd6RR2bzmZsdXBsYXllcmplLmNvbQ==",
    ],
    false: [
      "YXBpLmkN8nDPCbd6RR2bzZsdXBsYXllcnVjaS5jb20=",
      "YkN8nDPCbd6RR2bzXBpLmZsdXBsYXllcnRjcy5jb20=",
    ],
  };

  static String getRequestUrl(bool isMiddle, int idx) {
    final desc = CommonAes.apiMap[isMiddle]![idx];
    return "https://${utf8.decode(base64Decode(desc.replaceAll("kN8nDPCbd6RR2bz", "")))}";
  }

  static String getUrl(String sender) {
    final myKey = utf8.decode(
      base64Decode(
        (isProd
                ? "aGNqbEw4YmE5STB3Q3ZTdmpMxjgypeBUXXQXo2QT09"
                : "MlFSMxjgypeBUXYUtVWGc4WS9ScUJQSkppQXlWQT09")
            .replaceAll("MxjgypeBUX", ""),
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
        (isProd
                ? "Tm9kaGVxVFgxSGJ3VkhXSnlGR3kwR250M3FLVMxjgypeBUXUJnR0Q="
                : "a0NYcFBabnhDdXMxjgypeBUXQ3TG9oRTZKMXI1dEhMNzVDd0JNUVU=")
            .replaceAll("MxjgypeBUX", ""),
      ),
    );

    final key = Key.fromUtf8(myKey);
    final iv = IV.fromUtf8(
      utf8.decode(
        base64Decode(
          "MxjgypeBUXMlhrNGRMbzM4YzlaMlEyYQ==".replaceAll("MxjgypeBUX", ""),
        ),
      ),
    );

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.encrypt(jsonEncode([param]), iv: iv).base64;
  }
}
