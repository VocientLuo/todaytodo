import TodoModel from '../db/TodoModel'
import router from '@ohos.router';
import { TitleLayout } from '../widgets/TitleLayout';
import { toast } from '../common/Toast';
import { DbManager } from '../db/DbManager';

@Entry
@Component
struct EditPage {
  todoModel: TodoModel | undefined = undefined

  private title = "新增事项"

  private content = ""

  async aboutToAppear() {
    if (this.todoModel) {

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
        TextInput({
          placeholder: "请输入内容",
          text: this.todoModel?.text
        })
          .width('100%')
          .height(200)
          .fontSize(13)
          .fontColor($r("app.color.text_h1"))
          .padding(16)
          .margin(16)
          .onChange((value) => {
            this.content = value;
          })
          .onSubmit((keyType) => {
            this.submit();
          })
        Text("保存")
          .width('100%')
          .margin(16)
          .padding(10)
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
      this.todoModel.modifyTime = new Date().toLocaleTimeString()
      DbManager.getInstance().update(this.todoModel).then(success => {
        if (success) {
          toast("更新成功")
          router.back()
        }
      })
    } else {
      let model = new TodoModel()
      model.text = this.content
      model.createTime = new Date().toLocaleTimeString()
      DbManager.getInstance().insert(model).then( success => {
        if (success) {
          toast("保存成功")
          router.back()
        }
      })
    }
  }
}