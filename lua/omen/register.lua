local register = {}

---Fills a register given content with a retention
---@param regchar string @Register char string
---@param content string @Content to be stored in register
---@param retention integer @Retention to remove the content in seconds
---@param type string @Type type of object being copied to register
function register.fill_with_retention(regchar, content, retention, type)
    local msg
    if regchar == "+" then
        local fmt = "%s copied to clipboard"
        msg = fmt:format(type)
    else
        local fmt = "Filled register %s"
        msg = fmt:format(regchar)
    end
    print(msg)
    vim.fn.setreg(regchar, content, "c")

    vim.defer_fn(function()
        vim.fn.setreg(regchar, "", "c")
        print(("Cleared register %s"):format(regchar))
    end, retention * 1000)
end

return register
