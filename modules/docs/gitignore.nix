{
  perSystem = {
    files.file.".gitignore".text = ''
      /result
      /result.*
      .direnv
      .cache
      .pre-commit-config.yaml
    '';
  };
}
