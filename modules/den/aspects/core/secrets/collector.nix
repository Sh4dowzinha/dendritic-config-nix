{
  den.aspects.core.secrets.collector =
    let
      collect =
        lib: sops-secrets:
        let
          merged = lib.mergeAttrsList (map (m: m.sops.secrets or { }) sops-secrets);
        in
        /*
          Do not emit `sops.secrets = {}`.

          This matters for hosts where the collector exists but the
          SOPS backend is not actually needed.
        */
        lib.optionalAttrs (merged != { }) {
          sops.secrets = merged;
        };
    in
    {
      nixos =
        {
          sops-secrets ? [ ],
          lib,
          ...
        }:
        collect lib sops-secrets;

      darwin =
        {
          sops-secrets ? [ ],
          lib,
          ...
        }:
        collect lib sops-secrets;
    };
}
