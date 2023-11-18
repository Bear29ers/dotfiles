local status, bufferline = pcall(require, 'bufferline')
if (not status) then return end

local colors = require('onedark.palette')

bufferline.setup({
  options = {
    mode = 'tabs',
    separator_style = 'slant',
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true,
    diagnostics = 'nvim_lsp',
    -- Diagnostics indicator settings inside tabs
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = ' '
      for e, n in pairs(diagnostics_dict) do
        local sym = e == 'error' and ' '
          or e == 'warning' and ' '
          or (e == 'hint' and ' ' or '')
        s = s .. n .. sym
      end
      return s
    end,
    custom_areas = { -- Setting custom areas (right place)
      right = function()
        local result = {}
        local seve = vim.diagnostic.severity
        local error = #vim.diagnostic.get(0, {severity = seve.ERROR})
        local warning = #vim.diagnostic.get(0, {severity = seve.WARN})
        local info = #vim.diagnostic.get(0, {severity = seve.INFO})
        local hint = #vim.diagnostic.get(0, {severity = seve.HINT})

        if error ~= 0 then
            table.insert(result, {text = '  ' .. error, fg = colors.darker.red})
        end

        if warning ~= 0 then
            table.insert(result, {text = '  ' .. warning, fg = colors.darker.yellow})
        end

        if hint ~= 0 then
            table.insert(result, {text = '  ' .. hint, fg = colors.darker.purple})
        end

        if info ~= 0 then
            table.insert(result, {text = '  ' .. info, fg = colors.darker.blue})
        end
        return result
      end,
    }
  },
  highlights = { -- Tab highlights settings
    separator = {
      fg = colors.darker.bg0,
      bg = colors.darker.black,
    },
    separator_selected = {
      fg = colors.darker.bg0,
    },
    background = {
      fg = colors.darker.light_grey,
      bg = colors.darker.black
    },
    buffer_selected = {
      fg = colors.darker.fg,
      bold = true,
    },
    modified = {
      bg = colors.darker.black
    },
    duplicate = {
      fg = colors.darker.dark_red,
      bg = colors.darker.black
    },
    duplicate_selected = {
      fg = colors.darker.red
    },
    diagnostic = {
      bg = colors.darker.black
    },
    error = {
      fg = colors.darker.dark_red,
      bg = colors.darker.black
    },
    error_diagnostic = {
      fg = colors.darker.dark_red,
      bg = colors.darker.black
    },
    error_diagnostic_selected = {
      fg = colors.darker.red
    },
    warning = {
      fg = colors.darker.dark_yellow,
      bg = colors.darker.black
    },
    warning_diagnostic = {
      fg = colors.darker.dark_yellow,
      bg = colors.darker.black
    },
    warning_diagnostic_selected = {
      fg = colors.darker.yellow
    },
    hint = {
      fg = colors.darker.dark_purple,
      bg = colors.darker.black
    },
    hint_diagnostic = {
      fg = colors.darker.dark_purple,
      bg = colors.darker.black
    },
    hint_diagnostic_selected = {
      fg = colors.darker.purple
    },
    info = {
      fg = colors.darker.dark_blue,
      bg = colors.darker.black
    },
    info_diagnostic = {
      fg = colors.darker.dark_blue,
      bg = colors.darker.black
    },
    info_diagnostic_selected = {
      fg = colors.darker.blue
    },
    fill = {
      bg = colors.darker.black,
    }
  },
})

vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
