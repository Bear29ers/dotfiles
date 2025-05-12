return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
                        ██████        ██████████          ██████                        
                      ████████████████          ██████████████████                      
                    ████████████                        ████████████                    
                  ████████████                            ████████████                  
                  ██████████                                ██████████                  
                  ████████                                    ████████                  
                    ████        ██████            ██████        ████                    
                      ██      ████████            ████████      ██                      
                      ██    ██████  ██            ██  ██████    ██                      
                      ██    ██████████            ██████████    ██                      
                      ██    ██████████  ████████  ██████████    ██                      
                        ██  ████████    ████████    ████████  ██                        
                        ██    ████                    ████    ██                        
                          ██                                ██                          
                            ██                            ██                            
                              ████                    ████                              
                                ████████████████████████                                
                                ████████        ████████                                
                                ██  ████        ████  ██                                
                                ██                    ██                                
                                ██                    ██                                
                                  ████████████████████                                  
                                  ██████        ██████                                  
                                    ████        ████                                    

                                      [bear27leap]
    ]]
    opts.section.header.val = vim.split(logo, "\n", { trimempty = true })
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file", "<cmd> Telescope find_files <cr>"),
      dashboard.button("n", " " .. " New file", "<cmd> ene <BAR> startinsert <cr>"),
      dashboard.button("r", " " .. " Recent files", "<cmd> Telescope oldfiles <cr>"),
      dashboard.button("g", " " .. " Find text", "<cmd> Telescope live_grep <cr>"),
      dashboard.button("c", " " .. " Config", "<cmd> lua require('lazyvim.util').telescope.config_files()() <cr>"),
      dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      dashboard.button("x", " " .. " Lazy Extras", "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
    }
  end,
}
