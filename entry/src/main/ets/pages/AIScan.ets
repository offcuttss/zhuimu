import { router } from '@kit.ArkUI'
import { OcrResult } from '../model/ShowModel'

@Entry
@Component
struct AIScan {
  @State isProcessing: boolean = false
  @State ocrResult: OcrResult | null = null
  @State errorMsg: string = ''

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

        Text('AI智能识别')
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
            Text('端侧AI智能识别')
              .fontSize(16)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Bold)
            Text('上传演出截图或海报，AI将在设备端本地识别并自动提取剧名、卡司、日期、场馆等关键信息。')
              .fontSize(13)
              .fontColor('#666E8A')
              .lineHeight(20)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('rgba(212,168,83,0.06)')
          .borderRadius(12)

          Column({ space: 12 }) {
            Text('📸')
              .fontSize(48)
            Text('点击选择演出截图或海报')
              .fontSize(14)
              .fontColor('#666E8A')
            Text('支持JPG、PNG格式')
              .fontSize(12)
              .fontColor('#444A5E')
          }
          .width('100%')
          .height(180)
          .backgroundColor('#1A1A2E')
          .borderRadius(12)
          .justifyContent(FlexAlign.Center)

          if (this.isProcessing) {
            Column({ space: 12 }) {
              LoadingProgress()
                .width(36)
                .height(36)
                .color('#D4A853')
              Text('正在端侧AI识别中...')
                .fontSize(14)
                .fontColor('#D4A853')
              Text('Core Vision Kit · 本地执行')
                .fontSize(12)
                .fontColor('#444A5E')
            }
            .width('100%')
            .padding(24)
            .backgroundColor('#1A1A2E')
            .borderRadius(12)
            .justifyContent(FlexAlign.Center)
          }

          if (this.ocrResult !== null && !this.isProcessing) {
            Column({ space: 16 }) {
              Row() {
                Text('识别完成')
                  .fontSize(16)
                  .fontColor('#34C759')
                  .fontWeight(FontWeight.Bold)
                Blank()
                Text('置信度: ' + Math.round(this.ocrResult.confidence * 100) + '%')
                  .fontSize(12)
                  .fontColor('#666E8A')
              }
              .width('100%')

              Column({ space: 12 }) {
                this.ResultRow('剧目名称', this.ocrResult.showName)
                this.ResultRow('演出日期', this.ocrResult.dateText)
                this.ResultRow('演出场馆', this.ocrResult.venueText)

                Row() {
                  Text('卡司阵容')
                    .fontSize(13)
                    .fontColor('#666E8A')
                    .width(72)
                  Row({ space: 6 }) {
                    ForEach(this.ocrResult.castList, (name: string) => {
                      Text(name)
                        .fontSize(13)
                        .fontColor('#FFFFFF')
                        .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                        .backgroundColor('#2A2A3E')
                        .borderRadius(8)
                    })
                  }
                }
                .width('100%')
                .alignItems(VerticalAlign.Center)
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#1A1A2E')
              .borderRadius(12)

              Column({ space: 8 }) {
                Text('原始识别文本')
                  .fontSize(13)
                  .fontColor('#666E8A')
                Text(this.ocrResult.rawText)
                  .fontSize(12)
                  .fontColor('#444A5E')
                  .width('100%')
                  .lineHeight(18)
              }
              .width('100%')
              .padding(14)
              .backgroundColor('#1A1A2E')
              .borderRadius(12)

              Button('确认入库')
                .width('100%')
                .height(48)
                .fontSize(16)
                .fontColor('#0D0D0D')
                .fontWeight(FontWeight.Bold)
                .backgroundColor('#D4A853')
                .borderRadius(24)
                .onClick(() => {
                  this.errorMsg = '信息已成功入库！感谢您的众包贡献。'
                })
            }
            .width('100%')
            .padding(16)
            .backgroundColor('rgba(52,199,89,0.06)')
            .borderRadius(12)
            .border({ width: 1, color: 'rgba(52,199,89,0.15)' })
          }

          if (this.errorMsg.length > 0) {
            Text(this.errorMsg)
              .fontSize(13)
              .fontColor('#34C759')
              .width('100%')
              .padding(14)
              .backgroundColor('rgba(52,199,89,0.08)')
              .borderRadius(12)
          }

          Column({ space: 8 }) {
            Text('Demo提示')
              .fontSize(13)
              .fontColor('#D4A853')
              .fontWeight(FontWeight.Medium)
            Text('点击下方按钮体验AI识别流程。')
              .fontSize(12)
              .fontColor('#444A5E')
              .lineHeight(18)

            Button('使用模拟数据演示')
              .fontSize(14)
              .fontColor('#0D0D0D')
              .fontWeight(FontWeight.Bold)
              .backgroundColor('#D4A853')
              .borderRadius(20)
              .margin({ top: 8 })
              .onClick(() => this.loadDemoData())
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#1A1A2E')
          .borderRadius(12)
        }
        .padding({ left: 16, right: 16, bottom: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0D0D0D')
  }

  @Builder
  ResultRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(13)
        .fontColor('#666E8A')
        .width(72)
      Text(value)
        .fontSize(14)
        .fontColor(value.length === 0 ? '#444A5E' : '#FFFFFF')
        .fontWeight(value.length === 0 ? FontWeight.Normal : FontWeight.Medium)
        .layoutWeight(1)
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  loadDemoData() {
    this.isProcessing = true
    this.errorMsg = ''
    this.ocrResult = null

    setTimeout(() => {
      let result: OcrResult = {
        rawText: '音乐剧《赵氏孤儿》\n演出时间：2026年8月15日 19:30\n演出地点：上海大剧院\n主演：郑云龙、阿云嘎、明道',
        showName: '《赵氏孤儿》',
        castList: ['郑云龙', '阿云嘎', '明道'],
        dateText: '2026年8月15日 19:30',
        venueText: '上海大剧院',
        confidence: 0.92,
        timestamp: Date.now()
      }
      this.ocrResult = result
      this.isProcessing = false
    }, 1500)
  }
}