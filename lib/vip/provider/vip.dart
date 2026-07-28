import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluplayer/common/common_enum.dart';
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

final _llList = ["gBCEi", "sEIzcDL", "RKUpnI"];

@Riverpod(keepAlive: true)
class Vip extends _$Vip {
  final instance = InAppPurchase.instance;
  List<ProductDetails> details = [];
  Map<String, dynamic>? data;
  bool firstBuy = false;
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
          await _buyRequest(tranc);
          EasyLoading.dismiss();
        case PurchaseStatus.error:
          EasyLoading.showError(tranc.error!.message);
        case PurchaseStatus.restored:
          await _buyRequest(tranc);
          EasyLoading.dismiss();
        case PurchaseStatus.canceled:
          final model = state.models.firstWhereOrNull(
            (e) => e.id == tranc.productID,
          );
          if (model != null) {
            CommonReport.eventThings(
              ThingEnum.premiwqfumFail,
              data: {"PuUTVimak": _llList[model.type - 1]},
            );
          }
          EasyLoading.dismiss();
      }
      for (final i in data) {
        instance.completePurchase(i);
      }
    });
  }

  void buyVip(Map<String, dynamic>? sender) {
    EasyLoading.show();

    final curr = ref.read(vipChooseProvider);
    final model = state.models.firstWhereOrNull((e) => e.id == curr);
    final del = details.firstWhereOrNull((e) => e.id == curr);
    data = sender;

    if (del != null) {
      firstBuy = true;
      data?["PuUTVimak"] = _llList[(model?.type ?? 1) - 1];
      CommonReport.eventThings(ThingEnum.premiuTHTLmClick, data: data);
      final p = PurchaseParam(productDetails: del);
      InAppPurchase.instance.buyNonConsumable(purchaseParam: p);
    } else {
      EasyLoading.showError("Product unavailable");
    }
  }

  Future<void> _buyRequest(PurchaseDetails sender) async {
    final res = await HttpHelper.dio2.postUri(
      Uri.parse("https://uyp.fluplayerapp.com/melanoids/zybah8e4da/overscream"),
      options: Options(headers: {"skulled": "spicehouse"}),
      data: {
        "bossdom": await CommonReport.uniqueId(),
        "sukey": firstBuy,
        "bistort": (await CommonReport.package()).packageName,
        "catchflies": sender.productID,
        "severals": 1,
        "agtpuuq_lv": int.parse(sender.transactionDate ?? "0"),
        "fidos": sender.status.index,
        "wytzl_ufka": sender.verificationData.serverVerificationData,
      },
    );
    firstBuy = false;
    final r = res.data['knelling'];
    if (r["aphanesite"] == true) {
      final time = r['overserene'] ?? 0;
      final id = r['catchflies'];
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
      if (firstBuy) {
        CommonReport.eventThings(ThingEnum.premiBdUumSuc, data: data);
      }
    } else {
      clear();
    }
  }

  void clear() {
    globalOpenVip = false;
    state = state.copyWith(isVip: false);
    EasyLoading.dismiss();
  }

  Future<void> init(String vipText) async {
    final vip = jsonDecode(vipText);
    List<VipModel> models = [];
    final t = vip["models"];
    for (final i in t) {
      models.add(VipModel.fromJson(i));
    }
    globalDefaultVipId = vip["defaultId"];
    if (state.models.isEmpty) {
      state = state.copyWith(models: models);
    }
    if (details.isEmpty) {
      getGoods();
    }
  }

  Future<void> getGoods() async {
    if (!(await instance.isAvailable())) {
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
                desc: details.firstWhereOrNull((e2) => e2.id == e.id)?.price,
              ),
            )
            .toList(),
      );
    }
  }

  void redeem(bool showStatus) async {
    if (await instance.isAvailable()) {
      if (showStatus) {
        EasyLoading.show();
      }
      try {
        await instance.restorePurchases();
      } catch (e) {
        print("error = $e");
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
