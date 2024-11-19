<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
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
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function historyByDOCNO(pp)
{   
  subWin=window.open("TSIQCInspectLotHistoryDetail.jsp?INSPLOTNO="+pp,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function historyByCust(pp,qq,rr)
{   
  subWin=window.open("TSSDRQInformationQuery.jsp?CUSTOMERNO="+pp+"&CUSTOMERNAME="+qq+"&DATESETBEGIN=20000101"+"&DATESETEND=20991231"+"&CUSTOMERID="+rr,"subwin");  
}
function resultOfDOAP(repno,svrtypeno)
{   
  subWin=window.open("../jsp/subwindow/DOAPResultQuerySubWindow.jsp?REPNO="+repno+"&SVRTYPENO="+svrtypeno,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function IQCInspectDetailHistQuery(inspLotNo,lineNo)
{     
    subWin=window.open("../jsp/TSIQCInspectLotHistoryDetail.jsp?INSPLOTNO="+inspLotNo+"&LINENO="+lineNo,"subwin","width=800,height=480,scrollbars=yes,menubar=no");    	
}
function ExpandBasicInfoDisplay(expand)
{       
 //alert("URL="+location.href);
 //alert("length="+location.href.indexOf("EXPAND")); 
 var subURL = location.href.substring(0,location.href.indexOf("EXPAND")-1); 
 //alert("subURL="+subURL);
 var URL = location.href;
 if (location.href.indexOf("EXPAND")<0)
 {
          if (expand=="OPEN")
		  { 
		    document.DISPLAYREPAIR.action=URL;  
		  } else { 
                  document.DISPLAYREPAIR.action=URL+"&EXPAND="+expand;
				 }
 } else {
          if (expand=="OPEN")
		  { 
		    document.DISPLAYREPAIR.action=subURL; 
		  }
		  else
		  {
		   document.DISPLAYREPAIR.action=subURL+"&EXPAND="+expand;
		  }
        }
 //alert("LAST URL="+location.href);
 window.document.DISPLAYREPAIR.submit();
}
function popMenuMsg(itemDesc)
{
 alert("台半料號:"+itemDesc);
}
function setSubmitResult(URL,xINDEX,setResult)
{    
  var linkURL = "#ACTION";   
 
  document.DISPLAYREPAIR.action=URL+"&LINE_NO="+xINDEX+"&SETRESULT="+setResult+linkURL;
  document.DISPLAYREPAIR.submit();    
}
</script>
</head>
<%
    out.println("setResult="+setResult);
	

%>

<!--%<a href="../jsp/include/TSDRQBasicInfoDisplayPage.jsp?EXPAND=FALSE"><img src="/include/MINUS.gif" width="14" height="15" border="0"></a> %-->
<table cellSpacing="1" bordercolordark="#D0C8C1" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="0">
  <tr bgcolor="#8F5B34"><td width="3%">&nbsp;</td>
  <td width="6%"><font color="#CCCCCC">檢驗項目</font></td>
  <td width="77%"><font color="#CCCCCC">檢驗處理明細</font></td>
  <td width="14%"><font color="#CCCCCC">抽樣數量</font></td>  
  </tr>
  <%  
        int rowLength = 0, colLength = 0;
	    Statement stateCNT=con.createStatement();
        ResultSet rsCNT=stateCNT.executeQuery("select count(DISTINCT ITEM_ID),count(DISTINCT EXAMINE_ITEM_ID) from ORADDMAN.TSCIQC_EXAMINE where CLASS_ID='"+classID+"' ");	
	    if (rsCNT.next())  { rowLength = rsCNT.getInt(1); colLength = rsCNT.getInt(2); }
	    rsCNT.close();
	    stateCNT.close();
        String wafer[][]=new String[rowLength+1][colLength+1]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
       // 由檢驗項目表自動帶出內容
        String sqlInsp = "select * from ORADDMAN.TSCIQC_ITEM where CLASS_ID ='"+classID+"' order by ITEM_ID ";
		Statement stateInsp=con.createStatement();
        ResultSet rsInsp=stateInsp.executeQuery(sqlInsp);	   
	    while (rsInsp.next())
	    {//out.println("0");
		
			int itemNo = Integer.parseInt(rsInsp.getString("ITEM_ID"));
  %>
  <tr bgcolor="#DDDBAA"><td><div align="center"><%=rsInsp.getString("ITEM_ID")%></div></td>
       <td nowrap><%=rsInsp.getString("ITEM_NAME")%></td>
       <td nowrap>	        
			<%
			  switch (rsInsp.getString("ITEM_ID").charAt(1)) { // 利用Switch Case 條件決定要用那種內容檢驗的表單Include
               case '1':   // 外觀檢驗欄位			   
	           {   
			   
			       out.println("<table cellSpacing='0' bordercolordark='#D0AAC1' cellPadding='0' width='100%' align='center' borderColorLight='#ffffff' border='0'>");
				   out.println("<tr><td>");
			       out.print("外觀不良(Mechanical Nogo.):</td>");
			       out.print("<td><input type='text' name='SURDEFECT' value='"+surDefect+"' size=5>"+"pcs"+"</td>");
				   out.print("<td>破片/短少數(NotIntent/Shortage):</td>");
			       out.print("<td><input type='text' name='SHORTAGE' value='"+shortage+"' size=5>"+"pcs"+"</td>");				   
				   out.println("<td>鍍層(Plating Layer):</td>");
				   out.print("<td>");
				   try
                   {       
                     Statement statement=con.createStatement();
                     ResultSet rs=statement.executeQuery("select WF_PLAT_ID as WFPLATID,WF_PLAT_NAME from ORADDMAN.TSCIQC_WAFER_PLAT order by WF_PLAT_ID");
                     checkBoxBean.setRs(rs);
                     if (wfPlatID != null)
   	                 checkBoxBean.setChecked(wfPlatID);
	                 checkBoxBean.setFieldName("WFPLATID");	   
	                 checkBoxBean.setColumn(3); //傳參數給bean以回傳checkBox的列數
                     out.println(checkBoxBean.getRsString());
	                 statement.close();
                     rs.close();       
                   } //end of try
                   catch (Exception e)
                   {
                    out.println("Exception:"+e.getMessage());
                   }
				   out.println("</td></tr></table>");
				   wafer[itemNo][1]=surDefect;wafer[itemNo][2]=shortage;wafer[itemNo][3]=wfPlatID;				   
				   arrIQC2DWaferDiceBean.setArray2DString(wafer);
				   
				   
			     break;
			   }
			   case '2':
			   {
			       out.print("<input type='button' name='ELECDETAIL' value='電性檢測'>");
			       break;
			   }
			   case '3':
			   {
			        out.println("<table cellSpacing='0' bordercolordark='#D0AAC1' cellPadding='0' width='100%' align='center' borderColorLight='#ffffff' border='0'>");
				    out.println("<tr>");			      
                    out.println("<td nowrap>晶片尺寸:</td>");
	                out.println("<td nowrap>");	                
	                try
                    {       
                      Statement statement=con.createStatement();
                      ResultSet rs=statement.executeQuery("select WF_SIZE_ID as WFSIZEID,WFSIZE_REMARK from ORADDMAN.TSCIQC_WAFER_SIZE order by WF_SIZE_ID");
                      checkBoxBean.setRs(rs);
                      if (wfSizeID != null)
   	                  checkBoxBean.setChecked(wfSizeID);
	                  checkBoxBean.setFieldName("WFSIZEID");	   
	                  checkBoxBean.setColumn(3); //傳參數給bean以回傳checkBox的列數
                      out.println(checkBoxBean.getRsString());
	                  statement.close();
                      rs.close();       
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }	                
	                out.println("</td>");
					out.println("<td>晶粒尺寸:</td>");
					out.print("<td><input type='text' name='EXDICESIZE' value='"+exDiceSize+"' size=5>"+"mil"+"</td>");
	                out.println("<td>晶片厚度:</td>");
					out.print("<td><input type='text' name='EXWFTHICK' value='"+exWfThick+"' size=5>"+"μm"+"</td>");
	                out.println("<td>電阻系數:</td>");
					out.print("<td><input type='text' name='EXWFRESIST' value='"+exWfResist+"' size=5>"+"Ω-cm"+"</td>");
	                out.println("</tr></table>");
					wafer[itemNo][1]=wfSizeID;wafer[itemNo][2]=exDiceSize;wafer[itemNo][3]=exWfThick;wafer[itemNo][4]=exWfResist;
					arrIQC2DWaferDiceBean.setArray2DString(wafer);
					
			        break;
			   }
			    case '4': // 拉力測試
			   {
			       out.println("<table cellSpacing='0' bordercolordark='#D0AAC1' cellPadding='0' width='100%' align='center' borderColorLight='#ffffff' border='0'>");
				   out.println("<tr><td>");
			       out.print("拉力讀值(A/Dmin):</td>");
			       out.print("<td><input type='text' name='PULLDMIN' value='"+pullDMIN+"' size=5>"+"kg."+"</td>");
				   out.print("<td>剝裂測試(Peeling Test):</td>");
			       out.print("<td>金屬剝落層<input type='text' name='MATPEEL' value='"+peeling+"' size=5>"+"pcs"+"</td>");				   
				   out.println("<td>氣泡(Void):</td>");
				   out.print("<td><input type='text' name='VOIDBUB' value='"+voidBub+"' size=5>"+"pcs"+"</td>");
				   out.println("<td>氧化(Oxid):</td>");
				   out.print("<td><input type='text' name='OXID' value='"+oxid+"' size=5>"+"pcs"+"</td>");					 
				   out.println("</td></tr></table>");
				   wafer[itemNo][1]=pullDMIN;wafer[itemNo][2]=peeling;wafer[itemNo][3]=voidBub;wafer[itemNo][4]=oxid;
				   arrIQC2DWaferDiceBean.setArray2DString(wafer);
			       break;
			   }
			    case '5': // 晶片/晶粒數量
			   {
			       out.println("<table cellSpacing='0' bordercolordark='#D0AAC1' cellPadding='0' width='40%' align='left' borderColorLight='#ffffff' border='0'>");
				   out.println("<tr><td>");
			       out.print("晶粒短少率:</td>");
			       out.print("<td><input type='text' name='DICESHTRATE' value='"+diceShtRate+"' size=5>"+" %"+"</td>");
				   out.print("<td>晶片短少:</td>");
			       out.print("<td><input type='text' name='WFSHTQTY' value='"+wfShtQty+"' size=5>"+"片"+"</td>");
				   out.print("<td colspan=3>&nbsp;</td>");			   
				   out.println("</tr></table>");
				   wafer[itemNo][1]=diceShtRate;wafer[itemNo][2]=wfShtQty;
				   arrIQC2DWaferDiceBean.setArray2DString(wafer);
			       break;
			   }
			   case '6': // 晶片晶粒破片
			   {
			       break;
			   }
			   case '7': // 晶片晶粒崩邊
			   {
			       break;
			   }
			   case '8': // 晶片晶粒鍍層
			   {
			       break;
			   }
			   default:
			   {
			   
			   }
			  } // End of Switch
			%>
	   </td>
	   <td nowrap><a href onmouseover='this.T_WIDTH=150;this.T_OPACITY=80;return escape("<%=rsInsp.getString("EXITEM_MATHOD")%>")'><%=rsInsp.getString("EXITEM_SAMPQTY")%></a></td>	   
  </tr>
  <%
        }
		rsInsp.close();
		stateInsp.close();
  %>   
</table>
<table cellSpacing="1" bordercolordark="#D0C8C1" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="0">
  <tr bgcolor="#DDDBAA"> 
      <td width="28%" >電性良品率(Total Yield):
        <INPUT TYPE="TEXT" NAME="TOTALYIELD" SIZE=10 maxlength="10" value="<%=totalYield%>"> %		        
    </td>
	  <td width="29%" >適用產品(Products):
        <INPUT TYPE="TEXT" NAME="PRODMODEL" SIZE=10 maxlength="10" value="<%=prodModel%>">		        
    </td>
	  <td width="43%" colspan="3" >型號良率(Product Yiels):
        <INPUT TYPE="TEXT" NAME="PRODYIELD" SIZE=10 maxlength="10" value="<%=prodYield%>"> %	        
    </td>
  </tr> 
</table>
<table cellSpacing="1" bordercolordark="#D0C8C1" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="0">  
  <tr bgcolor="#DDDBAA"> 
      <td width="14%" colspan="1" valign="top"><div align="right">最後判定(Results):<BR><input type="button" name="EXRESULT" value="檢測結果確認" onClick='setSubmitResult("../jsp/TSIQCInspectLotInspectingPage.jsp?INSPLOTNO=<%=inspLotNo%>","<%=line_No%>","Y")'></div></td>
	  <td width="86%" colspan="4">         
		<%
		           try
                   {       
                     Statement statement=con.createStatement();
                     ResultSet rs=statement.executeQuery("select RESULT_ID,RESULT_DESC from ORADDMAN.TSCIQC_RESULT order by RESULT_ID");
                     checkBoxBean.setRs(rs);
                     if (result != null)
   	                 checkBoxBean.setChecked(result);
	                 checkBoxBean.setFieldName("RESULT");	   
	                 checkBoxBean.setColumn(1); //傳參數給bean以回傳checkBox的列數
                     out.println(checkBoxBean.getRsString());
	                 statement.close();
                     rs.close();       
                   } //end of try
                   catch (Exception e)
                   {
                    out.println("Exception:"+e.getMessage());
                   }	
		%>	         
    </td>
  </tr> 
</table> 
<%  // 若使用者作檢測結果確認,則先將結果存入資料庫_起
    if (setResult.equals("Y"))
	{  
	   String aIQCWaferDiceCode[][]=arrIQC2DWaferDiceBean.getArray2DContent();      // <!--取出夾入檢驗數據陣列內容-->
	
	    String sqlInspItem = "select * from ORADDMAN.TSCIQC_ITEM where CLASS_ID ='"+classID+"' order by ITEM_ID ";
		Statement stateInspItem=con.createStatement();
        ResultSet rsInspItem=stateInspItem.executeQuery(sqlInspItem);	   
	    while (rsInspItem.next())
	    { //out.println("0");
		  int i = Integer.parseInt(rsInspItem.getString("ITEM_ID")); // 取得列號
		  
	        String sqlExamItem = "select * from ORADDMAN.TSCIQC_EXAMINE where CLASS_ID ='"+classID+"' and ITEM_ID = '"+rsInspItem.getString("ITEM_ID")+"' order by EXAMINE_ITEM_ID ";
		    Statement stateExamItem=con.createStatement();
            ResultSet rsExamItem=stateExamItem.executeQuery(sqlExamItem);
			while (rsExamItem.next())
			{
			 int j = Integer.parseInt(rsExamItem.getString("EXAMINE_ITEM_ID")); // 取得行號
			 
			 if (i<6) // 暫時For 5 個晶片晶粒檢驗項目
			 {
			 
			   String sqlExist = "select EXAMINE_VALUE from ORADDMAN.TSCIQC_LOTEXAMINE_DETAIL where INSPLOT_NO = '"+inspLotNo+"' and CLASS_ID ='"+classID+"' and ITEM_ID = '"+rsInspItem.getString("ITEM_ID")+"' and EXAMINE_ITEM_ID='"+rsExamItem.getString("EXAMINE_ITEM_ID")+"' ";
		       Statement stateExist=con.createStatement();
               ResultSet rsExist=stateExist.executeQuery(sqlExist);
			   if (rsExist.next())
			   {  // 已存在,先刪除,後面再新增
			       String sqlDel= "delete from ORADDMAN.TSCIQC_LOTEXAMINE_DETAIL where INSPLOT_NO = '"+inspLotNo+"' and CLASS_ID ='"+classID+"' and ITEM_ID='"+rsInspItem.getString("ITEM_ID")+"' and EXAMINE_ITEM_ID = '"+rsExamItem.getString("EXAMINE_ITEM_ID")+"' ";
				   PreparedStatement pstmtDel=con.prepareStatement(sqlDel); 
				                     pstmtDel.executeUpdate(); 
                                     pstmtDel.close();  
			   }
	           rsExist.close();
			   stateExist.close();
	
	         String sqlDtl="insert into ORADDMAN.TSCIQC_LOTEXAMINE_DETAIL(INSPLOT_NO, LINE_NO, CLASS_ID, ITEM_ID, EXAMINE_ITEM_ID, "+
	                                                                     "EXAMINE_VALUE, EXAMINE_UNIT, DEFECT_REASON, LOT_RESULTS, "+ 
					           										     "DEFECT_REMARK, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY) "+		  
                           " values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
	         PreparedStatement pstmt=con.prepareStatement(sqlDtl);      
	                           pstmt.setString(1,inspLotNo); // 檢驗批單號
							   //out.println("inspLotNo="+inspLotNo);
	                           pstmt.setString(2,"ALL");     //  項次,預設以批為檢驗單位,以為日後可擴展為依檢驗批項次作檢驗
							   //out.println("LineNo="+"ALL");
						       pstmt.setString(3,classID);   //  檢驗類型代碼
							   //out.println("classID="+classID);
						       pstmt.setString(4,rsInspItem.getString("ITEM_ID"));  //out.println("itemID="+rsInspItem.getString("ITEM_ID"));       // 檢驗項目代碼							   
							   pstmt.setString(5,rsExamItem.getString("EXAMINE_ITEM_ID")); //out.println("examineitemID="+rsExamItem.getString("EXAMINE_ITEM_ID")); // 檢驗測試項目代碼
							   pstmt.setString(6,aIQCWaferDiceCode[i][j]);   //out.println("aIQCWaferDiceCode[i][j]="+aIQCWaferDiceCode[i][j]);              //  檢驗測試項目值
							   pstmt.setString(7,rsExamItem.getString("EXAMINE_ITEM_UNIT")); //out.println("Unit="+rsExamItem.getString("EXAMINE_ITEM_UNIT")); // 檢驗測試項目單位
							   pstmt.setString(8,"");        // 不良原因說明
							   pstmt.setString(9,result);  //out.println("result="+result);   // 最後檢驗結果
							   pstmt.setString(10,"");       // 備註說明
							   pstmt.setString(11,userID); // 最後更新人員
						       pstmt.setString(12,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
                               pstmt.setString(13,userID); // 最後更新人員	                          
                               pstmt.executeUpdate(); 
                               pstmt.close();  
						//out.println("<BR>");   // 最後檢驗結果	
			 } // End of if (i< 6)				   
			} // End of While (rsExamItem.next())
			rsExamItem.close();
			stateExamItem.close();	
						   			  
	    } // End of While (rsInspItem.close())
		rsInspItem.close();
		stateInsp.close();
	
	}  // 若使用者作檢測結果確認,則先將結果存入資料庫_起

%>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</html>
