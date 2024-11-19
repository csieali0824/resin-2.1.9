<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="RsCountBean,DateBean" %>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
</script>
<%    
  String docNo=request.getParameter("DOCNO"); 
  String targetYear="",targetMonth="";
  String createBy="",createByName="",createDate="",createTime="",nextPrcsMan="",isComplete="N",remark="",status="";   
  String updateMan="",updateDate="",updateTime="",action="";
  
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
  Statement subStat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
  ResultSet  rs=null,subRs=null;   
  String sql="",sub_Sql="";  
  int subRow=1; 	
 try
{       
   rs=statement.executeQuery("select TARGETYEAR,TARGETMONTH,CREATEDDATE,CREATEDTIME,NEXTPRCSMAN,REMARK,STATUS,CREATEDBY,USERNAME,IS_COMPLETE from PSALES_FORE_MRC_HD,WSUSER where DOCNO='"+docNo+"' and CREATEDBY=WEBID(+)"); 
   if (rs.next())                 
   {         
	 createBy=rs.getString("CREATEDBY"); //申請人ID	 
	 createByName=rs.getString("USERNAME"); //申請人名稱
	 createDate=rs.getString("CREATEDDATE");
	 createDate=createDate.substring(0,4)+"/"+createDate.substring(4,6)+"/"+createDate.substring(6,8);
	 createTime=rs.getString("CREATEDTIME");
	 createTime=createTime.substring(0,2)+":"+createTime.substring(2,4);
	 nextPrcsMan=rs.getString("NEXTPRCSMAN");	 
	 remark=rs.getString("REMARK");	 
	 isComplete=rs.getString("IS_COMPLETE");
	 status=rs.getString("STATUS");	 
	 if (remark==null) remark="";	
	 targetYear=rs.getString("TARGETYEAR");	
	 targetMonth=rs.getString("TARGETMONTH");	 
   } 
   rs.close();     		 
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
} 
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Material Request Confirmation Form</title>
</head>
<body>
<FORM METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Material Request Confirmation</strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="193" bgcolor="#0099CC"><font color="#333399" face="Arial Black"><strong>DOCNO:</strong></font><font color="WHITE" size=2><%=docNo%></font></td>
      <td width="204" bgcolor="#0099CC">
	    <font color="#333399" face="Arial Black"><strong>STATUS:</strong></font><font color="WHITE" size=2><%=status%></font>
      </td>
      <td width="562" colspan="2" bgcolor="#0099CC">	 
	  </td>  	 
	</tr><FONT >	
 </table>
  <HR>    
   <TABLE width="936">
   <TR><TH width="86" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>INTER MODEL</FONT></TH>
   <TH width="58" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>EXT MODEL</FONT></TH><TH width="76" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>COLOR</FONT></TH>
   <TH width="53" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>Qty. of PR </FONT></TH>
   <TH width="71" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REQUEST Qty.</FONT></TH>
   <TH width="83" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REQUEST DATE </FONT></TH>
   <TH width="78" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>DELIVERY Qty. </FONT></TH>
   <TH width="87" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>DELIVERY DATE </FONT></TH>
   <TH width="77" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>RECEIVED Qty. </FONT></TH>
   <TH width="86" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>RECEIVED DATE </FONT></TH>
   <TH width="63" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REMARK1</FONT></TH>
   <TH width="66" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REMARK2</FONT></TH>
   </TR>
<%    
 String f_interModel="",f_extModel="",f_color="";
 String origin_rqty="0",ep_qty="0",origin_rqtyTotal="0",ep_qtyTotal="0",ep_date="",cm_qtyTotal="0",act_qtyTotal="0";  
 String cm_qty="&nbsp;",cm_date="&nbsp;",act_qty="&nbsp;",act_date="&nbsp;";
 String remark1="",remark2="";
  try
  {      
   sql = "select a.PRJCD,b.SALESCODE,a.COLOR,a.ORIGIN_RQTY,a.EP_QTY,a.EP_DATE from PSALES_FORE_MRC_LN a,PIMASTER b "+
         " where trim(a.PRJCD)=trim(b.PROJECTCODE)"+
		 " and a.R_TYPE='I' and a.DOCNO='"+docNo+"'";     
   sql=sql+" order by PRJCD,COLOR";      	
   rs=statement.executeQuery(sql);
   
   String bgColor="B0E0E6";

   while (rs.next())  
   {                  
	f_interModel=rs.getString("PRJCD");
	f_extModel=rs.getString("SALESCODE");
	f_color=rs.getString("COLOR");
	origin_rqty=rs.getString("ORIGIN_RQTY");
	ep_qty=rs.getString("EP_QTY");	
	ep_date=rs.getString("EP_DATE"); 
	
	 sub_Sql="select PRJCD,COLOR,CM_QTY,CM_DATE,ACT_QTY,ACT_DATE,LINENO,REMARK,COMMENTS from PSALES_FORE_MRC_LN"+
	          " where R_TYPE='R' and DOCNO='"+docNo+"' and PRJCD='"+f_interModel+"' and COLOR='"+f_color+"'"+
			  " order by PRJCD,COLOR,LINENO";  
	  subRs=subStat.executeQuery(sub_Sql);			 
	  rsCountBean.setRs(subRs); //取得其總筆數
	  subRow=rsCountBean.getRsCount();	 
	  if (subRow<1) subRow=1;	
	  if (subRs.next())
	  { 	  
		  cm_qty=subRs.getString("CM_QTY");
		  if (cm_qty==null)
		  {
			cm_qty="&nbsp;";
		  } else {
			cm_qtyTotal=String.valueOf(Float.parseFloat(cm_qtyTotal)+Float.parseFloat(cm_qty)); 
		  }			  
		  cm_date=subRs.getString("CM_DATE");	  
		  if (cm_date==null) 
		  {
			   cm_date="&nbsp;";
		  } else {
			 if (cm_date.length()==8) cm_date=cm_date.substring(0,4)+"/"+cm_date.substring(4,6)+"/"+cm_date.substring(6,8);
		  }  
		  act_qty=subRs.getString("ACT_QTY");
		  if (act_qty==null) 
		  {
			act_qty="&nbsp;";
		  } else {
			act_qtyTotal=String.valueOf(Float.parseFloat(act_qtyTotal)+Float.parseFloat(act_qty)); 
		  }	
		  act_date=subRs.getString("ACT_DATE");	  
		  if (act_date==null) 
		  {
			   act_date="&nbsp;";
		  } else {
			 if (act_date.length()==8) act_date=act_date.substring(0,4)+"/"+act_date.substring(4,6)+"/"+act_date.substring(6,8);
		  } 		  
		  
		  remark1=subRs.getString("REMARK"); //取得上海物管回覆的備註
		  if (remark1==null) remark1="";
		  remark2=subRs.getString("COMMENTS"); //取得台北物管收料的備註
		  if (remark2==null) remark2="";	
	  } //end of if=> (subRs.next())	   	    
%>
   <TR BGCOLOR=<%=bgColor%>><TD><FONT SIZE=2><%=f_interModel%></TD><TD><%=f_extModel%></TD><TD><%=f_color%></TD><TD><div align="center"><%=origin_rqty%></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=ep_qty%></strong></FONT></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=ep_date%></strong></FONT></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=cm_qty%></strong></FONT></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=cm_date%></strong></FONT></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=act_qty%></strong></FONT></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=act_date%></strong></FONT></div></TD>
     <TD>
	  <%   
       if (!remark1.equals("")) //若有備註說明才秀出
	   {
	     out.println("<img title='"+remark1+"' src='../image/docicon.gif'>");
	   } 
     %>
	 &nbsp;
	 </TD>
     <TD>
	 <%
      if (!remark2.equals("")) //若有備註說明才秀出
	  {
	     out.println("<img title='"+remark2+"' src='../image/docicon.gif'>");
	  } 
    %>
	 &nbsp;
	 </TD>
	 </TR>
	  <%
	  int v_to_sub=2; //用來比對是否是子項目的最終一筆
      if (subRow>1)
	  {	    
        while (subRs.next())
	    {
		   cm_qty=subRs.getString("CM_QTY");
	       if (cm_qty==null)
	       {
	         cm_qty="&nbsp;";
	       } else {
	         cm_qtyTotal=String.valueOf(Float.parseFloat(cm_qtyTotal)+Float.parseFloat(cm_qty)); 
	       }	
	       cm_date=subRs.getString("CM_DATE");
	       if (cm_date==null) 
	       {
	          cm_date="&nbsp;";
	       } else {
	          if (cm_date.length()==8) cm_date=cm_date.substring(0,4)+"/"+cm_date.substring(4,6)+"/"+cm_date.substring(6,8);
	       }  
	       act_qty=subRs.getString("ACT_QTY");
	       if (act_qty==null) 
	       { 
	          act_qty="&nbsp;";
	       } else {
	          act_qtyTotal=String.valueOf(Float.parseFloat(act_qtyTotal)+Float.parseFloat(act_qty)); 
	       }
	       act_date=subRs.getString("ACT_DATE");
	       if (act_date==null) 
	       {
	          act_date="&nbsp;";
	       } else {
	          if (act_date.length()==8) act_date=act_date.substring(0,4)+"/"+act_date.substring(4,6)+"/"+act_date.substring(6,8);
	       } 
  %>
     <TR BGCOLOR=<%=bgColor%>>
	 <TD>
	 <%
	    if (v_to_sub==subRow) //如果是子項目的最後一個
		 {
		    out.println("&nbsp;<img border='0' src='../image/branchend.gif'>");				     
		 } else {
		    out.println("&nbsp;<img border='0' src='../image/branch.gif'>");				     
		 }
	 %>	 
	 <FONT SIZE=2><%=f_interModel%></TD>
	 <TD><%=f_extModel%></TD><TD><%=f_color%></TD><TD><div align="center"><img border='0' src='../image/arrowup.gif'></div></TD>
     <TD><div align="center"><img border='0' src='../image/arrowup.gif'></div></TD>
     <TD><div align="center"><img border='0' src='../image/arrowup.gif'></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=cm_qty%></strong></FONT></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=cm_date%></strong></FONT></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=act_qty%></strong></FONT></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=act_date%></strong></FONT></div></TD>
    <TD>
	  <%   
       if (!remark1.equals("")) //若有備註說明才秀出
	   {
	     out.println("<img title='"+remark1+"' src='../image/docicon.gif'>");
	   } 
     %>
	 &nbsp;
	 </TD>
     <TD>
	 <%
      if (!remark2.equals("")) //若有備註說明才秀出
	  {
	     out.println("<img title='"+remark2+"' src='../image/docicon.gif'>");
	  } 
    %>
	 &nbsp;
	 </TD>
    </tr>	 
<%	  
             v_to_sub++;
          }  //end of while => subRs.next	
	  }	 //end of if => if (subRow>1)       
    if (subRs!=null) subRs.close(); 

	origin_rqtyTotal=String.valueOf(Float.parseFloat(origin_rqtyTotal)+Float.parseFloat(origin_rqty));	
	ep_qtyTotal=String.valueOf(Float.parseFloat(ep_qtyTotal)+Float.parseFloat(ep_qty));
	
    if (bgColor.equals("B0E0E6")) //間隔列顏色改換
    {
      bgColor="ADD8E6";
    } else {
      bgColor="B0E0E6";	  
    }           		             
   } //end of rs.next() while    
   rs.close();      
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
<TR>
  <TD colspan="2"><font color="#FF0000"><strong>Target Date:<%=targetYear%>/<%=targetMonth%></strong></font><font color="#FF0000">&nbsp;</font></TD>
  <TD BGCOLOR=#0099CC><div align="right"><FONT COLOR=WHITE>TOTAL</font></div></TD>
  <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=origin_rqtyTotal%></strong></font></div></TD>
  <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=ep_qtyTotal%></strong></font></div></TD>
  <TD BGCOLOR=#0099CC>&nbsp;</TD>
  <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=cm_qtyTotal%></strong></font></div></TD>
  <TD BGCOLOR=#0099CC>&nbsp;</TD>
  <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=act_qtyTotal%></strong></font></div></TD>
  <TD colspan="3" BGCOLOR=#0099CC>&nbsp;</TD>
  </TR>
<TR bgcolor="#FFFFCC">
  <TD colspan="14"><div align="left"><strong>REMARK:</strong><%=remark%></div></TD></TR>           
 </TABLE>
<HR>
<table width="62%" border="1" bordercolordark="#999999">
     <tr bgcolor="#0099CC">
       <td width="27%"><strong><font color="#FFFFFF">處理人</font></strong></td>
       <td width="39%"><strong><font color="#FFFFFF">處理時間</font></strong></td>
       <td width="34%"><strong><font color="#FFFFFF">動作</font></strong></td>
     </tr>
     <TR>
       <td><font size=2><%=createByName%></font></td>
       <td><font size=2><%=createDate%>-<%=createTime%></font></td>
       <td><font size=2>ISSUE</font></td>
     </tr>   
<%     		 
try
{      
   rs=statement.executeQuery("select USERNAME,ACT_DATE,ACT_TIME,ACTION from PSALES_FORE_MRC_HIST,WSUSER where DOCNO='"+docNo+"' and WHO=WEBID order by ACT_DATE DESC,ACT_TIME"); 	     
   while (rs.next())
   {
	  updateMan=rs.getString("USERNAME");
	  updateDate=rs.getString("ACT_DATE");
	  updateTime=rs.getString("ACT_TIME");	 
	  updateDate=updateDate.substring(0,4)+"/"+updateDate.substring(4,6)+"/"+updateDate.substring(6,8);	 
	  updateTime=updateTime.substring(0,2)+":"+updateTime.substring(2,4); 
	  action=rs.getString("ACTION"); 
	  %>
     <TR> 
       <td ><font size=2><%=updateMan%></font></td>
       <td><FONT SIZE=2><%=updateDate%>-<%=updateTime%></font></td>	    
       <td><FONT SIZE=2><%=action%></font></td>
	</TR>  
	  <%  
    } 
    rs.close();                       		                 		    	   		
} //end of try
catch (Exception e1)
{
  %>
    <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <%
  out.println("Exception:"+e1.getMessage());
}
%>   
  </table>
<!-- 表單參數 --> 
<input name="DOCNO" type="HIDDEN" value="<%=docNo%>" >
</FORM>
</body>
<%
  statement.close();	
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
