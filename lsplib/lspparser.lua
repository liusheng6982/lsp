--[[
解析html,根据标签，把生成的lua语名放入luacontent
]]
module(..., package.seeall)


--[[
这样做就是让文件名作为包名，适不适这样做，不确定，请高手指点
好处：文件名改了，包名跟着修改
]]
local class = _M

local io=io
local print=ngx.say

class.print="say"
class.eqTag="="
class.includeTag="include" 
class.startTag="<%%"
class.endTag="%%>"
class.luacontent={}
class.local_path=""

function class:new(obj)
	obj = obj or {}
	setmetatable( obj, self )
	self.__index = self
	return obj
end

--读取html文件
function class:read(htmlfile)
    local file =io.open(htmlfile, "r") --读取文件(r读取)
    if  file ~= nil then
        return file:read( "*all" );    
    end 
end

--解析html文本,生成lua格式的字符串，并放入luacontent中
function class:parsehtml(htmlbody)   
   local start0, end0 = string.find( htmlbody, self.startTag);  --  查找第一个标签<%
   if start0 ~= nil  then  --   如果找到了标签<%
        if start0 > 1 then --前面有静态内容,则把静态页加上输出插入self.luacontent
            staicstr = string.sub( htmlbody, 1, start0-1);
            strTep = self.print .. "(\"" .. "ssssssssssss" .."\");"
            table.insert(self.luacontent, self.print.."([["..staicstr.."]]);");
--print( "aa=table len="..table.getn( self.luacontent));
         end        
         local leftbody = string.sub( htmlbody, end0 +1 , string.len( htmlbody ) ); --  标签<%后剩下的内容  
         local start1, end1 = string.find( leftbody, self.endTag); --  标签<%后剩下的内容查找第一个%>标签
         if start1 ~= nil then 
            local luastr = string.sub( leftbody, 1, start1-1 ); --  找到<% 与 %>的内容
            if string.find(luastr, self.startTag ) ~= nil then  --  如果<% 与 %>的内容中还有<%标签,算报错
                --self.luacontent=nil;
            else    
                if string.find(luastr, self.includeTag ) ~= nil then --如果<% 与 %>的内容中包含include标签                  
                    local _,_,filestr = string.find( luastr, "file=\"(.*)\"" )  --查找到<%include file=""%>中的文件名      
--	print( "include="..self.local_path.."/"..filestr);
                    self:parsefile( self.local_path.."/".. filestr );
                elseif string.find(luastr, self.eqTag ) ~= nil and 
                       string.find(luastr, self.eqTag ) == 1 then --<%标签后如果第一为“=”,则直接输出
                    table.insert(self.luacontent, self.print.."(" ..string.sub(luastr, 2, string.len(luastr))..");");
--print( "bb=table len="..table.getn( self.luacontent));                
else  
                    table.insert( self.luacontent, luastr );   --<%%>的内容中直接存入
--print( "cc=table len="..table.getn( self.luacontent));
                end                
                local left_body = string.sub( leftbody, end1 +1 , string.len( leftbody ) );
                if left_body ~= nil then --算是尾调吗？
                    return self: parsehtml( left_body );
                end
            end
        else
            --有<%开头，没有%>结尾
            --self.luacontent=nil;
        end
    else
         -- 内容全是静态文件
        table.insert(self.luacontent, self.print.."( [[" .. htmlbody .. "]]);" );
--print( "dd=table len="..table.getn( self.luacontent));
    end
end

--解析html文件,生成lua格式的字符串，并放入luacontent?function class:parsefile( file_ )
function class:parsefile( file_ )       
        local htmlbody = self:read( file_ )
        if htmlbody ~= nil then
            self:parsehtml(htmlbody);
        end
       -- print( "table len="..table.getn( self.luacontent));
   -- end
end
