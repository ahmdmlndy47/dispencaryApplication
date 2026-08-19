import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyRecords extends StatefulWidget {
  const MyRecords({super.key});

  @override
  State<MyRecords> createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  // المحافظات
  List<QueryDocumentSnapshot> countries = [];

  // المستوصفات
  List<QueryDocumentSnapshot> dispensaries = [];

  // سجلات المريض
  List<Map<String, dynamic>> records = [];

  // المحافظة المختارة
  QueryDocumentSnapshot? selectedCountry;

  // المستوصف المختار
  QueryDocumentSnapshot? selectedDispensary;

  bool isLoading = true;
  bool isLoadingDispensaries = false;
  bool isLoadingRecords = false;

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  // جلب المحافظات
  Future<void> getCountries() async {
    try {
      final countriesSnapshot =
      await FirebaseFirestore.instance
          .collection("countries")
          .get();

      if (!mounted) return;

      setState(() {
        countries = countriesSnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      print("Error getting countries: $e");
    }
  }

  // جلب المستوصفات التابعة للمحافظة
  Future<void> getDispensaries(String countryId) async {
    setState(() {
      isLoadingDispensaries = true;

      // تصفير المستوصف السابق
      selectedDispensary = null;

      // تصفير المستوصفات
      dispensaries = [];

      // تصفير السجلات
      records = [];
    });

    try {
      final dispensariesSnapshot =
      await FirebaseFirestore.instance
          .collection("countries")
          .doc(countryId)
          .collection("dispensaries")
          .get();

      if (!mounted) return;

      setState(() {
        dispensaries = dispensariesSnapshot.docs;
        isLoadingDispensaries = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingDispensaries = false;
      });

      print("Error getting dispensaries: $e");
    }
  }

  // جلب سجلات المريض من المستوصف المحدد
  Future<void> getPatientRecords(
      String countryId,
      String dispensaryId,
      ) async {
    setState(() {
      isLoadingRecords = true;
      records = [];
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          isLoadingRecords = false;
        });

        return;
      }

      // البحث عن المريض ضمن المستوصف
      final patientSnapshot =
      await FirebaseFirestore.instance
          .collection("countries")
          .doc(countryId)
          .collection("dispensaries")
          .doc(dispensaryId)
          .collection("patients")
          .where(
        "UID",
        isEqualTo: user.uid,
      )
          .limit(1)
          .get();

      // إذا المريض غير موجود في هذا المستوصف
      if (patientSnapshot.docs.isEmpty) {
        if (!mounted) return;

        setState(() {
          records = [];
          isLoadingRecords = false;
        });

        return;
      }

      final patient = patientSnapshot.docs.first;

      // جلب records الموجودة داخل Document المريض
      final patientData = patient.data();

      final patientRecords = patientData["records"];

      // إذا ما عنده records
      if (patientRecords == null ||
          patientRecords is! List ||
          patientRecords.isEmpty) {
        if (!mounted) return;

        setState(() {
          records = [];
          isLoadingRecords = false;
        });

        return;
      }

      // تحويل records إلى List<Map<String, dynamic>>
      final List<Map<String, dynamic>> loadedRecords = [];

      for (final record in patientRecords) {
        if (record is Map) {
          loadedRecords.add(
            Map<String, dynamic>.from(record),
          );
        }
      }

      if (!mounted) return;

      setState(() {
        records = loadedRecords;
        isLoadingRecords = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        records = [];
        isLoadingRecords = false;
      });

      print("Error getting patient records: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجلاتي"),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // ==========================================
            // النص التوضيحي
            // ==========================================

            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      offset: Offset(-5, 5),
                      color: Colors.grey,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "يجب أولا إدخال المحافظة ثم المستوصف للحصول على سجلاتك الموجودة فيه",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==========================================
            // المحافظة
            // ==========================================

            const Text(
              "المحافظات",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<QueryDocumentSnapshot>(
              value: selectedCountry,

              decoration: InputDecoration(
                hintText: "اختر المحافظة",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              items: countries.map((country) {
                return DropdownMenuItem<QueryDocumentSnapshot>(
                  value: country,
                  child: Text(
                    country["countryName"],
                  ),
                );
              }).toList(),

              onChanged: (country) {
                if (country == null) return;

                setState(() {
                  selectedCountry = country;
                });

                getDispensaries(country.id);
              },
            ),

            const SizedBox(height: 25),

            // ==========================================
            // المستوصف
            // ==========================================

            const Text(
              "المستوصف",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            isLoadingDispensaries
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : DropdownButtonFormField<QueryDocumentSnapshot>(
              value: selectedDispensary,

              decoration: InputDecoration(
                hintText: selectedCountry == null
                    ? "اختر المحافظة أولاً"
                    : "اختر المستوصف",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              items: dispensaries.map((dispensary) {
                return DropdownMenuItem<QueryDocumentSnapshot>(
                  value: dispensary,
                  child: Text(
                    dispensary["disName"],
                  ),
                );
              }).toList(),

              onChanged: selectedCountry == null
                  ? null
                  : (dispensary) {
                if (dispensary == null) return;

                setState(() {
                  selectedDispensary = dispensary;
                });

                getPatientRecords(
                  selectedCountry!.id,
                  dispensary.id,
                );
              },
            ),

            const SizedBox(height: 30),

            // ==========================================
            // عنوان السجلات
            // ==========================================

            if (selectedDispensary != null)
              const Text(
                "السجلات الطبية",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 15),

            // ==========================================
            // تحميل السجلات
            // ==========================================

            if (isLoadingRecords)

              const Center(
                child: CircularProgressIndicator(),
              )

            // ==========================================
            // لا يوجد سجلات
            // ==========================================

            else if (
            selectedDispensary != null &&
                records.isEmpty
            )

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "لا توجد سجلات في هذا المستوصف",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              )

            // ==========================================
            // عرض السجلات
            // ==========================================

            else

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, index) {

                  final record = records[index];

                  // اسم السجل
                  // مثال:
                  // "سجل عيادة الأسنان"
                  final recordName = record.keys.first;

                  // بيانات السجل
                  final recordData =
                  Map<String, dynamic>.from(
                    record[recordName],
                  );

                  // اسم العيادة
                  final clinicName =
                      recordData["clinicName"] ?? "";

                  // اسم الطبيب
                  final doctorName =
                      recordData["doctorName"] ?? "";

                  // الزيارات
                  final visitsData =
                      recordData["visits"] ?? [];

                  final List<Map<String, dynamic>> visits = [];

                  if (visitsData is List) {
                    for (final visit in visitsData) {
                      if (visit is Map) {
                        visits.add(
                          Map<String, dynamic>.from(visit),
                        );
                      }
                    }
                  }

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          // ==================================
                          // اسم السجل
                          // ==================================

                          Text(
                            recordName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // ==================================
                          // اسم العيادة
                          // ==================================

                          Text(
                            "العيادة: $clinicName",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ==================================
                          // اسم الطبيب
                          // ==================================

                          Text(
                            "الطبيب: $doctorName",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ==================================
                          // عنوان الزيارات
                          // ==================================

                          const Text(
                            "الزيارات",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ==================================
                          // الزيارات
                          // ==================================

                          if (visits.isEmpty)

                            const Text(
                              "لا توجد زيارات",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            )

                          else

                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),

                              itemCount: visits.length,

                              itemBuilder:
                                  (context, visitIndex) {

                                final visit =
                                visits[visitIndex];

                                final date =
                                    visit["date"] ?? "";

                                final symptoms =
                                    visit["symptoms"] ?? "";

                                final diagnosis =
                                    visit["diagnosis"] ?? "";

                                final medicines =
                                    visit["medicines"] ?? [];

                                return Container(
                                  margin:
                                  const EdgeInsets.only(
                                    bottom: 12,
                                  ),

                                  padding:
                                  const EdgeInsets.all(12),

                                  decoration:
                                  BoxDecoration(
                                    color:
                                    Colors.grey.shade100,

                                    borderRadius:
                                    BorderRadius.circular(
                                      15,
                                    ),

                                    border: Border.all(
                                      color:
                                      Colors.grey.shade300,
                                    ),
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children: [

                                      // رقم الزيارة
                                      Text(
                                        "الزيارة ${visitIndex + 1}",
                                        style:
                                        const TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      // التاريخ
                                      Text(
                                        "التاريخ: $date",
                                      ),

                                      const SizedBox(
                                        height: 6,
                                      ),

                                      // الأعراض
                                      Text(
                                        "الأعراض: $symptoms",
                                      ),

                                      const SizedBox(
                                        height: 6,
                                      ),

                                      // التشخيص
                                      Text(
                                        "التشخيص: $diagnosis",
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      // الأدوية
                                      const Text(
                                        "الأدوية:",
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 5,
                                      ),

                                      if (medicines is List &&
                                          medicines.isNotEmpty)

                                        ...medicines.map(
                                              (medicine) {
                                            return Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                bottom: 3,
                                              ),
                                              child: Text(
                                                "• $medicine",
                                              ),
                                            );
                                          },
                                        )

                                      else

                                        const Text(
                                          "لا يوجد أدوية",
                                          style: TextStyle(
                                            color:
                                            Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}