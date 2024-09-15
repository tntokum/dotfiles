local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>rm", function()
	vim.cmd.RustLsp("expandMacro") -- supports rust-analyzer's grouping
	-- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr })
