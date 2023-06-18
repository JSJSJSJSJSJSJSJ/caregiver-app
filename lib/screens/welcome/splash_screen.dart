import 'package:caregiver_app/screens/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class SplashModel{
  String _img;

  SplashModel(this._img);

  String get img=>_img;
}

class SplashModelList{
  static List<SplashModel> getSplashList(){
    return[
      SplashModel('assets/images/care-1.png'),
      SplashModel('assets/images/care-2.png'),
      SplashModel('assets/images/care-3.png'),
    ];
  }
}

class _SplashScreenState extends State<SplashScreen> {
  late double _height;
  late double _width;

  int currentPageValue = 0;

  late PageController controller;

  late List<SplashModel> splashModel;

  @override
  void initState() {
    splashModel = SplashModelList.getSplashList();

    currentPageValue = 0;

    controller = PageController(initialPage: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '护 工',
          style: TextStyle(
              fontFamily: 'Roboto Medium', fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff1c70df),
        elevation: 0.0,
      ),
      body: Container(
        height: _height,
        width: _width,
        color: const Color(0xff1c70df),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: splashModel.length,
                  onPageChanged: (int page) {
                    getChangedPageAndMoveBar(page);
                  },
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSplashList(splashModel[index], index);
                  }),
            ),
            Expanded(
              child: Visibility(
                visible:
                currentPageValue == splashModel.length ? false : true,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < splashModel.length; i++)
                            if (i == currentPageValue) ...[
                              circleBar(true)
                            ] else
                              circleBar(false),
                        ],
                      ),
                      Visibility(
                        visible: currentPageValue == splashModel.length-1 ? false : true,
                        child:Expanded(child:Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          // color:Colors.red,
                          child: const Text(
                            '为您找到细致合适的专业护理',
                            style: TextStyle(
                                fontFamily: 'Roboto Regular',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5,
                                height: 1.4),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1.3,
                          ),
                        ),),
                      ),

                      Visibility(
                        visible: currentPageValue == splashModel.length-1 ? false : true,
                        child: Expanded(child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor:const Color(0xff1c70df).withOpacity(1.0),
                              child: InkWell(
                                onTap: () {
                                  int page = currentPageValue - 1;
                                  controller.animateToPage(page,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeOut);
                                  currentPageValue = page;
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            CircleAvatar(
                              backgroundColor: const Color(0xff1c70df).withOpacity(1.0),
                              child: InkWell(
                                onTap: () {
                                  int page = currentPageValue + 1;
                                  controller.animateToPage(page,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeOut);
                                  currentPageValue = page;
                                },
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),),
                      ),

                      Visibility(
                        visible: currentPageValue == splashModel.length - 1 ? true : false,
                        child:ButtonTheme(
                          minWidth: _width,
                          height: _height / 16,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1c70df).withOpacity(1.0),),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const FireBaseAuth()));
                            },
                            child: const Text(
                              '跳转主页面',
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: 16.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: isActive ? 8 : 8,
      width: isActive ? 8 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.indigo[100]?.withOpacity(1.0),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget _buildSplashList(SplashModel items, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: 0.4,
              child: ClipOval(
                child: Container(
                  alignment: Alignment.center,
                  height: _height / 4.5,
                  width: _width / 1.2,
                  color: const Color(0xff1c70df).withOpacity(1.0),
                ),
                // clipper:TopWaveClipper(),
              ),
            ),
          ),
          Align(
            // alignment: Alignment.center,
            child: Image.asset(
              items.img,
              fit: BoxFit.fitHeight,
              height: _height / 2.7,
            ),
          ),
        ],
      ),
    );
  }
}