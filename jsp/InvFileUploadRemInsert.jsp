<!--讀入EXCEL庫存餘額表, 並產生倉別/架位主檔-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Remaining File Upload Insert</title>
</head>

<body>
<%
try
{
	//
	PreparedStatement stateDel=con.prepareStatement("DELETE FROM INV_M_REM");
	stateDel.executeUpdate();
	stateDel.close();
	
	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	out.println("File name="+upload_file.getFileName());
	upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); // save file o server
	InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName());   // open uplad file
	jxl.Workbook wb = Workbook.getWorkbook(is);  // open work book
	int iSheets = wb.getNumberOfSheets();
	out.println("<BR>"+"Sheets="+iSheets);
	
	String sToday = dateBean.getYearMonthDay();
	out.println("Today="+sToday);

	int i = 1;
	while (i<2)
	//while (i<iSheets)
	{
		
		jxl.Sheet sht = wb.getSheet(i);  // open work sheet
		String sSheetName = sht.getName();
		out.println("<BR>"+"Seq="); out.println(i+1);
		out.println("Sheet Name="+sSheetName);
		int iMaxRows = sht.getRows();  // get max rows
		out.println("MaxRow="+iMaxRows);
		
		PreparedStatement stateIns=con.prepareStatement("INSERT INTO INV_M_REM "+
		"(REMWHS,REMLOC,REMITEMNO,REMQTY)"+" VALUES(?,?,?,?)");

		
		int n = 4;
		while (n<iMaxRows)
		{
			out.println("<br>");
			out.println(n+1);
			
			jxl.Cell wc1 = sht.getCell(1, n);
			String sItem = wc1.getContents();
			sItem = sItem.trim();
			//out.println("Item="+sItem);
			
			jxl.Cell wc2 = sht.getCell(2, n);
			String sDesc = wc2.getContents();
			//out.println("Desc="+sDesc);
			
			jxl.Cell wc3 = sht.getCell(3, n);
			String sUM = wc3.getContents();
			//out.println("UM="+sUM);
			
			if (sItem!=null && !sItem.equals("")) {
				int iSerial = 0;
				// 是否存在INV_ITEM, 若無則從IIM抄過來, 再無則新增
				Statement stateExist=con.createStatement();
				ResultSet rsExist=stateExist.executeQuery("SELECT * FROM INV_ITEM WHERE ITEMNO='"+sItem+"'");
				if (!rsExist.next()) {
					Statement stateIIM=bpcscon.createStatement();
					ResultSet rsIIM=stateIIM.executeQuery("SELECT IPROD,IDESC||IDSCE AS DESC,IUMS,SERIALCOLUMN FROM IIM WHERE IPROD='"+sItem+"'");
					if (rsIIM.next()) {
						sDesc = rsIIM.getString("DESC");
						sUM = rsIIM.getString("IUMS");
						//out.println("DESC="+sDesc);
						//out.println("UM="+sUM);
					}
					rsIIM.close();
					stateIIM.close();
					
					PreparedStatement stateINV=con.prepareStatement("INSERT INTO INV_ITEM "+
					" (ITEMNO,ITEMDESC,ITEMUOM,ITEMCREATEUSER,ITEMCREATEDATE,ITEMCREATENO,SERIALCOLUMN)"+
					" VALUES(?,?,?,?,?,?,?)");
					stateINV.setString(1,sItem);
					stateINV.setString(2,sDesc);
					stateINV.setString(3,sUM);
					stateINV.setString(4,"wsadmin");
					stateINV.setString(5,sToday);
					stateINV.setString(6,sToday);
					stateINV.setInt(7,iSerial);
					stateINV.executeUpdate();
					stateINV.close();
				
				} // end if
				rsExist.close();
				stateExist.close();
			} // end if  (sItem!=null && !sItem.equals(""))
			
			jxl.Cell wc4 = sht.getCell(4, n);
			String sQty = wc4.getContents();
			//out.println("Qty="+sQty);
			
			jxl.Cell wc7 = sht.getCell(7, n);
			String sLoc = wc7.getContents();
			sLoc = sLoc.trim();
			if (sLoc!=null && !sLoc.equals(""))
			{
				sLoc = sLoc.substring(2,5);
				
			}
			//out.println("Loc="+sLoc);

			jxl.Cell wc8 = sht.getCell(8, n);
			String sVend = wc8.getContents();
			sVend = sVend.trim();
			//out.println("Vend="+sVend);
			String sVndNo = "";
			if (sVend!=null && !sVend.equals(""))
			{
				Statement state=con.createStatement();
				String sql = "SELECT VNDNO FROM INV_VND WHERE VNDDESC='"+sVend+"'";
				//out.println(sql);
				ResultSet rs=state.executeQuery(sql);
				boolean rs_isEmpty = !rs.next();
				boolean rs_hasData = !rs_isEmpty;
				if (rs_hasData) { sVndNo = rs.getString("VNDNO"); String sLoct = sLoc; sLoc = sLoc + sVndNo;
					// 是否存在倉別/架位, 否則新增
					Statement stateExist=con.createStatement();
					ResultSet rsExist=stateExist.executeQuery("SELECT * FROM INV_WHS WHERE WHSLOC='"+sLoc+"'");
					if (!rsExist.next()) {					
						Statement stateGroup=con.createStatement();
						ResultSet rsGroup=state.executeQuery("SELECT GCNNAME FROM INV_GROUP WHERE GLOC='"+sLoct+"'");
						String sCN = "";
						if (rsGroup.next()) { sCN = rsGroup.getString("GCNNAME");
							rsGroup.close();
							stateGroup.close();
							PreparedStatement stateWHS=con.prepareStatement("INSERT INTO INV_WHS"+
							" (WHSWHS,WHSLOC,WHSDESC,WHSCREATEUSER,WHSCREATEDATE,WHSCREATENO)"+
							" VALUES (?,?,?,?,?,?)");
							stateWHS.setString(1,"CE");
							stateWHS.setString(2,sLoc);
							stateWHS.setString(3,sCN+"-"+sVend);  //out.println(sCN+"-"+sVend);
							stateWHS.setString(4,"wsadmin");
							stateWHS.setString(5,sToday);
							stateWHS.setString(6,sToday);
							stateWHS.executeUpdate();
							stateWHS.close();
						}
						else { sLoc = "X"+sVndNo;
						}
						
					}
					rsExist.close();
					stateExist.close();
				
				}
				else {sLoc = sLoc + "X"; }
				rs.close();
				state.close();
			} // end if
			
			//out.println("LOC="+sLoc);

			
			if (sItem!=null && !sItem.equals("") && sQty!=null && !sQty.equals("") && sVend!=null && !sVend.equals("") && sLoc!=null && !sLoc.equals(""))
			{
				stateIns.setString(1,"CE");
				stateIns.setString(2,sLoc);
				stateIns.setString(3,sItem);
				stateIns.setFloat(4,Float.parseFloat(sQty));
				stateIns.executeUpdate();
			}
			
			n++;
		} // end while n
		
		stateIns.close();
		
		i++;
		
		
		
	} // end while i
	
	wb.close();

}  // end try
catch (Exception e){out.println("Exception:"+e.getMessage());}

%>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>