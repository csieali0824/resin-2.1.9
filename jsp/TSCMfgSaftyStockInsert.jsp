<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 

<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>

<script language="JavaScript" type="text/JavaScript">
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();
	
}
/*
function updateDB(URL)
{ 
//alert(xUpdateFlag); 

  document.MYFORM.UPDATEFLAG.value="Y";
  alert( document.MYFORM.UPDATEFLAG.value);

  document.MYFORM.action=URL;
  document.MYFORM.submit();
}


function submitCheck(ms1,ms2)
{  
  if (document.MYFORM.UPDATEFLAG.value=="N")  //GENERTED表示為確認工令生成並展開流程卡動作
  {
      return(false);
			  else {
						return(true);
			       }
  }  
*/
</script>
<body>
<A HREF="../jsp/TSCMfgSaftyStockUpload.jsp">上一頁</A>
<FORM NAME="MYFORM" onsubmit='return submitCheck("是","否")' ACTION="../jsp/TSCMfgSaftyStockInsert.jsp" METHOD="post">
<%
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
//out.println("Step1");
com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
upload_file.saveAs("d:/resin-2.1.9/webapps/oradds/report/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
String uploadFile_name=upload_file.getFileName();
String uploadFilePath="d:/resin-2.1.9/webapps/oradds/report/"+request.getRemoteAddr()+"-"+upload_file.getFileName();

String loginUserId="";
String updateFlag = request.getParameter("UPDATEFLAG");       //判斷是否按了更新資料庫BUTTON

if (updateFlag==null || updateFlag.equals("")) updateFlag="N";
//out.println("updateFlag="+updateFlag);

   /*
            try
	         {  
			    //define connection 
				String url="jdbc:oracle:thin:@10.0.1.7:1522:dev";
			    Connection dmcon=DriverManager.getConnection(url,"oraddman","oraddman");   
				Statement statement=dmcon.createStatement();
				//Statement statement=con.createStatement();
			    String sSql="select FILENAME "+" "+
		                           "from ittest_excel"; 
		        String sWhere="where  FILENAME='"+uploadFile_name+"'"; 
		        
	            sSql=sSql+sWhere; 
	            //out.println(sSql);      					 
	            ResultSet rs=statement.executeQuery(sSql);
		        if(rs.next())
			    {
				String sqld="delete from  ittest_excel where  FILENAME='"+uploadFile_name+"'";   
                PreparedStatement dstmt=dmcon.prepareStatement(sqld);      
                dstmt.executeUpdate();           
                dstmt.close();
				}
				 statement.close();
	             rs.close();
				}//end of try
		       catch (Exception e)
             {
               e.printStackTrace();
               out.println(e.getMessage());
              }//end of catch
*/				

            try
            {

              String sqlid = " select USER_ID from fnd_user  where upper(user_name) = trim(upper('"+UserName+"')) " ;
	          // out.print("sqli="+sqli);
	 	      Statement stateid=con.createStatement();
     	      ResultSet rsid=stateid.executeQuery(sqlid);
	 	      if (rsid.next())
		       { 	
                 loginUserId=rsid.getString("USER_ID");
               }
               //end of while
		       rsid.close();
    	       stateid.close(); 


				String sqlDC =  " delete APPS.YEW_SAFTY_STOCK ";   			            
                 PreparedStatement seqstmt=con.prepareStatement(sqlDC); //out.println("Step1.1.2");  
                 //out.print("<br>資料庫已清空<br>");
                 seqstmt.executeUpdate();
                 seqstmt.close(); 			 
            }
			catch (Exception e)
			{
				 out.println("Exception delete:"+e.getMessage());		  
			} 


             String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
             String strDate = dateBean.getYearMonthDay();   // 取結轉日期時間 //
            /*  For Excel View  */         
            // 取得上傳Excel報表
	        InputStream is = new FileInputStream("d:/resin-2.1.9/webapps/oradds/report/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 			
			
            jxl.Workbook wb = Workbook.getWorkbook(is);                
            //jxl.Sheet sht = wb.getSheet(0);
			
			jxl.Sheet sht = wb.getSheet("Sheet1");      
            int rowCount = sht.getRows();  // 取此次筆數 
            out.println("上傳資料數="+rowCount+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");

			/*
			 jxl.Cell wcTsc_Package = sht.getCell(0, 1);    //ws.getWritableCell(int column, int row);  // 讀Supplier_id                              
             String Tsc_Package = wcTsc_Package.getContents();              
             out.print("<table><tr bgcolor='#FFFFCC'><td><font size='2'>"+Tsc_Package+"</font></td>");
			  jxl.Cell wcTSC_Makebuy = sht.getCell(1, 1);    //ws.getWritableCell(int column, int row);  // 讀Supplier_name                                
             String TSC_Makebuy = wcTSC_Makebuy.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+TSC_Makebuy+"</font></td>");
			  jxl.Cell wcPeriod = sht.getCell(2, 1);    //ws.getWritableCell(int column, int row);  // 讀Created_by                               
             String Period = wcPeriod.getContents(); 
			 out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Period+"</font></td>");
			  jxl.Cell wcDate_Code = sht.getCell(3, 1);    //ws.getWritableCell(int column, int row);  // 讀Supplier_item                            
             String Date_Code = wcDate_Code.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Date_Code+"</font></td></table>");
			 */
			 /*
			  jxl.Cell wcSupplier_item_desc = sht.getCell(4, 5);    //ws.getWritableCell(int column, int row);  // 讀Supplier_item_desc                         
             String Supplier_item_desc = wcSupplier_item_desc.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Supplier_item_desc+"</font></td>");
			  jxl.Cell wcCreation_date = sht.getCell(5, 5);    //ws.getWritableCell(int column, int row);  // 讀Creation_date                               
             String Creation_date = wcCreation_date.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Creation_date+"</font></td>");
			 jxl.Cell wcOrg_id = sht.getCell(6, 5);    //ws.getWritableCell(int column, int row);  // 讀Org_id                               
             String Org_id = wcOrg_id.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Org_id+"</font></td>");
			*/
          //  out.println("<table width='50%' border='0' cellspacing='1' cellpadding='1'><tr bgcolor='#000099'><td><font size='2' face='Arial' color='#FFFFFF'>No.</font>></td><td><font size='2' face='Arial' color='#FFFFFF'>ORG_ID</font></td><td><font size='2' face='Arial' color='#FFFFFF'>ITEM_NO</font></td><td><font size='2' face='Arial' face='Arial' color='#FFFFFF'>ITEM_DESC</font></td>"+
         //                "<td><font size='2' face='Arial' color='#FFFFFF'>UOM</font></td><td><font size='2' face='Arial' color='#FFFFFF'>SAFTY_STOCK</font></td></tr>");    
                        
       


		    int i = 1;			
            
			try {
            while (i<rowCount)  
            {  
			  //out.print("<tr bgcolor='#FFFFCC'><td>"+i+"</td>");       
              jxl.Cell wcDOrg_Id = sht.getCell(0, i);    //ws.getWritableCell(int column, int row);  // 讀org_id                                
              String dOrg_Id = wcDOrg_Id.getContents();           
            // if (dSupplier_id==null || dSupplier_id.equals(""))  dSupplier_id ="N/A";  //如果是空值, 則設定同上一筆
		     //else {PreITEM = dName;}
			// out.print("<td><font size='2' face='Arial'>"+dOrg_Id+"</font></td>");
			 
			  jxl.Cell wcDItem_No = sht.getCell(1, i);    //ws.getWritableCell(int column, int row);  // 讀item no                               
              String dItem_No = wcDItem_No.getContents();              
			 // if (dSupplier_name==null || dSupplier_name.equals("")) {dSupplier_name ="000";}  //如果是空值, 則設定同上一筆		    
			// out.print("<td><font size='2' face='Arial'>"+dItem_No+"</font></td>");
			 
			   jxl.Cell wcDItem_Desc = sht.getCell(2, i);    //ws.getWritableCell(int column, int row);  // 讀item_desc                              
              String dItem_Desc = wcDItem_Desc.getContents();              
            //  out.print("<td><font size='2' face='Arial'>"+dItem_Desc+"</font></td>");
			  
			   jxl.Cell wcDUom = sht.getCell(3, i);    //ws.getWritableCell(int column, int row);  // 讀uom                            
               String dUom = wcDUom.getContents();              
             //  out.print("<td><font size='2' face='Arial'>"+dUom+"</font></td>");
			  //Name1=Name1+"-"+Name2+"-"+Name3; 			
			  
			  jxl.Cell wcDSafty_Stock = sht.getCell(4, i);    //ws.getWritableCell(int column, int row);  // 讀safty stock                             
              String dSafty_Stock = wcDSafty_Stock.getContents();              
           //   out.print("<td><font size='2' face='Arial'>"+dSafty_Stock+"</font></td>");

			/*  
			  jxl.Cell wcDCreation_date = sht.getCell(5, i);    //ws.getWritableCell(int column, int row);  // 讀Creation_date                         
              String dCreation_date = wcDCreation_date.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+dCreation_date+"</font></td>");
             
			  jxl.Cell wcDOrg_id = sht.getCell(6, i);    //ws.getWritableCell(int column, int row);  // 讀Org_id                          
              String dOrg_id = wcDOrg_id.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+dOrg_id+"</font></td>"); 
			 */


				String sqlTC =  "insert into APPS.YEW_SAFTY_STOCK(ORG_ID,ITEM_NO,ITEM_DESC,UOM,SAFTY_STOCK) "+
                                        "values(?,?,?,?,?) ";   
                //out.print("****inserting***");			            
                 PreparedStatement seqstmt=con.prepareStatement(sqlTC); //out.println("Step1.1.2");    				
				 seqstmt.setString(1,dOrg_Id); // out.println("Step1.1");
                 seqstmt.setString(2,dItem_No);// out.println("Step1.2"); 
				 seqstmt.setString(3,dItem_Desc); //out.println("Step1.4");
				 seqstmt.setString(4,dUom); //out.println("Step1.5");
				 seqstmt.setString(5,dSafty_Stock); 
			/*	 seqstmt.setString(6,dCreation_date);
				 seqstmt.setString(7,dOrg_id);		
			*/	
                 seqstmt.executeUpdate();
                 seqstmt.close(); 			 
            i++;  
		  }   // End of While (i<rowCount)
             out.print("<br>*****insert into APPS.YEW_SAFTY_STOCK success!!****<br>");
				String sqlUC =  "update APPS.YEW_SAFTY_STOCK YSS "+
 								"   set YSS.ITEM_ID = (select MSI.INVENTORY_ITEM_ID from MTL_SYSTEM_ITEMS MSI "+
  	 			     			" where trim(YSS.ORG_ID) = MSI.ORGANIZATION_ID and trim(YSS.ITEM_NO) = MSI.SEGMENT1) ";
            //out.print("<br>sqlUC="+sqlUC);   			            
                 PreparedStatement seqstmta=con.prepareStatement(sqlUC); //out.println("Step1.1.2");    				
                 seqstmta.executeUpdate();
                 seqstmta.close(); 	
                 updateFlag="Y";		 
		} // end of try
			catch (Exception e)
			{
				 out.println("Exception insert:"+e.getMessage());		  
			} 
		
        //out.println("</table>"); 
        wb.close(); 

   try
   {
    if (updateFlag=="Y" || updateFlag.equals("Y"))
     {
       String sqlDs =  " delete  mtl_safety_stocks where organization_id in (326,327) ";   			            
       PreparedStatement seqstmt=con.prepareStatement(sqlDs); //out.println("Step1.1.2");  
                 //out.print("<br>資料庫已清空<br>");
       seqstmt.executeUpdate();
       seqstmt.close(); 



       String sqlIC =  " insert into mtl_safety_stocks stk( "+
	        		   "             INVENTORY_ITEM_ID,ORGANIZATION_ID,EFFECTIVITY_DATE,LAST_UPDATE_DATE,LAST_UPDATED_BY, "+
					   "             CREATION_DATE,CREATED_BY,SAFETY_STOCK_CODE,SAFETY_STOCK_QUANTITY) "+
					   "      select to_number(ITEM_ID),to_number(ORG_ID),sysdate,sysdate,"+loginUserId+" ,sysdate,"+loginUserId+" ,1,to_number(SAFTY_STOCK)  "+
					   "        from apps.yew_safty_stock  where item_id is not null ";
          // out.print("<br>sqlIC="+sqlIC);   			            
       PreparedStatement seqstmta=con.prepareStatement(sqlIC); //out.println("Step1.1.2");    				
       seqstmta.executeUpdate();
       seqstmta.close(); 		

	       %>
	          <script LANGUAGE="JavaScript">
	            alert("資料庫更新完畢!!");
	          </script>
	       <%

        int j = 1;
           out.println("<table width='50%' cellspacing='0' bordercolordark='#6699CC' cellpadding='1' bordercolorlight='#ffffff' border='1'><tr><td colspan='6'><font size='2' face='Arial'>料號有誤,無法轉入資料如下</font></td></tr> "+
                       " <tr bgcolor='#000077'><td><font size='2' face='Arial' color='#FFFFFF'>No.</font></td><td><font size='2' face='Arial' color='#FFFFFF'>ORG_ID</font></td><td><font size='2' face='Arial' color='#FFFFFF'>ITEM_NO</font></td><td><font size='2' face='Arial' face='Arial' color='#FFFFFF'>ITEM_DESC</font></td> "+
                       " <td><font size='2' face='Arial' color='#FFFFFF'>UOM</font></td><td><font size='2' face='Arial' color='#FFFFFF'>SAFTY_STOCK</font></td></tr>");    

   		String sqli = " select ORG_ID,ITEM_NO,ITEM_DESC,UOM,SAFTY_STOCK from apps.yew_safty_stock where item_id is null " ;
		// out.print("sqli="+sqli);
	 	Statement statei=con.createStatement();
     	ResultSet rsi=statei.executeQuery(sqli);
	 	while (rsi.next())
		{ 	
          out.print("<tr bgcolor='#D1E2FE'><td>"+j+"</td>"); 
          out.print("<td><font size='2' face='Arial'>"+rsi.getString("ORG_ID")+"</font></td>");
		  out.print("<td><font size='2' face='Arial'>"+rsi.getString("ITEM_NO")+"</font></td>");
          out.print("<td><font size='2' face='Arial'>"+rsi.getString("ITEM_DESC")+"</font></td>");
          out.print("<td><font size='2' face='Arial'>"+rsi.getString("UOM")+"</font></td>");
          out.print("<td><font size='2' face='Arial'>"+rsi.getString("SAFTY_STOCK")+"</font></td></tr>");

         j++; 
        }//end of while
		rsi.close();
    	statei.close(); 
        out.println("</table>"); 
     }	
    else
     {out.print("updateFlag="+updateFlag);}

	} // end of try
			catch (Exception e)
			{
				 out.println("Exception updatedb:"+e.getMessage());		  
			} 

%>
</FORM>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
