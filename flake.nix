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
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    certs = {
      url = "git+ssh://git@github.com/edgwitr/certs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
  let
    myname = "edgwitr";
    ver = "24.11";
    x86linux = "x86_64-linux";
    armmac = "aarch64-darwin";
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

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/02e229f9-365c-4dac-b364-9492b5e5366e";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/7E4F-7697";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };
        swapDevices = [ { device = "/swapfile"; size = 2*1024; } ];
        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault x86linux;
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      });
      conf = ({ inputs, config, pkgs, lib, ... }: {
        time.timeZone = "Asia/Tokyo";
        networking.hostName = "Astrolabe";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        security.sudo = {
          enable = true;
          wheelNeedsPassword = true;
        };
        services.openssh.enable = true;
        system.stateVersion = ver;
        users.users."${myname}" = {
          isNormalUser = true;
          extraGroups = [ "networkmanager" "wheel" ];
        };
        programs.nix-ld.enable = true;
        virtualisation.docker.enable = true;
      });
      lnxc = ({ config, pkgs, lib, ... }: {
        boot = {
          loader = {
            systemd-boot = {
              enable = true;
            };
            efi = {
              canTouchEfiVariables = true;
            };
          };
        };
        console.useXkbConfig = true;
        networking.networkmanager.enable = true;
        i18n = {
          defaultLocale = "en_US.UTF-8";
          inputMethod = {
            type = "fcitx5";
            fcitx5 = {
              waylandFrontend = true;
              addons = with pkgs; [ fcitx5-mozc ];
            };
          };
        };
        fonts = {
          packages = with pkgs; [
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-extra
            noto-fonts-emoji
            nerd-fonts.monaspace
          ];
        };
        # Enable RealTimeKit
        security.rtkit.enable = true;
        # Enable sound with pipewire.
        hardware.pulseaudio.enable = false;
        hardware.bluetooth.enable = true;
        services = {
          # Enable the OpenSSH daemon.
          openssh.enable = true;
          # Configure desktop environment
          displayManager.ly.enable = true;
          # getty.autologinUser = myname;

          xserver = {
            windowManager = {
              xmonad = {
                enable = true;
                enableContribAndExtras = true;
              };
            };
            # Configure keymap in X11
            xkb = {
              layout = "jp";
              variant = "";
              options = "ctrl:swapcaps";
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
        programs = {
          hyprland.enable = true;
        };
      });
      wslc = ({ config, pkgs, lib, nixos-wsl, ... }: {
        imports = [ nixos-wsl.nixosModules.wsl ];
        wsl = {
          enable = true;
          defaultUser = myname;
          wslConf = {
            interop.appendWindowsPath = false;
            boot.systemd = true;
          };
        };
      });
    in
    {
      lenovo = inputs.nixos.lib.nixosSystem {
        system = x86linux;
        modules = [ conf lnxc lenovo inputs.catppuccin.nixosModules.catppuccin ];
      };
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
    {
      mini = inputs.nix-darwin.lib.darwinSystem {
        system = armmac;
        modules = [
        ({ config, pkgs, lib, ... }: {
          nixpkgs.config.allowUnfree = true;
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
          time.timeZone = "Asia/Tokyo";
          networking.hostName = "Nocturnal";
          fonts.packages = with pkgs; [
            nerd-fonts.monaspace
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
              "alacritty"
              "elecom-mouse-util"
              "visual-studio-code"
              "discord"
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
      pkg = ({ pkgs, ... }: {
        home.packages = with pkgs; [
          devbox
          gh
          powershell
        ];
        programs = {
          home-manager.enable = true;
          git.enable = true;
          neovim = {
            enable = true;
            extraPackages = with pkgs; [
              gcc
              unzip
              cargo
            ];
          };
          tmux = {
            enable = true;
            sensibleOnTop = false;
            shell = "${pkgs.powershell}/bin/pwsh";
            extraConfig = ''
              ${builtins.readFile ./tmux/tmux.conf}
            '';
          };
        };
      });
      env = ({ config, pkgs, baseshell, homedir, ... }:
      let
        symlink = config.lib.file.mkOutOfStoreSymlink;
        home = "/${homedir}/${myname}";
      in
      {
        home = {
          stateVersion = ver;
          username = "${myname}";
          homeDirectory = home;
          sessionPath = [ "$HOME/.local/bin" ];
          sessionVariables = {
          };
          file = {
          };
        };
        xdg = {
          dataFile = {
            "powershell/Modules".source = symlink /${homedir}/${myname}/.local/dotfiles/posh/Modules;
          };
          configFile = {
            "powershell/Microsoft.PowerShell_profile.ps1".source = ./posh/Microsoft.PowerShell_profile.ps1;
            "nvim".source = symlink /${homedir}/${myname}/.local/dotfiles/nvim;
            "git" = {
              source = ./git;
              recursive = true;
            };
            "alacritty" = {
              source = ./alacritty;
              recursive = true;
            };
            "hypr" = {
              source = ./hypr;
              recursive = true;
            };
            "alacritty/local.toml".text =
            let
              tmux = "${pkgs.tmux}/bin/tmux";
            in
            ''
              [terminal]
              shell = { program = "${baseshell}", args = [ "-c", "${tmux} attach || ${tmux}" ] }
            '';
          };
        };
      });
      linux = ({ pkgs, ...}: {
        home.packages = [
          pkgs.xclip
          pkgs.xfce.thunar
        ];
        programs = {
          wofi.enable = true;
          alacritty.enable = true;
          firefox.enable = true;
          vscode.enable = true;
        };
      });
    in
    {
      lnx = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = x86linux;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
          baseshell = "bash";
          homedir = "home";
        };
        modules = [ pkg env linux ];
      };
      wsl = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = x86linux;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
          baseshell = "bash";
          homedir = "home";
        };
        modules = [ pkg env ];
      };
      mac = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = armmac;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
          baseshell = "zsh";
          homedir = "Users";
        };
        modules = [ pkg env ];
      };
    };
  };
}
