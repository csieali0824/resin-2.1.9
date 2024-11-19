<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
String sql = "";
int area_cnt =0;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Label Type List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(vName,vCode,vSizeName)
{
	window.opener.document.MYFORM.LABEL_TYPE_NAME.value = vName;
	window.opener.document.MYFORM.LABEL_TYPE_CODE.value = vCode;
	window.opener.document.MYFORM.LABEL_NAME.value = vSizeName;
	this.window.close();
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<body >  
<FORM METHOD="post" ACTION="TSLabelTypeInfo.jsp" NAME="SUBFORM">
<table align="center" width="100%">
	<tr>
		<td>
			<%     
				try
				{ 
					sql = " SELECT a.LABEL_TYPE_CODE,a.LABEL_TYPE_NAME,a.description,to_char(a.LAST_UPDATE_DATE,'yyyy-mm-dd') LAST_UPDATE_DATE,a.LAST_UPDATED_BY,to_char(a.EFFECTIVE_FROM_DATE,'yyyy-mm-dd') EFFECTIVE_FROM_DATE,to_char(a.EFFECTIVE_TO_DATE,'yyyy-mm-dd') EFFECTIVE_TO_DATE,a.PRINT_NUM"+
					      " ,a.LABEL_SIZE_DESC"+
						  " FROM oraddman.ts_label_types a  "+
						  " where trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))"+
					      " order by a.LABEL_TYPE_CODE";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					ResultSet rs=statement.executeQuery();
					int vline=0;
					while (rs.next())
					{
						vline++;
						if (vline==1)
						{
						%>
							<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
								<tr bgcolor="#D3E6F3"> 
									<td width="5%">&nbsp;&nbsp;&nbsp;</td> 
									<td width="10%" style="font-size:12px;color:#006666" align="center">標籤代碼</td>
									<td width="25%" style="font-size:12px;color:#006666" align="center">標籤名稱</td>
									<td width="25%" style="font-size:12px;color:#006666" align="center">標籤說明</td>
									<td width="15%" style="font-size:12px;color:#006666" align="center">標籤尺吋</td>
									<td width="8%" style="font-size:12px;color:#006666" align="center">標籤張數</td>
								</TR>
						<% 
						}
						%>
						
						<TR>
						<TD><input type="button" name="Set<%=vline%>" value="SET" style="font-size:12px;font-family: Tahoma,Georgia;" onclick='setSubmit("<%=rs.getString("label_type_name").replace('"','吋')%>","<%=rs.getString("LABEL_TYPE_CODE")%>","<%=rs.getString("LABEL_SIZE_DESC")%>")'></TD>
						<td><%=rs.getString("LABEL_TYPE_CODE")%></td>
						<td><%=rs.getString("LABEL_TYPE_name")%></td>
						<td><%=(rs.getString("DESCRIPTION")==null?"&nbsp;":rs.getString("DESCRIPTION"))%></td>
						<td><%=(rs.getString("LABEL_SIZE_DESC")==null?"&nbsp;":rs.getString("LABEL_SIZE_DESC"))%></td>
						<td><%=(rs.getString("PRINT_NUM")==null?"&nbsp;":rs.getString("PRINT_NUM"))%></td>
						</TR>
					<%
					}
					if (vline>0)
					{
					%>
						</TABLE>
					<%
					}
					rs.close();  
					statement.close();  
				}
				catch (Exception e)
				{
					out.println("Exception1:"+e.getMessage());
				}
				
			%>
		</td>
	</tr>
</table>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
