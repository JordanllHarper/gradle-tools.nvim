local cmd = vim.api.nvim_create_user_command
local util = require('util')

-- if not buf then
--     buf = vim.api.nvim_create_buf(true, true)
-- end
--
-- if not win then
--     win = vim.api.nvim_open_win(buf, true, { split = 'right' })
-- end


local function on_finish(code)
    local exit_message = ("Gradle finished with exit code"):format("%s: %s", code)
    vim.notify(exit_message)
end

---@param config gradle-tools.Config
function setup_commands(config, buf)
    cmd("Gradle",
        function(local_opts)
            local args = local_opts.fargs

            util.run_job(args, config.command,
                function(_, value) util.append_buf(buf, value) end,
                function(error, _) util.append_buf(buf, error) end,
                function(code, _) on_finish(code) end
            )
        end, {
            nargs = '*',
        })
end
