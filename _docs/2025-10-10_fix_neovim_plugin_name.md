# Neovim Plugin Name Fix

- **Date:** 2025-10-10
- **Author:** Gemini

## Summary

After updating Neovim and LazyVim, a warning message appeared indicating that the plugin `williamboman/mason.nvim` has been renamed to `mason-org/mason.nvim`.

This implementation fixes the warning by updating the plugin name in the Neovim configuration files.

## Changes

- Updated `/Users/bear29ers/dotfiles/.config/nvim/lua/plugins/lsp.lua` to replace `williamboman/mason.nvim` with `mason-org/mason.nvim`.
- Updated `/Users/bear29ers/dotfiles/.config/nvim/lua/plugins/example.lua` to replace `williamboman/mason.nvim` with `mason-org/mason.nvim`.
