<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>IQC Item Information Input Save Page</title>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
.style1 {
	color: #666600;
	font-weight: bold;
}
.style3 {color: #4E5309; font-weight: bold; }
</STYLE>
</head>
<%

  String maintMode=request.getParameter("MODE");
  String classID=request.getParameter("CLASSID"); 
  String itemID=request.getParameter("ITEMID"); 
  String itemCode=request.getParameter("ITEMCODE");
  String itemName=request.getParameter("ITEMNAME");
  String itemDesc=request.getParameter("ITEMDESC");
  String itemRemark=request.getParameter("ITEMREMARK");
  String createDate=request.getParameter("CREATEDATE");
  String createdBy=request.getParameter("CREATEDBY");
  String updateDate=request.getParameter("UPDATEDATE");
  String updatedBy=request.getParameter("UPDATEDBY");
  
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<A HREF="/oradds/jsp/TSIQCInspectItemInput.jsp">檢驗項目資料新增</A>&nbsp;<A HREF="/oradds/jsp/TSIQCInspectItemQuery.jsp">檢驗項目資料查詢</A>
<FORM name="MYFORM" method="post" action="TSIQCInspectItemInsert.jsp">
<%
  
  
  if (maintMode==null || maintMode.equals("INSERT"))
  {
  out.println(classID);
  out.println(itemID);
  out.println(itemCode);
  out.println(itemName);
  out.println(itemDesc);
  out.println(itemRemark);
  out.println(maintMode);
  
       // 取下一號ITEM ID識別碼_起
       String sSql = "select lpad(max(ITEM_ID)+1,2,'0') as ITEM_ID from ORADDMAN.TSCIQC_ITEM ";		  
	   String sWhere = "where CLASS_ID ='"+classID+"' ";		 
	   sSql = sSql+sWhere;		 		      
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sSql);
       if (rs.next() ) 
       { 
        itemID = rs.getString("ITEM_ID"); 
        out.println("<strong class='style3'>"+"Next ItemID value="+itemID+"</strong>"+"<BR>");
       }
       rs.close();
       statement.close();
	   
	// 取下一號ITEM ID識別碼_迄  
	
	if (itemCode!=null)
	{
	  // 開始寫入IQC ITEM主檔資料_起
	  String sql="insert into ORADDMAN.TSCIQC_ITEM(CLASS_ID,ITEM_ID,ITEM_CODE,ITEM_NAME,ITEM_DESC,ITM_REMARK,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY) "+
                 "values(?,?,?,?,?,?,?,?,?,?)";           
      PreparedStatement pstmt=con.prepareStatement(sql);
                        pstmt.setString(1,classID);  
                        pstmt.setString(2,itemID);
                        pstmt.setString(3,itemCode);  
                        pstmt.setString(4,itemName);
                        pstmt.setString(5,itemDesc);
                        pstmt.setString(6,itemRemark);             
                        pstmt.setString(7,createDate);
                        pstmt.setString(8,createdBy); //  
		                pstmt.setString(9,updateDate); 
		                pstmt.setString(10,updatedBy);                  
                        pstmt.executeUpdate();
	  // 開始寫入IQC ITEM主檔資料_迄
	    out.println("<strong class='style3'>"+"新增檢驗項目完成!!!"+"</strong>");	
	  } // end of if (itemCode!=null)	
	}
	else if (maintMode.equals("UPDATE"))
    {			
	   // 判斷若使用者查詢後新增,itemID 與 itemCode對應與原始不同
	   String sSql = "select ITEM_ID from ORADDMAN.TSCIQC_ITEM ";		  
	   String sWhere = "where CLASS_ID ='"+classID+"' and ITEM_ID = '"+itemID+"' and ITEM_CODE = '"+itemCode+"' ";		 
	   sSql = sSql+sWhere;	
	   out.println(sSql);	 		      
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sSql);
       if (rs.next() ) // 如果真的已存在,作修改
	   { 
	
	
	     String sql="update ORADDMAN.TSCIQC_ITEM set ITEM_CODE=?,ITEM_NAME=?,ITEM_DESC=?,ITM_REMARK=?,LAST_UPDATE_DATE=?,LAST_UPDATED_BY=? "+
                  "where CLASS_ID = '"+classID+"' and ITEM_ID ='"+itemID+"' ";           
         PreparedStatement pstmt=con.prepareStatement(sql);                      
                           pstmt.setString(1,itemCode);  
                           pstmt.setString(2,itemName);
                           pstmt.setString(3,itemDesc);
                           pstmt.setString(4,itemRemark); 
		                   pstmt.setString(5,updateDate); 
		                   pstmt.setString(6,updatedBy);                  
                           pstmt.executeUpdate(); 						 
	     out.println("<strong class='style3'>"+"更新檢驗項目完成!!!"+"</strong>");	
	  } // End of if (rs.next() )	
	  else { //否則即是新增
	            // 取下一號ITEM ID識別碼_起
                String sSqlID = "select lpad(max(ITEM_ID)+1,2,'0') as ITEM_ID from ORADDMAN.TSCIQC_ITEM ";		  
	            String sWhereID = "where CLASS_ID ='"+classID+"' ";		 
	            sSqlID = sSqlID+sWhereID;
				out.println(sSqlID);		 		      
                Statement stateID=con.createStatement();
                ResultSet rsID=stateID.executeQuery(sSqlID);
                if (rsID.next() ) 
                { 
                   itemID = rsID.getString("ITEM_ID"); 
                   out.println("<strong class='style3'>"+"Next ItemID value="+itemID+"</strong>"+"<BR>");
                }
                rsID.close();
                stateID.close();
	   
	// 取下一號ITEM ID識別碼_迄  
	          
	  
	           // 開始寫入IQC ITEM主檔資料_起
	           String sql="insert into ORADDMAN.TSCIQC_ITEM(CLASS_ID,ITEM_ID,ITEM_CODE,ITEM_NAME,ITEM_DESC,ITM_REMARK,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY) "+
                          "values(?,?,?,?,?,?,?,?,?,?)";           
               PreparedStatement pstmt=con.prepareStatement(sql);
                                 pstmt.setString(1,classID);  
                                 pstmt.setString(2,itemID);
                                 pstmt.setString(3,itemCode);  
                                 pstmt.setString(4,itemName);
                                 pstmt.setString(5,itemDesc);
                                 pstmt.setString(6,itemRemark);             
                                 pstmt.setString(7,createDate);
                                 pstmt.setString(8,createdBy); //  
		                         pstmt.setString(9,updateDate); 
		                         pstmt.setString(10,updatedBy);                  
                                 pstmt.executeUpdate();
	            // 開始寫入IQC ITEM主檔資料_迄
	            out.println("<strong class='style3'>"+"新增檢驗項目完成!!!"+"</strong>");
	       } //End of else 				 
	}  // end of else if (maintMode.equals("UPDATE"))

%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
