--[[
根据访问路径，调用lua
]]
module( ..., package.seeall )

local print=ngx.say

local class = _M


local generator = require("lsplib.generator")

--用户的url及对应的处理方法，url, 业务处理, html模板(可有可无),在urlconf.lua中定义
class.urlmap = {
    --['/lua/test']  = {'lua.binz.test.test()',        'lsp/lua/hello.lsp' }
    --['/lua/query'] = {'lua.binz.test:query()',       'lsp/blog/qurey.lsp' }
}
--获取访问的路径,去掉后面的参数？
function class:process() 
    --print( ngx.var.uri )   
    local _,_, url = string.find( ngx.var.uri, "(.+)%?*" )
    if url ~= nil then   
        local  lua_table = urlmap[url];
        if lua_table ~= nil then
            local  lua_process_name = lua_table[1] ; --根据url获取处理名
            if lua_process_name ~= nil then   --如果处理不为空
                --分离包名与处理方法
                local _,_,mod_name, func_name = string.find(lua_process_name, "(.+)%.(.+)%(%)" )
		--print( "mod_name="..mod_name, "     func_name="..func_name); 
                if mod_name ~= nil then  --module名称
                    local mod = require( mod_name ) --加载module,如果没有，则会报错，如何处理这个异常? 
                    if func_name ~= nil then
                        local f = mod[func_name];
			if f ~= nil then
                            f();   --调用业务方法
			end
                        if lua_table[2] ~= nil then
                            local lspname = lua_table[2];
                            local lsp_home = os.getenv("LSP_HOME")
   		            if lsp_home == nil then
       				 print( "please set lsp_home" )
				return;					
   			    end
		            class:render( lsp_home..'/'..lspname  )--跳转页面
                        end
                    else
                           print( "mod中没有处理方法")
                    end                  
                end 
            else
                 print("没有定义处理mod")
            end
         else
            print("找不到对应的URL定义")
         end
    else
        print("url 出错")
    end
    
end

function class:render(lspname)    
    -- lsp/lua/test/hello.html
    --print("lspname=" ..lspname );
    local lsp_home = os.getenv("LSP_HOME")
    if lsp_home == nil then
        print( "please set lsp_home" )
        return;
    end
    local _,_,path,filename = string.find( lspname, ".+/(.+)%/(.+)%.lsp" );
    local lsp_lua = lsp_home..'/work/'..path.."/"..filename.."_lsp.lua";
    --print( "lsp_lua=" .. lsp_lua);
    if not class:file_exists( lsp_lua ) then
        local success = generator:new({}):generate(lspname,lsp_home..'/work/'..path.."/", lsp_lua);
        if success == false then
	    return;
	end
    end
    dofile( lsp_lua )
    
end

function class:file_exists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end


--process();




