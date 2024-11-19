<!-- 20180628 Peggy,add new column =customer group-->
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,DateBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<title>Customer_Relationship_One</title>
<link href='/images/website.css' rel='stylesheet' type='text/css'>
</head>
<script language="javascript" type="text/javascript">
function radioChange(obj)
{
	/*
	var len = document.form1.elements[obj].length;
	for (var i = 0 ; i < len ; i++)
	{
		if (document.form1.elements[obj][i].checked)
		{
			document.form1.elements[obj][i].style.backgroundColor='#fad8a9';
		}
		else
		{
			document.form1.elements[obj][i].style.backgroundColor='#ffffff';
		}
	}
	*/
}

function setSubmit()
{
	for (var i =1 ; i <=10 ; i++)
	{
		if (typeof "Q"+i == 'object')  
		{
			var len = document.form1.elements["Q"+i].length;
			if (len != undefined)
			{
				var checkcnt=0;
				for (var j = 0 ; j < len ; j++)
				{
					if (document.form1.elements["Q"+i][j].checked)
					{
						checkcnt=1;
					}
				}
				//if (checkcnt==0)
				//{
				//	alert("Question "+ i +" information has not correctly or appropriately been filled in, please recheck it again!!");
				//	return false;
				//}
			}
		}
	}
	document.form1.submit(); 
}
</script>
<body  background='images/bkgrnd_greydots.png'>
<form action='<%=request.getRequestURL().toString().substring(0,request.getRequestURL().toString().lastIndexOf("/")+1)%>TSCMailCollectQuestSave.jsp' method='post'  name='form1'>
<%
String id = request.getParameter("id");
if (id == null) id = "";
String reqURL = request.getRequestURL().toString();
if (reqURL != null) reqURL = reqURL.substring(0,reqURL.lastIndexOf("/")+1);
String keycode ="",custid="",name= "", email= "", title= "", department= "", telephone= "", fax= "", company= "", region= "",terrority = "";
boolean bfound = false;
try
{ 
	String Sql = " select rowid,id,name,email,title,department,telephone,fax,company,REGION,TERRORITY,deadline,TO_CHAR(trunc(sysdate),'yyyymmdd') nowdate "+
				 " from ORADDMAN.CUST_MAIL "+
				 " where email is not null and active_flag ='Y' "+
				 //" and substr(CREATION_DATE,1,10) = (select max(substr(CREATION_DATE,1,10)) from ORADDMAN.CUST_MAIL) "+
				 " and id||rowid = '"+id +"'"+
				 " ORDER BY to_number(id) "; 
	//out.println(Sql);
	Statement st = null;
	ResultSet rs = null;
	st = con.createStatement();
	rs = st.executeQuery(Sql);
	if (rs.next())
	{
		out.println("<input type='hidden' name='deadline' value='"+rs.getString("deadline")+"'>");
		if (Long.parseLong(rs.getString("deadline")) >= Long.parseLong(rs.getString("nowdate")))
		{
			keycode=rs.getString("rowid");
			custid = rs.getString("id");
			name= rs.getString("name");
			email= rs.getString("email");
			title= rs.getString("title");
			if (title == null) title="";
			department= rs.getString("department");
			if (department == null) department="";
			telephone= rs.getString("telephone");
			if (telephone == null) telephone="";
			fax= rs.getString("fax");
			if (fax == null) fax="";
			company= rs.getString("company");
			if (company == null) company ="";
			region = rs.getString("REGION");
			if (region == null) region="";
			terrority = rs.getString("TERRORITY");
			if (terrority == null) terrority ="";
			bfound = true;
			if (reqURL.toLowerCase().indexOf("tsrfq.") <0 && reqURL.toLowerCase().indexOf("rfq134.") <0) //測試環境
			{
				email ="peggy.chen@ts.com.tw";
			}
		}
		else
		{
%>
			<Script language="JavaScript">
				alert("The customer questionnaire end on "+document.form1.deadline.value+" and thanks for your cooperation!!");
				location.replace('http://www.taiwansemi.com/');  
			</Script>
<%
		}
	}
	else
	{
%>
	<Script language="JavaScript">
		alert("Sorry!The id is invalid!!");
		location.replace('http://www.taiwansemi.com/');  
	</Script>
<%
	}
}
catch(Exception e)
{ 
	out.println(e.toString()); 
}
%>
<table width='850' border='0' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#FFFFFF' >
<%
try
{
	String sql1 = "select QUEST_CODE,QUESTION,NVL(case (select b.language_version from oraddman.cust_mail b where b.id||b.rowid='"+id+"')  WHEN 'TRADITIONAL CHINESE' THEN TRADITIONAL_CHINESE WHEN 'SIMPLIFIED CHINESE' THEN SIMPLIFIED_CHINESE WHEN 'KOREAN' THEN KOREAN WHEN 'JAPANESE' THEN JAPANESE ELSE  '' END,'') AS LOCAL_LANG_QUESTION  "+
                 " ,NVL((select case WHEN a.QUEST_CODE ='Q1' THEN Q1 "+
                 " WHEN a.QUEST_CODE ='Q2' THEN Q2 "+
                 " WHEN a.QUEST_CODE ='Q3' THEN Q3 "+
                 " WHEN a.QUEST_CODE ='Q4' THEN Q4 "+
                 " WHEN a.QUEST_CODE ='Q5' THEN Q5 "+
                 " WHEN a.QUEST_CODE ='Q6' THEN Q6 "+
                 " WHEN a.QUEST_CODE ='Q7' THEN Q7 "+
                 " WHEN a.QUEST_CODE ='Q8' THEN Q8 "+
                 " WHEN a.QUEST_CODE ='Q9' THEN Q9 "+
                 " WHEN a.QUEST_CODE ='Q10' THEN Q10 "+
                 " WHEN a.QUEST_CODE ='Q11' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q11)"+
                 " WHEN a.QUEST_CODE ='Q12' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q12)"+
                 " WHEN a.QUEST_CODE ='Q13' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q13)"+
                 " WHEN a.QUEST_CODE ='Q14' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q14)"+
                 " WHEN a.QUEST_CODE ='Q15' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q15) END "+
                 " from oraddman.cust_collect_questionnaire c where customer_id='"+custid+"'  and exists (select 1 from oraddman.cust_mail x "+
                 " WHERE x.id || x.ROWID = '"+id+"' and x.year = c.year and x.BIANNUAL_CODE= c.BIANNUAL_CODE)),0) AS SCORE_LEVEL,OBJ_TYPE,FONT_SIZE,ALIGN_TYPE,FONT_STYLE"+
                 " from oraddman.cust_quest_define a "+
				 " where a.quest_id <1000"+
				 " and ((a.QUESTION_TYPE in ('QUESTION','COMMENT') and exists (select 1 from oraddman.cust_questionnaire_type cqt,oraddman.cust_mail cm"+ //add by Peggy 20180628 start
                 " where cqt.customer_group=nvl(cm.customer_group ,'ALL')"+
                 " and cm.id || cm.ROWID = '"+id+"'"+
                 " and cqt.QUEST_CODE=a.QUEST_CODE)) or a.QUESTION_TYPE is null)"+  //add by Peggy 20180628 end
				 " order by CASE WHEN quest_id<900 THEN TO_NUMBER(QUEST_ID) *1000 ELSE TO_NUMBER(QUEST_ID) END";			  
	//out.println(sql1);
	Statement st1 = con.createStatement();
	ResultSet rs1 = st1.executeQuery(sql1);
	String strbgcolor = "",strFontSize="",strAlign="",strFontStyle="",strQuestion="",strLocalQuestion="",strCode="";
	int seqno=0;
	int k=0;
	while(rs1.next())
	{
		strCode=rs1.getString("QUEST_CODE");strFontSize=rs1.getString("FONT_SIZE");strAlign=rs1.getString("ALIGN_TYPE");strFontStyle=rs1.getString("FONT_STYLE");strQuestion=rs1.getString("QUESTION");strLocalQuestion=rs1.getString("LOCAL_LANG_QUESTION");
		if (strFontSize==null) strFontSize="12";
		if (strAlign==null) strAlign="left";
		if (strFontStyle==null) strFontStyle = "arial";
		if (strQuestion==null) strQuestion="";
		if (strLocalQuestion ==null) strLocalQuestion = "";
		if (strCode.startsWith("A"))
		{
			if (strCode.equals("A0"))
			{
				//if (strLocalQuestion.equals("")) strLocalQuestion=strQuestion;
				//out.println("<tr><TD style='PADDING-BOTTOM: 10px; LINE-HEIGHT: 20px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; COLOR: #000; PADDING-TOP: 10px;font-family:"+strFontStyle+";font-size:"+strFontSize+"px' bgColor=#e7e7e7 width=783 align="+strAlign+">※"+strLocalQuestion.replace("?01","<A style='COLOR: #000; FONT-WEIGHT: bold; TEXT-DECORATION: underline' href='"+reqURL+"TscMailCollectQuestReply.jsp?id="+id+"' target=_blank>").replace("?02","</A>")+"</td></tr><tr><td>&nbsp;</td></tr>");
			}
			else
			{
				out.println("<tr><td height='28' bgcolor='#FFFFFF'>");
				if (strCode.equals("A1")) out.println("<table><tr><td valign='top'><img src='http://tsrfq.ts.com.tw:8080/oradds/jsp/images/logo.PNG' width='150' height='55'></td><td>");
				out.println("<div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+"<p>"+((strLocalQuestion.equals("") && strCode.equals("A1"))?"&nbsp;":strLocalQuestion)+"<p></div></td></tr>");
				if (strCode.equals("A1")) out.println("</td></tr></TABLE>");
			}
		}
		else if (strCode.startsWith("B"))
		{
			out.println("<tr><td height='28' bgcolor='#FFFFFF'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>(<font style='color:#FF0000;font-size:"+strFontSize+";font-weight: bold'>*</font> "+strQuestion+" "+strLocalQuestion+")</div></td></tr>");
		}
		else if (strCode.startsWith("C"))
		{
			if (strCode.equals("C1"))
			{
				if (strQuestion.startsWith("Company"))
				{
					out.println("<tr><td><table width='100%' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#999999'>");
					out.println("<tr><td colspan='2' height='35' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'><font style='color:#FF0000;font-size:"+strFontSize+";font-weight:bold'>*</font>"+strQuestion+" "+strLocalQuestion+"</div></td>");
					out.println("<td colspan='4'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(company.equals("")?"&nbsp;":company)+"</div></td></tr>");
				}
			}
			else if (strCode.equals("C2"))
			{
				if (strQuestion.equals("Name"))
				{
					out.println("<tr><td width='15%' height='35' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'><font style='color:#FF0000;font-size:"+strFontSize+";font-weight: bold'>*</font>"+strQuestion+" "+strLocalQuestion+"</div></td>");
					out.println("<td width='18%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(name.equals("")?"&nbsp;":name)+"</div></td>");
				}
				else if (strQuestion.equals("Department"))
				{
					out.println("<td width='15%' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&nbsp;"+strQuestion+" "+strLocalQuestion+"</div></td>");
					out.println("<td width='18%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(department.equals("")?"&nbsp;":department)+"</div></td>");
				}
				else if (strQuestion.equals("Title"))
				{
					out.println("<td width='15%' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&nbsp;"+strQuestion+" "+strLocalQuestion+"</div></td>");
					out.println("<td width='18%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(title.equals("")?"&nbsp;":title)+"</div></td></tr>");
				}
			}
			else if (strCode.equals("C3"))
			{
				if (strQuestion.equals("Telephone"))
				{
					out.println("<tr><td height='35' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&nbsp;"+strQuestion+" "+strLocalQuestion+"</div></td>");
					out.println("<td><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(telephone.equals("")?"&nbsp;":telephone)+"</div></td>");
				}
				else if (strQuestion.equals("Fax"))
				{
					out.println("<td bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&nbsp;"+strQuestion+" "+strLocalQuestion+"</div></td>");
					out.println("<td><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(fax.equals("")?"&nbsp;":fax)+"</div></td>");
				}
				else if (strQuestion.equals("E-mail"))
				{
					out.println("<td bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'><font style='color:#FF0000;font-size:"+strFontSize+";font-weight: bold'>*</font>"+strQuestion+" "+strLocalQuestion+"</div></td>");
					out.println("<td><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(email.equals("")?"&nbsp;":email)+"</div></td></tr></table></td></tr>");
				}
			}
		}
		else if (strCode.startsWith("Q"))
		{
			if (seqno==0)
			{
				out.println("<tr><td><table width='100%' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#999999'>");
			}
			if (strCode.equals("Q01"))
			{
				out.println("<tr bgcolor='#CCFFCC'><td width='5%' height='45'><div align='center'  style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>No</div></td>");
				out.println("<td width='47%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+" "+strLocalQuestion+"</div></td>");
			}
			else if (strCode.equals("Q02"))
			{
				out.println("<td colspan='5'><table width='100%' border='0'><tr><td width='45%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&larr;"+strQuestion+" "+strLocalQuestion+"</div></td>");
			}
			else if (strCode.equals("Q03"))
			{
				out.println("<td><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+" "+strLocalQuestion+"&rarr;</div></td></tr></table></td></tr>");
			}
			else	
			{
				k++;
				if ((k % 2)==1)
				{
					strbgcolor="#FFFFFF";
				}
				else
				{
					strbgcolor="#EEFAFF";
				}
			
				out.println("<tr bgcolor='"+strbgcolor+"'><td height='60' width='30'><div align='center' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+k+"</div></td>");
				out.println("<td width='470'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+"<br>"+strLocalQuestion+"</div></td>");
				if (rs1.getString("obj_type").toLowerCase().equals("radio"))
				{
					for(int i=5 ; i>0 ;i--)
					{ 
						if (i!=Integer.parseInt(rs1.getString("SCORE_LEVEL")))
						{ 
							//out.println("<td width='50'><div align='center' style='font-family:arial;font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+i+"<input type='radio' name='Q"+k+"' value='"+i+"' onClick='radioChange("+'"'+"Q"+k+'"'+")' ></div></td>"); 
							out.println("<td width='50'><div align='center' style='font-family:arial;font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+i+"<input type='radio' name='"+strCode+"' value='"+i+"' onClick='radioChange("+'"'+strCode+'"'+")' ></div></td>"); 
						}
						else
						{	
							//out.println("<td width='50'><div align='center' style='font-family:arial;font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+i+"<input type='radio' name='Q"+k+"' value='"+i+"' onClick='radioChange("+'"'+"Q"+k+'"'+")' checked></div></td>");
							out.println("<td width='50'><div align='center' style='font-family:arial;font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+i+"<input type='radio' name='"+strCode+"' value='"+i+"' onClick='radioChange("+'"'+strCode+'"'+")' checked></div></td>");
						}
					}
				}
				else if (rs1.getString("obj_type").toLowerCase().equals("textarea"))
				{
					out.println("<td colspan='5'><textarea name='comment' cols='40' rows='4' id='comment'>"+(rs1.getString("SCORE_LEVEL")==null||rs1.getString("SCORE_LEVEL").equals("0")?"":rs1.getString("SCORE_LEVEL"))+"</textarea></td>");
				}
				out.println("</tr>");
			}
			seqno ++;
		}
	}
	if (seqno >0) out.println("</table></td></tr>");
	if (bfound)
	{
		out.println("<tr bgcolor='FFFFFF'> <td colspan='8'><div align='right'><input name='Submit'  type='button' id='Submit' value='submit' onClick='setSubmit()'></div></td></tr>");
	}
	rs1.close();
	st1.close();
}
catch (Exception e)
{
	System.out.println(e.toString());
}
%>
</table>
<input type='hidden' name='keycode' value='<%=keycode%>'>
<input type='hidden' name='custid' value='<%=custid%>'>
</form>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
