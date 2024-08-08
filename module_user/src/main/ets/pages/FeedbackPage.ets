import router from '@ohos.router';
import { TitleLayout } from '../widgets/TitleLayout'
import { toast } from '../commons/Toast';

@Entry({routeName: "FeedbackPage"})
@Component
struct FeedbackPage {

  @State title: string = "反馈建议"

  @State content: string = ""

  async aboutToAppear() {

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
        TextInput({
          placeholder: "请输入内容",
          text: this.content
        })
          .height(200)
          .fontSize(13)
          .fontColor($r("app.color.text_h1"))
          .align(Alignment.TopStart)
          .padding(16)
          .margin(16)
          .onChange((value) => {
            this.content = value;
          })
          .onSubmit((keyType) => {
            this.submit();
          })
        Text("保存")
          .textAlign(TextAlign.Center)
          .width(350)
          .margin(16)
          .padding(10)
          .borderRadius(10)
          .fontColor($r('app.color.white'))
          .backgroundColor($r('app.color.main'))
          .onClick(e => {
            this.submit();
          })
      }
        .width('100%')
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }

  submit() {
    if (!this.content) {
      toast("请输入内容")
      return
    }

  }
}