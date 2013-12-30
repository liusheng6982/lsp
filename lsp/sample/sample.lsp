
<%include file="b.lsp"%>

<html>
	<head>
		<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	<body>
		<div><%=test %></div>
		<div><%=ngx.req.get_uri_args()["test"] %></div>
		<table border="1">
			<%
				for i = 0, 10 do
			%>
					<tr>
						<td><%=i%></td><td><%=i%></td><td><%=i%></td><td><%=i%></td>
						<td><%=i%></td><td><%=i%></td><td><%=i%></td><td><%=i%></td>
						<td><%=i%></td><td><%=i%></td><td><%=i%></td><td><%=i%></td>
					</tr>
			<%
				end
			%>
		</table>
	</body>

</html>
