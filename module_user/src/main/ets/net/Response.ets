export class Response<T> {
  errorCode: number = 0
  errorMsg: string = ""
  result?: T = undefined

  isSuccess(): boolean {
    return this.errorCode === 0
  }

  isSuccessWithData(): boolean {
    return this.errorCode === 0 && this.result !== undefined;
  }

  getDataOrThrow(): T {
    return this.result!!
  }
}
