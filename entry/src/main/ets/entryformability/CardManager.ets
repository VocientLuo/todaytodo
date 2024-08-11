
import { DbManager } from '../db/DbManager'
import { formBindingData, formProvider } from '@kit.FormKit'
import TodoModel from '../db/TodoModel'
import TodoStatus from '../net/model/TodoStatus'
import LogUtils from '../common/LogUtils'

import dataPreferences from '@ohos.data.preferences';
import EntryContext from 'LibUser/src/main/ets/commons/EntryContext'

export class FormDataClass {
  cardListData: TodoModel[] = []
}

export class CardManager {
  private static instance: CardManager = new CardManager()
  static get(): CardManager {
    return CardManager.instance
  }
  static EVENT_DONE = "event_done"
  static EVENT_ADD = "event_add"
  static EVENT_MAIN = "event_main"

  static KEY_CARD_ID = "card_id"

  private saveCardId(context: Context, formId: string) {
    let pref = dataPreferences.getPreferencesSync(context, {name: CardManager.KEY_CARD_ID});
    pref.putSync(CardManager.KEY_CARD_ID, formId)
    pref.flush()
  }

  clearCardId(context: Context) {
    let pref = dataPreferences.getPreferencesSync(context, {name: CardManager.KEY_CARD_ID});
    pref.putSync(CardManager.KEY_CARD_ID, '')
    pref.flush()
  }

  getFormId(context: Context): string {
    let pref = dataPreferences.getPreferencesSync(context, {name: CardManager.KEY_CARD_ID});
    let cardId = pref.getSync(CardManager.KEY_CARD_ID, '') as string
    return cardId
  }

  updateCard( context?: Context, formId?: string) {
    LogUtils.debug("start updateCard --->")
      if (context) {
        DbManager.getInstanceAsync(context, (db)=> {
          this.updateCardData(context, db, formId)
        })
      } else {
        this.updateCardData(EntryContext.getContext() as Context, DbManager.getInstance(), formId)
      }
  }

  updateCardData(context: Context, db: DbManager, cardId?: string) {
    LogUtils.debug("updateCardData --->")
    if (!cardId) {
      cardId = this.getFormId(context)
    }
    LogUtils.debug("cardId: " + cardId)
    if (cardId) {
      db.getRecordByStatus(TodoStatus.TODAY).then( list => {
        let dataClass = new FormDataClass()
        dataClass.cardListData = Array.from(list)
        let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(dataClass);
        formProvider.updateForm(cardId, formInfo)
        console.log("update card complete --->")
      })
      this.saveCardId(context, cardId)
    } else {
      LogUtils.error("card id is empty")
    }
  }
}