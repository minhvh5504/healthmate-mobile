// ignore_for_file: unused_element
import 'dart:io';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'prescription_api.g.dart';

@RestApi()
abstract class PrescriptionApi {
  factory PrescriptionApi(Dio dio) = _PrescriptionApi;

  @GET('prescriptions')
  Future<dynamic> getPrescriptions();

  @DELETE('prescriptions/{id}')
  Future<dynamic> deletePrescription(@Path('id') String id);

  @POST('prescriptions')
  @MultiPart()
  Future<dynamic> createPrescription({
    @Part(name: 'doctorName') required String doctorName,
    @Part(name: 'clinicName') required String clinicName,
    @Part(name: 'note') required String note,
    @Part(name: 'startDate') required String startDate,
    @Part(name: 'endDate') String? endDate,
    @Part(name: 'file') File? file,
  });

  @PATCH('prescriptions/{id}')
  @MultiPart()
  Future<dynamic> updatePrescription({
    @Path('id') required String id,
    @Part(name: 'doctorName') required String doctorName,
    @Part(name: 'clinicName') required String clinicName,
    @Part(name: 'note') required String note,
    @Part(name: 'startDate') required String startDate,
    @Part(name: 'endDate') String? endDate,
    @Part(name: 'file') File? file,
    @Part(name: 'status') String? status,
  });
}
