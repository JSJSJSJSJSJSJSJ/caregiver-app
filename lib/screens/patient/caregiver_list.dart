import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caregiver_app/firestore_data/search_list.dart';

class CaregiversList extends StatefulWidget {
  const CaregiversList({Key? key}) : super(key: key);

  @override
  State<CaregiversList> createState() => _CaregiversListState();
}

class _CaregiversListState extends State<CaregiversList> {
  final TextEditingController _textController = TextEditingController();
  late String search;
  var _length = 0;

  @override
  void initState() {
    super.initState();
    search = _textController.text;
    _length = search.length;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('查找护工'),
        actions: <Widget>[
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: '在这里输入.....',
                  hintStyle: GoogleFonts.lato(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  prefixStyle: TextStyle(
                    color: Colors.grey[300],
                  ),
                  suffixIcon: _textController.text.isNotEmpty
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              _textController.clear();
                              _length = search.length;
                            });
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 20,
                          ),
                        )
                      : const SizedBox(),
                ),
                // onFieldSubmitted: (String _searchKey) {
                //   setState(
                //     () {
                //       print('>>>' + _searchKey);
                //       search = _searchKey;
                //     },
                //   );
                // },
                onChanged: (String searchKey) {
                  setState(
                    () {
                      print('>>>$searchKey');
                      search = searchKey;
                      _length = search.length;
                    },
                  );
                },
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textInputAction: TextInputAction.search,
                autofocus: false,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: _length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _length = 1;
                        });
                      },
                      child: Text(
                        '显示所有护工',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Image(image: AssetImage('assets/images/search-bg.png')),
                  ],
                ),
              )
            : SearchList(
                searchKey: search,
              ),
      ),
    );
  }
}
