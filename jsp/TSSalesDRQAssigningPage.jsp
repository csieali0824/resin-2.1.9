<%@ page language="java" import="java.sql.*"%>
<html>
<head>
<title>Sales Delivery Request Data Edit Page for Assign</title>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,bean.ComboBoxBean,bean.Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<jsp:useBean id="array2DAssignFactoryBean" scope="session" class="bean.Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function submitCheck(ms1,ms2,ms3,ms4,ms5,pgRow)
{     

  if (document.DISPLAYREPAIR.ACTIONID.value=="004")  //��ܬ�CANCE�ʧ@
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  }      
  
  //  
 if (document.DISPLAYREPAIR.ACTIONID.value=="--" || document.DISPLAYREPAIR.ACTIONID.value==null)
  { 
   alert(ms2);   
   return(false);
  }  else if (document.DISPLAYREPAIR.ACTIONID.value!="003")  //��ܰʧ@�M�椣��ASSIGN,�i��O�ۦ��JLINE_ID,�]���ݥd������ʧ@
          { 
            alert("                    Error Action Process!!!\n Don't try key-in invalid line No in this page...");   
            return(false);
          }   
		  
   // �Y����ܥ��@Line �@�ʧ@,�hĵ�i
   var chkFlag="FALSE";
   for (i=0;i<document.DISPLAYREPAIR.CHKFLAG.length;i++)
   {
     if (document.DISPLAYREPAIR.CHKFLAG[i].checked==true)
	 {
	   chkFlag="TURE";
	 } 
	 //alert("TTT");
   }  
   if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
   {
    alert(ms4);   
    return(false);
   }
  // 
  //alert(pgRow);		
  var setFlag="FALSE";
  for (j=0;j<pgRow;j++)
  {  
     if (document.DISPLAYREPAIR.elements["ASSIGN_FACT"+j].value !=null && document.DISPLAYREPAIR.elements["ASSIGN_FACT"+j].value != "N/A")
	 {//alert(document.DISPLAYREPAIR.elements["ASSIGN_FACT"+j].value);
	   setFlag="TRUE";
	 }
  }  
  if (setFlag=="FALSE")
  {
    alert(ms5);   
    return(false);
  }
       
  return(true);  
}
function setSubmit1(URL)
{ //alert(); 
  //alert(document.DISPLAYREPAIR.CHKFLAG.length);  
 
  var linkURL = "#ACTION";
  document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.submit();    
}
function setSubmit3(URL,LINKREF)
{ //alert(); 

      
   if(document.DISPLAYREPAIR.PRODMANUFACTORY.value=="--") // �Y�O����ܲ��a,�礣���\�]�w
   {	
     alert("Please choose Assign factory before you Set this item..."); 
	 document.DISPLAYREPAIR.PRODMANUFACTORY.focus();
	 return (false);
   }
  document.DISPLAYREPAIR.ACTIONID.value="--"; // �קK�ϥΪ̥���ʧ@�A�]�w�U����
  
  var prodSelect="&PRODMANUFACTORY="+document.DISPLAYREPAIR.PRODMANUFACTORY.options[document.DISPLAYREPAIR.PRODMANUFACTORY.selectedIndex].value;
  var linkURL = "#"+LINKREF;
  document.DISPLAYREPAIR.action=URL+prodSelect+linkURL;
  document.DISPLAYREPAIR.submit();    
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="bean.ComboBoxBean"/>
</head>
<%
   String dnDocNo=request.getParameter("DNDOCNO");
   String prodManufactory=request.getParameter("PRODMANUFACTORY");   
   String lineNo=request.getParameter("LINENO");
   
   String actionID = request.getParameter("ACTIONID");  
   String remark = request.getParameter("REMARK");    
   //response.sendRedirect("../jsp/TSSalesDRQAssigningPage.jsp?DNDOCNO="+dnDocNo); 
   String line_No=request.getParameter("LINE_NO");
   
   String [] check=request.getParameterValues("CHKFLAG");
   
   int pageResultRow = 0;
   
   if (lineNo==null) { lineNo="";}
   if (prodManufactory==null) { prodManufactory="";}
   if (remark==null) { remark=""; }
   
   //out.println(check.length);
         int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '002' ");	// ASSIGNING ���A
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
		 
		 pageResultRow = rowLength; //������������,�Ω�P�_�O�_����������j��
   
%>
<body>
<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>","<jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>","<%=pageResultRow%>")' ACTION="../jsp/TSSalesDRQMProcess.jsp?DNDOCNO=<%=dnDocNo%>" METHOD="post">
  <!--=============�H�U�Ϭq�����o���װ򥻸��==========-->
<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
<!--=================================-->
<hr>
<table border="1" cellpadding="0" cellspacing="0" align="center" width="97%" bordercolor="#996633"  bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
    <tr bgcolor='#D5D8A7'> 
    <td colspan="3"><font color="#000066">
      <jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/></font>
      :&nbsp;&nbsp;&nbsp;<img src="../image/point.gif"><font color="#FF6600"><jsp:getProperty name="rPH" property="pgNoBlankMsg"/><BR>
      <%
	  try
      {   
	    String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};  // ���N���e���Ӫ����Y,���@���}�C		 	     			  
    	array2DAssignFactoryBean.setArrayString(oneDArray);
		// ���� �Ӹ߰ݳ浧��
	/*	
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' ");	
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
	*/ 
		 
	  
	   //choice = new String[rowLength+1][2];  // ���w�Ȧs�G���}�C���C��
	   String b[][]=new String[rowLength+1][7]; // �ŧi�@�G���}�C,���O�O(�����t���a=�C)X(������+1= ��)
	  
	   //array2DAssignFactoryBean.setArray2DString(oneDArray); // ������Y�m�J�G���Ĥ@�C
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE border='1' cellpadding='0' cellspacing='0' align='center' width='100%'  bordercolor='#999966' bordercolorlight='#999999' bordercolordark='#CCCC99' bgcolor='#CCCC99'>");
	   out.println("<tr bgcolor='#D5D8A7'>");	   
	   out.println("<td nowrap>");
	   %>
	   <input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
	   <%
	   out.println("</td>");
	   out.println("<td width='1%'><font color='#FFFFFF'>&nbsp;</font></td>");
	   out.println("<td><font color='#000000'><div align='center'><img src='../image/point.gif'>Assign Factory</div>");
	   try
        { // �ʺA�h���Ͳ��a��T 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select MANUFACTORY_NO, MANUFACTORY_NAME as PRODMANUFACTORY "+
			                        "from ORADDMAN.TSPROD_MANUFACTORY "+
			                        "where MANUFACTORY_NO > 0 "+																  
								     "order by MANUFACTORY_NO "; 		  
                   rsGetP=stateGetP.executeQuery(sqlGetP);
				   comboBoxBean.setRs(rsGetP);
		           comboBoxBean.setSelection(prodManufactory);
	               comboBoxBean.setFieldName("PRODMANUFACTORY");					     
                   out.println(comboBoxBean.getRsString());				
					           
				    stateGetP.close();		  		  
		            rsGetP.close();
	   } //end of try		 
       catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	   out.println("</font></td>");
	   out.println("<td width='1%' nowrap><font color='#000000'>");
	   %><jsp:getProperty name="rPH" property="pgAnItem"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %>
	   <jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %><jsp:getProperty name="rPH" property="pgQty"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %>
	   <jsp:getProperty name="rPH" property="pgUOM"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %><jsp:getProperty name="rPH" property="pgRequestDate"/>
	   <%
	   out.println("</font></td><td><font color='#000000'>");
	   %><jsp:getProperty name="rPH" property="pgRemark"/>
	   <%
	   out.println("</font></td>"); 
	   //out.println("<td width='2%'><font size='2'>Line No</font></td><td><font size='2'>Item Description</font></td><td><font size='2'>Qty.</font></td><td><font size='2'>UOM</font></td><td><font size='2'>Request Date</font></td><td><font size='2'>Remark</font></td>");    
	   int k=0;
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO");	   
	   while (rs.next())
	   {
	    out.print("<TR bgcolor='#D5D8A7'>");		
		                      								  
	    out.println("<TD width='1%'><div align='center'>");
		out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
		if (check !=null) // �Y���e�H�]�w�����,�hCheck Box ��� checked
		{
		  for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  }
		  if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // ���w�t�O�Y�]�w������
		  
		} else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //�Ĥ@�����t�O�Y�]�w������  
		if (rowLength==1) out.println("checked >"); else out.println(" >");
		out.println("</div></TD>");
					
		out.println("<TD width='1%'><font color='#000000'>");
		out.println("<INPUT TYPE='button' value='Set' onClick='setSubmit3("+'"'+"../jsp/TSSalesDRQAssigningPage.jsp?LINENO="+rs.getString("LINE_NO")+"&DNDOCNO="+dnDocNo+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+")'>");	
		out.println("</div></TD>");
		
		out.println("<TD width='5%' nowrap><font color='#000000'>");      
		if (rs.getString("ASSIGN_MANUFACT")=="N/A" || rs.getString("ASSIGN_MANUFACT").equals("N/A"))
		{  out.println("<font color='#000000'>&nbsp;");
		  // out.println("<font size='2'>"); 
		  if (lineNo==null)
		  { out.println("</font>"); }
		  else if (lineNo.equals(rs.getString("LINE_NO")) || lineNo==rs.getString("LINE_NO"))
		  {  out.println(prodManufactory+"</font>"); }
		
		 }
		else  {
		        out.println("<font color='#FF0000'>");
				//out.println(rs.getString("ASSIGN_MANUFACT")+"</font></TD>");	
				if (lineNo!=rs.getString("LINE_NO") && !lineNo.equals(rs.getString("LINE_NO")))
				{ out.println(rs.getString("ASSIGN_MANUFACT")+"</font>");	}
				else {out.println(prodManufactory+"</font>"); }				 
		      }		 
		out.println("<INPUT TYPE='hidden' NAME='ASSIGN_FACT"+k+"' value='"+rs.getString("ASSIGN_MANUFACT")+"'>"); // ���óQ�����u�t����,�H�K�� java _script�P�_�O�_�ϥΪ̥������Y�e�X����   			 
		out.println("</TD>");
		out.println("<TD><font color='#000000'><a name="+rs.getString("LINE_NO")+">");
		out.println(rs.getString("LINE_NO")+"</a></font></TD><TD><font color='#000000'>"+rs.getString("ITEM_DESCRIPTION")+"</font></TD><TD><font color='#000000'>"+rs.getString("QUANTITY")+"</font></TD><TD><font color='#000000'>"+rs.getString("UOM")+"</font></TD><TD><font color='#000000'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font></TD><TD><font color='#000000'>"+rs.getString("REMARK")+"</font></TD></TR>");
		 
		 b[k][0]=rs.getString("LINE_NO");b[k][1]=rs.getString("ITEM_SEGMENT1");b[k][2]=rs.getString("QUANTITY");b[k][3]=rs.getString("UOM");b[k][4]=rs.getString("REQUEST_DATE");b[k][5]=rs.getString("REMARK");b[k][6]=rs.getString("ASSIGN_MANUFACT");		 
		 array2DAssignFactoryBean.setArray2DString(b);
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DAssignFactoryBean.getArray2DString()); // �⤺�e�L�X��
	    if (lineNo !=null && prodManufactory!=null)
	    {
	      String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set ASSIGN_MANUFACT=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
	      PreparedStatement pstmt=con.prepareStatement(sql);  
          pstmt.setString(1,prodManufactory);  // �߰ݳ渹
		  pstmt.executeUpdate(); 
          pstmt.close();
        }  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	     String a[][]=array2DAssignFactoryBean.getArray2DContent();//���o�ثe�}�C���e 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		        //out.println("ROW="+a.length+" ");
				//out.println("COLUMN="+a[0].length+"<BR>");
						
				//out.println(a[0][0]+ " " +a[0][1]+" " +a[0][2]+" " +a[0][3]+" " +a[0][4]+" " +a[0][5]+" " +a[0][6]+"<BR>");	
				//out.println(a[1][0]+ " " +a[1][1]+" " +a[1][2]+" " +a[1][3]+" " +a[1][4]+" " +a[1][5]+" " +a[1][6]+"<BR>");
				//out.println(a[2][0]+ " " +a[2][1]+" " +a[2][2]+" " +a[2][3]+" " +a[2][4]+" " +a[2][5]+" " +a[2][6]+"<BR>");
				//out.println(a[3][0]+ " " +a[3][1]+" " +a[3][2]+" " +a[3][3]+" " +a[3][4]+" " +a[3][5]+" " +a[3][6]+"<BR>");
				//out.println(a[4][0]+ " " +a[4][1]+" " +a[4][2]+" " +a[4][3]+" " +a[4][4]+" " +a[4][5]+" " +a[4][6]+"<BR>");
				//out.println(a[5][0]+ " " +a[5][1]+" " +a[5][2]+" " +a[5][3]+" " +a[5][4]+" " +a[5][5]+" " +a[5][6]+"<BR>");
				
	        	//array2DAssignFactoryBean.setFieldName("ADDITEMS");			
				//out.println(array2DAssignFactoryBean.getArray2DString()); // �⤺�e�L�X��  		
				//out.println(array2DAssignFactoryBean.getCheckContent()); 				
		 }	//enf of a!=null if		
		/* 
	  int div1=0,div2=0;      //�����B��@���h�֭�row�Mcolumn��J��쪺�ܼ�
	  try
      {	
	    String d[][]=array2DAssignFactoryBean.getArray2DContent();//���o�ثe�}�C���e 		    		                       		    		  	   
         if (d!=null) 
		 {		  
		        div1=d.length;
				div2=d[0].length;				
	        	//array2DAssignFactoryBean.setFieldName("ADDITEMS");			
				out.println(array2DAssignFactoryBean.getArray2DString()); 				
				//isModelSelected = "Y";	// �YModel ���Ӥ������@�����,�h�� "Y"  	
		  		 				
		 }	//enf of a!=null if		
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }*/
    %> </font>      
  </tr>    
  <tr bgcolor='#D5D8A7'> 
      <td colspan="3"><font color='#FF0000'><jsp:getProperty name="rPH" property="pgProcessMark"/>: 
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
		<INPUT type="hidden" name="WORKTIME" value="0">
        <INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 ></font>           
     </td>
    </tr>
  <tr bgcolor='#D5D8A7'>
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessUser"/>:</font><font color="#0080C0"><%=userID+"("+UserName+")"%></font></td>
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessDate"/>:<%=dateBean.getYearMonthDay()%>
    </font></td>
      <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessTime"/>: 
	   <%=dateBean.getHourMinuteSecond()%></font>
      </td>
    </tr>       
</table>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</font></strong> 
   <a name='#ACTION'>
    <%
	  try
      {  
	        
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQAssigningPage.jsp?DNDOCNO="+dnDocNo+'"'+")'>");				  				  
	   out.println("<OPTION VALUE=-->--");     
	   while (rs.next())
	   {            
		String s1=(String)rs.getString(1); 
		String s2=(String)rs.getString(2); 
        if (s1.equals(actionID)) 
  		{
          out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        } else {
                  out.println("<OPTION VALUE='"+s1+"'>"+s2);
               }        
	   } //end of while
	   out.println("</select>"); 	   
	   
	   rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   rs.next();
	   if (rs.getInt(1)>0) //�P�_�Y�S���ʧ@�i��ܴN���X�{submit���s
	   {
         out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
		 out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
	   } 
       rs.close();       
	   statement.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></a></td></tr></table>
<!-- ���Ѽ� --> 
<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >
</FORM>
 <!--=============�H�U�Ϭq������s����==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
