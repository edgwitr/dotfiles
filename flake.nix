{
  description = "total config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    certs = {
      url = "git+ssh://git@github.com/edgwitr/certs";
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
      lenovo = ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];
        # pertision
        fileSystems."/" = { device = "/dev/disk/by-uuid/3f968628-81c7-426f-85b4-8519905999b9"; fsType = "ext4"; };
        fileSystems."/boot" = { device = "/dev/disk/by-uuid/A80E-82B4"; fsType = "vfat"; options = [ "fmask=0022" "dmask=0022" ]; };
        swapDevices = [ { device = "/swapfile"; size = 2*1024; } ];
        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      });
      conf = ({ config, pkgs, lib, ... }: {
        time.timeZone = "Asia/Tokyo";
        networking.hostName = "Astrolabe";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        security.sudo.wheelNeedsPassword = true;
        system.stateVersion = ver;
      });
      lnxc = ({ config, pkgs, lib, ... }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        console.useXkbConfig = true;
        networking.networkmanager.enable = true;
        i18n.defaultLocale = "en_US.UTF-8";
        fonts = {
          packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk
            noto-fonts-extra
            noto-fonts-emoji
            monaspace
            fira-code-nerdfont
          ];
        };
        # Enable RealTimeKit
        security.rtkit.enable = true;
        # Enable sound with pipewire.
        sound.enable = true;
        hardware.pulseaudio.enable = false;
        hardware.bluetooth.enable = true;
        services = {
          # Enable the OpenSSH daemon.
          openssh.enable = true;

          xserver = {
            enable = true;
            # Configure desktop environment
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
            # Configure keymap in X11
            xkb = {
              layout = "jp";
              variant = "";
              options = "ctrl:nocaps";
            };
          };
          libinput.enable = true;
          # Enable CUPS to print documents.
          printing.enable = true;
          pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
          };
        };
        nixpkgs.config.allowUnfree = true;
        virtualisation.docker.enable = true;
      });
      wslc = ({ config, pkgs, lib, nixos-wsl, ... }: {
        imports = [ nixos-wsl.nixosModules.wsl ];
        wsl.enable = true;
        wsl.wslConf.interop.appendWindowsPath = false;
        programs.nix-ld.enable = true;
        programs.nix-ld.package = pkgs.nix-ld-rs;
      });
    in
    {
      wsl = inputs.nixos.lib.nixosSystem {
        system = x86linux;
        specialArgs = { nixos-wsl = inputs.nixos-wsl; };
        modules = [ conf wslc ];
      };
      wsldkr = inputs.nixos.lib.nixosSystem {
        system = x86linux;
        specialArgs = { nixos-wsl = inputs.nixos-wsl; };
        modules = [ conf wslc inputs.certs.nixosModules.dkrc ];
      };
    };

    darwinConfigurations =
    let
    in
    {
      mini = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
        ({ config, pkgs, lib, ... }: {
          nixpkgs.config.allowUnfree = true;
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
          time.timeZone = "Asia/Tokyo";
          networking.hostName = "Nocturlabe";
          fonts.packages = with pkgs; [
            fira-code-nerdfont
          ];
          system = {
            stateVersion = 5;
            defaults = {
              NSGlobalDomain = {
                AppleInterfaceStyle = "Dark";
                NSAutomaticCapitalizationEnabled = false;
                NSAutomaticPeriodSubstitutionEnabled = false;
                NSAutomaticQuoteSubstitutionEnabled = false;
                NSAutomaticSpellingCorrectionEnabled = false;
                NSTextShowsControlCharacters = true;
              };
              finder = {
                AppleShowAllFiles = true;
                AppleShowAllExtensions = true;
                FXRemoveOldTrashItems = true;
                NewWindowTarget = "Home";
                ShowPathbar = true;
              };
              dock = {
                autohide = true;
                orientation = "bottom";
                mineffect = "scale";
              };
            };
          };
          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = true;
              cleanup = "uninstall";
            };
            casks = [
              "karabiner-elements"
              "chatgpt"
            ];
          };
        })
        ];
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
        xdg.configFile."git" = {
          source = ./git;
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


