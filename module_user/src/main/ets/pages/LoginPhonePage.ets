import router from '@ohos.router';
import { TitleLayout } from '../widgets/TitleLayout';
import AppConfig from '../commons/AppConfig';
import FormInput from '../widgets/FormInput';
import { toast } from '../commons/Toast';
import Api from '../net/Api';
import { PhoneLoginModel } from '../net/model/PhoneLoginModel';
import UserService from '../net/service/UserService';

import('./WebPage')
import('./RegisterPage')

@Entry({routeName: "LoginPhonePage"})
@Component
export struct LoginPhonePage {
  @State title: string = "账号登录"

  @State accountValue: string = ""
  @State password: string = ""
  agreement: boolean = false
  aboutToAppear(): void {

  }

  build() {
    Column() {
      TitleLayout({
        title: this.title,
        rightText: "注册",
        onRightClick: () => {
          router.pushNamedRoute({name: "RegisterPage"})
        },
        onBack: () => {
          router.back()
        }
      })
      Flex({direction: FlexDirection.Column}) {
        Flex({justifyContent: FlexAlign.Center}) {
          FormInput({
            value: this.accountValue,
            label: "账号",
            type: InputType.Normal,
            showClearBtn: true,
            onChange:(value:string)=>{
              this.accountValue = value
            }
          })
        }
        .margin({ top: 10 })
        Row() {
          FormInput({
            value: this.password,
            label: "密码",
            icon: $r('app.media.verify_code'),
            type: InputType.Password,
            onChange:(value:string)=>{
              this.password = value
            },
          })
        }
        .margin({ top: 10 })
        .justifyContent(FlexAlign.Center)
        Row() {
          Checkbox()
            .onChange(checked => {
              this.agreement = checked
            })
          Text(){
            Span("我已详细阅读并同意")
              .fontSize(12)
              .fontColor($r("app.color.text_h6"))
            Span("用户协议")
              .fontSize(12)
              .fontColor($r("app.color.green"))
              .onClick(e => {
                this.openWeb(AppConfig.getProtocolUrl())
              })
            Span("和")
              .fontSize(12)
              .fontColor($r("app.color.text_h6"))
            Span("隐私协议")
              .fontSize(12)
              .fontColor($r("app.color.green"))
              .onClick(e => {
                this.openWeb(AppConfig.getPrivacyUrl())
              })
          }
        }
        .margin({ top: 10, left: 50 })
        .justifyContent(FlexAlign.Center)
        Row() {
          Button("登录")
            .width(150)
            .fontSize(14)
            .fontColor($r("app.color.white"))
            .align(Alignment.Center)
            .onClick( e => {
              this.login()
            })
        }
        .justifyContent(FlexAlign.Center)
        .margin({ top: 20 })
        .width("100%")
      }
      .margin({ top: 30 , bottom: 30})
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.main_bg"))
  }

  openWeb(path: string) {
    router.pushNamedRoute({name: 'WebPage', params: {url: path}})
  }

  login() {
    if (!this.agreement) {
      toast("请阅读并勾选用户与隐私协议")
      return
    }
    if (!this.accountValue) {
      toast("请输入账号名称")
      return
    }
    if (this.accountValue.length < 6) {
      toast("账号名称至少6位")
      return
    }
    if (!this.password) {
      toast("请输入密码")
      return
    }
    let model = new PhoneLoginModel()
    model.phone = this.accountValue
    model.password = this.password
    Api.get().loginByPhone(model)
      .then((res) => {
        if (res.errorCode == 200) {
          toast("登录成功")
          UserService.get().setUser(res.result)
          router.back()
        }
      })
  }
}
