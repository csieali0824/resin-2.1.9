<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="java.io.*,DateBean,JCopy" %>
<!--=============以下區段為取得連結池==========-->
<%//@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="jCopy" scope="page" class="JCopy"/>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSMicroPoolPage.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%

  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");
  String DayFr=request.getParameter("DAYFR");
  String dateStringBegin=YearFr+MonthFr+DayFr;
  String dateYYYYMMDD = "";
  String sDate="";
  String sGFilename="";

if (YearFr!=null && !YearFr.equals(""))   // 若由手動選取日,取選定結轉日(月日年)
{
            sDate= MonthFr+DayFr+YearFr;
            sGFilename=sDate+".txt"; 
			dateYYYYMMDD = YearFr+"/"+MonthFr+"/"+DayFr;
 }
 else  {      // 若為自動排程轉入,則取伺服器日期前一日為結轉日
               dateBean.setAdjDate(-1);
               sDate=dateBean.getMonthString()+dateBean.getDayString()+dateBean.getYearString(); 
               sGFilename=sDate+".txt"; 
			   dateYYYYMMDD = dateBean.getYearString()+"/"+dateBean.getMonthString()+"/"+dateBean.getDayString();
               dateBean.setAdjDate(1);
         }
     
out.println("取得 "+"<font color='#CC3366'></strong>"+sGFilename+"</strong></font>"); 

File url1 = null;
File url2 = null;
try
{
   url1= new File("I://Tw9900//TEXTLOG//"+sGFilename);

//if (url1==null )
//{ out.println("伺服器連線卡鐘出勤工作站異常,請洽管理員重新設定連線 !!! "); }

    url2= new File("D://resin-2.1.9/webapps/wins/ftp/DBTEL_Daily_Tmp.txt");
	if ( url1 !=null && !url1.equals(""))
    {
	   jCopy.copyFile(url1,url2);   
	   out.println("File Save as OK !");
	   
	    String inputFileName  = "D://resin-2.1.9/webapps/wins/ftp/DBTEL_Daily_Tmp.txt";
        int       insertResults = 0;
        String DELIM = ",";
        String  DATE_TIME;
        String  EVENT;
        String  EVENT_DESC;
        String  CARD_NO;
        String  CARD_NAME;
        String  DEPT;
        String  EMP_NO;
		
        
         try
	    {

            Statement stmt = bpcscon.createStatement ();
            FileReader inputFileReader = new FileReader(inputFileName);
            BufferedReader inputStream   = new BufferedReader(inputFileReader);
	         String inLine = null;
		      //inLine =  inputStream.readLine(); 			
              //int k1=inLine.lastIndexOf(DELIM); 
		     
			
		    //while (inLine != null) 
			 
            while ((inLine = inputStream.readLine()) != null )
			{ //out.println(inLine); 
			   int k1=inLine.lastIndexOf(DELIM); 
			   //int k1=inLine.IndexOf(DELIM); 
			   //out.println(k1); 
			   if(k1>58)
              {
			   StringTokenizer st = new StringTokenizer(inLine, DELIM);
              // out.print(st); 		  
                DATE_TIME   = st.nextToken();		
			    EVENT  = st.nextToken();		
                EVENT_DESC     = st.nextToken();	
                CARD_NO = st.nextToken();				
                CARD_NAME = st.nextToken();				
                DEPT = st.nextToken();				
				EMP_NO = st.nextToken();				
				//out.println(CARD_NO); 
				//out.println(EVENT); 
				//out.println(DEPT); 
               
				String dbtelsSql="INSERT INTO  daily_tmp VALUES ('"+DATE_TIME+"','"+EVENT+"', '"+EVENT_DESC+"', '"+CARD_NO+"', '"+ CARD_NAME +"' , '"+ DEPT+"','"+ EMP_NO+"'  )"; 
				//String dbtelsSql="INSERT INTO  daily_tmp  (DATE_TIME,EVENT,EVENT_DESC ,CARD_NO,CARD_NAME) VALUES ('"+DATE_TIME+"','"+EVENT+"', '"+EVENT_DESC+"', '"+CARD_NO+"', '"+ CARD_NAME +"' )"; 
                //out.println(dbtelsSql); 
                insertResults = stmt.executeUpdate(dbtelsSql);
              
			   }
              }
            //bpcscon.commit();
            inputStream.close();
            stmt.close();
            
           }	// end try
	      catch (Exception e)
	      {
		     out.println("Exception:"+e.getMessage());				
	       }   

          try
         {      
		    Statement stateMicro=ifxmicrocon.createStatement();
            String sSqlMicro="select * from daily_tmp "+
                                        "where substr(DATE_TIME,0,10) ='"+dateYYYYMMDD+"' ";  
			ResultSet rsMicro=stateMicro.executeQuery(sSqlMicro);  
		    if(rsMicro.next())
			{   // 已經存在選擇日出勤資料,先刪除後新增
			         PreparedStatement stMicro = ifxmicrocon.prepareStatement("delete from  daily_tmp where  substr(DATE_TIME,0,10) = '"+dateYYYYMMDD+"' "); 
		             stMicro.executeUpdate();           
	    	         stMicro.close();
			}
			rsMicro.close();
			stateMicro.close();			
			
		    
                       Statement statement=bpcscon.createStatement();
                       String sSql="select trim(date_time) as date_time, trim(event) as event,trim(event_desc) as event_desc,"+
                                         "trim(card_no) as card_no,trim(card_name) as card_name,"+
                                         "trim(dept) as dept,trim(emp_no) as emp_no "+
                                         "from daily_tmp"+
                                        " where trim(dept)='部門:研能科技'"; 
                               //out.println(sSql); 
                      ResultSet rs=statement.executeQuery(sSql);
  
                      while (rs.next())
                     {   
                         String microSql="insert into daily_tmp  values(?,?,?,?,?,?,?)";  
                         //String microSql="insert into daily_tmp DATE_TIME,EVENT,EVENT_DESC,CARD_NO,CARD_NAME,DEPT, values(?,?,?,?,?,?)";   
                         //out.println(microSql); 
                         PreparedStatement microstmt=ifxmicrocon.prepareStatement(microSql);     
                         microstmt.setString(1,rs.getString("date_time"));
                         microstmt.setString(2,rs.getString("event"));  
                         microstmt.setString(3,rs.getString("event_desc"));
                         microstmt.setString(4,rs.getString("card_no"));  
                         microstmt.setString(5,rs.getString("card_name"));    
                         microstmt.setString(6,rs.getString("dept"));
                         microstmt.setString(7,rs.getString("emp_no"));   
	
                         microstmt.executeUpdate();  
                         microstmt.close();   
                     }
	                 rs.close();
	                 statement.close();
		  
	     	         PreparedStatement stdel = bpcscon.prepareStatement("delete from  daily_tmp "); 
		             stdel.executeUpdate();           
	    	         stdel.close();
			
			

       }	// end try
	   catch (Exception e)
	   {
		     out.println("Exception:"+e.getMessage());				
	   } 

	   
	}  // End of if (url1!=null)
	else {
	        // out.println("伺服器連線卡鐘出勤工作站異常,請洽管理員重新設定連線 !!! ");   
	       }
	
}	// end try
 catch (Exception e)
 {
		    // out.println("Exception:"+e.getMessage());							
			 out.println("伺服器連線卡鐘出勤工作站異常,請洽管理員重新設定連線 !!! ");   
 }     


       

%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSMicroPage.jsp"%>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%//@ include file="/jsp/include/ReleaseConnPage.jsp"%>
