--[[
根据访问路径，调用lua
]]
--module( ..., package.seeall )
local urldispatcher = require("lsplib.urldispatcher")


--用户的url及对应的处理方法，{url,{ 业务处理, html模板(可有可无)},}
--其中：url由nginx.conf中的配置路径开始算
--	业务的区理方法，必须要有方法名称
--      lsp模板对应的路径应该在nginx.conf中的LSP_HOME路径下
--      根据lsp生成的lua文件，会存在LSP_HOME下的work目录下，work目录要有写的权限
--      现在的lsp文件修改后，不会自动更新，需要你手工删除work下对应的lua
--url的配置放到这里，会不会初使化多次？
urldispatcher.urlmap = {
   ['/lua/test']       = { 'biz.test.test()',        'lsp/sample/sample.lsp' },
   ['/lua/query']      = { 'biz.test.query()',       '/lsp/blog/query.lsp' }
}

function process()
    urldispatcher:process();
end



process();
