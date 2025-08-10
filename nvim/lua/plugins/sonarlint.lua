return {
	-- 从 GitLab 安装插件，需要提供完整的 Git URL
	"https://gitlab.com/schrieveslaach/sonarlint.nvim.git",

	-- lazy.nvim 的 config 函数会在插件加载后运行
	config = function()
		-- 确保这部分配置在 lspconfig 的基础配置之后加载
		-- LazyVim 会处理好加载顺序，所以通常不需要担心
		require("sonarlint").setup({
			server = {
				-- 这是配置的核心部分，它告诉插件如何启动
				-- mason.nvim 安装的 sonarlint-language-server
				cmd = {
					"sonarlint-language-server", -- mason 安装的可执行文件
					"-stdio", -- 通过标准输入输出与 Neovim 通信
					"-analyzers", -- 指定分析器的路径

					-- 重点：这里需要列出您希望使用的分析器 .jar 文件。
					-- 这些文件也由 mason.nvim 管理。
					-- 以下是针对 Python, C/C++, 和 Java 的示例。
					-- 您可以根据需要添加或删除。
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),

					-- 如果您需要分析其他语言，请在这里添加对应的 .jar 文件路径，例如:
					-- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"), -- for JavaScript/TypeScript
					-- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"), -- for HTML
				},
			},
			-- 指定您希望 SonarLint 自动分析的文件类型
			-- 这里的列表应与您在上面 cmd 中指定的分析器相对应
			filetypes = {
				-- "python",
				-- "cpp",
				-- "c",
				"java",
				-- 'javascript',
				-- 'typescript',
				-- 'html',
			},
		})
	end,
}
