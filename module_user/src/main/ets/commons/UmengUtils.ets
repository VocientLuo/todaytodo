import { preInit, InternalPlugin, setLogEnabled, init, onEventObject } from '@umeng/analytics';
class UmengUtils {

  setLoggable(debug: boolean) {
    setLogEnabled(debug)
  }


  previewInit(context: Context) {
    // 初始化友盟
    preInit({
      context: context.getApplicationContext(),
      plugins: [new InternalPlugin()]
    });
  }

  start() {
    init()
  }

  onEvent(eName: string, value: string) {
    onEventObject(eName, {
      key: value
    })
  }
}

export default new UmengUtils()