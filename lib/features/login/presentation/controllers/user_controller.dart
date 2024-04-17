import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ordini_ristorante/features/login/domain/repositories/user_repo.dart';

import '../../../../routes/routes.dart';

class UserController extends GetxController{

  final UserRepository userRepository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserController(this.userRepository);

  Future<User?> signUp(String email, String password) async{

    return userRepository.signUp(email, password);

  }

  Future<User?> signIn(String email, String password) async{

    return userRepository.signIn(email, password);

  }

  Future<void> loginWithCondition(UserController userController, String email, String password ) async {

    User? user = await userController.signIn(email, password);

    if(user == null){
      print("errore");
    }
    else{
      emailController.clear();
      passwordController.clear();
      Get.toNamed(Routes.MENU);
    }

  }


}