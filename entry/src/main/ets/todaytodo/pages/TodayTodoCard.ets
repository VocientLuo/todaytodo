import { CardListComponent } from '../view/CardListComponent';
import { CardConfigParameter } from '../viewmodel/CardConfigParameter';
import TodoModel from '../../db/TodoModel';
import TodoStatus from '../../net/model/TodoStatus';
import { CardManager } from '../../entryformability/CardManager';
const storage = new LocalStorage();

@Entry(storage)
@Component
struct TodayTodoCard {

  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';
  readonly ACTION_MSG: string = "message";
  readonly ACTION_ADD: string = "add_todo";
  readonly ACTION_ENTER: string = "enter_todo";

  /*
   * The ability name.
   */
  readonly ABILITY_NAME: string = 'EntryAbility';
  /*
   * The message.
   */
  readonly MESSAGE: string = 'add detail';
  /*
   * The width percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  @LocalStorageProp('cardListData') cardListData: TodoModel[] = []
  @LocalStorageProp('itemNumber') itemNumber: number = 0
  @LocalStorageProp('cardConfig') cardConfig: CardConfigParameter = new CardConfigParameter()

  private doneItem(item: TodoModel) {
    postCardAction(this, {
      action: this.ACTION_MSG,
      params: {
        type: CardManager.EVENT_DONE,
        item: item
      }
    })
  }

  @Builder
  cardListBuilder() {
    if (this.cardListData.length > 0) {
      ForEach(this.cardListData, (item: TodoModel) => {
        ListItem() {
          Row() {
            if (item.status == TodoStatus.TODAY) {
              Image($r("app.media.square"))
                .width($r('app.float.item_image_size'))
                .height($r('app.float.item_image_size'))
                .onClick(e => {
                  this.doneItem(item)
                })
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
                .fontColor(this.cardConfig.txtColor)
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
          .width(this.FULL_WIDTH_PERCENT)
        }
        .width(this.FULL_WIDTH_PERCENT)
        .height($r('app.float.item_height'))
      }, (item: number, index) => index + JSON.stringify(item))
    } else {
      Row() {
        Text("今日无事...")
          .maxLines(1)
          .fontSize($r('app.float.item_content_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor("#999999")
          .height($r('app.float.item_text_height'))
          .margin({ top: $r('app.float.item_text_margin') })
      }
    }
  }

  build() {
    Stack() {
      Image($r(this.cardConfig.bgStr))
        .opacity(this.cardConfig.bgAlpha)
        .width("100%")
        .height("100%")
      CardListComponent({ cardListParameter: this.cardConfig, cardListNumber: this. itemNumber}) {
        this.cardListBuilder()
      }
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .backgroundColor("#00000000")
    .onClick(() => {
      postCardAction(this, {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: {
          message: this.MESSAGE
        }
      });
    })
  }

}