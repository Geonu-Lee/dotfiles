-- VSCode 전용 기본 설정

-- 리더 키 설정
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 기본 옵션
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
--vim.opt.scrolloff = 8
vim.opt.scrolloff = 10 -- 커서를 항상 중앙에 유지 (부드러운 느낌)
vim.opt.sidescrolloff = 8

-- VSCode에서 불필요한 설정들은 비활성화
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
