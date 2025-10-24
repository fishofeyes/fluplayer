import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluplayer/common/common_report/common_report.dart';
import 'package:fluplayer/common/request/http_helper.dart';
import 'package:fluplayer/vip/model/vip_model.dart';
import 'package:fluplayer/vip/provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:collection/collection.dart';
part 'vip.g.dart';

@Riverpod(keepAlive: true)
class Vip extends _$Vip {
  final instance = InAppPurchase.instance;
  List<ProductDetails> details = [];
  bool isLoading = false;
  @override
  VipState build() {
    _listener();
    return VipState();
  }

  void _listener() async {
    if (!(await instance.isAvailable())) {
      print("appstore is not use");
      return;
    }
    instance.purchaseStream.listen((data) async {
      if (data.isEmpty) {
        clear();
        return;
      }
      data.sort(
        (a, b) => (int.parse(
          b.transactionDate ?? "0",
        )).compareTo(int.parse(a.transactionDate ?? "0")),
      );
      final tranc = data.first;
      final status = tranc.status;
      switch (status) {
        case PurchaseStatus.pending:
        case PurchaseStatus.purchased:
          await _buyRequest(tranc, true);
          EasyLoading.dismiss();
        case PurchaseStatus.error:
          EasyLoading.showError(tranc.error!.message);
        case PurchaseStatus.restored:
          await _buyRequest(tranc, false);
          EasyLoading.dismiss();
        case PurchaseStatus.canceled:
          EasyLoading.dismiss();
      }
    });
  }

  void buyVip() {
    if (isLoading) return;
    isLoading = true;
    EasyLoading.show();
    final curr = ref.read(vipChooseProvider);
    final model = state.models.firstWhereOrNull((e) => e.id == curr);
    final del = details.firstWhereOrNull((e) => e.id == curr);
    if (del != null) {
      final p = PurchaseParam(productDetails: del);
      if (model?.type == 3) {
        InAppPurchase.instance.buyConsumable(purchaseParam: p);
      } else {
        InAppPurchase.instance.buyNonConsumable(purchaseParam: p);
      }
    } else {
      isLoading = false;
      EasyLoading.showError("Product unavailable");
    }
  }

  Future<void> _buyRequest(PurchaseDetails sender, bool firstBuy) async {
    final res = await HttpHelper.dio2.postUri(
      Uri.parse("https://fpyr.fluplayer.com/anomalurus/pyruvates/covid"),
      options: Options(headers: {"taxw8ego86": "insolvable"}),
      data: {
        "nassau": await CommonReport.uniqueId(),
        "overloan": (await CommonReport.package()).packageName,
        "pn2id44xb_": sender.productID,
        "moraller": {
          "finickily": (await CommonReport.device())?.identifierForVendor,
        },
        "portrays": sender.verificationData.serverVerificationData,
      },
    );
    final r = res.data['governor'];
    if (r["overkick"] == true) {
      final rf = r['delthyrium'][0];
      final time = rf['gabbais'] ?? 0;
      final id = rf['pn2id44xb_'];
      final p = state.models.firstWhere((e) => e.id == id);
      final desc = vipPriceMap[p.type]!;
      state = state.copyWith(
        isVip: true,
        expired: p.type == 3
            ? "Lifetime"
            : DateFormat(
                "yyyy/MM/dd",
              ).format(DateTime.fromMillisecondsSinceEpoch(time)),
        desc: p.type == 3 ? desc : desc.replaceAll("##", p.desc),
      );
      globalOpenVip = true;
    } else {
      clear();
    }
    isLoading = false;
  }

  void clear() {
    globalOpenVip = false;
    state = state.copyWith(isVip: false);
    EasyLoading.dismiss();
  }

  void init(String vipText) {
    final vip = jsonDecode(vipText);
    List<VipModel> models = [];
    final t = vip["models"];
    for (final i in t) {
      models.add(VipModel.fromJson(i));
    }
    globalDefaultVipId = vip["defaultId"];
    state = state.copyWith(models: models);
  }

  void getGoods() async {
    if (await instance.isAvailable()) {
      print("app store is available");
      return;
    }
    final res = await instance.queryProductDetails(
      state.models.map((e) => e.id).toSet(),
    );
    details = res.productDetails;
    if (details.isNotEmpty) {
      state = state.copyWith(
        models: state.models
            .map(
              (e) => e.copyWith(
                desc: details.firstWhere((e2) => e2.id == e.id).price,
              ),
            )
            .toList(),
      );
    }
  }

  void redeem(bool showStatus) async {
    if (isLoading) return;
    if (await instance.isAvailable()) {
      isLoading = true;
      if (showStatus) {
        EasyLoading.show();
      }
      try {
        await instance.restorePurchases();
        isLoading = false;
      } catch (e) {
        print("error = $e");
        isLoading = false;
        EasyLoading.dismiss();
      }
    }
  }
}

class VipState {
  final List<VipModel> models;
  final String? expired;
  final String? desc;
  final bool isVip;

  VipState({
    this.models = const [],
    this.expired,
    this.desc,
    this.isVip = false,
  });

  VipState copyWith({
    List<VipModel>? models,
    String? expired,
    String? desc,
    bool? isVip,
  }) {
    return VipState(
      models: models ?? this.models,
      expired: expired ?? this.expired,
      desc: desc ?? this.desc,
      isVip: isVip ?? this.isVip,
    );
  }
}
