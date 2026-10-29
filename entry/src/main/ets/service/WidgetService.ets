import { ShowInfo } from '../model/ShowModel'
import { MOCK_SHOWS } from './ShowData'

export function getWidgetShows(): ShowInfo[] {
  let result: ShowInfo[] = []
  for (let i = 0; i < MOCK_SHOWS.length && i < 3; i++) {
    result.push(MOCK_SHOWS[i])
  }
  return result
}