<%@ page language="java" import="java.sql.*"%>
<html>
<head>
<title>IQC Inspection Lot Process Page</title>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,bean.ComboBoxBean,bean.Array2DimensionInputBean"%>
</head>
<jsp:useBean id="array2DimQCProcessBean" scope="session" class="bean.Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
function check(field) 
{
	if (checkflag == "false") 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = true;
		}
 		checkflag = "true";
 		return "�������"; 
	}
 	else 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = false; 
		}
 		checkflag = "false";
 		return "�������"; 
	}
}
function submitCheck(ms1,ms2,ms3)
{  
	return(true);  
}
function setSubmit1(URL)
{ //alert(); 
	document.DISPLAYREPAIR.action=URL;
  	document.DISPLAYREPAIR.submit();    
}
function setSubmit2(URL)
{ 
  	var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  	document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  	document.DISPLAYREPAIR.submit();    
}
function setUpdate(inspectno,lineno,column)
{
	document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open("../jsp/TSIQCInspectLotUpdatePage.jsp?NO="+inspectno+"&LINE="+lineno+"&CLN="+column,"subwin","left=500,width=500,height=300,scrollbars=yes,menubar=no");  
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="bean.ComboBoxBean"/>

<%
String inspLotNo=request.getParameter("INSPLOTNO");
//String prodManufactory=request.getParameter("PRODMANUFACTORY");   
String lineNo=request.getParameter("LINENO");
//String pcAcceptDate=request.getParameter("PCACPDATE"); 
String actionID = request.getParameter("ACTIONID");   
String remark = request.getParameter("REMARK");   
String line_No=request.getParameter("LINE_NO");
String recUserID=request.getParameter("RECUSERID");
String statusID=request.getParameter("STATUSID");   

String [] check=request.getParameterValues("CHKFLAG");

if (lineNo==null) { lineNo="";}
//if (pcAcceptDate==null) { pcAcceptDate="";}
if (remark==null) { remark=""; }
%>
<body>
<%@ include file="/jsp/include/TSIQCDocHyperLinkPage.jsp"%>
<BR>
<!--=============�H�U�Ϭq�����oIQC�����򥻸��==========-->
<%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%>
<!--=================================-->
<HR>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("�����T�{","�O�_�e�X","�п�ܰ���ʧ@")' ACTION="../jsp/TSIQCInspectLotMProcess.jsp?INSPLOT_NO=<%=inspLotNo%>" METHOD="post">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="�з���" size="+2">��Ʋ��ʤ�,�еy��.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
	<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    	<tr bgcolor="#CCCC99"> 
    		<td colspan="3"><font color="#000066">
      		���e����
      		: <BR>
    		<%
	  		try
      		{   
	    		String oneDArray[]= {"����","����","�x�b�Ƹ�","���Ƽƶq","���","���Ƥ��","�����Ӷi�Ƨ帹","�Ƶ�"};  // ���N���e���Ӫ����Y,���@���}�C		 	     			  
				// ���� �Ӹ߰ݳ浧��
	     		int rowLength = 0;
	     		Statement stateCNT=con.createStatement();
         		ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' ");	
	     		if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     		rsCNT.close();
	     		stateCNT.close();
	  
	   			String b[][]=new String[rowLength+1][8]; // �ŧi�@�G���}�C,���O�O(�����t���a=�C)X(������+1= ��)
	  
	   			out.println("<TABLE cellSpacing='0' bordercolordark='#B5B89A' cellPadding='0' width='100%' align='center' bordercolorlight='#FFFFFF'  border='1'>");
	   			out.println("<tr bgcolor='#CCCC99'>");
	   			out.println("<td nowrap><font color='#FFFFFF'>&nbsp;</font>");
	   		%>
	   			<input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='��ܥ���'>
	   		<%
	   			out.println("</td>");
	   			out.println("<td>����</td>");
	   			out.println("<td>���絲�G����(Comment)</td>");	  
	   			out.println("<td>���Ƴ�(���ʩ���)</td>");
				out.println("<td nowrap>�����Ӷi�Ƨ帹</td>");
				out.println("<td>�x�b�Ƹ�</td>");
				out.println("<td>���Ƽƶq</td>");
				out.println("<td>���</td>");
				out.println("<td>���Ƥ��</td>");
				out.println("<td>�Ƶ�</td>");    
	   			int k=0;
	   
	   			String sqlEst = "";
				if (UserRoles.indexOf("admin")>=0) // �Y�O�޲z��,�i�]�w���@���ج��S��
	   			{ 
	     			sqlEst = "select decode(RESULT,'01','ACCEPT','02','REJECT','03','WAIVE',RESULT) as RESULT, LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, SHIPMENT_LINE_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO";
	   			}
	   			else 
				{   
	          		sqlEst = "select decode(RESULT,'01','ACCEPT','02','REJECT','03','WAIVE',RESULT) as RESULT, LINE_NO, SUPPLIER_LOT_NO, RECEIPT_NO, INV_ITEM, INV_ITEM_DESC, RECEIPT_QTY, UOM, RECEIPT_DATE, INSPECT_REMARK, SAMPLE_QTY, INSPECT_QTY, INSPECT_DATE, COMMENTS, SHIPMENT_LINE_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; 
				}
	   
       			Statement statement=con.createStatement();
       			ResultSet rs=statement.executeQuery(sqlEst);	   
	   			while (rs.next())
	   			{
		      		String recList = "";
			  		int listCNT = 1;
		      		Statement stateDlvr=con.createStatement();
              		ResultSet rsDlvr=stateDlvr.executeQuery("select TRANSACTION_TYPE, TRANSACTION_DATE from RCV_TRANSACTIONS where VENDOR_LOT_NUM = '"+rs.getString("SUPPLIER_LOT_NO")+"' and SHIPMENT_LINE_ID = '"+rs.getString("SHIPMENT_LINE_ID")+"' order by TRANSACTION_DATE ");	
		      		while (rsDlvr.next())
			  		{
			    		listCNT++;
						if (listCNT==1)
						{
			      			recList = recList+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
						} 
						else if (listCNT==2)
				       	{
					    	recList = recList+"&nbsp;&nbsp;"+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
					   	}
						else 
						{
					    	recList = recList+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+rsDlvr.getString("TRANSACTION_TYPE")+"<BR>";
					    }
			  		}
			  		rsDlvr.close();
			  		stateDlvr.close();
	   
					out.println("<TR bgcolor='#CCCC99'>");		
					out.println("<TD width='1%'><div align='center'>");
					out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' ");
					if (check !=null) // �Y���e�H�]�w�����,�hCheck Box ��� checked
					{ 
		  				for (int j=0;j<check.length;j++) 
						{ 
							if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");  
						}
		  				if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // ���w�Ͳ�����Y�]�w������
					} 
					else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //�Ĥ@�����w�Ͳ�����Y�]�w������  
					if (rowLength==1) out.println(" checked >"); 	else out.println(" >");		
					out.println("</div></TD>");
					out.println("<TD nowrap>"+rs.getString("LINE_NO")+"</TD>");
					out.println("<TD nowrap>"+rs.getString("RESULT")+"</TD>");		
					out.println("<TD nowrap>");
					%><a onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=recList%>")'>
					<% 
					out.println(rs.getString("RECEIPT_NO")+"</a></TD>");
					out.println("<TD nowrap>"+rs.getString("SUPPLIER_LOT_NO")+"</TD>");
					out.println("<TD nowrap>"+rs.getString("INV_ITEM_DESC")+"</TD>");
					out.println("<TD nowrap>"+rs.getString("RECEIPT_QTY")+"</TD>");
					out.println("<TD nowrap>"+rs.getString("UOM")+"</TD>");
					out.println("<TD nowrap>"+rs.getString("RECEIPT_DATE")+"</TD>");
					out.println("<TD nowrap><div>"+(UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0||UserName.toUpperCase().equals("PEGGY_CHEN")?"<img border='0' src='images/updateicon_enabled.gif' onClick='setUpdate("+'"'+inspLotNo+'"'+","+'"'+rs.getString("LINE_NO")+'"'+","+'"'+"INSPECT_REMARK"+'"'+")'>":"")+"<span id='rmk"+rs.getString("LINE_NO")+"' style='vertical-align:top'>"+(rs.getString("INSPECT_REMARK")==null?"":rs.getString("INSPECT_REMARK"))+"</span></div></TD>");
					out.println("</TR>");
		 			k++;
	   			}    	   	   	 
	   			out.println("</TABLE>");
	   			statement.close();
       			rs.close();  	         
      		} //end of try
       		catch (Exception e)
       		{
        		out.println("Exception:"+e.getMessage());
       		}
    		%>      
  		</tr>       
	</table>
	<table cellSpacing="1" bordercolordark="#D0C8C1" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="0">  
  		<tr bgcolor="#DDDBAA"> 
    		<td width="12%" colspan="1" valign="top"><div align="center">�̫�P�w(Results):<BR></div></td>
	  		<td width="88%" colspan="4"><%=resultName%></td>
  		</tr> 
	</table> 
	<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">             
  		<tr bgcolor="#CCCC99"> 
      		<td colspan="5">���}��]����: 
        	<INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
			<INPUT type="hidden" name="WORKTIME" value="0">
        	<INPUT TYPE="hidden" NAME="LINE_NO" SIZE=60 value="<%=line_No%>" >           
     	</td>
    	</tr>          
	</table>
	<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">       
  		<tr bgcolor="#CCCC99"> 
      		<td colspan="3">�B�z�Ƶ�: 
        	<INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
			<INPUT type="hidden" name="WORKTIME" value="0">
        	<INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 >           
     	</td>
    	</tr>          
	</table>
<BR>
<%
if (UserRoles.indexOf("admin")>=0 )
{ // �޲z���~�ݪ���B�z���s
%>
	<table align="left"><tr><td colspan="3">
   		<strong><font color="#FF0000">����ʧ@-&gt;</font></strong> 
   		<a name='#ACTION'>
    	<%
	  	try
      	{  
       		Statement statement=con.createStatement();
       		ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   		out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSIQCInspectLotInspectingPage.jsp?INSPLOTNO="+inspLotNo+'"'+")'>");				  				  
	   		out.println("<OPTION VALUE=-->--");     
	   		while (rs.next())
	   		{            
				String s1=(String)rs.getString(1); 
				String s2=(String)rs.getString(2); 
        		if (s1.equals(actionID)) 
  				{
          			out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        		} 
				else 
				{
                	out.println("<OPTION VALUE='"+s1+"'>"+s2);
               	}        
	   		}
	   		out.println("</select>"); 
	   
	   		rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   		rs.next();
	   		if (rs.getInt(1)>0) //�P�_�Y�S���ʧ@�i��ܴN���X�{submit���s
	   		{
         		out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
		 		out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>�l��q��<%
	   		} 
       		rs.close();       
	   		statement.close();
       	}
       	catch (Exception e)
       	{
        	out.println("Exception:"+e.getMessage());
       	}
       	%>
			</a>
			</td>
		</tr>
	</table>
<%
}
%>
<!-- ���Ѽ� --> 
<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
 <!--=============�H�U�Ϭq������s����==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
