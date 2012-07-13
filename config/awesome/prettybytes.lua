local math = require("math")

module("prettybytes")

function prettify(bytes)
    local kilobyte = 1024
    local megabyte = kilobyte * 1024
    local gigabyte = megabyte * 1024

    if bytes >= 0 and bytes < kilobyte then
        return bytes .. ' B'
    elseif bytes >= kilobyte and bytes < megabyte then
        return math.floor(bytes / kilobyte) .. ' KB'
    elseif bytes >= megabyte and bytes < gigabyte then
        return math.floor(bytes / megabyte) .. ' MB'
    elseif bytes >= gigabyte then
        return math.floor(bytes / gigabyte) .. ' GB'
    else
        return bytes .. ' B'
    end
end
