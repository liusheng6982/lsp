--[[
根据html文件，生成lua文件
]]
module(..., package.seeall)
class = _M

local io=io;
local print=ngx.say
local parser = require("lsplib.lspparser")

function class:new(obj)
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

--根据传入的html的文件名，生成lua文件
function class:generate(htmlfile,lua_path,luafile)   
    os.execute("mkdir -p "..lua_path)
    local a = parser:new{};
    local _,_,local_path = string.find( htmlfile, "(.+)%/.+%.lsp");
    --print( "local_path="..local_path );
    a.local_path = local_path;
    a:parsefile( htmlfile ); --解析html文件    
    local out = io.open(luafile, "wb")
    if out == nil then
       print( "don'nt open file: ".. luafile);
       return false;
    end
    out:write( "local say=ngx.say;" )
    for i,v in pairs(a.luacontent) do  --遍历解析html文件
        out:write( v )
        --print( i.."="..v )
    end
    --[[for element in list_iter(parser.luacontent) do
	print(element)
        out.write( element );
    end]]

    out:close();
end
