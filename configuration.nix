{ config, pkgs, ... }:

{
  # ============================================
  # ЗАГРУЗЧИК И ДИСКИ (btrfs + LUKS)
  # ============================================
  boot.loader.systemd-boot.enable = true;


  # Точки монтирования
  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/sda3";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/sda3";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  # СЕТЬ
  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  # ПОЛЬЗОВАТЕЛЬ
  users.users.aptivace = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.fish;  # Fish как дефолтная оболочка
    initialPassword = "123";
  };

  # sudo без пароля
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ { command = "ALL"; options = [ "PASSWD" ]; } ];
    }
  ];

  # LOGIN MANAGER - LY
  services.greetd = {
    enable = true;
    package = pkgs.greetd.tuigreet;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";  # это специальный пользователь greetd, НЕ bro!
      };
    };
  };

  # HYPRLAND
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # env
  environment.variables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
  };

  # СИСТЕМНЫЕ ПАКЕТЫ
  environment.systemPackages = with pkgs; [
    # Системные утилиты
    git
    vim
    wget
    curl
    htop
    fastfetch
    unzip
    gzip
    udiskie

    # Звук (PipeWire)
    pipewire
    wireplumber
    pulsemixer
  ];

  # ЗВУК
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # ШРИФТЫ

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
    noto-fonts
    noto-fonts-cjk-sans-serif
  ];

  # НАСТРОЙКИ FLAKES
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # ЧАСОВОЙ ПОЯС
  time.timeZone = "Europe/Moscow";

  # ОСТАЛЬНОЕ
  system.stateVersion = "24.11";
}
