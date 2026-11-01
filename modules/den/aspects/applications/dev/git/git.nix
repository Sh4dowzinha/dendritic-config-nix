{ lib, ... }:
{
  den.aspects.applications.dev.git = {
    settings = {
      signing = {
        method = lib.mkOption {
          type = lib.types.enum [
            "none"
            "ssh"
            "openpgp"
          ];
          default = "none";
          description = "Git commit signing method";
        };
      };

      extraIdentities = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              email = lib.mkOption {
                type = lib.types.str;
                description = "Email address for this identity";
              };
              fullName = lib.mkOption {
                type = lib.types.str;
                description = "Full display name for this identity";
              };
              githubUser = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "GitHub username for this identity";
              };
              signingKey = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Signing key for this identity";
              };
              conditions = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Git includeIf condition patterns (e.g. 'gitdir:~/work/')";
              };
            };
          }
        );
        default = [ ];
        description = "Additional conditional Git identities";
      };
    };

    homeManager =
      {
        lib,
        pkgs,
        user,
        ...
      }:
      let
        gitCfg = user.settings.applications.dev.git or { };
        githubUser = user.settings.applications.dev.git.github.username or "";
        signingMethod = gitCfg.signing.method or "none";

        userEmail = user.identity.email or "${user.name}@users.noreply.github.com";
        userFullName = user.identity.displayName or user.name;

        globalSigningKeyObj = lib.findFirst (k: k.tag == "global-signing" || k.tag == "signing") null (
          user.identity.sshKeys or [ ]
        );
        signingKey = if globalSigningKeyObj != null then globalSigningKeyObj.key else null;

        makeGitConfig =
          {
            userName,
            userEmail,
            githubUser ? null,
            signingKey ? null,
            signingMethod ? "none",
          }:
          pkgs.writeText "git-conditional-config" (
            ''
              [user]
                name = "${userName}"
                email = "${userEmail}"
            ''
            + lib.optionalString (signingKey != null && signingKey != "") ''
              signingkey = "${signingKey}"
            ''
            + lib.optionalString (githubUser != null && githubUser != "") ''
              [github]
                user = "${githubUser}"
            ''
          );

        defaultIdentity = {
          email = userEmail;
          fullName = userFullName;
          inherit githubUser;
          signingKey =
            if signingMethod == "ssh" then
              signingKey
            else if signingMethod == "openpgp" then
              user.identity.gpgKey or null
            else
              null;
          conditions = lib.optional (
            githubUser != ""
          ) "hasconfig:remote.*.url:git@github.com:${githubUser}/**";
        };

        allIdentities = [ defaultIdentity ] ++ (gitCfg.extraIdentities or [ ]);
      in
      {
        assertions = [
          {
            assertion = (signingMethod == "ssh") -> (signingKey != null);
            message = "Git signing method is set to 'ssh', but no SSH key with tag 'global-signing' or 'signing' was found in user.identity.sshKeys.";
          }
        ];

        programs.git = {
          enable = true;
          lfs.enable = true;
          signing = {
            signByDefault = signingMethod != "none";
          }
          // lib.optionalAttrs (signingMethod == "openpgp") (
            {
              format = "openpgp";
            }
            // lib.optionalAttrs ((user.identity.gpgKey or null) != null) {
              key = user.identity.gpgKey;
            }
          )
          // lib.optionalAttrs (signingMethod == "ssh") {
            format = "ssh";
            key = signingKey;
          };

          settings = {
            user.name = userFullName;
            user.email = userEmail;
            pull.rebase = true;
            init.defaultBranch = "main";
            push.autoSetupRemote = true;
            merge.conflictstyle = "diff3";
            "url \"git@github.com:\"".pushInsteadOf = "https://github.com/";
            core.autocrlf = "input";
            http.postBuffer = "524288000";
          };

          ignores = [
            ".direnv"
            "result"
            "result-*"
            "#*"
            ".git-bak*"
            "*~"
            "*.swp"
            ".DS_Store"
            "/.helix"
            ".flake"
            ".pkgs"
            ".aider*"
            "!.aider.conf.yml"
            "!.aiderignore"
            ".worktrees"
            ".pre-commit-config.yaml"
            ".claude"
          ];

          includes = lib.pipe allIdentities [
            (builtins.filter (v: v != null))
            (map (
              {
                email,
                fullName,
                githubUser ? null,
                signingKey ? null,
                conditions ? [ ],
              }:
              let
                configFile = makeGitConfig {
                  inherit githubUser signingKey signingMethod;
                  userName = fullName;
                  userEmail = email;
                };
              in
              map (condition: {
                path = configFile;
                inherit condition;
              }) conditions
            ))
            lib.flatten
          ];
        };
      };
  };
}
