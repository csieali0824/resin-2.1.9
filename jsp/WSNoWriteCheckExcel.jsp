<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<!--%@ page contentType="image/jpeg; charset=Big5" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %-->
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<% 
      String TYPE=request.getParameter("TYPE"); 
	  String DATE=request.getParameter("DATE");
	  String DATE2=request.getParameter("DATE2");
	  String sDateBegin=dateBean.getYearString()+dateBean.getMonthString()+"01"; 
	  int nYear=dateBean.getYear()-1911;	  
	  String sYear=String.valueOf(nYear);	  
	   String sDate=sYear+dateBean.getMonthString()+dateBean.getDayString() ; 	  
	  String WSUserID=(String)session.getAttribute("USERNAME");  
	   if (TYPE==null || TYPE== "" || TYPE.equals("")) 
		    { TYPE="3"; }
	   if (DATE==null || DATE== "" || DATE.equals("")) 
		    { DATE=sDateBegin; }
	   if (DATE2==null || DATE2== "" || DATE2.equals("")) 
	        {DATE2=dateBean.getYearMonthDay(); }
  
 // float vatBaseF = 1;

 try 
      {      String amhvnd=""; 
	          String vndnam=""; 
			  String amhbnk=""; 
			  String hhtrno=""; 
			  String refno=""; 
			  String amhcur=""; 
			  int amhpam=0; 
			  int amcnfc=0; 
			  int abhpam=0; 
			  String amhtda=""; 
			  String tda=""; 
	          String sqlTC=""; 
		      String sWhereTC=""; 
			  String sqlTC2=""; 
		      String sWhereTC2=""; 
              if(TYPE.equals("1"))
			  {
               sqlTC =  "SELECT amh.amhvnd, amh.amhbnk, amh.amhcur, amh.amhtda, amh.amhpam, amh.abhpam, amh.amcnfc,"+
			                           "xpay.tda as tda,"+
									   "ghh.hhjdat, ghh.hhtrno,"+
									   "avm.vndnam,"+
									   "vt2.refno"+" "+
			                  "FROM amh,xpay,ghh ,avm ,OUTER vt2"+" ";
			    sWhereTC = "WHERE amh.amhcpc = xpay.jno AND  amh.amhvnd = xpay.vnd AND  amh.amhpam = xpay.sdamt AND" +" "+
			                                 "amh.amhcpc = ghh.hhjnen AND  amh.amhvnd = avm.vendor AND  ghh.hhjdat = vt2.voudate AND" +" "+
							             	" ghh.hhjnen = vt2.vouno ";
				 if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC = sWhereTC + "AND (amh.amhtda BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "+
				                                             " AND (ghh.hhjdat BETWEEN "+sDateBegin+"AND "+dateBean.getYearMonthDay()+")"+									 
								                        	 " AND  xpay.tda> " +sDate
										 
				    ; }
			     else 
				    {int nDATE2 = Integer.parseInt(DATE2);
					
					 nDATE2=nDATE2 -19110000; 
					 //out.println(nDATE2); 

					  sWhereTC = sWhereTC + "AND (amh.amhtda between " +DATE+" and " +DATE2 +") "+
				                         " AND (ghh.hhjdat between " +DATE+" and " +DATE2+")"+
										  "  AND  xpay.tda> " +nDATE2
				     ; }
			  }
			  else if(TYPE.equals("2"))
			  {
               sqlTC =  "SELECT amh.amhvnd, amh.amhbnk, amh.amhcur, amh.amhtda, amh.amhpam, amh.abhpam, amh.amcnfc,"+
			                            " ' 'as tda, " +			                          
									   "ghh.hhjdat, ghh.hhtrno,"+
									   "avm.vndnam,"+
									   "vt2.refno"+
			                   " FROM amh,ghh ,avm ,OUTER vt2"+" ";
			    sWhereTC = " WHERE amh.amhcpc = ghh.hhjnen AND  amh.amhtda = ghh.hhjdat AND" +" "+
			                         "amh.amhvnd = avm.vendor AND  ghh.hhjdat = vt2.voudate AND" +" "+
							         " ghh.hhjnen = vt2.vouno AND  amh.amhsts = 'A' ";
				  if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC = sWhereTC + "AND (amh.amhtda BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "+
				                                             " AND (ghh.hhjdat BETWEEN "+sDateBegin+" AND "+dateBean.getYearMonthDay()+")"									 
								                        											 
				    ; }
			     else  
				    { sWhereTC = sWhereTC + "AND (amh.amhtda between " +DATE+" and " +DATE2 +") "+
				                         " AND (ghh.hhjdat between " +DATE+" and " +DATE2+")"
					;  }
			  }			  
			   else
			  {
			    sqlTC =  "SELECT amh.amhvnd, amh.amhbnk, amh.amhcur, amh.amhtda, amh.amhpam, amh.abhpam, amh.amcnfc,"+
			                           "xpay.tda as tda,"+
									   "ghh.hhjdat, ghh.hhtrno,"+
									   "avm.vndnam,"+
									   "vt2.refno"+" "+
			                  "FROM amh,xpay,ghh ,avm ,OUTER vt2"+" ";
			    sWhereTC = "WHERE amh.amhcpc = xpay.jno AND  amh.amhvnd = xpay.vnd AND  amh.amhpam = xpay.sdamt AND" +" "+
			                                 "amh.amhcpc = ghh.hhjnen AND  amh.amhvnd = avm.vendor AND  ghh.hhjdat = vt2.voudate AND" +" "+
							             	" ghh.hhjnen = vt2.vouno ";
				    if (DATE==null || DATE== "" || DATE.equals("")  )  
			      	  { sWhereTC = sWhereTC + "AND (amh.amhtda BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "+
				                                             " AND (ghh.hhjdat BETWEEN "+sDateBegin+"AND "+dateBean.getYearMonthDay()+")"+									 
								                        	 " AND  xpay.tda> " +sDate
				    	; }
				  else 
				    {int nDATE2 = Integer.parseInt(DATE2);
					
					 nDATE2=nDATE2 -19110000; 
					 //out.println(nDATE2); 

					  sWhereTC = sWhereTC + "AND (amh.amhtda between " +DATE+" and " +DATE2 +") "+
				                         " AND (ghh.hhjdat between " +DATE+" and " +DATE2+")"+
										  "  AND  xpay.tda> " +nDATE2
				     ; }
			     sqlTC2=  "SELECT amh.amhvnd, amh.amhbnk, amh.amhcur, amh.amhtda, amh.amhpam, amh.abhpam, amh.amcnfc,"+
			                           " 0  as tda, " +			                          
									   "ghh.hhjdat, ghh.hhtrno,"+
									   "avm.vndnam,"+
									   "vt2.refno"+
			                   " FROM amh,ghh ,avm ,OUTER vt2"+" ";
			    sWhereTC2 = " WHERE amh.amhcpc = ghh.hhjnen AND  amh.amhtda = ghh.hhjdat AND" +" "+
			                         "amh.amhvnd = avm.vendor AND  ghh.hhjdat = vt2.voudate AND" +" "+
							         " ghh.hhjnen = vt2.vouno AND  amh.amhsts = 'A' ";
				  if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC2 = sWhereTC2 + "AND (amh.amhtda BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "+
				                                             " AND (ghh.hhjdat BETWEEN "+sDateBegin+" AND "+dateBean.getYearMonthDay()+")"									 
				   ; }	
			 	else  
				    { sWhereTC2 = sWhereTC2 + "AND (amh.amhtda between " +DATE+" and " +DATE2 +") "+
				                         " AND (ghh.hhjdat between " +DATE+" and " +DATE2+")"
					;  }
				   						 
			  }
			  
			  String sOrderTC = " Order by 10 ASC";			  	  			 
             if(TYPE.equals("3"))	
			   {sqlTC = sqlTC = sqlTC + sWhereTC+"  UNION  " +  sqlTC2+ sWhereTC2 +sOrderTC ;}
			  else
			   {sqlTC = sqlTC = sqlTC + sWhereTC+sOrderTC ;}			  
			
	 out.println(sqlTC );

    // 產生報表
	OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\wins\\report\\"+WSUserID+"_Query.xls"); 	
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("NoWriteCheck", 0); 
	jxl.SheetSettings ss = new jxl.SheetSettings();
	ss.setSelected();
	ss.setVerticalFreeze(5);
	ss.setFitToPages(true);	
			
	//file://抬頭:(第0列第1行)
    jxl.write.WritableFont wf = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF = new jxl.write.WritableCellFormat(wf); 
	wcfF.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	//抬頭:(第0列第1行)
    jxl.write.Label labelCF0 = new jxl.write.Label(0, 0, "廠商", wcfF); 
    ws.addCell(labelCF0);
	ws.setColumnView(0, 10);			
	//file://抬頭:(第0列第2行)
   jxl.write.Label labelCF1 = new jxl.write.Label(1, 0, "廠商名稱", wcfF); 
    ws.addCell(labelCF1);
	ws.setColumnView(1, 40);
	//file://抬頭:(第0列第3行)
   jxl.write.Label labelCF2 = new jxl.write.Label(2, 0, "帳號", wcfF); 
    ws.addCell(labelCF2);
	ws.setColumnView(2, 10);
	//file://抬頭:(第0列第4行)
	jxl.write.Label labelCF3 = new jxl.write.Label(3, 0, "事件號碼", wcfF); 
    ws.addCell(labelCF3);
	ws.setColumnView(3, 15);
	//file://抬頭:(第0列第5行)
	jxl.write.Label labelCF4 = new jxl.write.Label(4, 0, "傳票號碼", wcfF); 
    ws.addCell(labelCF4);
	ws.setColumnView(4, 15);
	//file://抬頭:(第0列第6行)
	jxl.write.Label labelCF5 = new jxl.write.Label(5, 0, "幣別", wcfF); 
    ws.addCell(labelCF5);
	ws.setColumnView(5, 10);
	//file://抬頭:(第0列第7行)
	jxl.write.Label labelCF6 = new jxl.write.Label(6, 0, "幣別金額", wcfF); 
    ws.addCell(labelCF6);
	ws.setColumnView(6, 20);
	//file://抬頭:(第0列第8行)
	jxl.write.Label labelCF7 = new jxl.write.Label(7, 0, "匯率", wcfF); 
    ws.addCell(labelCF7);
	ws.setColumnView(7, 10);
	//file://抬頭:(第0列第9行)
	jxl.write.Label labelCF8 = new jxl.write.Label(8, 0, "台幣金額", wcfF); 
    ws.addCell(labelCF8);
	ws.setColumnView(8, 20);
	//file://抬頭:(第0列第10行)
	jxl.write.Label labelCF9 = new jxl.write.Label(9, 0, "付款日期", wcfF); 
    ws.addCell(labelCF9);
	ws.setColumnView(9, 15);
	//file://抬頭:(第0列第11行)
	jxl.write.Label labelCF10 = new jxl.write.Label(10, 0, "開票日期", wcfF); 
    ws.addCell(labelCF10);
	ws.setColumnView(10, 15);

	
	
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 1;
					
	     Statement statementTC=bpcscon.createStatement();     	
		 ResultSet rsTC=statementTC.executeQuery(sqlTC);	 		
        		
		
		while (rsTC.next())
		{	  		
		 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);   	     
		
		  amhvnd=rsTC.getString("amhvnd");
		  if ((amhvnd== null ||  amhvnd.equals("")))
		  {amhvnd ="";}	 
	      jxl.write.Label lable11 = new jxl.write.Label(0, rowNo, amhvnd, wcfFL); 
          ws.addCell(lable11);
		  
		  vndnam=rsTC.getString("vndnam");
		  if ((vndnam== null ||  vndnam.equals("")))
		  {vndnam ="";}	 
	      jxl.write.Label lable12 = new jxl.write.Label(1, rowNo, vndnam, wcfFL); 
          ws.addCell(lable12);
		  
		  amhbnk=rsTC.getString("amhbnk");
		  if ((amhbnk== null ||  amhbnk.equals("")))
		  {amhbnk ="";}	 
	      jxl.write.Label lable13 = new jxl.write.Label(2, rowNo, amhbnk, wcfFL); 
          ws.addCell(lable13);
		  
		    hhtrno=rsTC.getString("hhtrno");
		  if ((hhtrno== null ||  hhtrno.equals("")))
		  {hhtrno ="";}	 
	      jxl.write.Label lable14 = new jxl.write.Label(3, rowNo, hhtrno, wcfFL); 
          ws.addCell(lable14);
		  
		   refno=rsTC.getString("refno");
		  if ((refno== null || refno.equals("")))
		  {refno ="";}	 
	      jxl.write.Label lable15 = new jxl.write.Label(4, rowNo, refno, wcfFL); 
          ws.addCell(lable15);
		  
		    amhcur=rsTC.getString("amhcur");
		  if ((amhcur== null || amhcur.equals("")))
		  {amhcur ="";}	 
	      jxl.write.Label lable16 = new jxl.write.Label(5, rowNo, amhcur, wcfFL); 
          ws.addCell(lable16);
		  
		 amhpam=rsTC.getInt("amhpam");
		  if (amhpam==0)
		  {amhpam =0;}	 
	      jxl.write.Number lable17 = new jxl.write.Number(6, rowNo, amhpam, wcfFL); 
          ws.addCell(lable17);
		  
		   amcnfc=rsTC.getInt("amcnfc");
		  if (amcnfc== 0)
		  {amcnfc =0;}	 
	      jxl.write.Number lable18 = new jxl.write.Number(7, rowNo, amcnfc, wcfFL); 
          ws.addCell(lable18);
		  
		   abhpam=rsTC.getInt("abhpam");
		  if (abhpam== 0 )
		  {abhpam =0;}	 
	      jxl.write.Number lable19= new jxl.write.Number(8, rowNo, abhpam, wcfFL); 
          ws.addCell(lable19);
		  
		     amhtda=rsTC.getString("amhtda");
		  if ((amhtda== null || amhtda.equals("")))
		  {amhtda ="";}	 
	      jxl.write.Label lable20= new jxl.write.Label(9, rowNo, amhtda, wcfFL); 
          ws.addCell(lable20);
		     tda=rsTC.getString("tda");
			 
		  if ((tda== null || tda.equals("")))
		  {tda ="";}	 
	      jxl.write.Label lable21= new jxl.write.Label(10, rowNo, tda, wcfFL); 
          ws.addCell(lable21);
		  
		  rowNo = rowNo + 1;
		  
		
	 }   // End of While rsTC.next()
		

	 rsTC.close();
	 statementTC.close();	 
	
	//寫入Excel 
	wwb.write();     
   wwb.close();
    out.close(); 
	

    }   // End of try
    catch (Exception e) 
    { 
	 out.println("Exception:"+e.getMessage()); 
   
    } 	
%>
<img src="../image/logo.gif"><BR>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>

