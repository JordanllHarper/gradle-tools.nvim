-- TODO:: Review
--
--- @class gradle-tools.Config
--- @field command string
local M = {}

--- @type gradle-tools.Config
local default = {
    command = "./gradlew"
}

--- @param user_config gradle-tools.Config 
function M.set(user_config)
    if not user_config then
        return default
    end
    return vim.tbl_deep_extend("force", default, user_config)
end

return M
