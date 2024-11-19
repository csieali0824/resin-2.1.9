<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,ForecastInputBean,ForePriCostInputBean,RsCountBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<script language="JavaScript" type="text/JavaScript"> 
versionArray=new Array();
modelArray=new Array();		    
productArray=new Array();
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
   for (j=0;j<ch.length;j++)
   {
      if (ch[j].checked==true)
	  {
	    pass="Y";
		break;
	  }
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
    }	   

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function openForm(docno) 
{   
  location.href="WSPIT_Display.jsp?TICKETNO="+docno;  
}
function showSource()
{        
   var sourceObj;  
   sourceObj = document.MYFORM.SOURCE;   
   
   var str1=sourceObj.options[sourceObj.selectedIndex].text;
   document.MYFORM.SOURCENAME.value=str1; //將名稱寫入隱藏參數欄位  
}

function showVersion(gg)
{      
   var productObj,modelObj,objectObj;
   productObj = document.MYFORM.PRODUCT;
   modelObj = document.MYFORM.MODEL;
   objectObj = document.MYFORM.OBJECT;
   
   var str1=objectObj.options[objectObj.selectedIndex].text;
   document.MYFORM.OBJECTNAME.value=str1; //將名稱寫入隱藏參數欄位
  
   for (t=0;t<gg;t++)  //清空所有選項
   {
     if (document.MYFORM.VERSION.options[0].value!=null)
	 {         
       document.MYFORM.VERSION.options[0] =null;		
	 }  	   
   }

   if (objectObj.value=="--")
   {                  
     document.MYFORM.VERSION.options[0] = new Option("--","--");
   } else {            
      var j=0;
	  var pmoStr=productObj.value+"-"+modelObj.value+"-"+objectObj.value;	  
      for (gc=0;gc<versionArray.length;gc++)
      {  	     
         if (versionArray[gc][0]==pmoStr)
	     { 	        
	          document.MYFORM.VERSION.options[j] = new Option(versionArray[gc][1],""+versionArray[gc][1]);            
			  j++;
	     } 
      }	
   } //end of if  =>objectObj.value=="--"   
}
function showModel(gg)
{   
  //先將OBJECT之值歸零
   document.MYFORM.OBJECT.selectedIndex=0; 
  
  //以下為處理動態show出model   
   var productObj;
   productObj = document.MYFORM.PRODUCT;              
   
   for (t=0;t<gg;t++)  //清空所有選項
   {
     if (document.MYFORM.MODEL.options[0].value!=null)
	 {         
       document.MYFORM.MODEL.options[0] =null;		
	 }  	   
   }    
   
   if (productObj.value=="--")
   {                  
     document.MYFORM.MODEL.options[0] = new Option("--","--");
   } else {            
      for (i=0;i<productArray.length;i++)
      {  
         if (productArray[i]==productObj.value)
	     { 
	        for (j=0;j<modelArray[i].length;j++)
		    {			   			  
	          document.MYFORM.MODEL.options[j] = new Option(modelArray[i][j],""+modelArray[i][j]);
            }
	     } 
      }	
   } //end of if  =>productObj.value=="--"     
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>PIT Form</title>
</head>
<body>
<FORM ACTION="WSPIT_QueryAll.jsp" METHOD="post" NAME="MYFORM">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>產品問題追蹤</strong></font> &nbsp;&nbsp;&nbsp;&nbsp; <A HREF="/wins/WinsMainMenu.jsp">HOME</A> 
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
  String status=request.getParameter("STATUS");  
  String dateString=dateBean.getYearMonthDay();
  String productArray[]=null;

%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong><font color="#FF0000">*</font>PRODUCT:</strong></font>
      		<%      
	  try
      {     	         
        rs=statement.executeQuery("select PROD_CLASS A,PROD_CLASS B from MRPRODCLS order by A");	   
	    rsCountBean.setRs(rs); //取得其line detail總筆數
	    productArray=new String[rsCountBean.getRsCount()]; //宣告為符合其總筆數大小之陣列
			  		  		  
		  int pi=0; 
          while (rs.next())
          {     
		   int mi=0;//代表共有多少筆屬於該product的model       
           String s1=(String)rs.getString(1);            
		   productArray[pi]=s1;
		   %>
             <script language="JavaScript" type="text/JavaScript">
			  productArray[<%=pi%>]="<%=s1%>";
		      modelArray[<%=pi%>]=new Array();			    		      
		     </script>
           <%   		   		   		   		  			
			 subRs=subStmt.executeQuery("select PROJECTCODE from PIMASTER where PRODUCTTYPE='"+s1+"' order by PROJECTCODE");  
		     while (subRs.next())
		     {
		       String cn1=(String)subRs.getString(1);//專案/機種代碼 	 					   
			   %>
               <script language="JavaScript" type="text/JavaScript">			    		        			    
		        modelArray[<%=pi%>][<%=mi%>]="<%=cn1%>";
		       </script>
           <%			 			 
			   mi++;
		     } //end of while=>subRs.next()	 
		     subRs.close();
		     pi++;
           } //end of while => rs.next();
		   rs.close(); 		 		
	   
	       arrayComboBoxBean.setArrayString(productArray); 		   
		   arrayComboBoxBean.setOnChangeJS("showModel(document.MYFORM.MODEL.length)");
	       arrayComboBoxBean.setFieldName("PRODUCT");
		   //arrayComboBoxBean.setSelection(product);	 
	       out.println(arrayComboBoxBean.getArrayString());	      	           
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
		     out.println("<select NAME='MODEL'>");
             out.println("<OPTION VALUE='--'>--");  		 
		     out.println("</select>");		  
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
		    rs=statement.executeQuery("select OBJECTID,NAME from PIT_OBJECT order by OBJECTID");	 	 	    		
			
	        comboBoxBean.setRs(rs);	   
			comboBoxBean.setOnChangeJS("showVersion(document.MYFORM.VERSION.length)"); 
	        comboBoxBean.setFieldName("OBJECT");	   
            out.println(comboBoxBean.getRsString());	   
	   
            rs.close();         		                   		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>      </td>
      <td colspan=2><font color="#333399" face="Arial Black" size="2"><strong>VERSION:</strong></font> 
                  <% 		 		 		 
	     try
         {   
		    int pmovi=0;
		    subRs=subStmt.executeQuery("select PRODUCT||'-'||MODEL||'-'||T_OBJECT as PMO,T_VERSION from PIT_VERSION where ACTIVE='Y' order by PMO,T_VERSION");	   	 	    				
			while (subRs.next())
			{
			   String cn1=(String)subRs.getString(1);//產品/機種/物件
			   String cn2=(String)subRs.getString(2);//版本
		   %>
             <script language="JavaScript" type="text/JavaScript">			  
		      versionArray[<%=pmovi%>]=new Array();
			  versionArray[<%=pmovi%>][0]="<%=cn1%>";		
			  versionArray[<%=pmovi%>][1]="<%=cn2%>";	    		      
		     </script>
           <%  		 
		       pmovi++;
		    }
			subRs.close();
			
		     out.println("<select NAME='VERSION'>");
             out.println("<OPTION VALUE='--'>--");  		 
		     out.println("</select>");		  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
    </tr>
    <tr bgcolor="#D0FFFF">
      <td width="21%" bordercolor="#FFFFFF"><font color="#333399" face="Arial Black" size="2"><strong>SOURCE:</strong></font> 
        <% 		 		 		 
	     try
         {   
		    rs=statement.executeQuery("select SOURCEID,NAME from PIT_SOURCE order by NAME");	   
	 	    			
	        comboBoxBean.setRs(rs);	   
			comboBoxBean.setOnChangeJS("showSource()"); 
	        comboBoxBean.setFieldName("SOURCE");	   
            out.println(comboBoxBean.getRsString());	   
	   
            rs.close();   	  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td> 
      <td width="19%" height="23" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>COUNTRY:
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
      <td width="21%"><font color="#330099" face="Arial Black" size="2"><strong>S.Level: 
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
      <td width="20%"><font color="#330099" face="Arial Black" size="2"><strong>STATUS: 
        <% 		 		 		 
	     try
         {   
		    String sql="select unique STATUS a,STATUS b from PIT_MASTER where STATUS is not null ";
		    sql=sql+" order by a";		  
            rs=statement.executeQuery(sql);			  	 	    			
	        comboBoxBean.setRs(rs);	  
		    comboBoxBean.setFontSize(9); 
		    comboBoxBean.setSelection(status);	 
		    comboBoxBean.setOnChangeJS(""); 
	        comboBoxBean.setFieldName("STATUS");	   
            out.println(comboBoxBean.getRsString());	
			rs.close();      	
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </strong></font></td>
      <td width="19%"><input name="submit1" type="submit" value="Query" onClick='return setSubmit()'></td>
    </tr>	
  </table>
	<HR>
	<TABLE width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">	
	<TR bgcolor="#CCFFFF">
	  <TH width="2%">&nbsp;&nbsp;</TH>
	  <TH width="7%"><font size="2">Version</font></TH>
	  <TH width="6%"><font size="2">S.Level</font></TH>
	  <TH width="34%"><font size="2">Phenomenon</font></TH>
	  <TH width="16%"><font size="2">Correction Action</font></TH>
	  <TH width="6%"><font size="2">Result</font></TH>	
	  <TH width="7%"><font size="2">Status</font></TH>	 
	  <TH width="10%"><font size="2">Assign To</font></TH>
	  <TH width="12%"><font size="2">Due Date</font></TH>
	  </TR>
<% 		 		 		
String ticketNo="",mFunc="",sFunc="",v_version="",v_level="",phnmn="",pbbt="",CoAction="",duedate="",assignto="",result="",username=""; 
try
{   
	String sql="select TICKETNO,MFUNCTION,f.NAME as sFunc,p.T_VERSION,S_LEVEL,PHNMN,PBBT,p.STATUS,p.CORRECTACTION,p.duedate,p.assignto,p.result,W.USERNAME from PIT_MASTER p,PIT_FUNCTION f,PIT_VERSION v,WSUSER w";
	String sqlWhere=" where  p.ASSIGNTO=W.WEBID(+) and p.SFUNCTION=f.CODE and p.T_VERSION=v.T_VERSION "; //把狀態為SUBMITTED的資料取出
	sqlWhere=sqlWhere+" and p.PRODUCT='"+product+"'";
	sqlWhere=sqlWhere+" and p.MODEL='"+model+"'";
	sqlWhere=sqlWhere+" and p.T_OBJECT='"+object+"'";
	if (version!=null && !version.equals("--")) sqlWhere=sqlWhere+" and p.T_VERSION='"+version+"'";
	if (source!=null && !source.equals("--")) sqlWhere=sqlWhere+" and T_SOURCE='"+source+"'";
	if (sLvl!=null && !sLvl.equals("--")) sqlWhere=sqlWhere+" and S_LEVEL='"+sLvl+"'";
	if (country!=null && !country.equals("--")) sqlWhere=sqlWhere+" and v.COUNTRY='"+country+"'";
	if (status!=null && !status.equals("--")) sqlWhere=sqlWhere+" and p.status='"+status+"'";
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
	   CoAction=rs.getString("CORRECTACTION");
	   pbbt=rs.getString("PBBT");
	   status=rs.getString("status");
	   duedate=rs.getString("duedate");
	   assignto=rs.getString("assignto");
	   result=rs.getString("result");
	   username=rs.getString("username");
%>		
	<TR>
      <TD><A href='javascript:openForm("<%=ticketNo%>")'><IMG border="0" src="../image/docicon.gif"></A></TD>
	  <TD><font size="2"><%=v_version%></font></TD>
	  <TD><div align="center"><font size="2"><%=v_level%></font></div></TD>
	  <TD><font size="2"><%=phnmn%></font></TD>
	  <TD><font size="2"><%=CoAction%></font></TD>
	  <TD><div align="center"><font size="2"><%=result%></font></div></TD>	
	  <TD><div align="center"><font size="2"><%=status%></font></div></TD>	 
	  <TD><div align="center"><font size="2"><%=username%></font></div></TD>	
	  <TD><div align="center"><font size="2"><%=duedate%></font></div></TD>	 

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
