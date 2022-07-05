import 'dart:convert';

class PrintModel {
  PrintModel({
    required this.code,
    required this.printMeta,
  });

  final String code;
  final PrintMeta printMeta;

  factory PrintModel.fromJson(String str) => PrintModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrintModel.fromMap(Map<String, dynamic> json) => PrintModel(
    code: json["code"],
    printMeta: PrintMeta.fromMap(json["printMeta"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "printMeta": printMeta.toMap(),
  };
}

class PrintMeta {
  PrintMeta({
    required this.printMethod,
    required this.printerName,
    required this.printData,
  });

  final String printMethod;
  final String printerName;
  final List<PrintDatum> printData;

  factory PrintMeta.fromJson(String str) => PrintMeta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrintMeta.fromMap(Map<String, dynamic> json) => PrintMeta(
    printMethod: json["printMethod"],
    printerName: json["printerName"],
    printData: List<PrintDatum>.from(json["printData"].map((x) => PrintDatum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "printMethod": printMethod,
    "printerName": printerName,
    "printData": List<dynamic>.from(printData.map((x) => x.toMap())),
  };
}

class PrintDatum {
  PrintDatum({
    required this.header,
    required this.body,
  });

  final Header header;
  final Body body;

  factory PrintDatum.fromJson(String str) => PrintDatum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrintDatum.fromMap(Map<String, dynamic> json) => PrintDatum(
    header: Header.fromMap(json["Header"]),
    body: Body.fromMap(json["Body"]),
  );

  Map<String, dynamic> toMap() => {
    "Header": header.toMap(),
    "Body": body.toMap(),
  };
}

class Body {
  Body({
    required this.bodyRows,
  });

  final List<BodyRow> bodyRows;

  factory Body.fromJson(String str) => Body.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Body.fromMap(Map<String, dynamic> json) => Body(
    bodyRows: List<BodyRow>.from(json["BodyRows"].map((x) => BodyRow.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "BodyRows": List<dynamic>.from(bodyRows.map((x) => x.toMap())),
  };
}

class BodyRow {
  BodyRow({
    required this.bodyColumns,
  });

  final List<BodyColumn> bodyColumns;

  factory BodyRow.fromJson(String str) => BodyRow.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BodyRow.fromMap(Map<String, dynamic> json) => BodyRow(
    bodyColumns: List<BodyColumn>.from(json["BodyColumns"].map((x) => BodyColumn.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "BodyColumns": List<dynamic>.from(bodyColumns.map((x) => x.toMap())),
  };
}

class BodyColumn {
  BodyColumn({
    required this.text,
    required this.align,
    required this.bold,
  });

  final String text;
  final String align;
  final bool bold;

  factory BodyColumn.fromJson(String str) => BodyColumn.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BodyColumn.fromMap(Map<String, dynamic> json) => BodyColumn(
    text: json["Text"],
    align: json["Align"],
    bold: json["Bold"],
  );

  Map<String, dynamic> toMap() => {
    "Text": text,
    "Align": align,
    "Bold": bold,
  };
}

class Header {
  Header({
    required this.background,
    required this.text,
    required this.foreground,
    required this.align,
    required this.bold,
  });

  final String background;
  final String text;
  final String foreground;
  final String align;
  final bool bold;

  factory Header.fromJson(String str) => Header.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Header.fromMap(Map<String, dynamic> json) => Header(
    background: json["Background"],
    text: json["Text"],
    foreground: json["Foreground"],
    align: json["Align"],
    bold: json["Bold"],
  );

  Map<String, dynamic> toMap() => {
    "Background": background,
    "Text": text,
    "Foreground": foreground,
    "Align": align,
    "Bold": bold,
  };
}
