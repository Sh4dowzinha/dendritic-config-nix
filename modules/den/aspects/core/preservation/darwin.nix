# Dummy persistence options for Darwin so modules that reference
# osConfig.preservation.preserveAt don't error out.
{ lib, ... }:
{
  den.aspects.core.preservation = {
    darwin = _: {
      options.preservation.preserveAt = lib.mkOption {
        type = lib.types.anything;
        default = { };
        description = "Dummy persistence option for Darwin (no-op).";
      };
    };
  };
}
