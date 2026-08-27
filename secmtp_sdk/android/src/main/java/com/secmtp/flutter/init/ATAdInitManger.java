package com.secmtp.flutter.init;

import androidx.annotation.NonNull;

import android.text.TextUtils;

import com.secmtp.flutter.ATFlutterEventManager;
import com.secmtp.flutter.HandleSecmtpMethod;
import com.secmtp.flutter.utils.BridgeJsonMapUtil;
import com.secmtp.flutter.utils.Const;
import com.secmtp.flutter.utils.FlutterPluginUtil;
import com.secmtp.flutter.utils.MsgTools;
import com.secmtp.flutter.utils.Utils;
import com.secmtp.sdk.core.api.ATGDPRAuthCallback;
import com.secmtp.sdk.core.api.ATGDPRConsentDismissListener;
import com.secmtp.sdk.core.api.ATGDPRConsentDismissListener.ConsentDismissInfo;
import com.secmtp.sdk.core.api.ATSDK;
import com.secmtp.sdk.core.api.ATSharedPlacementConfig;
import com.secmtp.sdk.core.api.ATWaterfallFilter;
import com.secmtp.sdk.core.api.NetTrafficeCallback;
import com.secmtp.sdk.debug.api.ATDebuggerUITest;

import android.app.Activity;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ATAdInitManger implements HandleSecmtpMethod {

    private static class SingletonClassInstance {
        private static final ATAdInitManger instance = new ATAdInitManger();
    }

    public static ATAdInitManger getInstance() {
        return SingletonClassInstance.instance;
    }

    private ATAdInitManger() {
    }

    /** Maps {@link ConsentDismissInfo} to Flutter {@code InitCallName} payload (keys: infoMsg, dismissType). */
    private static Map<String, Object> consentDismissToMap(ConsentDismissInfo info) {
        Map<String, Object> map = new HashMap<>(4);
        if (info != null) {
            map.put("infoMsg", info.getInfoMsg() != null ? info.getInfoMsg() : "");
            map.put("dismissType", info.getDismissType());
        }
        return map;
    }

    @Override
    public boolean handleMethodCall(@NonNull MethodCall methodCall, @NonNull final MethodChannel.Result result) throws Exception {

        switch (methodCall.method) {
            case "initSDK":
                String appID = methodCall.argument(Const.Init.APP_ID_STR);
                String appKey = methodCall.argument(Const.Init.APP_KEY_STR);

                MsgTools.printMsg("initSDK: " + appID + ", " + appKey);
                ATSDK.init(FlutterPluginUtil.getApplicationContext(), appID, appKey);
                result.success("");
                break;
            case "setLogEnabled":
                Boolean logEnable = methodCall.argument(Const.Init.LOG_ENABLE);

                MsgTools.setLogDebug(logEnable);
                MsgTools.printMsg("setLogEnabled: " + logEnable);
                ATSDK.setNetworkLogDebug(logEnable);
                break;
            case "setChannelStr":
                String channelStr = methodCall.argument(Const.Init.CHANNEL_STR);

                MsgTools.printMsg("setChannelStr: " + channelStr);
                ATSDK.setChannel(channelStr);
                break;
            case "setSubchannelStr":
                String subchannelStr = methodCall.argument(Const.Init.SUB_CHANNEL_STR);

                MsgTools.printMsg("setSubchannelStr: " + subchannelStr);
                ATSDK.setSubChannel(subchannelStr);
                break;
            case "setCustomDataDic":
                Map<String, Object> argument = methodCall.argument(Const.Init.CUSTOM_DATA_DIC);
                if (argument != null) {
                    MsgTools.printMsg("setCustomDataDic: " + argument);
                    ATSDK.initCustomMap(argument);
                }
                break;
            case "setExludeBundleIDArray":
                MsgTools.printMsg("setExludeBundleIDArray");
                List<String> bundleIdList = methodCall.argument(Const.Init.EXLUDE_BUNDLE_ID_ARRAY);

                if (bundleIdList != null) {

                    int size = bundleIdList.size();
                    for (int i = 0; i < size; i++) {
                        MsgTools.printMsg("setExludeBundleIDArray: " + bundleIdList.get(i));
                    }

//                    ATSDK.setExcludeMyOfferPkgList(bundleIdList);
                    ATSDK.setExcludePackageList(bundleIdList);
                }
                break;
            case "deniedUploadDeviceInfo":
                MsgTools.printMsg("deniedUploadDeviceInfo");
                List<String> deniedUploadDeviceInfoList = methodCall.argument(Const.Init.DENIED_UPLOAD_INFO_ARRAY);

                if (deniedUploadDeviceInfoList != null) {

                    int size = deniedUploadDeviceInfoList.size();
                    if (size > 0) {
                        String[] deniedArray = new String[size];
                        String info;
                        for (int i = 0; i < size; i++) {
                            info = deniedUploadDeviceInfoList.get(i);
                            deniedArray[i] = info;
                            MsgTools.printMsg("deniedUploadDeviceInfo: " + info);
                        }

                        ATSDK.deniedUploadDeviceInfo(deniedArray);
                        break;
                    }
                }

                try {
                    MsgTools.printMsg("deniedUploadDeviceInfo: empty string");
                    ATSDK.deniedUploadDeviceInfo("");
                } catch (Throwable e) {
                    e.printStackTrace();
                }

                break;
            case "setPlacementCustomData":
                String placementIDStr = methodCall.argument(Const.Init.PLACEMENT_ID_STR);
                Map<String, Object> placementCustomDataMap = methodCall.argument(Const.Init.PLACEMENT_CUSTOM_DATA_DIC);

                MsgTools.printMsg("setPlacementCustomData: " + placementIDStr + ", " + placementCustomDataMap);
                ATSDK.initPlacementCustomMap(placementIDStr, placementCustomDataMap);
                break;
            case "getGDPRLevel":
                int gdprDataLevel = ATSDK.getGDPRDataLevel(FlutterPluginUtil.getApplicationContext());

                MsgTools.printMsg("getGDPRLevel: " + gdprDataLevel);

                String levelString;
                switch (gdprDataLevel) {
                    case ATSDK.PERSONALIZED:
                        levelString = "ATDataConsentSetPersonalized";
                        break;
                    case ATSDK.NONPERSONALIZED:
                        levelString = "ATDataConsentSetNonpersonalized";
                        break;
                    default:
                        levelString = "ATDataConsentSetUnknown";
                        break;
                }
                MsgTools.printMsg("getGDPRLevel: callback to flutter: " + levelString);
                result.success(levelString);
                break;
            case "getUserLocation":
                MsgTools.printMsg("getUserLocation");
                ATSDK.checkIsEuTraffic(FlutterPluginUtil.getApplicationContext(), new NetTrafficeCallback() {
                    @Override
                    public void onResultCallback(boolean b) {
                        MsgTools.printMsg("getUserLocation: onResultCallback: " + b);

                        final String result = b ? "1" : "2";
                        MsgTools.printMsg("getUserLocation: callback to flutter: result: " + result);
                        ATFlutterEventManager.getInstance().sendMsgToFlutter(Const.CallbackMethodCall.InitCallName, Const.InitCallback.locationCallbackKey, result);
                    }

                    @Override
                    public void onErrorCallback(String s) {
                        MsgTools.printMsg("getUserLocation: onErrorCallback: " + s);

                        ATFlutterEventManager.getInstance().sendMsgToFlutter(Const.CallbackMethodCall.InitCallName, Const.InitCallback.locationCallbackKey, "0");//unknown
                    }
                });
                break;
            case "setDataConsentSet":
                String uploadDataLevel = methodCall.argument(Const.Init.GDPR_UPLOAD_DATA_LEVEL);

                MsgTools.printMsg("setDataConsentSet: " + uploadDataLevel);

                int level;
                switch (uploadDataLevel) {
                    case "ATDataConsentSetPersonalized":
                        level = ATSDK.PERSONALIZED;
                        break;
                    case "ATDataConsentSetNonpersonalized":
                        level = ATSDK.NONPERSONALIZED;
                        break;
                    default:
                        level = ATSDK.UNKNOWN;
                        break;
                }

                ATSDK.setGDPRUploadDataLevel(FlutterPluginUtil.getApplicationContext(), level);
                break;
            case "showGDPRAuth":
                MsgTools.printMsg("showGDPRAuth");

                FlutterPluginUtil.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        ATSDK.showGdprAuth(FlutterPluginUtil.getApplicationContext(), new ATGDPRAuthCallback() {
                            @Override
                            public void onAuthResult(int i) {
                                MsgTools.printMsg("showGDPRAuth: onAuthResult: " + i);

                                String result;
                                switch (i) {
                                    case ATSDK.PERSONALIZED:
                                        result = "1";
                                        break;
                                    case ATSDK.NONPERSONALIZED:
                                        result = "2";
                                        break;
                                    default:
                                        result = "0";//unknown
                                        break;
                                }
                                MsgTools.printMsg("showGDPRAuth: onAuthResult: callback to flutter: result: " + result);
                                ATFlutterEventManager.getInstance().sendMsgToFlutter(Const.CallbackMethodCall.InitCallName, Const.InitCallback.consentSetCallbackKey, result);
                            }

                            @Override
                            public void onPageLoadFail() {
                                MsgTools.printMsg("showGDPRAuth: onPageLoadFail");

                                ATFlutterEventManager.getInstance().sendMsgToFlutter(Const.CallbackMethodCall.InitCallName, Const.InitCallback.consentSetCallbackKey, "0");//unknown
                            }
                        });
                    }
                });
                break;

            case "showGDPRConsentDialog":
                final String consentAppId = methodCall.argument(Const.APP_ID);
                MsgTools.printMsg("showGDPRConsentDialog: appId=" + consentAppId);

                FlutterPluginUtil.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Activity activity = FlutterPluginUtil.getActivity();
                        if (!FlutterPluginUtil.isActivityUsable(activity)) {
                            MsgTools.printMsg("showGDPRConsentDialog: activity invalid, abort");
                            Map<String, Object> dismissMap = new HashMap<>(4);
                            dismissMap.put("infoMsg", "activity is null!");
                            dismissMap.put("dismissType", -1);
                            ATFlutterEventManager.getInstance().sendMsgToFlutter(
                                    Const.CallbackMethodCall.InitCallName,
                                    Const.InitCallback.consentDismissCallbackKey,
                                    dismissMap);
                            try {
                                result.success(dismissMap);
                            } catch (Throwable ignored) {
                            }
                            return;
                        }
                        ATGDPRConsentDismissListener listener = new ATGDPRConsentDismissListener() {
                            @Override
                            public void onDismiss(ConsentDismissInfo consentDismissInfo) {
                                MsgTools.printMsg("showGDPRConsentDialog: onDismiss: " + consentDismissInfo);
                                final Map<String, Object> dismissMap = consentDismissToMap(consentDismissInfo);
                                ATFlutterEventManager.getInstance().sendMsgToFlutter(
                                        Const.CallbackMethodCall.InitCallName,
                                        Const.InitCallback.consentDismissCallbackKey,
                                        dismissMap);
                                try {
                                    result.success(dismissMap);
                                } catch (Throwable ignored) {
                                }
                            }
                        };
                        if (consentAppId != null && consentAppId.length() > 0) {
                            ATSDK.showGDPRConsentDialog(activity, listener, consentAppId);
                        } else {
                            ATSDK.showGDPRConsentDialog(activity, listener);
                        }
                    }
                });
                break;

            case "showGDPRConsentSecondDialog":
                final String secondAppId = methodCall.argument(Const.APP_ID);
                MsgTools.printMsg("showGDPRConsentSecondDialog: appId=" + secondAppId);

                FlutterPluginUtil.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Activity activity = FlutterPluginUtil.getActivity();
                        if (!FlutterPluginUtil.isActivityUsable(activity)) {
                            MsgTools.printMsg("showGDPRConsentSecondDialog: activity invalid, abort");
                            Map<String, Object> dismissMap = new HashMap<>(4);
                            dismissMap.put("infoMsg", "activity is null!");
                            dismissMap.put("dismissType", -1);
                            ATFlutterEventManager.getInstance().sendMsgToFlutter(
                                    Const.CallbackMethodCall.InitCallName,
                                    Const.InitCallback.consentDismissCallbackKey,
                                    dismissMap);
                            try {
                                result.success(dismissMap);
                            } catch (Throwable ignored) {
                            }
                            return;
                        }
                        ATGDPRConsentDismissListener listener = new ATGDPRConsentDismissListener() {
                            @Override
                            public void onDismiss(ConsentDismissInfo consentDismissInfo) {
                                MsgTools.printMsg("showGDPRConsentSecondDialog: onDismiss: " + consentDismissInfo);
                                final Map<String, Object> dismissMap = consentDismissToMap(consentDismissInfo);
                                ATFlutterEventManager.getInstance().sendMsgToFlutter(
                                        Const.CallbackMethodCall.InitCallName,
                                        Const.InitCallback.consentDismissCallbackKey,
                                        dismissMap);
                                try {
                                    result.success(dismissMap);
                                } catch (Throwable ignored) {
                                }
                            }
                        };
                        if (secondAppId != null && secondAppId.length() > 0) {
                            ATSDK.showGDPRConsentSecondDialog(activity, listener, secondAppId);
                        } else {
                            ATSDK.showGDPRConsentSecondDialog(activity, listener, "");
                        }
                    }
                });
                break;

            case "checkIsEuTraffic":
                final String euAppId = methodCall.argument(Const.APP_ID);
                MsgTools.printMsg("checkIsEuTraffic: appId=" + euAppId);
                ATSDK.checkIsEuTraffic(FlutterPluginUtil.getApplicationContext(), new NetTrafficeCallback() {
                    @Override
                    public void onResultCallback(boolean b) {
                        MsgTools.printMsg("checkIsEuTraffic: onResultCallback: " + b);
                        try {
                            result.success(b);
                        } catch (Throwable ignored) {
                        }
                    }

                    @Override
                    public void onErrorCallback(String s) {
                        MsgTools.printMsg("checkIsEuTraffic: onErrorCallback: " + s);
                        try {
                            result.success(false);
                        } catch (Throwable ignored) {
                        }
                    }
                }, euAppId);
                break;

            case "setPresetPlacementConfigPath":
                String path = methodCall.argument(Const.Init.PATH_STR);

                MsgTools.printMsg("setPresetPlacementConfigPath: " + path);
                ATSDK.setLocalStrategyAssetPath(FlutterPluginUtil.getApplicationContext(), path);
                break;

            case "getSDKVersionName":
                try {
                    String v = ATSDK.getSDKVersionName();
                    result.success(v);
                } catch (Throwable e) {
                    result.success("");
                }
                break;

            case "start":
                try {
                    ATSDK.start();
                    result.success("");
                } catch (Throwable e) {
                    result.success("");
                }
                break;

            case "putFilter": {
                String placementId = methodCall.argument(Const.PLACEMENT_ID);
                Map<String, Object> filterSpec = methodCall.argument(Const.EXTRA_DIC);
                MsgTools.printMsg("putFilter: placementId=" + placementId + ", spec=" + (filterSpec != null ? filterSpec.toString() : ""));
                try {
                    if (!TextUtils.isEmpty(placementId) && filterSpec != null) {
                        String json = Utils.flutterMapToJsonString(filterSpec);
                        ATWaterfallFilter filter = BridgeJsonMapUtil.waterfallFilterFromGroupsJson(json);
                        if (filter != null) {
                            ATSDK.putFilter(placementId, filter);
                        }
                    }
                } catch (Throwable t) {
                    MsgTools.printMsg("putFilter error: " + t.getMessage());
                }
                result.success("");
                break;
            }

            case "removeFilterWithPlacementId": {
                String placementId = methodCall.argument(Const.PLACEMENT_ID);
                MsgTools.printMsg("removeFilterWithPlacementId: placementId=" + placementId);
                try {
                    ATSDK.removeFilterWithPlacementId(placementId);
                } catch (Throwable ignored) {
                }
                result.success("");
                break;
            }

            case "removeFilters":
                MsgTools.printMsg("removeFilters");
                try {
                    ATSDK.removeFilters();
                } catch (Throwable ignored) {
                }
                result.success("");
                break;

            case "setSharedPlacementConfig": {
                Map<String, Object> cfg = methodCall.argument(Const.EXTRA_DIC);
                MsgTools.printMsg("setSharedPlacementConfig: " + (cfg != null ? cfg.toString() : ""));
                try {
                    if (cfg != null) {
                        String json = Utils.flutterMapToJsonString(cfg);
                        ATSharedPlacementConfig config = BridgeJsonMapUtil.sharedPlacementConfigFromJson(json);
                        if (config != null) {
                            ATSDK.setSharedPlacementConfig(config);
                        }
                    }
                } catch (Throwable t) {
                    MsgTools.printMsg("setSharedPlacementConfig error: " + t.getMessage());
                }
                result.success("");
                break;
            }

            case "setAdSourcePrivacyPolicy": {
                String policyJson = methodCall.argument(Const.Init.POLICY_JSON);
                MsgTools.printMsg("setAdSourcePrivacyPolicy: "
                        + (policyJson == null ? "null" : ("len=" + policyJson.length())));
                if (TextUtils.isEmpty(policyJson)) {
                    AdSourcePrivacyPolicyStore.setPolicyJson(null);
                } else {
                    AdSourcePrivacyPolicyStore.setPolicyJson(policyJson);
                }
                result.success("");
                break;
            }

            case "showDebuggerUI":
                String debugKey = methodCall.argument(Const.DEBUGKEY);
                try {
                    ATDebuggerUITest.showDebuggerUI(FlutterPluginUtil.getApplicationContext(), debugKey);
                } catch (Error e) {
                    MsgTools.printMsg("showDebuggerUI: " + e.toString());
                }
                break;

        }
        return true;
    }
}
