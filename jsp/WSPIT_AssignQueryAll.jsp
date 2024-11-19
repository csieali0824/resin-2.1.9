<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript"> 
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
function setSubmit()
{  
   if (document.MYFORM.PRODUCT.value=="--" || document.MYFORM.PRODUCT.value==null || document.MYFORM.PRODUCT.value=="")
  { 
   alert("Please Check the PRODUCT!!It should not be null or blanked");   
   return(false);
  } 

   if (document.MYFORM.MODEL.value=="--" || document.MYFORM.MODEL.value==null || document.MYFORM.MODEL.value=="")
  { 
   alert("Please Check the MODEL!!It should not be null or blanked");   
   return(false);
  } 

  if (document.MYFORM.OBJECT.value=="--" || document.MYFORM.OBJECT.value==null || document.MYFORM.OBJECT.value=="")
  { 
   alert("Please Check the OBJECT!!It should not be null or blanked");   
   return(false);
  }    
	 
 document.MYFORM.submit();
}

function setSubmit2(ch,URL)
{      
   var pass="N";
   if (ch.length!=null)
   {
	   for (j=0;j<ch.length;j++)
	   {
		  if (ch[j].checked==true)
		  {
			pass="Y";
			break;
		  }
	   }   
   } else {
     if (ch.checked==true)  pass="Y";
   }
     
   if (pass!="Y")  //若沒有任何資料則不能存檔
   {
       alert("No Need to Submit because there is no any data being Selected!!");   
       return(false);
   }
   
   if (document.MYFORM.ACTION.value=="--") //如果沒有選取任何動作,則不能submit
   {
       alert("Please select a proper ACTION first!!");   
       return(false);
   }

   if (document.MYFORM.ACTION.value=="007" && (document.MYFORM.ASSIGNTO.value=="--" || document.MYFORM.ASSIGNTO.value==null)) //如果選取動作為ASSIGN,則ASSIGNTO欄位必須有值
   {
       alert("Please assign SOMEONE before you submit!!");   
       return(false);
   }

   if (document.MYFORM.ACTION.value=="099") //如果action是close,則必須檢查remark欄位是否有輸入資料
   {
      if (ch.length!=null)
      {
		   for (i=0;i<ch.length;i++)
		   {          
			   if (ch[i].checked==true)  	      
			   {
					 if (document.MYFORM.elements["REMARK-"+ch[i].value].value=="" || document.MYFORM.elements["REMARK-"+ch[i].value].value==null)
					 { 
					   alert("Before you want to CLOSE , please do not let the REMARK be Null !!");   
					   return(false);
					 }	            
			   } //end of if  ch[i].checked==true 
		   } //end of for null check */ 
	   } else {
	        if (ch.checked==true)  	      
			   {
					 if (document.MYFORM.elements["REMARK-"+ch.value].value=="" || document.MYFORM.elements["REMARK-"+ch.value].value==null)
					 { 
					   alert("Before you want to CLOSE , please do not let the REMARK be Null !!");   
					   return(false);
					 }	            
			   } //end of if  ch[i].checked==true	   
	   }	   
    }	   

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function openForm(docno) 
{   
  location.href="WSPIT_Assign.jsp?TICKETNO="+docno;  
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>PIT ASSIGN Form</title>
</head>
<body>
<FORM ACTION="WSPIT_AssignQueryAll.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>產品問題追蹤-指派處理中</strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>  
<%           
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  Statement subStmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet rs=null,subRs=null;	 
  
  String product=request.getParameter("PRODUCT"); 
  String model=request.getParameter("MODEL"); 
  String object=request.getParameter("OBJECT"); 
  String version=request.getParameter("VERSION"); 
  String source=request.getParameter("SOURCE"); 
  String country=request.getParameter("COUNTRY"); 
  String sLvl=request.getParameter("SLVL");  
  
  String dateString=dateBean.getYearMonthDay();
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>PRODUCT:</strong></font>
      <%      
	  try
      {     	         
	      String sql="select unique PRODUCT a,PRODUCT b from PIT_MASTER";
		  sql=sql+" order by a";		  
          rs=statement.executeQuery(sql);			  	 	    			
	      comboBoxBean.setRs(rs);	  
		  comboBoxBean.setFontSize(9); 
		  comboBoxBean.setSelection(product);	 
		  comboBoxBean.setOnChangeJS(""); 
	      comboBoxBean.setFieldName("PRODUCT");	   
          out.println(comboBoxBean.getRsString());	      	           
		  rs.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>      </td>
      <td height="23" bordercolor="#FFFFFF">
        <p><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>MODEL:</strong></font> 
            <% 		 		 		 
	     try
         {   
		    String sql="select unique MODEL a,MODEL b from PIT_MASTER";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(model);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("MODEL");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </td>
      <td><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font></strong></font><font color="#333399" face="Arial Black" size="2"><strong>OBJECT</strong></font>: 
          <% 		 		 		 
	     try
         {   
		    String sql="select unique p.T_OBJECT as b, o.NAME as a from PIT_MASTER p,PIT_OBJECT o"+
			           " where p.T_OBJECT=o.OBJECTID";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(object);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("OBJECT");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	     		                   		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>      </td>
      <td><font color="#333399" face="Arial Black" size="2"><strong>VERSION:</strong></font> 
          <% 		 		 		 
	     try
         {   
		    String sql="select unique T_VERSION a,T_VERSION b from PIT_MASTER";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(version);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("VERSION");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
    </tr>
    <tr bgcolor="#D0FFFF">
      <td width="15%" bordercolor="#FFFFFF"><font color="#333399" face="Arial Black" size="2"><strong>SOURCE:</strong></font> 
        <% 		 		 		 
	     try
         {   
		    String sql="select unique p.T_SOURCE as b, s.NAME as a from PIT_MASTER p,PIT_SOURCE s"+
			           " where p.T_SOURCE=s.SOURCEID";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(source);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("SOURCE");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td> 
      <td width="15%" height="23" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>COUNTRY:
        <% 		 		 		 
	     try
         {   
		    String sql="select unique LOCALE as b,LOCALE_ENG_NAME||'('||LOCALE||')' as a from PIT_MASTER p,PIT_VERSION v,WSLOCALE l"+
			           " where p.T_VERSION=v.T_VERSION and v.COUNTRY=l.LOCALE";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(country);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("COUNTRY");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </strong></font></td>
      <td width="14%"><font color="#330099" face="Arial Black" size="2"><strong>S.Level:
        <% 		 		 		 
	     try
         {   
		    String sql="select unique S_LEVEL a,S_LEVEL b from PIT_MASTER where s_LEVEL is not null ";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(sLvl);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("SLVL");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </strong></font></td>
      <td width="25%"><input name="submit1" type="submit" value="Query" onClick='return setSubmit()'></td>
    </tr>	
  </table>
	<HR>
	<table width="100%" border="1">
      <tr bordercolor="#0099FF" bgcolor="#99FFFF">
        <td width="21%">ACTION: 
        <%      
	  try
      {     	         
	      String sql="SELECT w.ACTIONID,a.ACTIONNAME FROM WSWORKFLOW w,WSWFACTION a WHERE w.ACTIONID=a.ACTIONID and FORMID='PIT' AND TYPENO='001' AND FROMSTATUSID='101'";		  	  
          rs=statement.executeQuery(sql);			  	 	    			
	      comboBoxBean.setRs(rs);	  
		  comboBoxBean.setFontSize(11); 		  	 
		  comboBoxBean.setOnChangeJS(""); 
	      comboBoxBean.setFieldName("ACTION");	   
          out.println(comboBoxBean.getRsString());	      	           
		  rs.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></td>
        <td width="31%">ASSIGN TO:
        <%      
	  try
      {     	         
	      String sql="SELECT WEBID,USERNAME FROM WSUSER WHERE LOCKFLAG!='Y' order by USERNAME";		  	  
          rs=statement.executeQuery(sql);			  	 	    			
	      comboBoxBean.setRs(rs);	  
		  comboBoxBean.setFontSize(11); 		  	 
		  comboBoxBean.setOnChangeJS(""); 
	      comboBoxBean.setFieldName("ASSIGNTO");	   
          out.println(comboBoxBean.getRsString());	      	           
		  rs.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></td>
        <td width="26%">DUE DATE :
	    <input name="DUEDATE" type="text" size="5" value='<%=dateString%>'><A href='javascript:void(0)' onclick="gfPop.fPopCalendar(document.MYFORM.elements['DUEDATE']);return false;"><img border='0' src='../image/calbtn.gif'></A>		</td>
        <td width="22%"><INPUT TYPE="button"  value="<-Submit" onClick='setSubmit2(document.MYFORM.CH,"WSPIT_Process.jsp")' ></td>
      </tr>
    </table>
	<HR>
	<TABLE width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">	
	<TR bgcolor="#CCFFFF"><TH width="2%"><input name="checkselect" type=checkbox onClick="this.value=check(this.form.CH)" title="選取或取消選取"></TH><TH width="2%">&nbsp;&nbsp;</TH>
	  <TH width="10%"><font size="2">Function</font></TH>
	  <TH width="14%"><font size="2">Version</font></TH>
	  <TH width="5%"><font size="2">S.Level</font></TH>
	  <TH width="25%"><font size="2">Phenomenon</font></TH>
	  <TH width="7%"><font size="2">Probability</font></TH>	 
	  <TH width="23%"><font size="2">Remark</font></TH>
	  </TR>
<% 		 		 		
String ticketNo="",mFunc="",sFunc="",v_version="",v_level="",phnmn="",pbbt=""; 
try
{   
	String sql="select TICKETNO,MFUNCTION,f.NAME as sFunc,p.T_VERSION,S_LEVEL,PHNMN,PBBT from PIT_MASTER p,PIT_FUNCTION f,PIT_VERSION v";
	String sqlWhere=" where p.SFUNCTION=f.CODE and p.T_VERSION=v.T_VERSION and STATUSID='101'"; //把狀態為SUBMITTED的資料取出
	sqlWhere=sqlWhere+" and p.PRODUCT='"+product+"'";
	sqlWhere=sqlWhere+" and p.MODEL='"+model+"'";
	sqlWhere=sqlWhere+" and p.T_OBJECT='"+object+"'";
	if (version!=null && !version.equals("--")) sqlWhere=sqlWhere+" and p.T_VERSION='"+version+"'";
	if (source!=null && !source.equals("--")) sqlWhere=sqlWhere+" and T_SOURCE='"+source+"'";
	if (sLvl!=null && !sLvl.equals("--")) sqlWhere=sqlWhere+" and S_LEVEL='"+sLvl+"'";
	if (country!=null && !country.equals("--")) sqlWhere=sqlWhere+" and v.COUNTRY='"+country+"'";
	
	sql=sql+sqlWhere+" order by TICKETNO";		
	rs=statement.executeQuery(sql);
	while (rs.next()) //main loop			 	    				
	{
	   ticketNo=rs.getString("TICKETNO");
	   mFunc=rs.getString("MFUNCTION");
	   sFunc=rs.getString("SFUNC");
	   v_version=rs.getString("T_VERSION");
	   v_level=rs.getString("S_LEVEL");
	   phnmn=rs.getString("PHNMN");
	   pbbt=rs.getString("PBBT");
%>		
	<TR><TD><INPUT TYPE=checkbox NAME='CH' VALUE="<%=ticketNo%>"></TD><TD><A href='javascript:openForm("<%=ticketNo%>")'><IMG border="0" src="../image/docicon.gif"></A></TD>
	  <TD><font size="2"><%=mFunc+"-"+sFunc%></font></TD>
	  <TD><font size="2"><%=v_version%></font></TD>
	  <TD><div align="center"><font size="2"><%=v_level%></font></div></TD>
	  <TD><font size="2"><%=phnmn%></font></TD>
	  <TD><div align="center"><font size="2"><%=pbbt%>%</font></div></TD>	 
	  <TD><font size="2"><textarea name="REMARK-<%=ticketNo%>" cols="20" rows="3" ></textarea></font></TD>	  
	  </TR>
<%	 
    } //end of while => rs.next() 
	rs.close();      	
} //end of try
catch (Exception ee)
{
    %>
	  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
	<%  
    out.println("Exception:"+ee.getMessage());		  
}	
%>  
  </TABLE>
 <!-- 表單參數 -->  
    <input name="OBJECTNAME" type="HIDDEN" value="">	
	<input name="SOURCENAME" type="HIDDEN" value="">		
	<input name="FROMSTATUS" type="HIDDEN" value="101">		
	<input name="FORMID" type="HIDDEN" value="PIT">
	<input name="TYPENO" type="HIDDEN" value="001">
</FORM>
<iframe width=80 height=80 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%
 subStmt.close();
 statement.close();  
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
