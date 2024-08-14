import router from '@ohos.router';
import { TitleLayout } from '../widgets/TitleLayout';
import AppConfig from '../commons/AppConfig';

@Entry({routeName: "AboutPage"})
@Component
export struct AboutPage {
  @State appName: string = ""

  async aboutToAppear() {
    this.appName = AppConfig.appName
  }

  build() {
    Column() {
      TitleLayout({
        title: "关于",
        onBack: () => {
          router.back()
        }
      })
      Column() {
        Image($r("app.media.app_logo"))
          .width(50)
          .height(50)
          .margin({ top: 50 })

        Text(this.appName + "\n" + AppConfig.appVersion)
          .fontSize(13)
          .fontColor($r("app.color.text_h1"))
          .padding(16)
          .textAlign(TextAlign.Center)
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}