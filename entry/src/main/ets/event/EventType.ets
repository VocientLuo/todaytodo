import { emitter } from '@kit.BasicServicesKit'

export default class EventType {
  static EVENT_ID_TODO_UPDATE = 1

  static UPDATE_EVENT: emitter.InnerEvent = {
    eventId: EventType.EVENT_ID_TODO_UPDATE,
    priority: emitter.EventPriority.LOW
  }

  static EVENT_DATA: emitter.EventData = {
    data: {

    }
  }
}