import { router } from '@kit.ArkUI'
import { ShowInfo, ActorInfo } from '../model/ShowModel'
import { searchShows, searchActors, getStatusLabel, getStatusColor } from '../service/ShowData'

@Entry
@Component
struct SearchResult {
  @State keyword: string = ''
  @State searchType: string = 'all'
  @State showResults: ShowInfo[] = []
  @State actorResults: ActorInfo[] = []
  @State isLoaded: boolean = false

  aboutToAppear() {
    let params = router.getParams() as Record<string, string>
    if (params['keyword']) {
      this.keyword = params['keyword'] as string
    }
    if (params['searchType']) {
      this.searchType = params['searchType'] as string
    }
    this.performSearch()
  }

  performSearch() {
    if (this.searchType === 'actor' || this.searchType === 'all') {
      this.actorResults = searchActors(this.keyword)
    }
    if (this.searchType === 'show' || this.searchType === 'all') {
      this.showResults = searchShows(this.keyword)
    }
    this.isLoaded = true
  }

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

        Column({ space: 4 }) {
          Text('搜索: ' + this.keyword)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
          Text('找到 ' + (this.showResults.length + this.actorResults.length) + ' 个结果')
            .fontSize(12)
            .fontColor('#99A0B8')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 12, right: 20, top: 16, bottom: 8 })
      .height(70)

      if (!this.isLoaded) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color('#D4A853')
          Text('搜索中...')
            .fontSize(14)
            .fontColor('#99A0B8')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.showResults.length === 0 && this.actorResults.length === 0) {
        Column() {
          Text('未找到相关结果')
            .fontSize(16)
            .fontColor('#99A0B8')
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 12 }) {
          ForEach(this.actorResults, (actor: ActorInfo) => {
            ListItem() {
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
                    .fontSize(16)
                    .fontColor('#FFFFFF')
                    .fontWeight(FontWeight.Bold)
                  Text(actor.role + ' · ' + actor.shows.length + '场演出')
                    .fontSize(13)
                    .fontColor('#99A0B8')
                }
                .alignItems(HorizontalAlign.Start)
                .margin({ left: 12 })
                .layoutWeight(1)
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#1A1A2E')
              .borderRadius(12)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ActorDetail',
                  params: { actorId: actor.id }
                })
              })
            }
          })

          ForEach(this.showResults, (show: ShowInfo) => {
            ListItem() {
              this.ShowCard(show)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 16, right: 16, top: 8 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0D0D0D')
  }

  @Builder
  ShowCard(show: ShowInfo) {
    Column({ space: 8 }) {
      Row() {
        Text(show.title)
          .fontSize(17)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Text(show.castType)
          .fontSize(11)
          .fontColor('#D4A853')
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .backgroundColor('rgba(212,168,83,0.12)')
          .borderRadius(8)
      }
      .width('100%')

      Row({ space: 6 }) {
        Text('卡司:')
          .fontSize(12)
          .fontColor('#99A0B8')
        ForEach(show.cast, (actor: string) => {
          Text(actor)
            .fontSize(12)
            .fontColor('#FFFFFF')
            .padding({ left: 6, right: 6, top: 2, bottom: 2 })
            .backgroundColor('#2A3050')
            .borderRadius(10)
        })
      }
      .width('100%')

      Row({ space: 16 }) {
        Text(show.date + ' ' + show.time)
          .fontSize(12)
          .fontColor('#99A0B8')
        Text(show.venue)
          .fontSize(12)
          .fontColor('#99A0B8')
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')

      Row() {
        Text(show.price)
          .fontSize(13)
          .fontColor('#D4A853')
          .fontWeight(FontWeight.Medium)
        Blank()
        Text(getStatusLabel(show.status))
          .fontSize(12)
          .fontColor(getStatusColor(show.status))
          .padding({ left: 10, right: 10, top: 3, bottom: 3 })
          .backgroundColor(getStatusColor(show.status) + '18')
          .borderRadius(10)
      }
      .width('100%')
    }
    .width('100%')
    .padding(14)
    .backgroundColor('#1A1A2E')
    .borderRadius(12)
  }
}