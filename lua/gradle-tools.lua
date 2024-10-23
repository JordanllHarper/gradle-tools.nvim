local Job = require("plenary.job")
local cmd = vim.api.nvim_create_user_command
local schedule = vim.schedule

local util = require("util")

--- @type number
local buf = nil

--- @type number
local win = nil

local M = {}

local function on_finish(code)
    vim.notify(string.format("Gradle finished with code: " .. code))
end

-- TODO: Ideas
-- - "Cache" Gradle tasks - so we don't need to run tasks constantly
-- - Allow user config of how gradle is exectuted using user config

---@param config gradle-tools.Config
local function setup_commands(config)
    cmd("Gradle",
        function(local_opts)
            local args = local_opts.fargs

            if not buf then
                buf = vim.api.nvim_create_buf(true, true)
            end

            if not win then
                win = vim.api.nvim_open_win(buf, true, { split = 'right' })
            end

            util.run_job(args, config.command,
                function(_, value) util.append_buf(buf, value) end,
                function(error, _) util.append_buf(buf, error) end,
                function(code, _) on_finish(code) end
            )
        end, {
            nargs = '*',
        })
end

---@param user_opts gradle-tools.Config
function M.setup(user_opts)
    local config = require('config').set(user_opts)
    setup_commands(config)
end

return M
