part of 'pdf_bloc.dart';

class PdfState {
  final PdfStatus status;
  final String? pdfPath;
  final String? message;

  PdfState({required this.status, this.pdfPath,this.message});

  PdfState copyWith({
    PdfStatus? status,
    String? pdfPath,
    String? message,
  }) {
    return PdfState(
      status: status ?? this.status,
      pdfPath: pdfPath ?? this.pdfPath,
      message: message ?? this.message,
    );
  }
}

enum PdfStatus { initial, loading, success, error }
