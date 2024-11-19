<!-- 20180628 Peggy,add new column =customer group-->
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<title>Customer_Relationship_One</title>
<link href='/images/website.css' rel='stylesheet' type='text/css'>
</head>
<script language="javascript" type="text/javascript">
function setSubmit()
{
	document.form1.stype.value="save";
	document.form1.submit();
}
function setSubmit1()
{
	window.close(); 
}
function setSubmit2()
{
	document.form1.stype.value="confirm";
	document.form1.submit();
}
function setAttache(URL)
{
	subWin=window.open(URL,"subwin","width=740,height=250,scrollbars=yes,menubar=no,location=no");
}
function delAttache(URL)
{
	if (confirm("Are you sure to delete file?"))
	{
		document.form1.action=URL;
		document.form1.submit();
	}
	return false;
}
</script>
<body  background='images/bkgrnd_greydots.png'>
<form action='<%=request.getRequestURL().toString().substring(0,request.getRequestURL().toString().lastIndexOf("/")+1)%>TscMailQuestTraceabilityReply.jsp' method='post'  name='form1'>
<%
String id = request.getParameter("id");
if (id==null) id = "";
String stype= request.getParameter("stype");
if (stype==null) stype="";
String keycode= request.getParameter("keycode");
if (keycode==null) keycode="";
String custid = request.getParameter("custid");
if (custid==null) custid="";
String syear = request.getParameter("syear");
if (syear==null) syear="";
String biannual_code = request.getParameter("biannual_code");
if (biannual_code==null) biannual_code="";
String ACTIONCODE= request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="Submit";
String FILENAME = request.getParameter("FILENAME");
if (FILENAME==null) FILENAME ="";
String reqURL = request.getRequestURL().toString();
if (reqURL != null) reqURL = reqURL.substring(0,reqURL.lastIndexOf("/")+1);
String sql="", name= "", email= "", title= "", department= "", telephone= "", fax= "", company= "", region= "",terrority = "",sales_deadline_date="",trace_deadline_date="",str_value="",column_name="";
boolean bfound = false;
int col=7, screen_width=2000,input_cnt=0;

try
{ 
	if (stype.equals("save"))
	{
		try
		{
			sql = " update oraddman.cust_collect_questionnaire a"+
				  " set a.followup_reply_date=sysdate"+
				  " where customer_id=?"+
				  " and year=?"+
				  " and biannual_code=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,custid);
			pstmtDt.setString(2,syear);
			pstmtDt.setString(3,biannual_code);
			pstmtDt.executeQuery();
			pstmtDt.close();
					
			sql = " select a.quest_code,a.obj_type from oraddman.cust_quest_define a"+
				  " where a.quest_code like 'Q%'"+
				  " and a.quest_code not like 'Q0%'"+
				  " order by a.quest_code";
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery(sql);
			while (rs.next())
			{
				if (rs.getString("obj_type").toLowerCase().equals("textarea"))
				{
					column_name = "comment";
				}
				else
				{
					column_name = rs.getString("quest_code");
				}
				sql = " select 1 from  oraddman.cust_questionnaire_trace a"+
					  " where a.customer_id=?"+
					  " and a.year=?"+
					  " and a.biannual_code=?"+
					  " and a.question_no=?";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,custid);
				st1.setString(2,syear);
				st1.setString(3,biannual_code);
				st1.setString(4,column_name);
				ResultSet rs1 = st1.executeQuery();
				if (rs1.next())
				{
					String [] reply_str = new String[col];
					input_cnt =0;
					for (int j = 1 ; j <=col ; j++)
					{
						str_value=request.getParameter("textarea"+j+"_"+rs.getString("quest_code"));
						if (str_value!=null && !str_value.equals(""))
						{
							input_cnt ++;
							reply_str[j-1]=str_value;
						}
					}
					if (input_cnt>0)
					{
						sql = " update oraddman.cust_questionnaire_trace a"+
							  " set question_what=?"+
							  ",question_where=?"+
							  ",question_who=?"+
							  ",question_when=?"+
							  ",question_why=?"+
							  ",question_solution=?"+
							  ",question_result=?"+
							  ",attachment_id=?"+
							  ",last_update_date=sysdate"+
							  ",remote_addr=?"+
							  " where customer_id=?"+
							  " and year=?"+
							  " and biannual_code=?"+
							  " and question_no=?";
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,reply_str[0]);
						pstmtDt.setString(2,reply_str[1]);
						pstmtDt.setString(3,reply_str[2]);
						pstmtDt.setString(4,reply_str[3]); 
						pstmtDt.setString(5,reply_str[4]); 
						pstmtDt.setString(6,reply_str[5]); 
						pstmtDt.setString(7,reply_str[6]);  
						pstmtDt.setString(8,"");
						pstmtDt.setString(9,request.getRemoteAddr());
						pstmtDt.setString(10,custid);
						pstmtDt.setString(11,syear);
						pstmtDt.setString(12,biannual_code);
						pstmtDt.setString(13,column_name);					
						pstmtDt.executeQuery();
						pstmtDt.close();						  
					}
				}
				else
				{
					String [] reply_str = new String[col];
					input_cnt =0;
					for (int j = 1 ; j <=col ; j++)
					{
						//out.println("textarea"+j+"_"+rs.getString("quest_code"));
						str_value=request.getParameter("textarea"+j+"_"+rs.getString("quest_code"));
						//out.println(str_value);
						if (str_value!=null && !str_value.equals(""))
						{
							input_cnt ++;
							reply_str[j-1]=str_value;
						}
					}
					if (input_cnt>0)
					{				
						sql = " insert into oraddman.cust_questionnaire_trace a"+
							  "(customer_id"+
							  ",year"+
							  ",biannual_code"+
							  ",question_no"+
							  ",question_what"+
							  ",question_where"+
							  ",question_who"+
							  ",question_when"+
							  ",question_why"+
							  ",question_solution"+
							  ",question_result"+
							  ",attachment_id"+
							  ",last_update_date"+
							  ",remote_addr)"+
							  " values"+
							  "(?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",sysdate"+
							  ",?)";
						pstmtDt=con.prepareStatement(sql);  
						pstmtDt.setString(1,custid);
						pstmtDt.setString(2,syear);
						pstmtDt.setString(3,biannual_code);
						pstmtDt.setString(4,column_name);					
						pstmtDt.setString(5,reply_str[0]);
						pstmtDt.setString(6,reply_str[1]);
						pstmtDt.setString(7,reply_str[2]);
						pstmtDt.setString(8,reply_str[3]); 
						pstmtDt.setString(9,reply_str[4]); 
						pstmtDt.setString(10,reply_str[5]); 
						pstmtDt.setString(11,reply_str[6]);  
						pstmtDt.setString(12,"");
						pstmtDt.setString(13,request.getRemoteAddr());
						pstmtDt.executeQuery();
						pstmtDt.close();	
					}							  
				}
				rs1.close();
				st1.close();	
			}
			rs.close();
			st.close();	
			con.commit();
			%>
			
			<Script language="JavaScript">
				alert("Save successfully!!");
				location.replace('http://www.taiwansemi.com/');  
			</Script>	
			
			<%		
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("The data write fail!!"+e.getMessage());
		}	  
	}
	else if (stype.equals("confirm"))
	{
		try
		{	
			sql = " update oraddman.cust_collect_questionnaire a"+
				  " set a.followup_closed_date=sysdate"+
                  ",a.followup_closed_by=?"+
				  " where customer_id=?"+
				  " and year=?"+
				  " and biannual_code=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,session.getAttribute("USERNAME").toString());
			pstmtDt.setString(2,custid);
			pstmtDt.setString(3,syear);
			pstmtDt.setString(4,biannual_code);
			pstmtDt.executeQuery();
			pstmtDt.close();
			con.commit();
			%>
			
			<Script language="JavaScript">
				alert("Follow up closed!!");
				setSubmit1();
				window.opener.document.MYFORM.action="../jsp/TSCMailCollectQuestReport.jsp";
				window.opener.document.MYFORM.submit();
			</Script>	
			
			<%		
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("The close cation fail!!"+e.getMessage());
		}			
	}
	
	sql = " select rowid,id,name,email,title,department,telephone,fax,company,REGION,TERRORITY,deadline,trunc(add_months(to_date(deadline,'yyyymmdd'),1)) nowdate "+
				 ",to_char(add_months(to_date(deadline,'yyyymmdd'),1),'yyyy/mm/dd') sales_deadline"+
				 ",to_char(to_date(deadline,'yyyymmdd')+60,'Month', 'nls_date_language=American') trace_deadline,year,biannual_code"+
				 " from ORADDMAN.CUST_MAIL "+
				 " where email is not null"+
				 " and active_flag ='Y' "+
				 //" and substr(CREATION_DATE,1,10) = (select max(substr(CREATION_DATE,1,10)) from ORADDMAN.CUST_MAIL) "+
				 " and id||rowid = '"+id +"'"+
				 " ORDER BY to_number(id) "; 
	//out.println(Sql);
	Statement st = null;
	ResultSet rs = null;
	st = con.createStatement();
	rs = st.executeQuery(sql);
	if (rs.next())
	{
		out.println("<input type='hidden' name='deadline' value='"+rs.getString("deadline")+"'>");
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
		sales_deadline_date = rs.getString("sales_deadline");
		trace_deadline_date = rs.getString("trace_deadline");	
		if (stype.equals("*")) bfound = true;
		if (reqURL.toLowerCase().indexOf("tsrfq.") <0 && reqURL.toLowerCase().indexOf("rfq134.") <0) //測試環境
		{
			email ="peggy.chen@ts.com.tw";
		}
		syear=rs.getString("year");
		biannual_code=rs.getString("biannual_code");
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
	out.println("<font color='red'>Error message~"+e.toString()+"</font>"); 
}
%>
<table width="<%=screen_width%>" border="0" align="center" cellpadding="1" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#FFFFFF">
<%
try
{
	String sql1 =" SELECT QUEST_CODE,QUESTION,NVL(case (select b.language_version from oraddman.cust_mail b where b.id||b.rowid='"+id+"')  WHEN 'TRADITIONAL CHINESE' THEN TRADITIONAL_CHINESE WHEN 'SIMPLIFIED CHINESE' THEN SIMPLIFIED_CHINESE WHEN 'KOREAN' THEN KOREAN WHEN 'JAPANESE' THEN JAPANESE ELSE  '' END,'') AS LOCAL_LANG_QUESTION  "+
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
                 " from oraddman.cust_collect_questionnaire c "+
				 " where customer_id='"+custid+"' "+
				 " and exists (select 1 from oraddman.cust_mail x "+
                 "             where x.id || x.ROWID = '"+id+"'"+
				 "             and x.year = c.year"+
				 "             and x.BIANNUAL_CODE= c.BIANNUAL_CODE)),0) AS SCORE_LEVEL"+
				 " ,OBJ_TYPE"+
				 " ,FONT_SIZE"+
				 " ,ALIGN_TYPE"+
				 " ,FONT_STYLE"+
				 " ,b.*"+
                 " from oraddman.cust_quest_define a"+
				 " ,(select QUESTION_NO,question_what qu1, question_where qu2, question_who qu3, question_when qu4, question_why qu5, question_solution qu6, question_result qu7, attachment_id, last_update_date, remote_addr from oraddman.cust_questionnaire_trace where customer_id='"+custid+"' and year='"+syear+"' and biannual_code='"+biannual_code+"') b"+
                 " WHERE SUBSTR(a.QUEST_CODE,1,1) NOT IN ('A','B') "+
                 " AND SUBSTR(a.QUEST_CODE,1,2) NOT IN ('Q0') "+
				 " AND NVL(a.AUDIT_HIDE_FLAG,'N')='N'"+ //add by Peggy 20180530
				 //" AND a.QUEST_CODE = b.QUESTION_NO(+)"+
				 " AND DECODE( a.OBJ_TYPE,'textarea', 'comment',a.QUEST_CODE) = b.QUESTION_NO(+)"+ 
				 " AND ((a.QUESTION_TYPE in ('QUESTION','COMMENT') and exists (select 1 from oraddman.cust_questionnaire_type cqt,oraddman.cust_mail cm"+ //add by Peggy 20180628 start
                 " where cqt.customer_group=nvl(cm.customer_group ,'ALL')"+
                 " and cm.id || cm.ROWID = '"+id+"'"+
                 " and cqt.QUEST_CODE=a.QUEST_CODE)) or a.QUESTION_TYPE is null)"+  //add by Peggy 20180628 end					 
                 " ORDER BY DECODE(SUBSTR(a.QUEST_CODE,1,1),'X',1,'C',2,3),TO_NUMBER(a.QUEST_ID) ";		  
	//out.println(sql1);
	Statement st1 = con.createStatement();
	ResultSet rs1 = st1.executeQuery(sql1);
	String strbgcolor = "",strFontSize="",strAlign="",strFontStyle="",strQuestion="",strLocalQuestion="",strCode="";
	int seqno=0;
	int k=0;
	while(rs1.next())
	{
		strCode=rs1.getString("QUEST_CODE");
		strFontSize=rs1.getString("FONT_SIZE");
		strAlign=rs1.getString("ALIGN_TYPE");
		strFontStyle=rs1.getString("FONT_STYLE");
		strQuestion=rs1.getString("QUESTION");
		strLocalQuestion=rs1.getString("LOCAL_LANG_QUESTION");
		if (strFontSize==null) strFontSize="12";
		if (strAlign==null) strAlign="left";
		if (strFontStyle==null) strFontStyle = "arial";
		if (strQuestion==null) strQuestion="";
		if (strLocalQuestion ==null) strLocalQuestion = "";
		if (strCode.startsWith("X"))
		{
			if (!strCode.equals("X0"))
			{
				out.println("<tr><td height='28' bgcolor='#FFFFFF' width='"+(screen_width/2)+"'>");
				if (strCode.equals("X2")) out.println("<table><tr><td>");
				if (strCode.equals("X1")) out.println("<table><tr><td valign='top'><img src='http://tsrfq.ts.com.tw:8080/oradds/jsp/images/logo.PNG' width='150' height='55'></td><td>");
				out.println("<div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion.replace("?01","").replace("?02",sales_deadline_date).replace("?03",trace_deadline_date)+"</div></td></tr>");
				out.println("</TABLE></td></tr>");
			}
		}
		else if (strCode.startsWith("C"))
		{
			if (strCode.equals("C1"))
			{
				if (strQuestion.startsWith("Company"))
				{
					out.println("<tr><td width='"+(screen_width/2)+"'><table width='100%'><tr><td><table width='100%' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#999999'>");
					out.println("<tr><td colspan='2' height='35' bgcolor='#CCFFCC' width='"+screen_width+"'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'><font style='color:#FF0000;font-size:"+strFontSize+";font-weight:bold'>*</font>"+strQuestion+" "+strLocalQuestion+"</div></td>");
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
					out.println("<td><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(email.equals("")?"&nbsp;":email)+"</div></td></tr></table></td></tr></table></td><td>&nbsp;</td></tr>");
				}
			}
		}
		else if (strCode.startsWith("Q"))
		{
			if (seqno==0)
			{
				out.println("<tr><td><table width='100%' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#999999'>");
				out.println("<tr align='center' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>");
				out.println("<td colspan='2' width='380'>Question</td>");
				out.println("<td width='160'>Score</td>");
				out.println("<td width='140'>What/Event</td>");
				out.println("<td width='140'>Where/Plant</td>");
				out.println("<td width='140'>Who/Issue Owner</td>");
				out.println("<td width='140'>When/When happened</td>");
				out.println("<td width='140'>Why/Happened reason</td>");
				out.println("<td width='140'>How/Solution</td>");
				out.println("<td width='140'>Result</td>");
				out.println("<td width='200'>Attached Evidence</td></tr>");
			}
			k++;
			if ((rs1.getString("SCORE_LEVEL")!=null && rs1.getString("obj_type").toLowerCase().equals("radio") && rs1.getInt("SCORE_LEVEL")<3 ) || (rs1.getString("obj_type").toLowerCase().equals("textarea") && !rs1.getString("SCORE_LEVEL").equals("0") && rs1.getString("SCORE_LEVEL")!=null))
			{
				strbgcolor="#EEFAFF";
			}
			else
			{
				strbgcolor="#FFFFFF";
			}
		
			out.println("<tr bgcolor='"+strbgcolor+"'>");
			out.println("<td width='40'><div align='center' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+k+"</div></td>");
			out.println("<td width='340'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+"<br>"+strLocalQuestion+"</div></td>");
			if (rs1.getString("obj_type").toLowerCase().equals("radio"))
			{
				out.println("<td width='140' align='center' style='font-family:arial;"+(rs1.getString("SCORE_LEVEL")!=null && rs1.getInt("SCORE_LEVEL")<3?"color:#ff0000;font-weight:bold;font-size:18px;":"color:#0000ff;font-size:16px;")+"'>"+rs1.getString("SCORE_LEVEL")+"</td>");
			}
			else if (rs1.getString("obj_type").toLowerCase().equals("textarea"))
			{
				out.println("<td width='140' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(rs1.getString("SCORE_LEVEL")==null||rs1.getString("SCORE_LEVEL").equals("0")?"&nbsp;":rs1.getString("SCORE_LEVEL"))+"</td>");
			}
			if ((rs1.getString("SCORE_LEVEL")!=null && rs1.getString("obj_type").toLowerCase().equals("radio") && rs1.getInt("SCORE_LEVEL")<3 ) || (rs1.getString("obj_type").toLowerCase().equals("textarea") && !rs1.getString("SCORE_LEVEL").equals("0") && rs1.getString("SCORE_LEVEL")!=null))
			{
				for (int j = 1 ; j <=col ; j++)
				{
					out.println("<td width='140'>");
					if (stype.equals("*"))
					{
						out.println("<textarea name='textarea"+j+"_"+strCode+"' cols='30' rows='6' style='color:#ff000;font-family:arial;background-color:EEFAFF'>");
					}
					out.println((request.getParameter("textarea"+j+"_"+strCode)==null?(rs1.getString("qu"+j)==null?"&nbsp;":rs1.getString("qu"+j)):request.getParameter("textarea"+j+"_"+strCode)));
					if (stype.equals("*"))
					{
						out.println("</textarea></td>");
					}
				}
				
				out.println("<td width='200'>");
				String rootName = "/jsp/CustomerQuestion_Attache/"+id+(rs1.getString("obj_type").toLowerCase().equals("textarea")?"comment":strCode);
				if (ACTIONCODE.equals("DELATTACHE") && !FILENAME.equals(""))
				{
					String delPath = application.getRealPath(rootName+"/"+FILENAME);
					File file = new File(delPath);   
					if (file.exists()) 
					{  
						boolean deleted = file.delete();  
					}
				}
						
				String rootPath = application.getRealPath(rootName);
				File fp = new File(rootPath);
				if (fp.exists()) 
				{
					String[] list = fp.list();
					if (list.length > 0)
					{
						for(int i=0; i<list.length;i++)
						{
							File inFp = new File(rootPath + File.separator + list[i]);
							out.println("&nbsp;<font style='font-family:arial;font-size:12px'><a href='.."+rootName+"/"+list[i]+"' target='_blank'>"+list[i]+"</a></font>&nbsp;&nbsp;&nbsp;");
							if (stype.equals("*"))
							{
								out.println("<img style='vertical-align:text-bottom' src='images/deleteicon_disabled.gif' border='0' onClick='delAttache("+'"'+"../jsp/TscMailQuestTraceabilityReply.jsp?ACTIONCODE=DELATTACHE&FILENAME="+ list[i]+'"'+")'>");
							}
							out.println("<br>");
						}
					}
					else
					{
						out.println("&nbsp;<br>&nbsp;");
					}
				}
				if (stype.equals("*"))
				{					
					out.println("<input type='hidden' name='FILEID' value='"+id+"'><input type='button' name='upload'  size='20' value='upload file' onClick='setAttache("+'"'+"../jsp/subwindow/TscMailQuestTraceabilityUpload.jsp?FILEID="+id+(rs1.getString("obj_type").toLowerCase().equals("textarea")?"comment":strCode)+'"'+")'></td>");
				}
				else
				{
					out.println("&nbsp;");
				}
				out.println("</td>");
			}
			else
			{
				out.println("<td"+(rs1.getString("obj_type").toLowerCase().equals("radio")? " width='140'":" width='200'")+">&nbsp;</td>");
				out.println("<td"+(rs1.getString("obj_type").toLowerCase().equals("radio")? " width='140'":" width='200'")+">&nbsp;</td>");
				out.println("<td"+(rs1.getString("obj_type").toLowerCase().equals("radio")? " width='140'":" width='200'")+">&nbsp;</td>");
				out.println("<td"+(rs1.getString("obj_type").toLowerCase().equals("radio")? " width='140'":" width='200'")+">&nbsp;</td>");
				out.println("<td"+(rs1.getString("obj_type").toLowerCase().equals("radio")? " width='140'":" width='200'")+">&nbsp;</td>");
				out.println("<td"+(rs1.getString("obj_type").toLowerCase().equals("radio")? " width='140'":" width='200'")+">&nbsp;</td>");
				out.println("<td"+(rs1.getString("obj_type").toLowerCase().equals("radio")? " width='140'":" width='200'")+">&nbsp;</td>");
				out.println("<td"+(rs1.getString("obj_type").toLowerCase().equals("radio")? " width='140'":" width='200'")+">&nbsp;</td>");
			}
			out.println("</tr>");
			seqno ++;
		}
	}
	if (seqno >0) out.println("</table></td></tr>");
	if (bfound)
	{
		out.println("<tr bgcolor='FFFFFF'><td colspan='3'><p><div align='right'><input name='Submit' type='button' id='Submit' value='Save' onClick='setSubmit()'>&nbsp;&nbsp;&nbsp;<input name='Submit1'  type='button' id='Submit1' value='Exit' onClick='setSubmit1()'>&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>");
	}
	else
	{
		out.println("<tr bgcolor='FFFFFF'><td colspan='3'><p><div align='center'><input name='Submit' type='button' id='Submit' value='Follow up Close' onClick='setSubmit2()'>&nbsp;&nbsp;&nbsp;<input name='Submit1'  type='button' id='Submit1' value='Exit' onClick='setSubmit1()'>&nbsp;&nbsp;&nbsp;&nbsp;</div></td></tr>");
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
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="keycode" value="<%=keycode%>">
<input type="hidden" name="custid" value="<%=custid%>">
<input type="hidden" name="stype" value="<%=stype%>">
<input type="hidden" name="syear" value="<%=syear%>">
<input type="hidden" name="biannual_code" value="<%=biannual_code%>">
</form>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
