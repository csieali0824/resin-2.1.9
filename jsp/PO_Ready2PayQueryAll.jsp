<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsCountBean"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnDominoPage(NOTESAPP).jsp"%>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<title>Query All BPCS PO those are ready to pay </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
function setSubmit(ch,URL)
{     
   var pass="N";
   if (ch.length!=null)
   {
	   for (j=0;j<ch.length;j++)
	   {
		  if (ch[j].checked==true)
		  {
			pass="Y";
			break;
		  }
	   }   
   } else {
     if (ch.checked==true)  pass="Y";
   }
     
   if (pass!="Y")  //若沒有任何資料則不能存檔
   {
       alert("您尚未選取任何資料!!");   
       return(false);
   }

  flag=confirm("確定要將所選取的PO列印出『黏存單/支出單』?"); 
  if (flag==0)
  {
    return(false);
  } else {   
    //以下為檢查是否已填入應填寫之欄位^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	if (ch.length!=null)
      {
		   for (i=0;i<ch.length;i++)
		   {          
			   if (ch[i].checked==true)  	      
			   {
					 if (document.MYFORM.elements["INVNO-"+ch[i].value].value=="" || document.MYFORM.elements["INVNO-"+ch[i].value].value==null)
					 { 
					   alert("請務必先填寫發票號碼 !!");   
					   return(false);
					 }	            
			   } //end of if  ch[i].checked==true 
		   } //end of for null check */ 
	   } else {
	        if (ch.checked==true)  	      
			   {
					 if (document.MYFORM.elements["INVNO-"+ch.value].value=="" || document.MYFORM.elements["INVNO-"+ch.value].value==null)
					 { 
					   alert("請務必先填寫發票號碼 !!");   
					   return(false);
					 }	            
			   } //end of if  ch[i].checked==true	   
	   }	
  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }  
}
function prDetail(prURL)
{ 
  subWin=window.open(prURL,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
}
</script>
<body>
<%
String searchString=request.getParameter("SEARCHSTRING"); 
%>
<FORM ACTION="PO_Ready2PayQueryAll.jsp" METHOD="POST" NAME="MYFORM"> 
<A HREF="/wins/WinsMainMenu.jsp">Home</A><BR> 
<strong><font color="#004080" size="4">待請款之採購通知單(PO)</font></strong>
<table width="91%" border="1">
<tr>
<td width="41%"><font size=2>PR/PO號碼,廠商編號,廠商名稱:</font>
  <INPUT type="text" name="SEARCHSTRING" size=10 <%if (searchString!=null) out.println("value="+searchString);%>></td>
<td width="15%"><INPUT name="button" TYPE="submit"  value="Query" ></td>
<td width="44%"><INPUT name="button2" TYPE="button"  onClick='setSubmit(document.MYFORM.CH,"PO_PayConverter.jsp")' value="列印『黏存單/支出單』"> </td>
</tr>
</table> 
<%
String sSql="";
int maxrow=0;
String poArray[][]=null; //做為存pr2po資訊的陣列
Statement bpcsStat=ifxTestCon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
ResultSet rs=null;
try
{     
    Database db=sess_notes.getDatabase(sess_notes.getServerName(),"dbtel_tp/tpepu.nsf"); //取下一層目錄的資料庫其符號為右上左下的斜線"/"
    View v=(View)db.getView("AllDoc_234");  
	Document doc=null; 

   //sSql="select unique substr(c.VNDNAM,1,10)||'...('||VENDORCODE||')' as vendorname,vendorcode,b.TNAME||'('||SHIPTOCODE||')' as shiptoname,PO_NO,PR_LINE,PR_NO,PR_APPLYTYPENAME,substr(ITEMDESCRIPTION,1,30) as itemdesc,unitcost,currency from PR2PO a,EST b,AVM c"+
   //     " where SHIPTOCODE=b.TSHIP and VENDORCODE=c.VENDOR and RECEIVED_FLAG='Y' and PAID_FLAG!='Y'"; //只取出已收料但尚未請款之資料		
   sSql="select  c.VNDNAM,VENDORCODE,b.TNAME,SHIPTOCODE,PO_NO,PR_NO,COUNT(PO_NO) as po_count from PR2PO a,EST b,AVM c"+ 
        " where SHIPTOCODE=b.TSHIP and VENDORCODE=c.VENDOR and RECEIVED_FLAG='Y' and PAID_FLAG!='Y'";//只取出已收料但尚未請款之資料	
   if (UserRoles.indexOf("admin")<0) //若角色不是admin,則只能看到屬於自己轉換過的PO
   {
      sSql=sSql+" and USER_MAIL='"+userMail+"'";
   }		
   
   if (searchString!=null && !searchString.equals(""))
   {
     sSql=sSql+" and (PR_NO like '"+searchString+"%' or substr(PO_NO,1) like '"+searchString+"%' or VNDNAM like '"+searchString+"%' or substr(VENDORCODE,1) like '"+searchString+"%')";
   }		
   //sSql=sSql+" ORDER BY VENDORCODE,PO_NO,PR_LINE";
   sSql=sSql+" GROUP BY  VNDNAM,vendorcode,TNAME,SHIPTOCODE,PO_NO,PR_NO ORDER BY VENDORCODE,PO_NO";
   rs=bpcsStat.executeQuery(sSql);    
   
   rsCountBean.setRs(rs); 
   maxrow=rsCountBean.getRsCount(); 
   
   poArray=new String[maxrow][7];  
   int poi=0;
%>
<TABLE width="91%" border="1" cellspacing="0">
  <tr bgcolor="#66CCCC">
    <td width="3%"><font size="2"><input name="checkselect" type=checkbox onClick="this.value=check(this.form.CH)" title="選取或取消選取"></font></td>
	<td width="3%"><font size="2">&nbsp;&nbsp;</font></td>
    <td width="21%"><strong><font size="2">廠商</font></strong></td>
    <td width="14%"><strong><font size="2">費用部門</font></strong></td>
	<td width="9%"><strong><font size="2">發票號碼</font></strong></td>
	<td width="6%"><strong><font size="2">PO號碼</font></strong></td>	
	<td width="25%"><strong><font size="2">申購項目</font></strong></td>
	<td width="8%"><strong><font size="2">申購金額</font></strong></td>
	<td width="6%"><strong><font size="2">營業稅</font></strong></td>	
	<td width="5%"><strong><font size="2">幣別</font></strong></td>	
  </tr>	
<%   
  
   while (rs.next()) 
   {
     poArray[poi][0]=rs.getString("PO_NO");
	 poArray[poi][1]=rs.getString("PR_NO");	
	 poArray[poi][2]=rs.getString("po_count");		  
	 poArray[poi][3]=rs.getString("VNDNAM").substring(0,10)+"...";
	 poArray[poi][4]=rs.getString("VENDORCODE");
	 poArray[poi][5]=rs.getString("TNAME");
	 poArray[poi][6]=rs.getString("SHIPTOCODE");
     poi++;
   } //end of while =>rs.next()    
   rs.close();   
   
   for (int i=0;i<poArray.length;i++)
   {     
     doc=v.getDocumentByKey(poArray[i][1]); //PR號碼
	  if (doc!=null) 
	  {
	     String docID=doc.getUniversalID();
	     String docUrl="http://"+dominoConn.getServerName()+"/dbtel_tp/tpepu.nsf/w_viwSample/"+docID+"?OpenDocument";		 
		 sSql="select PO_NO,PR_LINE,substr(ITEMDESCRIPTION,1,30) as itemdesc,unitcost,currency from PR2PO"+
              " where PO_NO="+poArray[i][0]+" order by PR_LINE"; 
 	     rs=bpcsStat.executeQuery(sSql); 
		 
		  rsCountBean.setRs(rs); 
          maxrow=rsCountBean.getRsCount(); 		 
		 
		 String subPOArray[][]=new String[Integer.parseInt( poArray[i][2])][4];
		 int sub_i=0;
		 while (rs.next())
		 {
		   subPOArray[sub_i][0]=rs.getString("PR_LINE");
		   subPOArray[sub_i][1]=rs.getString("itemdesc");
		   subPOArray[sub_i][2]=rs.getString("unitcost");
		   subPOArray[sub_i][3]=rs.getString("currency");
		   sub_i++; 
		 }
		 rs.close();
		 
%>
    <tr >
    <td rowspan=<%=poArray[i][2]%>><font size="2"><INPUT TYPE=checkbox NAME='CH' value='<%=poArray[i][0]%>'></font></td>
    <td rowspan=<%=poArray[i][2]%>><font size="2"><A href='javaScript:prDetail("<%=docUrl%>")'><img src='../image/docicon.gif'></A></font></td>
    <td rowspan=<%=poArray[i][2]%>><font size="2"><%=poArray[i][3]%>(<%=poArray[i][4]%>)</font></td>
	<td rowspan=<%=poArray[i][2]%>><font size="2"><%=poArray[i][5]%>(<%=poArray[i][6]%>)</font></td>
	<td rowspan=<%=poArray[i][2]%>><font size="2"><INPUT TYPE=text NAME='INVNO-<%=poArray[i][0]%>' size=10 maxlength="10"></font></td>
	<td rowspan=<%=poArray[i][2]%>><font size="2"><%=poArray[i][0]%></font></td>	
	<td><div><font size="2"><%=subPOArray[0][1]%></font></div></td>
	<td ><div align="right"><font size="2"><%=subPOArray[0][2]%></font></div></td>
	<td ></div><font size="2"><INPUT TYPE=text NAME='TAX-<%=poArray[i][0]%>-<%=subPOArray[0][0]%>' size=6 maxlength="6"></font></div></td>
	<td ></div><font size="2"><%=subPOArray[0][3]%></font></div></td>
	</tr>	
<%
          for (int j=1;j<subPOArray.length;j++)
		  {
%>	
    <tr>
	<td><div><font size="2"><%=subPOArray[j][1]%></font></div></td>
	<td ><div align="right"><font size="2"><%=subPOArray[j][2]%></font></div></td>
	<td ></div><font size="2"><INPUT TYPE=text NAME='<%=poArray[i][0]%>-<%=subPOArray[j][0]%>' size=6 maxlength="6"></font></div></td>
	<td ></div><font size="2"><%=subPOArray[j][3]%></font></div></td>		
	</tr>
<%
          }       
      } //end of if->doc!=null  
   } //end of for loop          
   if (doc!=null) doc.recycle();
   v.recycle();
   db.recycle(); 
} //end of try
catch (Exception ec)
{
   out.println("Exception:"+ec.getMessage());
   %>
     <%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%> 
   <%
}
bpcsStat.close();
%>	 	
</TABLE>	
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>


