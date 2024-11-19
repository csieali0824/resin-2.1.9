<%
	String q1 = "10";
	String q2 = "10";
	String q3 = "10";
	String q4 = "10";
	String q5 = "10";
	String q6 = "10";
	String q7 = "10";
	String q8 = "10";
	String q9 = "10";
	String q10 = "10";
	String q11 = "10";
try{
		

		String sql1 =" select * from tsc_collect_two " + 
 					" where customer_id ='"+id+"' ";
		//out.print(sql);
		Statement st1 = conn.createStatement();
		ResultSet rs1 = st1.executeQuery(sql1);
 			while(rs1.next()){
				q1	= rs1.getString("q1");
				q2	= rs1.getString("q2");
				q3	= rs1.getString("q3");
				q4	= rs1.getString("q4");
				q5	= rs1.getString("q5");
				q6	= rs1.getString("q6");
				q7	= rs1.getString("q7");
				q8	= rs1.getString("q8");
				q9	= rs1.getString("q9");
				q10	= rs1.getString("q10");
				q11	= rs1.getString("q11");
			} 
		
								 
	}catch(SQLException e){
		System.out.println(e.toString());
	}//finally{
	    //if(conn!=null){
	 		//conn.close();
			//conn=null;
		    //response.sendRedirect("http://www.taiwansemiconductor.com.tw");
		//}
	//}	
	
	

String httl = "<table width='640' border='0' align='center' cellpadding='0' cellspacing='0'>"+
"<h4><font face='Arial' size ='3'><div align='left'>If you can't see the form , please click<a href= 'http://intranet.ts.com.tw:8080/oradds/jsp/tscmailcollectone2.jsp?id="+id+"'> here </a><br><br>If you block pop up windows, you will see no reaction by pressing the submit button,<BR> but the questionnaire was sent anyway.</FONT></div></h4>"+
"</table>"+
"<html><head></head><body  background='images/bkgrnd_greydots.png'>"+
"<form action='http://intranet.ts.com.tw:8080/oradds/jsp/TSCMailCollectOneSave.jsp' method='post'  name='form1'><table width='640' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#6699CC' >"+
"<tr><td height='28' colspan='6' bgcolor='#FFFFFF'><div align='left'><p>&nbsp;</p><p><font size='2' face='Arial'><strong>Welcome Mr/Mrs . Thank you for participating. Please rate following&#13;</strong><strong>questions based on your experience in the last two months with TSC.</strong><br></font></p><p><font size='2' face='Arial'> ( <span class='style1'>* </span>Required ) <br></font></p></div></td></tr>"+
"<tr><td width='15%' bgcolor='#EEFAFF'><font size='2' face='Arial'><span class='style1'>&nbsp;* </span> Name</font></td><td width='18%' bgcolor='FFFFFF' ><font size='2' face='Arial'><input name='Name' type='text' id='Name' size='15' maxlength='40' value= '"+name+"'></font></td><td width='15%' bgcolor='#EEFAFF'><font size='2' face='Arial'>Department</font></td><td width='17%' bgcolor='FFFFFF'><font size='2' face='Arial'><input name='Department' type='text' id='Department' size='15' maxlength='40'  value= '"+department+"' ></font></td><td width='15%'bgcolor='#EEFAFF'><font size='2' face='Arial'>Title</font></td><td width='17%' bgcolor='FFFFFF'><font size='2' face='Arial'><input name='Title' type='text' id='Title' size='15' maxlength='40' value= '"+title+"'></font></td></tr></table><table width='640' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#6699CC' >"+
"<tr><td width='17%' bgcolor='#EEFAFF'><font size='2' face='Arial'><span class='style1'>&nbsp;*</span> Company Name</font></td><td width='33%' bgcolor='FFFFFF'><font size='2' face='Arial'><input name='Company' type='text' id='Company3' size='20' maxlength='50' value= '"+company+"' ></font></td><td width='15%' bgcolor='#EEFAFF'><font size='2' face='Arial'><span class='style1'>&nbsp;* </span>E-mail</font></td><td width='35%' bgcolor='FFFFFF' ><font size='2' face='Arial'><input name='Email' type='text' id='Email2' size='20' maxlength='50' value='"+email+"' ></font></td></tr></table><table width='640'  border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#6699CC' >"+
"<tr><td width='15%' bgcolor='#EEFAFF'><font size='2' face='Arial'>Telephone</font></td><td width='35%' bgcolor='FFFFFF'><font size='2' face='Arial'><input name='Telephone' type='text' id='Telephone3' size='20' maxlength='40' value= '"+telephone+"' ></font></td><td width='15%' bgcolor='#EEFAFF'><font size='2' face='Arial'>Fax</font></td><td width='35%' bgcolor='FFFFFF'><font size='2' face='Arial'><input name='Fax' type='text' id='Fax3' size='20' maxlength='40'  value= '"+fax+"' ></font></td></tr></table><table width='640' border='1' align='center' cellpadding='1' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#6699CC' >"+
"<tr bgcolor='FFFFFF'><td width='5%' bgcolor='FFFFFF'>&nbsp;</td><td width='35%' bgcolor='FFFFFF'>&nbsp;</td><td colspan='6'><div align='center'><font size='2' face='Arial'> &lt;-- Applies Totally&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font><font size='2' face='Arial'>Does not apply at all --&gt; </font></div>      </td></tr>"+
"<tr bgcolor='FFFFFF'><td width='5%'><div align='center'>1</div></td><td width='35%'><font size='2' face='Arial'>Your requests for quotations have been answered as quick as you expected.</font> </td>";
	//out.println(httl);

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q1)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q1' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q1' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='#EEFAFF'><td><div align='center'>2</div></td><td><font size='2' face='Arial'>The price levels are competitive.</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q2)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q2' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q2' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='FFFFFF'><td><div align='center'>3</div></td><td><font size='2' face='Arial'>Your technical questions were answered properly and quick.</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q3)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q3' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q3' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='#EEFAFF'><td><div align='center'>4</div></td><td><font size='2' face='Arial'>Samples have been sent in the correct timing to meet the design in window. </font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q4)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q4' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q4' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='FFFFFF'><td><div align='center'>5</div></td><td><font size='2' face='Arial'>Your lead time inquiries were answered quickly as expected.</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q5)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q5' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q5' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='#EEFAFF'><td><div align='center'>6</div></td><td><font size='2' face='Arial'>TSC's lead times can meet your expectations.</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q6)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q6' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q6' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='FFFFFF'><td><div align='center'>7</div></td><td><font size='2' face='Arial'>OC have been sent on time.</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q7)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q7' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q7' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='#EEFAFF'><td><div align='center'>8</div></td><td><font size='2' face='Arial'>Your shipment inquiries were answered in your satisfaction.</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q8)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q8' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q8' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='FFFFFF'><td><div align='center'>9</div></td><td><font size='2' face='Arial'>Shipments are on time.</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q9)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q9' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q9' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='#EEFAFF'><td><div align='center'>10</div></td><td><font size='2' face='Arial'>TSC website and documentations are helpful meets your expectation.</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q10)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q10' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q10' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='FFFFFF'><td><div align='center'>11</div></td><td><font size='2' face='Arial'>TSC overall meets your expectations and is a good business partners for your business..</font></td>";

 	for(int i=6 ; i>0 ;i--){ 
		if((i!=Integer.parseInt(q11)) ){ 
			httl=httl+"<td width='10%'><div align='center'>"+i+"<input type='radio' name='Q11' value='"+i+"'></div></td>"; 
		}else{	
			 
			httl=httl+"<td width='10%' bgcolor='#FFCF07'><div align='center'>"+i+"<input type='radio' name='Q11' value='"+i+"'></div></td>";
			 
		}
	}
httl=httl+"</tr>"+
"<tr bgcolor='FFFFFF'><td>12</td><td><font size='2' face='Arial'>Your comment to TSC </font></td>"+
"<td colspan='6'><textarea name='comment' cols='40' rows='5' id='comment'></textarea></td></tr>	"+
"<tr bgcolor='FFFFFF'> <td colspan='8'><input name='id' type='hidden'  size='15' maxlength='40' value ='"+id+"' ><div align='right'><input name='Submit'  type='submit' id='Submit'   value='submit'></div></td></tr></table></form></body></html>";
%>