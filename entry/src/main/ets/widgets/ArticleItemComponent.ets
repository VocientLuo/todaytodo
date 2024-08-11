import { DbManager } from '../db/DbManager';
import TodoModel from '../db/TodoModel';
import TodoStatus from '../net/model/TodoStatus';
import { emitter } from '@kit.BasicServicesKit';
import EventType from '../event/EventType';
import LogUtils from '../common/LogUtils';
import { promptAction, router } from '@kit.ArkUI';
import { CardManager } from '../entryformability/CardManager';

@Component
export struct ArticleItemComponent {
  article: TodoModel = new TodoModel();
  onCollectClick?: (article: TodoModel) => void;

  @State checkResource: Resource = $r("app.media.square")

  aboutToAppear(): void {
    if (this.article.status == TodoStatus.TODAY) {
      this.checkResource = $r("app.media.square")
    } else if (this.article.status == TodoStatus.HISTORY) {
      this.checkResource = $r("app.media.square_check")
    } else {
      this.checkResource = $r("app.media.square_gray")
    }
    LogUtils.debug("modify time: " + this.article.modifyTime)
  }

  build() {
    Column() {
      Row(){
        Image(this.checkResource)
          .width(20)
          .height(20)
          .objectFit(ImageFit.Contain)
          .onClick(e => {
            this.onCheck()
          })
        Text(this.article.text)
          .fontColor($r("app.color.text_h1"))
          .fontSize(15)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
          .margin({left:10})
      }
      .width('100%')
      Divider()
        .width('100%')
        .height(5)
        .color(Color.Transparent)
      Row() {
        Text(this.article.modifyTime)
          .fontColor($r("app.color.text_h2"))
          .fontSize(12)
          .margin({left: 30})
        Blank()
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
    }
    .border({width: 1, color: "#efefef", radius: 10})
    .margin(10)
    .shadow({radius: 5.5,
      color: "#efefef",
      offsetY: vp2px(5)})
    .padding({
      left: 16,
      top: 10,
      right: 16,
      bottom: 10
    })
    .onClick(e => {
      if (this.article.status == TodoStatus.TODAY) {
        router.pushUrl({
          url: "pages/EditPage",
          params: this.article
        })
      } else if (this.article.status == TodoStatus.HISTORY) {
        this.showDeleteDialog()
      } else {
        this.showHardDeleteDialog()
      }
    })
  }

  private showHardDeleteDialog() {
    promptAction.showDialog({
      title: "提示",
      message: "是否永久删除该事项？",
      buttons: [
        {
          text: "删除",
          color: $r("app.color.red")
        },
        {
          text: "取消",
          color: $r("app.color.text_h2")
        }
      ]
    }).then((resp) => {
      if (resp.index === 0) {
        this.deleteDB()
        CardManager.get().updateCard()
      }
    })
  }

  private showDeleteDialog() {
    promptAction.showDialog({
      title: "提示",
      message: "是否删除该事项？",
      buttons: [
        {
          text: "删除",
          color: $r("app.color.main")
        },
        {
          text: "取消",
          color: $r("app.color.text_h2")
        }
      ]
    }).then((resp) => {
      if (resp.index === 0) {
        this.article.status = TodoStatus.DELETED
        this.updateDB()
        CardManager.get().updateCard()
      }
    })
  }

  private onCheck() {
    if (this.article.status == TodoStatus.HISTORY) {
      this.article.status = TodoStatus.TODAY
    } else {
      this.article.status = TodoStatus.HISTORY
    }
    this.updateDB()
    CardManager.get().updateCard()
  }

  private updateDB() {
    DbManager.getInstance().update(this.article).then(success =>{
      if (success) {
        emitter.emit(EventType.UPDATE_EVENT, EventType.EVENT_DATA)
      }
    })
  }

  private deleteDB() {
    DbManager.getInstance().delete(this.article).then(success =>{
      if (success) {
        emitter.emit(EventType.UPDATE_EVENT, EventType.EVENT_DATA)
      }
    })
  }
}