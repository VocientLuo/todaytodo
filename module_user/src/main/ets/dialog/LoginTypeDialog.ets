
@Component
@Preview
export default struct LoginTypeDialog {
  onTypeSelect?: (type: number) => void

  build() {
    Column({
      space:12
    }){
      Row(){
        Button("华为账号登录").padding(10)
          .fontSize(14)
          .fontColor($r("app.color.white"))
          .width('85%')
          .onClick(e => {
            if (this.onTypeSelect) this.onTypeSelect(1)
          })
      }
      Row(){
        Button("官方账号登录").padding(10)
          .fontSize(14)
          .fontColor($r("app.color.white"))
          .width('85%')
          .onClick(e => {
            if (this.onTypeSelect) this.onTypeSelect(2)
          })
      }
    }
    .width("100%")
    .height("100%")
    .padding(16)
  }
}