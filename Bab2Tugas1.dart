enum KategoriProduk { DataManagement, NetworkAutomation }

// Class Produk
class Produk {
  String namaProduk;
  double harga;
  KategoriProduk kategori;

  Produk(this.namaProduk, this.harga, this.kategori) {
    if (kategori == KategoriProduk.NetworkAutomation && harga < 200000) {
      throw ArgumentError("Harga produk NetworkAutomation harus minimal 200.000");
    } else if (kategori == KategoriProduk.DataManagement && harga >= 200000) {
      throw ArgumentError("Harga produk DataManagement harus di bawah 200.000");
    }
  }
}

// Subclass Produk Premium dengan Diskon
class ProdukPremium extends Produk {
  int jumlahTerjual;

  ProdukPremium(String namaProduk, double harga, KategoriProduk kategori, this.jumlahTerjual)
      : super(namaProduk, harga, kategori);

  void berikanDiskon() {
    if (kategori == KategoriProduk.NetworkAutomation && jumlahTerjual > 50) {
      double hargaSetelahDiskon = harga * 0.85;
      harga = (hargaSetelahDiskon < 200000) ? 200000 : hargaSetelahDiskon;
    }
  }
}

enum PeranKaryawan { Developer, NetworkEngineer, Manager }

// Superclass Karyawan
abstract class Karyawan {
  String nama;
  int umur;
  PeranKaryawan peran;

  Karyawan(this.nama, {required this.umur, required this.peran});

  void bekerja();
}

// Subclass Karyawan Tetap
class KaryawanTetap extends Karyawan {
  KaryawanTetap(String nama, {required int umur, required PeranKaryawan peran})
      : super(nama, umur: umur, peran: peran);

  void bekerja() {
    print('$nama bekerja sebagai $peran dengan jam kerja tetap.');
  }
}

// Subclass Karyawan Kontrak
class KaryawanKontrak extends Karyawan {
  KaryawanKontrak(String nama, {required int umur, required PeranKaryawan peran})
      : super(nama, umur: umur, peran: peran);

  void bekerja() {
    print('$nama bekerja sebagai $peran dengan kontrak proyek.');
  }
}

mixin Kinerja {
  int produktivitas = 0;
  DateTime? lastUpdate;

  void updateProduktivitas(int nilai) {
    DateTime now = DateTime.now();
    if (lastUpdate == null || now.difference(lastUpdate!).inDays >= 30) {
      if (nilai >= 0 && nilai <= 100) {
        produktivitas = nilai;
        lastUpdate = now;

      } else {
        throw Exception("Nilai produktivitas harus antara 0 hingga 100.");
      }
    } else {
      throw Exception("Produktivitas hanya dapat diperbarui setiap 30 hari.");
    }
  }
}

class KaryawanDenganKinerja extends Karyawan with Kinerja {
  KaryawanDenganKinerja(String nama, {required int umur, required PeranKaryawan peran})
      : super(nama, umur: umur, peran: peran);

  void bekerja() {
    print('$nama bekerja sebagai $peran dengan produktivitas ${produktivitas}%.');
  }
}

enum FaseProyek { Perencanaan, Pengembangan, Evaluasi }

// Class Proyek
class Proyek {
  FaseProyek fase = FaseProyek.Perencanaan;
  int jumlahKaryawan;
  DateTime tanggalMulai;

  Proyek(this.jumlahKaryawan, this.tanggalMulai);

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

// Class Manajemen
class ManajemenKaryawan {
  List<Karyawan> karyawanAktif = [];
  List<Karyawan> karyawanNonAktif = [];

  void tambahKaryawan(Karyawan karyawan) {
    if (karyawanAktif.length >= 20) {
      throw Exception("Maksimal 20 karyawan aktif");
    }
    karyawanAktif.add(karyawan);
    print("${karyawan.nama} ditambahkan sebagai karyawan aktif.");
  }

  void resignKaryawan(Karyawan karyawan) {
    if (karyawanAktif.contains(karyawan)) {
      karyawanAktif.remove(karyawan);
      karyawanNonAktif.add(karyawan);
      print("${karyawan.nama} telah resign dan menjadi karyawan non-aktif.");
    } else {
      print("${karyawan.nama} tidak ditemukan di daftar karyawan aktif.");
    }
  }
}

void main() {
  try {
    var produk1 = Produk("Data Management Basic", 170000, KategoriProduk.DataManagement);
    print("Produk1 berhasil dibuat: ${produk1.namaProduk}, Harga: ${produk1.harga}");

    var produk2 = ProdukPremium("Network Automation Pro", 300000, KategoriProduk.NetworkAutomation, 60);
    produk2.berikanDiskon();
    print("Produk2 berhasil dibuat: ${produk2.namaProduk}, Harga setelah diskon: ${produk2.harga}");
  } catch (e) {
    print("Error: $e");
  }

  var manajemenKaryawan = ManajemenKaryawan();
  var karyawan1 = KaryawanTetap("Khaira", umur: 25, peran: PeranKaryawan.Developer);
  var karyawan2 = KaryawanKontrak("Vikriyah", umur: 27, peran: PeranKaryawan.NetworkEngineer);

  var karyawanDenganKinerja = KaryawanDenganKinerja("Nir", umur: 29, peran: PeranKaryawan.Manager);
  karyawanDenganKinerja.updateProduktivitas(90);
  print("${karyawanDenganKinerja.nama} produktivitas: ${karyawanDenganKinerja.produktivitas}");

  manajemenKaryawan.tambahKaryawan(karyawan1);
  manajemenKaryawan.tambahKaryawan(karyawan2);

  print("Jumlah karyawan aktif: ${manajemenKaryawan.karyawanAktif.length}");

  var proyek = Proyek(5, DateTime.now().subtract(Duration(days: 49)));
  try {
    proyek.lanjutKePengembangan();
    proyek.lanjutKeEvaluasi();
    print("Proyek saat ini di fase: ${proyek.fase}");
  } catch (e) {
    print(e);
  }

  manajemenKaryawan.resignKaryawan(karyawan1);

  print("Jumlah karyawan aktif setelah resign: ${manajemenKaryawan.karyawanAktif.length}");
}