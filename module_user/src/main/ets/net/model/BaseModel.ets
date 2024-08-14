import AppConfig from '../../commons/AppConfig'
import UserService from '../service/UserService'

export class BaseModel {
  appName: string = AppConfig.pkgName
  deviceModel: string = "ANDROID"
  deviceType: string = "PHONE"
  sign: string = ""
  uuid: string = ""
  size: number = 100
  page: number = 1
  limit: number = 100
  categoryCode: string = AppConfig.pkgName

  constructor() {
    if (UserService.get().getUser()) {
      this.uuid = UserService.get().getUser()!!.uuid
    }
  }
}