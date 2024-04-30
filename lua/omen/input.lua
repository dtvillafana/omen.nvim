local input = {}

local gpg = require("omen.gpg")
local gopass = require("omen.gopass")

local CANCEL_RETURN = "29bfa101a5784de0907b666c2d5ef510"

function input.clear()
    vim.cmd("mode")
end

function input.decrypt_password(file, prompt)
    local decoded, err = gpg.decrypt(file)
    if not err then
        return decoded
    end
    local passphrase = vim.fn.inputsecret({
        prompt = prompt,
        cancelreturn = CANCEL_RETURN,
    })
    if passphrase == CANCEL_RETURN then
        return
    end
    decoded, err = gpg.decrypt(file, passphrase)
    input.clear()
    if err then
        vim.api.nvim_err_writeln(err)
    end
    return decoded
end

function input.decrypt_otp(file_path, store_path, prompt)
    local decoded, err = gopass.get_otp(file_path, store_path)
    if not err then
        return decoded
    end
    local passphrase = vim.fn.inputsecret({
        prompt = prompt,
        cancelreturn = CANCEL_RETURN,
    })
    if passphrase == CANCEL_RETURN then
        return
    end
    decoded, err = gpg.decrypt(file_path, passphrase)
    input.clear()
    if err then
        vim.api.nvim_err_writeln(err)
    end
    return decoded
end

return input
