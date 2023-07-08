-- local set_shortcuts = require("shortcuts")

return {
    "nvim-telescope/telescope.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = "Telescope",
    init = function()
        require("shortcuts").set_shortcuts("telescope")
    end,
    -- opts = function()
    -- end,
    config = function(_, opts)
        require("telescope").setup(opts)
    end,
}
