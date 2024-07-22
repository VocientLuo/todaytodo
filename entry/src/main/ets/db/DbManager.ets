import relationalStore from '@ohos.data.relationalStore'
import TodoModel from './TodoModel'
import LogUtils from '../common/LogUtils'
import { BusinessError } from '@kit.BasicServicesKit'
import { ArrayList } from '@kit.ArkTS'

export class DbManager {
  private static instance = new DbManager()

  private dbName = 'today.db'
  private tbName = 'tb_todo'
  private storeConfig: relationalStore.StoreConfig = {
    name: this.dbName,
    securityLevel: relationalStore.SecurityLevel.S1
  }
  private store: relationalStore.RdbStore | undefined = undefined;

  static getInstance(): DbManager {
    return DbManager.instance
  }

  init(context: Context) {
    relationalStore.getRdbStore(context, this.storeConfig, (err, store) => {
      if (err) {
        LogUtils.debug("db init error.")
        return
      }
      this.store = store
      LogUtils.debug("db version: " + store.version)
      if (store.version == 0) {
        this.createTable(store)
        store.version = 1
      }
    })
  }

  private createTable(store: relationalStore.RdbStore) {
    const sql =
      'CREATE TABLE IF NOT EXISTS '+ this.tbName +' (' +
        'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        'text TEXT, ' +
        'createTime TEXT, ' +
        'modifyTime TEXT, ' +
        'weight INTEGER, ' +
        'status INTEGER, ' +
        'fontStyle TEXT, ' +
        'imgUrl TEXT, ' +
        'schedule INTEGER, ' +
        'wxRemind INTEGER, ' +
        'repeat INTEGER, ' +
        'planTime TEXT, ' +
        'deleteState INTEGER, ' +
        'serverId INTEGER' +
        ')'
    LogUtils.debug("create table---->")
    store.executeSql(sql).then((res) => {
      LogUtils.debug("res: " + res)
    })

  }

  insert(model: TodoModel): Promise<boolean> {
    if (this.store == undefined) {
      LogUtils.error("db store is not defined.")
      return Promise.resolve(false)
    }
    return new Promise<boolean>((resolve, reject) => {
      if (this.store == undefined) {
        LogUtils.error("db store is not defined.")
        reject()
        return
      }
      this.store.insert(this.tbName, this.getValuesBucket(model, true), (err: BusinessError, rowId: number) => {
        if (err) {
          LogUtils.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
          reject()
          return
        }
        LogUtils.debug("insert model success, rowId: " + rowId)
        resolve(true)
      })
    })
  }

  update(model: TodoModel): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      let predicates = new relationalStore.RdbPredicates(this.tbName)
      predicates.equalTo('id', model.id)
      if (this.store == undefined) {
        LogUtils.error("db store is not defined.")
        reject()
        return
      }
      (this.store as relationalStore.RdbStore).update(this.getValuesBucket(model), predicates, (err: BusinessError, rows: number) => {
        if (err) {
          LogUtils.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
          reject()
          return;
        }
        LogUtils.info(`Succeeded in updating data. row count: ${rows}`);
        resolve(true)
      })
    })
  }

  delete(model: TodoModel): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      let predicates = new relationalStore.RdbPredicates(this.tbName)
      predicates.equalTo('id', model.id)
      if (this.store == undefined) {
        LogUtils.error("db store is not defined.")
        reject()
        return
      }
      (this.store as relationalStore.RdbStore).delete(predicates, (err: BusinessError, rows: number) => {
        if (err) {
          LogUtils.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
          reject()
          return;
        }
        LogUtils.info(`Succeeded in delete data. delete row: ${rows}`);
        resolve(true)
      })
    })
  }

  getRecordByStatus(status: number): Promise<ArrayList<TodoModel>> {
    return new Promise<ArrayList<TodoModel>>((resolve, reject) => {
      let predicates = new relationalStore.RdbPredicates(this.tbName)
      predicates.equalTo('status', status)
      if (this.store == undefined) {
        LogUtils.error("db not init.")
        reject()
        return
      }
      (this.store as relationalStore.RdbStore).query(predicates, ['id', 'text', 'createTime', 'modifyTime', 'weight',
          'status', 'fontStyle', 'imgUrl', 'schedule', 'wxRemind', 'repeat', 'planTime', 'deleteState', 'serverId'], (err: BusinessError, resultSet: relationalStore.ResultSet) => {
        if (err) {
          console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);
        let data = new ArrayList<TodoModel>()
        // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
        while (resultSet.goToNextRow()) {
          let model = new TodoModel()
          model.id = resultSet.getLong(resultSet.getColumnIndex('id'))
          model.text = resultSet.getString(resultSet.getColumnIndex('text'))
          model.createTime = resultSet.getString(resultSet.getColumnIndex('createTime'))
          model.modifyTime = resultSet.getString(resultSet.getColumnIndex('modifyTime'))
          model.weight = resultSet.getLong(resultSet.getColumnIndex('weight'))
          model.status = resultSet.getLong(resultSet.getColumnIndex('status'))
          model.fontStyle = resultSet.getString(resultSet.getColumnIndex('fontStyle'))
          model.imgUrl = resultSet.getString(resultSet.getColumnIndex('imgUrl'))
          model.schedule = resultSet.getLong(resultSet.getColumnIndex('schedule'))
          model.wxRemind = resultSet.getLong(resultSet.getColumnIndex('wxRemind'))
          model.repeat = resultSet.getLong(resultSet.getColumnIndex('repeat'))
          model.planTime = resultSet.getString(resultSet.getColumnIndex('planTime'))
          model.deleteState = resultSet.getLong(resultSet.getColumnIndex('deleteState'))
          model.serverId = resultSet.getLong(resultSet.getColumnIndex('serverId'))
          data.add(model)
        }
        // 释放数据集的内存
        resultSet.close();
        resolve(data)
      })
    })
  }

  getValuesBucket(model: TodoModel, isAdd: boolean = false): relationalStore.ValuesBucket {
    if (isAdd) {
      let vb: relationalStore.ValuesBucket = {
        text: model.text,
        createTime: model.createTime,
        modifyTime: model.modifyTime,
        weight: model.weight,
        status: model.status,
        fontStyle: model.fontStyle,
        imgUrl: model.imgUrl,
        schedule: model.schedule,
        wxRemind: model.wxRemind,
        repeat: model.repeat,
        planTime: model.planTime,
        deleteState: model.deleteState,
        serverId: model.serverId
      }
      return vb
    }
    let values: relationalStore.ValuesBucket = {
      id: model.id,
      text: model.text,
      createTime: model.createTime,
      modifyTime: model.modifyTime,
      weight: model.weight,
      status: model.status,
      fontStyle: model.fontStyle,
      imgUrl: model.imgUrl,
      schedule: model.schedule,
      wxRemind: model.wxRemind,
      repeat: model.repeat,
      planTime: model.planTime,
      deleteState: model.deleteState,
      serverId: model.serverId
    }
    return values
  }
}