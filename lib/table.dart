class Chair {
  int count = 0;
  bool full = false;

  Chair({required this.count});

  }

class CafeTable {
  Chair chair;
  List<bool> chairStatusList;

  CafeTable({int chairCount = 4})
      : chair = Chair(count: chairCount),
        chairStatusList = List<bool>.filled(chairCount, false); // Koltuk sayısı kadar öğeyle başlatılıyor


  bool socket = false;
  bool window = false;
  bool full = false;

}
List<CafeTable> tables = [];