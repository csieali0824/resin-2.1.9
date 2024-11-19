<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="DateBean"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Daily Transformation Product Structure to Data Model</title>
</head>

<body>
<%
    String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
    // 先刪除        
    try
    { 
              String sqlDModel="delete from DMADMIN.PRODSTRUC where TRANSDTIME < '"+strDateTime+"' ";   
               //out.println(seqSqlinf); 
              PreparedStatement seqstmt=dmcon.prepareStatement(sqlDModel); //out.println("Step1.1.2"); 
              seqstmt.executeUpdate();
              //seqno=seqkey+"-001";
              seqstmt.close();    
                       
    } //end of try
    catch (Exception e)
    {
     out.println("Exception:"+e.getMessage());		  
    }           

    // 後新增,相當於作資料更新... 

    try
    { 
          Statement stateProdModel=con.createStatement();
          // out.println("Step1=");
          String sqlProdModel = "select DISTINCT trim(PROJECTCODE) as PROJECTCODE, trim(SALESCODE) as SALESCODE, trim(MITEM) as MITEM, "+
                                "trim(COLORDESC) as COLORDESC, trim(RDDPT_NO) as RDDPT_NO, trim(LAUNCHDATE) as LAUNCHDATE, trim(DELAUNCHDATE) as DELAUNCHDATE "+
                                "from PIMASTER a, PRODMODEL b, PICOLOR_MASTER c, MRDPT d "+
                                "where a.PROJECTCODE = b.MPROJ and b.MCOLOR = c.COLORCODE and a.DESIGNHOUSE = d.RDDPT and b.MCOUNTRY='886' ";  //out.println("sqlGetItem="+sqlGetItem);
          ResultSet rsProdModel=stateProdModel.executeQuery(sqlProdModel);  
          while (rsProdModel.next())
          { 
              String itemDesc = "";      
              Statement stateItemDesc=bpcscon.createStatement();    
              String sqlItemDesc = "select trim(IDESC) as IDESC from IIM where IPROD = '"+rsProdModel.getString("MITEM")+"' ";
              ResultSet rsItemDesc=stateItemDesc.executeQuery(sqlItemDesc);
              if (rsItemDesc.next())  { itemDesc =rsItemDesc.getString("IDESC"); }  
              rsItemDesc.close();
              stateItemDesc.close();                         

              String sqlDataModel="insert into DMADMIN.PRODSTRUC(MODELNO,SALESNO,PRODNUM,PRODDESC,PRODCOL,DESGNHM,EFFDATE,DISDATE,TRANSDTIME) values(?,?,?,?,?,?,?,?,?)";   
               //out.println(seqSqlinf); 
              PreparedStatement seqstmt=dmcon.prepareStatement(sqlDataModel); //out.println("Step1.1.2");    
            
              //seqstmt.setString(1,"886"); out.println("Step1.2");
              seqstmt.setString(1,rsProdModel.getString("PROJECTCODE")); //out.println("Step1.2");
              seqstmt.setString(2,rsProdModel.getString("SALESCODE"));  // out.println("Step1.3");             
              seqstmt.setString(3,rsProdModel.getString("MITEM"));
              seqstmt.setString(4,itemDesc); // out.println("Step1.4");
              seqstmt.setString(5,rsProdModel.getString("COLORDESC"));// out.println("Step1.5");
              seqstmt.setString(6,rsProdModel.getString("RDDPT_NO")); //out.println("Step1.6");
              seqstmt.setString(7,rsProdModel.getString("LAUNCHDATE"));  // out.println("Step1.7");
              seqstmt.setString(8,rsProdModel.getString("DELAUNCHDATE"));
              seqstmt.setString(9,strDateTime); // out.println("Step1.8");             
              seqstmt.executeUpdate();
              //seqno=seqkey+"-001";
              seqstmt.close();       
          }  // End of While          
          rsProdModel.close();
          stateProdModel.close();                        
    } //end of try
    catch (Exception e)
    {
     out.println("Exception:"+e.getMessage());		  
    }   

%>
</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSDisttstPage.jsp"%-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
