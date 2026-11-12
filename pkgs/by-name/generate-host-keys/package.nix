{
  writeShellApplication,
  sops,
  ssh-to-age,
  gnupg,
  openssh,
  coreutils,
}:
writeShellApplication {
  name = "generate-host-keys";
  meta.description = "Generate and encrypt SSH host keys for a new host";
  runtimeInputs = [
    sops
    ssh-to-age
    gnupg
    openssh
    coreutils
  ];
  text = builtins.readFile ./generate-host-keys.sh;
}
