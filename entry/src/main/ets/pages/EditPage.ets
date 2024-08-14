import TodoModel from '../db/TodoModel'
import router from '@ohos.router';
import { TitleLayout } from 'LibUser/src/main/ets/widgets/TitleLayout'
import { toast } from 'LibUser/src/main/ets/commons/Toast';
import { DbManager } from '../db/DbManager';
import { emitter } from '@kit.BasicServicesKit';
import EventType from '../event/EventType';
import DateUtils from '../common/DateUtils';
import { CardManager } from '../entryformability/CardManager';
import LogUtils from '../common/LogUtils';

@Entry
@Component
struct EditPage {
  todoModel: TodoModel | undefined = undefined

  @State title: string = "新增事项"

  private content = ""

  async aboutToAppear() {
    this.todoModel = router.getParams() as TodoModel
    if (this.todoModel) {
      this.title = "更新事项"
    } else {
      this.title = "新增事项"
    }
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
        TextArea({
          placeholder: "请输入内容",
          text: this.todoModel?.text,
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
    if(this.todoModel) {
      this.todoModel.text = this.content
      this.todoModel.modifyTime = DateUtils.getFormatDate()
      DbManager.getInstance().update(this.todoModel).then(success => {
        if (success) {
          this.editSuccess("更新成功")
        }
      })
    } else {
      let model = new TodoModel()
      model.text = this.content
      model.createTime = DateUtils.getFormatDate()
      model.modifyTime = DateUtils.getFormatDate()
      DbManager.getInstance().insert(model).then( success => {
        if (success) {
          this.editSuccess("保存成功")
        }
      })
    }
  }

  private editSuccess(msg: string) {
    toast(msg)
    emitter.emit(EventType.UPDATE_EVENT, EventType.EVENT_DATA)
    LogUtils.debug("edit todo to update card")
    CardManager.get().updateCard()
    router.back()
  }
}