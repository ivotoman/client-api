<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.MissingResourceException"%>
<%@ page import="java.util.ResourceBundle"%>

<%@ page import="com.aducid.sdk.common.AducidClientException"%>
<%@ page import="com.aducid.sdk.AducidAdvancedClient"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hello World</title>
</head>
<body>

	<%
		// read AIM host URL
		String aimUrl;
		try {
		    aimUrl = ResourceBundle.getBundle("config").getString("aimUrl");
		} catch (MissingResourceException ex) {
		    aimUrl = "http://localhost:8080";
		}

		// initialize SDK ADUCID client
		AducidAdvancedClient client = new AducidAdvancedClient(aimUrl);

		// build return URL, where result of authentication will be redirected to
		String returnUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
				+ request.getContextPath() + "/result.jsp";

		try {
			// get redirect URL, where the user should be redirected to invoke PEIG 
			String redirectUrl = client.startAuthenticationSession(returnUrl);

			// send redirect to AIM Proxy to process authentication
			response.sendRedirect(redirectUrl);
		} catch (AducidClientException ace) {
    %>

	<b style="color: red">ADUCID Client Exception:</b><br/><%=ace.getMessage()%><br/><br/>

	<a href="index.jsp">Try again</a>

    <%	}	%>

</body>
</html>
