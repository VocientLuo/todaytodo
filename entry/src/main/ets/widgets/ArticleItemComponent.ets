import router from '@ohos.router';
import TodoModel from '../db/TodoModel';
import { Article, ArticleTag, getArticleAuthor, getArticleChapter, getTagColor } from '../net/model/Article';

@Component
export struct ArticleItemComponent {
  article: TodoModel = new TodoModel();
  onCollectClick?: (article: Article) => void;

  build() {
    Column() {
      Text(this.article.text)
        .width('100%')
        .fontColor($r("app.color.text_h1"))
        .fontSize(15)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Divider()
        .width('100%')
        .height(5)
        .color(Color.Transparent)
      Row() {
        Text(this.article.modifyTime)
          .fontColor($r("app.color.text_h2"))
          .fontSize(12)
        Blank()
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
    }
    .width('100%')
    .padding({
      left: 16,
      top: 10,
      right: 16,
      bottom: 10
    })
  }
}