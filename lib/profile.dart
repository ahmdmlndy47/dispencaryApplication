import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dispensary/components/input_field.dart';
import 'package:dispensary/components/main_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  File? profileImage;

  final ImagePicker picker = ImagePicker();

  final Stream<QuerySnapshot> stream =
  FirebaseFirestore.instance
      .collectionGroup("patients")
      .where(
    "UID",
    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
  )
      .limit(1)
      .snapshots();

  Future pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  late TextEditingController oldPassword;
  late TextEditingController newPassword;
  late TextEditingController confirmPassword;

  GlobalKey<FormState> oldPasswordKey = GlobalKey();
  GlobalKey<FormState> changePasswordKey = GlobalKey();

  bool isFieldEnabled = false;
  bool isChangingPassword = false;

  @override
  void initState() {
    oldPassword = TextEditingController();
    newPassword = TextEditingController();
    confirmPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();

    super.dispose();
  }

  // ============================================================
  // دالة إظهار رسالة باستخدام AwesomeDialog
  // ============================================================

  void showMessageDialog({
    required String title,
    required String message,
    required DialogType dialogType,
  }) {
    if (!mounted) return;

    AwesomeDialog(
      context: context,
      title: title,
      desc: message,
      dialogType: dialogType,
      animType: AnimType.rightSlide,
      showCloseIcon: true,
      btnOkText: "حسناً",
      btnOkOnPress: () {},
    ).show();
  }

  // ============================================================
  // التحقق من كلمة المرور القديمة
  // ============================================================

  Future<void> verifyOldPassword(
      BuildContext dialogContext,
      StateSetter setDialogState,
      ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessageDialog(
        title: "خطأ",
        message: "لم يتم العثور على المستخدم",
        dialogType: DialogType.error,
      );

      return;
    }

    if (!oldPasswordKey.currentState!.validate()) {
      return;
    }

    try {
      setDialogState(() {
        isChangingPassword = true;
      });

      // إنشاء بيانات التحقق
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword.text,
      );

      // إعادة التحقق من المستخدم
      await user.reauthenticateWithCredential(credential);

      if (!mounted) return;

      setDialogState(() {
        isFieldEnabled = true;
        isChangingPassword = false;
      });

      // رسالة نجاح التحقق
      showMessageDialog(
        title: "تم التحقق",
        message:
        "كلمة المرور القديمة صحيحة، يمكنك الآن إدخال كلمة المرور الجديدة",
        dialogType: DialogType.success,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setDialogState(() {
        isChangingPassword = false;
      });

      String message;

      switch (e.code) {
        case "wrong-password":
        case "invalid-credential":
          message = "كلمة المرور القديمة غير صحيحة";
          break;

        case "user-mismatch":
          message = "بيانات المستخدم غير صحيحة";
          break;

        case "user-not-found":
          message = "المستخدم غير موجود";
          break;

        case "network-request-failed":
          message = "تحقق من اتصالك بالإنترنت";
          break;

        case "too-many-requests":
          message =
          "تم إجراء محاولات كثيرة، حاول مرة أخرى لاحقاً";
          break;

        default:
          message = "حدث خطأ أثناء التحقق من كلمة المرور";
      }

      showMessageDialog(
        title: "خطأ",
        message: message,
        dialogType: DialogType.error,
      );
    } catch (e) {
      if (!mounted) return;

      setDialogState(() {
        isChangingPassword = false;
      });

      showMessageDialog(
        title: "خطأ",
        message: "حدث خطأ أثناء التحقق من كلمة المرور",
        dialogType: DialogType.error,
      );
    }
  }

  // ============================================================
  // تغيير كلمة المرور
  // ============================================================

  Future<void> changePassword(
      BuildContext dialogContext,
      StateSetter setDialogState,
      ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMessageDialog(
        title: "خطأ",
        message: "لم يتم العثور على المستخدم",
        dialogType: DialogType.error,
      );

      return;
    }

    if (!changePasswordKey.currentState!.validate()) {
      return;
    }

    // التأكد من تطابق كلمتي المرور
    if (newPassword.text != confirmPassword.text) {
      showMessageDialog(
        title: "خطأ",
        message: "كلمتا المرور الجديدتان غير متطابقتين",
        dialogType: DialogType.error,
      );

      return;
    }

    // التأكد من طول كلمة المرور
    if (newPassword.text.length < 6) {
      showMessageDialog(
        title: "خطأ",
        message:
        "كلمة المرور الجديدة يجب أن تكون 6 أحرف على الأقل",
        dialogType: DialogType.error,
      );

      return;
    }

    try {
      setDialogState(() {
        isChangingPassword = true;
      });

      // تغيير كلمة المرور في Firebase
      await user.updatePassword(
        newPassword.text,
      );

      if (!mounted) return;

      // إغلاق Dialog تغيير كلمة المرور
      Navigator.of(dialogContext).pop();

      // تنظيف الحقول
      oldPassword.clear();
      newPassword.clear();
      confirmPassword.clear();

      setState(() {
        isFieldEnabled = false;
        isChangingPassword = false;
      });

      // إظهار رسالة نجاح
      showMessageDialog(
        title: "تم بنجاح",
        message: "تم تغيير كلمة المرور بنجاح",
        dialogType: DialogType.success,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setDialogState(() {
        isChangingPassword = false;
      });

      String message;

      switch (e.code) {
        case "weak-password":
          message = "كلمة المرور الجديدة ضعيفة";
          break;

        case "requires-recent-login":
          message =
          "يجب إعادة التحقق من الحساب ثم المحاولة مرة أخرى";
          break;

        case "network-request-failed":
          message = "تحقق من اتصالك بالإنترنت";
          break;

        case "too-many-requests":
          message =
          "تم إجراء محاولات كثيرة، حاول مرة أخرى لاحقاً";
          break;

        default:
          message =
          "حدث خطأ أثناء تغيير كلمة المرور";
      }

      showMessageDialog(
        title: "خطأ",
        message: message,
        dialogType: DialogType.error,
      );
    } catch (e) {
      if (!mounted) return;

      setDialogState(() {
        isChangingPassword = false;
      });

      showMessageDialog(
        title: "خطأ",
        message: "حدث خطأ أثناء تغيير كلمة المرور",
        dialogType: DialogType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الملف الشخصي"),
        centerTitle: true,
      ),

      body: StreamBuilder(
        stream: stream,
        builder: (
            context,
            AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("لا توجد بيانات"),
            );
          }

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [

                // =====================================================
                // صورة المستخدم
                // =====================================================

                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Stack(
                      children: [

                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.teal,

                          backgroundImage:
                          profileImage != null
                              ? FileImage(profileImage!)
                              : null,

                          child: profileImage == null
                              ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                              : null,
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // =====================================================
                // اسم المستخدم
                // =====================================================

                Center(
                  child: Text(
                    "${snapshot.data!.docs.first["firstName"]} "
                        "${snapshot.data!.docs.first["lastName"]}",
                    style:
                    Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================================
                // الإيميل
                // =====================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    const Icon(
                      Icons.mail,
                      size: 18,
                      color: Colors.redAccent,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "${FirebaseAuth.instance.currentUser!.email}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // =====================================================
                // رقم الهاتف
                // =====================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    const Icon(
                      Icons.phone,
                      size: 18,
                      color: Colors.redAccent,
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "${snapshot.data!.docs.first["phone"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =====================================================
                // الإعدادات
                // =====================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    const Text(
                      "الإعدادات",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Icon(
                      Icons.settings,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =====================================================
                // تغيير كلمة المرور
                // =====================================================

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {

                      // إعادة ضبط الحالة
                      isFieldEnabled = false;
                      isChangingPassword = false;

                      oldPassword.clear();
                      newPassword.clear();
                      confirmPassword.clear();

                      showDialog(
                        context: context,

                        // منع إغلاق Dialog بالضغط خارجه
                        barrierDismissible: false,

                        builder: (dialogContext) {

                          return StatefulBuilder(
                            builder: (
                                context,
                                setDialogState,
                                ) {

                              return Dialog(
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding:
                                    const EdgeInsets.all(20),

                                    decoration: BoxDecoration(
                                      color: Colors.white,

                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset:
                                          Offset(-5, 5),
                                          blurRadius: 5,
                                        ),
                                      ],

                                      borderRadius:
                                      BorderRadius.circular(
                                        20,
                                      ),
                                    ),

                                    child: Column(
                                      mainAxisSize:
                                      MainAxisSize.min,

                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,

                                      children: [

                                        // =====================================
                                        // العنوان
                                        // =====================================

                                        Text(
                                          "تغيير كلمة المرور",
                                          style:
                                          Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),

                                        // =====================================
                                        // كلمة المرور القديمة
                                        // =====================================

                                        Form(
                                          key: oldPasswordKey,

                                          child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,

                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,

                                            children: [

                                              Text(
                                                "كلمة المرور القديمة",
                                                style:
                                                Theme.of(
                                                  context,
                                                )
                                                    .textTheme
                                                    .titleMedium,
                                              ),

                                              InputField(
                                                hint:
                                                "أدخل كلمة المرور القديمة",

                                                icon:
                                                const Icon(
                                                  Icons.lock,
                                                ),

                                                inputType:
                                                TextInputType
                                                    .visiblePassword,

                                                isObscure: true,

                                                controller:
                                                oldPassword,

                                                enabled: true,

                                                validator: (val) {

                                                  if (val == null ||
                                                      val.isEmpty) {
                                                    return "لا يمكن ترك الحقل فارغاً";
                                                  }

                                                  return null;
                                                },
                                              ),

                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),

                                        // =====================================
                                        // زر التحقق
                                        // =====================================

                                        MyButton(
                                          onPressed:
                                          isChangingPassword
                                              ? null
                                              : () {
                                            verifyOldPassword(
                                              dialogContext,
                                              setDialogState,
                                            );
                                          },

                                          label:
                                          isChangingPassword
                                              ? "جاري التحقق..."
                                              : "التحقق",

                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                              20,
                                            ),
                                          ),

                                          fontSize: 20,

                                          btnColor:
                                          Colors.blueAccent,
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),

                                        // =====================================
                                        // كلمة المرور الجديدة
                                        // =====================================

                                        Form(
                                          key:
                                          changePasswordKey,

                                          child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,

                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,

                                            children: [

                                              Text(
                                                "كلمة المرور الجديدة",
                                                style:
                                                Theme.of(
                                                  context,
                                                )
                                                    .textTheme
                                                    .titleMedium,
                                              ),

                                              InputField(
                                                hint:
                                                "أدخل كلمة المرور الجديدة",

                                                icon:
                                                const Icon(
                                                  Icons.lock,
                                                ),

                                                inputType:
                                                TextInputType
                                                    .visiblePassword,

                                                isObscure: true,

                                                controller:
                                                newPassword,

                                                enabled:
                                                isFieldEnabled,

                                                validator: (val) {

                                                  if (val == null ||
                                                      val.isEmpty) {
                                                    return "لا يمكن ترك الحقل فارغاً";
                                                  }

                                                  if (val.length < 6) {
                                                    return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                                                  }

                                                  return null;
                                                },
                                              ),

                                              const SizedBox(
                                                height: 20,
                                              ),

                                              // =====================================
                                              // تأكيد كلمة المرور
                                              // =====================================

                                              Text(
                                                "كلمة المرور الجديدة مجدداً",
                                                style:
                                                Theme.of(
                                                  context,
                                                )
                                                    .textTheme
                                                    .titleMedium,
                                              ),

                                              InputField(
                                                hint:
                                                "أدخل كلمة المرور الجديدة مجدداً",

                                                icon:
                                                const Icon(
                                                  Icons.lock,
                                                ),

                                                inputType:
                                                TextInputType
                                                    .visiblePassword,

                                                isObscure: true,

                                                controller:
                                                confirmPassword,

                                                enabled:
                                                isFieldEnabled,

                                                validator: (val) {

                                                  if (val == null ||
                                                      val.isEmpty) {
                                                    return "لا يمكن ترك الحقل فارغاً";
                                                  }

                                                  if (val !=
                                                      newPassword.text) {
                                                    return "كلمتا المرور غير متطابقتين";
                                                  }

                                                  return null;
                                                },
                                              ),

                                              const SizedBox(
                                                height: 20,
                                              ),

                                              // =====================================
                                              // زر تغيير كلمة المرور
                                              // =====================================

                                              MyButton(
                                                onPressed:
                                                isFieldEnabled &&
                                                    !isChangingPassword
                                                    ? () {
                                                  changePassword(
                                                    dialogContext,
                                                    setDialogState,
                                                  );
                                                }
                                                    : null,

                                                label:
                                                isChangingPassword
                                                    ? "جاري التغيير..."
                                                    : "تغيير كلمة المرور",

                                                shape:
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                    20,
                                                  ),
                                                ),

                                                fontSize: 20,

                                                btnColor:
                                                Colors.blueAccent,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },

                    child: const Text(
                      "تغيير كلمة المرور",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // =====================================================
                // حول التطبيق
                // =====================================================

                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {

                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,

                        title: "حول التطبيق",

                        desc:
                        "تطبيق mediCenter هو تطبيق يتيح لك الحجز في مستوصف عن بعد ومراقبة دورك ويمكنك رؤية سجلاتك الطبية ومراجعة وصفاتك الطبية بسهولة",

                        titleTextStyle:
                        const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),

                        descTextStyle:
                        const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),

                        showCloseIcon: true,
                      ).show();
                    },

                    child: const Text(
                      "حول التطبيق",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // =====================================================
                // تسجيل الخروج
                // =====================================================

                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {

                      AwesomeDialog(
                        context: context,

                        title: "تسجيل الخروج",

                        desc:
                        "هل أنت متأكد من تسجيل الخروج",

                        dialogType:
                        DialogType.question,

                        showCloseIcon: true,

                        animType:
                        AnimType.rightSlide,

                        btnOkOnPress: () async {

                          await FirebaseAuth.instance
                              .signOut();

                          if (!context.mounted) return;

                          Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                            "logOrSignPage",
                                (route) => false,
                          );
                        },

                        btnCancelOnPress: () {},

                        btnOkText: "نعم",

                        btnCancelText: "لا",
                      ).show();
                    },

                    child: const Text(
                      "تسجيل الخروج",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}