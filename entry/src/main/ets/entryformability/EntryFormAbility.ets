import { formBindingData, FormExtensionAbility, formInfo } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import TodoModel from '../db/TodoModel';
import { CardManager, FormDataClass } from './CardManager';
import LogUtils from '../common/LogUtils';
import { DbManager } from '../db/DbManager';
import TodoStatus from '../net/model/TodoStatus';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    // Called to return a FormBindingData object.
    this.updateFormId(want)
    let data = new FormDataClass()
    data.cardListData = []
    return formBindingData.createFormBindingData(data);
  }

  onCastToNormalForm(formId: string) {

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
    // CardManager.clearCardId()
  }

  private updateFormId(want: Want) {
    let formId: string = '';
    if (want.parameters) {
      formId = JSON.stringify(want.parameters[formInfo.FormParam.IDENTITY_KEY]);
      LogUtils.debug("----------update formId: " + formId)
      CardManager.get().updateCard(this.context, formId)
    }

  }

  onAcquireFormState(want: Want) {
    this.updateFormId(want)
    return formInfo.FormState.READY;
  }
};