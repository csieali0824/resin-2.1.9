<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>RpprogrammerInputPage.jsp</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
var chkflag="false";
function buttonContent()
{ 
  subWin=window.open("subwindow/RPPROGRAMMERITEMSubWindow.jsp","subwin","width=600,height=400,scrollbars=yes,menubar=no"); 
  chkflag = "true"; 
}

function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<%@ page import="CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayCheckBoxBean"%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--此bean作用在存入故障描述-->
<%
  arrayCheckBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
%>
</head>
<body>

<%
      String programmername=request.getParameter("PROGRAMMERNAME");   
     String rolename=request.getParameter("ROLENAME");
     String model=request.getParameter("model"); 
	 if (model==null)
	{model="A1"; }
	 String EDITION=null;
	 String dateString=null;
	 String Month=null;
	 String Day=null;
	 String Hour=null;
	 String NEWSID=null;
	 String HourSecond=null;
	 String TIME=null;
  
  try
    {
	Statement statement=con.createStatement();
	
	 dateString=dateBean.getYearMonthDay();
     Month=dateBean.getMonthString();
     Day=dateBean.getDayString();
     Hour=dateBean.getHourMinute();
	 HourSecond=dateBean.getHourMinuteSecond();
	 TIME=dateString+HourSecond;
     EDITION=dateString+Hour;
     NEWSID=Month+Day+Hour;
	 //out.print(TIME+"<br>");
	 //out.print(EDITION+"<br>");
	 //out.print(NEWSID);
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>


<%
String ROLENAM="";
String s1="";
String s2="";
String s4=""; 
String s5=""; 

//String rolename="";
String address="";
String addressdesc="";

//String programmername="";
String lineno="";


//String roleaddress=request.getParameter("ROLEADDRESS");

//out.print("ROLEADDRESS:"+roleaddress);


%>
<FORM ACTION="/wins/jsp/RpprogrammerInsert.jsp" METHOD="post" NAME="MYFORM" >
  <table width="64%"  border="1"  bordercolor="#6699CC" align="center">
    <tr> 
      <td width="28%" height="77" background="../image/back5.gif" ><input type="hidden" name="ADDRESSDESC" value="<%= TIME %>" > 
        <a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammer.jsp">查詢所有角色記錄</A> <p><BR> <font color="#FF3333" size="3"><strong>程式對應角色新增</strong></font>&nbsp; 
      </td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> 模組: 
        <select name="model" onChange="setSubmit('../jsp/RpprogrammerInputPage.jsp')">
          <option value="A1" <% if (model!=null && (model=="A1" || model.equals("A1")) ) { out.println("SELECTED"); } %>>A1 
          人員群組管理 </option>
          <option value="B1" <% if (model!=null && (model=="B1" || model.equals("B1")) ) { out.println("SELECTED"); } %>>B1 
          報表查詢 </option>
          <option value="C1" <% if (model!=null && (model=="C1" || model.equals("C1")) ) { out.println("SELECTED"); } %>>C1 
          資料維護與管理 </option>
          <option value="D1" <% if (model!=null && (model=="D1" || model.equals("D1")) ) { out.println("SELECTED"); } %>>D1 
          SALES FORECAST </option>
          <option value="E1" <% if (model!=null && (model=="E1" || model.equals("E1")) ) { out.println("SELECTED"); } %>>E1 
          出貨管理 </option>
          <option value="F1" <% if (model!=null && (model=="F1" || model.equals("F1")) ) { out.println("SELECTED"); } %>>F1 
          LC維護管理 </option>
          <option value="G1" <% if (model!=null && (model=="G1" || model.equals("G1")) ) { out.println("SELECTED"); } %>>G1 
          產品發展平台資料查詢 </option>
          <option value="H1" <% if (model!=null && (model=="H1" || model.equals("H1")) ) { out.println("SELECTED"); } %>>H1 
          產品資訊 </option>
          <option value="J1" <% if (model!=null && (model=="J1" || model.equals("J1")) ) { out.println("SELECTED"); } %>>J1 
          業務員管理 </option>
          <option value="K1" <% if (model!=null && (model=="K1" || model.equals("K1")) ) { out.println("SELECTED"); } %>>K1 
          RD倉管理 </option>
        </select>
        <br>
        程式名稱: 
        <%
		      Statement statement=con.createStatement();
	          ResultSet rs=statement.executeQuery("select Unique PROGRAMMERNAME as x , PROGRAMMERNAME from wsprogrammer where ROLENAME='admin' and model='"+model+"'");
		  out.println("<select NAME='PROGRAMMERNAME' onChange='setSubmit("+'"'+"../jsp/RpprogrammerInputPage.jsp"+'"'+")'>");
          out.println("<OPTION>--");     
          while (rs.next())
          {            
            s1=(String)rs.getString(1); 
            s2=(String)rs.getString(2); 
			//s4=(String)rs.getString(4);
			//s5=(String)rs.getString(5);
            if (s1.equals(programmername)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            } else {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
            } 	    
           } //end of while            
		   out.println("</select>"); 
		   //out.println(programmername); 
		  if (programmername!=null && !programmername.equals("--"))
		  {
		   rs=statement.executeQuery("SELECT address FROM wsprogrammer where PROGRAMMERNAME='"+programmername+"'");
		   if (rs.next()) 
		   {address=rs.getString("address");		    
		   }
		  }
		   rs.close();    
		  statement.close();  
	          %>
        <BR>
        網址: <%=address%> </td>
    </tr>
    <tr> 
      <td height="26" bgcolor="#DEF5FE" > 
        <!--  <input name="button3" type=button onClick="buttonContent()" value="角色:">-->
        角色名稱: <%
		      Statement statement3=con.createStatement();
	          ResultSet rs3=statement3.executeQuery("select ROLENAME,ROLENAME from wsROLE where rolename!='admin'");
			  comboBoxBean.setRs(rs3);
			  comboBoxBean.setSelection(rolename);
	          comboBoxBean.setFieldName("ROLENAME");
              out.println(comboBoxBean.getRsString());
			  statement3.close();
			  rs3.close();
	          %> <font color="#FF0000">&nbsp; </font></td>
    </tr>
    <tr>
      <td height="26" > 
        <% 
      int div1=0,div2=0;      //¢FX¢Gg?¢FX1Boa|@|3|h?O-OrowcMcolumn?e?JAa|iaoAU?A
	  try
      {	//out.println("Step6");
	    String a[][]=arrayCheckBoxBean.getArray2DContent();//!Lu!Oo¢FDO?e¢FX}|C?oRe 
        	    		                       		    		  	   
         if (a!=null) 
		 {//out.println("Step7");
		        div1=a.length;
				div2=a[0].length;
	        	//arrayCheckBoxBean.setFieldName("ADDITEMS");			
                //out.println("Step8");   			 	   			 
                out.println(arrayCheckBoxBean.getArray2DString());
                //out.println("Step9");        		   	 				
		 }	//enf of a!=null if           
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>
        <p> 
          <input type="hidden" name="address" value="<%= address %>" >        
          <input type="hidden" name="programmername" value="<%= programmername %>" >
          <INPUT TYPE="submit" name="save" value='存檔' >
        </p>

</td>
    </tr>
  </table>   
    
  <p>&nbsp;</p>

</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

