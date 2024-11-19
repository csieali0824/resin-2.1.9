<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>IQC Inspect Lot Drawing data Insert</title>
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
.style17 {
	color: #000099;
	font-family: Georgia;
	font-weight: bold;
	font-size: large;
}
</STYLE>
<script language="javascript">
   function setFormClose()
   { 
    flag=confirm("是否確認關閉?"); 
	if (flag=true) this.window.close();
    return flag;
   }
</script>
</head>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/IQCinclude/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="array2DDrawInputBean" scope="session" class="Array2DimensionInputBean"/>
<body>
<A HREF="/oradds/OraddsMainMenu.jsp">回首頁</A> 
<%
   String successInsert = "FALSE";
   String inspLotNo=request.getParameter("INSPLOTNO"); 
   String classID=request.getParameter("CLASSID");
   
   String a[][]=array2DDrawInputBean.getArray2DContent();//取得目前陣列內容
   
   
   
   String q[][]=array2DDrawInputBean.getArray2DContent();//取得目前陣列內容		
    //印出陣列內容
   if (q!=null) 
   {			        
	  out.println(array2DDrawInputBean.getArray2DDrawString());
   }
   
 try
 {   
   
  if (a!=null) // 判斷入若session Array 內值不為null
  {  //out.println("5");
  
     // 判斷若檢驗批檢測明細已存在,則先刪除後新增_起
	     String sqlExist ="  select * from ORADDMAN.TSCIQC_LOTDRAWING_DETAIL where INSPLOT_NO = '"+inspLotNo+"' and CLASS_ID ='"+classID+"' ";  
         Statement stateExist=con.createStatement();
         ResultSet rsExist=stateExist.executeQuery(sqlExist);
         if (rsExist.next())
         {
		      String sqlDel="delete from ORADDMAN.TSCIQC_LOTDRAWING_DETAIL where INSPLOT_NO = '"+inspLotNo+"' and CLASS_ID ='"+classID+"' ";		 
	          PreparedStatement stmtDEL=con.prepareStatement(sqlDel);                 	
		      stmtDEL.executeUpdate();
              stmtDEL.close();
		 }
		 rsExist.close();
		 stateExist.close();
	 
	 //  判斷若檢驗批檢測明細已存在,則先刪除後新增_迄
  
     for (int ac=0;ac<a.length;ac++)
     { 	 
	   for (int k=2;k<a[ac].length;k++)
	   {
         String sql="insert into ORADDMAN.TSCIQC_LOTDRAWING_DETAIL(INSPLOT_NO, CLASS_ID, PART_CODE, PART_DESC, SEQ_NO, EXAM_VALUE, ATTRIBUTE1, DRAW_REMARK, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)"+  //9
                         " values(?,?,?,?,?,?,?,?,?,?,?,?) ";
         //out.println("3="+waiveLot);
         PreparedStatement pstmt=con.prepareStatement(sql);  
         pstmt.setString(1,inspLotNo);  // 檢驗批單號
         pstmt.setString(2,classID); // CLASS_ID 檢驗識別碼
         pstmt.setString(3,a[ac][1]);  // 規格圖位
         pstmt.setString(4,"");  // 規格圖位說明
         pstmt.setInt(5,k-1);   // SeqNo 第 k-1 次測量值  
         pstmt.setFloat(6,Float.parseFloat(a[ac][k])); // 從第貳欄開始為資料
         pstmt.setString(7,""); //若為CPK, MIN, MAX, AVG 等值,則註記
		 pstmt.setString(8,""); // 備註說明
		 pstmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //CREATION_DATE日期  
         pstmt.setString(10,userID); //寫入User ID
         pstmt.setString(11,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //CREATION_DATE日期 
         pstmt.setString(12,userID); //最後更新User  
         pstmt.executeUpdate(); 
         pstmt.close();
		 
	   } //enf of for k=0
   
     } //enf of for	
     successInsert = "TRUE";
   }  // End of if (a!=null) 
   
  } //end of try
  catch (SQLException e)
  {
    out.println(e.getMessage());
  }//end of catch
  

%>
<%    
	//array2DDrawInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
%>
<input type="button" name='CLOSE' value="關閉" onClick="setFormClose()">
</body>
	<input name="INSPLOTNO" type="hidden" value="<%=inspLotNo%>" >
	<input name="CLASSID" type="hidden" value="<%=classID%>" >
<%@ include file="/jsp/IQCinclude/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
   
	if (successInsert==null || successInsert.equals("FALSE"))
	{	  
	    %>
		   <script language="javascript">
		       alert("儲存資料異常,未成功新增檢驗明細檔資料,請檢視您的資料 !!!");	
		   </script>
		<%
		response.reset();
	    response.sendRedirect("../IQCInclude/TSIQCInspectLotDrawingInput.jsp?INSPLOTNO="+inspLotNo+"&CLASSID="+classID+"&INSERT=Y");
	} else
	    { 
		  array2DDrawInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作		 		  
        }  
%>

</html>
