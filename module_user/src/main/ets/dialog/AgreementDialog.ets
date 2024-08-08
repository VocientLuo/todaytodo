import AppConfig from '../commons/AppConfig'


@Preview
@CustomDialog
export default struct AgreementDialog{
  controller?: CustomDialogController
  confirm?: (agree: boolean)=>void
  onProtocol?: (url: string)=>void

  build() {
    Column() {
      Text('用户协议与隐私政策').fontSize(20)
      Row() {
        Text() {
          Span(`感谢您使用${AppConfig.appName}APP，在您使用本软件过程中，我们可能会对您的部分个人信息进行收集、使用和共享。请您仔细阅读`)
            .fontSize(13)
            .fontColor("#666666")
          Span("《用户协议》").fontSize(13).fontColor($r("app.color.main")).onClick(e => {
            if (this.onProtocol) this.onProtocol(AppConfig.getProtocolUrl());
            this.controller?.close()
          })
          Span("、").fontSize(13).fontColor("#666666")
          Span("《隐私协议》").fontSize(13).fontColor($r("app.color.main")).onClick(e => {
            if (this.onProtocol) this.onProtocol(AppConfig.getPrivacyUrl());
            this.controller?.close()
          })
          Span("和").fontSize(13).fontColor("#666666")
          Span("《第三方SDK类服务商说明》").fontSize(13).fontColor($r("app.color.main")).onClick(e => {
            if (this.onProtocol) this.onProtocol(AppConfig.getThirdSdkUrl());
            this.controller?.close()
          })
          Span(`，并确定完全了解我们对您个人信息的处理规则。如您同意上述协议，请点击 “同意” 开始使用${AppConfig.appName}，我们会尽全力保护您的个人信息安全`)
            .fontSize(13)
            .fontColor("#666666")
        }
      }
      .margin({ top: 20 })
      Row() {
        Button("同意").onClick(() => {
          if (this.confirm) this.confirm(true)
          this.controller?.close()
        })
          .width('80%')
          .backgroundColor($r("app.color.main"))
          .borderRadius(10)
          .fontColor($r("app.color.white"))
      }.margin({ top: 20 })

      Row() {
        Button("不同意且退出").onClick(() => {
          if (this.confirm) this.confirm(false)
          this.controller?.close()
        })
          .width('80%')
          .backgroundColor($r("app.color.translucent"))
          .borderRadius(10)
          .fontColor($r("app.color.text_h3"))
      }.margin({ top: 10 })

    }.backgroundColor($r("app.color.white")).padding(10).borderRadius(10).margin(10)
  }
}