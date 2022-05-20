{
  description = "modloader64";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    npm2nix = {
      url = github:serokell/nix-npm-buildpackage;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ml64-platform-deps = {
      url = github:hylian-modding/ModLoader64-Platform-Deps;
      flake = false;
    };
    ml64 = {
      url = github:hylian-modding/modloader64;
      flake = false;
    };
    ml64-gui = {
      url = github:hylian-modding/modloader64-gui;
      flake = false;
    };
    z64lib = {
      url = github:hylian-modding/ML64-Z64Lib;
      flake = false;
    };
    alejandra = {
      url = github:kamadorueda/alejandra;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    npm2nix,
    alejandra,
    ...
  }:
    with builtins; let
      std = nixpkgs.lib;
      systems = ["x86_64-linux"];
      genSystems = fn: std.genAttrs systems fn;
      nixpkgsFor = genSystems (system:
        import nixpkgs {
          localSystem = builtins.currentSystem or system;
          crossSystem = system;
          overlays = [
            npm2nix.overlay
            self.overlays.${system}
          ];
        });
      derivations =
        genSystems
        (system: {
          z64lib = final: prev:
            final.buildYarnPackage {
              pname = "z64lib";
              nativeBuildInputs = with final; [nodejs_latest];
              src = inputs.z64lib;
            };
          # modloader64-platform-deps = final: prev: final.buildNpmPackage {
          #   name = "modloader64-platform-deps";
          #   src = inputs.ml64-platform-deps;
          # };
          modloader64 = final: prev:
            final.stdenvNoCC.mkDerivation {
              name = "modloader64";
              nativeBuildInputs = with final; [nodejs_latest xorg.lndir unzip];
              # packageOverrides = with final; [ modloader64-platform-deps ];
              sfmlAudio = final.fetchurl {
                url = "https://cdn.discordapp.com/attachments/562776415595135008/864721624301174794/sfml_audio.node";
                hash = "sha256-mUuhyvxlgzEfLAyTXc/ZFpcoCmh4pyeMx6zRA2rMZ8Q=";
              };
              passthru = {
                mods = import ./mods.nix {pkgs = final;};
                cores = import ./cores.nix {pkgs = final;};
              };
              # src = inputs.ml64;
              src = final.fetchurl {
                url = "https://github.com/hylian-modding/ModLoader64/releases/download/v2.0.30/ModLoader-linux64.zip";
                hash = "sha256-82hDlxNaaW6m1UG538jJLvhhX5ryhpQQYAkexhYSXls=";
              };
              dontConfigure = true;
              dontBuild = true;
              installPhase = ''
                mkdir -p $out/emulator
                cp -r ./* $out
                rm $out/emulator/sfml_audio.node
                ln -sT $sfmlAudio $out/emulator/sfml_audio.node
                mkdir -p $out/{cores,mods,roms}
                rm $out/emulator/*.cfg
              '';
            };
          modloader64-gui = final: prev:
            final.stdenvNoCC.mkDerivation {
              name = "modloader64-gui";
              nativeBuildInputs = with final; [xorg.lndir];
              buildInputs = with final;
                [
                  pango
                  cairo
                  glib
                  gtk3
                  alsa-lib
                  nss
                  glew
                ]
                ++ (with final.xorg; [
                  libX11
                  libXcomposite
                  libXcursor
                  libXdamage
                  libXtst
                  libXi
                  libXScrnSaver
                ]);
              # src = ml64-gui;
              src = final.fetchurl {
                url = "https://github.com/hylian-modding/ModLoader64-GUI/releases/download/v1.1.60/modloader64-gui-1.1.60.tar.gz";
                hash = "sha256-HXloZ3l2qpWUtmbibUVdmmjXfRxiJo2AS01f872wQ94=";
              };
              installPhase = ''
                mkdir -p $out/ModLoader
                cp -r ./* $out
                lndir -silent ${final.modloader64} $out/ModLoader
              '';
            };
        });
      genDrvs = fn: std.genAttrs (attrNames derivations) fn;
    in {
      formatter = std.mapAttrs (system: pkgs: pkgs.default) alejandra.packages;
      overlays = genDrvs (system: final: prev:
        (mapAttrs (pname: pdrv: pdrv final prev) derivations.${system})
        // {
          mkML64 = base @ {
            src,
            type,
            ...
          }:
            final.stdenvNoCC.mkDerivation (base
              // {
                dontUnpack = true;
                dontBuild = true;
                dontConfigure = true;
                installPhase = ''
                  mkdir -p $out/${type}
                  cp $src $out/${type}
                '';
              });
        });
      packages = genDrvs (system: let
        pkgs = nixpkgsFor.${system};
      in
        (mapAttrs (pname: pdrv: pkgs.${pname}) derivations.${system})
        // {
          default = pkgs.modloader64;
        });
      homeManagerModules.default = import ./hm.nix;
    };
}
