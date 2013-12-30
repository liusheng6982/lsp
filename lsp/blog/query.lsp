<html>
<head>
	<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<%
     
 ngx.say(ngx.ctx.title);
 
%>

<%
    for i=0, 10 do
%>
		<p>这是我的blog</p>
<%
	end
%>

</body>
</html>
