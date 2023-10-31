アップロード日　
# アプリの紹介
ユーザーがタスクをCRUDでき、タスクが終わったらチェックボタンで完了することができるTodoアプリです。

## このアプリの作成経緯
Todoアプリを作る過程で開発に必要な基本的が技術が身につくということをネットで見て、作ってみようと思ったことが最初の動機です。
実はこのアプリはflutterを勉強して最初に作ったアプリでしたが、わからないところはコピペで間に合わせていたので「本当はここをこうしたいけど、どこ変えていいのかわからないからそのまま」のように自分が考えてる理想とは不本意な出来栄えだったので、全ての箇所をModifyして自分が欲しかったＴｏｄｏアプリを作ろうと思いました。

## 開発期間
２か月

## 開発技術・使用したPackage
Firebase Authentication
Firebase Firestore
あとで書く

## 工夫したところ
初めてリリースしたアプリはプリミティブにローカル上で全て動くアプリだったので、２個目は何か外部の機能を連携したいと考えていたのでflutterと親和性のあるFirebaseを使おうと決めました。
このアプリはCRUDとチェックマーク・入れ替えの機能があるのですが、この機能をどうやって説明しようか非常に悩みました。そこでアカウントを新規登録したと同時にリストを作成してそこに使い方の説明文を書いて使い方をしってもらうようにしました。

## 大変だったこと
長押しして並び替えをする機能を追加したのですがこの実装にほとんどの時間を費やしました。その大きな理由としてdartでforの書き方は理解してましたが、これをflutterでどこに書けばいいのかわからなかったこと・firebaseで並び替えを実装しているreferenceがなかったことと並び替えるロジックを実装するのが初めてだったため、実装するのに苦労しました。
解決する突破口となったのは所属しているコミュニティの方からfor文での流れをを説明してもらい、そのロジックの構築の仕方を頭の中でイメージできたらすぐ実装できました。

## うまくいったところ
1,並び替えですが、これも実際並び替えを行ってみるとfor文の関係でラグが起きてリストを実際に動かすと一旦動かす前に一瞬戻った後で並び替えをするのでこれもまだ最適解ではないのかなと思います。
2,このアプリを作ってる間にGitHubを勉強して一般的な使い方が理解できるようになったので作っている途中でしたがGitHubを使ってバージョン管理ができるようになりました。
3,広告実装。広告実装したけど本番IDを晒すのは良くないと思ったため

## できなかったところ
並び替えの機能は結果的に実装できましたが自分ひとりで実装できたわけではないため、まだまだ実装力が足りないと思いました。

## 反省・今後の課題
１,最初のアプリのパスワード画面をリベンジする形で実装しましたが、メールアドレスとパスワードをログインごとに入力するのはめんどくさいと思ったので、もっと違う方法のログイン認証にすればよかったなと思いました。
2,行き当たりばったりで作った。もっと最初に練ればよかった
