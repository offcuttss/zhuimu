import { router } from '@kit.ArkUI'
import { getHotSearchKeywords, getFollowedActors, MOCK_ACTORS, MOCK_SHOWS, toggleFollow } from '../service/ShowData'
import { ActorInfo, ShowInfo } from '../model/ShowModel'

@Entry
@Component
struct Index {
  @State searchKeyword: string = ''
  @State hotKeywords: string[] = []
  @State currentTab: number = 0
  @State calendarYear: number = 2026
  @State calendarMonth: number = 8
  @State followedActorsList: ActorInfo[] = []
  @State calendarFirstDay: number = 0
  @State calendarDaysInMonth: number = 31

  aboutToAppear() {
    this.hotKeywords = getHotSearchKeywords()
    this.refreshFollowed()
    this.updateCalendarInfo()
  }

  refreshFollowed() {
    this.followedActorsList = getFollowedActors()
  }

  updateCalendarInfo() {
    this.calendarFirstDay = this.getFirstDayOfMonth()
    this.calendarDaysInMonth = this.getDaysInMonth()
  }

  build() {
    Row() {
      // 左侧导航栏（桌面端）
      Column({ space: 8 }) {
        Column({ space: 2 }) {
          Text('Zhui Mu')
            .fontSize(18)
            .fontColor('#D4A853')
            .fontWeight(FontWeight.Bold)
          Text('追幕')
            .fontSize(10)
            .fontColor('#666E8A')
        }
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 16, top: 16, bottom: 16 })

        this.TabItem('🏠', '首页', 0)
        this.TabItem('🔍', '搜索', 1)
        this.TabItem('📅', '日历', 2)
        this.TabItem('👤', '我的', 3)
      }
      .width(220)
      .height('100%')
      .backgroundColor('#1A1A2E')
      .border({ width: { right: 1 }, color: '#2A3050' })

      // 右侧内容区
      Column() {
        if (this.currentTab === 0) {
          this.HomePage()
        } else if (this.currentTab === 1) {
          this.SearchPage()
        } else if (this.currentTab === 2) {
          this.CalendarPage()
        } else {
          this.ProfilePage()
        }
      }
      .layoutWeight(1)
      .height('100%')
      .backgroundColor('#0D0D0D')
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  HomePage() {
    Column() {
      Row() {
        Column({ space: 2 }) {
          Text('Zhui Mu')
            .fontSize(20)
            .fontColor('#D4A853')
            .fontWeight(FontWeight.Bold)
          Text('追幕')
            .fontSize(10)
            .fontColor('#666E8A')
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Column() {
          Text('🔔')
            .fontSize(22)
        }
        .width(40)
        .height(40)
        .backgroundColor('#1A1A2E')
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 16, bottom: 8 })

      Scroll() {
        Column({ space: 0 }) {
          Row({ space: 10 }) {
            Row({ space: 8 }) {
              Text('🔍')
                .fontSize(16)
                .fontColor('#666E8A')
              TextInput({ placeholder: '搜索音乐剧、剧院或宝藏演员...', text: this.searchKeyword })
                .layoutWeight(1)
                .height(40)
                .backgroundColor('transparent')
                .placeholderColor('#666E8A')
                .fontColor('#FFFFFF')
                .fontSize(14)
                .onChange((value: string) => {
                  this.searchKeyword = value
                })
                .onSubmit(() => {
                  this.doSearch()
                })
            }
            .layoutWeight(1)
            .height(44)
            .backgroundColor('#1A1A2E')
            .borderRadius(22)
            .padding({ left: 14, right: 14 })
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 8 })

          Column({ space: 12 }) {
            Row() {
              Text('本周瞩目演员')
                .fontSize(16)
                .fontColor('#FFFFFF')
                .fontWeight(FontWeight.Bold)
              Blank()
              Text('查看全部 ›')
                .fontSize(12)
                .fontColor('#D4A853')
                .onClick(() => {
                  this.currentTab = 1
                })
            }
            .width('100%')
            .padding({ left: 20, right: 20 })

            Scroll() {
              Row({ space: 16 }) {
                ForEach(MOCK_ACTORS, (actor: ActorInfo) => {
                  Column({ space: 6 }) {
                    Column() {
                      Text(actor.name[0])
                        .fontSize(28)
                        .fontColor('#D4A853')
                        .fontWeight(FontWeight.Bold)
                    }
                    .width(70)
                    .height(70)
                    .borderRadius(35)
                    .backgroundColor('#1A1A2E')
                    .border({ width: 2, color: '#D4A853' })
                    .justifyContent(FlexAlign.Center)

                    Text(actor.name)
                      .fontSize(13)
                      .fontColor('#FFFFFF')
                      .fontWeight(FontWeight.Medium)

                    Text(actor.role)
                      .fontSize(11)
                      .fontColor('#666E8A')
                  }
                  .alignItems(HorizontalAlign.Center)
                  .width(90)
                  .onClick(() => {
                    router.pushUrl({ url: 'pages/ActorDetail', params: { actorId: actor.id } })
                  })
                })
              }
              .padding({ left: 20, right: 20 })
            }
            .scrollable(ScrollDirection.Horizontal)
            .width('100%')
          }
          .width('100%')
          .margin({ top: 20 })

          Row({ space: 12 }) {
            this.FeatureCard('📷', 'AI识图', () => {
              router.pushUrl({ url: 'pages/AIScan' })
            })
            this.FeatureCard('🗺️', '巡演地图', () => {
              router.pushUrl({ url: 'pages/TourMap' })
            })
            this.FeatureCard('🎭', '座位视角', () => {
              router.pushUrl({ url: 'pages/SeatMap' })
            })
          }
          .width('100%')
          .padding({ left: 20, right: 20 })
          .margin({ top: 20 })
          .justifyContent(FlexAlign.SpaceEvenly)

          Column({ space: 12 }) {
            Text('近期瞩目演出日程')
              .fontSize(16)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .padding({ left: 20, right: 20 })

            ForEach(MOCK_SHOWS, (show: ShowInfo) => {
              this.ScheduleItem(show.date.substring(8, 10), show.date.substring(5, 7) + '月', show.title, show.venue, '#D4A853')
            })
          }
          .width('100%')
          .margin({ top: 24 })

          Column().height(80)
        }
        .width('100%')
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  SearchPage() {
    Scroll() {
      Column({ space: 0 }) {
        Text('搜索')
          .fontSize(20)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .padding({ left: 20, top: 20, bottom: 16 })

        Row({ space: 8 }) {
          Text('🔍')
            .fontSize(16)
            .fontColor('#666E8A')
          TextInput({ placeholder: '搜索演员或剧目...' })
            .layoutWeight(1)
            .height(40)
            .backgroundColor('transparent')
            .placeholderColor('#666E8A')
            .fontColor('#FFFFFF')
            .fontSize(14)
            .onChange((value: string) => {
              this.searchKeyword = value
            })
            .onSubmit(() => {
              this.doSearch()
            })
        }
        .width('90%')
        .height(44)
        .backgroundColor('#1A1A2E')
        .borderRadius(22)
        .padding({ left: 14, right: 14 })

        Column({ space: 12 }) {
          Text('🔥 热门搜索')
            .fontSize(15)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
            .width('100%')

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.hotKeywords, (keyword: string) => {
              Text(keyword)
                .fontSize(13)
                .fontColor('#D4A853')
                .padding({ left: 14, right: 14, top: 6, bottom: 6 })
                .backgroundColor('rgba(212,168,83,0.1)')
                .borderRadius(16)
                .margin({ right: 8, bottom: 8 })
                .onClick(() => {
                  this.searchKeyword = keyword
                  this.doSearch()
                })
            })
          }
          .width('100%')
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 24 })
        .alignItems(HorizontalAlign.Start)

        Column({ space: 12 }) {
          Text('全部演员')
            .fontSize(15)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
            .width('100%')

          ForEach(MOCK_ACTORS, (actor: ActorInfo) => {
            Row() {
              Column() {
                Text(actor.name[0])
                  .fontSize(20)
                  .fontColor('#D4A853')
                  .fontWeight(FontWeight.Bold)
              }
              .width(50)
              .height(50)
              .borderRadius(25)
              .backgroundColor('#1A1A2E')
              .border({ width: 1, color: 'rgba(212,168,83,0.3)' })
              .justifyContent(FlexAlign.Center)

              Column({ space: 4 }) {
                Text(actor.name)
                  .fontSize(15)
                  .fontColor('#FFFFFF')
                  .fontWeight(FontWeight.Bold)
                Text(actor.role + ' · ' + actor.shows.length + '场演出')
                  .fontSize(12)
                  .fontColor('#666E8A')
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ left: 12 })
              .layoutWeight(1)

              Text('›')
                .fontSize(24)
                .fontColor('#666E8A')
            }
            .width('100%')
            .padding(14)
            .backgroundColor('#1A1A2E')
            .borderRadius(12)
            .onClick(() => {
              router.pushUrl({ url: 'pages/ActorDetail', params: { actorId: actor.id } })
            })
          })
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 24 })
        .alignItems(HorizontalAlign.Start)

        Column().height(80)
      }
      .width('100%')
    }
    .layoutWeight(1)
    .width('100%')
    .backgroundColor('#0D0D0D')
  }

  @Builder
  CalendarPage() {
    Scroll() {
      Column({ space: 0 }) {
        Text('演出日历')
          .fontSize(20)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .padding({ left: 20, top: 20, bottom: 16 })

        Row() {
          Text('‹')
            .fontSize(24)
            .fontColor('#D4A853')
            .width(40)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              if (this.calendarMonth === 1) {
                this.calendarMonth = 12
                this.calendarYear = this.calendarYear - 1
              } else {
                this.calendarMonth = this.calendarMonth - 1
              }
              this.updateCalendarInfo()
            })

          Text(this.calendarYear + '年 ' + this.calendarMonth + '月')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Text('›')
            .fontSize(24)
            .fontColor('#D4A853')
            .width(40)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              if (this.calendarMonth === 12) {
                this.calendarMonth = 1
                this.calendarYear = this.calendarYear + 1
              } else {
                this.calendarMonth = this.calendarMonth + 1
              }
              this.updateCalendarInfo()
            })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 12 })

        Row() {
          ForEach(['日', '一', '二', '三', '四', '五', '六'], (day: string) => {
            Text(day)
              .fontSize(12)
              .fontColor('#666E8A')
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
          })
        }
        .width('100%')
        .padding({ left: 12, right: 12, bottom: 8 })

        Column({ space: 0 }) {
          this.CalendarGrid()
        }
        .width('100%')
        .padding({ left: 12, right: 12 })

        Column({ space: 8 }) {
          Text('本月演出')
            .fontSize(15)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .padding({ top: 16, bottom: 8 })

          this.MonthShowList()
        }
        .width('100%')
        .padding({ left: 20, right: 20 })

        Column().height(80)
      }
      .width('100%')
    }
    .layoutWeight(1)
    .width('100%')
    .backgroundColor('#0D0D0D')
  }

  @Builder
  CalendarGrid() {
    ForEach([0, 1, 2, 3, 4, 5], (weekIndex: number) => {
      Row() {
        ForEach([0, 1, 2, 3, 4, 5, 6], (dayIndex: number) => {
          this.CalendarCell(weekIndex * 7 + dayIndex - this.calendarFirstDay + 1)
        })
      }
      .width('100%')
    })
  }

  @Builder
  CalendarCell(dayNum: number) {
    if (dayNum >= 1 && dayNum <= this.calendarDaysInMonth) {
      Column({ space: 2 }) {
        Text(dayNum + '')
          .fontSize(14)
          .fontColor(this.hasShowOnDay(dayNum) ? '#D4A853' : '#FFFFFF')
          .fontWeight(this.hasShowOnDay(dayNum) ? FontWeight.Bold : FontWeight.Normal)

        if (this.hasShowOnDay(dayNum)) {
          Column()
            .width(6)
            .height(6)
            .borderRadius(3)
            .backgroundColor('#D4A853')
        }
      }
      .width('100%')
      .height(44)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.hasShowOnDay(dayNum) ? 'rgba(212,168,83,0.08)' : 'transparent')
      .borderRadius(8)
    } else {
      Column()
        .width('100%')
        .height(44)
    }
  }

  @Builder
  MonthShowList() {
    ForEach(MOCK_SHOWS, (show: ShowInfo) => {
      if (this.isShowInCurrentMonth(show)) {
        Row({ space: 12 }) {
          Column({ space: 2 }) {
            Text(show.date.substring(8, 10))
              .fontSize(22)
              .fontColor('#D4A853')
              .fontWeight(FontWeight.Bold)
            Text(show.date.substring(5, 7) + '月')
              .fontSize(10)
              .fontColor('#666E8A')
          }
          .width(44)
          .alignItems(HorizontalAlign.Start)

          Column({ space: 4 }) {
            Text(show.title)
              .fontSize(14)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Medium)
            Text(show.time + ' · ' + show.venue)
              .fontSize(11)
              .fontColor('#666E8A')
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text(show.cast[0])
            .fontSize(11)
            .fontColor('#D4A853')
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .backgroundColor('rgba(212,168,83,0.12)')
            .borderRadius(8)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#1A1A2E')
        .borderRadius(10)
        .margin({ bottom: 8 })
      }
    })
  }

  @Builder
  ProfilePage() {
    Scroll() {
      Column({ space: 0 }) {
        Column({ space: 8 }) {
          Column() {
            Text('🎭')
              .fontSize(36)
          }
          .width(80)
          .height(80)
          .borderRadius(40)
          .backgroundColor('#1A1A2E')
          .border({ width: 2, color: '#D4A853' })
          .justifyContent(FlexAlign.Center)

          Text('追幕用户')
            .fontSize(18)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)

          Text('theater enthusiast')
            .fontSize(12)
            .fontColor('#666E8A')
        }
        .width('100%')
        .padding({ top: 24, bottom: 20 })
        .alignItems(HorizontalAlign.Center)

        Row({ space: 0 }) {
          Column({ space: 4 }) {
            Text(this.followedActorsList.length + '')
              .fontSize(22)
              .fontColor('#D4A853')
              .fontWeight(FontWeight.Bold)
            Text('关注演员')
              .fontSize(11)
              .fontColor('#666E8A')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
          .padding(16)

          Column()
            .width(1)
            .height(40)
            .backgroundColor('#2A3050')

          Column({ space: 4 }) {
            Text(MOCK_SHOWS.length + '')
              .fontSize(22)
              .fontColor('#D4A853')
              .fontWeight(FontWeight.Bold)
            Text('演出追踪')
              .fontSize(11)
              .fontColor('#666E8A')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
          .padding(16)

          Column()
            .width(1)
            .height(40)
            .backgroundColor('#2A3050')

          Column({ space: 4 }) {
            Text('5')
              .fontSize(22)
              .fontColor('#D4A853')
              .fontWeight(FontWeight.Bold)
            Text('本月日程')
              .fontSize(11)
              .fontColor('#666E8A')
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
          .padding(16)
        }
        .width('90%')
        .backgroundColor('#1A1A2E')
        .borderRadius(12)
        .margin({ left: 20, right: 20 })

        Column({ space: 12 }) {
          Text('我关注的演员')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .width('100%')

          if (this.followedActorsList.length === 0) {
            Text('暂无关注，去搜索页关注喜欢的演员吧')
              .fontSize(13)
              .fontColor('#666E8A')
              .width('100%')
              .padding(20)
              .textAlign(TextAlign.Center)
          } else {
            ForEach(this.followedActorsList, (actor: ActorInfo) => {
              Row() {
                Column() {
                  Text(actor.name[0])
                    .fontSize(20)
                    .fontColor('#D4A853')
                    .fontWeight(FontWeight.Bold)
                }
                .width(50)
                .height(50)
                .borderRadius(25)
                .backgroundColor('#1A1A2E')
                .border({ width: 1, color: 'rgba(212,168,83,0.3)' })
                .justifyContent(FlexAlign.Center)

                Column({ space: 4 }) {
                  Text(actor.name)
                    .fontSize(15)
                    .fontColor('#FFFFFF')
                    .fontWeight(FontWeight.Bold)
                  Text(actor.role + ' · ' + actor.shows.length + '场演出')
                    .fontSize(12)
                    .fontColor('#666E8A')
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 12 })
                .layoutWeight(1)

                Button('取消关注')
                  .fontSize(11)
                  .fontColor('#FF6B35')
                  .backgroundColor('transparent')
                  .border({ width: 1, color: '#FF6B35' })
                  .borderRadius(12)
                  .height(28)
                  .padding({ left: 10, right: 10 })
                  .onClick(() => {
                    toggleFollow(actor.id)
                    this.refreshFollowed()
                  })
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#1A1A2E')
              .borderRadius(12)
              .onClick(() => {
                router.pushUrl({ url: 'pages/ActorDetail', params: { actorId: actor.id } })
              })
            })
          }
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 24 })
        .alignItems(HorizontalAlign.Start)

        Column({ space: 0 }) {
          Text('更多功能')
            .fontSize(16)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .padding({ top: 24, bottom: 12 })

          this.MenuItem('🗺️', '巡演地图', '查看剧目全国巡演路线')
          this.MenuItem('🎭', '座位视角', '选择剧场查看座位遮挡情况')
          this.MenuItem('📷', 'AI识图', '扫描海报自动提取演出信息')
          this.MenuItem('📜', '关于追幕', '聚光灯下的卡司档期')
        }
        .width('100%')
        .padding({ left: 20, right: 20 })

        Column().height(80)
      }
      .width('100%')
    }
    .layoutWeight(1)
    .width('100%')
    .backgroundColor('#0D0D0D')
  }

  @Builder
  MenuItem(icon: string, title: string, desc: string) {
    Row() {
      Text(icon)
        .fontSize(22)
        .width(40)
      Column({ space: 2 }) {
        Text(title)
          .fontSize(14)
          .fontColor('#FFFFFF')
        Text(desc)
          .fontSize(11)
          .fontColor('#666E8A')
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .margin({ left: 8 })

      Text('›')
        .fontSize(24)
        .fontColor('#666E8A')
    }
    .width('100%')
    .padding(14)
    .backgroundColor('#1A1A2E')
    .borderRadius(12)
    .margin({ bottom: 8 })
    .onClick(() => {
      if (title === '巡演地图') {
        router.pushUrl({ url: 'pages/TourMap' })
      } else if (title === '座位视角') {
        router.pushUrl({ url: 'pages/SeatMap' })
      } else if (title === 'AI识图') {
        router.pushUrl({ url: 'pages/AIScan' })
      }
    })
  }

  @Builder
  TabItem(icon: string, label: string, index: number) {
    Row({ space: 12 }) {
      Text(icon)
        .fontSize(20)
      Text(label)
        .fontSize(14)
        .fontColor(this.currentTab === index ? '#D4A853' : '#666E8A')
    }
    .width('100%')
    .height(48)
    .padding({ left: 20 })
    .alignItems(VerticalAlign.Center)
    .borderRadius(8)
    .backgroundColor(this.currentTab === index ? 'rgba(212,168,83,0.12)' : 'transparent')
    .onClick(() => {
      this.currentTab = index
    })
  }

  @Builder
  FeatureCard(icon: string, label: string, onClick: () => void) {
    Column({ space: 8 }) {
      Column() {
        Text(icon)
          .fontSize(28)
      }
      .width(60)
      .height(60)
      .backgroundColor('#1A1A2E')
      .borderRadius(16)
      .border({ width: 1, color: 'rgba(212,168,83,0.15)' })
      .justifyContent(FlexAlign.Center)

      Text(label)
        .fontSize(12)
        .fontColor('#FFFFFF')
    }
    .width(100)
    .alignItems(HorizontalAlign.Center)
    .onClick(onClick)
  }

  @Builder
  ScheduleItem(day: string, month: string, title: string, venue: string, accentColor: string) {
    Row({ space: 16 }) {
      Column({ space: 2 }) {
        Text(day)
          .fontSize(28)
          .fontColor(accentColor)
          .fontWeight(FontWeight.Bold)
        Text(month)
          .fontSize(11)
          .fontColor('#666E8A')
      }
      .width(50)
      .alignItems(HorizontalAlign.Start)

      Column({ space: 6 }) {
        Text(title)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Medium)
          .width('100%')
        Row({ space: 4 }) {
          Text('📍')
            .fontSize(11)
            .fontColor('#666E8A')
          Text(venue)
            .fontSize(12)
            .fontColor('#666E8A')
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({ top: 4, bottom: 4 })
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 12, bottom: 12 })
  }

  getFirstDayOfMonth(): number {
    let date = new Date(this.calendarYear, this.calendarMonth - 1, 1)
    return date.getDay()
  }

  getDaysInMonth(): number {
    return new Date(this.calendarYear, this.calendarMonth, 0).getDate()
  }

  hasShowOnDay(day: number): boolean {
    let monthStr = this.calendarMonth < 10 ? '0' + this.calendarMonth : '' + this.calendarMonth
    let dayStr = day < 10 ? '0' + day : '' + day
    let targetDate = this.calendarYear + '-' + monthStr + '-' + dayStr
    for (let i = 0; i < MOCK_SHOWS.length; i++) {
      if (MOCK_SHOWS[i].date === targetDate) {
        return true
      }
    }
    return false
  }

  isShowInCurrentMonth(show: ShowInfo): boolean {
    let showMonth = parseInt(show.date.substring(5, 7))
    return showMonth === this.calendarMonth
  }

  doSearch() {
    if (this.searchKeyword.length === 0) {
      return
    }
    router.pushUrl({
      url: 'pages/SearchResult',
      params: {
        keyword: this.searchKeyword,
        searchType: 'all'
      }
    })
  }
}