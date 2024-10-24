local M = {}

local lazy = require("gradle-tools.lazy")      --- @module "gradle-tools.lazy"
local util = lazy.require('gradle-tools.util') --- @module "gradle-tools.util"
local levels = vim.log.levels

--- @type number
local buf = nil

--- @type number
local win = nil

---@param code number
local function on_finish(code)
    local exit_message = ("Gradle finished with exit code %d"):format(code)
    vim.notify(exit_message)
end


---Runs Gradle using a given command and args.
---@param command string
---@param args [string]
function M.run_gradle(command, args)
    local ok, _ = pcall(function()
        if not buf then
            buf = vim.api.nvim_create_buf(true, true)
        end
        if not win then
            win = vim.api.nvim_open_win(buf, true, { split = 'right' })
        end

        util.run_job(args, command,
            function(_, value) util.append_buf(buf, value) end,
            function(error, _) util.append_buf(buf, error) end,
            function(_, code, _) on_finish(code) end
        )
    end)

    if not ok then
        vim.notify(
            "Gradle executable couldn't be found. Make sure you're in a project with a gradle executable.",
            vim.log.levels.ERROR
        )
    end
end

---@param command string
function M.gradle_tasks(command)
    local contents = ""
    local ok, _ = pcall(function()
        util.run_job({ "tasks" }, command,
            function(_, value) contents = contents .. value end,
            function(_, value)
                -- local error_message = "Eek"
                print(value)

                -- vim.notify(error_message, levels.ERROR, {})
            end,
            function(_, code, _)
                vim.notify(contents, levels.ERROR)
                on_finish(code)
            end
        )
    end)




    if not ok then
        vim.notify(
            "Gradle executable couldn't be found. Make sure you're in a project with a gradle executable.",
            vim.log.levels.ERROR
        )
    end
end

return M
