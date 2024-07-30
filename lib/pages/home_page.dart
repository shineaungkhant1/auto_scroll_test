import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../blocs/pdf_bloc/pdf_bloc.dart';


class PDFViewerPage extends StatelessWidget {
  const PDFViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfBloc()..add(LoadPdf()),
      child: const PDFViewerBody(),
    );
  }
}

class PDFViewerBody extends StatelessWidget {
  const PDFViewerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: BlocBuilder<PdfBloc, PdfState>(
        builder: (context, state) {
          if (state.status == PdfStatus.loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == PdfStatus.success) {
            return PDFView(filePath: state.pdfPath!);
          } else if (state.status == PdfStatus.error) {
            return Center(child: Text('Failed to load PDF'));
          } else {
            return Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
}
