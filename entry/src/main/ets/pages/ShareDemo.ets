import { router } from '@kit.ArkUI'
import { ShowInfo } from '../model/ShowModel'
import { MOCK_SHOWS } from '../service/ShowData'

@Entry
@Component
struct ShareDemo {
  @State selectedIndex: number = 0
  @State shareResult: string = ''

  build() {
    Column() {
      Row() {
        Text('‹')
          .fontSize(28)
          .fontColor('#FFFFFF')
          .width(40)
          .height(40)
          .textAlign(TextAlign.Center)
          .onClick(() => router.back())

        Text('碰一碰分享')
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

      Scroll() {
        Column({ space: 20 }) {
          Column({ space: 8 }) {
            Text('NFC碰一碰分享')
              .fontSize(16)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
            Text('基于鸿蒙Share Kit的碰一碰能力，将两台手机轻碰即可瞬间传输演出卡司与场次详情。')
              .fontSize(13)
              .fontColor('#666E8A')
              .lineHeight(20)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('rgba(212,168,83,0.06)')
          .borderRadius(12)

          this.ShareCard()

          Text('选择要分享的演出')
            .fontSize(14)
            .fontColor('#666E8A')
            .width('100%')

          List({ space: 8 }) {
            ForEach(MOCK_SHOWS, (show: ShowInfo, index: number) => {
              ListItem() {
                Row() {
                  Radio({ value: index + '', group: 'showSelect' })
                    .checked(this.selectedIndex === index)
                    .onChange((isChecked: boolean) => {
                      if (isChecked) {
                        this.selectedIndex = index
                      }
                    })

                  Column({ space: 4 }) {
                    Text(show.title)
                      .fontSize(14)
                      .fontColor('#FFFFFF')
                    Text(show.cast[0] + ' · ' + show.date)
                      .fontSize(12)
                      .fontColor('#666E8A')
                  }
                  .alignItems(HorizontalAlign.Start)
                  .margin({ left: 8 })
                  .layoutWeight(1)
                }
                .width('100%')
                .padding(12)
                .backgroundColor(this.selectedIndex === index ?
                  'rgba(212,168,83,0.08)' : '#1A1A2E')
                .borderRadius(10)
                .onClick(() => {
                  this.selectedIndex = index
                })
              }
            })
          }
          .width('100%')

          Button('碰一碰分享')
            .width('100%')
            .height(52)
            .fontSize(16)
            .fontColor('#0D0D0D')
            .fontWeight(FontWeight.Bold)
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [['#D4A853', 0], ['#E8BE63', 1]]
            })
            .borderRadius(26)
            .onClick(() => {
              this.shareResult = MOCK_SHOWS[this.selectedIndex].title + ' 已准备好分享'
            })

          if (this.shareResult.length > 0) {
            Text(this.shareResult)
              .fontSize(13)
              .fontColor('#34C759')
              .width('100%')
              .padding(14)
              .backgroundColor('rgba(52,199,89,0.08)')
              .borderRadius(12)
              .textAlign(TextAlign.Center)
          }

          Column({ space: 16 }) {
            Text('将两台手机背靠背轻碰')
              .fontSize(14)
              .fontColor('#666E8A')

            Row({ space: 40 }) {
              Column({ space: 4 }) {
                Text('你的手机')
                  .fontSize(11)
                  .fontColor('#444A5E')
              }

              Column({ space: 4 }) {
                Text('好友手机')
                  .fontSize(11)
                  .fontColor('#444A5E')
              }
            }
          }
          .width('100%')
          .padding(20)
          .backgroundColor('#1A1A2E')
          .borderRadius(12)
        }
        .padding({ left: 16, right: 16, bottom: 30 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0D0D0D')
  }

  @Builder
  ShareCard() {
    Column({ space: 12 }) {
      Text('分享预览')
        .fontSize(14)
        .fontColor('#666E8A')
        .width('100%')

      Column({ space: 10 }) {
        Row() {
          Text('追幕')
            .fontSize(14)
            .fontColor('#D4A853')
            .fontWeight(FontWeight.Bold)
          Blank()
          Text(MOCK_SHOWS[this.selectedIndex].castType)
            .fontSize(11)
            .fontColor('#D4A853')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor('rgba(212,168,83,0.12)')
            .borderRadius(6)
        }
        .width('100%')

        Text(MOCK_SHOWS[this.selectedIndex].title)
          .fontSize(22)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .width('100%')

        Text(MOCK_SHOWS[this.selectedIndex].cast.join(' · '))
          .fontSize(14)
          .fontColor('#D4A853')
          .width('100%')

        Text('📅 ' + MOCK_SHOWS[this.selectedIndex].date + ' ' + MOCK_SHOWS[this.selectedIndex].time)
          .fontSize(13)
          .fontColor('#666E8A')
        Text('📍 ' + MOCK_SHOWS[this.selectedIndex].venue)
          .fontSize(13)
          .fontColor('#666E8A')
        Text(MOCK_SHOWS[this.selectedIndex].price)
          .fontSize(13)
          .fontColor('#666E8A')

        Divider().color('#2A2A3E')

        Text('来自「追幕」· 聚光灯下的卡司档期')
          .fontSize(11)
          .fontColor('#444A5E')
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#1A1A2E')
      .borderRadius(16)
      .border({ width: 1, color: 'rgba(212,168,83,0.15)' })
    }
    .width('100%')
  }
}