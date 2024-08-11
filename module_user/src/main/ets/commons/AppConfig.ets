
export default class AppConfig {
  static BASE_URL: string = "https://api.beeteker.com/api/"

  static appName: string = ""
  static appVersion: string = ""
  static pkgName: string = ""
  static appChannel: string = "harmony"

  static goMain?: () => void;

  static getPrivacyUrl(): string {
    return `${AppConfig.BASE_URL}privacy.html?appName=${AppConfig.pkgName}&channel=${AppConfig.appChannel}`
  }

  static getProtocolUrl(): string {
    return `${AppConfig.BASE_URL}userProtect.html?appName=${AppConfig.pkgName}&channel=${AppConfig.appChannel}`
  }

  static getThirdSdkUrl(): string {
    return `${AppConfig.BASE_URL}protocolDetail.html?appName=${AppConfig.pkgName}&channel=${AppConfig.appChannel}`
  }

  static getVipProtocol(): string {
    return `${AppConfig.BASE_URL}vipProtect.html?appName=${AppConfig.pkgName}&channel=${AppConfig.appChannel}`
  }
}