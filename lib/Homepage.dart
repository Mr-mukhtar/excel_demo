import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ExcelTableScreen extends StatefulWidget {
  @override
  _ExcelTableScreenState createState() => _ExcelTableScreenState();
}

class _ExcelTableScreenState extends State<ExcelTableScreen> {
  late Excel _excel;

  Future<void> _pickAndParseExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      _excel = Excel.decodeBytes(file.readAsBytesSync());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Table'),
      ),
      body: _excel == null
          ? Center(
        child: ElevatedButton(
          onPressed: _pickAndParseExcel,
          child: Text('Pick and parse an Excel file'),
        ),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: _excel.tables.values.first.rows.first
              .map(
                (columnName) => DataColumn(label: Text(columnName)),
          )
              .toList(),
          rows: _excel.tables.values.first.rows
              .skip(1)
              .map(
                (excelRow) => DataRow(
              cells: excelRow.map((cellValue) => DataCell(Text(cellValue))).toList(),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}