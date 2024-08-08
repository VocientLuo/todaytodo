import { MMKV } from '@tencent/mmkv'
import { User } from '../net/model/User'

export default class AppConfig {
  static BASE_URL: string = "https://api.beeteker.com/api/"

  static appName: string = ""
  static appVersion: string = ""
  static pkgName: string = ""
  static appChannel: string = "harmony"

  static userInfo: User | undefined

  static goMain?: () => void;

  static isLogin() : boolean {
    if (AppConfig.userInfo) {
      return true
    }
    if (MMKV.defaultMMKV().decodeString("user_id")) {
      return true
    }
    return false
  }

  static getUserId(): string {
    return MMKV.defaultMMKV().decodeString("user_id") || ""
  }

  static getUserInfo(): User | undefined {
    if (AppConfig.userInfo) {
      return AppConfig.userInfo
    }
    if (AppConfig.isLogin()) {
      let cache = MMKV.defaultMMKV().decodeString("user_info")
      AppConfig.userInfo = JSON.parse(cache as string)
    }
    return AppConfig.userInfo
  }

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