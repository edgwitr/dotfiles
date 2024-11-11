{
  description = "total config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: 
  let
    ver = "24.05";
    x86linux = "x86_64-linux";
  in
  {
    # System-wide Configurations
    nixosConfigurations =
    let
      conf = ({ config, pkgs, lib, nixos-wsl, ... }: {
        time.timeZone = "Asia/Tokyo";
        networking.hostName = "Astrolabe";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        security.sudo.wheelNeedsPassword = true;
        virtualisation.docker.enable = true;
        system.stateVersion = ver;
      });
      wslc = ({ config, pkgs, lib, nixos-wsl, ... }: {
        imports = [ nixos-wsl.nixosModules.wsl ];
        wsl.enable = true;
        wsl.wslConf.interop.appendWindowsPath = false;
        programs.nix-ld.enable = true;
        programs.nix-ld.package = pkgs.nix-ld-rs;
      });
      dkrs = ({
        security.pki.certificateFiles = [ /etc/ssl/certs/certs.crt ];
        networking.proxy.default = "http://tyo4.sme.zscaler.net:80";
        networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
      });
    in
    {
      wsl = inputs.nixos.lib.nixosSystem {
        system = x86linux;
        specialArgs = { nixos-wsl = inputs.nixos-wsl; };
        modules = [ conf wslc ];
      };
    };

    # home-manager Configurations
    homeConfigurations = 
    let
      no = ({
        home = rec {
          stateVersion = ver;
          username = "nixos";
          homeDirectory = "/home/${username}";
        };
      });
      pg = ({ pkgs, ... }: {
        home.packages = with pkgs; [ devbox ghq powershell deno ];
        programs = {
          home-manager.enable = true;
          fzf.enable = true;
          git.enable = true;
          vim.enable = true;
          neovim = {
            enable = true;
            withNodeJs = true;
          };
          git-credential-oauth.enable = true;
          tmux = {
            enable = true;
            shell = "${pkgs.powershell}/bin/pwsh";
            extraConfig = ''
              ${builtins.readFile ./tmux/tmux.conf}
            '';
          };
        };
      });
      env = ({ pkgs, ... }: {
        home = {
          sessionPath = [ "$HOME/.local/bin" ];
          sessionVariables = {
            EDITOR = "${pkgs.vim}/bin/vim";
          };
          file = {
          };
        };
      });
      files = ({
        xdg.configFile."nvim" = {
          source = ./nvim;
          recursive = true;
        };
      });
      linux = ({ pkgs, ...}: {
        home.packages = [ pkgs.xclip ];
        dconf.settings = {
          "org/gnome/shell" = {
            favorite-apps = [
              "firefox.desktop"
              "org.gnome.Epiphany.desktop"
              "org.gnome.Console.desktop"
              "org.gnome.Nautilus.desktop"
              "org.gnome.TextEditor.desktop"
              "org.gnome.Geary.desktop"
              "org.gnome.Calendar.desktop"
            ];
          };
          "org/gnome/desktop/input-sources" = {
            xkb-options = "['ctrl:nocaps']";
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = ":minimize,maximize,close";
          };
          "org/gnome/desktop/interface" = {
            clock-show-weekday = true;
          };
        };
        programs = {
          firefox.enable = true;
          vscode.enable = true;
        };
      });
    in
    {
      wsl = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = x86linux;
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ no pg env files ];
      };
    };

  };
}


