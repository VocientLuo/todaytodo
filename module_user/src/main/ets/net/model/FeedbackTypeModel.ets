import { BaseModel } from './BaseModel'

export class FeedbackTypeModel {
  id: number = -1
  typeName: string = ""
  isDel: number = 0
  showShort: number = 0
  selected: boolean = false
}

export class FeedbackModel extends BaseModel{
  content: string = ""
  feedbackTypeId: number = 105 // 界面问题
}