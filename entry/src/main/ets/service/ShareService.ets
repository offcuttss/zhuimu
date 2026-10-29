import { ShowInfo } from '../model/ShowModel'

export function shareShowByNfc(show: ShowInfo): string {
  return show.title + ' 的卡司档期已准备好分享'
}