import { CardConfigParameter } from '../viewmodel/CardConfigParameter';

@Component
export struct CardListComponent {
  /**
   * The max quantity of list items.
   */
  readonly MAX_QUANTITY: number = 99;
  /*
 * The width percentage setting.
 */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  @BuilderParam customBuilderParam: () => void = this.customBuilder;
  @Link cardListParameter: CardConfigParameter;
  @Link cardListNumber: number;

  @Builder
  customBuilder() {
  }

  build() {
    if (this.cardListParameter !== undefined) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column({ space: FlexAlign.Start }) {
          Row() {
            Row() {
              Text("今日事")
                .fontSize($r('app.float.list_title_font_size'))
                .fontWeight(FontWeight.Bold)
                .height($r('app.float.list_title_height'))
                .fontColor(this.cardListParameter.txtColor)
                .padding({ right: $r('app.float.list_title_padding_right') })
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(this.cardListNumber! > this.MAX_QUANTITY
                ? '99+' : this.cardListNumber + '')
                .textAlign(TextAlign.Center)
                .fontSize($r('app.float.item_count_font_size'))
                .fontWeight(FontWeight.Medium)
                .fontColor(this.cardListParameter.txtColor)
                .width($r('app.float.item_count_width'))
                .height($r('app.float.item_count_height'))
                .borderRadius($r('app.float.item_count_radius'))
            }.layoutWeight(1)
            Image($r(this.cardListParameter.addIconStr))
              .width($r('app.float.bottom_icon_size'))
              .height($r('app.float.bottom_icon_size'))
          }
          .width(this.FULL_WIDTH_PERCENT)
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ bottom: $r('app.float.list_row_padding_bottom') })

          List() {
            this.customBuilderParam()
          }
          .width(this.FULL_WIDTH_PERCENT)
          .height(this.FULL_HEIGHT_PERCENT)
          .layoutWeight(1)
          .scrollBar(BarState.Off)
        }
        .pixelRound({ bottom: PixelRoundCalcPolicy.FORCE_CEIL })

      }
      .padding({
        top: $r('app.float.list_side_padding'),
        bottom: $r('app.float.list_side_padding'),
        left: $r('app.float.list_side_padding'),
        right: $r('app.float.list_side_padding')
      })
    }
  }
}