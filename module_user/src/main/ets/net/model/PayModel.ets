import { BaseModel } from './BaseModel';

export class PayModel extends BaseModel {
  productId: string = ""
  remark: string = ""
  reward: string = ""
  appForm: string = "app"
  payType: string = ""
  orderId: string = ""
}

export class PreOrderModel {
  resultCode: string = ""
  errorCode: string = ""
  resultMsg: string = ""
  payInfo: string = ""
  orderInfo: string = ""
}