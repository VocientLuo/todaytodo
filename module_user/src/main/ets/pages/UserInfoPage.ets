import router from '@ohos.router';
import { TitleLayout } from '../widgets/TitleLayout';
import UserService from '../net/service/UserService';
import { toast } from '../commons/Toast';
import Api from '../net/Api';
import { promptAction } from '@kit.ArkUI';
import { User } from '../net/model/User';

@Entry({routeName: "UserInfoPage"})
@Component
export struct UserInfoPage {
  @State title: string = "用户中心"

  @State userHeader: Resource | string = $r("app.media.icon_default_avatar")
  @State userName: string = "未登录"

  private userObserver = (user?: User) => {
    if (user) {
      this.userName = user.username
      if (user.avatar) {
        this.userHeader = user.avatar
      }
    } else {
      this.userName = "未登录"
    }
  }

  aboutToAppear() {
    UserService.get().addUserObserver(this.userObserver);
    const user = UserService.get().getUser();
    this.userObserver(user);
  }

  aboutToDisappear() {
    UserService.get().removeUserObserver(this.userObserver);
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
        if (UserService.get().isLogin()) {
          Image(this.userHeader)
            .width(80)
            .height(80)
          Text(this.userName)
            .fontColor($r("app.color.text_h1"))
            .fontSize(14)
            .margin({ top: 10 })
          Text(`ID: ${UserService.get().getUser()?.uuid}`)
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
      UserService.get().getUser()!.deviceModel = "HARMONY"
      UserService.get().getUser()!.deviceType = "PHONE"
      Api.get().loginExit(UserService.get().getUser()!).then(res => {
        if (res.errorCode == 200) {
          UserService.get().clearUser();
          toast("注销成功")
          router.back()
        } else {
          toast("操作失败，请重试")
        }
      })
    })
  }
}
