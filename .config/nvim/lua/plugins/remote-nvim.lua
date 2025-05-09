local ssh_config = {
  ssh_binary = "ssh",
  scp_binary = "scp",
  ssh_config_file_paths = { "$HOME/.ssh/config" },
  ssh_prompts = {
    {
      match = "Enter passphrase for key",
      type = "secret",
      value_type = "static",
      value = "",
    },
    {
      match = "password:",
      type = "secret",
      value_type = "static",
      value = "",
    },
    {
      match = "continue connecting (yes/no/[fingerprint])?",
      type = "plain",
      value_type = "static",
      value = "",
    },
  },
}

return {
  "amitds1997/remote-nvim.nvim",
  version = "*", -- Pin to GitHub releases
  dependencies = {
    "nvim-lua/plenary.nvim", -- For standard functions
    "MunifTanjim/nui.nvim", -- To build the plugin UI
    "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
  },
  config = function()
    -- プラグインの基本設定
    require("remote-nvim").setup({
      ssh = ssh_config,
    })

    -- キーマッピングの設定
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Remote commands
    keymap("n", "<leader>rs", ":RemoteStart<CR>", opts) -- リモートインスタンスに接続する。リモートneovimサーバーがすでに実行されている場合、ユーザーはローカルクライアントを起動できる。
    keymap("n", "<leader>rq", ":RemoteStop<CR>", opts) -- Neovimサーバーの実行を停止し、セッションを閉じる。
    keymap("n", "<leader>ri", ":RemoteInfo<CR>", opts) -- 現在の Neovim 実行で作成されたセッションに関する情報を取得する。進行状況ビューアーを開く。
    keymap("n", "<leader>rc", ":RemoteCleanup<CR>", opts) -- リモートインスタンスからワークスペースおよびリモートneovimセットアップ全体を削除する。また，リモートリソースの構成をクリーンアップする。
    keymap("n", "<leader>rd", ":RemoteConfigDel<CR>", opts) -- 保存されたセッションレコードから、存在しなくなったリモートインスタンスのレコードを削除する
    keymap("n", "<leader>rl", ":RemoteLog<CR>", opts) -- プラグインのログファイルを開く。エラーが出たらここ見れば大体わかる。
  end,
}
