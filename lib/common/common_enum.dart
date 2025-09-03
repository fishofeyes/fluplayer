// _adInterval = cloakJson['adInterval'] ?? 60;
// mediaPlayPoint = cloakJson['mediaPlayPoint'] ?? 600;
// firstOpenTime = cloakJson['fistOpenTime'] ?? 7;
// nativeCloseRate = cloakJson['nativeCloseRate'] ?? 0.5;
// nativeShowTime = cloakJson['nativeShowTime'] ?? 3;
enum RemoteConfigEnum {
  adInterval, // 广告间隔时间
  mediaPlayPoint, // 视频播放点
  launchTime, // 首次打开时间
  nativeMayClick, // 原生广告误触率
  nativeShowTime, // 原生广告展示时间
  adConfig, // 广告配置字符串 base64
  adConfigSecond, // 第二广告配置字符串 base64
}

enum CommonReportEnum {
  commAd("pathways"),
  commonPlay("axebreaker"),
  commonView("cronartium"),
  commonDownload("whatkin"),
  commLocalAd("decubital"),
  commLocalPlay("wedlocks"),
  commUserActive("azine");

  final String key;

  const CommonReportEnum(this.key);
}

enum CommonReportSourceEnum {
  outpage("herohead"),
  userpage("tribual"),
  history("jockey"),
  home("home"),
  playlistRecommend("bkwbv4t_sm"),
  outPageRecommend("spartiate"),
  userPageRecommend("1vtdxrtclv");

  final String key;
  const CommonReportSourceEnum(this.key);
}

enum MySessionValue {
  copen(""),
  hopen(""),
  play(""),
  playnext(""),
  playback(""),
  play10(""),
  exhcnage(""),
  chpage(""),
  chlistpage(""),
  pause(""),
  landHot(""),
  landRect(""),
  chHot(""),
  chRect(""),
  folder("");

  final String value;

  const MySessionValue(this.value);
}

enum MySessionEvent {
  Direct_AD_Show("Direct_AD_Show"), // ad show
  Direct_AD_Click("Direct_AD_Click"), // ad click
  ad_req_time("ad_req_time"),
  homeERILtSxpose("gsXnaHxEC"), // 首页曝光
  homeChanlzRQUnelExpose("Tzy"), // 首页群组模块曝光
  homeHistSgPoryExpose("VFJqLj"), // 首页历史模块曝光
  landpag1lAeExpose("dGBxBIFQCW"), // 承接页曝光（外部进入）
  landpaCDZgeFail("vdfrSgTQYo"), // 承接页加载失败
  landpageAzaKQ0vatarClick("hxPSE"), // 承接页点击头像
  landpageUpl1LFD0oadedExpose("Rqqjs"), // 承接页最近上传曝光
  playStiHLOgartAll("Vei"), // 播放
  playSPmdU5ource("RpMhBiYQC"), // 主动播放
  plaP2cySuc("iugVd"), // 播放成功
  playmRC3dFail("NHpdo"), // 播放失败
  adReqPlzuowyacement("RBIx"), // 广告请求场景
  adReNazqSuc("WECKWgcR"), // 广告请求成功
  adNeejLNWUdShow("phAiw"), // 广告应展示场景
  adShowPH9FvSlacement("UTkFsjE"), // 广告展示场景
  adFzZ4ail("Sws"), // 请求失败
  adShowFail("aEdHjjh"), // 广告展示失败
  adCI3llick("gcASmdwtp"), // 广告点击
  historP2A2lyExpose("MSBecqgva"), // 历史列表曝光
  deepliC5qrfnkOpen("IpNligC"), // 外部支持深链打开（冷热启动都算）
  channell3pAistExpose("ppVLDwafD"), // 频道列表曝光
  channellEw9istClick("cPZW"), // 频道列表点击
  channelpRPpageExpose("kbjK"), // 频道页曝光
  premiub4LmExpose("uWGwBww"), // 订阅页曝光
  premiupcuZmmClick("gyzcyYtf"), // 订阅点击
  premirt7GUumSuc("cShM"), // 订阅成功
  premiVn2xumFail("pbq"), // 订阅失败时机：取消时上报
  commendShow("Liushe"), // 订阅失败时机：取消时上报
  commendClick("Zmuxi") // 订阅失败时机：取消时上报
  ;

  final String desc;

  const MySessionEvent(this.desc);
}
