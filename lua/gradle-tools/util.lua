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
---@param on_exit? fun(j: Job, code: number, signal: number)
function M.run_job(args, command, on_stdout, on_stderr, on_exit)
    Job:new({
        command = command,
        args = args,
        on_stdout = function(error, data)
            if on_stdout then
                schedule(function()
                    on_stdout(error, data)
                end)
            end
        end,
        on_stderr = function(error, data)
            if on_stderr then
                schedule(function()
                    on_stderr(error, data)
                end)
            end
        end,
        on_exit = function(j, code, signal)
            if on_exit then
                schedule(function()
                    on_exit(j, code, signal)
                end)
            end
        end
    }):start()
end

return M
