import hilog from '@ohos.hilog'

export default class LogUtils {
  static TAG = "1111-----222222 : "
  static debug(log: string | object, domain: number = 0, tag: string = LogUtils.TAG) {
    hilog.debug(domain, tag, LogUtils.TAG + JSON.stringify(log))
  }
  static error(log: string | object, domain: number = 0, tag: string = LogUtils.TAG) {
    hilog.error(domain, tag, LogUtils.TAG + JSON.stringify(log))
  }
  static info(log: string | object, domain: number = 0, tag: string = LogUtils.TAG) {
    hilog.info(domain, tag, LogUtils.TAG + JSON.stringify(log))
  }

}