import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import TodoModel from '../db/TodoModel';
import { CardManager, FormDataClass } from './CardManager';
import LogUtils from '../common/LogUtils';
import { DbManager } from '../db/DbManager';
import TodoStatus from '../net/model/TodoStatus';
import { CardConfigParameter } from '../todaytodo/viewmodel/CardConfigParameter';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    this.parseFormId(want)
    let data = new FormDataClass()
    data.itemNumber = 0
    data.cardListData = []
    data.cardConfig = new CardConfigParameter()
    return formBindingData.createFormBindingData(data);
  }

  private parseFormId(want: Want) {
    let formId: string = '';
    if (want.parameters) {
      formId = JSON.stringify(want.parameters[formInfo.FormParam.IDENTITY_KEY]);
      CardManager.get().saveCardId(this.context, formId)
    }
  }

  onCastToNormalForm(formId: string) {
    CardManager.get().saveCardId(this.context, formId)
    CardManager.get().updateCard(this.context, formId)
  }

  onUpdateForm(formId: string) {
    CardManager.get().updateCard(this.context, formId)
  }

  onFormEvent(formId: string, message: string) {
    LogUtils.debug("on from event: " + message)
    if (message) {
      let data: object = JSON.parse(message)
      // 处理待办
      if (data['type'] == CardManager.EVENT_DONE) {
        LogUtils.debug("done todo")
        let model: TodoModel = JSON.parse(JSON.stringify(data["item"]))
        DbManager.getInstanceAsync(this.context, (db)=> {
          model.status = TodoStatus.HISTORY
          db.update(model)
          CardManager.get().updateCard(this.context, formId)
          LogUtils.debug("update card success")
        })
      } else if (data['type'] == CardManager.EVENT_ADD) {
        // 添加待办
        LogUtils.debug("add todo event")
      } else {
        LogUtils.debug("enter todo main page")
      }
    }
  }

  onRemoveForm(formId: string) {
    CardManager.get().clearCardId(this.context)
  }

  onAcquireFormState(want: Want) {
    this.parseFormId(want)
    return formInfo.FormState.READY;
  }
};