<%@ page contentType="text/html; charset=ISO8859_1" %>
<%@ page import="PageHeaderBean" %>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>

<jsp:setProperty name="pageHeader" property="pgTitleName" value="PRODUCT INFORMATION"/>
<jsp:setProperty name="pageHeader" property="pgSalesCode" value="Sales Code"/>
<jsp:setProperty name="pageHeader" property="pgProjectCode" value="Project Code"/>
<jsp:setProperty name="pageHeader" property="pgProductType" value="Product Type"/>
<jsp:setProperty name="pageHeader" property="pgBrand" value="Brand"/>
<jsp:setProperty name="pageHeader" property="pgLength" value="Length"/>
<jsp:setProperty name="pageHeader" property="pgWidth" value="Width"/>
<jsp:setProperty name="pageHeader" property="pgHeight" value="Height"/>
<jsp:setProperty name="pageHeader" property="pgWeight" value="Weight"/>

<jsp:setProperty name="pageHeader" property="pgLaunchDate" value="Launch Date"/>
<jsp:setProperty name="pageHeader" property="pgDeLaunchDate" value="DeLaunch Date"/>
<jsp:setProperty name="pageHeader" property="pgSize" value="SIZE"/>
<jsp:setProperty name="pageHeader" property="pgDisplay" value="DISPLAY"/>
<jsp:setProperty name="pageHeader" property="pgCamera" value="CAMERA"/>
<jsp:setProperty name="pageHeader" property="pgRingtone" value="RINGTONE"/>
<jsp:setProperty name="pageHeader" property="pgPhonebook" value="PHONEBOOK"/>

<jsp:setProperty name="pageHeader" property="pgRemark" value="REMARK"/>
