<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.util.MissingResourceException"%>
<%@ page import="java.util.ResourceBundle"%>

<%@ page import="com.aducid.sdk.AducidAdvancedClient"%>
<%@ page import="com.aducid.sdk.common.AducidClientException"%>
<%@ page import="com.aducid.sdk.pojo.ExecutePersonalObjectResponse"%>
<%@ page import="com.aducid.sdk.pojo.GetPSLAttributesResponse"%>
<%@ page import="com.aducid.sdk.pojo.PersonalObjectAttribute"%>

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

		// read authId from request 
		String authId = request.getParameter("authId");

		// read authKey from request 
		String authKey = request.getParameter("authKey");

		// initialize SDK ADUCID client
		AducidAdvancedClient client = new AducidAdvancedClient(aimUrl);

		try {
			// verify authentication and ask for authentication data
			GetPSLAttributesResponse authData = client.getResult(authId, authKey);
	%>

	<h4>Authentication Result</h4>
	<ul>
		<li>authId = <%=authData.getAuthId()%></li>
		<li>authKey = <%=authData.getAuthKey()%></li>
		<li>aimStatus = <%=authData.getStatusAIM()%></li>
		<li>authStatus = <%=authData.getStatusAuth()%></li>
	</ul>
	<h4>Authentication Data</h4>
	<ul>
		<li>securityLevel = <%=authData.getSecurityLevel()%></li>
		<li>securityProfileName = <%=authData.getSecurityProfileName()%></li>
		<li>userDatabaseIndex = <%=authData.getUserDatabaseIndex()%></li>
		<li>operationName = <%=authData.getOperationName()%></li>
		<li>validityTime = <%=authData.getValidityTime()%></li>
		<li>validityCount = <%=authData.getValidityCount()%></li>
		<li>expirationCountdownTime = <%=authData.getExpirationCountdownTime()%></li>
		<li>expirationCountdownUses = <%=authData.getExpirationCountdownUses()%></li>
	</ul>

	<%
			// ask client for personal object attributes
			List<PersonalObjectAttribute> personalObjectAttributeList = client.read(authData.getAuthId(), authData.getAuthKey(), "ADUCID_USER");
			if (!personalObjectAttributeList.isEmpty()) {
	%>

	<h4>Personal Object Attributes (personalObjectName=ADUCID_USER)</h4>
	<ul>

	<%
				// iterate over all personal object attributes and print their keys and values
				for (PersonalObjectAttribute personalObjectAttribute : personalObjectAttributeList) {
	%>

		<li><%=personalObjectAttribute.getName()%> = <%=personalObjectAttribute.getValue()%></li>

	<%
				}
			}
	%>

	</ul>

	<%	} catch (AducidClientException ace) {	%>

	<b style="color: red">ADUCID Client Exception:</b><br/><%=ace.getMessage()%><br/><br/>

    <%	}	%>

	<a href="index.jsp">Try again</a>

</body>
</html>
