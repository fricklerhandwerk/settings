{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      l = "ls -la --color=tty";
      ll = "ls -lah --color=tty";
      ".." = "cd ..";
    };
    plugins = with pkgs.fishPlugins; [
      {
        name = "foreign-env";
        src = foreign-env.src;
      }
    ];
    shellAbbrs = {
      e = "emacs";
      gl = "git log";
      gsh = "git show";
      gst = "git status";
      gd = "git diff";
      gdc = "git diff --cached";
      ga = "git add";
      gc = "git commit";
      gr = "git rebase";
      gri = "git rebase -i";
      grc = "git rebase --continue";
      gra = "git rebase --abort";
      gm = "git mergetool";
      gpl = "git pull";
      gpr = "git pull --rebase";
      gf = "git fetch";
      gfr = "git fetch; and git rebase";
      gp = "git push";
      gco = "git checkout";
    };
    interactiveShellInit = ''
      function upload
        rsync -a --partial --progress $argv webgo:www/fricklerhandwerk/temp/
        for arg in $argv
          echo https://fricklerhandwerk.de/temp/(basename $arg)
        end
      end
      # update remote machine's configuration
      function rebuild
        nixos-rebuild --target-host root@$argv[1] switch -I nixos-config=$HOME/src/nixos/machines/$argv[1] -I nixpkgs=$HOME/src/nixos --show-trace --option tarball-ttl 0
      end
    '';
  };
}
