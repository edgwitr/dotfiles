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
    myname = "edgwitr";
    ver = "25.05";
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
        nixpkgs.config.allowUnfree = true;
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
            nerd-fonts.caskaydia-cove
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
        programs = {
          hyprland.enable = true;
        };
      });
      lnxh = {
        virtualisation.docker.enable = true;
      };
      wslc = ({ config, pkgs, lib, nixos-wsl, ... }: {
        imports = [ nixos-wsl.nixosModules.wsl ];
        wsl = {
          enable = true;
          defaultUser = myname;
          wslConf = {
            interop.appendWindowsPath = false;
            # boot.systemd = true;
          };
        };
      });
    in
    {
      lenovo = inputs.nixos.lib.nixosSystem {
        system = x86linux;
        modules = [ conf lnxc lnxh lenovo ];
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
            nerd-fonts.caskaydia-cove
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
              "visual-studio-code"
              "elecom-mouse-util"
              "karabiner-elements"
              "discord"
              "chatgpt"
              "firefox"
              "reaper"
              "google-chrome"
              "steam"
              "font-monaspace"
            ];
          };
        })
        ];
      };
    };

    # home-manager Configurations
    homeConfigurations =
    let
      pkg = ({ pkgs, lib, ... }: 
      let
        vimpkgs = with pkgs; [
          deno
        ];
        myVim = pkgs.symlinkJoin {
          name = "my-vim";
          paths = [ pkgs.vim ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/vim \
              --prefix PATH : ${pkgs.lib.makeBinPath vimpkgs}
          '';
        };
      in
      {
        home.packages = with pkgs; [
          devbox
          netcat
          myVim
        ] ++ [
          pkgs.fzf
        ];
        programs = {
          home-manager.enable = true;
          git = {
            enable = true;
          };
          gh = {
            enable = true;
          };
          zsh = {
            enable = true;
            dotDir = ".config/zsh";
            defaultKeymap = "emacs";
            autosuggestion = {
              enable = true;
            };
            syntaxHighlighting = {
              enable = true;
            };
            initContent = lib.mkMerge [
              (lib.mkOrder 1000 ''
                source ${./zsh/abbr.zsh}
                source ${./zsh/prompt.zsh}
              '')
            ];
          };
          neovim = {
            enable = true;
            extraPackages = with pkgs; [
              deno
            ];
          };
          direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
          };
          tmux = {
            enable = true;
            escapeTime = 0;
            clock24 = true;
            prefix = "c-q";
            shell = "${pkgs.zsh}/bin/zsh";
            # ${builtins.readFile ./tmux/tmux.conf}
            terminal = "screen-256color";
            extraConfig = ''
              set -g terminal-features "*:RGB"
              set -g status-position top
              set -g status-bg brightblack
              set -g status-fg black
              set -g status-left "#[fg=white,bg=black]#{?client_prefix,#[reverse],} [#S] #[default] "
            '';
          };
        };
      });
      env = ({ config, pkgs, baseshell, homedir, ... }:
      let
        homeName = "/${homedir}/${myname}";
        # symlink = config.lib.file.mkOutOfStoreSymlink;
      in
      {
        home = rec {
          stateVersion = ver;
          username = "${myname}";
          homeDirectory = homeName;
          # sessionPath = [ "$HOME/.local/bin" ];
          sessionVariables = {
            EDITOR = "vim";
            NININI = "tera";
          };
          file = {
          };
        };
        xdg = {
          configFile = {
            "vim" = {
              source = ./vim;
              recursive = true;
            };
            # "nvim" = {
            #   source = ./nvim;
            #   recursive = true;
            # };
            "git" = {
              source = ./git;
              recursive = true;
            };
          };
        };
      });
      mac = ({ config, pkgs, homedir, ...}: {
        xdg = {
          configFile = {
            "karabiner".source = config.lib.file.mkOutOfStoreSymlink /${homedir}/${myname}/.local/dotfiles/karabiner;
          };
        };
      });
      lnxs = ({ pkgs, ...}: {
        home.packages = with pkgs; [
        ];
      });
      lnxh = ({ pkgs, ...}: {
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
        modules = [ pkg env lnxs lnxh ];
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
        modules = [ pkg env lnxs ];
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
        modules = [ pkg env mac ];
      };
    };
  };
}
