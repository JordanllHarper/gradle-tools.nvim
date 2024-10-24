local M = {}

--Vim imports
local cmd = vim.api.nvim_create_user_command

--Modules
local lazy = require('gradle-tools.lazy')              --- @module "gradle-tools.lazy"
local commands = lazy.require('gradle-tools.commands') --- @module "gradle-tools.commands"
local config = lazy.require('gradle-tools.config')     --- @module "gradle-tools.config"

-- TODO: Ideas
-- - "Cache" Gradle tasks - so we don't need to run tasks constantly

---@param local_config gradle-tools.Config
local function setup_commands(local_config)
    cmd("Gradle", function(args) commands.run_gradle(local_config.command, args.fargs) end, { nargs = '*' })
    cmd("GradleTasks", function() commands.gradle_tasks(local_config.command) end, {})
end

---@param user_opts gradle-tools.Config
function M.setup(user_opts)
    local local_config = config.set(user_opts)
    setup_commands(local_config)
end

return M
