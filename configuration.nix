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
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  services.displayManager.ly.enable = true;

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

  # НАСТРОЙКИ FLAKES
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  hardware.enableRedistributableFirmware = true;

  # ЧАСОВОЙ ПОЯС
  time.timeZone = "Europe/Moscow";

  # ОСТАЛЬНОЕ
  system.stateVersion = "26.05";
}
