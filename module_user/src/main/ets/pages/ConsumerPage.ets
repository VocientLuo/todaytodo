import { TitleLayout } from '../widgets/TitleLayout';
import { BusinessError, pasteboard } from '@kit.BasicServicesKit';
import { toast } from '../commons/Toast';
import { router } from '@kit.ArkUI';

@Entry({routeName: "ConsumerPage"})
@Component
export struct ConsumerPage {
  @State showLoading: boolean = false;
  @State title: string = "联系客服";

  private weixin = "--"
  private email = "--"

  aboutToAppear() {

  }

  build() {
    Column() {
      TitleLayout({
        title: this.title,
        onBack: () => {
          router.back()
        }
      })
      Row() {
        Text("微信")
          .layoutWeight(1)
          .fontSize(15)
          .fontColor($r("app.color.text_h6"))
        Text(this.weixin)
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
        this.copyToClipboard(this.weixin)
      })

      Row()
        .width('100%')
        .height(0.5)
        .backgroundColor($r("app.color.divider"))
      Row() {
        Text("邮箱：")
          .layoutWeight(1)
          .fontSize(15)
          .fontColor($r("app.color.text_h6"))
        Text(this.email)
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
        this.copyToClipboard(this.email)
      })
    }
    .width('100%')
    .height('100%')
  }

  private copyToClipboard(value: string) {
    let systemPasteboard = pasteboard.getSystemPasteboard();
    // 创建一条纯文本类型的剪贴板内容对象
    let pasteData = pasteboard.createPlainTextData(value);
    //pasteData.addTextRecord(value);
    // 将数据写入系统剪贴板
    systemPasteboard.setData(pasteData).then(()=>{
      // 存入成功，处理正常场景
      toast("已复制")
    }).catch((error: BusinessError) => {
      // 处理异常场景
    });
  }
}