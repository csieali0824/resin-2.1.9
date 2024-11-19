<!-- 20180628 Peggy,add new column =customer group-->
<%
try
{	
	httl = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' pageEncoding='UTF-8'><link href='http://tsrfq.ts.com.tw:8080/oradds/jsp/images/website.css' rel='stylesheet' type='text/css'></head>"+
	       "<body  background='images/bkgrnd_greydots.png'><form action='"+reqURL+"TscMailQuestTraceabilityReply.jsp' method='post' name='form1'>"+
	       "<table width='850' border='0' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#FFFFFF'>";
	String sql1 = " SELECT QUEST_CODE"+
	              " ,QUESTION,NVL(CASE (SELECT b.language_version FROM oraddman.cust_mail b WHERE b.rowid='"+keycode+"')  WHEN 'TRADITIONAL CHINESE' THEN TRADITIONAL_CHINESE WHEN 'SIMPLIFIED CHINESE' THEN SIMPLIFIED_CHINESE WHEN 'KOREAN' THEN KOREAN WHEN 'JAPANESE' THEN JAPANESE ELSE  '' END,'') AS LOCAL_LANG_QUESTION  "+
                  " ,NVL((SELECT CASE WHEN a.QUEST_CODE ='Q1' THEN Q1 "+
                  "                   WHEN a.QUEST_CODE ='Q2' THEN Q2 "+
                  "                   WHEN a.QUEST_CODE ='Q3' THEN Q3 "+ 
                  "                   WHEN a.QUEST_CODE ='Q4' THEN Q4 "+ 
                  "                   WHEN a.QUEST_CODE ='Q5' THEN Q5 "+ 
                  "                   WHEN a.QUEST_CODE ='Q6' THEN Q6 "+ 
                  "                   WHEN a.QUEST_CODE ='Q7' THEN Q7 "+ 
                  "                   WHEN a.QUEST_CODE ='Q8' THEN Q8 "+ 
                  "                   WHEN a.QUEST_CODE ='Q9' THEN Q9  "+
                  "                   WHEN a.QUEST_CODE ='Q10' THEN Q10 "+
                  "                   WHEN a.QUEST_CODE ='Q11' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q11) "+
                  "                   WHEN a.QUEST_CODE ='Q12' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q12) "+ 
                  "                   WHEN a.QUEST_CODE ='Q13' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q13)"+ 
                  "                   WHEN a.QUEST_CODE ='Q14' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q14) "+ 
                  "                   WHEN a.QUEST_CODE ='Q15' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q15) END "+ 
                  "       FROM oraddman.cust_collect_questionnaire c "+
				  "       WHERE customer_id='"+cust_id+"' "+
				  "       AND c.year = '"+s_year+"' "+
				  "       AND c.BIANNUAL_CODE= '"+ s_month+"' "+
	              "       ),0) AS SCORE_LEVEL "+
				  " ,OBJ_TYPE,FONT_SIZE "+
				  " ,ALIGN_TYPE,FONT_STYLE "+
                  " FROM oraddman.cust_quest_define a "+
                  " WHERE SUBSTR(a.QUEST_CODE,1,1) NOT IN ('A','B') "+
                  " AND SUBSTR(a.QUEST_CODE,1,2) NOT IN ('Q0') "+
				  " AND ((a.QUESTION_TYPE in ('QUESTION','COMMENT') and exists (select 1 from oraddman.cust_questionnaire_type cqt,oraddman.cust_mail cm"+ //add by Peggy 20180628 start
                  " where cqt.customer_group=nvl(cm.customer_group ,'ALL')"+
                  " and cm.id || cm.ROWID = '"+cust_id+keycode+"'"+
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
		strCode=rs1.getString("QUEST_CODE");strFontSize=rs1.getString("FONT_SIZE");strAlign=rs1.getString("ALIGN_TYPE");strFontStyle=rs1.getString("FONT_STYLE");strQuestion=rs1.getString("QUESTION");strLocalQuestion=rs1.getString("LOCAL_LANG_QUESTION");
		if (strFontSize==null) strFontSize="12";
		if (strAlign==null) strAlign="left";
		if (strFontStyle==null) strFontStyle = "arial";
		if (strQuestion==null) strQuestion="";
		if (strLocalQuestion ==null) strLocalQuestion = "";
		if (strCode.startsWith("X"))
		{
			if (strCode.equals("X0"))
			{
				if (strLocalQuestion.equals("")) strLocalQuestion=strQuestion;
				httl+="<tr><TD style='PADDING-BOTTOM: 10px; LINE-HEIGHT: 20px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; COLOR: #000; PADDING-TOP: 10px;font-family:"+strFontStyle+";font-size:"+strFontSize+"px' bgColor=#e7e7e7 width=783 align="+strAlign+">"+strLocalQuestion+"</td></tr>"+
		              "<tr><td>&nbsp;</td></tr>";
			}
			else
			{
				httl+="<tr><td height='28' bgcolor='#FFFFFF'>";
				if (strCode.equals("X1")) httl+="<table><tr><td valign='top' width='15%'><img src='http://tsrfq.ts.com.tw:8080/oradds/jsp/images/tc_logo.png' width=150 height=50></td><td>";
				httl+="<div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion.replace("?01","<a  style='color:#0000ff;font-weight:bold;font-size:16px' href='"+reqURL+"TscMailQuestTraceabilityReply.jsp?id="+cust_id+keycode+"&stype=*'>Click here</a>").replace("?02",sales_deadline_date).replace("?03",trace_deadline_date)+"</div></td></tr>";
				if (strCode.equals("X1")) httl+="</td></tr></TABLE>";
			}
		}
		else if (strCode.startsWith("C"))
		{
			if (strCode.equals("C1"))
			{
				if (strQuestion.startsWith("Company"))
				{
					httl += "<tr><td><table width='100%' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#999999'>"+
					       "<tr><td colspan='2' height='35' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'><font style='color:#FF0000;font-size:"+strFontSize+";font-weight: bold'>*</font>"+strQuestion+" "+strLocalQuestion+"</div></td>"+
						   "<td colspan='4'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+company+"</div></td></tr>";
				}
			}
			else if (strCode.equals("C2"))
			{
				if (strQuestion.equals("Name"))
				{
					httl += "<tr><td width='15%' height='35' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'><font style='color:#FF0000;font-size:"+strFontSize+";font-weight: bold'>*</font>"+strQuestion+" "+strLocalQuestion+"</div></td>"+
						   "<td width='18%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+name+"</div></td>";
				}
				else if (strQuestion.equals("Department"))
				{
					httl += "<td width='15%' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&nbsp;"+strQuestion+" "+strLocalQuestion+"</div></td>"+
						   "<td width='18%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(department.equals("")?"&nbsp;":department)+"</div></td>";
				}
				else if (strQuestion.equals("Title"))
				{
					httl += "<td width='15%' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&nbsp;"+strQuestion+" "+strLocalQuestion+"</div></td>"+
						   "<td width='18%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(title.equals("")?"&nbsp;":title)+"</div></td></tr>";
				}
			}
			else if (strCode.equals("C3"))
			{
				if (strQuestion.equals("Telephone"))
				{
					httl += "<tr><td height='35' bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&nbsp;"+strQuestion+" "+strLocalQuestion+"</div></td>"+
						   "<td><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(telephone.equals("")?"&nbsp;":telephone)+"</div></td>";
				}
				else if (strQuestion.equals("E-mail"))
				{
					httl += "<td bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'><font style='color:#FF0000;font-size:"+strFontSize+";font-weight: bold'>*</font>"+strQuestion+" "+strLocalQuestion+"</div></td>"+
						   "<td colspan='3'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+email+"</div></td></tr></table></td></tr>";
				}
			}
		}
		else if (strCode.startsWith("Q"))
		{
			if (seqno==0)
			{
				httl += "<tr><td><table width='100%' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#999999'>";
			}
			k++;
			if ((k % 2)==1)
			{
				strbgcolor="#FFFFFF";
			}
			else
			{
				strbgcolor="#EEFAFF";
			}
		
			httl+="<tr bgcolor='"+strbgcolor+"'>"+
				  "<td height='60' width='30'><div align='center' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+k+"</div></td>"+
				  "<td width='470'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+"<br>"+strLocalQuestion+"</div></td>";
			if (rs1.getString("obj_type").toLowerCase().equals("radio"))
			{
				httl+="<td width='150'><div align='center' style='font-family:"+strFontStyle+";"+(rs1.getString("SCORE_LEVEL")!=null && rs1.getInt("SCORE_LEVEL")<3?"color:#ff0000;font-weight:bold;font-size:18px;":"color:#0000ff;font-size:16px;")+"'>"+rs1.getString("SCORE_LEVEL")+"</div></td>";			
			}
			else if (rs1.getString("obj_type").toLowerCase().equals("textarea"))
			{
				httl += "<td width='150'>"+(rs1.getString("SCORE_LEVEL").equals("0")?"":rs1.getString("SCORE_LEVEL"))+"</td>";
			}
			httl+="</tr>";
			seqno ++;
		}
	}
	if (seqno >0)	httl += "</table></td></tr>";
	httl +="</table>"+
			"<input type='hidden' name='keycode' value='"+keycode+"'><input type='hidden' name='custid' value='"+id+"'></form></body></html>";
	
	rs1.close();
	st1.close();

	//out.println(httl);
}
catch (Exception e)
{
	//httl ="";
	httl=e.toString();
	email = "peggy.chen@ts.com.tw";
	System.out.println(e.toString());
}
%>
 