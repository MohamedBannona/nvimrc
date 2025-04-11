return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "BufEnter",
    opts = {
        options = {
            show_close_icons = false,
            separator_style = "slope",
            hover = {
                enabled = true,
                delay = 0,
                reveal = { "close" },
            },
            diagnostics_indicator = function(_, _, diagnostics_dict, context)
                if context.buffer:current() then
                    return ""
                end
                local s = " "
                for e, n in pairs(diagnostics_dict) do
                    local sym = e == "error" and " " or (e == "warning" and " " or " ")
                    s = s .. n .. sym
                end
                return s
            end,
        },
    },
}
