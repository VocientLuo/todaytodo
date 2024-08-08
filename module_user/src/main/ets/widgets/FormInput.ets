import PaddingConstants from '../commons/constants/PaddingConstants'
/**
 * @author 2008
 * @datetime 2024/7/20 01:21
 * @className: FormInput
 * 自定义Input
 */


@Component
export  default  struct FormInput {
  @Prop value: string
  type: InputType = InputType.Normal
  inputWidth:number = 235
  label: string = ''
  isLength: boolean = false
  maxLength: number = 50
  showClearBtn: boolean = false
  onChange: Function = (_value: string) => {}
  showTitle: boolean = false
  icon:Resource|string = $r('app.media.phone')

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
            .width(this.inputWidth)
            .backgroundColor(Color.Transparent)
            .placeholderColor('#73000000')
            .type(this.type)
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
          if (this.value.length > 0 && this.showClearBtn){
            Image($r('app.media.clear_input_icon')).width(16).height(16)
              .onClick(()=>{
                this.value = ''
              })
          }
        }
        .margin({right:PaddingConstants.PADDING_16})
      }
      .alignContent(Alignment.End)
      .borderRadius(4)
      .backgroundColor($r('app.color.divider'))
    }
    .margin({ top: 12 })
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}