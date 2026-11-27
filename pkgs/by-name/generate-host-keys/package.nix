{
  writeShellApplication,
  coreutils,
  git,
  gnupg,
  openssh,
  ssh-to-age,
}:
writeShellApplication {
  name = "generate-host-keys";
  meta.description = "Generate and encrypt an Ed25519 SSH host key for a new host";
  runtimeInputs = [
    coreutils
    git
    gnupg
    openssh
    ssh-to-age
  ];
  text = builtins.readFile ./generate-host-keys.sh;
}
