import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Model {
  // 他からインスタンス作成不可をする記述
  Model._();

  // クラス内にこのクラスのインスタンスを生成
  static final instance = Model._();

  // 変数一覧
  // main pageのみ
  String mailAddress = "example@gmail.com"; //この２個はアプリ登録する時に''にしていること
  String password = "aaaaaa";

  // registrasion pageのみ
  String mailAddressRegistration = "";
  String passwordRegistration = "";
  String passwordCheckRegistration = "";

  String makeRandomId(User user) {
    // 個々のuid内でランダムIDを生成し、戻り値をStringとして返す
    return FirebaseFirestore.instance.collection(user.uid).doc().id;
  }

  // todo page
  String newItem = "";
  // 全てにまたがっているもの
  final db = FirebaseFirestore.instance;
}
