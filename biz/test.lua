local print=ngx.say
print("业务处理----------------------------------------------------\n");


module( ..., package.seeall )

local print=print

function test()
	print("hahah!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
end

function query()
    --print("query query query query ");
    ngx.ctx.title="this my title";
end
