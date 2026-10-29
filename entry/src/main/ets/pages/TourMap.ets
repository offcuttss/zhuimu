import { router } from '@kit.ArkUI'
import { MOCK_SHOWS } from '../service/ShowData'
import { ShowInfo } from '../model/ShowModel'

interface CityNode {
  name: string
  x: number
  y: number
  shows: string[]
  isVisited: boolean
}

@Entry
@Component
struct TourMap {
  @State selectedShow: number = 0
  @State selectedCity: number = -1
  @State cityNodes: CityNode[] = []

  private initCities(): CityNode[] {
    return [
      { name: '北京', x: 0.62, y: 0.22, shows: ['s003', 's004'], isVisited: false },
      { name: '上海', x: 0.72, y: 0.50, shows: ['s001', 's002', 's008'], isVisited: false },
      { name: '广州', x: 0.60, y: 0.78, shows: ['s005'], isVisited: false },
      { name: '深圳', x: 0.63, y: 0.82, shows: ['s006'], isVisited: false },
      { name: '南京', x: 0.68, y: 0.42, shows: ['s007'], isVisited: false },
      { name: '成都', x: 0.35, y: 0.52, shows: [], isVisited: false },
      { name: '武汉', x: 0.55, y: 0.52, shows: [], isVisited: false },
      { name: '杭州', x: 0.72, y: 0.55, shows: [], isVisited: false },
      { name: '重庆', x: 0.38, y: 0.58, shows: [], isVisited: false },
      { name: '西安', x: 0.42, y: 0.38, shows: [], isVisited: false },
      { name: '天津', x: 0.64, y: 0.24, shows: [], isVisited: false },
      { name: '长沙', x: 0.55, y: 0.65, shows: [], isVisited: false }
    ]
  }

  aboutToAppear() {
    this.cityNodes = this.initCities()
    this.filterCitiesForShow(0)
  }

  filterCitiesForShow(index: number) {
    this.selectedCity = -1
    let nodes = this.initCities()
    let showId = MOCK_SHOWS[index].id
    for (let i = 0; i < nodes.length; i++) {
      if (nodes[i].shows.indexOf(showId) >= 0) {
        nodes[i].isVisited = true
      }
    }
    this.cityNodes = nodes
  }

  getCityShowInfo(city: CityNode): ShowInfo | null {
    let showId = MOCK_SHOWS[this.selectedShow].id
    for (let i = 0; i < MOCK_SHOWS.length; i++) {
      if (MOCK_SHOWS[i].id === showId && city.shows.indexOf(showId) >= 0) {
        return MOCK_SHOWS[i]
      }
    }
    return null
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor('#FFFFFF')
          .width(40)
          .height(40)
          .textAlign(TextAlign.Center)
          .onClick(() => router.back())

        Text('3D巡演地图')
          .fontSize(18)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('')
          .width(40)
      }
      .width('100%')
      .padding({ left: 12, right: 20, top: 16, bottom: 8 })

      // 剧目选择
      Scroll() {
        Row({ space: 10 }) {
          ForEach(MOCK_SHOWS, (show: ShowInfo, index: number) => {
            Text(show.title.replace('《', '').replace('》', ''))
              .fontSize(13)
              .fontColor(this.selectedShow === index ? '#0D0D0D' : '#666E8A')
              .fontWeight(this.selectedShow === index ? FontWeight.Bold : FontWeight.Normal)
              .padding({ left: 14, right: 14, top: 6, bottom: 6 })
              .borderRadius(16)
              .backgroundColor(this.selectedShow === index ? '#D4A853' : 'rgba(102,110,138,0.1)')
              .onClick(() => {
                this.selectedShow = index
                this.filterCitiesForShow(index)
              })
          })
        }
        .padding({ left: 16, right: 16 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .width('100%')
      .margin({ top: 8 })

      // 地图区域
      Stack() {
        // 地图背景
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#0D0D0D')

        // 中国地图轮廓（简化版SVG风格）
        Column() {
          // 东北地区
          Row()
            .width(120)
            .height(60)
            .backgroundColor('rgba(40,42,62,0.6)')
            .borderRadius(8)
            .position({ x: 200, y: 10 })

          // 华北地区
          Row()
            .width(140)
            .height(70)
            .backgroundColor('rgba(40,42,62,0.5)')
            .borderRadius(10)
            .position({ x: 170, y: 60 })

          // 西北地区
          Row()
            .width(130)
            .height(90)
            .backgroundColor('rgba(40,42,62,0.4)')
            .borderRadius(12)
            .position({ x: 30, y: 50 })

          // 西南地区
          Row()
            .width(110)
            .height(80)
            .backgroundColor('rgba(40,42,62,0.45)')
            .borderRadius(10)
            .position({ x: 40, y: 140 })

          // 华中地区
          Row()
            .width(100)
            .height(70)
            .backgroundColor('rgba(40,42,62,0.5)')
            .borderRadius(10)
            .position({ x: 140, y: 130 })

          // 华东地区
          Row()
            .width(110)
            .height(80)
            .backgroundColor('rgba(40,42,62,0.55)')
            .borderRadius(10)
            .position({ x: 210, y: 110 })

          // 华南地区
          Row()
            .width(120)
            .height(70)
            .backgroundColor('rgba(40,42,62,0.5)')
            .borderRadius(10)
            .position({ x: 160, y: 200 })
        }
        .width('100%')
        .height('100%')

        // 连线层（巡演路线）
        ForEach(this.cityNodes, (city: CityNode, index: number) => {
          if (city.isVisited) {
            ForEach(this.cityNodes, (city2: CityNode, index2: number) => {
              if (city2.isVisited && index2 > index) {
                Row()
                  .width(2)
                  .height(60)
                  .backgroundColor('rgba(212,168,83,0.2)')
                  .position({
                    x: (city.x + city2.x) / 2 * 340,
                    y: (city.y + city2.y) / 2 * 360
                  })
              }
            })
          }
        })

        // 城市节点
        ForEach(this.cityNodes, (city: CityNode, index: number) => {
          Column() {
            if (city.isVisited) {
              // 脉冲光环
              Column()
                .width(this.selectedCity === index ? 28 : 22)
                .height(this.selectedCity === index ? 28 : 22)
                .borderRadius(this.selectedCity === index ? 14 : 11)
                .backgroundColor('rgba(212,168,83,0.15)')

              Column()
                .width(this.selectedCity === index ? 16 : 12)
                .height(this.selectedCity === index ? 16 : 12)
                .borderRadius(this.selectedCity === index ? 8 : 6)
                .backgroundColor('#D4A853')
                .shadow({ radius: 12, color: 'rgba(212,168,83,0.6)' })
            } else {
              Column()
                .width(8)
                .height(8)
                .borderRadius(4)
                .backgroundColor('rgba(102,110,138,0.4)')
                .border({ width: 1, color: 'rgba(102,110,138,0.3)' })
            }

            Text(city.name)
              .fontSize(11)
              .fontColor(city.isVisited ? '#D4A853' : '#666E8A')
              .fontWeight(city.isVisited ? FontWeight.Bold : FontWeight.Normal)
              .margin({ top: 4 })
          }
          .position({
            x: city.x * 320,
            y: city.y * 360
          })
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            this.selectedCity = index
          })
        })

        // 选中城市详情卡
        if (this.selectedCity >= 0) {
          this.CityDetailCard()
        }
      }
      .width(360)
      .height(400)
      .margin({ top: 12 })
      .borderRadius(16)
      .clip(true)
      .backgroundColor('#0D0D0D')

      // 图例
      Row({ space: 24 }) {
        Row({ space: 6 }) {
          Column()
            .width(12)
            .height(12)
            .borderRadius(6)
            .backgroundColor('#D4A853')
            .shadow({ radius: 6, color: 'rgba(212,168,83,0.5)' })
          Text('有巡演')
            .fontSize(12)
            .fontColor('#666E8A')
        }
        Row({ space: 6 }) {
          Column()
            .width(8)
            .height(8)
            .borderRadius(4)
            .backgroundColor('rgba(102,110,138,0.4)')
          Text('暂无计划')
            .fontSize(12)
            .fontColor('#666E8A')
        }
      }
      .margin({ top: 12 })

      // 底部统计
      Row({ space: 0 }) {
        Column({ space: 4 }) {
          Text(this.getVisitedCount() + '')
            .fontSize(22)
            .fontColor('#D4A853')
            .fontWeight(FontWeight.Bold)
          Text('巡演城市')
            .fontSize(12)
            .fontColor('#666E8A')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding(12)

        Column()
          .width(1)
          .height(40)
          .backgroundColor('#2A3050')

        Column({ space: 4 }) {
          Text(this.getVisitedCount() + '场')
            .fontSize(22)
            .fontColor('#D4A853')
            .fontWeight(FontWeight.Bold)
          Text('演出场次')
            .fontSize(12)
            .fontColor('#666E8A')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .padding(12)
      }
      .width('100%')
      .margin({ top: 12, left: 20, right: 20 })
      .backgroundColor('#1A1A2E')
      .borderRadius(12)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0D0D0D')
  }

  @Builder
  CityDetailCard() {
    Column({ space: 10 }) {
      Row() {
        Text(this.cityNodes[this.selectedCity].name)
          .fontSize(16)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
        Blank()
        if (this.cityNodes[this.selectedCity].isVisited) {
          Text('● 有巡演')
            .fontSize(11)
            .fontColor('#D4A853')
        } else {
          Text('○ 暂无计划')
            .fontSize(11)
            .fontColor('#666E8A')
        }
      }
      .width('100%')

      if (this.cityNodes[this.selectedCity].isVisited) {
        Text(this.getCityShowInfo(this.cityNodes[this.selectedCity])!.title)
          .fontSize(14)
          .fontColor('#D4A853')
          .fontWeight(FontWeight.Medium)
        Row({ space: 16 }) {
          Row({ space: 4 }) {
            Text('📅')
              .fontSize(11)
            Text(this.getCityShowInfo(this.cityNodes[this.selectedCity])!.date + ' ' + this.getCityShowInfo(this.cityNodes[this.selectedCity])!.time)
              .fontSize(12)
              .fontColor('#FFFFFF')
          }
          Row({ space: 4 }) {
            Text('📍')
              .fontSize(11)
            Text(this.getCityShowInfo(this.cityNodes[this.selectedCity])!.venue)
              .fontSize(12)
              .fontColor('#FFFFFF')
          }
        }
        .width('100%')

        Row({ space: 6 }) {
          ForEach(this.getCityShowInfo(this.cityNodes[this.selectedCity])!.cast, (name: string) => {
            Text(name)
              .fontSize(11)
              .fontColor('#FFFFFF')
              .padding({ left: 8, right: 8, top: 3, bottom: 3 })
              .backgroundColor('rgba(212,168,83,0.15)')
              .borderRadius(10)
          })
        }
        .width('100%')

        Row() {
          Text(this.getCityShowInfo(this.cityNodes[this.selectedCity])!.price)
            .fontSize(13)
            .fontColor('#D4A853')
            .fontWeight(FontWeight.Medium)
          Blank()
          Text('查看座位图 ›')
            .fontSize(12)
            .fontColor('#D4A853')
            .onClick(() => {
              router.pushUrl({ url: 'pages/SeatMap' })
            })
        }
        .width('100%')
      } else {
        Text('该城市暂无此剧目的巡演计划')
          .fontSize(12)
          .fontColor('#666E8A')
        Button('提醒我当有演出')
          .fontSize(12)
          .fontColor('#D4A853')
          .backgroundColor('transparent')
          .border({ width: 1, color: '#D4A853' })
          .borderRadius(16)
          .height(32)
          .padding({ left: 16, right: 16 })
      }
    }
    .padding(16)
    .backgroundColor('#1A1A2E')
    .borderRadius(16)
    .border({ width: 1, color: 'rgba(212,168,83,0.2)' })
    .width('90%')
    .position({ x: '5%', y: 280 })
  }

  getVisitedCount(): number {
    let count = 0
    for (let i = 0; i < this.cityNodes.length; i++) {
      if (this.cityNodes[i].isVisited) {
        count++
      }
    }
    return count
  }
}