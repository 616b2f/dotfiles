local snippets = require('snippets')
local U = require('snippets.utils')
snippets.snippets = {
    lua = {
        req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']];
        func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]];
        ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]];
        -- Match the indentation of the current line for newlines.
        ["for"] = U.match_indentation [[
for ${1:i}, ${2:v} in ipairs(${3:t}) do
    $0
end]];
    };
    cs = {
        ["class"] = U.match_indentation [[
private class $1
{
    $0
}]];
        ["pclass"] = U.match_indentation [[
public class $1
{
    $0
}]];
        ["prop"] = U.match_indentation [[public $1 $2 { get; set; }]];
        func = U.match_indentation [[
private ${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})
{
    $0
}]];
        pfunc = U.match_indentation [[
public ${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})
{
    $0
}]];
        ["for"] = U.match_indentation [[
for (${1:i} in ${2:t})
{
    $0
}]];
        };
        _global = {
            -- If you aren't inside of a comment, make the line a comment.
            copyright = U.force_comment [[Copyright (C) Ashkan Kiani ${=os.date("%Y")}]];
    };
}
