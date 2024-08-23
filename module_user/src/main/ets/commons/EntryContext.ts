export default class EntryContext {
  private static context: object | undefined = undefined

  static setContext(context: object) {
    this.context = context
  }

  static getContext(): object {
    return EntryContext.context
  }
}