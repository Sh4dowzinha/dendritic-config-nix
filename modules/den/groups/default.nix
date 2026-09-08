# Group definitions — user roles, system gates, service access, and POSIX groups.
{
  den.groups = {
    # User role groups (identity & login gates)
    admins = {
      labels = [
        "user-role"
      ];
      description = "Full administrative access";
    };
    users = {
      labels = [
        "user-role"
      ];
      description = "Standard user access";
      members = [ "admins" ];
    };

    # POSIX groups (Unix permissions with gidNumber)
    wheel = {
      labels = [ "posix" ];
      gid = 10;
      description = "Sudo access";
      members = [ "admins" ];
    };
    audio = {
      labels = [ "posix" ];
      gid = 63;
      description = "Audio device access";
      members = [ "users" ];
    };
    video = {
      labels = [ "posix" ];
      gid = 44;
      description = "Video device access";
      members = [ "users" ];
    };
    networkmanager = {
      labels = [ "posix" ];
      gid = 84;
      description = "NetworkManager control";
      members = [ "admins" ];
    };
    input = {
      labels = [ "posix" ];
      gid = 40;
      description = "Input device access";
      members = [ "users" ];
    };
    tty = {
      labels = [ "posix" ];
      gid = 5;
      description = "TTY access";
      members = [ "admins" ];
    };
    podman = {
      labels = [ "posix" ];
      gid = 993;
      description = "Container runtime access";
      members = [ "admins" ];
    };
    media = {
      labels = [ "posix" ];
      gid = 900;
      description = "Media files access";
      members = [ "admins" ];
    };
    gamemode = {
      labels = [ "posix" ];
      gid = 981;
      description = "GameMode access";
      members = [ "users" ];
    };
    render = {
      labels = [ "posix" ];
      gid = 106;
      description = "GPU render access";
      members = [ "admins" ];
    };
    libvirtd = {
      labels = [ "posix" ];
      gid = 901;
      description = "VM management access";
      members = [ "admins" ];
    };
    kvm = {
      labels = [ "posix" ];
      gid = 902;
      description = "KVM hypervisor access";
      members = [ "admins" ];
    };
  };
}
