import 'package:fluffypawmobile/dependency_injection/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluffypawmobile/presentation/pages/home/home.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHomeData();
    });
  }

  Future<void> _loadHomeData() async {
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final watchState = ref.watch(homeViewModelProvider.notifier);

    try {
      await homeViewModel.loadPetOwnerDetail();

      // Đảm bảo rằng widget vẫn được mount trước khi chuyển trang
      if (homeViewModel.state.errorMessage == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Home()),
        );
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra khi tải dữ liệu: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/fluffypaw_logo.svg',
              width: 120,
              height: 120,
            ),
            SizedBox(height: 40),
            LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.pink,
              size: 60,
            ),
            SizedBox(height: 20),
            Text(
              'Đang tải dữ liệu...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}