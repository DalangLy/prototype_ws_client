import 'dart:convert';

class PrintTemplateModel {
  PrintTemplateModel({
    this.requestType,
    this.printMeta,
  });

  final String? requestType;
  final PrintMeta? printMeta;

  factory PrintTemplateModel.fromJson(String str) => PrintTemplateModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrintTemplateModel.fromMap(Map<String, dynamic> json) => PrintTemplateModel(
    requestType: json["requestType"] == null ? null : json["requestType"],
    printMeta: json["printMeta"] == null ? null : PrintMeta.fromMap(json["printMeta"]),
  );

  Map<String, dynamic> toMap() => {
    "requestType": requestType == null ? null : requestType,
    "printMeta": printMeta == null ? null : printMeta?.toMap(),
  };
}

class PrintMeta {
  PrintMeta({
    this.printerName,
    this.printMethod,
    this.printTemplate,
  });

  final String? printerName;
  final String? printMethod;
  final PrintTemplate? printTemplate;

  factory PrintMeta.fromJson(String str) => PrintMeta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrintMeta.fromMap(Map<String, dynamic> json) => PrintMeta(
    printerName: json["printerName"] == null ? null : json["printerName"],
    printMethod: json["printMethod"] == null ? null : json["printMethod"],
    printTemplate: json["printTemplate"] == null ? null : PrintTemplate.fromMap(json["printTemplate"]),
  );

  Map<String, dynamic> toMap() => {
    "printerName": printerName == null ? null : printerName,
    "printMethod": printMethod == null ? null : printMethod,
    "printTemplate": printTemplate == null ? null : printTemplate?.toMap(),
  };
}

class PrintTemplate {
  PrintTemplate({
    this.printTemplateLayout,
  });

  final PrintTemplateLayout? printTemplateLayout;

  factory PrintTemplate.fromJson(String str) => PrintTemplate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrintTemplate.fromMap(Map<String, dynamic> json) => PrintTemplate(
    printTemplateLayout: json["printTemplateLayout"] == null ? null : PrintTemplateLayout.fromMap(json["printTemplateLayout"]),
  );

  Map<String, dynamic> toMap() => {
    "printTemplateLayout": printTemplateLayout == null ? null : printTemplateLayout?.toMap(),
  };
}

class PrintTemplateLayout {
  PrintTemplateLayout({
    this.rows = const [],
  });

  final List<RowElement> rows;

  factory PrintTemplateLayout.fromJson(String str) => PrintTemplateLayout.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrintTemplateLayout.fromMap(Map<String, dynamic> json) => PrintTemplateLayout(
    rows: List<RowElement>.from(json["rows"].map((x) => RowElement.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "rows": rows == null ? null : List<dynamic>.from(rows.map((x) => x.toMap())),
  };
}

class RowElement {
  RowElement({
    this.row,
  });

  final RowRow? row;

  factory RowElement.fromJson(String str) => RowElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RowElement.fromMap(Map<String, dynamic> json) => RowElement(
    row: json["row"] == null ? null : RowRow.fromMap(json["row"]),
  );

  Map<String, dynamic> toMap() => {
    "row": row == null ? null : row!.toMap(),
  };
}

class RowRow {
  RowRow({
    this.rowBorderTop = 0,
    this.rowBorderRight = 0,
    this.rowBorderBottom = 0,
    this.rowBorderLeft = 0,
    this.rowBackground = "transparent",
    this.columns = const [],
  });

  final int rowBorderTop;
  final int rowBorderRight;
  final int rowBorderBottom;
  final int rowBorderLeft;
  final String rowBackground;
  final List<ColumnElement> columns;

  factory RowRow.fromJson(String str) => RowRow.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RowRow.fromMap(Map<String, dynamic> json) => RowRow(
    rowBorderTop: json["rowBorderTop"] == null ? null : json["rowBorderTop"],
    rowBorderRight: json["rowBorderRight"] == null ? null : json["rowBorderRight"],
    rowBorderBottom: json["rowBorderBottom"] == null ? null : json["rowBorderBottom"],
    rowBorderLeft: json["rowBorderLeft"] == null ? null : json["rowBorderLeft"],
    rowBackground: json["rowBackground"] == null ? null : json["rowBackground"],
    columns: List<ColumnElement>.from(json["columns"].map((x) => ColumnElement.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "rowBorderTop": rowBorderTop == null ? null : rowBorderTop,
    "rowBorderRight": rowBorderRight == null ? null : rowBorderRight,
    "rowBorderBottom": rowBorderBottom == null ? null : rowBorderBottom,
    "rowBorderLeft": rowBorderLeft == null ? null : rowBorderLeft,
    "rowBackground": rowBackground == null ? null : rowBackground,
    "columns": columns == null ? null : List<dynamic>.from(columns.map((x) => x.toMap())),
  };
}

class ColumnElement {
  ColumnElement({
    this.column,
  });

  final ColumnColumn? column;

  factory ColumnElement.fromJson(String str) => ColumnElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ColumnElement.fromMap(Map<String, dynamic> json) => ColumnElement(
    column: json["column"] == null ? null : ColumnColumn.fromMap(json["column"]),
  );

  Map<String, dynamic> toMap() => {
    "column": column == null ? null : column?.toMap(),
  };
}

class ColumnColumn {
  ColumnColumn({
    this.content = "",
    this.rowSpan = 1,
    this.columnWidth = 0,
    this.columnBorderTop = 0,
    this.columnBorderRight = 0,
    this.columnBorderBottom = 0,
    this.columnBorderLeft = 0,
  });

  final String content;
  final int rowSpan;
  final int columnWidth;
  final int columnBorderTop;
  final int columnBorderRight;
  final int columnBorderBottom;
  final int columnBorderLeft;

  factory ColumnColumn.fromJson(String str) => ColumnColumn.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ColumnColumn.fromMap(Map<String, dynamic> json) => ColumnColumn(
    content: json["content"] == null ? null : json["content"],
    rowSpan: json["rowSpan"] == null ? null : json["rowSpan"],
    columnWidth: json["columnWidth"] == null ? null : json["columnWidth"],
    columnBorderTop: json["columnBorderTop"] == null ? null : json["columnBorderTop"],
    columnBorderRight: json["columnBorderRight"] == null ? null : json["columnBorderRight"],
    columnBorderBottom: json["columnBorderBottom"] == null ? null : json["columnBorderBottom"],
    columnBorderLeft: json["columnBorderLeft"] == null ? null : json["columnBorderLeft"],
  );

  Map<String, dynamic> toMap() => {
    "content": content == null ? null : content,
    "rowSpan": rowSpan == null ? null : rowSpan,
    "columnWidth": columnWidth == null ? null : columnWidth,
    "columnBorderTop": columnBorderTop == null ? null : columnBorderTop,
    "columnBorderRight": columnBorderRight == null ? null : columnBorderRight,
    "columnBorderBottom": columnBorderBottom == null ? null : columnBorderBottom,
    "columnBorderLeft": columnBorderLeft == null ? null : columnBorderLeft,
  };
}
