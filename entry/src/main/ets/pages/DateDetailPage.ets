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
import DateUtils from '../common/DateUtils';
import { TitleLayout } from 'LibUser/src/main/ets/widgets/TitleLayout';
import {ReportItem} from './Reports'

@Entry
@Component
export struct DateDetailPage {
  private static TAG = "MyHomeTab"

  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = true;
  @State date: string = DateUtils.getFormatDay(new Date())
  @State data: TodoModel[] = [];

  private scroller: Scroller = new Scroller();
  private refreshConfig = new PullToRefreshConfigurator();

  aboutToAppear() {
    this.date = (router.getParams() as ReportItem).date
    this.refreshConfig.setHasRefresh(false);
    this.refreshConfig.setHasLoadMore(false)
    this.loadData();
    emitter.on(EventType.UPDATE_EVENT, (data)=> {
      this.loadData()
    })
  }

  private loadData() {
    this.loadState = LoadState.LOADING
    this.loadDataByPage().then(
      (data) => {
        this.showLoading = false
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
  }

  private async loadDataByPage(): Promise<ArrayList<TodoModel>> {
    const data = await DbManager.getInstance().getRecordByDay(this.date)
    return Promise.resolve(data)
  }

  build() {
    Column() {
      TitleLayout({
        title: this.date,
        onBack: () => {
          router.back()
        }
      })
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
              customLoad: null,
              customRefresh: null,
            })
          }
          .width('100%')
          .height('100%')
        }
      }.padding({bottom:100})
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