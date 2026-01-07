class ArtistImages {
  static const String _base = "assets/"; 

  
  static final Map<String, String> _map = {
    "ati242": "${_base}ati242.jpg",
    "cem adrian": "${_base}cem_adrian.jpg",
    "ari barokas": "${_base}ari_barokas.jpg",
    "gokhan turkmen": "${_base}gokhan_turkmen.jpg",
    "ilyas yalcintas": "${_base}ilyas_yalcintas.jpg",
    "lvbel c5": "${_base}lvbelc5.jpg",
    "merve ozbey": "${_base}merve_ozbey.jpg",
    "ozcan deniz": "${_base}ozcan_deniz.png",
    "sagopa kajmer": "${_base}sagopa_kajmer.jpg",
    "yuksek sadakat": "${_base}Yuksek_Sadakat.jpg", 
    
   
  };

  static String? pickForTitle(String title) {
    final key = _normalize(title);
    return _map[key];
  }

  static String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll("ı", "i")
        .replaceAll("ğ", "g")
        .replaceAll("ü", "u")
        .replaceAll("ş", "s")
        .replaceAll("ö", "o")
        .replaceAll("ç", "c")
        .replaceAll(RegExp(r"[^a-z0-9 ]"), "")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();
  }
}