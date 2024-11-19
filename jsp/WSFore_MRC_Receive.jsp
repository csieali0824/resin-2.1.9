<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ArrayStoreBean,RsCountBean" %>
<jsp:useBean id="arrayStoreBean" scope="session" class="ArrayStoreBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<script language="JavaScript" type="text/JavaScript">
function saveMRC()
{ 
   document.MYFORM.action="../jsp/WSFore_MRC_ReceiveProcess.jsp";
   document.MYFORM.submit();
}
</script>
<%    
String docNo=request.getParameter("DOCNO"); 
String targetYear="",targetMonth="",status="";     
   
Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);  
ResultSet rs=null;
String MRC_Array[][]=null;
  
arrayStoreBean.setArray2DStore(null); //若是第一次進入則先清空Array Bean中之資料
try
{    
   //取得Header的資料   
   rs=statement.executeQuery("select TARGETYEAR,TARGETMONTH,STATUS from PSALES_FORE_MRC_HD where DOCNO='"+docNo+"'"); 
   if (rs.next())                 
   {        	
	 status=rs.getString("STATUS");	 	 	
	 targetYear=rs.getString("TARGETYEAR");	
	 targetMonth=rs.getString("TARGETMONTH");	 
   } 
   rs.close();  
   
   //取得line detail的資料
   rs=statement.executeQuery("select PRJCD,b.SALESCODE,COLOR,LINENO,EP_QTY,EP_DATE,HIERARCHY,CM_QTY,CM_DATE,a.REMARK,ACT_QTY,ACT_DATE,COMMENTS from PSALES_FORE_MRC_LN a,PIMASTER b where trim(a.PRJCD)=trim(b.PROJECTCODE) and DOCNO='"+docNo+"' and R_TYPE='R' order by PRJCD,COLOR,LINENO");    		 
   rsCountBean.setRs(rs); //取得其line detail總筆數
   MRC_Array=new String[rsCountBean.getRsCount()][13]; //宣告為符合其總筆數大小之陣列
   
   int ari=0;
   while (rs.next())  
   {                  
	   MRC_Array[ari][0]=rs.getString("PRJCD");
	   MRC_Array[ari][1]=rs.getString("COLOR");
	   MRC_Array[ari][2]=rs.getString("LINENO");	
	   MRC_Array[ari][3]=rs.getString("SALESCODE");  
	   MRC_Array[ari][4]=rs.getString("EP_QTY");
	   MRC_Array[ari][5]=rs.getString("EP_DATE");
	   MRC_Array[ari][6]=rs.getString("HIERARCHY");
	   MRC_Array[ari][7]=rs.getString("CM_QTY");
	   MRC_Array[ari][8]=rs.getString("CM_DATE");
	   MRC_Array[ari][9]=rs.getString("REMARK");
	   MRC_Array[ari][10]=rs.getString("ACT_QTY");
	   MRC_Array[ari][11]=rs.getString("ACT_DATE");
	   MRC_Array[ari][12]=rs.getString("COMMENTS");
	   ari++;
   } //end of while=>rs.next
   rs.close();	
   arrayStoreBean.setArray2DStore(MRC_Array); //將資料寫到bean裏
   
} //end of try
catch (Exception e1)
{
  %>
    <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <%
  out.println("Exception:"+e1.getMessage());
} 
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Material Request Confirmation Receive Form</title>
</head>
<body>
<FORM METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Material Request Confirmation(<font color="#FF0000">RECEIVE</font>)</strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="193" bgcolor="#0099CC"><font color="#333399" face="Arial Black"><strong>DOCNO:</strong></font><font color="WHITE" size=2><%=docNo%></font></td>
      <td width="204" bgcolor="#0099CC">
	    <font color="#333399" face="Arial Black"><strong>STATUS:</strong></font><font color="WHITE" size=2><%=status%></font>
      </td>
      <td width="562" colspan="2" bgcolor="#0099CC">
	  <%       
        if ( (UserRoles.indexOf("MCUser")>=0 || UserRoles.indexOf("admin")>=0) && status.equals("COMPLETE"))
        {      
          out.println("<input name='Button' type='Button' onClick='saveMRC()' value='SAVE'>");   
        }    		    
      %> 
	  </td>  	 
	</tr><FONT >	
 </table>
  <HR>
<%  
 String f_interModel="",f_extModel="",f_color="",f_line="",f_hierarchy="",subLineEnd="Y",verifyStr1="",verifyStr2="";
 String ep_qty="0",ep_date="",ep_qtyTotal="0",cm_qty="0",cm_date="",cm_qtyTotal="0",cm_remark=""; 
 String act_qty="",act_date="",v_comments=""; 
  try
  {   
   MRC_Array=arrayStoreBean.getArray2DStore(); //直接自bean中取得資料  
   String bgColor="ADD8E6";
%>     
   <TABLE width="989">
   <TR><TH width="86" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>INTER MODEL</FONT></TH>
   <TH width="68" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>EXT MODEL</FONT></TH><TH width="78" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>COLOR</FONT></TH>
   <TH width="75" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REQUEST Qty.</FONT></TH>
   <TH width="88" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REQUEST DATE</FONT></TH>
   <TH width="91" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>DELIVERY Qty.</FONT></TH>
   <TH width="89" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>DELIVERY DATE.</FONT></TH>
   <TH width="77" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>RECEIVE Qty.</FONT></TH>
   <TH width="81" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>RECEIVE DATE </FONT></TH>
   <TH width="212" BGCOLOR=BLACK><font color="WHITE" size="1">COMMENTS</font></TH>
   </TR>
<%    
   for (int ari=0;ari<MRC_Array.length;ari++)  
   {                  
	f_interModel=MRC_Array[ari][0];
	f_extModel=MRC_Array[ari][3];
	f_color=MRC_Array[ari][1];	
	verifyStr1=f_interModel+"-"+f_color; //做為辨識用途之用
	f_line=MRC_Array[ari][2]; //LINE NO
	ep_qty=MRC_Array[ari][4];	
	ep_date=MRC_Array[ari][5]; 
	cm_qty=MRC_Array[ari][7];
	cm_date=MRC_Array[ari][8];
	cm_remark=MRC_Array[ari][9];
	if (cm_remark==null) cm_remark="";
	f_hierarchy=MRC_Array[ari][6];
	act_qty=MRC_Array[ari][10];
	if (act_qty==null) act_qty="";
	act_date=MRC_Array[ari][11];
	if (act_date==null) act_date="";
	v_comments=MRC_Array[ari][12];
	if (v_comments==null) v_comments="";	
	
	if (f_hierarchy.equals("P")) //間隔列顏色改換
    {
      bgColor="ADD8E6";
    } else {
      bgColor="B0E0E6";	  
    }  //end of if=>f_hierarchy.equals("P")
	
	if (ari<(MRC_Array.length-1))
	{
	  verifyStr2=MRC_Array[ari+1][0]+"-"+MRC_Array[ari+1][1];
	  if (verifyStr2.equals(verifyStr1))
	  {
	     subLineEnd="N";
	  } else {
	     subLineEnd="Y";
	  }	 
	} else {
	     subLineEnd="Y";
	}
%>
   <TR BGCOLOR=<%=bgColor%>>
     <TD>
      <%	  
	  if (!f_hierarchy.equals("P"))
	  {	  	    		
		 if (subLineEnd.equals("Y")) //表示是子項目的最後一個
		 {
		    out.println("&nbsp;<img border='0' src='../image/branchend.gif'>");				     
		 } else {
		    out.println("&nbsp;<img border='0' src='../image/branch.gif'>");				     
		 }
	  } 
	  out.println(f_interModel);
	  %>
	 </TD>
     <TD><%=f_extModel%></TD><TD><%=f_color%></TD>
     <TD><div align="center"><%=ep_qty%></div></TD>
     <TD><div align="center"><%=ep_date%></div></TD>
     <TD><div align="center"><%=cm_qty%></div></TD>
     <TD><div align="center"><%=cm_date%></div></TD>
     <TD><input name="<%=f_interModel%>-<%=f_color%>-<%=f_line%>-RECQTY" type="text" size="3" value="<%=act_qty%>"></TD>
     <TD><input name="RECDATE-<%=f_interModel%>-<%=f_color%>-<%=f_line%>" type="text" size="6" value="<%=act_date%>"><A href='javascript:void(0)' onclick="gfPop.fPopCalendar(document.MYFORM.elements['RECDATE-<%=f_interModel%>-<%=f_color%>-<%=f_line%>']);return false;"><img border='0' src='../image/calbtn.gif'></A></TD>
     <TD>
	   <input name="<%=f_interModel%>-<%=f_color%>-<%=f_line%>-COMMENT" type="text" size="20" maxlength="30" value="<%=v_comments%>">
	 <%
	    if (!cm_remark.equals("")) //若有備註說明才秀出
		{
	      out.println("<img title='"+cm_remark+"' src='../image/docicon.gif'>");
		}  
	 %>	 
	 </TD>
   </TR>
<%	  
	 cm_qtyTotal=String.valueOf(Float.parseFloat(cm_qtyTotal)+Float.parseFloat(cm_qty));	              
	 if (f_hierarchy.equals("P"))
	 {
	   ep_qtyTotal=String.valueOf(Float.parseFloat(ep_qtyTotal)+Float.parseFloat(ep_qty));            		             
	 }  //end of if =>f_hierachy.equals("P")	
   } //end of for =>ari           
} //end of try
catch (Exception e2)
{
 %>
    <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
 <%
 out.println("Exception:"+e2.getMessage());
}
%>
<TR>
  <TD colspan="2"><font color="#FF0000"><strong>Target Date:<%=targetYear%>/<%=targetMonth%></strong></font><font color="#FF0000">&nbsp;</font></TD>
  <TD BGCOLOR=#0099CC><div align="right"><FONT COLOR=WHITE>TOTAL</font></div></TD>
  <TD BGCOLOR=#0099CC><div align="right"><FONT COLOR=WHITE><strong><%=ep_qtyTotal%></strong></font></div></TD>
  <TD BGCOLOR=#0099CC><FONT COLOR=LIGHTYELLOW><strong>K pcs</strong></font></TD>
  <TD BGCOLOR=#0099CC><div align="right"><FONT COLOR=WHITE><strong><%=cm_qtyTotal%></strong></font></div></TD>
  <TD BGCOLOR=#0099CC><FONT COLOR=LIGHTYELLOW><strong>K pcs</strong></font></TD>
  <TD BGCOLOR=#0099CC>&nbsp;</TD>
  <TD BGCOLOR=#0099CC>&nbsp;</TD>
  <TD BGCOLOR=#0099CC>&nbsp;</TD> 
</TR>
 </TABLE>
<HR>
<!-- 表單參數 -->
<input name="DOCNO" type="HIDDEN" value="<%=docNo%>" >
<input name="ACTION" type="HIDDEN" value="SAVE" >
</FORM>
<iframe width=80 height=80 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%
statement.close();	
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
