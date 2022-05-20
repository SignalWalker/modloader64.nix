{
  config,
  pkgs,
  lib,
  ...
}:
with builtins; let
  std = pkgs.lib;
in {
  options.programs.modloader64-gui = with lib; {
    enable = mkEnableOption "modloader64-gui";
    package = mkOption {
      type = types.package;
      default = pkgs.modloader64-gui;
    };
    cores = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    mods = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    roms = mkOption {
      type = types.listOf types.package;
      default = [];
    };
    config = mkOption {
      type = types.submodule {
        freeformType = (pkgs.formats.json {}).type;
      };
      default = {};
    };
  };
  imports = [];
  config = let
    cfg = config.programs.modloader64-gui;
    mlroot = "modloader64-gui";
    foldFiles = mldir: files:
      std.foldl
      (acc: file:
        acc
        // {
          "${mlroot}/${mldir}/${file.name}" = {
            recursive = false;
            source = file;
          };
        })
      {}
      files;
  in
    lib.mkIf cfg.enable {
      programs.modloader64-gui.config.automaticUpdates = lib.mkForce false;
      xdg.configFile =
        (foldFiles "ModLoader/cores" cfg.cores)
        // (foldFiles "ModLoader/mods" cfg.mods)
        // (foldFiles "ModLoader/roms" cfg.roms)
        // {
          ${mlroot} = {
            recursive = true;
            source = cfg.package;
          };
          "${mlroot}/ModLoader64-GUI-config.json" = {
            text = toJSON cfg.config;
          };
        };
      xdg.desktopEntries = {
        modloader64-gui = let
          dir = "${config.xdg.configHome}/${mlroot}";
          bin = "${dir}/modloader64-gui";
        in {
          type = "Application";
          exec = "sh -c \"cd ${dir}; ${bin}\"";
          name = "ModLoader64-GUI";
          icon = "${dir}/resources/app/ml64.png";
          prefersNonDefaultGPU = true;
          categories = [
            "Game"
            "Emulator"
          ];
          settings = {
            Keywords = "n64;emulator";
          };
        };
      };
    };
}
