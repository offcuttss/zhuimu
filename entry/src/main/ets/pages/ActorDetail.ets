import { router, promptAction } from '@kit.ArkUI'
import { ActorInfo, ShowInfo } from '../model/ShowModel'
import { MOCK_ACTORS, getStatusLabel, getStatusColor, toggleFollow, getDaysUntil } from '../service/ShowData'
import { addShowToCalendarDemo, CalendarResult } from '../service/CalendarService'

@Entry
@Component
struct ActorDetail {
  @State actor: ActorInfo | null = null
  @State isFollowed: boolean = false
  @State showTimeline: ShowInfo[] = []
  @State calendarAddedShows: string[] = []

  aboutToAppear() {
    let params = router.getParams() as Record<string, string>
    let actorId = params['actorId'] as string

    if (actorId !== undefined && actorId.length > 0) {
      for (let i = 0; i < MOCK_ACTORS.length; i++) {
        if (MOCK_ACTORS[i].id === actorId) {
          this.actor = MOCK_ACTORS[i]
          this.isFollowed = MOCK_ACTORS[i].isFollowed
          let sorted: ShowInfo[] = []
          for (let j = 0; j < MOCK_ACTORS[i].shows.length; j++) {
            sorted.push(MOCK_ACTORS[i].shows[j])
          }
          sorted.sort((a: ShowInfo, b: ShowInfo) => a.date.localeCompare(b.date))
          this.showTimeline = sorted
          break
        }
      }
    }
  }

  build() {
    Column() {
      if (this.actor === null) {
        Text('演员信息未找到')
          .fontSize(16)
          .fontColor('#666E8A')
        Blank()
      } else {
        Scroll() {
          Column({ space: 20 }) {
            // 演员信息头部
            Column({ space: 12 }) {
              Column() {
                Text(this.actor.name[0])
                  .fontSize(32)
                  .fontColor('#D4A853')
                  .fontWeight(FontWeight.Bold)
              }
              .width(80)
              .height(80)
              .borderRadius(40)
              .backgroundColor('#1A1A2E')
              .border({ width: 2, color: '#D4A853' })
              .justifyContent(FlexAlign.Center)

              Text(this.actor.name)
                .fontSize(24)
                .fontColor('#FFFFFF')
                .fontWeight(FontWeight.Bold)

              Text(this.actor.role)
                .fontSize(14)
                .fontColor('#666E8A')

              Row({ space: 12 }) {
                Button(this.isFollowed ? '已关注 ⭐' : '+ 关注')
                  .fontSize(14)
                  .fontColor(this.isFollowed ? '#0D0D0D' : '#D4A853')
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(this.isFollowed ? '#D4A853' : 'transparent')
                  .borderRadius(20)
                  .border({ width: 1, color: '#D4A853' })
                  .layoutWeight(1)
                  .height(38)
                  .onClick(() => {
                    if (this.actor !== null) {
                      this.isFollowed = toggleFollow(this.actor.id)
                    }
                  })

                Button('分享')
                  .fontSize(14)
                  .fontColor('#666E8A')
                  .backgroundColor('transparent')
                  .borderRadius(20)
                  .border({ width: 1, color: '#2A2A3E' })
                  .layoutWeight(1)
                  .height(38)
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/ShareDemo' })
                  })
              }
              .width('100%')
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#1A1A2E')
            .borderRadius(16)

            // 统计信息
            Row({ space: 0 }) {
              this.StatItem('近期演出', this.showTimeline.length + '场')
              this.StatItem('合作演员', this.getCollaborators() + '位')
              this.StatItem('覆盖城市', this.getCities() + '个')
            }
            .width('100%')
            .backgroundColor('#1A1A2E')
            .borderRadius(12)

            // 演出时间线
            Column({ space: 12 }) {
              Text('近期档期')
                .fontSize(16)
                .fontColor('#FFFFFF')
                .fontWeight(FontWeight.Bold)
                .width('100%')

              ForEach(this.showTimeline, (show: ShowInfo, index: number) => {
                Row() {
                  Column({ space: 0 }) {
                    if (index === 0) {
                      Column()
                        .width(10)
                        .height(10)
                        .borderRadius(5)
                        .backgroundColor('#D4A853')
                    } else {
                      Column()
                        .width(8)
                        .height(8)
                        .borderRadius(4)
                        .backgroundColor('#2A2A3E')
                    }
                    if (index < this.showTimeline.length - 1) {
                      Column()
                        .width(1)
                        .height(80)
                        .backgroundColor('#2A2A3E')
                    }
                  }
                  .width(20)
                  .alignItems(HorizontalAlign.Center)

                  Column({ space: 8 }) {
                    Row() {
                      Text(show.title)
                        .fontSize(15)
                        .fontColor('#FFFFFF')
                        .fontWeight(FontWeight.Bold)
                        .layoutWeight(1)
                      Text(show.castType)
                        .fontSize(11)
                        .fontColor('#D4A853')
                        .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                        .backgroundColor('rgba(212,168,83,0.12)')
                        .borderRadius(6)
                    }
                    .width('100%')

                    Row({ space: 8 }) {
                      Text(show.date + ' ' + show.time)
                        .fontSize(12)
                        .fontColor('#666E8A')
                      Text('· ' + getDaysUntil(show.date) + '天后')
                        .fontSize(11)
                        .fontColor('#D4A853')
                    }
                    .width('100%')

                    Text(show.venue)
                      .fontSize(12)
                      .fontColor('#666E8A')
                    Text(show.cast.join('、'))
                      .fontSize(12)
                      .fontColor('#444A5E')

                    Row() {
                      Text(show.price)
                        .fontSize(12)
                        .fontColor('#D4A853')
                      Blank()
                      Text(getStatusLabel(show.status))
                        .fontSize(11)
                        .fontColor(getStatusColor(show.status))
                    }
                    .width('100%')

                    // 日历按钮
                    if (this.isCalendarAdded(show.id)) {
                      Text('已添加至日历')
                        .fontSize(12)
                        .fontColor('#34C759')
                        .fontWeight(FontWeight.Medium)
                        .width('100%')
                        .height(34)
                        .textAlign(TextAlign.Center)
                        .backgroundColor('rgba(52,199,89,0.08)')
                        .borderRadius(8)
                    } else {
                      Button('📅 添加到系统日历')
                        .fontSize(12)
                        .fontColor('#D4A853')
                        .fontWeight(FontWeight.Medium)
                        .backgroundColor('transparent')
                        .borderRadius(8)
                        .border({ width: 1, color: 'rgba(212,168,83,0.3)' })
                        .width('100%')
                        .height(34)
                        .onClick(() => {
                          this.addToCalendar(show)
                        })
                    }
                  }
                  .layoutWeight(1)
                  .padding(12)
                  .backgroundColor('#1A1A2E')
                  .borderRadius(10)
                  .alignItems(HorizontalAlign.Start)
                }
                .width('100%')
                .alignItems(VerticalAlign.Top)
              })
            }
            .width('100%')
            .padding({ bottom: 20 })
          }
          .padding({ left: 16, right: 16, top: 8 })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0D0D0D')
  }

  @Builder
  StatItem(label: string, value: string) {
    Column({ space: 4 }) {
      Text(value)
        .fontSize(20)
        .fontColor('#D4A853')
        .fontWeight(FontWeight.Bold)
      Text(label)
        .fontSize(12)
        .fontColor('#666E8A')
    }
    .layoutWeight(1)
    .padding(16)
    .alignItems(HorizontalAlign.Center)
  }

  isCalendarAdded(showId: string): boolean {
    for (let i = 0; i < this.calendarAddedShows.length; i++) {
      if (this.calendarAddedShows[i] === showId) {
        return true
      }
    }
    return false
  }

  addToCalendar(show: ShowInfo) {
    let result: CalendarResult = addShowToCalendarDemo(show)
    if (result.success) {
      this.calendarAddedShows.push(show.id)
      promptAction.showToast({
        message: result.message,
        duration: 3000
      })
    } else {
      promptAction.showToast({
        message: result.message,
        duration: 3000
      })
    }
  }

  getCollaborators(): number {
    if (this.actor === null) return 0
    let set: string[] = []
    for (let i = 0; i < this.actor.shows.length; i++) {
      for (let j = 0; j < this.actor.shows[i].cast.length; j++) {
        let name = this.actor.shows[i].cast[j]
        if (name !== this.actor.name) {
          let found = false
          for (let k = 0; k < set.length; k++) {
            if (set[k] === name) {
              found = true
              break
            }
          }
          if (!found) {
            set.push(name)
          }
        }
      }
    }
    return set.length
  }

  getCities(): number {
    if (this.actor === null) return 0
    let cities: string[] = []
    for (let i = 0; i < this.actor.shows.length; i++) {
      let city = this.actor.shows[i].city
      let found = false
      for (let j = 0; j < cities.length; j++) {
        if (cities[j] === city) {
          found = true
          break
        }
      }
      if (!found) {
        cities.push(city)
      }
    }
    return cities.length
  }
}