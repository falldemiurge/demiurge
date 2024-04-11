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

  sound.enable = false;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
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
    yazi
    rtorrent
    browsh
    aerc
    cmus
    khal
    wine
    steamcmd
    wget
    timg
    feh
    nushell
    ouch
    tmux
    thefuck
    neovim
    carapace
    alejandra
    cbonsai
    neofetch

    #wm utils
    waybar
    swaylock
    swayidle
    sway-audio-idle-inhibit
    swaybg
    grim
    slurp
    wl-clipboard
    mako
    pavucontrol
    authenticator
    kitty

    # gui packages
    xfce.thunar
    firefox
    rofi-wayland
    krita
    bitwarden
    vesktop
    calibre
    osu-lazer

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
      platformTheme = "gtk";
      style.name = "adwaita-dark";
    };

    gtk = {
      enable = true;
      theme = {
        name = "Gruvbox-Dark-BL";
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
    home.stateVersion = "23.11";
  };

  environment = {
    variables = {
      EDITOR = "neovim";
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

  users.defaultUserShell = pkgs.nushell;

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

  hardware.opengl = {
    ## radv: an open-source Vulkan driver from freedesktop
    driSupport = true;
    driSupport32Bit = true;

    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [pkgs.amdvlk];
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
