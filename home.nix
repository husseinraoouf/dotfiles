{ config, pkgs, repo, ... }:
let
  vscode-extenstions = import ./extra/vscode-extenstions.nix;
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hussein";
  home.homeDirectory = "/home/hussein";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  programs.git = {
    enable = true;
    userName = "ElHussein Abdelraouf";
    userEmail = "hussein@raoufs.me";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = [ repo.packages.x86_64-linux.ms-dotnettools.csharp pkgs.vscode-extensions.ms-vsliveshare.vsliveshare ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace vscode-extenstions.extensions;
    keybindings = [ ];
    # mutableExtensionsDir = true;
    userSettings = builtins.fromJSON ''
      {
        "omnisharp.useModernNet": true,
        "cSpell.userWords": ["setvariable"],
        "[jsonc]": {
          "editor.defaultFormatter": "esbenp.prettier-vscode"
        },
        "[yaml]": {
          "editor.defaultFormatter": "esbenp.prettier-vscode"
        },
        "[javascript]": {
          "editor.defaultFormatter": "esbenp.prettier-vscode"
        },
        "[json]": {
          "editor.defaultFormatter": "esbenp.prettier-vscode"
        }
      }
      '';
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export PATH=~/.npm-packages/bin:$PATH
      export NODE_PATH=~/.npm-packages/lib/node_modules
      eval "$(direnv hook bash)"


      export PATH=~/go/bin:$PATH
    '';
  };
}
