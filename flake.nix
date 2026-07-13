{
  description = "ThinkPad NixOS with Hyprland and Home Manager";

  inputs = {
    # Основной репозиторий пакетов (unstable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Подключаем системный конфиг
        ./configuration.nix

        # Подключаем home-manager как модуль
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.aptivace = import ./home.nix;
        }
      ];
    };
  };
}
