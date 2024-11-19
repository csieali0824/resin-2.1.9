<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.Math.*"%>
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
function subSpecFileUpload(inspLotNo, classID)
{    
  //subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  subWin=window.open("../jsp/IQCInclude/TSIQCSpecFileBlobsUpload.jsp?INSPLOTNO="+inspLotNo+"&CLASSID="+classID,"subwin","width=640,height=480,status=yes,scrollbars=yes");  
} 
function subInspDrawInput(inspLotNo, classID)
{ 
  subWin=window.open("../jsp/IQCInclude/TSIQCInspectLotDrawingInput.jsp?INSPLOTNO="+inspLotNo+"&CLASSID="+classID,"subwin","width=640,height=480,status=yes,scrollbars=yes,menubar=yes,scrollbar=yes,resizable=yes"); 
}
</script>
</head>
<%
   result=request.getParameter("RESULT"); // 取最後傳過來的檢驗結果值

   try
   {
    //out.println("setResult="+setResult);
	 if (setResult==null || setResult.equals("N") )  // 若判斷不是確認檢測資料送出,則找出同檢驗批內檢測資料_起
	 {  
	    String sqlInspNo = "select * from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO='"+inspLotNo+"' ";
		Statement stateInspNo=con.createStatement();
        ResultSet rsInspNo=stateInspNo.executeQuery(sqlInspNo);	   
	    while (rsInspNo.next())
	    { //out.println("0");
		    
			totalYield = rsInspNo.getString("TOTAL_YIELD");
			product = rsInspNo.getString("PROD_MODEL");
			prodYield = rsInspNo.getString("PROD_YIELD");
						   			  
	    } // End of While (rsInspItem.close())
		rsInspNo.close();
		stateInspNo.close();
			
	 } // End of if (!setResult.equals("Y"))
     // 若判斷不是確認檢測資料送出,則找出同檢驗批內檢測資料_迄
   } //end of try
   catch (Exception e)
   {
     out.println("Exception:"+e.getMessage());
   }	 
%>
<%
   
%>
<!--%<a href="../jsp/include/TSDRQBasicInfoDisplayPage.jsp?EXPAND=FALSE"><img src="/include/MINUS.gif" width="14" height="15" border="0"></a> %-->
<table cellSpacing="1" bordercolordark="#D0C8C1" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="0">
  <tr bgcolor="#8F5B34"><td width="3%">&nbsp;</td>
  <td width="11%"><font color="#CCCCCC">檢驗項目</font></td>
  <td width="72%"><font color="#CCCCCC">檢驗處理明細</font></td>
  <td width="14%"><font color="#CCCCCC">抽樣數量</font></td>  
  </tr>
  <%  
  /*
        double test = 48;
		double mon = 20;
		out.println("rem="+Math.IEEEremainder(test,mon));
		
		out.println("Quot="+(test/mon));
		
		out.println("testCeil="+Math.ceil(test/mon));
	*/	
		//out.println("test="+test);
		//out.println("testDouble="+Math.ceil(test));
      
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
		
		%>
	  <tr bgcolor="#DDDBAA">
	   <td bgcolor="#8F5B34" nowrap><div align="center"><font color="#CCCCCC"><%=rsInsp.getString("ITEM_ID")%></font></div></td>
       <td nowrap><font color="#000066"><%=rsInsp.getString("ITEM_NAME")%></font></td>
       <td nowrap>	
		<%
		    out.println("<table cellSpacing='0' bordercolordark='#D0AAC1' cellPadding='0' width='100%' align='center' borderColorLight='#ffffff' border='0'>");
	        out.println("<tr>");
			int itemNo = Integer.parseInt(rsInsp.getString("ITEM_ID"));			
			
			String sqlExam = "select * from ORADDMAN.TSCIQC_EXAMINE where CLASS_ID ='"+classID+"' and ITEM_ID = '"+rsInsp.getString("ITEM_ID")+"' order by EXAMINE_ITEM_ID ";
		    Statement stateExam=con.createStatement();
            ResultSet rsExam=stateExam.executeQuery(sqlExam);
			while (rsExam.next())
			{
			  int examNo = Integer.parseInt(rsExam.getString("EXAMINE_ITEM_ID"));
			  
			  String examValue = "";
			  String sqlVal = "select EXAMINE_VALUE from ORADDMAN.TSCIQC_LOTEXAMINE_DETAIL where INSPLOT_NO = '"+inspLotNo+"' and CLASS_ID ='"+classID+"' and ITEM_ID = '"+rsInsp.getString("ITEM_ID")+"' and EXAMINE_ITEM_ID='"+rsExam.getString("EXAMINE_ITEM_ID")+"' ";
		      Statement stateVal=con.createStatement();
              ResultSet rsVal=stateVal.executeQuery(sqlVal);
			  if (rsVal.next() && !setResult.equals("Y"))
			  {
			    examValue = rsVal.getString("EXAMINE_VALUE");
			  }  // End of if (rsVal.next()) 	
			  //else if (aIQCWaferDiceCode!=null) examValue = aIQCWaferDiceCode[itemNo][examNo];			  		 
              rsVal.close();
              stateVal.close();
		   
		    
			 out.print("<td width='10%' nowrap>"+rsExam.getString("EXAMINE_ITEM_NAME")+":</td>");
			 /*
			  out.print("<td><input type='text' name='"+rsExam.getString("EXAMINE_ITEM_CODE")+"' value='"+examValue+"' size=5> "+rsExam.getString("EXAMINE_ITEM_UNIT")+"</td>");			 
			  wafer[itemNo][examNo]=examValue;				   
			  arrIQC2DMMaterialBean.setArray2DString(wafer);
			*/
			if (rsInsp.getString("ITEM_ID").equals("01")) // 尺寸
			{
			  switch (rsExam.getString("EXAMINE_ITEM_ID").charAt(1)) { // 利用Switch Case 條件決定要用那種內容檢驗的表單Include
			    case '1':   // 主要原物料尺寸規格圖面		   
	            {   
				  if (specFile==null || specFile.equals("")) specFile=examValue;
				  //out.print("<td><input type='text' name='"+rsExam.getString("EXAMINE_ITEM_CODE")+"' value='"+surDefect+"' size=5> "+rsExam.getString("EXAMINE_ITEM_UNIT")+"</td>");			 				  
				  out.print("<td width='10%'>");
				  %>
				  <input type="button" name="EXRESULT" value="規格圖面上載" onClick='subSpecFileUpload("<%=inspLotNo%>","<%=classID%>")'>
				  <%
				  out.print("</td>");
			      wafer[itemNo][examNo]=surDefect;				   
			      arrIQC2DMMaterialBean.setArray2DString(wafer);
				  break;
			    }
				case '2':   // CPK>=1.67			   
	              {   
				    if (mtSizeCPK==null) mtSizeCPK=examValue;
				    out.print("<td><input type='text' name='"+rsExam.getString("EXAMINE_ITEM_CODE")+"' value='"+mtSizeCPK+"' size=5> "+rsExam.getString("EXAMINE_ITEM_UNIT")+"</td>");			 
			        wafer[itemNo][examNo]=mtSizeCPK;				   
			        arrIQC2DMMaterialBean.setArray2DString(wafer);
				    break;
			      }			   		  
			    default:
			    {
			   
			    }
			   } // End of Switch
		 }// End of if ()	
		 else if (rsInsp.getString("ITEM_ID").equals("02"))   
		      {
			    switch (rsExam.getString("EXAMINE_ITEM_ID").charAt(1)) { // 利用Switch Case 條件決定要用那種內容檢驗的表單Include
			      case '1':   // 包裝數量短少%			   
	              {   
				    if (qtyShtRate==null) qtyShtRate=examValue;
				    out.print("<td><input type='text' name='"+rsExam.getString("EXAMINE_ITEM_CODE")+"' value='"+qtyShtRate+"' size=5> "+rsExam.getString("EXAMINE_ITEM_UNIT")+"</td>");			 
			        wafer[itemNo][examNo]=qtyShtRate;				   
			        arrIQC2DMMaterialBean.setArray2DString(wafer);
				    break;
			      }
			      default:
			      {
			   
			      }
			    } // End of Switch
			  } // ENd of else if (rsInsp.getString("ITEM_ID").equals("02"))
			  else if (rsInsp.getString("ITEM_ID").equals("03"))
			       {
			             switch (rsExam.getString("EXAMINE_ITEM_ID").charAt(1)) { // 利用Switch Case 條件決定要用那種內容檢驗的表單Include
			               case '1':   // 外觀0收1退			   
	                       {   
						     if (mtSurface==null || mtSurface.equals("")) mtSurface=examValue;
				             //out.print("<td><input type='text' name='"+rsExam.getString("EXAMINE_ITEM_CODE")+"' value='"+exWfSizeID+"' size=5> "+rsExam.getString("EXAMINE_ITEM_UNIT")+"</td>");			 
							 out.println("<td nowrap>");
	                         try
                             {       
                              Statement statement=con.createStatement();
                              ResultSet rs=statement.executeQuery("select RULE_ID as MTSURFACE,RULE_NAME from ORADDMAN.TSCIQC_RULE order by RULE_ID");
                              checkBoxBean.setRs(rs);
                              if (mtSurface != null)
   	                          checkBoxBean.setChecked(mtSurface);
	                          checkBoxBean.setFieldName("MTSURFACE");	   
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
			                 wafer[itemNo][examNo]=mtSurface;				   
			                 arrIQC2DMMaterialBean.setArray2DString(wafer);
				             break;
			               }						   
			               default:
			               {
						   			   
			               }
			             } // End of Switch
				   } // End of else if (rsInsp.getString("ITEM_ID").equals("03"))
				   else if (rsInsp.getString("ITEM_ID").equals("04"))  // 鋅底平面度0收1退
				         {
						      switch (rsExam.getString("EXAMINE_ITEM_ID").charAt(1)) { // 利用Switch Case 條件決定要用那種內容檢驗的表單Include
			                    case '1':   // 0收1退
	                            {   
								  if (mtPlatDeg==null || mtPlatDeg.equals("")) mtPlatDeg=examValue;
				                  out.println("<td nowrap>");
	                              try
                                  {       
                                     Statement statement=con.createStatement();
                                     ResultSet rs=statement.executeQuery("select RULE_ID as MTPLATDEG,RULE_NAME from ORADDMAN.TSCIQC_RULE order by RULE_ID");
                                     checkBoxBean.setRs(rs);
                                     if (mtPlatDeg != null)
   	                                 checkBoxBean.setChecked(mtPlatDeg);
	                                 checkBoxBean.setFieldName("MTPLATDEG");	   
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
			                      wafer[itemNo][examNo]=mtPlatDeg;				   
			                      arrIQC2DMMaterialBean.setArray2DString(wafer);
				                  break;
			                    }								
			                    default:
			                    {
			   
			                    }
			                  } // End of Switch
						 }// end of if (rsInsp.getString("ITEM_ID").equals("04"))
						 else if (rsInsp.getString("ITEM_ID").equals("05"))  // 外包裝箱
						      {
							      switch (rsExam.getString("EXAMINE_ITEM_ID").charAt(1)) { // 利用Switch Case 條件決定要用那種內容檢驗的表單Include
			                       case '1':   // 0收1退			   
	                               { 
								     if (mtPackBox==null || mtPackBox.equals("")) mtPackBox=examValue;   
				                     out.println("<td nowrap>");
	                                 try
                                     {       
                                        Statement statement=con.createStatement();
                                        ResultSet rs=statement.executeQuery("select RULE_ID as MTPACKBOX,RULE_NAME from ORADDMAN.TSCIQC_RULE order by RULE_ID");
                                        checkBoxBean.setRs(rs);
                                        if (mtPackBox != null)
   	                                    checkBoxBean.setChecked(mtPackBox);
	                                    checkBoxBean.setFieldName("MTPACKBOX");	   
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
			                         wafer[itemNo][examNo]=mtPackBox;				   
			                         arrIQC2DMMaterialBean.setArray2DString(wafer);
				                     break;
			                       }
								   default:
			                       {
			   
			                       }
			                      } // End of Switch
							  } // End of if (rsInsp.getString("ITEM_ID").equals("05"))
		
 
			
          }  // End of while (rsExam.next())
		  rsExam.close();
		  stateExam.close();
		 out.println("</tr>");
         out.println("</table>");
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
      <td width="14%">
	    <div align="center"><input type="button" name="EXRESULT" value="檢測明細輸入" onClick='subInspDrawInput("<%=inspLotNo%>","<%=classID%>")'></div>
      </td>
      <td width="27%" >抽樣數:
        <INPUT TYPE="TEXT" NAME="EXSAMPLEQTY" SIZE=10 maxlength="10" value="<%=exSampleQty%>">		        
    </td>
	  <td width="30%" >物料名稱:
        <INPUT TYPE="TEXT" NAME="EXPRODNAME" SIZE=20 maxlength="30" value="<%=exProdName%>">		        
    </td>
	  <td width="29%" colspan="3" >數量:
        <INPUT TYPE="TEXT" NAME="EXINSPECTQTY" SIZE=10 maxlength="10" value="<%=exInspectQty%>">	        
    </td>
  </tr> 
</table>
<%  
  try
  {
    // 若使用者作檢測結果確認,則先將結果存入資料庫_起
    if (setResult.equals("Y"))
	{  
	    String aIQCMMaterialCode[][]=arrIQC2DMMaterialBean.getArray2DContent();      // <!--取出夾入檢驗數據陣列內容-->
	
	    String sqlInspItem = "select * from ORADDMAN.TSCIQC_ITEM where CLASS_ID ='"+classID+"' order by ITEM_ID ";
		Statement stateInspItem=con.createStatement();
        ResultSet rsInspItem=stateInspItem.executeQuery(sqlInspItem);	   
	    while (rsInspItem.next())
	    {//out.println("0");
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
							   pstmt.setString(6,aIQCMMaterialCode[i][j]);   //out.println("aIQCWaferDiceCode[i][j]="+aIQCWaferDiceCode[i][j]);              //  檢驗測試項目值
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
		
		
		// ----------------更改檢驗批主檔的資料_於間接原物料頁面_起
		 try
		 {		
		      String sqlExist = "select * from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO = '"+inspLotNo+"' and IQC_CLASS_CODE ='"+classID+"' ";
		      Statement stateExist=con.createStatement();
			  //out.println(sqlExist);
              ResultSet rsExist=stateExist.executeQuery(sqlExist);
			  if (rsExist.next())
			  {  // 已存在,作更新
			    				
			       String sqlUpdate= "update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set SAMPLE_QTY=?, INSPECT_QTY=?, PROD_NAME=? where INSPLOT_NO = '"+inspLotNo+"' ";
				   PreparedStatement pstmtUpd=con.prepareStatement(sqlUpdate);
				                     pstmtUpd.setFloat(1,Float.parseFloat(exSampleQty)); 
									 pstmtUpd.setFloat(2,Float.parseFloat(exInspectQty));
									 pstmtUpd.setString(3,exProdName);
				                     pstmtUpd.executeUpdate(); 
                                     pstmtUpd.close();  
			  }
	          rsExist.close();
			  stateExist.close();
		  } //end of try
          catch (Exception e)
          {
            out.println("Update Insp Header Exception:"+e.getMessage());
          }	
		//  ---------------更改檢驗批主檔的資料_於間接原物料頁面_迄
		
	%> 
	   <script language="javascript">
	       alert("資料已更新!");
	   </script>
	<%		
	
	}  // 若使用者作檢測結果確認,則先將結果存入資料庫_迄
	
	
 } //end of try
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }	

%>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</html>
