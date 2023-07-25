class Validator {
  String? validateField({required String field}) {
    if (field.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? validateNip({required String nip}) {
    final regexp = RegExp(r'[0-9]');
    if (nip.isEmpty) {
      return 'Field tidak boleh kosong';
    } else if (!nip.contains(regexp)) {
      return 'NIP hanya terdiri dari angka';
    } else {
      return null;
    }
  }

  String? validateNama({required String nama}) {
    final regex = RegExp(r'^[a-zA-Z ]+$');
    if (nama.isEmpty) {
      return 'Field tidak boleh kosong';
    } else if (!nama.contains(regex)) {
      return 'Karakter yang diterima: huruf & spasi';
    } else {
      return null;
    }
  }

  String? validateTelp({required String noTelp}) {
    final regex = RegExp(r'[0-9]');
    if (noTelp.isEmpty) {
      return 'Field tidak boleh kosong';
    } else if (!noTelp.contains(regex)) {
      return 'No. telp hanya menerima angka';
    } else {
      return null;
    }
  }
}
