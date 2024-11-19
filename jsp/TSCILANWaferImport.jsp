<html>
<head>
<title>TSC ILAN Wafer Testing Data Import </title>

</head>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>

<%@ page language="java" import="javazoom.upload.*,java.sql.*,java.util.*,java.text.*" %>
<%@ page language="java" import="java.io.*,java.io.File,jxl.*" %>
<%@ page language="java" import="jxl.write.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>

<!--===========Change the directory location below ======================-->
<jsp:useBean id="fileMover" scope="page" class="uploadutilities.FileMover" />
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
  <jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCWaferImport/" />
  <jsp:setProperty name="upBean" property="overwrite" value="true" />
  <% upBean.addUploadListener(fileMover); %>
</jsp:useBean>

<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>

<!--  File Mover Bean is instantiated before the uploadBean to that it can be used as a
      listener for the upload Bean.
      NOTE:  FolderStore Property of the uploadBean is used by the filemover as the location
      to save the file.  Don't forget to modify this property to reflect a valid
      directory on your server.
-->
<%!
String replace(String s, String one, String another) {
// In a string replace one substring with another
  if (s.equals("")) return "";
  String res = "";
  int i = s.indexOf(one,0);
  int lastpos = 0;
  while (i != -1) {
    res += s.substring(lastpos,i) + another;
    lastpos = i + one.length();
    i = s.indexOf(one,lastpos);
  }
  res += s.substring(lastpos);  // the rest
  return res;  
}
%>
<% 
 String uploadFlag=request.getParameter("UPLOADFLAG");
%>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<ul><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">

<%
      if (MultipartFormDataRequest.isMultipartFormData(request))  {
        // Rename the file name with the following rule.
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        fileMover.setNewfilename("TSCILANWaferImport_"+sdf.format(new java.util.Date())+".xls");
        // Uses MultipartFormDataRequest to parse the HTTP request.
        MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
        String todo = mrequest.getParameter("todo");
        if ( (todo != null) && (todo.equalsIgnoreCase("upload")) )  {
          Hashtable files = mrequest.getFiles();
          if ( (files != null) || (!files.isEmpty()) )  {
            UploadFile file = (UploadFile) files.get("uploadfile");

            // The store method must be invoked to trigger the fileMover
            // Object's fileUploaded() callback function.  This is the function
            // That actually writes the file to disk.

            upBean.store(mrequest, "uploadfile");

            // Modified this slightly to retrieve the filename from the fileMover object.
            // The same could be done for the file size.

            out.println("<li>Form field : uploadfile"+"<BR> Uploaded file : " +
                                  fileMover.getFileName() + " (" + file.getFileSize() +
                                  " bytes)" + "<BR> Content Type : " + file.getContentType());

         // Change the directory location below
         Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCWaferImport/"+fileMover.getFileName()));
   
         Sheet sheet = rw.getSheet(0);
 
         // 眔 Wafer у腹

         Cell   cellwaferlotno   = sheet.getCell(1,1);
         String WaferLotNo       = cellwaferlotno.getContents();

         // 眔代刚兵ン

         // VF 
         Cell cellvf            = sheet.getCell(0,3);
         Cell cellif1a_vf       = sheet.getCell(0,4);
         Cell celltms1_vf       = sheet.getCell(0,5);
         Cell cellif2a_vf       = sheet.getCell(0,6);
         Cell celltms2_vf       = sheet.getCell(0,7);
         Cell cellif3a_vf       = sheet.getCell(0,8);
         Cell celltms3_vf       = sheet.getCell(0,9);
         Cell cellvf1lmv_vf     = sheet.getCell(2,4);
         Cell cellvf1hmv_vf     = sheet.getCell(2,5);
         Cell cellvf2lmv_vf     = sheet.getCell(2,6);
         Cell cellvf2hmv_vf     = sheet.getCell(2,7);
         Cell cellvf3lmv_vf     = sheet.getCell(2,8);
         Cell cellvf3hmv_vf     = sheet.getCell(2,9);

         String VF              = cellvf.getContents();
         String IF1A_VF         = cellif1a_vf.getContents();
         String TMS1_VF         = celltms1_vf.getContents();
         String IF2A_VF         = cellif2a_vf.getContents();
         String TMS2_VF         = celltms2_vf.getContents();
         String IF3A_VF         = cellif3a_vf.getContents();
         String TMS3_VF         = celltms3_vf.getContents();
         String VF1LMV_VF       = cellvf1lmv_vf.getContents();
         String VF1HNV_VF       = cellvf1hmv_vf.getContents();
         String VF2LMV_VF       = cellvf2lmv_vf.getContents();
         String VF2HMV_VF       = cellvf2hmv_vf.getContents();
         String VF3LMV_VF       = cellvf3lmv_vf.getContents();
         String VF3HMV_VF       = cellvf3hmv_vf.getContents();

         //out.println(VF+"-"+IF1A_VF+"-"+TMS1_VF+"-"+IF2A_VF+"-"+TMS2_VF+"-"+IF3A_VF+"-"+TMS3_VF+"-"+VF1LMV_VF+"-"+VF1HNV_VF+"-"+VF2LMV_VF+"-"+VF2HMV_VF+"-"+VF3LMV_VF+"-"+VF3HMV_VF);

         Cell cellif1a_vf_v     = sheet.getCell(1,4);
         Cell celltms1_vf_v     = sheet.getCell(1,5);
         Cell cellif2a_vf_v     = sheet.getCell(1,6);
         Cell celltms2_vf_v     = sheet.getCell(1,7);
         Cell cellif3a_vf_v     = sheet.getCell(1,8);
         Cell celltms3_vf_v     = sheet.getCell(1,9);
         Cell cellvf1lmv_vf_v   = sheet.getCell(3,4);
         Cell cellvf1hmv_vf_v   = sheet.getCell(3,5);
         Cell cellvf2lmv_vf_v   = sheet.getCell(3,6);
         Cell cellvf2hmv_vf_v   = sheet.getCell(3,7);
         Cell cellvf3lmv_vf_v   = sheet.getCell(3,8);
         Cell cellvf3hmv_vf_v   = sheet.getCell(3,9);

         String IF1A_VF_V         = cellif1a_vf_v.getContents();
         String TMS1_VF_V         = celltms1_vf_v.getContents();
         String IF2A_VF_V         = cellif2a_vf_v.getContents();
         String TMS2_VF_V         = celltms2_vf_v.getContents();
         String IF3A_VF_V         = cellif3a_vf_v.getContents();
         String TMS3_VF_V         = celltms3_vf_v.getContents();
         String VF1LMV_VF_V       = cellvf1lmv_vf_v.getContents();
         String VF1HNV_VF_V       = cellvf1hmv_vf_v.getContents();
         String VF2LMV_VF_V       = cellvf2lmv_vf_v.getContents();
         String VF2HMV_VF_V       = cellvf2hmv_vf_v.getContents();
         String VF3LMV_VF_V       = cellvf3lmv_vf_v.getContents();
         String VF3HMV_VF_V       = cellvf3hmv_vf_v.getContents();

         //out.println(VF+"-"+IF1A_VF_V+"-"+TMS1_VF_V+"-"+IF2A_VF_V+"-"+TMS2_VF_V+"-"+IF3A_VF_V+"-"+TMS3_VF_V+"-"+VF1LMV_VF_V+"-"+VF1HNV_VF_V+"-"+VF2LMV_VF_V+"-"+VF2HMV_VF_V+"-"+VF3LMV_VF_V+"-"+VF3HMV_VF_V);

         // VZ 
         Cell cellvz            = sheet.getCell(0,12);
         Cell celliz1ma_vz      = sheet.getCell(0,13);
         Cell celltms1_vz       = sheet.getCell(0,14);
         Cell celliz2ma_vz      = sheet.getCell(0,15);
         Cell celltms2_vz       = sheet.getCell(0,16);
         Cell celliz3ma_vz      = sheet.getCell(0,17);
         Cell celltms3_vz       = sheet.getCell(0,18);
         Cell cellvz1lv_vz      = sheet.getCell(2,13);
         Cell cellvz1hv_vz      = sheet.getCell(2,14);
         Cell cellvz2lv_vz      = sheet.getCell(2,15);
         Cell cellvz2hv_vz      = sheet.getCell(2,16);
         Cell cellvfdvz1v_vz    = sheet.getCell(2,17);
         Cell cellvfdvz2v_vz    = sheet.getCell(2,18);

         String VZ              = cellvz.getContents();
         String IZ1MA_VZ        = celliz1ma_vz.getContents();
         String TMS1_VZ         = celltms1_vz.getContents();
         String IZ2MA_VZ        = celliz2ma_vz.getContents();
         String TMS2_VZ         = celltms2_vz.getContents();
         String IZ3MA_VZ        = celliz3ma_vz.getContents();
         String TMS3_VZ         = celltms3_vz.getContents();
         String VZ1LV_VZ        = cellvz1lv_vz.getContents();
         String VZ1HV_VZ        = cellvz1hv_vz.getContents();
         String VZ2LV_VZ        = cellvz2lv_vz.getContents();
         String VZ2HV_VZ        = cellvz2hv_vz.getContents();
         String VFDVZ1V_VZ      = cellvfdvz1v_vz.getContents();
         String VFDVZ2V_VZ      = cellvfdvz2v_vz.getContents();

         Cell celliz1ma_vz_v    = sheet.getCell(1,13);
         Cell celltms1_vz_v     = sheet.getCell(1,14);
         Cell celliz2ma_vz_v    = sheet.getCell(1,15);
         Cell celltms2_vz_v     = sheet.getCell(1,16);
         Cell celliz3ma_vz_v    = sheet.getCell(1,17);
         Cell celltms3_vz_v     = sheet.getCell(1,18);
         Cell cellvz1lv_vz_v    = sheet.getCell(3,13);
         Cell cellvz1hv_vz_v    = sheet.getCell(3,14);
         Cell cellvz2lv_vz_v    = sheet.getCell(3,15);
         Cell cellvz2hv_vz_v    = sheet.getCell(3,16);
         Cell cellvfdvz1v_vz_v  = sheet.getCell(3,17);
         Cell cellvfdvz2v_vz_v  = sheet.getCell(3,18);

         String IZ1MA_VZ_V        = celliz1ma_vz_v.getContents();
         String TMS1_VZ_V         = celltms1_vz_v.getContents();
         String IZ2MA_VZ_V        = celliz2ma_vz_v.getContents();
         String TMS2_VZ_V         = celltms2_vz_v.getContents();
         String IZ3MA_VZ_V        = celliz3ma_vz_v.getContents();
         String TMS3_VZ_V         = celltms3_vz_v.getContents();
         String VZ1LV_VZ_V        = cellvz1lv_vz_v.getContents();
         String VZ1HV_VZ_V        = cellvz1hv_vz_v.getContents();
         String VZ2LV_VZ_V        = cellvz2lv_vz_v.getContents();
         String VZ2HV_VZ_V        = cellvz2hv_vz_v.getContents();
         String VFDVZ1V_VZ_V      = cellvfdvz1v_vz_v.getContents();
         String VFDVZ2V_VZ_V      = cellvfdvz2v_vz_v.getContents();

         //VB1/IR1
         Cell cellvb1ir1        = sheet.getCell(0,21);
         Cell cellib1ma_vb      = sheet.getCell(0,22);
         Cell celltms1_vb       = sheet.getCell(0,23);
         Cell cellib2ma_vb      = sheet.getCell(0,24);
         Cell celltms2_vb       = sheet.getCell(0,25);
         Cell cellvb1lv_vb      = sheet.getCell(2,22);
         Cell cellvb1hv_vb      = sheet.getCell(2,23);
         Cell cellir1lua_vb     = sheet.getCell(2,24);
         Cell cellir1hua_vb     = sheet.getCell(2,25);
         
         String VB1IR1          = cellvb1ir1.getContents();
         String IB1MA_VB        = cellib1ma_vb.getContents();
         String TMS1_VB         = celltms1_vb.getContents();
         String IB2MA_VB        = cellib2ma_vb.getContents();
         String TMS2_VB         = celltms2_vb.getContents();
         String VB1LV_VB        = cellvb1lv_vb.getContents();
         String VB1HV_VB        = cellvb1hv_vb.getContents();
         String IR1LUA_VB       = cellir1lua_vb.getContents();
         String IR1HUA_VB       = cellir1hua_vb.getContents();   

         Cell cellib1ma_vb_v    = sheet.getCell(1,22);
         Cell celltms1_vb_v     = sheet.getCell(1,23);
         Cell cellib2ma_vb_v    = sheet.getCell(1,24);
         Cell celltms2_vb_v     = sheet.getCell(1,25);
         Cell cellvb1lv_vb_v    = sheet.getCell(3,22);
         Cell cellvb1hv_vb_v    = sheet.getCell(3,23);
         Cell cellir1lua_vb_v   = sheet.getCell(3,24);
         Cell cellir1hua_vb_v   = sheet.getCell(3,25);

         String IB1MA_VB_V        = cellib1ma_vb_v.getContents();
         String TMS1_VB_V         = celltms1_vb_v.getContents();
         String IB2MA_VB_V        = cellib2ma_vb_v.getContents();
         String TMS2_VB_V         = celltms2_vb_v.getContents();
         String VB1LV_VB_V        = cellvb1lv_vb_v.getContents();
         String VB1HV_VB_V        = cellvb1hv_vb_v.getContents();
         String IR1LUA_VB_V       = cellir1lua_vb_v.getContents();
         String IR1HUA_VB_V       = cellir1hua_vb_v.getContents();   

         //IR2/IR3
         Cell cellir2ir3        = sheet.getCell(0,30);
         Cell cellvr2v_ir       = sheet.getCell(0,31);
         Cell celltms1_ir       = sheet.getCell(0,32);
         Cell cellvr3v_ir       = sheet.getCell(0,33);
         Cell celltms2_ir       = sheet.getCell(0,34);
         Cell cellir2lua_ir     = sheet.getCell(2,31);
         Cell cellir2hua_ir     = sheet.getCell(2,32);
         Cell cellir3lua_ir     = sheet.getCell(2,33);
         Cell cellir3hua_ir     = sheet.getCell(2,34);
         
         String IR2IR3          = cellir2ir3.getContents();
         String VR2V_IR         = cellvr2v_ir.getContents();   
         String TMS1_IR         = celltms1_ir.getContents();
         String VR3V_IR         = cellvr3v_ir.getContents();
         String TMS2_IR         = celltms2_ir.getContents();
         String IR2LUA_IR       = cellir2lua_ir.getContents();
         String IR2HUA_IR       = cellir2hua_ir.getContents();
         String IR3LUA_IR       = cellir3lua_ir.getContents();
         String IR3HUA_IR       = cellir3hua_ir.getContents();


         Cell cellvr2v_ir_v     = sheet.getCell(1,31);
         Cell celltms1_ir_v     = sheet.getCell(1,32);
         Cell cellvr3v_ir_v     = sheet.getCell(1,33);
         Cell celltms2_ir_v     = sheet.getCell(1,34);
         Cell cellir2lua_ir_v   = sheet.getCell(3,31);
         Cell cellir2hua_ir_v   = sheet.getCell(3,32);
         Cell cellir3lua_ir_v   = sheet.getCell(3,33);
         Cell cellir3hua_ir_v   = sheet.getCell(3,34);

         String VR2V_IR_V         = cellvr2v_ir_v.getContents();   
         String TMS1_IR_V         = celltms1_ir_v.getContents();
         String VR3V_IR_V         = cellvr3v_ir_v.getContents();
         String TMS2_IR_V         = celltms2_ir_v.getContents();
         String IR2LUA_IR_V       = cellir2lua_ir_v.getContents();
         String IR2HUA_IR_V       = cellir2hua_ir_v.getContents();
         String IR3LUA_IR_V       = cellir3lua_ir_v.getContents();
         String IR3HUA_IR_V       = cellir3hua_ir_v.getContents();

         //VB2/IR4
         Cell cellvb2ir4        = sheet.getCell(0,39);
         Cell cellib2ma_vb2     = sheet.getCell(0,40);
         Cell celltms1_vb2      = sheet.getCell(0,41);
         Cell cellib3ma_vb2     = sheet.getCell(0,42);
         Cell celltms2_vb2      = sheet.getCell(0,43);
         Cell cellvb2lv_vb2     = sheet.getCell(2,40);
         Cell cellvb2hv_vb2     = sheet.getCell(2,41);
         Cell cellir4lua_vb2    = sheet.getCell(2,42);
         Cell cellir4hua_vb2    = sheet.getCell(2,43);

         String VB2IR4          = cellvb2ir4.getContents();
         String IB2MA_VB2       = cellib2ma_vb2.getContents();
         String TMS1_VB2        = celltms1_vb2.getContents();
         String IB3MA_VB2       = cellib3ma_vb2.getContents();
         String TMS2_VB2        = celltms2_vb2.getContents();
         String VB2LV_VB2       = cellvb2lv_vb2.getContents();
         String VB2HV_VB2       = cellvb2hv_vb2.getContents();
         String IR4LUA_VB2      = cellir4lua_vb2.getContents();
         String IR4HUA_VB2      = cellir4hua_vb2.getContents();

         Cell cellib2ma_vb2_v     = sheet.getCell(1,40);
         Cell celltms1_vb2_v      = sheet.getCell(1,41);
         Cell cellib3ma_vb2_v     = sheet.getCell(1,42);
         Cell celltms2_vb2_v      = sheet.getCell(1,43);
         Cell cellvb2lv_vb2_v     = sheet.getCell(3,40);
         Cell cellvb2hv_vb2_v     = sheet.getCell(3,41);
         Cell cellir4lua_vb2_v    = sheet.getCell(3,42);
         Cell cellir4hua_vb2_v    = sheet.getCell(3,43);

         String IB2MA_VB2_V       = cellib2ma_vb2_v.getContents();
         String TMS1_VB2_V        = celltms1_vb2_v.getContents();
         String IB3MA_VB2_V       = cellib3ma_vb2_v.getContents();
         String TMS2_VB2_V        = celltms2_vb2_v.getContents();
         String VB2LV_VB2_V       = cellvb2lv_vb2_v.getContents();
         String VB2HV_VB2_V       = cellvb2hv_vb2_v.getContents();
         String IR4LUA_VB2_V      = cellir4lua_vb2_v.getContents();
         String IR4HUA_VB2_V      = cellir4hua_vb2_v.getContents();

         //IR5/IR6
         Cell cellir5ir6        = sheet.getCell(0,48);
         Cell cellvr5v_ir5      = sheet.getCell(0,49);
         Cell celltms1_ir5      = sheet.getCell(0,50);
         Cell cellvr6v_ir5      = sheet.getCell(0,51);
         Cell celltms2_ir5      = sheet.getCell(0,52);
         Cell cellir5lua_ir5    = sheet.getCell(2,49);
         Cell cellir5hua_ir5    = sheet.getCell(2,50);
         Cell cellir6lua_ir5    = sheet.getCell(2,51);
         Cell cellir6hua_ir5    = sheet.getCell(2,52);

         String IR5IR6          = cellir5ir6.getContents();
         String VR5V_IR5        = cellvr5v_ir5.getContents();
         String TMS1_IR5        = celltms1_ir5.getContents();
         String VR6V_IR5        = cellvr6v_ir5.getContents();
         String TMS2_IR5        = celltms2_ir5.getContents();
         String IR5LUA_IR5      = cellir5lua_ir5.getContents();
         String IR5HUA_IR5      = cellir5hua_ir5.getContents();
         String IR6LUA_IR5      = cellir6lua_ir5.getContents();
         String IR6HUA_IR5      = cellir6hua_ir5.getContents();

         Cell cellvr5v_ir5_v      = sheet.getCell(1,49);
         Cell celltms1_ir5_v      = sheet.getCell(1,50);
         Cell cellvr6v_ir5_v      = sheet.getCell(1,51);
         Cell celltms2_ir5_v      = sheet.getCell(1,52);
         Cell cellir5lua_ir5_v    = sheet.getCell(3,49);
         Cell cellir5hua_ir5_v    = sheet.getCell(3,50);
         Cell cellir6lua_ir5_v    = sheet.getCell(3,51);
         Cell cellir6hua_ir5_v    = sheet.getCell(3,52);

         String VR5V_IR5_V        = cellvr5v_ir5_v.getContents();
         String TMS1_IR5_V        = celltms1_ir5_v.getContents();
         String VR6V_IR5_V        = cellvr6v_ir5_v.getContents();
         String TMS2_IR5_V        = celltms2_ir5_v.getContents();
         String IR5LUA_IR5_V      = cellir5lua_ir5_v.getContents();
         String IR5HUA_IR5_V      = cellir5hua_ir5_v.getContents();
         String IR6LUA_IR5_V      = cellir6lua_ir5_v.getContents();
         String IR6HUA_IR5_V      = cellir6hua_ir5_v.getContents();

         // 更戈畐 ORADDMAN.TSCIQC_LOTDRAWING_HEADER


        String sql="insert into ORADDMAN.TSCIQC_LOTDRAWING_HEADER("+
                   "VND_LOT_NUM,VF_IF1,IF1_T,VF_IF2,IF2_T,VF_IF3,IF3_T,VF1L,VF1H,VF2L,VF2H,VF3L,VF3H,"+
                   "VZ_IZ1,IZ1_T,VZ_IZ2,IZ2_T,VZ_IZ3,IZ3_T,VZ1L,VZ1H,VZ2L,VZ2H,DVZ1,DVZ2,"+
                   "VB1_IR1_IB1,IB1_T,VB1_IR1_IR1,IR1_T,VB1L,VB1H,IR1L,IR1H,"+
                   "IR2_IR3_VR2,VR2_T,IR2_IR3_VR3,VR3_T,IR2L,IR2H,IR3L,IR3H,"+
                   "VB2_IR4_IB2,IB2_T,VB2_IR4_IR4,IR4_T,VB2L,VB2H,IR4L,IR4H,"+
                   "IR5_IR6_VR5,VR5_T,IR5_IR6_VR6,VR6_T,IR5L,IR5H,IR6L,IR6H)"+
                   " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
                           "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";           
               PreparedStatement pstmt=con.prepareStatement(sql);
                                 pstmt.setString(1,WaferLotNo);
                                 pstmt.setString(2,IF1A_VF_V);  
                                 pstmt.setString(3,TMS1_VF_V);
                                 pstmt.setString(4,IF2A_VF_V);  
                                 pstmt.setString(5,TMS2_VF_V);
                                 pstmt.setString(6,IF3A_VF_V);
                                 pstmt.setString(7,TMS3_VF_V);             
                                 pstmt.setString(8,VF1LMV_VF_V);
                                 pstmt.setString(9,VF1HNV_VF_V);   
	                         pstmt.setString(10,VF2LMV_VF_V); 
	                         pstmt.setString(11,VF2HMV_VF_V);
                                 pstmt.setString(12,VF3LMV_VF_V);  
                                 pstmt.setString(13,VF3HMV_VF_V);
                                 pstmt.setString(14,IZ1MA_VZ_V);  
                                 pstmt.setString(15,TMS1_VZ_V);
                                 pstmt.setString(16,IZ2MA_VZ_V);
                                 pstmt.setString(17,TMS2_VZ_V);             
                                 pstmt.setString(18,IZ3MA_VZ_V);
                                 pstmt.setString(19,TMS3_VZ_V);   
	                         pstmt.setString(20,VZ1LV_VZ_V); 
	                         pstmt.setString(21,VZ1HV_VZ_V);
                                 pstmt.setString(22,VZ2LV_VZ_V);  
                                 pstmt.setString(23,VZ2HV_VZ_V);
                                 pstmt.setString(24,VFDVZ1V_VZ_V);  
                                 pstmt.setString(25,VFDVZ2V_VZ_V);
                                 pstmt.setString(26,IB1MA_VB_V);
                                 pstmt.setString(27,TMS1_VB_V);             
                                 pstmt.setString(28,IB2MA_VB_V);
                                 pstmt.setString(29,TMS2_VB_V);   
	                         pstmt.setString(30,VB1LV_VB_V); 
	                         pstmt.setString(31,VB1HV_VB_V);
                                 pstmt.setString(32,IR1LUA_VB_V);  
                                 pstmt.setString(33,IR1HUA_VB_V);
                                 pstmt.setString(34,VR2V_IR_V);  
                                 pstmt.setString(35,TMS1_IR_V);
                                 pstmt.setString(36,VR3V_IR_V);
                                 pstmt.setString(37,TMS2_IR_V);             
                                 pstmt.setString(38,IR2LUA_IR_V);
                                 pstmt.setString(39,IR2HUA_IR_V);   
	                         pstmt.setString(40,IR3LUA_IR_V); 
	                         pstmt.setString(41,IR3HUA_IR_V);
                                 pstmt.setString(42,IB2MA_VB2_V);  
                                 pstmt.setString(43,TMS1_VB2_V);
                                 pstmt.setString(44,IB3MA_VB2_V);  
                                 pstmt.setString(45,TMS2_VB2_V);
                                 pstmt.setString(46,VB2LV_VB2_V);
                                 pstmt.setString(47,VB2HV_VB2_V);             
                                 pstmt.setString(48,IR4LUA_VB2_V);
                                 pstmt.setString(49,IR4HUA_VB2_V);   
	                         pstmt.setString(50,VR5V_IR5_V); 
	                         pstmt.setString(51,TMS1_IR5_V);
                                 pstmt.setString(52,VR6V_IR5_V);  
                                 pstmt.setString(53,TMS2_IR5_V);
                                 pstmt.setString(54,IR5LUA_IR5_V);  
                                 pstmt.setString(55,IR5HUA_IR5_V);
                                 pstmt.setString(56,IR6LUA_IR5_V);
                                 pstmt.setString(57,IR6HUA_IR5_V);             
                                 pstmt.executeUpdate();
                                 pstmt.close();


         // 眔代刚计沮
        
         Cell cellrecordno   = null;
         Cell celltesterno   = null;
         Cell cellbinno      = null;
         Cell cellattribute1 = null;
         Cell cellattribute2 = null;
         Cell cellattribute3 = null;
         Cell cellattribute4 = null;
         Cell cellattribute5 = null;
         Cell cellattribute6 = null;
         Cell cellattribute7 = null;
         Cell cellattribute8 = null;

         String    RecordNo     = null;
         String    TesterNo     = null;
         String    BinNo        = null;
         String    Attribute1   = null;
         String    Attribute2   = null;
         String    Attribute3   = null;
         String    Attribute4   = null;
         String    Attribute5   = null;
         String    Attribute6   = null;
         String    Attribute7   = null;
         String    Attribute8   = null;

         // Set first array

         String oneDArray[]= {"","Wafer Lot No.","RecordNo","TesterNo","BinNo","VF2(mV)","VZ1(V)","DV1(V)","IR2(uA)","VF2 R(mV)","VZ1 R(V)","DV1 R(V)","IR2 R(uA)"}; 		 	     			  
         arrayRFQDocumentInputBean.setArrayString(oneDArray);
	         
         int rows    = sheet.getRows(); 
         int columns = sheet.getColumns(); 

         out.println(rows);
         out.println(columns);

         String iNo=null;
         int itemCNTsub[]             = new int[rows];
         String b[][]                 = new String[rows][columns+1];
         
         for( int i=0 ; i< rows-59 ; i++ )
         {
  
            //attention: The first parameter is column,the second parameter is row.  



             cellrecordno   = sheet.getCell(0,i+59);
             celltesterno   = sheet.getCell(1,i+59);
             cellbinno      = sheet.getCell(2,i+59);
             cellattribute1 = sheet.getCell(3,i+59);
             cellattribute2 = sheet.getCell(4,i+59);
             cellattribute3 = sheet.getCell(5,i+59);
             cellattribute4 = sheet.getCell(6,i+59);
             cellattribute5 = sheet.getCell(7,i+59);
             cellattribute6 = sheet.getCell(8,i+59);
             cellattribute7 = sheet.getCell(9,i+59);
             cellattribute8 = sheet.getCell(10,i+59);

             // Set CLASS_ID as contant

             String ClassID = "01";
             String SourceCode = "ILAN";
             RecordNo     = cellrecordno.getContents();
             TesterNo     = celltesterno.getContents();
             BinNo        = cellbinno.getContents();
             Attribute1   = cellattribute1.getContents();
             Attribute2   = cellattribute2.getContents();
             Attribute3   = cellattribute3.getContents();
             Attribute4   = cellattribute4.getContents();
             Attribute5   = cellattribute5.getContents();
             Attribute6   = cellattribute6.getContents();
             Attribute7   = cellattribute7.getContents();
             Attribute8   = cellattribute8.getContents();
            
             b[i][0]=WaferLotNo;
             b[i][1]=RecordNo;
             b[i][2]=TesterNo;
             b[i][3]=BinNo;
             b[i][4]=Attribute1;
             b[i][5]=Attribute2;
             b[i][6]=Attribute3;
             b[i][7]=Attribute4;
             b[i][8]=Attribute5;  
             b[i][9]=Attribute6;
             b[i][10]=Attribute7;
             b[i][11]=Attribute8;

        try
        {

        String sqll="insert into ORADDMAN.TSCIQC_LOTDRAWING_DETAIL("+
                   "VND_LOT_NUM,CLASS_ID,SOURCE_CODE,SEQ_NO,TESTER_NO,BIN_NO,VF2_MV,VZ1_V,DV1_V,IR2_UA,VF2R_MV,VZ1R_V,DV1R_V,IR2R_UA)"+
                   " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
              PreparedStatement pstmtl=con.prepareStatement(sqll);
                                pstmtl.setString(1,WaferLotNo);
                                pstmtl.setString(2,ClassID);
                                pstmtl.setString(3,SourceCode);
                                pstmtl.setString(4,RecordNo);
                                pstmtl.setString(5,TesterNo);
                                pstmtl.setString(6,BinNo);  
                                pstmtl.setString(7,Attribute1);
                                pstmtl.setString(8,Attribute2);  
                                pstmtl.setString(9,Attribute3);
                                pstmtl.setString(10,Attribute4);  
                                pstmtl.setString(11,Attribute5);
                                pstmtl.setString(12,Attribute6);  
                                pstmtl.setString(13,Attribute7);
                                pstmtl.setString(14,Attribute8);
                                pstmtl.executeUpdate();
                                pstmtl.close();    
        }
        catch (Exception e)
        {
         out.println("Exception:"+e.getMessage());
        }
					
             arrayRFQDocumentInputBean.setArray2DString(b);
             arrayRFQDocumentInputBean.setArray2DCheck(b);	

	 // 眔更︽计

         session.setAttribute("IMPORTRECORD",RecordNo);
	     	
       } // end of for loop
      
      // Close Excel file  
      rw.close();
     }
     else  {
            out.println("<li>No uploaded files");
           }
     }
     else out.println("<BR> todo="+todo);
     }
                       
%>
</font></ul>
<form method="post" action="TSCILANWaferImport.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

<% //TSCEBufferImport.jsp?UPLOADFLAG=Y

  String ImportRecord = (String)session.getAttribute("IMPORTRECORD");

  //String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//眔ヘ玡皚ず甧 		
 
  //if (q!=null) 
  //{//out.println("<BR>");		  
    //out.println(arrayRFQDocumentInputBean.getArray2DBufferString());
  //}		
                       		    		  	   		   
  if (uploadFlag == null) 
  {  }
  else if (uploadFlag == "Y" || uploadFlag.equals("Y"))
  { 
   String urlDir = "TSCWaferImportStatus.jsp?"+"IMPORTRECORD="+ImportRecord;
   response.sendRedirect(urlDir);
  }		
			
				   
%>
  <table width="60%" border="0" cellspacing="1" cellpadding="1" align="center">
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif"><b>Select
        TSC ILAN Wafer Test Excel Report to upload :</b></font></td>
    </tr>
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">
        <input type="file" name="uploadfile" size="50">
        </font></td>
    </tr>
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">
	<input type="hidden" name="todo" value="upload">
	
        <input type="submit" name="Submit" value="Upload">
        <input type="reset" name="Reset" value="Cancel">
        </font></td>
    </tr>
  </table>
</form>

<!--=============Release Database Connection==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
