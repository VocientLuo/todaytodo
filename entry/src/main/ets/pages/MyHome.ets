import TodoStatus from '../net/model/TodoStatus';
import { LoadState } from 'LibUser/src/main/ets/widgets/PageLoading';
import { MyHomeTab } from './MyHomeTab';

@Component
export struct MyHome {
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  @State tabStatus: TodoStatus[] = [new TodoStatus(TodoStatus.TODAY, "今日事"), new TodoStatus(TodoStatus.HISTORY, "往日事"), new TodoStatus(TodoStatus.DELETED, "已删除"),]

  aboutToAppear() {
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.Start
      }) {
        ForEach(this.tabStatus, (status: TodoStatus) => {
          TabContent() {
            MyHomeTab({
              todoStatus: status
            })
          }
          .tabBar(status.name)
        })
      }
      .width('100%')
      .height('100%')
      .scrollable(true)
      .barMode(BarMode.Scrollable)
      .barHeight(44)
      .margin({top: 40})
    }
    .width('100%')
    .height('100%')
  }
}