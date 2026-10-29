import { ShowInfo, ActorInfo } from '../model/ShowModel'

function createShow(
  id: string,
  title: string,
  cast: string[],
  date: string,
  time: string,
  venue: string,
  city: string,
  status: string,
  castType: string,
  price: string
): ShowInfo {
  return {
    id: id,
    title: title,
    cast: cast,
    date: date,
    time: time,
    venue: venue,
    city: city,
    status: status,
    castType: castType,
    price: price
  }
}

export let MOCK_SHOWS: ShowInfo[] = [
  createShow('s001', '《赵氏孤儿》', ['郑云龙', '阿云嘎', '明道'], '2026-08-15', '19:30', '上海大剧院', '上海', 'onSale', 'A卡', '280-1280元'),
  createShow('s002', '《赵氏孤儿》', ['郑云龙', '刘令飞', '徐均朔'], '2026-08-16', '14:00', '上海大剧院', '上海', 'onSale', 'B卡', '280-1280元'),
  createShow('s003', '《人间失格》', ['白举纲', '刘令飞'], '2026-08-20', '19:30', '北京保利剧院', '北京', 'onSale', 'A卡', '180-880元'),
  createShow('s004', '《人间失格》', ['白举纲', '郑云龙'], '2026-08-21', '19:30', '北京保利剧院', '北京', 'upcoming', 'B卡', '180-880元'),
  createShow('s005', '《蝶变》', ['阿云嘎', '丁臻滢'], '2026-09-01', '19:30', '广州大剧院', '广州', 'upcoming', 'A卡', '220-980元'),
  createShow('s006', '《粉丝来信》', ['刘令飞', '徐均朔', '丁臻滢'], '2026-09-10', '14:00', '深圳滨海艺术中心', '深圳', 'upcoming', 'A卡', '180-680元'),
  createShow('s007', '《白夜行》', ['韩雪', '郑云龙'], '2026-08-25', '19:30', '南京保利大剧院', '南京', 'soldOut', 'A卡', '280-1080元'),
  createShow('s008', '《罗密欧与朱丽叶》', ['阿云嘎', '李紫婷'], '2026-10-01', '19:30', '上海文化广场', '上海', 'upcoming', 'A卡', '280-1280元'),
  createShow('s009', '《剧院魅影》', ['阿云嘎', '郑棋元'], '2026-10-24', '19:30', '上海大剧院·大剧场', '上海', 'onSale', 'A卡', '380-1680元'),
  createShow('s010', '《雷雨》', ['华雯', '赵志刚', '秦雷'], '2026-09-04', '19:30', '上海大剧院', '上海', 'upcoming', 'A卡', '180-680元'),
  createShow('s011', '《悲惨世界》', ['阿云嘎', '郑棋元'], '2026-08-15', '19:30', '上海大剧院', '上海', 'onSale', 'A卡', '280-1280元'),
  createShow('s012', '《伊丽莎白》', ['徐丽东', '郑云龙'], '2026-09-20', '19:30', '上海文化广场', '上海', 'upcoming', 'A卡', '280-1280元'),
]

function createActor(id: string, name: string, role: string, shows: ShowInfo[], followed: boolean): ActorInfo {
  return {
    id: id,
    name: name,
    avatar: '',
    role: role,
    shows: shows,
    isFollowed: followed
  }
}

export let MOCK_ACTORS: ActorInfo[] = [
  createActor('a001', '郑云龙', '音乐剧演员', getActorShows('郑云龙'), true),
  createActor('a002', '阿云嘎', '音乐剧演员', getActorShows('阿云嘎'), true),
  createActor('a003', '刘令飞', '音乐剧演员', getActorShows('刘令飞'), false),
  createActor('a004', '白举纲', '音乐剧演员/歌手', getActorShows('白举纲'), false),
  createActor('a008', '郑棋元', '音乐剧演员', getActorShows('郑棋元'), true),
  createActor('a009', '徐丽东', '音乐剧演员', getActorShows('徐丽东'), true),
  createActor('a005', '徐均朔', '音乐剧演员', getActorShows('徐均朔'), false),
  createActor('a006', '韩雪', '演员/歌手', getActorShows('韩雪'), true),
  createActor('a007', '丁臻滢', '音乐剧演员', getActorShows('丁臻滢'), false)
]

function getActorShows(name: string): ShowInfo[] {
  let result: ShowInfo[] = []
  for (let i = 0; i < MOCK_SHOWS.length; i++) {
    let show = MOCK_SHOWS[i]
    let found = false
    for (let j = 0; j < show.cast.length; j++) {
      if (show.cast[j] === name) {
        found = true
        break
      }
    }
    if (found) {
      result.push(show)
    }
  }
  return result
}

export function searchShows(keyword: string): ShowInfo[] {
  if (keyword === null || keyword.length === 0) {
    return []
  }
  let kw = keyword.toLowerCase()
  let result: ShowInfo[] = []
  for (let i = 0; i < MOCK_SHOWS.length; i++) {
    let show = MOCK_SHOWS[i]
    if (show.title.toLowerCase().indexOf(kw) >= 0 ||
      show.venue.toLowerCase().indexOf(kw) >= 0 ||
      show.city.toLowerCase().indexOf(kw) >= 0) {
      result.push(show)
      continue
    }
    for (let j = 0; j < show.cast.length; j++) {
      if (show.cast[j].toLowerCase().indexOf(kw) >= 0) {
        result.push(show)
        break
      }
    }
  }
  return result
}

export function searchActors(keyword: string): ActorInfo[] {
  if (keyword === null || keyword.length === 0) {
    return []
  }
  let kw = keyword.toLowerCase()
  let result: ActorInfo[] = []
  for (let i = 0; i < MOCK_ACTORS.length; i++) {
    if (MOCK_ACTORS[i].name.toLowerCase().indexOf(kw) >= 0) {
      result.push(MOCK_ACTORS[i])
    }
  }
  return result
}

export function getHotSearchKeywords(): string[] {
  return ['郑云龙', '赵氏孤儿', '阿云嘎', '人间失格', '白夜行', '刘令飞']
}

export function getFollowedActors(): ActorInfo[] {
  let result: ActorInfo[] = []
  for (let i = 0; i < MOCK_ACTORS.length; i++) {
    if (MOCK_ACTORS[i].isFollowed) {
      result.push(MOCK_ACTORS[i])
    }
  }
  return result
}

export function toggleFollow(actorId: string): boolean {
  for (let i = 0; i < MOCK_ACTORS.length; i++) {
    if (MOCK_ACTORS[i].id === actorId) {
      MOCK_ACTORS[i].isFollowed = !MOCK_ACTORS[i].isFollowed
      return MOCK_ACTORS[i].isFollowed
    }
  }
  return false
}

export function getStatusLabel(status: string): string {
  if (status === 'onSale') {
    return '热卖中'
  }
  if (status === 'soldOut') {
    return '已售罄'
  }
  if (status === 'upcoming') {
    return '即将开票'
  }
  return status
}

export function getStatusColor(status: string): string {
  if (status === 'onSale') {
    return '#C9A96B'
  }
  if (status === 'soldOut') {
    return '#FF3B30'
  }
  if (status === 'upcoming') {
    return '#4A90D9'
  }
  return '#99A0B8'
}

export function getFeaturedActors(): ActorInfo[] {
  let result: ActorInfo[] = []
  for (let i = 0; i < MOCK_ACTORS.length; i++) {
    if (MOCK_ACTORS[i].id === 'a002' || MOCK_ACTORS[i].id === 'a008' || MOCK_ACTORS[i].id === 'a009') {
      result.push(MOCK_ACTORS[i])
    }
  }
  return result
}

export function getUpcomingShows(): ShowInfo[] {
  let result: ShowInfo[] = []
  for (let i = 0; i < MOCK_SHOWS.length; i++) {
    if (MOCK_SHOWS[i].status === 'onSale' || MOCK_SHOWS[i].status === 'upcoming') {
      result.push(MOCK_SHOWS[i])
      if (result.length >= 5) {
        break
      }
    }
  }
  return result
}

export function getDaysUntil(dateStr: string): number {
  let target = new Date(dateStr)
  let now = new Date()
  let diff = target.getTime() - now.getTime()
  return Math.ceil(diff / (1000 * 60 * 60 * 24))
}