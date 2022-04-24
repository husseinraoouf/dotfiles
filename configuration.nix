
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  nix = {
    package = pkgs.nixFlakes;
    autoOptimiseStore = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.e nable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = false;
    nvidiaWayland = false;
  };
  services.xserver.displayManager.defaultSession = "gnome-xorg";
  services.xserver.desktopManager.gnome = {
    enable = true;
  };


  # Configure keymap in X11
  services.xserver.layout = "us, ara";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
  hardware.pulseaudio.support32Bit = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.zeroconf.discovery.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.clickMethod = "buttonareas";
  services.xserver.libinput.touchpad.scrollMethod = "twofinger";
  services.xserver.libinput.touchpad.naturalScrolling = true;
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services.xserver.libinput.touchpad.tapping = true;



  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # services.xserver.displayManager.autoLogin.enable = false;
  # users.mutableUsers = false;
  users.users.hussein = {
    isNormalUser = true;
    hashedPassword = "$6$CiJDXxbrXukW526d$NAoLD6myNmyU85wxQJfWu2N6IC1z9r/bdeAxxLvWyi0JprntpRzggxl6pH/kQrkqgjxo0/wtnkvAQfQrdTYuR1";
    extraGroups = [ "wheel" "audio" "sound" "pulse" "video" "networkmanager" "input" "tty" "docker" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    beekeeper-studio
    kubectl
    lens
    unstable.kubernetes-helm
    unstable.terraform


    (dotnetCorePackages.combinePackages [
      dotnet-sdk
      dotnet-sdk_5
      dotnet-sdk_3
    ])

    unstable.git
    unstable.nodejs
    unstable.nodePackages.node-gyp
    unstable.nodePackages.node-gyp-build
    unstable.nodePackages.node-pre-gyp
    unstable.yarn

    unstable.go

    rustc
    cargo

    unstable.awscli2
    unstable.azure-cli

    unstable.teams
    remmina

    unstable.discord

    unstable.tdesktop

    obsidian

    icu

    vagrant

    rpi-imager

    postman

    pkgs.unixODBC
    pkgs.unixODBCDrivers.msodbcsql17
    (pkgs.python39.withPackages
      (ps: with ps; [ pip setuptools ]))
    virtualenv
    ansible
    python39Packages.pywinrm
    python39Packages.netaddr
    python39Packages.jinja2

    nodePackages.grunt-cli

    pavucontrol

    gnome.gnome-tweaks
    gnomeExtensions.tray-icons-reloaded
    gnome.gnome-shell-extensions

    libreoffice-fresh

    direnv
    nix-direnv

    zoom

    gcc

    unstable.flyctl
    unstable.dive

    jdk

    p7zip

    lshw
    jq

    unstable.mongodb-compass
    gparted

    nixpkgs-fmt
  
    wireguard 
    wireguard-tools

    unstable.mullvad
    unstable.mullvad-vpn

    unstable.bottles

    lshw
    busybox

    ngrok
  ];

  environment.variables.JAVA_HOME = pkgs.jdk.home;

  # nix options for derivations to persist garbage collection
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  # if you also want support for flakes (this makes nix-direnv use the
  # unstable version of nix):
  nixpkgs.overlays = [
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; })
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        icu
      ];
    };
  };

  programs.steam.enable = true;
  services.teamviewer.enable = true;
  virtualisation.docker.enable = true;

  programs.adb.enable = true;

#  hardware.nvidia.modesetting.enable = true;
#  # hardware.nvidia.powerManagement.enable = true;
#  hardware.nvidia.nvidiaPersistenced = true;
#  services.xserver = {
#    videoDrivers = [ "nvidia" ];
  #  config = ''
  #   Section "OutputClass"
  #     Identifier "nvidia"
  #     MatchDriver "nvidia-drm"
  #     Driver "nvidia"
  #     Option "AllowEmptyInitialConfiguration"
  #     # ModulePath "/usr/lib/x86_64-linux-gnu/nvidia/xorg"
  #   EndSection

  #   Section "Device"
  #     Identifier  "Intel Graphics"
  #     Driver      "intel"
  #     #Option      "AccelMethod"  "sna" # default
  #     #Option      "AccelMethod"  "uxa" # fallback
  #     Option      "TearFree"        "true"
  #     Option      "SwapbuffersWait" "true"
  #     BusID       "PCI:0:2:0"
  #     #Option      "DRI" "2"             # DRI3 is now default
  #   EndSection

  #   Section "Device"
  #     Identifier "nvidia"
  #     Driver "nvidia"
  #     BusID "PCI:1:0:0"
  #     Option "AllowEmptyInitialConfiguration"
  #   EndSection
  #  '';

  #   screenSection = ''
  #     Identifier     "Screen0"
  #     Device         "Device0"
  #     Monitor        "Monitor0"
  #     DefaultDepth   24
  #     Option         "Stereo" "0"
  #     Option         "nvidiaXineramaInfoOrder" "DFP-5"
  #     Option         "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
  #     # Option         "AllowIndirectGLXProtocol" "off"
  #     # Option         "TripleBuffer" "on"
  #     Option         "SLI" "Off"
  #     Option         "MultiGPU" "Off"
  #     Option         "BaseMosaic" "off"
  #     SubSection     "Display"
  #     Depth          24
  #     EndSubSection
  #   '';
#  };

#  hardware.nvidia.prime = {
#    sync.enable = true;

#    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
#    nvidiaBusId = "PCI:1:0:0";

#    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
#    intelBusId = "PCI:0:2:0";
#  };

  hardware.opengl.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  services.samba = {
    enable = true;
    enableNmbd = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = Samba Server
      server role = standalone server
      log file = /var/log/samba/smbd.%m
      max log size = 50
      dns proxy = no
      map to guest = Bad User
    '';
    shares = {
      public = {
        path = "/mnt/projects/share";
        browseable = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "yes";
        "public" = "yes";
        # "force user" = "share";
      };
    };
  };
  # services.nebula.networks = {
  #   home = {
  #     enable = true;
  #     isLighthouse = true;
  #   };
  # };
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
  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;
  # boot.kernelModules = [ "binder_linux" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  security.sudo.wheelNeedsPassword = false;


  # networking.wireguard.interfaces = {
  #   # "wg0" is the network interface name. You can name the interface arbitrarily.
  #   wg0 = {
  #     # Determines the IP address and subnet of the client's end of the tunnel interface.
  #     ips = [ "10.67.163.188/32" "fc00:bbbb:bbbb:bb01::4:a3bb/128" ];
  #     listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

  #     # Path to the private key file.
  #     #
  #     # Note: The private key can also be included inline via the privateKey option,
  #     # but this makes the private key world-readable; thus, using privateKeyFile is
  #     # recommended.
  #     # privateKeyFile = "path to private key file";
  #     privateKey = "uCfyUjQboFFeLqT1QS1dZN6GA0cdFCckyq3MO+mzN3s=";

  #     peers = [
  #       # For a client configuration, one peer entry for the server will suffice.

  #       {
  #         # Public key of the server (not a file path).
  #         publicKey = "fOrw0hU1D3Wc2A7AsLVdozlDlxwYOHZo6ZJ9OiNmGxU=";
  #         # presharedKey = "6MemasSoZYn/7zydMFYuXF7uw7J5QPPoSQVKW744mBM=";

  #         # Forward all the traffic via VPN.
  #         # allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #         allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #         # Or forward only particular subnets
  #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

  #         # Set this to the server IP and port.
  #         endpoint = "138.199.15.162:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

  #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };
}

