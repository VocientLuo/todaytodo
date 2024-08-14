import http from '@ohos.net.http';
import hilog from '@ohos.hilog';
import uri from '@ohos.uri';
import JSON from '@ohmos/json-bigint';

import { Response } from './Response';
import AppConfig from '../commons/AppConfig';
import { User } from './model/User';
import { PhoneLoginModel } from './model/PhoneLoginModel';
import { BaseModel } from './model/BaseModel';
import { FeedbackTypeModel, FeedbackModel } from './model/FeedbackTypeModel';
import { AppServerConfig } from './model/AppServerConfig';
import { PayModel, PreOrderModel } from './model/PayModel';

const TAG = "Api";

const POST = http.RequestMethod.POST
const GET = http.RequestMethod.GET

async function requestSync<T>(path: string, method: http.RequestMethod, extraData?: object): Promise<Response<T>> {
  return new Promise<Response<T>>((resolve, reject) => {
    const headers = new Headers();
    const url = AppConfig.BASE_URL + path;
    if (method === http.RequestMethod.POST) {
      headers.contentType = "application/json"
      if (!extraData) {
        // POST 必须有请求体，否则会报 Parameter error
        extraData = new Object();
      }
    }
    const httpRequest = http.createHttp();
    hilog.info(0, TAG,
      `start request, url: ${url}, method: ${method}, extraData: ` + JSON.stringify(extraData, undefined, undefined));
    httpRequest.request(
      url,
      {
        method: method,
        expectDataType: http.HttpDataType.OBJECT,
        header: headers,
        extraData: JSON.stringify(extraData, undefined, undefined)
      },
      (err, data) => {
        const res = new Response<T>()
        if (!err && data && data.responseCode === 200) {
          if (data.resultType === http.HttpDataType.STRING) {
            const result: Response<T> = JSON.parse(data);
            res.errorCode = result.errorCode;
            res.errorMsg = result.errorMsg;
            res.result = result.result;
          } else if (data.resultType === http.HttpDataType.OBJECT) {
            let dataResult: string = JSON.stringify(data.result, undefined, undefined)
            const result: Response<T> = JSON.parse(dataResult);
            res.errorCode = result.errorCode;
            res.errorMsg = result.errorMsg;
            res.result = result.result;
          } else {
            res.errorCode = -1
            res.errorMsg = `UnSupport data type: ${data.resultType}`
          }
          hilog.info(0, TAG, `request success, path: ${url}, result: ${JSON.stringify(res, undefined, undefined)}`)
        } else {
          hilog.error(0, TAG, `request error, path: ${url}, error: ${JSON.stringify(err, undefined, undefined)}`)
          res.errorCode = data?.responseCode ?? -1
          res.errorMsg = err?.message ?? ""
        }
        resolve(res);
      }
    )
  })
}

class Headers {
  contentType?: string;
  cookie?: string;
}


export default class Api {
  private static instance: Api;

  private constructor() {
  }

  static get(): Api {
    if (Api.instance === undefined) {
      Api.instance = new Api();
    }
    return Api.instance;
  }

  // 获取用户信息
  async getUserInfo(uuid: string): Promise<Response<User>> {
    let model = new BaseModel()
    model.uuid = uuid
    return requestSync(`getUserInfoOne`, POST, model);
  }

  // 手机号登录
  async loginByPhone(phoneParams: PhoneLoginModel): Promise<Response<User>> {
    return requestSync(`phoneLogin`, POST, phoneParams);
  }
  // 手机号注册
  async registerByPhone(phoneParams: PhoneLoginModel): Promise<Response<User>> {
    return requestSync(`phoneRegister`, POST, phoneParams);
  }

  // 注销
  async loginExit(userModel: User): Promise<Response<User>> {
    return requestSync(`loginExit`, POST, userModel);
  }

  // 反馈类型
  async getFeedbackType(): Promise<Response<FeedbackTypeModel>> {
    return requestSync(`dctFeedback/getFeedbackTypeList`, POST, new BaseModel());
  }

  // 反馈提交
  async postFeedback(feedback: FeedbackModel): Promise<Response<Object>> {
    return requestSync(`dctFeedback/saveFeedback`, POST, feedback);
  }

  // 配置信息
  async getAppConfig(): Promise<Response<AppServerConfig>> {
    return requestSync(`config?pkg=${AppConfig.pkgName}&channelName=harmony&versionName=${AppConfig.appVersion}`, GET);
  }

  // 商品信息
  async getProducts(): Promise<Response<AppServerConfig>> {
    return requestSync(`getProducts`, POST, new BaseModel());
  }


  // 下单
  async createOrder(productId: string): Promise<Response<string>> {
    let model = new PayModel()
    model.productId = productId
    return requestSync(`order/createOrder`, POST, model);
  }


  // 下单
  async getPayParamInfo(model: PayModel): Promise<Response<PreOrderModel>> {
    return requestSync(`order/placeOder`, POST, model);
  }


}