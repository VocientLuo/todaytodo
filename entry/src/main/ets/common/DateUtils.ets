import dayjs from "dayjs"

export default class DateUtils {
  static getFormatDate(time: number = 0): string {
    let date = dayjs()
    if (time > 0) {
      date = dayjs(time)
    }
    return date.format("YY-MM-DD HH:mm:ss")
  }
}