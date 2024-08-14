import router from '@ohos.router';
import WindowUtils from '../commons/WindowUtils';

@Component
export struct TitleLayout {
  @Prop
  title: string;
  isJustShowStatusBar: boolean = false;
  showBack: boolean = true;
  onBack: () => void = () => {
    router.back();
  }
  rightText: string | undefined;
  menuIcon?: Resource;
  onMenuClick?: () => void;
  onRightClick?: () => void;

  build() {
    Column() {
      Row()
        .width('100%')
        .height(WindowUtils.statusBarHeight + 'px')
      if (this.isJustShowStatusBar === false) {
        Row() {
          if (this.showBack) {
            Image($r("app.media.ic_back"))
              .width(48)
              .height(48)
              .padding(14)
              .fillColor("#212121")
              .objectFit(ImageFit.Contain)
              .onClick((event) => {
                if (this.onBack !== undefined) {
                  this.onBack();
                }
              })
          }
          Text(this.title)
            .layoutWeight(1)
            .fontSize(17)
            .fontColor("#212121")
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({ left: 16, right: 16 })
          if (this.menuIcon !== undefined) {
            Image(this.menuIcon)
              .width(48)
              .height(48)
              .padding(14)
              .fillColor("#212121")
              .objectFit(ImageFit.Contain)
              .onClick((e) => {
                if (this.onMenuClick !== undefined) {
                  this.onMenuClick();
                }
              })
          }
          if (this.rightText !== undefined) {
            Text(this.rightText)
              .fontSize(14)
              .fontColor($r("app.color.main"))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: 16, right: 16 })
              .onClick( e => {
                if (this.onRightClick !== undefined) {
                  this.onRightClick()
                }
              })
          }
        }
        .width('100%')
        .height(48)
        .alignItems(VerticalAlign.Center)

      }
    }
    .width('100%')
    .backgroundColor("#ffffff")
  }
}