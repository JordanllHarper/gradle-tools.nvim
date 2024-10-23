local M = {}

local lazy = require("gradle-tools.lazy") --- @module "gradle-tools.lazy"
local util = lazy.require('gradle-tools.util') --- @module "gradle-tools.util"

--- @type number
local buf = nil

--- @type number
local win = nil

---@param code number
local function on_finish(code)
    local exit_message = ("Gradle finished with exit code %d"):format(code)
    vim.notify(exit_message)
end


local function run(args, command)
    if not buf then
        buf = vim.api.nvim_create_buf(true, true)
    end
    if not win then
        win = vim.api.nvim_open_win(buf, true, { split = 'right' })
    end

    util.run_job(args, command,
        function(_, value) util.append_buf(buf, value) end,
        function(error, _) util.append_buf(buf, error) end,
        function(code, _) on_finish(code) end
    )
end

---Runs the gradle using a given command and args.
---@param command string
---@param args [string]
function M.run_gradle(command, args)
    local ok, _ = pcall(function()
        run(args, command)
    end)

    if not ok then
        vim.notify(
            "Gradle executable couldn't be found. Make sure you're in a project with a gradle executable.",
            vim.log.levels.ERROR
        )
    end
end

return M
