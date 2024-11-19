<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>Java Barcode</title>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
.style21 {
	color: #0000FF;
	font-size: 14px;
}
.style22 {font-size: 18px; color: #990033;}
</STYLE>
</head>
<body>
<%
   String moNo=request.getParameter("MONO");  
   String custNo=request.getParameter("CUSTNO");
   String custName=request.getParameter("CUSTNAME");
   String runCardNo=request.getParameter("RUNCARDNO"); 
   String custLabelTmp=request.getParameter("CUSTLABELTMP");   
   
   //out.println("RUNCARDNO="+runCardNo);
%>
<span class="style22">目檢站客戶標籤資訊</span><BR>
<span class="style21">客戶標籤規格樣本檔:<% if (custLabelTmp==null) out.println("無客戶樣本檔"); else out.println("<font>"+custLabelTmp+"</font>"); %></span>
<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="50%" align="left" borderColorLight="#ffffff" border="1">
  <tr> 
   <td width="9%" nowrap>
      MO 單號   </td>
   <td width="91%">
    <div align="center"><img src="/oradds/jsp/subwindow/TSMfgCustLabelBarCodeDraw.jsp?DATA=<%=moNo%>&CODE=<%="1"%>&width=80&height=20" align="middle"/></div>
   </td>
  </tr>
  <tr> 
   <td nowrap>
      客戶編號
   </td>
   <td>
    <div align="center"><img src="/oradds/jsp/subwindow/TSMfgCustLabelBarCodeDraw.jsp?DATA=<%=custNo%>&CODE=<%="2"%>&width=80&&height=20" align="middle"/></div>
   </td>
  </tr>
  <tr> 
   <td nowrap>
      客戶名稱
   </td>
   <td>
    <%=custName%>
   </td>
  </tr>
  <tr> 
   <td nowrap>
      流程卡號
   </td>
   <td>
    <div align="center"><img src="/oradds/jsp/subwindow/TSMfgCustLabelBarCodeDraw.jsp?DATA=<%=runCardNo%>&CODE=<%="3"%>&width=80&&height=20" align="middle"/></div>
   </td>
  </tr>
</table>
</body>
</html>
