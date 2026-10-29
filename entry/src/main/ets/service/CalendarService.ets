import { hilog } from '@kit.PerformanceAnalysisKit'
import { ShowInfo } from '../model/ShowModel'

const TAG = 'CalendarService'

export interface CalendarResult {
  success: boolean
  message: string
  eventId?: string
}

export function addShowToCalendarDemo(show: ShowInfo): CalendarResult {
  hilog.info(0x0000, TAG, `[Demo] 添加日历: ${show.title}`)
  return {
    success: true,
    message: show.title + '已添加至系统日历，将在演出前1天和1小时提醒您',
    eventId: 'demo_' + Date.now()
  }
}