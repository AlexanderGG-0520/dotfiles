 vim.cmd [[set et ts=2 sts=-1 sw=2 ai si nowrap number]]
 local modules = {"colorscheme","lsp","syntax"}
 local plugins = {}

 for _, mod in ipairs(modules) do
   for _, plugin in ipairs(require("...plugins.".. mod)) do
     plugins[#plugins+1]=plugin
   end
 end

 vim.pack.add(plugins)
