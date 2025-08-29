import 'dart:io';
import 'package:employee/consts/colors.dart';
import 'package:employee/core/models/response/PaystubModel.dart';
import 'package:employee/views/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart';

class PaystubDialog extends StatelessWidget {
  final PaystubResult paystub;

  const PaystubDialog({
    super.key,
    required this.paystub,
  });

  Future<void> _downloadPdf(BuildContext context) async {
    final pdf = pw.Document();
    final logo = await rootBundle.load('assets/logo/logo.png');
    final image = pw.MemoryImage(logo.buffer.asUint8List());
    final result = paystub;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey600, width: 1.2),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            padding: const pw.EdgeInsets.all(18),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                // Header: Logo and Employer Details
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(image, height: 40),
                    pw.Text('Employer Details',
                        style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.blue900,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(result.companyName ?? '',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(result.companyAddress ?? '',
                            style: pw.TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 14),
                // Section: Personal and Check Information
                _pdfSectionHeader('Personal and Check Information'),
                _pdfTable([
                  _pdfTableRow('Name', result.employeeName ?? ''),
                  _pdfTableRow('Address', result.address ?? ''),
                  _pdfTableRow('SSN#', result.socialSecurity ?? ''),
                  _pdfTableRow('Employee Id', result.id?.toString() ?? '-'),
                  _pdfTableRow('Pay Period', result.payPeriod ?? ''),
                  _pdfTableRow('Account #', result.ssn ?? '-'),
                  _pdfTableRow('Payment Method', result.paymentMethod ?? ''),
                  _pdfTableRow('Tax Status', result.federalFillingStatus ?? ''),
                ], evenRowColor: PdfColors.grey100),
                pw.SizedBox(height: 14),
                // Section: Earning
                _pdfSectionHeader('Earning'),
                _pdfTable([
                  _pdfTableRow(
                      'Basis of Description Pay',
                      result.earningtList?.isNotEmpty == true
                          ? result.earningtList![0]['elementName'] ?? ''
                          : ''),
                  _pdfTableRow(
                      'Hrs/Units',
                      result.earningtList?.isNotEmpty == true
                          ? result.earningtList![0]['value']?.toString() ?? ''
                          : ''),
                  _pdfTableRow('Rate', ''),
                  _pdfTableRow('YTD/Hours', ''),
                  _pdfTableRow(
                      'YTD(24)',
                      result.ytdList?.isNotEmpty == true
                          ? result.ytdList![0]['value']?.toString() ?? ''
                          : ''),
                ], evenRowColor: PdfColors.grey100),
                pw.SizedBox(height: 14),
                // Section: Withholding
                _pdfSectionHeader('Withholding'),
                _pdfTable([
                  _pdfTableRow4([
                    'Description',
                    'Filing Status',
                    'This Period(24)',
                    'YTD(24)'
                  ], isHeader: true),
                  ..._pdfWithholdingRows(result),
                ],
                    evenRowColor: PdfColors.grey100,
                    headerColor: PdfColors.grey300,
                    isFourCol: true),
                pw.SizedBox(height: 14),
                // Section: Net Pay Allocation
                _pdfSectionHeader('NET PAY ALLOCATION'),
                _pdfTable([
                  _pdfTableRow3(['Description', 'This Period(24)', 'YTD(24)'],
                      isHeader: true),
                  _pdfNetPayRow(
                      'Check Amount',
                      result.netPay ?? '',
                      result.ytdList?.isNotEmpty == true
                          ? result.ytdList![0]['value']?.toString() ?? ''
                          : ''),
                  _pdfNetPayRow(
                      'Net Pay',
                      result.netPay ?? '',
                      result.ytdList?.isNotEmpty == true
                          ? result.ytdList![0]['value']?.toString() ?? ''
                          : '',
                      isTotal: true),
                ],
                    evenRowColor: PdfColors.grey100,
                    headerColor: PdfColors.grey300,
                    isThreeCol: true),
              ],
            ),
          );
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/paystub.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  // PDF helpers
  pw.Widget _pdfSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      color: PdfColors.indigo900,
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  pw.Widget _pdfTable(List<pw.TableRow> rows,
      {PdfColor? evenRowColor,
      PdfColor? headerColor,
      bool isFourCol = false,
      bool isThreeCol = false}) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: isFourCol
          ? {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
            }
          : isThreeCol
              ? {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                }
              : {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(3),
                },
      children: rows,
    );
  }

  pw.TableRow _pdfTableRow(String left, String right,
      {bool isHeader = false, bool isEven = false}) {
    return pw.TableRow(
      decoration: isHeader
          ? const pw.BoxDecoration(color: PdfColors.grey300)
          : isEven
              ? const pw.BoxDecoration(color: PdfColors.grey100)
              : null,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            left,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            right,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  pw.TableRow _pdfTableRow4(List<String> cells,
      {bool isHeader = false, bool isEven = false}) {
    return pw.TableRow(
      decoration: isHeader
          ? pw.BoxDecoration(color: PdfColors.grey300)
          : isEven
              ? pw.BoxDecoration(color: PdfColors.grey100)
              : null,
      children: List.generate(4, (i) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            cells[i],
            textAlign: i > 1 ? pw.TextAlign.right : pw.TextAlign.left,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 12,
            ),
          ),
        );
      }),
    );
  }

  pw.TableRow _pdfTableRow3(List<String> cells,
      {bool isHeader = false, bool isEven = false}) {
    return pw.TableRow(
      decoration: isHeader
          ? pw.BoxDecoration(color: PdfColors.grey300)
          : isEven
              ? const pw.BoxDecoration(color: PdfColors.grey100)
              : null,
      children: List.generate(3, (i) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            cells[i],
            textAlign: i > 0 ? pw.TextAlign.right : pw.TextAlign.left,
            style: pw.TextStyle(
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              fontSize: 12,
            ),
          ),
        );
      }),
    );
  }

  List<pw.TableRow> _pdfWithholdingRows(PaystubResult result) {
    final deductions =
        (result.deductionList ?? []).cast<Map<String, dynamic>>();
    List<pw.TableRow> rows = [];
    for (int i = 0; i < deductions.length; i++) {
      final d = deductions[i];
      rows.add(_pdfTableRow4([
        d['elementName'] ?? '',
        '',
        d['value']?.toString() ?? '',
        d['ytd']?.toString() ?? '',
      ], isEven: i % 2 == 1));
    }
    // Add TOTAL row
    rows.add(_pdfTableRow4([
      'TOTAL',
      '',
      _pdfSumColumn(deductions, 'value'),
      _pdfSumColumn(deductions, 'ytd'),
    ], isHeader: true));
    return rows;
  }

  pw.TableRow _pdfNetPayRow(String desc, String period, String ytd,
      {bool isTotal = false}) {
    return _pdfTableRow3([
      desc,
      period,
      ytd,
    ], isHeader: isTotal);
  }

  String _pdfSumColumn(List<Map<String, dynamic>> list, String key) {
    double sum = 0;
    for (var item in list) {
      final val = double.tryParse(item[key]?.toString() ?? '0') ?? 0;
      sum += val;
    }
    return sum.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final result = paystub;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Logo and Close Button
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    height: 40,
                  ),
                  IconButton(
                    icon: Container(
                        padding: EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            color: AppColors.redColor, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 18,
                        )),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Employer Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Employer Details',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text(result.companyName ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(result.companyAddress ?? '',
                          style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            // Section: Personal and Check Information
            _sectionHeader('Personal and Check Information'),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                _tableRow('Name', result.employeeName ?? ''),
                _tableRow('Address', result.address ?? ''),
                _tableRow('SSN#', result.socialSecurity ?? ''),
                _tableRow('Employee Id', result.id?.toString() ?? '-'),
                _tableRow('Pay Period', result.payPeriod ?? ''),
                _tableRow('Account #', result.ssn ?? '-'),
                _tableRow('Payment Method', result.paymentMethod ?? ''),
                _tableRow('Tax Status', result.federalFillingStatus ?? ''),
              ],
            ),
            // Section: Earning
            _sectionHeader('Earning'),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                _tableRow(
                    'Basis of Description Pay',
                    result.earningtList?.isNotEmpty == true
                        ? result.earningtList![0]['elementName'] ?? ''
                        : ''),
                _tableRow(
                    'Hrs/Units',
                    result.earningtList?.isNotEmpty == true
                        ? result.earningtList![0]['value']?.toString() ?? ''
                        : ''),
                _tableRow('Rate', ''),
                _tableRow('YTD/Hours', ''),
                _tableRow(
                    'YTD(24)',
                    result.ytdList?.isNotEmpty == true
                        ? result.ytdList![0]['value']?.toString() ?? ''
                        : ''),
              ],
            ),
            // Section: Withholding
            _sectionHeader('Withholding'),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    _tableCell('Description', bold: true),
                    _tableCell('Filing Status', bold: true),
                    _tableCell('This Period(24)', bold: true),
                    _tableCell('YTD(24)', bold: true),
                  ],
                ),
                ..._withholdingRows(result),
              ],
            ),
            // Section: Net Pay Allocation
            _sectionHeader('NET PAY ALLOCATION'),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    _tableCell('Description', bold: true),
                    _tableCell('This Period(24)', bold: true),
                    _tableCell('YTD(24)', bold: true),
                  ],
                ),
                _netPayRow(
                    'Check Amount',
                    result.netPay ?? '',
                    result.ytdList?.isNotEmpty == true
                        ? result.ytdList![0]['value']?.toString() ?? ''
                        : ''),
                _netPayRow(
                    'Net Pay',
                    result.netPay ?? '',
                    result.ytdList?.isNotEmpty == true
                        ? result.ytdList![0]['value']?.toString() ?? ''
                        : ''),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _downloadPdf(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                ),
                child: Text(
                  'Download PDF',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: Colors.blue[900],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  TableRow _tableRow(String left, String right) {
    return TableRow(
      children: [
        _tableCell(left),
        _tableCell(right),
      ],
    );
  }

  Widget _tableCell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }

  List<TableRow> _withholdingRows(PaystubResult result) {
    final deductions = result.deductionList ?? [];
    List<TableRow> rows = [];
    for (var d in deductions) {
      rows.add(TableRow(
        children: [
          _tableCell(d['elementName'] ?? ''),
          _tableCell(''),
          _tableCell(d['value']?.toString() ?? ''),
          _tableCell(d['ytd']?.toString() ?? ''),
        ],
      ));
    }
    // Add TOTAL row
    rows.add(TableRow(
      decoration: BoxDecoration(color: Colors.grey[100]),
      children: [
        _tableCell('TOTAL', bold: true),
        _tableCell(''),
        _tableCell(_sumColumn(deductions, 'value'), bold: true),
        _tableCell(_sumColumn(deductions, 'ytd'), bold: true),
      ],
    ));
    return rows;
  }

  TableRow _netPayRow(String desc, String period, String ytd) {
    return TableRow(
      children: [
        _tableCell(desc),
        _tableCell(period),
        _tableCell(ytd),
      ],
    );
  }

  String _sumColumn(List<dynamic> list, String key) {
    double sum = 0;
    for (var item in list) {
      if (item is Map<String, dynamic>) {
        final val = double.tryParse(item[key]?.toString() ?? '0') ?? 0;
        sum += val;
      }
    }
    return sum.toStringAsFixed(2);
  }
}
