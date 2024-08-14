import { TitleLayout } from 'LibUser/src/main/ets/widgets/TitleLayout';
import { router } from '@kit.ArkUI';
import TodoModel from '../db/TodoModel';
import TodoStatus from '../net/model/TodoStatus';
import { DbManager } from '../db/DbManager';
import { CardConfigParameter } from '../todaytodo/viewmodel/CardConfigParameter';
import { CardManager } from '../entryformability/CardManager';
import EntryContext from 'LibUser/src/main/ets/commons/EntryContext';
import { toast } from 'LibUser/src/main/ets/commons/Toast';

@Entry
export struct CardSettingPage {

  @State bgStr: string = "app.media.card_bg_white"
  @State txtColor: string = "#000000"
  @State todoList: TodoModel[] = []
  @State addIconStr: string = "app.media.icon_plus_black"
  @State bgAlpha: number = 1
  @State isTextBlack: boolean = true

  private cardBgList: string[] = [
    "app.media.card_bg_white",
    "app.media.card_bg_black",
    "app.media.card_bg1",
    "app.media.card_bg2",
    "app.media.card_bg3",
    "app.media.card_bg4",
    "app.media.card_bg5",
    "app.media.card_bg6",
    "app.media.card_bg7",
    "app.media.card_bg8",
    "app.media.card_bg9",
    "app.media.card_bg10",
    "app.media.card_bg11",
    "app.media.card_bg12",
    "app.media.card_bg13",
    "app.media.card_bg14",
    "app.media.card_bg15",
    "app.media.card_bg16",
    "app.media.card_bg17",
    "app.media.card_bg18",
    "app.media.card_bg19",
    "app.media.card_bg20",
    "app.media.card_bg21",
    "app.media.card_bg22",
    "app.media.card_bg23",
    "app.media.card_bg24",
    "app.media.card_bg25",
  ]

  aboutToAppear() {
    DbManager.getInstance().getRecordByStatus(TodoStatus.TODAY)
      .then(list => {
        this.todoList = Array.from(list)
      })
    let cardConfig = CardManager.get().getCardConfig(EntryContext.getContext() as Context)
    this.bgStr = cardConfig.bgStr
    this.txtColor = cardConfig.txtColor
    this.addIconStr = cardConfig.addIconStr
    this.bgAlpha = cardConfig.bgAlpha
  }

  build() {
    Column() {
      TitleLayout({
        title: "卡片设置",
        onBack: () => {
          router.back()
        }
      })
      Column() {
        Stack() {
          Image($r(this.bgStr))
            .width("100%")
            .height("100%")
            .opacity(this.bgAlpha)
            .borderRadius(20)
          Column({ space: FlexAlign.Start }) {
            Row() {
              Row() {
                Text("今日事")
                  .fontSize($r('app.float.list_title_font_size'))
                  .fontWeight(FontWeight.Bold)
                  .height($r('app.float.list_title_height'))
                  .fontColor(this.txtColor)
                  .padding({ right: $r('app.float.list_title_padding_right') })
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(this.todoList.length! > 99
                  ? '99+' : this.todoList.length + '')
                  .textAlign(TextAlign.Center)
                  .fontSize($r('app.float.item_count_font_size'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.txtColor)
                  .width($r('app.float.item_count_width'))
                  .height($r('app.float.item_count_height'))
                  .borderRadius($r('app.float.item_count_radius'))
              }.layoutWeight(1)
              Image($r(this.addIconStr))
                .width($r('app.float.bottom_icon_size'))
                .height($r('app.float.bottom_icon_size'))
            }
            .width("100%")
            .alignItems(VerticalAlign.Top)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ bottom: $r('app.float.list_row_padding_bottom') })
            List() {
              this.todoListRender()
            }
            .width("100%")
            .height("100%")
            .layoutWeight(1)
            .scrollBar(BarState.Off)
          }
          .pixelRound({ bottom: PixelRoundCalcPolicy.FORCE_CEIL })
          .padding(10)
        }
        .width("100%")
        .height(200)
        .padding(20)
        Column() {
          Text("背景选择")
            .fontColor($r("app.color.text_h1"))
            .fontSize(16)
          List(){
            this.cardBgRender()
          }.listDirection(Axis.Horizontal)
          .height(100)
        }.margin({top:30, left: 20})
        .alignItems(HorizontalAlign.Start)
        Column() {
          Text("背景不透明度")
            .fontColor($r("app.color.text_h1"))
            .fontSize(16)
            .textAlign(TextAlign.Start)
          Slider({value: (this.bgAlpha*100), min: 0, max: 100, })
            .margin({left: 10, right: 10})
            .onChange((value, mode) => {
              this.bgAlpha = value/100
            })
        }.margin({top:20, left: 20})
        .alignItems(HorizontalAlign.Start)
        Column() {
          Text("字体/icon颜色")
            .fontColor($r("app.color.text_h1"))
            .fontSize(16)
            .textAlign(TextAlign.Start)
          Row() {
            Checkbox()
              .select(this.isTextBlack)
              .onClick(e => {
                this.isTextBlack = true
                this.onTxtColorChanged()
              })
            Text("黑色")
              .fontColor($r("app.color.text_h2"))
              .fontSize(13)
            Checkbox()
              .margin({left: 30})
              .select(!this.isTextBlack)
              .onClick(v => {
                this.isTextBlack = false
                this.onTxtColorChanged()
              })
            Text("白色")
              .fontColor($r("app.color.text_h2"))
              .fontSize(13)
          }.width("100%")
          .padding({left: 10, top: 10})
        }
        .margin({top:20, left: 20})
        .alignItems(HorizontalAlign.Start)
        Row() {
          Text("保存")
            .textAlign(TextAlign.Center)
            .width(350)
            .margin(16)
            .padding(10)
            .borderRadius(10)
            .fontColor($r('app.color.white'))
            .backgroundColor($r('app.color.main'))
            .onClick(e => {
              this.onSubmit()
            })
        }.margin({top:30})

      }
      .margin({ top: 30 , bottom: 30})
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.main_bg"))
  }

  private onTxtColorChanged() {
    if (this.isTextBlack) {
      this.txtColor = "#000000"
      this.addIconStr = "app.media.icon_plus_black"
    } else {
      this.txtColor = "#ffffff"
      this.addIconStr = "app.media.icon_plus_white"
    }
  }

  @Builder
  cardBgRender() {
    ForEach(this.cardBgList, (item: string) => {
      ListItem() {
        Row() {
          Image($r(item))
            .height(80)
            .margin(10)
            .onClick(e => {
              this.bgStr = item
            })
        }
      }
    })
  }

  @Builder
  todoListRender() {
    if (this.todoList.length > 0) {
      ForEach(this.todoList, (item: TodoModel) => {
        ListItem() {
          Row() {
            if (item.status == TodoStatus.TODAY) {
              Image($r("app.media.square"))
                .width($r('app.float.item_image_size'))
                .height($r('app.float.item_image_size'))
            } else {
              Image($r("app.media.square_check"))
                .width($r('app.float.item_image_size'))
                .height($r('app.float.item_image_size'))
            }
            Column() {
              Text(item.text)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontSize($r('app.float.item_content_font_size'))
                .fontWeight(FontWeight.Medium)
                .fontColor(this.txtColor)
                .height($r('app.float.item_text_height'))
                .margin({ top: $r('app.float.item_text_margin') })
              Divider()
                .strokeWidth(0.38)
                .lineCap(LineCapStyle.Square)
                .margin({ top: $r('app.float.list_divider_margin') })
            }
            .margin({ left: $r('app.float.list_row_margin') , top: 5})
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }
          .alignItems(VerticalAlign.Center)
          .width("100%")
        }
        .width("100%")
        .height($r('app.float.item_height'))
      }, (item: number, index) => index + JSON.stringify(item))
    } else {
      Row() {
        Text("今日无事")
          .maxLines(1)
          .fontSize($r('app.float.item_content_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor("#999999")
          .height($r('app.float.item_text_height'))
          .margin({ top: $r('app.float.item_text_margin') })
      }
    }
  }

  onSubmit() {
    let cardConfig = new CardConfigParameter()
    cardConfig.bgStr = this.bgStr
    cardConfig.txtColor = this.txtColor
    cardConfig.addIconStr = this.addIconStr
    cardConfig.bgAlpha = this.bgAlpha
    CardManager.get().saveCardConfig(EntryContext.getContext() as Context, cardConfig)
    CardManager.get().updateCard()
    toast("保存成功")
    router.back()
  }
}