export default class TodoStatus {
  static TODAY = 0
  static HISTORY = 1
  static DELETED = 2
  id: number = 0
  name: string = ""

  constructor(status: number, n: string) {
    this.id = status
    this.name = n
  }
}