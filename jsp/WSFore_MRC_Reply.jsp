<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ArrayStoreBean,RsCountBean" %>
<jsp:useBean id="arrayStoreBean" scope="session" class="ArrayStoreBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<script language="JavaScript" type="text/JavaScript">
function submitCheck()
{ 
  //檢查是否選取的資料有填入相對應的DATA
  for (i = 0; i < field.length; i++)  
  {      
	    if (document.MYFORM.elements["DELIVERYDATE-"+field[i]].value=="" || document.MYFORM.elements["DELIVERYDATE-"+field[i]].value==null || document.MYFORM.elements["DELIVERYQTY-"+field[i]].value=="" || document.MYFORM.elements["DELIVERYQTY-"+field[i]].value==null)
		{ 
          alert("Before you submit, please do not let the DELIVERY DATE and DELIVERY Qty be blank or null !!");   
          return(false);
		}  
		
		txt1=document.MYFORM.elements["DELIVERYQTY-"+field[i]].value;	
		txt2=document.MYFORM.elements["DELIVERYDATE-"+field[i]].value;	
		for (j=0;j<txt1.length;j++)      
        { 
	       c=txt1.charAt(j);
	        if ("0123456789.".indexOf(c,0)<0) 
	       {
             alert("The data that you inputed should be numerical!!");    
             return(false);
		    }
        }	
		
		for (j=0;j<txt2.length;j++)      
        { 
	       c=txt2.charAt(j);
	        if ("0123456789.".indexOf(c,0)<0) 
	       {
             alert("The data that you inputed should be numerical!!");    
             return(false);
		    }
        }					
  } //END OF 檢查是否選取的資料有填入相對應的DATA  
  
  document.MYFORM.action="../jsp/WSFore_MRC_ReplyProcess.jsp";   
  document.MYFORM.submit();   
}
function changeItem(itemName,lineNo,func)
{   
  document.MYFORM.ITEMNAME.value=itemName;
  document.MYFORM.LINENO.value=lineNo;
  document.MYFORM.FUNC.value=func;       
  document.MYFORM.action="../jsp/WSFore_MRC_Reply.jsp"; 
  document.MYFORM.submit();   
}
</script>
<%    
  String docNo=request.getParameter("DOCNO"); 
  String option=request.getParameter("OPTION"); //檢查是否第一次進REPLY這個工作 
  if (option==null) option="";
  String remark=request.getParameter("REMARK");  
  String isComplete=request.getParameter("ISCOMPLETE");     
  String itemName=request.getParameter("ITEMNAME");
  String lineNo=request.getParameter("LINENO");
  String func=request.getParameter("FUNC");
  String MRC_Array[][]=null,tempArray[][]=null; 
  
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);   
  ResultSet rs=null;  
  
 try
 {         
   if (option.equals("NEW"))
   {
      arrayStoreBean.setArray2DStore(null); //若是第一次進入則先清空Array Bean中之資料
	  
	  //取得Header的資料
      rs=statement.executeQuery("select IS_COMPLETE,REMARK from PSALES_FORE_MRC_HD,WSUSER where DOCNO='"+docNo+"' and CREATEDBY=WEBID(+)"); 
      if (rs.next())                 
      {       	 
	    remark=rs.getString("REMARK");	
	    if (remark==null) remark="";	
		isComplete=rs.getString("IS_COMPLETE");	
		if (isComplete==null) isComplete="";
      } 
      rs.close();     	
	  
	  //取得line detail的資料
	  rs=statement.executeQuery("select PRJCD,b.SALESCODE,COLOR,ORIGIN_RQTY,ORIGIN_RDATE,EP_QTY,EP_DATE from PSALES_FORE_MRC_LN a,PIMASTER b where trim(a.PRJCD)=trim(b.PROJECTCODE) and DOCNO='"+docNo+"' and R_TYPE='I' order by LINENO");   
	  rsCountBean.setRs(rs); //取得其line detail總筆數
	  MRC_Array=new String[rsCountBean.getRsCount()][12]; //宣告為符合其總筆數大小之陣列
	  
	  int ari=0;
	  while (rs.next())  
      {                  
	   MRC_Array[ari][0]=rs.getString("PRJCD");
	   MRC_Array[ari][1]=rs.getString("COLOR");
	   MRC_Array[ari][2]="0";
	   MRC_Array[ari][3]="PARENT";
	   MRC_Array[ari][4]=rs.getString("SALESCODE");	   
	   MRC_Array[ari][5]=rs.getString("ORIGIN_RQTY");
	   MRC_Array[ari][6]=rs.getString("EP_QTY");	
	   MRC_Array[ari][7]=rs.getString("EP_DATE"); 
	   MRC_Array[ari][8]=rs.getString("EP_QTY");	
	   MRC_Array[ari][9]=rs.getString("EP_DATE"); 
	   MRC_Array[ari][10]=""; //comment
	   MRC_Array[ari][11]="0"; //sub-line total
	   ari++;
	  } //end of while=>rs.next
	  rs.close();	
	  arrayStoreBean.setArray2DStore(MRC_Array); //將資料寫到bean裏
   } else  {
      tempArray=arrayStoreBean.getArray2DStore();	  
	  if (func!=null && !func.equals(""))
	  {	    
	     //+++++++++++若為新增一筆子項++++++++++++++++++++++++++++++
		 if (func.equals("ADD")) 
		 {		 
			int addIndex=0;
			String verifyStr="",lineParam="";		
			MRC_Array=new String[tempArray.length+1][12]; //宣告為符合其總筆數加1筆的大小之陣列
			for (int i=0;i<tempArray.length;i++)
			{		
			   lineParam=tempArray[i][0]+"-"+tempArray[i][1]+"-"+tempArray[i][2]; //做為取得其前一頁之項目辨識字元			   
			   verifyStr=tempArray[i][0]+"-"+tempArray[i][1]; //做為判斷其是否為前一頁指定之命令參數辨識
			   MRC_Array[i+addIndex][0]=tempArray[i][0];
			   MRC_Array[i+addIndex][1]=tempArray[i][1];
			   MRC_Array[i+addIndex][2]=tempArray[i][2]; //LINE NO
			   MRC_Array[i+addIndex][3]=tempArray[i][3];
			   MRC_Array[i+addIndex][4]=tempArray[i][4];	   
			   MRC_Array[i+addIndex][5]=tempArray[i][5];
			   MRC_Array[i+addIndex][6]=tempArray[i][6];	
			   MRC_Array[i+addIndex][7]=tempArray[i][7];	
			   MRC_Array[i+addIndex][8]=request.getParameter("DELIVERYQTY-"+lineParam);
			   MRC_Array[i+addIndex][9]=request.getParameter("DELIVERYDATE-"+lineParam);	
			   MRC_Array[i+addIndex][10]=request.getParameter(lineParam+"-COMMENT"); 
			   if (verifyStr.equals(itemName)) //若是前一頁指定之命令參數辨識,則在將sub line加1
			   {		  
				 MRC_Array[i+addIndex][11]=String.valueOf(Integer.parseInt(tempArray[i][11])+1);	 		  
			   }	else {
				 MRC_Array[i+addIndex][11]=tempArray[i][11];
			   } //end of if => verifyStr.equals(itemName)
			   
			   if (lineParam.equals(itemName+"-"+lineNo))
			   {
				  addIndex=1;
				  MRC_Array[i+addIndex][0]=tempArray[i][0];
				  MRC_Array[i+addIndex][1]=tempArray[i][1];
				  MRC_Array[i+addIndex][2]=String.valueOf(Integer.parseInt(tempArray[i][2])+1); //line no
				  MRC_Array[i+addIndex][3]="CHILD";
				  MRC_Array[i+addIndex][4]=tempArray[i][4];	   
				  MRC_Array[i+addIndex][5]=tempArray[i][5];
				  MRC_Array[i+addIndex][6]="↑";	
				  MRC_Array[i+addIndex][7]="↑";	
				  MRC_Array[i+addIndex][8]="";
				  MRC_Array[i+addIndex][9]="";	
				  MRC_Array[i+addIndex][10]=""; 		       
				  MRC_Array[i+addIndex][11]=String.valueOf(Integer.parseInt(tempArray[i][11])+1); //sub line				  	 		  		      
			   } //end of if => lineParam.equals(itemName+"-"+lineNo) 
			} //end of for=>i tempArray.length		  			 		   		 	
	     } //end of if => func.equals("ADD")
		 //+++++++++++++++++++++++++++++++++++++++++++
		 
		 //----------------------若為減少一筆子項---------------------------------
		 if (func.equals("DEL")) 
		 {		 
			int addIndex=0;
			String verifyStr="",lineParam="",thisLine="";		
			MRC_Array=new String[tempArray.length-1][12]; //宣告為符合其總筆數減1筆的大小之陣列
			for (int i=0;i<tempArray.length;i++)
			{		
			   lineParam=tempArray[i][0]+"-"+tempArray[i][1]+"-"+tempArray[i][2]; //做為取得其前一頁之項目辨識字元
			   verifyStr=tempArray[i][0]+"-"+tempArray[i][1]; //做為判斷其是否為前一頁指定之命令參數辨識		
			   thisLine=tempArray[i][2]; //現在這筆的line no   			   
			   if (lineParam.equals(itemName+"-"+lineNo))
			   {
			      addIndex=-1;
				  continue;
			   }
			    
			   MRC_Array[i+addIndex][0]=tempArray[i][0];
			   MRC_Array[i+addIndex][1]=tempArray[i][1];
			   if (Integer.parseInt(thisLine)>Integer.parseInt(lineNo) && verifyStr.equals(itemName)) //如果現在這筆的line no大於被指定要刪除的line no,就將之減1
			   {
			      MRC_Array[i+addIndex][2]=String.valueOf(Integer.parseInt(tempArray[i][2])-1); //LINE NO
			   } else {
			      MRC_Array[i+addIndex][2]=tempArray[i][2]; //LINE NO
			   }	  
			   MRC_Array[i+addIndex][3]=tempArray[i][3];
			   MRC_Array[i+addIndex][4]=tempArray[i][4];	   
			   MRC_Array[i+addIndex][5]=tempArray[i][5];
			   MRC_Array[i+addIndex][6]=tempArray[i][6];	
			   MRC_Array[i+addIndex][7]=tempArray[i][7];	
			   MRC_Array[i+addIndex][8]=request.getParameter("DELIVERYQTY-"+lineParam);
			   MRC_Array[i+addIndex][9]=request.getParameter("DELIVERYDATE-"+lineParam);	
			   MRC_Array[i+addIndex][10]=request.getParameter(lineParam+"-COMMENT");			  		
			   if (verifyStr.equals(itemName)) //若是前一頁指定之命令參數辨識,則在將sub line減1
			   {		  
				 MRC_Array[i+addIndex][11]=String.valueOf(Integer.parseInt(tempArray[i][11])-1);	 		  
			   }	else {
				 MRC_Array[i+addIndex][11]=tempArray[i][11];
			   } //end of if => verifyStr.equals(itemName)	  	   			  
			} //end of for=>i tempArray.length		  			 		   		 	
	     } //end of if => func.equals("ADD")
		 //---------------------------------------------------------		
	  } //end of if=>func!=null		  
	  arrayStoreBean.setArray2DStore(MRC_Array); //將資料寫到bean裏	 
   } //end of if=>option.equals("NEW")     
 } //end of try
 catch (Exception e1)
 {
   %>
     <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
   <%
   out.println("Exception:"+e1.getMessage());
 } 
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Material Request Confirmation Reply Form</title>
</head>
<body>
<FORM METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Material Request Confirmation(<font color="#FF0000">REPLY</font>)</strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;
<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="7%" bgcolor="#0099CC"><font color="#333399" face="Arial Black"><strong>
	  <%
	     if (!isComplete.equals("Y")) //若該筆需求已完成,則不能再回覆了
		 {
           out.println("<input name='Button' type='Button' onClick='submitCheck()' value='Submit'>");
		 } else {
		    out.println("&nbsp;");
		 }  
	  %>	
        </strong></font></td>
      <td width="20%" bgcolor="#0099CC"><font color="#333399" face="Arial Black"><strong>DOCNO:</strong></font><font color="WHITE" size=2><%=docNo%></font> </td>
      <td width="73%" colspan="2" bgcolor="#0099CC">
      <font color="#333399" face="Arial Black"><strong>REMARK:</strong></font>
	  <font color=WHITE size=1><%=remark%></font>	  </td>  	 
	</tr><FONT >	
 </table>
  <HR>
  <%  
 String f_interModel="",f_extModel="",f_color="",hierachy="",f_line="",f_comment="",f_qty="",f_date="",f_subline="";
 String ep_qty="0",ep_qtyTotal="0",ep_date="",f_qtyTotal="0";  
  try
  {    
   String bgColor="ADD8E6";
   MRC_Array=arrayStoreBean.getArray2DStore(); //直接自bean中取得資料  
%>
<script language="JavaScript" type="text/JavaScript">
var field = new Array();
<%
for (int i=0; i<MRC_Array.length; i++) 
{ // 將資料陣到傳到javaScript去
%>
field[<%=i%>] = "<%=MRC_Array[i][0]%>-<%=MRC_Array[i][1]%>-<%=MRC_Array[i][2]%>";
<%
}
%>
</script>
  <TABLE width="903">
    <TR>      
      <TH width="113" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>INTER MODEL</FONT></TH>
      <TH width="64" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>EXT MODEL</FONT></TH>
      <TH width="89" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>COLOR</FONT></TH>
      <TH width="95" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REQUEST Qty.</FONT></TH>
      <TH width="85" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REQUEST DATE </FONT></TH>
      <TH width="105" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>DELIVERY Qty.</FONT></TH>
      <TH width="89" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>DELIVERY DATE </FONT></TH>
      <TH width="227" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>COMMENTS</FONT></TH>
    </TR>
<%    
   for (int ari=0;ari<MRC_Array.length;ari++)  
   {                      
	f_interModel=MRC_Array[ari][0];
	f_color=MRC_Array[ari][1];
	f_line=MRC_Array[ari][2]; 
	hierachy=MRC_Array[ari][3]; //判斷是父項或子項
	f_extModel=MRC_Array[ari][4];		
	ep_qty=MRC_Array[ari][6];	
	ep_date=MRC_Array[ari][7]; 	
	f_qty=MRC_Array[ari][8];	
	f_date=MRC_Array[ari][9]; 		
	f_comment=MRC_Array[ari][10];
	f_subline=MRC_Array[ari][11]; //表示為共有多個少個子項
	
    if (hierachy.equals("PARENT")) //間隔列顏色改換
    {
      bgColor="ADD8E6";
    } else {
      bgColor="B0E0E6";	  
    }  //end of if=>hierachy.equals("PARENT") 
%>
    <TR valign="middle" BGCOLOR=<%=bgColor%>>     
      <TD>
	  <%	  
	  if (hierachy.equals("PARENT"))
	  {
	     out.println("<A href='javaScript:changeItem("+'"'+f_interModel+"-"+f_color+'"'+","+'"'+f_subline+'"'+","+'"'+"ADD"+'"'+")'><img border='0' src='../image/PLUS.gif'></A>");
	  } else {
	     if (f_line.equals(f_subline)) //如果是最後一個sub line則圖形變化為branchend
		 {
	       out.println("&nbsp;<img border='0' src='../image/branchend.gif'>");
		 } else {
		   out.println("&nbsp;<img border='0' src='../image/branch.gif'>");
		 }		 
	     out.println("<A href='javaScript:changeItem("+'"'+f_interModel+"-"+f_color+'"'+","+'"'+f_line+'"'+","+'"'+"DEL"+'"'+")'><img border='0' src='../image/MINUS.gif'></A>");
	  } 
	  out.println(f_interModel);
	  %>
	  </TD>
      <TD><%=f_extModel%></TD>
      <TD><%=f_color%></TD>
      <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=ep_qty%>&nbsp;
	  <%
	     if (hierachy.equals("PARENT"))
	     {
		   out.println("K pcs");
		 }  
	  %>	 
	         </strong></FONT></div></TD>
      <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=ep_date%></strong></FONT></div></TD>
      <TD><input name="DELIVERYQTY-<%=f_interModel%>-<%=f_color%>-<%=f_line%>" type="text" size="3" value='<%=f_qty%>'>&nbsp;K pcs</TD>
      <TD><input name="DELIVERYDATE-<%=f_interModel%>-<%=f_color%>-<%=f_line%>" type="text" size="6" value='<%=f_date%>'><A href='javascript:void(0)' onclick="gfPop.fPopCalendar(document.MYFORM.elements['DELIVERYDATE-<%=f_interModel%>-<%=f_color%>-<%=f_line%>']);return false;"><img border='0' src='../image/calbtn.gif'></A></TD>
      <TD><input name="<%=f_interModel%>-<%=f_color%>-<%=f_line%>-COMMENT" type="text" size="20" maxlength="30" value='<%=f_comment%>'></TD>
    </TR>
    <%	  
	  if (hierachy.equals("PARENT"))
	  {
	    ep_qtyTotal=String.valueOf(Float.parseFloat(ep_qtyTotal)+Float.parseFloat(ep_qty));            		             
	  }  //end of if =>hierachy.equals("PARENT")		  
	  if (!f_qty.equals(""))
	  {
	    f_qtyTotal=String.valueOf(Float.parseFloat(f_qtyTotal)+Float.parseFloat(f_qty));            		             
	  }  //end of if =>hierachy.equals("PARENT")	
   } //end of for =>ari              
  } //end of try
  catch (Exception e2)
  {
   %>
     <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
   <%
   out.println("Exception:"+e2.getMessage());
  }
%>
    <TR>
      <TD colspan="2">&nbsp;</TD>
      <TD bgcolor="#0099CC"><div align="right"><FONT COLOR=WHITE>TOTAL</font></div></TD>
      <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=ep_qtyTotal%>&nbsp;K pcs</strong></font></div></TD>
      <TD BGCOLOR=#0099CC><div align="center"></div></TD>
      <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=f_qtyTotal%>&nbsp;K pcs</strong></font></div></TD>
      <TD BGCOLOR=#0099CC><div align="center"></div></TD>
      <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=LIGHTYELLOW></font></div></TD>      
    </TR>
  </TABLE>
  <HR>
<!-- 表單參數 --> 
<input name="DOCNO" type="HIDDEN" value="<%=docNo%>" >
<input name="REMARK" type="HIDDEN" value="<%=remark%>" >
<input name="ISCOMPLETE" type="HIDDEN" value="<%=isComplete%>" >
<input name="ITEMNAME" type="HIDDEN" value="" >
<input name="LINENO" type="HIDDEN" value="" >
<input name="FUNC" type="HIDDEN" value="" >
<input name="ACTION" type="HIDDEN" value="REPLY" >
</FORM>
<iframe width=80 height=80 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%
  statement.close();	
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
