class Variable {
  // 他からインスタンス作成不可をする記述
  Variable._();

  // クラス内にこのクラスのインスタンスを生成
  static final instance = Variable._();

  // グローバルとして使う変数
}
