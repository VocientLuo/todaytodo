import PaddingConstants from '../commons/constants/PaddingConstants'
/**
 * @author 2008
 * @datetime 2024/7/20 01:21
 * @className: FormInput
 * 自定义Input
 */
export enum FormItemType {
  Input
}

@Component
export  default  struct CodeInput {
  @Prop value: string
  @Prop sendBtnText: string = "获取验证码"
  @Prop codeBtnColor: Resource = $r("app.color.green")
  onSendCode?: ()=>void
  type: FormItemType = FormItemType.Input
  label: string = ''
  isLength: boolean = false
  maxLength: number = 5
  onChange: Function = (_value: string) => {}
  showTitle: boolean = false
  icon:Resource|string = $r('app.media.verify_code')

  build() {
    Column() {
      Row() {
        Row() {
          if (this.showTitle){
            Text(this.label)
              .fontSize(16)
          }
        }
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Stack(){
        Row({
          space:2
        }){
          Image(this.icon)
            .width(24)
            .height(24)
            .margin({left: PaddingConstants.PADDING_16})
          TextInput({text: this.value, placeholder: `请输入${this.label}`,})
            .maxLength(this.maxLength)
            .backgroundColor(Color.Transparent)
            .placeholderColor('#73000000')
            .placeholderFont({ size: 16, weight: 400 })
            .caretColor('#FF6600')
            .margin({ top: 10, bottom: 10 })
            .fontSize(16)
            .fontColor('#E0000000')
            .onChange((value: string) => {
              this.onChange(value)
            })
        }
        Row({
          space:12
        }){
          Text(this.sendBtnText)
            .fontSize(14)
            .fontColor(this.codeBtnColor)
            .onClick(e=> {
              if(this.sendBtnText != "获取验证码") {
                return
              }
              if (this.onSendCode) this.onSendCode()
            })
        }
        .margin({right:PaddingConstants.PADDING_16})
      }
      .alignContent(Alignment.End)
      .borderRadius(4)
      .backgroundColor($r('app.color.divider'))
    }
    .margin({ top: 12 })
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

}