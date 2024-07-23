export default class AppConfig {

  static appName: string = ""
  static appVersion: string = ""
  static pkgName: string = ""

  static baseUrl: string = "https://api.beeteker.com/api/"

  static privacyPath: string = AppConfig.baseUrl + "privacy.html?channel=huawei&appName="
  static userProtectPath: string = AppConfig.baseUrl + "userProtect.html?channel=huawei&appName="
  static vipProtectPath: string = AppConfig.baseUrl + "vipProtect.html?channel=huawei&appName="
  static thirdProtocolPath: string = AppConfig.baseUrl + "protocolDetail.html?channel=huawei&appName="

  static initProtocolUrl() {
    let pkgName = "com.beeteker.today"
    AppConfig.privacyPath += pkgName
    AppConfig.userProtectPath += pkgName
    AppConfig.vipProtectPath += pkgName
    AppConfig.thirdProtocolPath += pkgName
  }
}