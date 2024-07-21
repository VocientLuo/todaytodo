import { Mine } from './Mine'
import OHPermission from '../common/OHPermission'
import WindowUtils from '../common/WindowUtils'
import { MyHome } from './MyHome'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  private static TAG = "Index"
  private tabsController = new TabsController()
  @State currentIndex: number = 0
  @State isPermissionGrant: boolean = false


  build() {
    Column() {
      if (this.isPermissionGrant) {
        Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
          TabContent() {
            MyHome()
          }.tabBar(this.tabBuilder("首页", 0, $r("app.media.tab1sel"), $r("app.media.tab1nor")))
          TabContent() {
            Mine()
          }.tabBar(this.tabBuilder("我的", 1, $r("app.media.tab4sel"), $r("app.media.tab4nor")))
        }
        .layoutWeight(1)
        .scrollable(false)
        .animationDuration(0)
        .onChange((index) => {
          this.currentIndex = index
        })
        .backgroundColor($r("app.color.start_window_background"))
      } else {
        Text("No Permission")
          .width('100%')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      Row()
        .width('100%')
        .height(WindowUtils.navigationBarHeight + 'px')
        .backgroundColor($r("app.color.navi_bar_bg"))
    }
  }

  aboutToAppear() {
    OHPermission.requestPermission(getContext(this), ['ohos.permission.INTERNET'])
      .then((v) => {
        this.isPermissionGrant = true;
      })
      .catch(() => {
        this.isPermissionGrant = false;
      })
  }

  @Builder
  tabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 24 })
        .fillColor(this.currentIndex === targetIndex ? $r("app.color.main") : $r("app.color.navi_tab_unselect"))
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? $r("app.color.main") : $r("app.color.navi_tab_unselect"))
        .fontSize(11)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.navi_bar_bg"))
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(targetIndex)
    })
  }
}