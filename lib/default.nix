
{inputs}: let
  inherit (inputs.nixpkgs) legacyPackages;
in rec {
  mkVimPlugin = {system}: let
    inherit (pkgs) vimUtils;
    inherit (vimUtils) buildVimPlugin;
    pkgs = legacyPackages.${system};
  in
    buildVimPlugin {

      buildInputs = with pkgs; [nodejs];

      dependencies = with pkgs.vimPlugins; [
        # languages
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        rust-tools-nvim

        # telescope
        plenary-nvim
        telescope-nvim

        # theme
        tokyonight-nvim

        # floaterm
        vim-floaterm

        # blink
        blink-cmp

        # extras
        luasnip
        cmp_luasnip
        lspkind-nvim

        gitsigns-nvim
        lualine-nvim
        comment-nvim
        noice-nvim
        nvim-colorizer-lua
        nvim-notify
        nvim-treesitter-context
      ];

      name = "kirre";
      postInstall = ''
        rm -rf $out/.envrc
        rm -rf $out/.gitignore
        rm -rf $out/flake.lock
        rm -rf $out/flake.nix
        rm -rf $out/justfile
        rm -rf $out/lib
      '';
      src = ../.;
    };

  mkNeovimPlugins = {system}: let
    inherit (pkgs) vimPlugins;
    pkgs = legacyPackages.${system};
    kirre02-nvim = mkVimPlugin {inherit system;};
  in [
    # languages
    vimPlugins.vim-just
    vimPlugins.zig-vim

    #extras
    vimPlugins.rainbow-delimiters-nvim
    vimPlugins.trouble-nvim


    # configuration
    kirre02-nvim
  ];

  mkExtraPackages = {system}: let
    inherit (pkgs) nodePackages ocamlPackages python3Packages;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in [
    # language servers
    nodePackages.bash-language-server
    nodePackages.diagnostic-languageserver
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    pkgs.gopls
    pkgs.lua-language-server
    pkgs.nil
    pkgs.nls
    pkgs.postgres-lsp
    pkgs.pyright
    pkgs.rust-analyzer
    pkgs.terraform-ls
    pkgs.zls

    # formatters
    pkgs.alejandra
    pkgs.gofumpt
    pkgs.golines
    pkgs.rustfmt
    pkgs.terraform
    python3Packages.black
  ];

  mkExtraConfig = ''
    lua << EOF
      require 'kirre'.init()
    EOF
  '';

  mkNeovim = {system}: let
    inherit (pkgs) lib neovim;
    extraPackages = mkExtraPackages {inherit system;};
    pkgs = legacyPackages.${system};
    start = mkNeovimPlugins {inherit system;};
  in
    neovim.override {
      configure = {
        customRC = mkExtraConfig;
        packages.main = {inherit start;};
      };
      extraMakeWrapperArgs = ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };

  mkHomeManager = {system}: let
    extraConfig = mkExtraConfig;
    extraPackages = mkExtraPackages {inherit system;};
    plugins = mkNeovimPlugins {inherit system;};
  in {
    inherit extraConfig extraPackages plugins;
    defaultEditor = true;
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
