import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'pdf_event.dart';
part 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  PdfBloc() : super(PdfState(status: PdfStatus.initial)) {
    on<LoadPdf>(_loadPdf);
  }

  Future<void> _loadPdf(
      LoadPdf event,
      Emitter<PdfState> emit,
      ) async {
    emit(state.copyWith(status: PdfStatus.loading));
    try {
      final ByteData data = await rootBundle.load('assets/pdf/Be_Your_Future_Self_Now.pdf');
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/Be_Your_Future_Self_Now.pdf');
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
      emit(state.copyWith(status: PdfStatus.success, pdfPath: tempFile.path));
    } catch (e) {
      emit(state.copyWith(status: PdfStatus.error,message: e.toString()));
    }
  }
}
