export interface ShowInfo {
  id: string
  title: string
  cast: string[]
  date: string
  time: string
  venue: string
  city: string
  status: string
  castType: string
  price: string
}

export interface ActorInfo {
  id: string
  name: string
  avatar: string
  role: string
  shows: ShowInfo[]
  isFollowed: boolean
}

export interface OcrResult {
  rawText: string
  showName: string
  castList: string[]
  dateText: string
  venueText: string
  confidence: number
  timestamp: number
}

export type SearchType = string