// ignore_for_file: unnecessary_null_comparison

import 'dart:core';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sse/model/entity/info_login.dart';
import 'package:sse/utils/log.dart';
import 'package:sqflite/sqflite.dart';

import '../entity/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get db async {
    // ignore: unnecessary_null_comparison
    if (_database != null) {
      return _database!;
    }
    _database = await init();
    return _database!;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE infoLogin(
      code TEXT,
      name TEXT,
      hot TEXT,
      id TEXT,
      pass TEXT)
  ''');
    print("Database InfoLogin was created!");
    db.execute('''
    CREATE TABLE product(
      code TEXT,
      name TEXT,
      name2 TEXT,
      dvt TEXT,
      description TEXT,
      price REAL,
      discountPercent REAL,
      priceAfter REAL,
      stockAmount REAL,
      taxPercent REAL,
      imageUrl TEXT,
      count REAL,
      discountMoney TEXT,
      discountProduct TEXT,
      budgetForItem TEXT,
      budgetForProduct TEXT,
      residualValueProduct REAL,
      residualValue REAL,
      unit TEXT,
      unitProduct TEXT,
      isMark INT,
      dsCKLineItem TEXT)
  ''');
    print("Database Production was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
    logger.i(
      "Migration: $oldVersion, $newVersion",
    );
    if (oldVersion == 1 && newVersion == 2) {
      db.execute('ALTER TABLE product ADD COLUMN attributes TEXT');
      db.delete("product");
    }
    db.execute('DROP TABLE IF EXISTS product');
    db.delete("product");
    if (oldVersion == 1 && newVersion == 2) {
      db.execute('ALTER TABLE infoLogin ADD COLUMN attributes TEXT');
      db.delete("infoLogin");
    }
    db.execute('DROP TABLE IF EXISTS infoLogin');
    db.delete("infoLogin");
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = p.join(directory.toString(), 'database.db');
    var database = openDatabase(dbPath,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return database;
  }

  ///InfoLogin

  Future<void> addInfoLogin(InfoLogin infoLogin) async {
    var client = await db;
    InfoLogin? oldLang = await fetchInfoLogin(infoLogin.code);
    if (oldLang == null)
      await client.insert('infoLogin', infoLogin.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      await updateInfoLogin(oldLang);
    }
  }

  Future<InfoLogin?> fetchInfoLogin(String code) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('infoLogin', where: 'code = ?', whereArgs: [code]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return InfoLogin.fromDb(maps.first);
    }
    return null;
  }

  Future<List<InfoLogin>> fetchAllInfoLogin() async {
    var client = await db;
    var res = await client.query('infoLogin');
    if (res.isNotEmpty) {
      var infoLogin =
          res.map((infoLoginMap) => InfoLogin.fromDb(infoLoginMap)).toList();
      return infoLogin;
    }
    return [];
  }

  Future<List<InfoLogin>> getInfoLogin() async {
    var client = await db;
    var res = await client.query('infoLogin',);
    if (res.isNotEmpty) {
      var infoLogin =
          res.map((infoLoginMap) => InfoLogin.fromDb(infoLoginMap)).toList();
      return infoLogin;
    }
    return [];
  }

  Future<void> deleteInfoLogin(InfoLogin infoLogin) async {
    var client = await db;
    await client.delete('infoLogin', where: 'code = ?', whereArgs: [infoLogin.code]);
  }

  Future<int> updateInfoLogin(InfoLogin infoLogin) async {
    var client = await db;
    return client.update('infoLogin', infoLogin.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Future<int>> removeInfoLogin(int id) async {
    var client = await db;
    return client.delete('infoLogin', where: 'id = ?', whereArgs: [id]);
  }

  ///Product
  Future<void> addProduct(Product product) async {
    var client = await db;
    Product? oldProduct = await fetchProduct(product.code.toString());
    if (oldProduct == null)
      await client.insert('product', product.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    else {
      oldProduct.count = product.count!;//oldProduct.count! + product.count!;
      await updateProduct(oldProduct);
    }
  }

  Future<void> decreaseProduct(Product product) async {
    if (product.count! > 1) {
      product.count = product.count! - 1;
      updateProduct(product);
    }
  }

  Future<void> increaseProduct(Product product) async {
    product.count = product.count! + 1;
    updateProduct(product);
  }

  Future<Product?> fetchProduct(String code) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps =
    client.query('product', where: 'code = ?', whereArgs: [code]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return Product.fromDb(maps.first);
    }
    return null;
  }

  Future<void> deleteAllProduct() async {
    var client = await db;
    await client.delete('product');
  }

  Future<List<Product>> fetchAllProduct() async {
    var client = await db;
    var res = await client.query('product');

    if (res.isNotEmpty) {
      var products =
      res.map((productMap) => Product.fromDb(productMap)).toList();
      return products;
    }
    return [];
  }

  Future<List<Product>> getAllProductSelected() async {
    var client = await db;
    var res =
    await client.query('product', where: 'ismark = ?', whereArgs: [1]);

    if (res.isNotEmpty) {
      var products =
      res.map((productMap) => Product.fromDb(productMap)).toList();
      return products;
    }
    return [];
  }

  Future<void> deleteProductSelected() async {
    var client = await db;
    await client.delete('product', where: 'ismark = ?', whereArgs: [1]);
  }

  Future<int> updateProduct(Product pr) async {
    var client = await db;
    return client.update('product', pr.toMapForDb(),
        where: 'code = ?',
        whereArgs: [pr.code],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Future<int>> removeProduct(String code) async {
    var client = await db;
    return client.delete('product', where: 'code = ?', whereArgs: [code]);
  }

  Future<List<Map<String, dynamic>>> countProduct({ Database? database}) async {
    var client = database ?? await db;
    return client.rawQuery('SELECT COUNT (code) FROM product', null);
  }

  Future<int> getCountProduct({Database? database}) async {
    var client = database ?? await db;
    var countDb = await countProduct(database: client);
    if (countDb == null) return 0;
    return countDb[0]['COUNT (id)'];
  }

  Future closeDb() async {
    var client = await db;
    client.close();
  }
}
