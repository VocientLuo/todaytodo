import WindowUtils from '../common/WindowUtils';
import Api from '../net/Api';
import { TodoStatus } from '../net/model/TodoStatus';
import { LoadState, PageLoading } from '../widgets/PageLoading';
import { MyHomeTab } from './MyHomeTab';

@Component
export struct MyHome {
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  @State tabStatus: TodoStatus[] = [new TodoStatus(TodoStatus.TODAY, "今日事"), new TodoStatus(TodoStatus.HISTORY, "往日事"), new TodoStatus(TodoStatus.DELETED, "已删除"),]

  aboutToAppear() {
    this.loadData();
  }

  private loadData() {
    this.loadState = LoadState.LOADING
    Api.get().getWeChatAuthorList()
      .then((res) => {
        if (res.isSuccessWithData()) {
          this.loadState = LoadState.SUCCESS;
        } else {
          this.loadState = LoadState.FAIL;
        }
      })
  }

  build() {
    Column() {
      Tabs({
        barPosition: BarPosition.Start
      }) {
        ForEach(this.tabStatus, (author: TodoStatus) => {
          TabContent() {
            MyHomeTab({
              todoStatus: author
            })
          }
          .tabBar(author.name)
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