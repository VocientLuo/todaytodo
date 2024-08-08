import router from '@ohos.router'
import { MMKV } from '@tencent/mmkv';
import AgreementDialog from '../dialog/AgreementDialog';
import AppConfig from '../commons/AppConfig'
import { emitter } from '@kit.BasicServicesKit';

import('../pages/WebPage')

@Entry({routeName: "LaunchPage"})
@Component
export struct LaunchPage {
  IS_AGREE_PROTOCOL: string = "is_first_start"

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: AgreementDialog({
      confirm: (agree)=> {
        if (agree) {
          MMKV.defaultMMKV().encodeBool(this.IS_AGREE_PROTOCOL, true)
          this.goMain()
        } else {
          router.back()
        }
      },
      onProtocol: (path)=> {
        router.pushNamedRoute({name: 'WebPage', params: {url: path}})
      }
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: 0 },
    customStyle: true
  })

  onPageShow(): void {
    console.log("-----------------> on launch page:")
    let mmkv: MMKV = MMKV.defaultMMKV()
    let isAgree: boolean|undefined = mmkv.decodeBool(this.IS_AGREE_PROTOCOL, false);
    console.log("is agree: " + isAgree);
    if (!isAgree) {
      this.dialogController?.open()
    } else {
      this.goMain()
    }
  }

  private goMain() {
    setTimeout(()=> {
      router.replaceUrl({url: "pages/Index"})
    }, 1000)
  }

  build() {
    RelativeContainer() {
      Image($r("app.media.app_logo"))
        .id("appLogo")
        .width(80)
        .height(80)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      Text(`${AppConfig.appName}`)
        .id("appName")
        .fontSize(14)
        .fontColor($r("app.color.text_h1"))
        .margin({top: 10})
        .alignRules({
          top: {anchor: 'appLogo', align: VerticalAlign.Bottom},
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .backgroundColor(Color.White)
    .height('100%')
    .width('100%')
  }
}