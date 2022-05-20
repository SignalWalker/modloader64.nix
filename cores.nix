{pkgs}: {
  SuperMario64 = pkgs.fetchurl {
    url = "https://repo.modloader64.com/mods/SM64O/update/SuperMario64.pak";
    hash = "sha256-VrlH3GP/flmgNNIgWZMTuGsKQ7VruShqf9x7znXenEY=";
  };
  MajorasMask = pkgs.fetchurl {
    url = "https://github.com/hylian-modding/Core-MajorasMask/releases/download/v1.0.1/MajorasMask.pak";
    hash = "sha256-YadQgp50FoNTvdqbTFgj1yGQHSmk8K7G7k0Mivfxjlo=";
  };
  BanjoKazooie = pkgs.fetchurl {
    url = "https://repo.modloader64.com/mods/BKO/update/BanjoKazooie.pak";
    hash = "sha256-+CNwA7gTU2XsxPq15YpvxFxoXzEYESRfIEjjPaNwIdQ=";
  };
}
