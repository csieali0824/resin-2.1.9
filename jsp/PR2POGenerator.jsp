<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.Vector,ComboBoxBean,DateBean" %>
<!-- =============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnDominoPage(NOTESAPP).jsp"%>
<!-- include file="/jsp/include/ConnBPCSPoolPage.jsp"%>-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>BPCS PO(Purchase Order) Generator</title>
<style type="text/css">
<!--
.style1 {
	color: #0080C0;
	font-weight: bold;
}
-->
</style>
</head>
<script language="JavaScript" type="text/JavaScript">
function rstart2(){
	showimage.style.visibility = '';
	blockDiv.style.display = '';
	init();
	slide();
	location.href='PR2POConverter.jsp';
}
function setSubmit(URL)
{  
  flag=confirm("確定要轉成PO嗎?"); 
  if (flag==0)
  {
    return(false);
  } else {
    rstart();
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }  
}
function queryVendor()
{ 
  subWin=window.open("subwindow/VendorQrySubWindow.jsp","subwin","width=520,height=400,scrollbars=yes,menubar=no");  
}
</script>
<%
String PRNO=request.getParameter("PRNO");
%>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM ACTION="PR2POConverter.jsp" METHOD="POST" NAME="MYFORM"> 
<A HREF="/wins/WinsMainMenu.jsp">Home</A><BR>
<span class="style1"><FONT SIZE=5>申購單(PR)轉採購通知單(PO)</FONT></span><BR>
<%
String thisDay=dateBean.getYearMonthDay();
//Statement bpcsStat=bpcscon.createStatement();
Statement bpcsStat=ifxTestCon.createStatement();
try
{      
  ResultSet pr2poRs=bpcsStat.executeQuery("select * from PR2PO where pr_no='"+PRNO+"' and trans_flag='Y'");
  if (!pr2poRs.next()) //如果該筆申購單尚未轉換過才進行以下動作
  {
	  Database db=sess_notes.getDatabase(sess_notes.getServerName(),"dbtel_tp/tpepu.nsf"); //取下一層目錄的資料庫其符號為右上左下的斜線"/"
	  View v=(View)db.getView("AllDoc_234");  
	  Document doc=v.getDocumentByKey(PRNO);  
	  if (doc!=null) 
	  {
		  out.println("申購單編號:"+PRNO+"<BR>");
		   try
		   {     	         
			 ResultSet rs=bpcsStat.executeQuery("select TSHIP,TNAME||'('||TSHIP||')' from est where TID='ST' and TCUST=999999 and  length(substr(tship,1,4))=4");
			 comboBoxBean.setRs(rs);	  
			 comboBoxBean.setFieldName("DEPTNO");        
			 out.println("申購部門:"+comboBoxBean.getRsString());
			 rs.close();
		   } //end of try
		   catch (Exception e)
		   {
			out.println("Exception:"+e.getMessage());
		   }
		  out.println("<BR>");
		  
		  //取得決定廠商
		  String vender="";
		  if (doc.getItemValueString("p_Decision1").equals("1"))
		  {
			 out.println("廠商:"+doc.getItemValueString("p_Vender1"));
			 vender="1";
		  }
		  if (doc.getItemValueString("p_Decision2").equals("1"))
		  {
			 out.println("廠商:"+doc.getItemValueString("p_Vender2"));
			 vender="2";
		  }
		  if (doc.getItemValueString("p_Decision3").equals("1"))
		  {
			 out.println("廠商:"+doc.getItemValueString("p_Vender3"));
			 vender="3";
		  }
		  out.println("&nbsp;&nbsp;");
		  out.println("<A HREF='javaScript:queryVendor()'>廠商編號</A>:<INPUT TYPE='TEXT' NAME='VENDORNO' SIZE=6 MAXLENGTH=6>"); 	  
		  
		  String applyType=null,applyTypeName=null,applicant=null,applyDate=null;
		  applyDate=doc.getItemValueString("WM_Created");//取得申購日期
		  applicant=doc.getItemValueString("ApplierName");//取得申購人		
		  applyType=doc.getItemValueString("p_ApplyType");//取得申購類別	  	  
		  if (applyType!=null) //如果有申購類別則取出其中文名稱
		  {
			 Database v1_db=sess_notes.getDatabase(sess_notes.getServerName(),"dbtel_tp/spec_assign.nsf"); //取申購單類別名稱
			 View v1_v=(View)v1_db.getView("TPE-PU-WIN");  
			 Document v1_doc=v1_v.getDocumentByKey(applyType); 
			  if (v1_doc!=null) 
			  {
				applyTypeName=v1_doc.getItemValueString("t_TypeName");//取得申購類別名稱	
			  } //end of if v1_doc!=null
			 v1_doc.recycle();
			 v1_v.recycle();
			 v1_db.recycle(); 
		  }	//end of if =>applyType!=null  
		  out.println("<BR>申購類別:"+applyTypeName);
	  
		  Vector item=doc.getItemValue("p_Item");
		  Vector unit=doc.getItemValue("p_Unit");
		  Vector qnt=doc.getItemValue("p_Qnt");
		  Vector expUPri=doc.getItemValue("p_ExpUPrc");
		  Vector expTotalPri=doc.getItemValue("p_ExpTotalPrc");
		  String curr=doc.getItemValueString("p_Currency");
		  Vector needDate=doc.getItemValue("p_NeedDate");
		  String itemDesc="",dueDate="00000000";
		  int descEnd=0; //表示有多少字元
		  
		  out.println("<TABLE border=1 cellspacing=0>");
		  out.println("<TR BGCOLOR='#C9D8D7'><TH>編號</TH><TH>品名/規格</TH><TH>單位</TH><TH>數量</TH><TH>預估單價</TH><TH>幣別</TH><TH>預估金額</TH><TH>需用日期</TH></TR>");
		  for (int i=0;i<item.size();i++)
		  {
			itemDesc=(String)item.elementAt(i);
			descEnd=itemDesc.length();
			if (descEnd>30) descEnd=30;
			dueDate=(String)needDate.elementAt(i);
			if (Integer.parseInt(dueDate)<Integer.parseInt(thisDay)) dueDate=thisDay; //若原申購單之需用日期早於今天,則需用日期改為今天日期
			out.println("<TR BGCOLOR=WHITE>");
			out.println("<TD><INPUT NAME='LINE-"+i+"' TYPE='HIDDEN' value='"+(i+1)+"'>"+(i+1)+"</TD>"+		            
						"<TD><INPUT TYPE='TEXT' NAME='DESC-"+i+"' value='"+itemDesc.substring(0,descEnd)+"' size=30 maxlength=30></TD>"+
						"<TD>"+(String)unit.elementAt(i)+"</TD>"+
						"<TD><INPUT NAME='QTY-"+i+"' type='HIDDEN' value='"+(String)qnt.elementAt(i)+"'>"+(String)qnt.elementAt(i)+"</TD>"+
						"<TD><INPUT NAME='PRICE-"+i+"' type='HIDDEN' value='"+(String)expUPri.elementAt(i)+"'>"+(String)expUPri.elementAt(i)+"</TD>"+
						"<TD><INPUT NAME='CURR-"+i+"' type='HIDDEN' value='"+curr+"'>"+curr+"</TD><TD>"+(String)expTotalPri.elementAt(i)+"</TD>"+
						"<TD><INPUT NAME='NEEDDATE-"+i+"' type='TEXT' value='"+dueDate+"'></TD>");
			out.println("</TR>");
		  }		 
		  out.println("</TABLE>");	  		  		  
		  out.println("<INPUT TYPE='button' NAME='B1' value='確認產生' onClick='setSubmit("+'"'+"PR2POConverter.jsp"+'"'+")'>");
		  
		  //以下為傳到下頁之隱藏參數
		  out.println("<INPUT NAME='ITEM_TOTAL' TYPE='HIDDEN' value='"+item.size()+"'>"); //共有多少個item
		  out.println("<INPUT NAME='APPLYTYPE' TYPE='HIDDEN' value='"+applyType+"'>"); //申購類別
		  out.println("<INPUT NAME='APPLYTYPENAME' TYPE='HIDDEN' value='"+applyTypeName+"'>"); //申購類別名稱
		  out.println("<INPUT NAME='PRNO' TYPE='HIDDEN' value='"+PRNO+"'>"); //申購單號
		  out.println("<INPUT NAME='APPLICANT' TYPE='HIDDEN' value='"+applicant+"'>"); //申購人
		  out.println("<INPUT NAME='APPLYDATE' TYPE='HIDDEN' value='"+applyDate+"'>"); //申購日期 
	  } else {
		  out.println("找不到該申購單:"+PRNO);
	  } //end of doc!=null if	 
	  v.recycle();
      db.recycle(); 
  } else {
	  out.println("申購單(編號:"+PRNO+") 已經完成資料轉換,請勿重覆作業!");
  } //end of if =>!rs.next()	
  pr2poRs.close();    
} //end of try
catch (NotesException n) 
{  
  out.println("Notes Exception:"+n.getMessage());  
}	 
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());  
} 	
bpcsStat.close();            
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<!-- include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</html>
