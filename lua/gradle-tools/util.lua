local Job = require("plenary.job")
local schedule = vim.schedule

local M = {}

---Appends a line to the end given buffer.
---@param buf number
---@param line string
function M.append_buf(buf, line)
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
end

---Convenience function for starting a new plenary job.
---@param args table
---@param command string
---@param on_stdout? fun(error: string, data: string)
---@param on_stderr? fun(error: string, data: string)
---@param on_exit? fun(code: number, signal: number)
function M.run_job(args, command, on_stdout, on_stderr, on_exit)
    Job:new({
        command = command,
        args = args,
        on_stdout = function(error, data)
            schedule(function()
                if on_stdout then on_stdout(error, data) end
            end)
        end,
        on_stderr = function(error, data)
            schedule(function()
                if on_stderr then on_stderr(error, data) end
            end)
        end,
        on_exit = function(_, code, signal)
            schedule(function()
                if on_exit then on_exit(code, signal) end
            end)
        end
    }):start()
end

return M
