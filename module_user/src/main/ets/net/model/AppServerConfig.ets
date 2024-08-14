
export class AppServerConfig {
  adConfig: AdConfig = new AdConfig()
  funcShow: FuncShow = new FuncShow()
  userConfig: UserConfig = new UserConfig()
  appConfig: AppInfoConfig = new AppInfoConfig()
}

export class AdConfig {
  adType: number = -1
  appId: string = ""
  rewardId: string = ""
  level: number = 1
  bannerId: string = ""
  openScreenId: string = ""
  infomationId: string = ""
  splashId: string = ""
  isEnabled: number = 0
  bannerWidth: number = 300
  bannerHeight: number = 150
  infoWidth: number = 300
  infoHeight: number = 180
  adInterval = 60*1000
}

export class FuncShow {
  func01: number = 1
  func02: number = 1
  func03: number = 1
  func04: number = 1
  func05: number = 1

  func11: number = 1
  func12: number = 1
  func13: number = 1
  func14: number = 1
  func15: number = 1

  func21: number = 1
  func22: number = 1
  func23: number = 1
  func24: number = 1
  func25: number = 1
}

export class UserConfig {
  userModule: number = 0
  payEnabled: number = 0
  wxPayId: string = ""
  wxPayEnabled: number = 1
  alipayEnabled: number = 1
}

export class AppInfoConfig {
  icp: string = ""
  newstVersion: string = ""
  appCompanyName: string = ""
  privacyAppName: string = ""
  channelName: string = ""
  thirdKey: string = ""
}