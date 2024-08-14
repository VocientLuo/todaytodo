import { DbManager } from '../db/DbManager'
import { formBindingData, formProvider } from '@kit.FormKit'
import TodoModel from '../db/TodoModel'
import TodoStatus from '../net/model/TodoStatus'
import LogUtils from '../common/LogUtils'

import dataPreferences from '@ohos.data.preferences';
import EntryContext from 'LibUser/src/main/ets/commons/EntryContext'
import { CardConfigParameter } from '../todaytodo/viewmodel/CardConfigParameter'
import JSON from '@ohmos/json-bigint';

export class FormDataClass {
  title: string = "今日事"
  itemNumber: number = 0
  cardListData: TodoModel[] = []
  cardConfig: CardConfigParameter = new CardConfigParameter()
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
  static KEY_CARD_CONFIG = "card_config"

  saveCardConfig(context: Context, config: CardConfigParameter) {
    let pref = dataPreferences.getPreferencesSync(context, { name: CardManager.KEY_CARD_ID });
    pref.putSync(CardManager.KEY_CARD_CONFIG, JSON.stringify(config, undefined, undefined))
    pref.flush()
  }

  getCardConfig(context: Context): CardConfigParameter {
    let pref = dataPreferences.getPreferencesSync(context, { name: CardManager.KEY_CARD_ID });
    let cardConfigStr = pref.getSync(CardManager.KEY_CARD_CONFIG, '') as string
    if (cardConfigStr == '') {
      return new CardConfigParameter()
    }
    let cardConfig: CardConfigParameter = JSON.parse(cardConfigStr)
    return cardConfig
  }

  saveCardId(context: Context, formId: string) {
    let pref = dataPreferences.getPreferencesSync(context, { name: CardManager.KEY_CARD_ID });
    pref.putSync(CardManager.KEY_CARD_ID, formId)
    pref.flush()
  }

  clearCardId(context: Context) {
    let pref = dataPreferences.getPreferencesSync(context, { name: CardManager.KEY_CARD_ID });
    pref.putSync(CardManager.KEY_CARD_ID, '')
    pref.flush()
  }

  getFormId(context: Context): string {
    let pref = dataPreferences.getPreferencesSync(context, { name: CardManager.KEY_CARD_ID });
    let cardId = pref.getSync(CardManager.KEY_CARD_ID, '') as string
    return cardId
  }

  updateCard(context?: Context, formId?: string) {
    if (context) {
      DbManager.getInstanceAsync(context, (db) => {
        this.updateCardData(context, db, formId)
      })
    } else {
      this.updateCardData(EntryContext.getContext() as Context, DbManager.getInstance(), formId)
    }
  }

  updateCardData(context: Context, db: DbManager, cardId?: string) {
    if (!cardId) {
      cardId = this.getFormId(context)
    }
    if (cardId) {
      db.getRecordByStatus(TodoStatus.TODAY).then(list => {
        let dataClass = new FormDataClass()
        dataClass.cardListData = Array.from(list)
        dataClass.itemNumber = list.length
        dataClass.cardConfig = this.getCardConfig(context)
        let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(dataClass);
        formProvider.updateForm(cardId, formInfo)
        LogUtils.debug("update card form complete.")
      })
      this.saveCardId(context, cardId)
    } else {
      LogUtils.error("card id is empty")
    }
  }
}