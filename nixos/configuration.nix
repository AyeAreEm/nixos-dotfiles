{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true; # nmcli dev wifi con <ssid-name> password <password>

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Australia/Brisbane";

  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Don't forget to set a password with `passwd`.
  users.users.adrian = {
    isNormalUser = true;
    description = "Adrian Mehta";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  # don't touch, tried to remove but it breaks... i think it's because my login thing actually uses xserver instead of hyprland
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = ["nvidia"];
  };

  # nvidia drivers, don't touch
  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    graphics.enable = true;

    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  # setup apps n stuff
  environment.systemPackages = with pkgs; [
    # cli 
    wget
    curl
    unzip
    file
    btop
    fastfetch
    playerctl
    brightnessctl

    # system
    rofi
    hyprpaper
    waybar
    grim
    slurp
    oh-my-posh

    # steam / gaming
    protonup # run protonup
    prismlauncher # minecraft

    # apps
    discord
    firefox
    spotify
    gimp
    libreoffice-qt

    # dev
    vim
    ghostty

    # languages
    # NOTE: do you really want a language to be system wide? maybe make a dev env instead of installing globally
  ];

  # hyprland
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # for electron apps

  # steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/adrian/.steam/root/compatibilitytools.d";

  # neovim
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # git config --global init.defaultBranch main
  # git config --global user.email "ag.ayeareem@gmail.com"
  # git config --global user.name "AyeAreEm"
  programs.git = {
    enable = true;
  };

  # this is mainly to let neovim mason to work
  # it lets dynamic execs to run so technically could be used for stuff besides
  # neovim but not gonna do that
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];

  # fonts, maybe only get a few nerdfonts cuz all of them is like 2gb
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    nerdfonts
  ];

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  # flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
