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
  commFirstOpen("acine"),
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

enum ThingSourceEnum {
  cp("FPllZYD"),
  hp("qJKd"),
  play("ffCiEsGYH"),
  playLast("ysQbouw"),
  playBk("coTrZylDO"),
  play10("ZPkzWVp"),
  chpage("GGbBqDUBbq"),
  chlistpage("JxaZmHRTwi"),
  pause("tqXj"),
  ladHot("KDQeA"),
  ladRecent("HNLCddwk"),
  chHot("yTHhCYZLc"),
  chRect("sDkv");

  final String value;

  const ThingSourceEnum(this.value);
}

enum ThingEnum {
  homeEJ6gQHxpose("KcsdYa"), // 首页曝光
  homeChan8FvYXnelExpose("hOdweL"), // 首页群组模块曝光
  homeHistyQOoryExpose("BTxLWMO"), // 首页历史模块曝光
  landpagMJFlMeExpose("PgMroVCnx"), // 承接页曝光（外部进入）
  landpa6EQy5geFail("eEjccn"), // 承接页加载失败
  landpageUplhpnoadedExpose("NGReON"), // 承接页最近上传曝光
  playStaZuartAll("NMBrA"), // 播放
  playST5Xource("SBRUgZSt"), // 主动播放
  pla5djkhySuc("qxCi"), // 播放成功
  playrrXujFail("xTC"), // 播放失败
  adReqPlR1Kacement("OPhe"), // 广告请求场景
  adReuKkp8qSuc("mug"), // 广告请求成功
  adRe7aTtqFail("qwjQF"), // 请求失败
  adNee8aQdShow("lIjzMlQsda"), // 广告应展示场景
  adShowPqEpOslacement("EmHIfmsS"), // 广告展示场景
  adShoIjxp9wFail("DBJnzBlBF"), // 广告展示失败
  adCLfrDZlick("OKa"), // 广告点击
  historlGwOyyExpose("FyBMgpLVj"), // 历史列表曝光
  deepliJgyZHnkOpen("kUSRZ"), // 外部支持深链打开（冷热启动都算）
  channellbXVRwistExpose("ISCMOMRfRH"), // 频道列表曝光
  channellqZkdlistClick("mfJPs"), // 频道列表点击
  channelpsMQ3HageExpose("nFwQsHw"), // 频道页曝光
  premiug8amExpose("uKyLLUesLL"), // 订阅页曝光
  premiuTHTLmClick("nASyXC"), // 订阅点击
  premiBdUumSuc("cua"), // 订阅成功
  premiwqfumFail("ZcdFigmKPy"), // 订阅失败时机：取消时上报
  rateServgRe0iceVisit("NjB"), // 好评弹窗曝光
  rateServj2snjiceClick("OVzeSH"), // 好评评分提交
  playingError("play_playing_error"), // 好评评分提交
  playingAdExitApp("ad_exit"), // 好评评分提交
  channel_fail("channel_fail"), // 好评评分提交
  recommend_fail("recommend_fail"), // 好评评分提交
  playGetLink("play_link_get") // 好评评分提交
  ;

  final String value;
  const ThingEnum(this.value);
}
