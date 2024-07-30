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

class PDFViewerBody extends StatefulWidget {
  const PDFViewerBody({super.key});

  @override
  _PDFViewerBodyState createState() => _PDFViewerBodyState();
}

class _PDFViewerBodyState extends State<PDFViewerBody> {
  int? _totalPages;
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: BlocBuilder<PdfBloc, PdfState>(
        builder: (context, state) {
          if (state.status == PdfStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == PdfStatus.success) {
            return Column(
              children: [
                Expanded(
                  child: PDFView(
                    filePath: state.pdfPath!,
                    onViewCreated: (PDFViewController pdfViewController) {
                      _pdfViewController = pdfViewController;
                      _pdfViewController!.getPageCount().then((count) {
                        setState(() {
                          _totalPages = count;
                        });
                      });
                    },
                    onRender: (_pages) {
                      setState(() {
                        _totalPages = _pages;
                      });
                    },
                  ),
                ),
                if (_totalPages != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Total Pages: $_totalPages'),
                  ),
              ],
            );
          } else if (state.status == PdfStatus.error) {
            return Center(child: Text("${state.message}"));
          } else {
            return const Center(child: Text('Loading...'));
          }
        },
      ),
    );
  }
}
