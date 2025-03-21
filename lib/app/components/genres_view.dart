import 'package:flutter/material.dart';
import 'package:mm_book/app/models/book_genres_model.dart';
import 'package:mm_book/app/services/m_m_book_services.dart';
import 'package:mm_book/app/widgets/index.dart';

class GenresView extends StatefulWidget {
  void Function(BookGenresModel genres) onClicked;
  GenresView({super.key, required this.onClicked});

  @override
  State<GenresView> createState() => _GenresViewState();
}

class _GenresViewState extends State<GenresView> {
  @override
  void initState() {
    super.initState();
    init();
  }

  List<BookGenresModel> list = [];
  bool isLoading = false;

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      list = await MMBookServices.instance.getGenresList();

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text(
              'Genres && အမျိုးအစားများ',
              style: TextTheme.of(context).bodyLarge,
            ),
            isLoading
                ? TLoader()
                : Wrap(
                    spacing: 7,
                    runSpacing: 5,
                    children: List.generate(
                      list.length,
                      (index) {
                        final genres = list[index];
                        return TChip(
                          title: genres.title,
                          onClick: () => widget.onClicked(genres),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
