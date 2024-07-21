import hilog from '@ohos.hilog'

export default class LogUtils {
  static debug(log: string, domain: number = 0, tag: string = "") {
    hilog.debug(domain, tag, log)
  }
  static error(log: string, domain: number = 0, tag: string = "") {
    hilog.error(domain, tag, log)
  }
  static info(log: string, domain: number = 0, tag: string = "") {
    hilog.info(domain, tag, log)
  }

}