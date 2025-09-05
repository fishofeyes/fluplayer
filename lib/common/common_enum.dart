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
  homeEJ6gQHxpose("KcsdYa"), // 首页曝光
  imporgmh8tClick("pVLJEQSMy"), // 导入点击
  impo1SnrtSuc("RvD"), // 导入成功
  imporQPhtFail("pJW"), // 导入失败
  import7wvHORename("FCnrZIoh"), // 导入文件重命名
  import4vyyqDelate("VgdLYkmjO"), // 导入文件删除
  homeAuthEohMrorizedSuc("iljHoPVk"), // 授权成功
  homeAuthoitKrizedFail("flabk"), // 授权失败
  homeChan8FvYXnelExpose("hOdweL"), // 首页群组模块曝光
  homeHistyQOoryExpose("BTxLWMO"), // 首页历史模块曝光
  downloadpnXhFOageExpose("oLO"), // 下载页曝光
  downloadAdWD3pageStart("XeYTXoB"), // 全部开始/全部暂停点击
  downloadpaFptHVgeDelateAll("jpwFrd"), // 全部删除
  downloadpwILp4ageDelate("ITnHxhqRxI"), // 单个任务删除
  downlwjbhpoadSuc("RyuM"), // 下载成功
  downloYIXr3adFail("bMx"), // 下载失败
  downlorC6x5adClick("pHpXLLCvi"), // 下载点击
  downloadR1zc1LetryClick("KyfRiWtBn"), // 下载重试点击
  landpagMJFlMeExpose("PgMroVCnx"), // 承接页曝光（外部进入）
  landpa0n3gePlay("vNYDwAL"), // 承接页播放
  landpa6EQy5geFail("eEjccn"), // 承接页加载失败
  landpageAvYH5bvatarClick("cXW"), // 承接页点击头像
  landpageUplhpnoadedExpose("NGReON"), // 承接页最近上传曝光
  landpageUploxksJHadedAllclick("uEPtkJjH"), // 承接页最近最热点击view all
  playStaZuartAll("NMBrA"), // 播放
  playST5Xource("SBRUgZSt"), // 主动播放
  pla5djkhySuc("qxCi"), // 播放成功
  playrrXujFail("xTC"), // 播放失败
  playPage1lwaBDuration("hTLm"), // 播放页面使用时长
  playbP7LUPlay("eXpMHCG"), // 暂停/播放点击
  playMuY0bNext("ddQGF"), // 下一个
  playACKcSpeed("zpvyQsMzw"), // 倍速
  playST86witch("TLWbVMP"), // 横竖屏切换
  playPlKFMQSaylist("FzTEDLr"), // 播放列表点击
  playFJgDFforword("INSwm"), // 前进
  playRobFewind("YKr"), // 后退
  playDoHXNwnload("SlV"), // 点击开始下载
  playFidSVtClick("laBe"), // 画面适配按钮点击
  adReqPlR1Kacement("OPhe"), // 广告请求场景
  adReuKkp8qSuc("mug"), // 广告请求成功
  adRe7aTtqFail("qwjQF"), // 请求失败
  adNee8aQdShow("lIjzMlQsda"), // 广告应展示场景
  adShowPqEpOslacement("EmHIfmsS"), // 广告展示场景
  adShoIjxp9wFail("DBJnzBlBF"), // 广告展示失败
  adCLfrDZlick("OKa"), // 广告点击
  historlGwOyyExpose("FyBMgpLVj"), // 历史列表曝光
  historbhuWtyClick("sALZ"), // 历史记录点击
  histornmplXyDelete("BRtMUKmL"), // 历史记录删除
  deepliJgyZHnkOpen("kUSRZ"), // 外部支持深链打开（冷热启动都算）
  channellbXVRwistExpose("ISCMOMRfRH"), // 频道列表曝光
  channellqZkdlistClick("mfJPs"), // 频道列表点击
  channelSuNi7SYbscription("mWEW"), // 点击关注
  channelUnsWZiNSubscription("pNp"), // 取消关注
  channelpsMQ3HageExpose("nFwQsHw"), // 频道页曝光
  browsey6o6rClick("KparilVl"), // 浏览器入口点击
  browserpZsyycageExpose("UNv"), // 浏览器页面曝光
  browserpageSUtBnSearchExpose("oscrdFsx"), // 输入框点击
  browserpageFhZerSearchClick("VDD"), // 浏览器搜索确认
  browserfQtU8Website("zSTS"), // 浏览器网址
  browserpagHdSlteAheadClick("oSOmInnOvC"), // 前进点击
  browserpageSlKaDEtepbackClick("NSNx"), // 后退点击
  browserRecNgguommendClick("xGXwnR"), // 推荐网址点击
  premiug8amExpose("uKyLLUesLL"), // 订阅页曝光
  premiuTHTLmClick("nASyXC"), // 订阅点击
  premiBdUumSuc("cua"), // 订阅成功
  premiwqfumFail("ZcdFigmKPy"), // 订阅失败时机：取消时上报
  rateServgRe0iceVisit("NjB"), // 好评弹窗曝光
  rateServj2snjiceClick("OVzeSH") // 好评评分提交
  ;

  final String value;
  const MySessionEvent(this.value);
}
