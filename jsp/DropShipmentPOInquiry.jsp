<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ page import="RsCountBean" %>
<jsp:useBean id="rsCountBean" scope="page" class="RsCountBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Drop Shipment PO Inquiry</title>
</head>
<script language="JavaScript" type="text/javascript">
function poDetail(pono,database)
{
  subWin=window.open("PODetailQuery.jsp?PONO="+pono+"&DATABASE="+database,"subwin");
}
function submitCheck()
{  
    if (document.MYFORM.SEARCHSTRING.value=="" )
	{
	   alert ("請輸入查詢條件!!");
	   return false;
	}
   	 document.MYFORM.action="DropShipmentPOInquiry.jsp?FLAG=1";
	 document.MYFORM.submit();
}
</script>
<body>
<form method="post" name="MYFORM" action="DropShipmentPOInquiry.jsp?">
<a href="/wins/WinsMainMenu.jsp">Home</a><br>
<%
     String searchString=request.getParameter("SEARCHSTRING");
	 String flag=request.getParameter("FLAG");//控制是否從本頁submit
	 int maxrow=0;
	 String poArray[][]=null;
%>
<font size="+1"><strong>Drop Shipment PO Inquiry</strong></font>
<table>
<tr>
     <td>PO NO :</td><td><input name="SEARCHSTRING" type="text"></td>
      <td><input type="button" name="Query" value="Query" onClick='return submitCheck()'></td>
</tr>
</table>

<%
String sSql="",sSql1="",sTpePO="";
Statement statement=null;
Statement statement1=null;
ResultSet rs=null,rs1=null;
int ipo=0;
try 
  {
     if (flag !=null)
      {
         statement=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
         sSql="select PHORD,PHCOMP,PHWHSE,PHVEND,PHSHIP,PHNAME,PHENDT,PHCMT,PHRQID from HPH "+
	             "where PHVEND IN('91002','91080') ";
	     if (searchString !=null && !searchString.equals(""))
	       {
		     sSql=sSql+" and PHORD="+searchString;
		   }
	     rs=statement.executeQuery(sSql);
		 //out.println("sSql"+sSql);
		 if (rs.next()) 
	      {
		     sTpePO="Y";
             statement1=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
             sSql1="select PHORD,PHCOMP,PHWHSE,PHVEND,PHSHIP,PHNAME,PHENDT,PHCMT,PHRQID from HPH "+
	                   "where PHVEND IN('91002','91080') "+
                       "and PHORD in(select HORD from dbexp@shbpcs_net:ech where HORD=PHORD) ";
             if (searchString !=null && !searchString.equals(""))
	           {
		         sSql1=sSql1+" and PHORD="+searchString;
	           }
             rs1=statement1.executeQuery(sSql1);
             //out.println(sSql1);
             rsCountBean.setRs(rs1);
             maxrow=rsCountBean.getRsCount();
             poArray=new String [maxrow][9];
             while (rs1.next()) {
                poArray[ipo][0]=rs1.getString("PHORD"); 
                poArray[ipo][1]=rs1.getString("PHCOMP");
                poArray[ipo][2]=rs1.getString("PHWHSE");
                poArray[ipo][3]=rs1.getString("PHVEND");
                poArray[ipo][4]=rs1.getString("PHSHIP");
                poArray[ipo][5]=rs1.getString("PHNAME");
                poArray[ipo][6]=rs1.getString("PHENDT");
                poArray[ipo][7]=rs1.getString("PHCMT");
                poArray[ipo][8]=rs1.getString("PHRQID");
                ipo++; 
               }//end of while
             statement1.close();
             rs1.close();
	      }// end of if rs.next
		 else {out.println("無此PO資料,請重新輸入!!");}
         statement.close();
         rs.close();
	}// end of if flag 
	else {out.println("請輸入PO NO!!");}
  } //end of try 
catch (Exception e)
  {
	 out.println("Exception:"+e.getMessage());
  }
%>

<%
try
{
  if (flag !=null)
   {
    if (maxrow > 0 && sTpePO=="Y") 
	  {
%>
  <table border="1" cellpadding="0">
    <!--DWLayoutTable-->
    <tr bgcolor="#66CCCC"> 
      <td><font size="2"><strong>PO NO</strong></font></td>
      <td><font size="2"><strong>COMP</strong></font></td>
      <td><font size="2"><strong>WHS</strong></font></td>
      <td><font size="2"><strong>VENDOR</strong></font></td>
      <td><font size="2"><strong>SHIP TO CUST</strong></font></td>
      <td><font size="2"><strong>CUST DESC</strong></font></td>
      <td><font size="2"><strong>DATE</strong></font></td>
      <td><font size="2"><strong>COMMENT</strong></font></td>
      <td><font size="2"><strong>USER</strong></font></td>
    </tr>
    <%
    for (int i=0;i<poArray.length;i++)
	   {
%>
    <tr> 
      <td><a href='javaScript:poDetail("<%=poArray[i][0]%>","dbtel")'><%=poArray[i][0]%></a></td>
      <td><font size="2"><%=poArray[i][1]%></font></td>
      <td><font size="2"><%=poArray[i][2]%></font></td>
      <td><font size="2"><%=poArray[i][3]%></font></td>
      <td><font size="2"><%=poArray[i][4]%></font></td>
      <td><font size="2"><%=poArray[i][5]%></font></td>
      <td><font size="2"><%=poArray[i][6]%></font></td>
      <td><font size="2"><%=poArray[i][7]%></font></td>
      <td><font size="2"><%=poArray[i][8]%></font></td>
    </tr>
    <%
	   }//end of for
	 }//end of if maxrow >0
	 else if (sTpePO=="Y" && maxrow == 0) 
	   {
	     out.println("此PO尚未轉入上海資料庫!!");
	   }
   }//end of if flag=null
 }//end of try
catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }
%>
  </table>
</form>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>