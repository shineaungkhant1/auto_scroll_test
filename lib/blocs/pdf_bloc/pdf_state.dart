part of 'pdf_bloc.dart';

class PdfState {
  final PdfStatus status;
  final String? pdfPath;

  PdfState({required this.status, this.pdfPath});

  PdfState copyWith({
    PdfStatus? status,
    String? pdfPath,
  }) {
    return PdfState(
      status: status ?? this.status,
      pdfPath: pdfPath ?? this.pdfPath,
    );
  }
}

enum PdfStatus { initial, loading, success, error }
