<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,java.lang.Math.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="java.io.*,com.jspsmart.upload.*,CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>UploadFile Check</title>
<script language="JavaScript" type="text/JavaScript">
function submitCheck(URL)
{ 

  if (document.MYFORM.ACTIONID.value=="--" || document.MYFORM.ACTIONID.value==null)
  { 
   alert("請先選擇您欲執行之動作後再存檔!!");   
   return(false);
  }  

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<%@ page import="com.jspsmart.upload.*,ArrayCheckBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<!--<FORM NAME="MYFORM" ACTION="../jsp/INVBatchIssInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data" >-->
<FORM NAME="MYFORM" ACTION="../jsp/INVBatchIssInsert.jsp" METHOD="post">
<A HREF="/wins/WinsMainMenu.jsp">HOME</A><BR>  
<strong><font color="#0080FF" size="5">批次領料單新增</font></strong>
<table width="96%" border="1">
  <tr>
  	<td colspan="1">申請料件:  <br>
		<%
   		    arrayCheckBoxBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			
			String sQuantity=mySmartUpload.getRequest().getParameter("QUANTITY");
			
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
			String uploadFile_name=upload_file.getFileName();
			String uploadFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName();
			
			   int iQty=0;//BOM表單位數量
			   int iQuantity=0;//套數
			   int iNew=0;//發料數量
			String sNew="";	 //發料數量
			 
			String project=mySmartUpload.getRequest().getParameter("PROJECT");
			String remark=mySmartUpload.getRequest().getParameter("REMARK");
			
			String formID=mySmartUpload.getRequest().getParameter("FORMID");
			String fromStatusID=mySmartUpload.getRequest().getParameter("FROMSTATUSID");		
			String actionID=mySmartUpload.getRequest().getParameter("ACTIONID");		

			  int j=0;
		   Statement statement1=con.createStatement();
		   out.println("<table width='100%' border='0' cellspacing='1' cellpadding='1'>");
		   out.println("<tr bgcolor='#000099'>");
		   out.println("<td><font size='2' color='#FFFFFF'>項次</font></td>");
		   out.println("<td><font size='2' color='#FFFFFF'>料號</font></td>");
		   out.println("<td><font size='2' color='#FFFFFF'>料號說明</font></td>");
		   out.println("<td><font size='2' color='#FFFFFF'>需求數量</font></td>");
		   out.println("<td><font size='2' color='#FFFFFF'>CE Qty</font></td>");
		   out.println("<td><font size='2' color='#FFFFFF'>BPCS(01)Qty</font></td>");
		   out.println("<td><font size='2' color='#FFFFFF'>BPCS(P1)Qty</font></td>");		   
		   out.println("</tr>"); 		
		   	
		   try
		   {       
			  //////寫入INV_M_IDTL
			  if  (!upload_file.isMissing())
			  {       
				// 取得上傳Excel報表		
				InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
				jxl.Workbook wb = Workbook.getWorkbook(is);     
				jxl.Sheet sht = wb.getSheet(0);        
			
				int rowCount = sht.getRows();  // 取此次筆數 
				//out.println("總共成功上載="+rowCount+"筆資料<BR>"); 
				
				int i = 4;
				String t[][]=new String[rowCount-4][2];
				while (i<rowCount)  
				{         
				  jxl.Cell wcITEM = sht.getCell(1, i);    //ws.getWritableCell(int column, int row);  // 讀料號                                
				  String item = wcITEM.getContents();  
				  item = item.trim();
				  	
				  jxl.Cell wcQTY = sht.getCell(4, i);    //ws.getWritableCell(int column, int row);  // 讀數量                                
				  String sQty = wcQTY.getContents();  
			
				  i++;                                        
			
				  if (item !=null && !item.equals(""))
				  {					 
					iQuantity = Integer.parseInt(sQuantity);
					iQty = Integer.parseInt(sQty);
					iNew = iQty * iQuantity;			
					sNew = String.valueOf(iNew); 
					  
					String itemDesc = "";  
					Statement stateID=con.createStatement();
					ResultSet rsID=stateID.executeQuery("select ITEMDESC from INV_ITEM where trim(ITEMNO)='"+item+"' ");	 
					if (rsID.next()) { itemDesc = rsID.getString("ITEMDESC");  }  
					rsID.close();     
					stateID.close(); 			

					//取得CE倉庫存
					String sQty3 = "";  
					Statement stateCE=con.createStatement();
					ResultSet rsCE=stateCE.executeQuery("select sum(remqty) qty from inv_m_rem where remitemno='"+item+"' ");	 
					if (rsCE.next()) { sQty3 = rsCE.getString("qty"); if (sQty3==null) { sQty3="0";}}  
					else { sQty3 = "0"; }
					rsCE.close();     
					stateCE.close(); 

					//取得01、P1倉庫存					
					String sQty1 = "";
					String sQty2 = "";
					Statement stateBPCS=bpcscon.createStatement();
					
					ResultSet rs01=stateBPCS.executeQuery("SELECT ROUND(SUM(LOPB+LRCT+LADJU-LISSU),0) AS QTY FROM ILI WHERE LWHS ='01' AND LPROD='"+item+"'");
					if (rs01.next()) { sQty1= rs01.getString("QTY"); if (sQty1==null) { sQty1="0";} }
					else { sQty1 = "0"; }
					rs01.close();
					
					ResultSet rsP1=stateBPCS.executeQuery("SELECT ROUND(SUM(LOPB+LRCT+LADJU-LISSU),0) AS QTY FROM ILI WHERE LWHS ='P1' AND LPROD='"+item+"'");
					if (rsP1.next()) { sQty2= rsP1.getString("QTY"); if (sQty2==null) { sQty2="0";} }
					else { sQty2 = "0"; }
					rsP1.close();
					
					stateBPCS.close();
		
					out.print("<tr bgcolor='#FFFFCC'>");
					out.print("<td><font size='2'>"); out.println(j+1); out.println("</font></td>");
					out.print("<td><font size='2'>"+item+"</font></td>");
					out.print("<td><font size='2'>"+itemDesc+"</font></td>");  
					out.print("<td><font size='2'>"+iNew+"</font></td>");		
					out.print("<td><font size='2'>"+sQty3+"</font></td>");
					out.print("<td><font size='2'>"+sQty1+"</font></td>");  
					out.print("<td><font size='2'>"+sQty2+"</font></td>");						
				
					//將上傳的item及需求數量存到array
					t[j][0]=item;
			      	t[j][1]=sNew;

					j++;						
				  } 
				} //end of while	
				arrayCheckBoxBean.setArray2DString(t);		
			  }//end of if				  
		   } //end of try
		   catch (Exception e)
		   {
			out.println("Exception:"+e.getMessage());
		   }
		%>
    </td>		
  </tr>	
</table>
<p>
    <strong><font color="#FF0000">可執行動作-&gt;</font></strong> 
    <%
	  try
      {      	   
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select distinct x1.ACTIONID,x2.ACTIONNAME from WSWORKFLOW x1,WSWFACTION x2 WHERE FORMID='RD'AND TYPENO='001' AND FROMSTATUSID='010' AND x1.ACTIONID=x2.ACTIONID");
       comboBoxBean.setRs(rs);
	   comboBoxBean.setFieldName("ACTIONID");	   
       out.println(comboBoxBean.getRsString());
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
     %>
<p>
    <input name="button2" type="button" onClick='submitCheck("../jsp/INVBatchIssInsert.jsp")' value="執行">
    <input name="FORMID" type="HIDDEN" value="RD">	
    <input name="FROMSTATUSID" type="HIDDEN" value="010">
	<input name="PROJECT" type="hidden" value="<%=project%>">
	<input name="REMARK" type="hidden" value="<%=remark%>">  
</FORM>	
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
