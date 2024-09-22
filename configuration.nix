{
  config,
  pkgs,
  options,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];


  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.locate.enable = true;
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: rec {

      };
    };
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # package installs
  environment.systemPackages = with pkgs; [
    # terminal stuff
    htop
    cava
    yazi
    rtorrent
    browsh
    aerc
    cmus
    khal
    wine
    wget
    timg
    feh
    nushell
    ouch
    tmux
    thefuck
    neovim
    carapace
    cbonsai
    ffmpeg
    hyfetch
    jq
    poppler
    fd
    zoxide
    fzf
    grc
    findutils
    qmk
    bluetuith
    cmatrix
    aalib
    wol

    #wm utils
    waybar
    swaylock
    swayidle
    wayland-pipewire-idle-inhibit
    sway-audio-idle-inhibit
    swaybg
    grim
    slurp
    wl-clipboard
    mako
    pavucontrol
    authenticator
    kitty
    foot

    # gui packages
    firefox
    rofi-wayland
    krita
    bitwarden
    vesktop
    calibre
    osu-lazer
    scribus
    nicotine-plus
    parsec-bin
    signal-desktop

    # necessary stuff
    dconf
    xwayland
    mesa
    wireplumber
    steam-run
    glib
    git
    libnotify
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    libGL
    libGLU
    libinput
    bluez
    
    # fish plugins
    fish
    fishPlugins.grc
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.sponge
    fishPlugins.pure
  ];

  fonts.packages = with pkgs; [
    fira-code
    monocraft
    (nerdfonts.override { fonts = [ "Gohu" ]; })
  ];


  #homemanager
  home-manager.users.demi = {pkgs, ...}: {
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
    };

    gtk = {
      enable = true;
     #theme = {
     #  name = "gruvbox-dark";
     #  package = pkgs.gruvbox-dark-gtk;
     #};
      theme = {
        name = "Gruvbox-Dark";
        package = pkgs.gruvbox-gtk-theme;
      };
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
      };
      cursorTheme = {
        name = "Capitaine Cursors (Gruvbox)";
        package = pkgs.capitaine-cursors-themed;
        size = 24;
      };
    };

    programs = {
      firefox = {
        enable = true;
      };

      neovim = {
        viAlias = true;
      };
    };

    home.stateVersion = "23.11";
  };

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  #users.defaultUserShell = pkgs.nushell;

  programs.fish.enable = true;

  programs.thunar.enable = true;

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
          '';
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  hardware.opentabletdriver.enable = true;
  hardware.keyboard.qmk.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  hardware.graphics = {

    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [
      pkgs.amdvlk
      pkgs.mesa.drivers
    ];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
    ];
  };

  networking = {
    hostName = "nix";
    networkmanager.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = ["amdgpu"];

  users.users = {
    demi = {
      initialPassword = "stnd";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = ["wheel" "networkmanager" "audio" "video"];
    };
  };
  programs.light.enable = true;
  programs.dconf.enable = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = false;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  services.automatic-timezoned.enable = true;
  time.timeZone = "America/Los_Angeles";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
