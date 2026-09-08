{
  perSystem = {
    files.file.".gitignore".text = ''
      /result
      /result.*
      .direnv
      .cache
      .claude
      CLAUDE.md
      .pre-commit-config.yaml
    '';
  };
}
