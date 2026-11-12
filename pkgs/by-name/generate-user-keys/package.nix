{
  writeShellApplication,
  age,
  gnupg,
  coreutils,
}:
writeShellApplication {
  name = "generate-user-keys";
  meta.description = "Generate and encrypt an Age keypair for a user";
  runtimeInputs = [
    age
    gnupg
    coreutils
  ];
  text = builtins.readFile ./generate-user-keys.sh;
}
