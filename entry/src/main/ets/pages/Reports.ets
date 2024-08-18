import router from '@ohos.router'
import UserService from 'LibUser/src/main/ets/net/service/UserService'
import { LoadState, PageLoading } from 'LibUser/src/main/ets/widgets/PageLoading'
import { TitleLayout } from 'LibUser/src/main/ets/widgets/TitleLayout'
import AppConfig from 'LibUser/src/main/ets/commons/AppConfig'
import { User } from 'LibUser/src/main/ets/net/model/User'
import { toast } from 'LibUser/src/main/ets/commons/Toast'
import DateUtils from '../common/DateUtils'
import { ArrayList } from '@kit.ArkTS'
import { DbManager } from '../db/DbManager'

import('LibUser/src/main/ets/pages/LoginPhonePage')
import('LibUser/src/main/ets/pages/FeedbackPage')
import('LibUser/src/main/ets/pages/ConsumerPage')
import('LibUser/src/main/ets/pages/UserInfoPage')
import('LibUser/src/main/ets/pages/AboutPage')
import('LibUser/src/main/ets/pages/WebPage')

enum ItemType {
  MONTH,
  EMPTY,
  DATE
}

export class ReportItem {
  year: number = -1
  month: number = -1
  day: number = -1
  count: number = 0
  date: string = ""
  text: string = ""
  itemType: ItemType = ItemType.DATE
}

class RowItem {
  index: number = 0
  month: number = 0
  rowList: ReportItem[] = []
}

@Component
export struct Reports {
  @State loadState: LoadState = LoadState.SUCCESS;
  @State showLoading: boolean = true;

  private colorList: string[] = ["#efefef", "#dddddd", "#cccccc", "#d6e685", "#8cc665", "#44a340", "#1e6823"]
  private weekList: string[] = ["", "周日", "周一", "周二", "周三", "周四", "周五", "周六"]

  @State reportList: RowItem[] = []

  private squareSize: number = 25

  aboutToAppear() {
    // 异步获取数据
    new Promise<boolean>((r, j)=> {
      // 今天的日期
      let today = new Date()
      let weekIndex = DateUtils.getWeekIndex(today)
      let dateList = new ArrayList<RowItem>()
      let countDay = 365
      let currentDay = 0
      // 第一个月份数据
      // 第一行
      let firstRow = new RowItem()
      firstRow.index = 0
      firstRow.rowList.push(this.getMonthItem(today))
      firstRow.month = DateUtils.getMonth(today)
      dateList.add(firstRow)
      let currentDate = new Date()
      for (let i = 0; i < weekIndex; i++) {
        currentDate.setDate(today.getDate()+weekIndex-i)
        firstRow.rowList.push(this.getEmptyItem(currentDate))
      }
      for (let i = weekIndex; i < 7; i++) {
        currentDate = new Date()
        currentDate.setDate(today.getDate()-i)
        firstRow.rowList.push(this.getDataItem(currentDate))
        currentDay++
      }
      let rowIndex = 1
      // 开始周循环取出数据
      while (currentDay < countDay) {
        let row = new RowItem()
        row.index = rowIndex
        currentDate = new Date()
        currentDate.setDate(today.getDate()-currentDay)
        row.month = DateUtils.getMonth(currentDate)
        row.rowList.push(this.getMonthItem(currentDate))
        for (let i = 0; i < 7; i++) {
          currentDate = new Date()
          currentDate.setDate(today.getDate()-currentDay)
          row.rowList.push(this.getDataItem(currentDate))
          currentDay++
        }
        dateList.add(row)
        this.reportList = Array.from(dateList)
        rowIndex++
      }
      this.showLoading = false
      r(true)
    })
  }

  private getMonthItem(date: Date): ReportItem {
    let item = new ReportItem()
    item.year = DateUtils.getYear(date)
    item.month = DateUtils.getMonth(date)
    item.itemType = ItemType.MONTH
    item.text = `${item.month +1}`
    return item
  }

  private getEmptyItem(date: Date): ReportItem {
    let item = new ReportItem()
    item.year = DateUtils.getYear(date)
    item.month = DateUtils.getMonth(date)
    item.itemType = ItemType.EMPTY
    return item
  }

  private getDataItem(date: Date): ReportItem {
    let item = new ReportItem()
    item.year = DateUtils.getYear(date)
    item.month = DateUtils.getMonth(date)
    item.date = DateUtils.getFormatDay(date)
    item.count = DbManager.getInstance().getCountByDaySync(item.date)
    item.day = DateUtils.getDay(date)
    item.text = `${item.day}`
    item.itemType = ItemType.DATE
    return item
  }

  aboutToDisappear() {

  }

  private getItemColor(count: number) : string {
    if (count > 10) {
      return this.colorList[6]
    }
    if (count >= 5) {
      return this.colorList[5]
    }
    return this.colorList[count]
  }


  build() {
    PageLoading({
      loadState: this.loadState,
      showLoading: this.showLoading
    }) {
      Column() {
        Row() {
          Row() {
            Text("少")
              .width(this.squareSize)
              .height(this.squareSize)
              .margin(5)
              .fontColor($r("app.color.text_h6"))
              .fontSize(12)
            ForEach(this.colorList, (color: string) => {
              Text("")
                .width(this.squareSize)
                .height(this.squareSize)
                .margin(5)
                .backgroundColor(color)
            })
            Text("多")
              .width(this.squareSize)
              .height(this.squareSize)
              .margin(5)
              .fontColor($r("app.color.text_h6"))
              .fontSize(12)
          }.layoutWeight(1)
          .margin({left:16, right: 16})
          Image($r("app.media.icon_help"))
            .width(30)
            .height(30)
            .margin({right: 16})
            .onClick(e => {
              toast("展示近一年的数据")
            })
        }.height(44)
        .margin({top:40})
        .alignItems(VerticalAlign.Center)
        Row() {
          ForEach(this.weekList, (week: string) => {
            Text(week)
              .fontColor($r("app.color.text_h1"))
              .fontSize(14)
              .textAlign(TextAlign.Center)
              .fontStyle(FontStyle.Italic)
              .margin({right: 1})
              .layoutWeight(1)
          })
        }.justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor(Color.White)
        .height(40)
        Scroll() {
          Column() {
            ForEach(this.reportList, (row: RowItem, index: number) => {
              if (index == 0 || (row.month != this.reportList[index-1].month)) {
                Row()
                  .width("100%")
                  .height(0.5)
                  .backgroundColor(Color.White)
              }
              Row() {
                ForEach(row.rowList, (item: ReportItem) => {
                  if (item.itemType == ItemType.MONTH) {
                    if (index == 0 || (row.month != this.reportList[index-1].month)) {
                      Text(`${item.text}月`)
                        .fontSize(14)
                        .fontColor($r("app.color.text_h1"))
                        .textAlign(TextAlign.Center)
                        .margin({right: 1, bottom: 1})
                        .padding(5)
                        .layoutWeight(1)
                    } else {
                      Text("")
                        .fontSize(14)
                        .fontColor($r("app.color.text_h1"))
                        .textAlign(TextAlign.Center)
                        .margin({right: 1, bottom: 1})
                        .padding(5)
                        .layoutWeight(1)
                    }
                  } else {
                    Text(item.text)
                      .fontSize(12)
                      .fontColor($r("app.color.text_h6"))
                      .backgroundColor(this.getItemColor(item.count))
                      .textAlign(TextAlign.Center)
                      .margin({right: 1, bottom: 1})
                      .padding(5)
                      .layoutWeight(1)
                      .onClick(e => {
                        this.openDetail(item)
                      })
                  }
                })
              }.justifyContent(FlexAlign.SpaceBetween)
            })
          }.width("100%")
        }.layoutWeight(1)
        .backgroundColor(Color.White)
      }
      .width('100%')
      .height('100%')
    }
  }

  openDetail(item: ReportItem) {
    router.pushUrl({
      url: "pages/DateDetailPage",
      params: item
    })
  }
}