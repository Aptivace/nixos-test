{ config, pkgs, ... }:

{
  # FISH SHELL (главная оболочка)
  programs.fish = {
    enable = true;

    # Интерактивные настройки
    shellInit = ''
      set -g fish_greeting             # Убираем приветствие
      fish_config theme choose "Dracula"  # Если хочешь тему
    '';

    # Плагины для Fish
    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];

    # Алиасы (как в bash)
    shellAliases = {
      ll = "ls -la";
      l = "ls -l";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      cat = "bat";     # если поставишь bat
      nixup = "sudo nix flake update && sudo nixos-rebuild switch --flake .#thinkpad";
    };
  };

  # ПАКЕТЫ ДЛЯ ПОЛЬЗОВАТЕЛЯ
  home.packages = with pkgs; [
    kitty          # или любой другой

    # Браузер
    firefox

    # Файловый менеджер
    thunar
    gvfs           # для монтирования дисков в Thunar

    # Редакторы
    neovim
    nano

    # Утилиты
    tree
    jq

    # Изображения
    feh            # просмотрщик
    grim           # скриншоты (Wayland)
    slurp          # выделение области для скриншотов

    # Мультимедиа
    mpv
    ffmpeg
  ];

  # ХРАНЕНИЕ SECRETS (опционально)
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # КОНФИГИ ДЛЯ ПРОГРАММ (через home-manager)
  programs.git = {
    enable = true;
    userName = "Bro";
    userEmail = "bro@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  # Neovim минимальный конфиг (с нуля)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };


  # ДОМАШНИЕ КАТАЛОГИ
  home.stateVersion = "24.11";
}
