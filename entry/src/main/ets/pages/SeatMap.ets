import { router, promptAction } from '@kit.ArkUI'
import { MOCK_SHOWS } from '../service/ShowData'
import { ShowInfo } from '../model/ShowModel'

interface SeatInfo {
  row: number
  col: number
  zone: string
  price: number
  status: string
}

interface VenueInfo {
  name: string
  city: string
  rows: number
  cols: number
  hasBalcony: boolean
}

@Entry
@Component
struct SeatMap {
  @State step: number = 0  // 0=选剧场 1=选剧目 2=选座
  @State selectedVenue: number = -1
  @State selectedShow: number = -1
  @State selectedSeats: string[] = []
  @State seatData: SeatInfo[] = []
  @State showViewTip: boolean = false

  private venues: VenueInfo[] = [
    { name: '上海大剧院', city: '上海', rows: 13, cols: 16, hasBalcony: true },
    { name: '北京保利剧院', city: '北京', rows: 12, cols: 14, hasBalcony: true },
    { name: '广州大剧院', city: '广州', rows: 11, cols: 15, hasBalcony: false },
    { name: '深圳滨海艺术中心', city: '深圳', rows: 10, cols: 14, hasBalcony: false },
    { name: '南京保利大剧院', city: '南京', rows: 12, cols: 14, hasBalcony: true },
    { name: '上海文化广场', city: '上海', rows: 14, cols: 18, hasBalcony: true }
  ]

  private zones: Record<string, string> = {
    'VIP': '#D4A853',
    'A': '#4A90D9',
    'B': '#34C759',
    'C': '#9966CC'
  }

  private zoneNames: Record<string, string> = {
    'VIP': 'VIP贵宾区',
    'A': 'A区',
    'B': 'B区',
    'C': 'C区'
  }

  // 遮挡等级颜色
  private viewLevels: string[] = ['#34C759', '#FFCC00', '#FF6B35', '#FF3B30']

  getVenueShows(venueName: string): ShowInfo[] {
    let result: ShowInfo[] = []
    for (let i = 0; i < MOCK_SHOWS.length; i++) {
      if (MOCK_SHOWS[i].venue === venueName) {
        result.push(MOCK_SHOWS[i])
      }
    }
    return result
  }

  generateSeats(rows: number, cols: number) {
    let seats: SeatInfo[] = []
    for (let row = 1; row <= rows; row++) {
      for (let col = 1; col <= cols; col++) {
        let zone = 'C'
        let price = 280
        if (row <= 2) {
          zone = 'VIP'
          price = 1280
        } else if (row <= 5) {
          zone = 'A'
          price = 880
        } else if (row <= 9) {
          zone = 'B'
          price = 580
        }

        let rand = Math.floor(Math.random() * 10)
        let status = 'available'
        if (rand < 5) {
          status = 'available'
        } else if (rand < 8) {
          status = 'sold'
        } else {
          status = 'locked'
        }
        seats.push({ row: row, col: col, zone: zone, price: price, status: status })
      }
    }
    this.seatData = seats
  }

  getSeatsByRow(row: number): SeatInfo[] {
    let result: SeatInfo[] = []
    for (let i = 0; i < this.seatData.length; i++) {
      if (this.seatData[i].row === row) {
        result.push(this.seatData[i])
      }
    }
    return result
  }

  getSeatId(seat: SeatInfo): string {
    return seat.row + '-' + seat.col
  }

  isSeatSelected(seat: SeatInfo): boolean {
    let seatId = this.getSeatId(seat)
    for (let i = 0; i < this.selectedSeats.length; i++) {
      if (this.selectedSeats[i] === seatId) {
        return true
      }
    }
    return false
  }

  toggleSeat(seat: SeatInfo) {
    if (seat.status !== 'available') {
      return
    }
    let seatId = this.getSeatId(seat)
    let newSeats: string[] = []
    let found = false
    for (let i = 0; i < this.selectedSeats.length; i++) {
      if (this.selectedSeats[i] === seatId) {
        found = true
      } else {
        newSeats.push(this.selectedSeats[i])
      }
    }
    if (!found) {
      newSeats.push(seatId)
    }
    this.selectedSeats = newSeats
  }

  getTotalPrice(): number {
    let total = 0
    for (let i = 0; i < this.selectedSeats.length; i++) {
      let parts = this.selectedSeats[i].split('-')
      let row = parseInt(parts[0])
      let col = parseInt(parts[1])
      for (let j = 0; j < this.seatData.length; j++) {
        if (this.seatData[j].row === row && this.seatData[j].col === col) {
          total += this.seatData[j].price
          break
        }
      }
    }
    return total
  }

  getAvailableCount(): number {
    let count = 0
    for (let i = 0; i < this.seatData.length; i++) {
      if (this.seatData[i].status === 'available') {
        count++
      }
    }
    return count
  }

  getSoldCount(): number {
    let count = 0
    for (let i = 0; i < this.seatData.length; i++) {
      if (this.seatData[i].status === 'sold') {
        count++
      }
    }
    return count
  }

  // 根据排数返回视角等级（0=最佳 3=最差）
  getViewLevel(row: number): number {
    if (row <= 5) {
      return 0  // 绿色 - 视角极佳
    } else if (row <= 8) {
      return 1  // 黄色 - 视角良好
    } else if (row <= 11) {
      return 2  // 橙色 - 视角一般
    } else {
      return 3  // 红色 - 视角受限
    }
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
          .onClick(() => {
            if (this.step > 0) {
              this.step = this.step - 1
              this.selectedSeats = []
            } else {
              router.back()
            }
          })

        Text(this.getStepTitle())
          .fontSize(18)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text(this.showViewTip ? '关闭' : '视角')
          .fontSize(13)
          .fontColor(this.showViewTip ? '#FF6B35' : '#D4A853')
          .width(40)
          .textAlign(TextAlign.Center)
          .visibility(this.step === 2 ? Visibility.Visible : Visibility.Hidden)
          .onClick(() => {
            this.showViewTip = !this.showViewTip
          })
      }
      .width('100%')
      .padding({ left: 12, right: 20, top: 16, bottom: 8 })

      // 步骤指示器
      Row({ space: 8 }) {
        ForEach(['选剧场', '选剧目', '选座位'], (label: string, index: number) => {
          Row({ space: 4 }) {
            Column()
              .width(20)
              .height(20)
              .borderRadius(10)
              .backgroundColor(this.step >= index ? '#D4A853' : '#2A3050')
              .justifyContent(FlexAlign.Center)
            Text((index + 1) + '')
              .fontSize(11)
              .fontColor(this.step >= index ? '#0D0D0D' : '#666E8A')
              .fontWeight(FontWeight.Bold)
              .position({ x: 5, y: 2 })
          }
          .width(20)
          .height(20)

          Text(label)
            .fontSize(11)
            .fontColor(this.step >= index ? '#D4A853' : '#666E8A')

          if (index < 2) {
            Column()
              .width(40)
              .height(1)
              .backgroundColor(this.step > index ? '#D4A853' : '#2A3050')
          }
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ top: 8, bottom: 12 })

      if (this.step === 0) {
        // 第一步：选择剧场
        this.VenueListStep()
      } else if (this.step === 1) {
        // 第二步：选择剧目
        this.ShowListStep()
      } else {
        // 第三步：选座
        this.SeatSelectionStep()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0D0D0D')
  }

  getStepTitle(): string {
    if (this.step === 0) {
      return '选择剧场'
    } else if (this.step === 1) {
      return '选择剧目'
    } else {
      return '选择座位'
    }
  }

  @Builder
  VenueListStep() {
    Scroll() {
      Column({ space: 12 }) {
        Text('请选择您要查看的剧场')
          .fontSize(13)
          .fontColor('#666E8A')
          .width('100%')
          .padding({ left: 20 })

        ForEach(this.venues, (venue: VenueInfo, index: number) => {
          Row() {
            Column({ space: 6 }) {
              Text(venue.name)
                .fontSize(16)
                .fontColor('#FFFFFF')
                .fontWeight(FontWeight.Bold)
              Row({ space: 12 }) {
                Row({ space: 4 }) {
                  Text('📍')
                    .fontSize(11)
                  Text(venue.city)
                    .fontSize(12)
                    .fontColor('#666E8A')
                }
                Row({ space: 4 }) {
                  Text('💺')
                    .fontSize(11)
                  Text(venue.rows + '排 · ' + venue.cols + '座/排')
                    .fontSize(12)
                    .fontColor('#666E8A')
                }
                if (venue.hasBalcony) {
                  Row({ space: 4 }) {
                    Text('🏛️')
                      .fontSize(11)
                    Text('含楼座')
                      .fontSize(12)
                      .fontColor('#D4A853')
                  }
                }
              }
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)

            Text('›')
              .fontSize(24)
              .fontColor('#666E8A')
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#1A1A2E')
          .borderRadius(12)
          .border({
            width: this.selectedVenue === index ? 1 : 0,
            color: '#D4A853'
          })
          .onClick(() => {
            this.selectedVenue = index
            this.step = 1
          })
        })
      }
      .padding({ left: 20, right: 20, bottom: 20 })
    }
    .layoutWeight(1)
    .width('100%')
  }

  @Builder
  ShowListStep() {
    Scroll() {
      Column({ space: 12 }) {
        Text(this.venues[this.selectedVenue].name + ' 近期演出')
          .fontSize(13)
          .fontColor('#666E8A')
          .width('100%')

        if (this.getVenueShows(this.venues[this.selectedVenue].name).length === 0) {
          Column({ space: 8 }) {
            Text('🎭')
              .fontSize(40)
            Text('该剧场暂无演出安排')
              .fontSize(14)
              .fontColor('#666E8A')
            Button('返回选择其他剧场')
              .fontSize(13)
              .fontColor('#D4A853')
              .backgroundColor('transparent')
              .border({ width: 1, color: '#D4A853' })
              .borderRadius(16)
              .height(36)
              .margin({ top: 8 })
              .onClick(() => {
                this.step = 0
              })
          }
          .width('100%')
          .padding(40)
          .alignItems(HorizontalAlign.Center)
        } else {
          ForEach(this.getVenueShows(this.venues[this.selectedVenue].name), (show: ShowInfo) => {
            Column({ space: 10 }) {
              Row() {
                Text(show.title)
                  .fontSize(16)
                  .fontColor('#FFFFFF')
                  .fontWeight(FontWeight.Bold)
                  .layoutWeight(1)
                Text(show.castType)
                  .fontSize(11)
                  .fontColor('#D4A853')
                  .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                  .backgroundColor('rgba(212,168,83,0.12)')
                  .borderRadius(8)
              }
              .width('100%')

              Row({ space: 16 }) {
                Row({ space: 4 }) {
                  Text('📅')
                    .fontSize(11)
                  Text(show.date + ' ' + show.time)
                    .fontSize(12)
                    .fontColor('#666E8A')
                }
                Row({ space: 4 }) {
                  Text('💰')
                    .fontSize(11)
                  Text(show.price)
                    .fontSize(12)
                    .fontColor('#D4A853')
                }
              }
              .width('100%')

              Row({ space: 6 }) {
                Text('卡司:')
                  .fontSize(12)
                  .fontColor('#666E8A')
                ForEach(show.cast, (name: string) => {
                  Text(name)
                    .fontSize(11)
                    .fontColor('#FFFFFF')
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .backgroundColor('#2A3050')
                    .borderRadius(8)
                })
              }
              .width('100%')

              Button('查看座位图')
                .width('100%')
                .height(40)
                .fontSize(14)
                .fontColor('#0D0D0D')
                .fontWeight(FontWeight.Bold)
                .linearGradient({
                  direction: GradientDirection.Right,
                  colors: [['#D4A853', 0], ['#E8BE63', 1]]
                })
                .borderRadius(20)
                .margin({ top: 4 })
                .onClick(() => {
                  let showIndex = -1
                  for (let i = 0; i < MOCK_SHOWS.length; i++) {
                    if (MOCK_SHOWS[i].id === show.id) {
                      showIndex = i
                      break
                    }
                  }
                  this.selectedShow = showIndex
                  let venue = this.venues[this.selectedVenue]
                  this.generateSeats(venue.rows, venue.cols)
                  this.step = 2
                })
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#1A1A2E')
            .borderRadius(12)
          })
        }
      }
      .padding({ left: 20, right: 20, top: 8, bottom: 20 })
    }
    .layoutWeight(1)
    .width('100%')
  }

  @Builder
  SeatSelectionStep() {
    Column() {
      // 演出信息
      Row() {
        Column({ space: 4 }) {
          Text(MOCK_SHOWS[this.selectedShow].title)
            .fontSize(15)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
          Text(this.venues[this.selectedVenue].name + ' · ' + MOCK_SHOWS[this.selectedShow].date)
            .fontSize(12)
            .fontColor('#666E8A')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        // 视角说明
        if (this.showViewTip) {
          Row({ space: 8 }) {
            ForEach(this.viewLevels, (color: string, index: number) => {
              Row({ space: 3 }) {
                Column()
                  .width(10)
                  .height(10)
                  .borderRadius(2)
                  .backgroundColor(color)
                Text(this.getViewLabel(index))
                  .fontSize(9)
                  .fontColor('#666E8A')
              }
            })
          }
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })

      // 座位图
      Scroll() {
        Column({ space: 4 }) {
          // 舞台
          Row() {
            Text('舞 台')
              .fontSize(14)
              .fontColor('#D4A853')
              .fontWeight(FontWeight.Bold)
              .letterSpacing(12)
          }
          .width(240)
          .height(32)
          .backgroundColor('rgba(212,168,83,0.1)')
          .borderRadius(4)
          .border({ width: 1, color: 'rgba(212,168,83,0.3)' })
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 8 })

          // 座位行
          ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], (rowNum: number) => {
            Row({ space: 3 }) {
              Text(rowNum + '')
                .fontSize(10)
                .fontColor('#666E8A')
                .width(16)
                .textAlign(TextAlign.Center)

              ForEach(this.getSeatsByRow(rowNum), (seat: SeatInfo) => {
                Column()
                  .width(16)
                  .height(16)
                  .borderRadius(3)
                  .backgroundColor(this.showViewTip ? this.viewLevels[this.getViewLevel(seat.row)] : this.getSeatColor(seat))
                  .border({
                    width: this.isSeatSelected(seat) ? 2 : 0,
                    color: '#FFFFFF'
                  })
                  .opacity(seat.status === 'sold' || seat.status === 'locked' ? 0.4 : 1)
                  .onClick(() => {
                    this.toggleSeat(seat)
                  })
              })

              Text(rowNum + '')
                .fontSize(10)
                .fontColor('#666E8A')
                .width(16)
                .textAlign(TextAlign.Center)
            }
            .margin({ bottom: 2 })
          })
        }
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 12, bottom: 20 })
      }
      .layoutWeight(1)
      .width('100%')

      // 图例
      if (!this.showViewTip) {
        Row({ space: 16 }) {
          Row({ space: 4 }) {
            Column()
              .width(12)
              .height(12)
              .borderRadius(3)
              .backgroundColor('#34C759')
            Text('可选')
              .fontSize(10)
              .fontColor('#666E8A')
          }
          Row({ space: 4 }) {
            Column()
              .width(12)
              .height(12)
              .borderRadius(3)
              .backgroundColor('#3A3A4E')
            Text('已售')
              .fontSize(10)
              .fontColor('#666E8A')
          }
          Row({ space: 4 }) {
            Column()
              .width(12)
              .height(12)
              .borderRadius(3)
              .backgroundColor('#FFFFFF')
              .border({ width: 2, color: '#FFFFFF' })
            Text('已选')
              .fontSize(10)
              .fontColor('#666E8A')
          }
        }
        .width('100%')
        .padding({ top: 4, bottom: 4 })
        .justifyContent(FlexAlign.Center)
      }

      // 底部状态栏
      Row() {
        Row({ space: 16 }) {
          Column({ space: 2 }) {
            Text(this.getAvailableCount() + '')
              .fontSize(16)
              .fontColor('#34C759')
              .fontWeight(FontWeight.Bold)
            Text('可选')
              .fontSize(10)
              .fontColor('#666E8A')
          }
          Column({ space: 2 }) {
            Text(this.getSoldCount() + '')
              .fontSize(16)
              .fontColor('#FF3B30')
              .fontWeight(FontWeight.Bold)
            Text('已售')
              .fontSize(10)
              .fontColor('#666E8A')
          }
          Column({ space: 2 }) {
            Text(this.selectedSeats.length + '')
              .fontSize(16)
              .fontColor('#D4A853')
              .fontWeight(FontWeight.Bold)
            Text('已选')
              .fontSize(10)
              .fontColor('#666E8A')
          }
        }
        .layoutWeight(1)

        Row({ space: 12 }) {
          Column({ space: 2 }) {
            Text('¥' + this.getTotalPrice())
              .fontSize(18)
              .fontColor('#D4A853')
              .fontWeight(FontWeight.Bold)
            Text('合计')
              .fontSize(10)
              .fontColor('#666E8A')
          }

          Button('确认选座')
            .height(44)
            .fontSize(14)
            .fontColor('#0D0D0D')
            .fontWeight(FontWeight.Bold)
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [['#D4A853', 0], ['#E8BE63', 1]]
            })
            .borderRadius(22)
            .enabled(this.selectedSeats.length > 0)
            .opacity(this.selectedSeats.length > 0 ? 1 : 0.5)
            .onClick(() => {
              promptAction.showToast({
                message: '已选 ' + this.selectedSeats.length + ' 个座位，合计 ¥' + this.getTotalPrice(),
                duration: 3000
              })
            })
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 16 })
      .backgroundColor('#1A1A2E')
      .border({ width: { top: 1 }, color: '#2A3050' })
    }
    .width('100%')
    .height('100%')
  }

  getSeatColor(seat: SeatInfo): string {
    if (this.isSeatSelected(seat)) {
      return '#FFFFFF'
    }
    if (seat.status === 'sold') {
      return '#3A3A4E'
    }
    if (seat.status === 'locked') {
      return '#2A2A3E'
    }
    return this.zones[seat.zone]
  }

  getViewLabel(index: number): string {
    if (index === 0) {
      return '极佳'
    } else if (index === 1) {
      return '良好'
    } else if (index === 2) {
      return '一般'
    } else {
      return '受限'
    }
  }
}