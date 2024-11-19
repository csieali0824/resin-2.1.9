<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%
 String searchString=request.getParameter("SEARCHSTRING");
 try
 {
   if (searchString==null)
   {
    searchString="";
   }
 } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>Page for choose customer to add to repair case</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(agentno,agentname,agentaddr,agenttel,agentfax,agent_unitno,contactman,sendImeiFreq)
{   
 window.opener.document.MYFORM.AGENTNO.value=agentno;
 window.opener.document.MYFORM.CUSTNAME.value=agentname;
 window.opener.document.MYFORM.CUSTADDRESS.value=agentaddr;
 window.opener.document.MYFORM.CONTACTTEL.value=agenttel;
 window.opener.document.MYFORM.CONTACTFAX.value=agentfax;
 window.opener.document.MYFORM.UNITNO.value=agent_unitno;
 window.opener.document.MYFORM.CONTACT.value=contactman;
 window.opener.document.MYFORM.SENDIMEIFREQ.value=sendImeiFreq; 
 /*
 window.opener.document.MYFORM.BUYPLACE.value=buyplace;
 window.opener.document.MYFORM.BUYYEAR.value=buydate.substring(0,4);
 window.opener.document.MYFORM.BUYMONTH.value=buydate.substring(4,6);
 window.opener.document.MYFORM.BUYDATE.value=buydate.substring(6,8);
 window.opener.document.MYFORM.MODEL.value=model;
 window.opener.document.MYFORM.COLOR.value=color;
 window.opener.document.MYFORM.WARRNO.value=warrno; 
 window.opener.document.MYFORM.ZIP.value=zip; 
 window.opener.document.MYFORM.JAMFREQ.value=jamFreq; 
 */
 this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="/wins/jsp/subwindow/CustomerIMEISubWindow.jsp">
<!--%<A HREF=/wins/jsp/subwindow/AgentInfoSubWindow.jsp>切換到經銷/代理商資訊</A><BR>%-->
  <font size="-1">客戶名稱或IMEI序號: 
  <input type="text" name="SEARCHSTRING" size=20 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
  -----客戶資訊--------------------------------------------     
  <BR>
  <%  
	  try
      { 
	   if (searchString!="" && searchString!=null) 
	   {  	    
	    String sql = "select DISTINCT a.AGENTNO, a.AGENTNAME, a.AGENTADDR, a.AGENTTEL, a.AGENTFAX, a.AGENT_UNITNO, a.CONTACTMAN from WSCUST_AGENT a, IMEI_TRACKING b where a.AGENTNO=b.CUST_NO and trim(a.AGENTNAME) like '"+searchString+"%' or trim(b.IMEI) like '"+searchString+"%'";
        Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql);
		//out.println(sql);
       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE>");      
        out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=1;i<=colCount;i++)
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
        out.println("</TR>");
		String v_agentno=null,v_agentname=null,v_agentaddr=null,v_agenttel=null,v_agentfax=null,v_agent_unitno=null,v_contactman=null;
        //String v_cmraddr=null,v_imei=null,v_dsn=null,v_cmrname=null,v_cmrtel=null,v_cmrcell=null;
		//String v_buyplace=null,v_buydate=null,v_model=null,v_color=null,v_warrno=null,v_zip=null;
		String v_sendImeiFreq="";
        String buttonContent=null;
		 
        while (rs.next())
        {
		 v_agentno=rs.getString("AGENTNO");
		 v_agentname=rs.getString("AGENTNAME");
		 v_agentaddr=rs.getString("AGENTADDR");
		 v_agenttel=rs.getString("AGENTTEL");
		 v_agentfax=rs.getString("AGENTFAX");
		 v_agent_unitno=rs.getString("AGENT_UNITNO");
		 v_contactman=rs.getString("CONTACTMAN");
		 //v_buyplace=rs.getString("BUYPLACE");
		// v_buydate=rs.getString("BUYDATE");
		 //v_model=rs.getString("MODEL");
		 //v_color=rs.getString("COLOR");
		 //v_warrno=rs.getString("WARRNO");
		 //v_zip=rs.getString("ZIP");
		 v_sendImeiFreq="0";
		 
	     Statement seqStat=con.createStatement();
         ResultSet seqRs=seqStat.executeQuery("select COUNT (*) from IMEI_TRACKING where CUST_NO='"+v_agentno+"'");
	     seqRs.next();
	     if (seqRs.getInt(1)>0)
	     {
	      v_sendImeiFreq=seqRs.getString(1); //計算出送件數(By IMEI數)
	     }	
		 else
		 {
		   v_sendImeiFreq= "0";
		 }
		 //out.println(v_sendImeiFreq);
		 
		 buttonContent="this.value=sendToMainWindow("+'"'+v_agentno+'"'+','+'"'+v_agentname+'"'+','+'"'+v_agentaddr+'"'+','+'"'+v_agenttel+'"'+','+'"'+v_agentfax+'"'+','+'"'+v_agent_unitno+'"'+','+'"'+v_contactman+'"'+','+'"'+v_sendImeiFreq+'"'+")";
		 //buttonContent="this.value=sendToMainWindow("+'"'+v_agentno+'"'+','+'"'+v_agentname+'"'+','+'"'+v_agentaddr+'"'+','+'"'+v_agenttel+'"'+','+'"'+v_agentfax+'"'+','+'"'+v_agent_unitno+'"'+','+'"'+v_contactman+'"'+','+'"'+v_sendImeiFreq+'"'+','+'"'+v_model+'"'+','+'"'+v_color+'"'+','+'"'+v_warrno+'"'+','+'"'+v_zip+'"'+','+'"'+v_jamFreq+'"'+")";
         out.println("<TR BGCOLOR=E3E3CF><TD><INPUT TYPE=button NAME='button' VALUE='帶入' onClick='"+buttonContent+"'></TD>");
		 //out.println("<TR BGCOLOR=E3E3CF><TD><INPUT TYPE=button NAME='button' VALUE='帶入' onClick='this.value=sendToMainWindow()'></TD>");
         for (int i=1;i<=colCount;i++)
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         } //end of for
          out.println("</TR>");
		  
		 seqStat.close();
         seqRs.close();
        } //end of while
        out.println("</TABLE>");						
		
		statement.close();
        rs.close();       
	   }//end of while
      } //end of try
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
     %>
  <BR>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
