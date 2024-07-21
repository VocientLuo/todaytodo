import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import EntryContext from '../common/EntryContext';
import WindowUtils from '../common/WindowUtils';
import { DbManager } from '../db/DbManager';


export default class EntryAbility extends UIAbility {
  private static TAG: string = "EntryAbility"

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    EntryContext.setContext(this.context)
    DbManager.getInstance().init(this.context)
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

    const windowClass = await windowStage.getMainWindow();
    hilog.info(0x0000, EntryAbility.TAG,
      'Succeeded in obtaining the main window. Data: ' + JSON.stringify(windowClass));
    windowClass.setWindowLayoutFullScreen(true);
    WindowUtils.init(windowClass);

    const data = await windowStage.loadContent('pages/Index');
    hilog.info(0x0000, EntryAbility.TAG, 'Succeeded in loading the content. Data: %{public}s',
      JSON.stringify(data) ?? '');
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
