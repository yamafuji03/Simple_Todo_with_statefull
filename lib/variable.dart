class Variable {
  // 他からインスタンス作成不可をする記述
  Variable._();

  // クラス内にこのクラスのインスタンスを生成
  static final instance = Variable._();

  // 変数一覧
  // main pageのみ
  String mailAddress = "example@gmail.com"; //この２個はアプリ登録する時に''にしていること
  String password = "aaaaaa";

  // registrasion pageのみ
  String mailAddressRegistration = "";
  String passwordRegistration = "";
  String passwordCheckRegistration = "";

  // 全てにまたがっているもの
}
