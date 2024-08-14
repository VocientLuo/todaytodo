import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh';
import { DbManager } from '../db/DbManager';
import TodoModel from '../db/TodoModel';
import TodoStatus from '../net/model/TodoStatus';
import { ArticleItemComponent } from '../widgets/ArticleItemComponent';
import { LoadState, PageLoading } from 'LibUser/src/main/ets/widgets/PageLoading';
import ArrayList from '@ohos.util.ArrayList';
import { router } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import EventType from '../event/EventType';

@Component
export struct MyHomeTab {
  todoStatus: TodoStatus | undefined = undefined;
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  @State data: TodoModel[] = [];
  private static TAG = "MyHomeTab"
  private scroller: Scroller = new Scroller();
  private refreshConfig = new PullToRefreshConfigurator();
  private nextPage: number = 1;
  private hasMore: boolean = true;

  aboutToAppear() {
    this.refreshConfig.setHasRefresh(false);
    this.loadData();
    emitter.on(EventType.UPDATE_EVENT, (data)=> {
      this.loadData()
    })
  }

  private loadData() {
    if (this.todoStatus) {
      this.loadState = LoadState.LOADING
      this.loadDataByPage(0).then(
        (data) => {
          this.data = data.convertToArray();
          if (this.data.length === 0) {
            this.loadState = LoadState.EMPTY;
          } else {
            this.loadState = LoadState.SUCCESS;
          }
        },
        () => {
          this.loadState = LoadState.FAIL;
        })
    } else {
      this.loadState = LoadState.FAIL;
    }
  }

  private async loadDataByPage(page: number): Promise<ArrayList<TodoModel>> {
    if (this.todoStatus) {
      const data = await DbManager.getInstance().getRecordByStatus(this.todoStatus.id)
      return Promise.resolve(data)
    } else {
      return Promise.reject();
    }
  }

  build() {
    Column() {
      RelativeContainer() {
        PageLoading({
          loadState: this.loadState,
          showLoading: this.showLoading,
          onReload: () => {
            this.loadData();
          }
        }) {
          Column() {
            PullToRefresh({
              data: $data,
              scroller: this.scroller,
              refreshConfigurator: this.refreshConfig,
              customList: () => {
                this.listViewBuilder();
              },
              onLoadMore: () => {
                return new Promise<string>((resolve, reject) => {
                  if (this.hasMore) {
                    this.loadDataByPage(this.nextPage).then(
                      (data) => {
                        if (data.length > 0) {
                          this.nextPage++
                          this.data.concat(data.convertToArray())
                          resolve('加载成功');
                        } else {
                          this.hasMore = false;
                          resolve('没有更多了');
                        }
                      },
                      () => {
                        resolve('加载失败');
                      }
                    )
                  } else {
                    resolve('没有更多了');
                  }
                });
              },
              customLoad: null,
              customRefresh: null,
            })
          }
          .width('100%')
          .height('100%')
          .padding({bottom:40})
        }
        if (this.todoStatus?.id == TodoStatus.TODAY) {
          Image($r("app.media.icon_add"))
            .width(48)
            .height(48)
            .objectFit(ImageFit.Contain)
            .alignRules({
              right: { anchor: "__container__", align: HorizontalAlign.End },
              bottom: {anchor: "__container__", align: VerticalAlign.Bottom}
            })
            .margin({right: 40, bottom: 80})
            .onClick(e => {
              router.pushUrl({
                url: 'pages/EditPage'
              });
            })
        }
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private listViewBuilder() {
    List({ scroller: this.scroller }) {
      ForEach(this.data, (item: TodoModel) => {
        ListItem() {
          ArticleItemComponent({
            article: item,
            onCollectClick: (article: TodoModel) => {
            }
          })
        }
      })
    }
    .width('100%')
    .height('100%')
    .listDirection(Axis.Vertical)
    .divider({
      strokeWidth: 0.5,
      color: $r("app.color.divider"),
      startMargin: 16,
      endMargin: 16
    })
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }
}