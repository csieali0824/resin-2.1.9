<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
String sql = "",sql1="";
String LABEL_GROUP= request.getParameter("LABEL_GROUP");
if (LABEL_GROUP==null ) LABEL_GROUP="";
int area_cnt =0;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TS Yew Label Group List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(vName,vCode)
{
	window.opener.document.MYFORM.LABEL_GROUP_NAME.value = vName;
	window.opener.document.MYFORM.LABEL_GROUP_CODE.value = vCode;
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
<FORM METHOD="post" ACTION="TSYewLabelGroupInfo.jsp" NAME="SUBFORM">
<table width="100%">
	<tr>
		<td>
			<table>
				<tr>
					<td style="font-family:arial;font-size:12px">群組代碼/名稱:</td>
					<td><input type="text" name="LABEL_GROUP" style="font-family:arial" value="<%=LABEL_GROUP%>"></td>
					<td><input type="submit" name="submit" value="Query" style="font-family:arial"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<%     
				try
				{ 
					sql = " select a.label_group_code,a.label_group_name, a.label_group_desc, "+
						  " to_char(a.effective_from_date,'yyyy-mm-dd') effective_from_date, to_char(a.effective_to_date,'yyyy-mm-dd') effective_to_date, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date, a.last_updated_by "+
					      " from oraddman.tsyew_label_groups a"+
						  " where 1=1";
					if (! LABEL_GROUP.equals(""))
					{
						sql += " and (a.label_group_code='"+ LABEL_GROUP+"' or a.label_group_name like '"+ LABEL_GROUP+"%')";
					}
					//sql += "  and trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))"+
					sql += "  and nvl(a.effective_to_date,to_date('20990101','yyyymmdd'))>trunc(sysdate) "+ //modify by Peggy 20210122
					       " order by a.label_group_code";
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
									<td width="3%" rowspan="2">&nbsp;&nbsp;&nbsp;</td> 
									<td width="6%" rowspan="2" style="font-size:12px;color:#006666" align="center">群組代碼</td>
									<td width="15%" rowspan="2" style="font-size:12px;color:#006666" align="center">群組名稱</td>
									<td width="15%" rowspan="2" style="font-size:12px;color:#006666" align="center">群組說明</td>
								</tr>
								<tr bgcolor="#D3E6F3"> 
								</tr>
							<% 
						}
						%>
						<TR id="tr_<%=vline%>">
						<TD><input type="button" name="Set<%=vline%>" value="SET" style="font-size:12px;font-family: Tahoma,Georgia;" onClick="setSubmit('<%=rs.getString("label_group_name")%>','<%=rs.getString("label_group_code")%>')"></TD>
						<td align="center"><%=rs.getString("label_group_code")%></td>
						<td><%=rs.getString("label_group_name")%></td>
						<td><%=rs.getString("label_group_desc")%></td>
						<% 
						for (int i = 1 ; i <=area_cnt ; i++)
						{
						%>
							<td align="center"><%=(rs.getString(8+(i-1))==null?"&nbsp;":rs.getString(8+(i-1)))%></td>
						<%
						}
						%>
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
