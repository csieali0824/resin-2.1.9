<!-- 20180628 Peggy,add new column =customer group-->
<%
try
{	
	//httl = "<html><head></head><body  background='images/bkgrnd_greydots.png'><form action='http://tsrfq.ts.com.tw:8080/oradds/jsp/TSCMailCollectQuestSave.jsp' method='post' name='form1'>"+
	httl = "<html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' pageEncoding='UTF-8'><link href='http://tsrfq.ts.com.tw:8080/oradds/jsp/images/website.css' rel='stylesheet' type='text/css'></head>"+
	       "<body  background='images/bkgrnd_greydots.png'><form action='"+reqURL+"TSCMailCollectQuestSave.jsp' method='post' name='form1'>"+
	       "<table width='850' border='0' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#FFFFFF'>";
	//add by Peggy 20121004		  
	String sql1 = "select QUEST_CODE,QUESTION,NVL(case (select b.language_version from oraddman.cust_mail b where b.rowid='"+keycode+"')  WHEN 'TRADITIONAL CHINESE' THEN TRADITIONAL_CHINESE WHEN 'SIMPLIFIED CHINESE' THEN SIMPLIFIED_CHINESE WHEN 'KOREAN' THEN KOREAN WHEN 'JAPANESE' THEN JAPANESE ELSE  '' END,'') AS LOCAL_LANG_QUESTION  "+
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
                 " WHEN a.QUEST_CODE ='Q11' THEN Q11 "+
                 " WHEN a.QUEST_CODE ='Q12' THEN Q12 "+
                 " WHEN a.QUEST_CODE ='Q13' THEN Q13 "+
                 " WHEN a.QUEST_CODE ='Q14' THEN Q14 "+
                 " WHEN a.QUEST_CODE ='Q15' THEN Q15 END "+
                 " from oraddman.cust_collect_questionnaire c where customer_id='"+id+"'  and exists (select 1 from oraddman.cust_mail x"+
                 " WHERE x.ROWID = '"+keycode+"' and x.id='"+ id+"' and x.year = c.year and x.BIANNUAL_CODE= c.BIANNUAL_CODE)),0) AS SCORE_LEVEL,OBJ_TYPE,FONT_SIZE,ALIGN_TYPE,FONT_STYLE"+
                 " from oraddman.cust_quest_define a"+
				 " where a.quest_id <1000"+
				 " and ((a.QUESTION_TYPE in ('QUESTION','COMMENT') and exists (select 1 from oraddman.cust_questionnaire_type cqt,oraddman.cust_mail cm"+ //add by Peggy 20180628 start
                 " where cqt.customer_group=nvl(cm.customer_group ,'ALL')"+
                 " and cm.ROWID = '"+keycode+"'"+
                 " and cqt.QUEST_CODE=a.QUEST_CODE)) or a.QUESTION_TYPE is null)"+  //add by Peggy 20180628 end
				 " order by CASE WHEN quest_id<900 THEN TO_NUMBER(QUEST_ID) *1000 ELSE TO_NUMBER(QUEST_ID) END";			  
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
				if (strLocalQuestion.equals("")) strLocalQuestion=strQuestion;
	       		//httl+="<tr><TD style='PADDING-BOTTOM: 10px; LINE-HEIGHT: 20px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; COLOR: #000; PADDING-TOP: 10px;font-family:"+strFontStyle+";font-size:"+strFontSize+"px' bgColor=#e7e7e7 width=783 align="+strAlign+">※"+strLocalQuestion.replace("?01","<A style='COLOR: #000; FONT-WEIGHT: bold; TEXT-DECORATION: underline' href='http://tsrfq.ts.com.tw:8080/oradds/jsp/TscMailCollectQuestReply.jsp?id="+id+"' target=_blank>").replace("?02","</A>")+"</td></tr>"+
				httl+="<tr><TD style='PADDING-BOTTOM: 10px; LINE-HEIGHT: 20px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; COLOR: #000; PADDING-TOP: 10px;font-family:"+strFontStyle+";font-size:"+strFontSize+"px' bgColor=#e7e7e7 width=783 align="+strAlign+">"+strLocalQuestion.replace("?01","<a  style='color:#0000ff;font-weight:bold;font-size:16px' href='"+reqURL+"TscMailCollectQuestReply.jsp?id="+id+keycode+"'>Click here</a>")+"</td></tr>"+
		              "<tr><td>&nbsp;</td></tr>";
//                      "<tr><td bgcolor='#FFFFFF'><div align='left'><img src='http://tsrfq.ts.com.tw:8080/oradds/jsp/images/ts_logo.jpg' width='150' height='55'></div></td></tr>";
			}
			else
			{
				httl+="<tr><td height='28' bgcolor='#FFFFFF'>";
				if (strCode.equals("A1")) httl+="<table><tr><td valign='top'><img src='http://tsrfq.ts.com.tw:8080/oradds/jsp/images/tc_logo.png'></td><td>";
				httl+="<div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+"<p>"+((strLocalQuestion.equals("") && strCode.equals("A1"))?"&nbsp;":strLocalQuestion)+"<p></div></td></tr>";
				if (strCode.equals("A1")) httl+="</td></tr></TABLE>";
			}
		}
		else if (strCode.startsWith("B"))
		{
			httl+="<tr><td height='28' bgcolor='#FFFFFF'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>(<font style='color:#FF0000;font-size:"+strFontSize+";font-weight: bold'>*</font> "+strQuestion+" "+strLocalQuestion+")</div></td></tr>";
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
				//傳真不顯示,modify by Peggy 20141216
				//else if (strQuestion.equals("Fax"))
				//{
				//	httl += "<td bgcolor='#CCFFCC'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&nbsp;"+strQuestion+" "+strLocalQuestion+"</div></td>"+
				//		   "<td><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+(fax.equals("")?"&nbsp;":fax)+"</div></td>";
				//}
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
			if (strCode.equals("Q01"))
			{
				httl += "<tr bgcolor='#CCFFCC'><td width='5%' height='45'><div align='center'  style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>No</div></td>"+
				            "<td width='47%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+" "+strLocalQuestion+"</div></td>";
			}
			else if (strCode.equals("Q02"))
			{
				httl += "<td colspan='5'><table width='100%' border='0'><tr><td width='45%'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>&larr;"+strQuestion+" "+strLocalQuestion+"</div></td>";
			}
			else if (strCode.equals("Q03"))
			{
				httl += "<td><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+" "+strLocalQuestion+"&rarr;</div></td></tr></table></td></tr>";
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
			
				httl+="<tr bgcolor='"+strbgcolor+"'>"+
					  "<td height='60' width='30'><div align='center' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+k+"</div></td>"+
					  "<td width='470'><div align='"+strAlign+"' style='font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+strQuestion+"<br>"+strLocalQuestion+"</div></td>";
				if (rs1.getString("obj_type").toLowerCase().equals("radio"))
				{
					for(int i=5 ; i>0 ;i--)
					{ 
						if (i!=Integer.parseInt(rs1.getString("SCORE_LEVEL")))
						{ 
							httl+="<td width='50'><div align='center' style='font-family:arial;font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+i+"<input type='radio' name='Q"+k+"' value='"+i+"'></div></td>"; 
						}
						else
						{	
							httl+="<td width='50'><div align='center' style='font-family:arial;font-size:"+strFontSize+"px;font-family:"+strFontStyle+"'>"+i+"<input type='radio' name='Q"+k+"' value='"+i+"' checked></div></td>";
						}
					}
				}
				else if (rs1.getString("obj_type").toLowerCase().equals("textarea"))
				{
					httl += "<td colspan='5'><textarea name='comment' cols='40' rows='4' id='comment'></textarea></td>";
				}
				httl+="</tr>";
			}
			seqno ++;
		}
	}
	if (seqno >0)	httl += "</table></td></tr>";
	httl +="<tr bgcolor='FFFFFF'> <td colspan='8'><div align='right'><input name='Submit'  type='Submit' id='Submit' value='submit'></div></td></tr></table>"+
			"<input type='hidden' name='keycode' value='"+keycode+"'><input type='hidden' name='custid' value='"+id+"'></form></body></html>";
	
	rs1.close();
	st1.close();

	//out.println(httl);
}
catch (Exception e)
{
	//httl ="";
	httl=e.toString();
	email = "peggy_chen@mail.ts.com.tw";
	System.out.println(e.toString());
}
%>
 