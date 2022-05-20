{pkgs}: {
  Sm64Online = pkgs.fetchurl {
    url = "https://repo.modloader64.com/mods/SM64O/update/Sm64Online.pak";
    hash = "sha256-0keKrjmM7frBTO2xy8m7y+ZtnB6o2iDfxBTHRHllZF0=";
  };
  MischiefMakersOnline = pkgs.fetchurl {
    url = "https://repo.modloader64.com/mods/Mischief/update/MischiefMakersOnline.pak";
    hash = "sha256-NvyMsdNkSvEHBfWzS83hRf0TIQQwfeTR3F1yWBJS/4w=";
  };
  OotOnline = pkgs.fetchurl {
    url = "https://github.com/hylian-modding/Z64Online/releases/download/v3.0.70/OotOnline.pak";
    hash = "sha256-u/zCW1nHN6s+lcnutStguG0f+O2anS+PLUeyVLjb6lo=";
  };
  MajorasMaskOnline = pkgs.fetchurl {
    url = "https://github.com/hylian-modding/MajorasMaskOnline/releases/download/v1.0.5/MajorasMaskOnline.pak";
    hash = "sha256-HYIoICFfj+ZM031WA7IZUmZLf2QB73/iHihO35zOJmQ=";
  };
  BKOnline = pkgs.fetchurl {
    url = "https://repo.modloader64.com/mods/BKO/update/BkOnline.pak";
    hash = "sha256-sCc4FDLhYl8S9PON+L7keHNtkY928EwLMUS8RSd4Pfg=";
  };
  NimpizeAdventure = pkgs.fetchurl {
    url = "https://cdn.discordapp.com/attachments/705760236883017808/850158349043761152/Nimpize_Key_Counter_Fix.bps";
    hash = "sha256-L9OuCaNbWoUtjSbqvwnLUvtCQ+ohVGcQ0rX1fifHtd0=";
  };
  FateOfTheBombiwa = pkgs.fetchurl {
    url = "https://cdn.discordapp.com/attachments/705760236883017808/706582178162671636/TFOTB_Patch.bps";
    hash = "sha256-l3g6A2DicxtEIQKPolFO0nEqtv+8LuMFMw1wb2611wo=";
  };
  CheatMenu = pkgs.fetchurl {
    url = "https://github.com/JerryWester/ML64-Z64CheatMenu/releases/download/2.0.0/cheatmenu.pak";
    hash = "sha256-FEqWjwFRW1LuG++PHwKUywvXXmN9Z9J08sVbAJ/Heis=";
  };
}
