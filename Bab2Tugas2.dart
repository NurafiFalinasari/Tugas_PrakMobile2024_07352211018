enum KategoriProduk { DataManagement, NetworkAutomation }

//Class Produk Digital
class ProdukDigital {
  String namaProduk;
  KategoriProduk kategori;
  double _harga;
  ProdukDigital(this.namaProduk, this._harga, this.kategori);

  double get harga => _harga;

  set harga(double value) {
    if (value > 0) {
      _harga = value;
    } else {
      print("Harga tidak bisa kurang dari 0");
    }
  }

  void terapkanDiskon() {
    if (kategori == KategoriProduk.NetworkAutomation && _harga > 200000) {
      _harga *= 0.85;
      if (_harga < 200000) {
        _harga = 200000;
      }
    }
  }
}

// Class abstrak Karyawan
abstract class Karyawan {
  String _nama;
  int _umur;
  String _peran;

  Karyawan(this._nama, {required int umur, required String peran})
      : _umur = umur, _peran = peran;

  String get nama => _nama;
  set nama(String value) {
    _nama = value;
  }

  int get umur => _umur;
  set umur(int value) {
    if (value >= 18) {
      _umur = value;
    } else {
      print("Umur lebih dari 17");
    }
  }

  String get peran => _peran;
  set peran(String value) {
    _peran = value;
  }

  void bekerja();
}

// Subclass KaryawanTetap
class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print('$nama bekerja sebagai $peran dengan jam kerja tetap.');
  }
}

// Subclass KaryawanKontrak
class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print('$nama bekerja sebagai $peran dengan kontrak proyek.');
  }
}

mixin Kinerja {
  int produktivitas = 100;
  DateTime? terakhirEvaluasi;

  void updateProduktivitas(int nilai) {
    if (terakhirEvaluasi == null ||
        DateTime.now().difference(terakhirEvaluasi!).inDays >= 30) {
      if (nilai >= 0 && nilai <= 100) {
        produktivitas = nilai;
        terakhirEvaluasi = DateTime.now();
      }
    } else {
      print("Produktivitas hanya dapat diperbarui setiap 30 hari.");
    }
  }

  void periksaProduktivitas() {
    if (produktivitas < 85) {
      print("Produktivitas harus lebih dari 85 untuk Manager.");
    }
  }
}

class KaryawanDenganKinerja extends Karyawan with Kinerja {
  KaryawanDenganKinerja(String nama, {required int umur, required String peran})
      : super(nama, umur: umur, peran: peran);

  @override
  void bekerja() {
    print('$nama bekerja sebagai $peran dengan produktivitas ${produktivitas}%.');
  }
}

enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

// Kelas Proyek
class Proyek {
  FaseProyek fase;
  int jumlahKaryawan;
  DateTime tanggalMulai;

  Proyek(this.fase, this.jumlahKaryawan, this.tanggalMulai);

  void lanjutKePengembangan() {
    if (fase == FaseProyek.Perencanaan && jumlahKaryawan >= 5) {
      fase = FaseProyek.Pengembangan;
    } else {
      throw Exception("Syarat perpindahan ke Pengembangan tidak terpenuhi");
    }
  }

  void lanjutKeEvaluasi() {
    if (fase == FaseProyek.Pengembangan &&
        DateTime.now().difference(tanggalMulai).inDays > 45) {
      fase = FaseProyek.Evaluasi;
    } else {
      throw Exception("Syarat perpindahan ke Evaluasi tidak terpenuhi");
    }
  }
}

// Kelas Perusahaan
class Perusahaan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];
  static const int MAX_KARYAWAN_AKTIF = 20;

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length < MAX_KARYAWAN_AKTIF) {
      karyawanAktif.add(karyawan);
    } else {
      print("Batas karyawan aktif tercapai");
    }
  }

  void resignKaryawan(Karyawan karyawan) {
    karyawanAktif.remove(karyawan);
    karyawanNonAktif.add(karyawan);
  }
}

void main() {
  var produk1 = ProdukDigital("Network Automation Pro", 280000, KategoriProduk.NetworkAutomation);
  produk1.terapkanDiskon();
  print("Produk: ${produk1.namaProduk}, Harga setelah diskon: ${produk1.harga}");

  var karyawan1 = KaryawanTetap("Sari", umur: 25, peran: "Developer");
  var karyawan2 = KaryawanKontrak("Nir", umur: 26, peran: "Network Engineer");

  var karyawanDenganKinerja = KaryawanDenganKinerja("Dea", umur: 29, peran: "Manager");
  karyawanDenganKinerja.updateProduktivitas(90);
  print("${karyawanDenganKinerja.nama} produktivitas: ${karyawanDenganKinerja.produktivitas}");
  
  var proyek = Proyek(FaseProyek.Perencanaan, 5, DateTime.now().subtract(Duration(days: 46)));
  try {
    proyek.lanjutKePengembangan();
    proyek.lanjutKeEvaluasi();
    print("Fase Proyek saat ini: ${proyek.fase}");
  } catch (e) {
    print(e);
  }

  var perusahaan = Perusahaan();
  perusahaan.tambahKaryawan(karyawan1);
  perusahaan.tambahKaryawan(karyawan2);
  print("Jumlah karyawan aktif: ${perusahaan.karyawanAktif.length}");

  perusahaan.resignKaryawan(karyawan1);
  print("Jumlah karyawan Non-Aktif: ${perusahaan.karyawanAktif.length}");
}