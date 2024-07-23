export default class AppConfig {

  static appName: string = ""
  static appVersion: string = ""
  static pkgName: string = ""

  static baseUrl: string = "https://www.baidu.com/"

  static privacyPath: string = AppConfig.baseUrl + "privacy.html?channel=huawei&appName="
  static userProtectPath: string = AppConfig.baseUrl + "userProtect.html?channel=huawei&appName="
  static vipProtectPath: string = AppConfig.baseUrl + "vipProtect.html?channel=huawei&appName="
  static thirdProtocolPath: string = AppConfig.baseUrl + "protocolDetail.html?channel=huawei&appName="

  static initProtocolUrl() {
    AppConfig.privacyPath += AppConfig.pkgName
    AppConfig.userProtectPath += AppConfig.pkgName
    AppConfig.vipProtectPath += AppConfig.pkgName
    AppConfig.thirdProtocolPath += AppConfig.pkgName
  }
}