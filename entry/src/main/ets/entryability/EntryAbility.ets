import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import EntryContext from 'LibUser/src/main/ets/commons/EntryContext';
import WindowUtils from 'LibUser/src/main/ets/commons/WindowUtils';
import { DbManager } from '../db/DbManager';
import bundleManager from '@ohos.bundle.bundleManager';
import AppConfig from 'LibUser/src/main/ets/commons/AppConfig';
import { MMKV } from '@tencent/mmkv';
import UmengUtils from 'LibUser/src/main/ets/commons/UmengUtils'

import('LibUser/./src/main/ets/pages/LaunchPage')



export default class EntryAbility extends UIAbility {
  private static TAG: string = "EntryAbility"

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    UmengUtils.previewInit(this.context)
  }

  private async initAppVersion() {
    try {
      let bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      AppConfig.appVersion = bundleInfo.versionName
      AppConfig.pkgName = bundleInfo.name
      console.log("app package name: " + AppConfig.pkgName)
      let appName = this.context.resourceManager.getStringSync($r("app.string.app_name"))
      AppConfig.appName = appName
    } catch (e) {
      console.log(e)
    }
  }

  onDestroy(): void {

  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    DbManager.getInstance().init(this.context)
    EntryContext.setContext(this.context)
    this.initAppVersion()
    const windowClass = await windowStage.getMainWindow();
    hilog.info(0x0000, EntryAbility.TAG,
      'Succeeded in obtaining the main window. Data: ' + JSON.stringify(windowClass));
    windowClass.setWindowLayoutFullScreen(true);
    WindowUtils.init(windowClass);
    this.initSDK()
    windowStage.loadContentByName('LaunchPage', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  private initSDK() {
    // mmkv
    let appCtx = this.context.getApplicationContext();
    let mmkvRootDir: string = MMKV.initialize(appCtx);
    console.info('mmkv rootDir: ', mmkvRootDir);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
