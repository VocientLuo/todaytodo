import dayjs from "dayjs"

export default class DateUtils {
  static getFormatDate(time: number = 0): string {
    let date = dayjs()
    if (time > 0) {
      date = dayjs(time)
    }
    return date.format("YY-MM-DD HH:mm:ss")
  }

  static getFormatDay(time: Date): string {
    return dayjs(time).format("YY-MM-DD")
  }

  static getWeekIndex(time: Date): number {
    let date = dayjs(time)
    return date.day()
  }

  static getDay(date: Date): number {
    let d = dayjs(date).date()
    return d
  }

  static getMonth(date: Date): number {
    return dayjs(date).month()
  }

  static getYear(date: Date): number {
    return dayjs(date).year()
  }
}