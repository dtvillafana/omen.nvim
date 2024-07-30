local gopass = {}

local path = require("omen.path")

local errors = require("omen.errors")

local Job = require("plenary.job")

---Decrypts given encrypted file with a passphrase.
---gopass decrypts the file without a passphrase if there is a valid cache.
---So the function can be used without the passphrase parameter safely.
---@param file_path string @File to be decrypted
---@param passphrase string?
---@param store_path string?
---@return string|nil @First line of decoded content
---@return string|nil @Error
function gopass.get_otp(file_path, store_path, passphrase)
    passphrase = passphrase or ""

    local function get_gopass_url(first_string, second_string)
        local keep_len = #first_string - #second_string
        local result = string.sub(first_string, -keep_len)
        return result
    end
    local gopass_url = get_gopass_url(path.remove_gpg_ext(file_path), store_path):gsub("stores/root/", "")
    local job = Job:new({
        command = "gopass",
        args = {
            "otp",
            "--password",
            gopass_url,
        },
        writer = passphrase,
    })
    job:sync()

    for _, line in ipairs(job:stderr_result()) do
        if line:find("Bad passphrase") then
            return nil, errors.BAD_PASSPHRASE
        end
    end

    local result = job:result()
    if #result == 0 then
        return nil, errors.EMPTY_RESULT
    end

    return result[1]
end

return gopass
