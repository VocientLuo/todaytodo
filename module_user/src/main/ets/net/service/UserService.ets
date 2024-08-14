import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import EntryContext from '../../commons/EntryContext';
import Api from '../Api';
import Preferences from '../../commons/Preferences';
import { User } from '../model/User';

export default class UserService {
  private static instance: UserService = new UserService()
  private static TAG = "UserService"
  private user?: User
  private userObservers: ((user?: User) => void)[] = []

  static get(): UserService {
    return UserService.instance
  }

  private constructor() {
    const context = EntryContext.getContext() as Context;
    const user = Preferences.get(context).getUser()
    if (user) {
      this.user = user;
      this.notifyObserver();
      this.updateUser().catch();
    }
  }

  isLogin(): boolean {
    if (this.user) {
      return true;
    }
    return false;
  }

  checkLogin(onLogin?: () => void) {
    if (this.isLogin()) {
      if (onLogin != undefined) {
        onLogin()
      }
    } else {
      promptAction.showDialog({
        title: "提示",
        message: "当前操作需要登录",
        buttons: [
          {
            text: "立即登录",
            color: $r("app.color.main")
          },
          {
            text: "取消",
            color: $r("app.color.text_h2")
          }
        ]
      }).then((resp) => {
        if (resp.index === 0) {
          router.pushUrl({
            url: 'pages/Login'
          })
        }
      })
    }
  }

  getUser(): User | undefined {
    return this.user;
  }

  setUser(user?: User) {
    this.user = user;
    this.notifyObserver();
    const context = EntryContext.getContext() as Context;
    Preferences.get(context).putUser(user);
  }

  async updateUser(): Promise<User> {
    if (this.isLogin() && this.user?.uuid) {
      const res = await Api.get().getUserInfo(this.user?.uuid)
      if (res.isSuccessWithData()) {
        const user = this.user!!;
        this.setUser(user);
        return Promise.resolve(user);
      } else {
        return Promise.reject(res.errorMsg);
      }
    } else {
      return Promise.reject()
    }
  }

  addUserObserver(observer: (user?: User) => void) {
    if (!this.userObservers.includes(observer)) {
      this.userObservers.push(observer);
    }
  }

  removeUserObserver(observer: (user?: User) => void) {
    const index = this.userObservers.indexOf(observer);
    if (index >= 0) {
      this.userObservers.splice(index, 1);
    }
  }

  private notifyObserver() {
    this.userObservers.forEach((observer) => {
      if (observer) {
        observer(this.user);
      }
    });
  }

  clearUser() {
    this.setUser(undefined);
  }
}
