import router from '@ohos.router'
import UserService from '../net/service/UserService'
import { LoadState, PageLoading } from '../widgets/PageLoading'
import { TitleLayout } from '../widgets/TitleLayout'
import AppConfig from '../commons/AppConfig'
import { User } from '../net/model/User'
import('./LoginPhonePage')
import('./FeedbackPage')
import('./ConsumerPage')
import('./UserInfoPage')
import('./AboutPage')
import('./WebPage')

@Component
export struct Mine {
  @State loadState: LoadState = LoadState.SUCCESS;
  @State showLoading: boolean = false;
  @State title: string = "";

  @State isLogin: boolean = false;
  @State userHeader: Resource | string = $r("app.media.icon_default_avatar")
  @State userName: string = "未登录,点击登录"
  private userObserver = (user?: User) => {
    if (user) {
      this.isLogin = true;
      this.userName = user.username
      if (user.avatar) {
        this.userHeader = user.avatar
      }
    } else {
      this.isLogin = false;
      this.userName = "未登录,点击登录"
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
    PageLoading({
      loadState: this.loadState,
      showLoading: this.showLoading
    }) {
      Column() {
        TitleLayout({
          title: this.title,
          isJustShowStatusBar: true
        })
        Column() {
          Image(this.userHeader)
            .width(80)
            .height(80)
            .padding(3)
          Text(this.userName)
            .fontColor($r("app.color.text_h1"))
            .fontSize(17)
            .margin({ top: 16 })
        }
        .margin({ top: 30 , bottom: 30})
        .alignItems(HorizontalAlign.Center)
        .onClick((e) => {
          if (UserService.get().isLogin()) {
            router.pushNamedRoute({name: "UserInfoPage"})
          } else {
            router.pushNamedRoute({name: "LoginPhonePage"})
          }
        })

        Row() {
          Image($r("app.media.icon_mine_setting"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
            .margin({right:10})
          Text("卡片设置")
            .layoutWeight(1)
            .fontSize(15)
            .fontColor($r("app.color.text_h1"))
          Image($r("app.media.ic_arrow_right"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(50)
        .margin({ top: 50 })
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r("app.color.white"))
        .onClick((e) => {
          router.pushUrl({url: "pages/CardSettingPage"})
        })
        Row()
          .width('100%')
          .height(0.5)
          .backgroundColor($r("app.color.divider"))
        Row() {
          Image($r("app.media.icon_mine_feedback"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
            .margin({right:10})
          Text("反馈建议")
            .layoutWeight(1)
            .fontSize(15)
            .fontColor($r("app.color.text_h1"))
          Image($r("app.media.ic_arrow_right"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(50)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r("app.color.white"))
        .onClick((event) => {
          router.pushNamedRoute({name: "FeedbackPage"})
        })

        Row()
          .width('100%')
          .height(0.5)
          .backgroundColor($r("app.color.divider"))
        Row() {
          Image($r("app.media.icon_service"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
            .margin({right:10})
          Text("联系客服")
            .layoutWeight(1)
            .fontSize(15)
            .fontColor($r("app.color.text_h1"))
          Image($r("app.media.ic_arrow_right"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(50)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r("app.color.white"))
        .onClick((event) => {
          router.pushNamedRoute({name: "ConsumerPage"})
        })

        Row()
          .width('100%')
          .height(0.5)
          .backgroundColor($r("app.color.divider"))
        Row() {
          Image($r("app.media.icon_user_pro"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
            .margin({right:10})
          Text("用户协议")
            .layoutWeight(1)
            .fontSize(15)
            .fontColor($r("app.color.text_h1"))
          Image($r("app.media.ic_arrow_right"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(50)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r("app.color.white"))
        .onClick((event) => {
          router.pushNamedRoute({name: "WebPage", params: {url: AppConfig.getProtocolUrl()}})
        })

        Row()
          .width('100%')
          .height(0.5)
          .backgroundColor($r("app.color.divider"))
        Row() {
          Image($r("app.media.icon_protocol"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
            .margin({right:10})
          Text("隐私政策")
            .layoutWeight(1)
            .fontSize(15)
            .fontColor($r("app.color.text_h1"))
          Image($r("app.media.ic_arrow_right"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(50)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r("app.color.white"))
        .onClick((event) => {
          router.pushNamedRoute({name: "WebPage", params: {url: AppConfig.getPrivacyUrl()}})
        })

        Row()
          .width('100%')
          .height(0.5)
          .backgroundColor($r("app.color.divider"))
        Row() {
          Image($r("app.media.icon_mine_about"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
            .margin({right:10})
          Text("关于")
            .layoutWeight(1)
            .fontSize(15)
            .fontColor($r("app.color.text_h1"))
          Image($r("app.media.ic_arrow_right"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(50)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r("app.color.white"))
        .onClick((event) => {
          router.pushNamedRoute({name: "AboutPage"})
        })
      }
      .width('100%')
      .height('100%')
    }
  }
}