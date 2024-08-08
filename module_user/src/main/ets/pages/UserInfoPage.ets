import router from '@ohos.router';
import { TitleLayout } from '../widgets/TitleLayout';
import AppConfig from '../commons/AppConfig';
import UserService from '../net/service/UserService';
import { toast } from '../commons/Toast';
import Api from '../net/Api';
import { promptAction } from '@kit.ArkUI';

@Entry({routeName: "UserInfoPage"})
@Component
export struct UserInfoPage {
  @State title: string = "用户中心"

  aboutToAppear(): void {

  }

  build() {
    Column() {
      TitleLayout({
        title: this.title,
        onBack: () => {
          router.back()
        }
      })
      Column() {
        if (AppConfig.getUserInfo()) {
          Image($r("app.media.app_logo"))
            .width(80)
            .height(80)
          Text(AppConfig.getUserInfo()?.username)
            .fontColor($r("app.color.text_h1"))
            .fontSize(14)
            .margin({ top: 10 })
          Text(`ID: ${AppConfig.getUserInfo()?.uuid}`)
            .fontColor($r("app.color.text_h1"))
            .fontSize(12)

          Button("退出登录", {
            type: ButtonType.Capsule
          })
            .width('80%')
            .fontSize(13)
            .fontColor($r("app.color.white"))
            .backgroundColor($r("app.color.red"))
            .margin({top:100})
            .onClick((e) => {
              this.logout();
            })
          Button("注销账户", {
            type: ButtonType.Capsule
          })
            .width('80%')
            .fontSize(13)
            .fontColor($r("app.color.white"))
            .backgroundColor($r("app.color.red"))
            .opacity(0.5)
            .margin({top:30})
            .onClick((e) => {
              this.destroyAccount();
            })
        }
      }
      .margin({ top: 30 , bottom: 30})
      .alignItems(HorizontalAlign.Center)
      .onClick((e) => {

      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.main_bg"))
  }

  logout() {
    UserService.get().clearUser();
    toast("已退出")
    router.back()
  }

  destroyAccount() {
    promptAction.showDialog({
      title: "提示",
      message: "注销账户会清除所有用户信息，确认注销？",
      buttons: [
        {
          text: "注销",
          color: $r("app.color.main")
        },
        {
          text: "不注销",
          color: $r("app.color.text_h2")
        }
      ]
    }).then((resp) => {
      Api.get().loginExit(UserService.get().getUser()!).then(res => {
        if (res.errorCode == 200) {
          UserService.get().clearUser();
          toast("注销成功")
          router.back()
        }
      })
    })
  }
}
