<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.sql.*" %>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="java.sql.*,DateBean" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--%@ include file="/jsp/include/PageHeaderSwitch.jsp"%-->
<!--%@ page import="SalesDRQPageHeaderBean" %-->

<html>
<head>
<title>Main</title>

<style type="text/css">
A.menu {
	color: #000000;
	text-decoration:none;
}
A.bar {
	color: #FFFF00;
	text-decoration:none;
}

td {word-break: break-all;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

<%
if ((","+UserRoles+",").indexOf(",WW_FAE,")>=0)
{
	response.sendRedirect("../oradds/jsp/TSCQRAProductNoticeQuery.jsp");
}
%>
<script>
function mmLoadMenus() {
<%
String sLoc = "886";
String sLan = "zh_TW";
if (roles==null) roles = "''";if (UserRoles==null) UserRoles = "";
String mm_menu = "";

try {
	String sSql = "";
	//get module
	sSql = "SELECT DISTINCT MMODULE,MDESC,MSEQ FROM ORADDMAN.MENUMODULE,ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER "+
	" WHERE MMODULE=FMODULE AND FSHOW=1 "+
	" AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN ("+roles+")"+
	" ORDER BY MSEQ,MMODULE ";
	//out.println(sSql);
	Statement stMod=con.createStatement();
	ResultSet rsMod=stMod.executeQuery(sSql);
	while(rsMod.next()) {
		out.println("window.mm_menu_"+rsMod.getString("MMODULE")+" = new Menu('"+rsMod.getString("MDESC")+"',260,20,'',12,'#0000FF','#0000CC','#CCFFFF','#00CCFF','left','middle',3,0,1000,-5,7,true,true,true,0,true,true);");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".hideOnMouseOut=true;");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".bgColor='#555555';");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".menuBorder=1;");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".menuLiteBgColor='#FFFFFF';");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".menuBorderBgColor='#777777';");
	}// end while
	rsMod.close();
	stMod.close();
	// end get module
	//get function
	sSql = "SELECT DISTINCT FMODULE,FFUNCTION,FFUNCTION||'--'||FDESC AS FDESC,FADDRESS,FSEQ FROM ORADDMAN.MENUMODULE,ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER "+
	" WHERE MMODULE=FMODULE AND FSHOW=1 "+
	" AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN ("+roles+")"+
	" ORDER BY FSEQ,FFUNCTION ";
	//out.println(sSql);
	Statement stFun=con.createStatement();
	ResultSet rsFun=stFun.executeQuery(sSql);
	while(rsFun.next()) {
		out.println("mm_menu_"+rsFun.getString("FMODULE")+".addMenuItem("+'"'+rsFun.getString("FDESC")+'"'+","+'"'+"location="+"'"+rsFun.getString("FADDRESS")+"'"+'"'+");");
	} // end while
	rsFun.close();
	stFun.close();
	// end get function
	//get root
	sSql = "SELECT RROOT,RDESC FROM ORADDMAN.MENUROOT ORDER BY RSEQ,RROOT ";
	//out.println(sSql);
	Statement stRoot=con.createStatement();
	ResultSet rsRoot=stRoot.executeQuery(sSql);
	while (rsRoot.next()) {
		out.println("window.mm_menu_"+rsRoot.getString("RROOT")+" = new Menu('root',260,20,'',12,'#0000FF','#0000CC','#CCFFFF','#00CCFF','left','middle',3,0,1000,-5,7,true,true,true,0,true,true);");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".hideOnMouseOut=true;");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".bgColor='#555555';");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".menuBorder=1;");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".menuLiteBgColor='#FFFFFF';");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".menuBorderBgColor='#777777';");
		//get module
		sSql = "SELECT DISTINCT MMODULE,MDESC,MSEQ FROM ORADDMAN.MENUMODULE,ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER "+
		" WHERE MMODULE=FMODULE AND FSHOW=1 "+
		" AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN ("+roles+")"+
		" AND MROOT='"+rsRoot.getString("RROOT")+"'"+
		" ORDER BY MSEQ,MMODULE ";
		//out.println(sSql);
		stMod=con.createStatement();
		rsMod=stMod.executeQuery(sSql);
		boolean isEmpty = !rsMod.next();
		if (isEmpty) {
			out.println("mm_menu_"+rsRoot.getString("RROOT")+".addMenuItem('空');");
		} else {
			while (!isEmpty) {			
				out.println("mm_menu_"+rsRoot.getString("RROOT")+".addMenuItem(mm_menu_"+rsMod.getString("MMODULE")+");");
				isEmpty = !rsMod.next();
			} // end while
		} // end if
		rsMod.close();
		stMod.close();
		//
		mm_menu = rsRoot.getString("RROOT"); // 找一個menu來write
		//	
	} // end while root
	rsRoot.close();
	stRoot.close();
	//
	out.println("window.mm_menu_"+mm_menu+".writeMenus();");

} catch (Exception ee) {
	out.println("Exception:"+ee.getMessage());
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
}
%>


} // mmLoadMenus
</script>
<script src="mm_menu.js"></script>

<body>


<script>mmLoadMenus();</script>
<%//=UserName%>
<%//=UserRoles%>
<%//=roles%>
<%//=flag%>
<FORM name="MAINFORM" action="../ORAddsMainMenu.jsp" method="post" target="_blank">
<%
  String langCh=request.getParameter("LANGCH");
  String userId = ""; 
  String encryptPassword = ""; 
  String decryptPassword = ""; 
  String userName = ""; 
  String sqlSSO = ""; 
  
  if (langCh==null) langCh = "zh-tw";
    
  //由Oracle ERP 中的 fnd_user 取得該使用者加密後的密碼
  Statement stmtSSO=con.createStatement(); 
  sqlSSO ="select * from fnd_user where ( user_name = '%"+UserName+"%' or lower(user_name)='"+UserName+"' or upper(user_name)='"+UserName+"') "; 
  //out.println("sqlSSO="+sqlSSO);
  ResultSet rsSSO = stmtSSO.executeQuery(sqlSSO);   
  while (rsSSO.next()) 
  { 
    userId = rsSSO.getString("USER_NAME"); 
    encryptPassword = rsSSO.getString("ENCRYPTED_USER_PASSWORD"); 
  } 
  rsSSO.close();
  stmtSSO.close();

  //透過Oracle ERP 的API 將加密後的密碼轉成未加密的密碼 
  oracle.apps.fnd.security.AolSecurity aolsec=new oracle.apps.fnd.security.AolSecurity(); 
  decryptPassword = aolsec.decrypt("APPS",encryptPassword); 
  //out.println("userId="+userId);
  //out.println("decryptPassword="+decryptPassword);

%>
<table width="770" align="center">
<!-- 上半部 -->
<tr>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
	<td colspan="2" width="700" height="100%" background="image/top-bd.jpg"><img src="image/logo.JPG" height="54"></td>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>

</tr>
<tr>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
	<td colspan="2" bgcolor="#0F67AE">
		<table width="240">
			<tr>
				<%
				
				if(flag.equals("ok")) { // 表示是用NOTES的認證
				} else 
				{ // 表示是用本系統自己的認證
				session.setAttribute("UNME1",UserName.toUpperCase());				
				%>
				<td width="70" align="center" nowrap><font size="-1" face="Arial" color="#FFFFFF"><a href="./jsp/indexCHPW.jsp?LANGCH=<%=langCh%>" class="bar">				                                                                            
				<%  if (langCh.equals("zh-tw")) 
	                {
		              out.println("修改密碼");
		            } else if (langCh.equals("zh-cn"))
		                   {
			                 out.println("修改口令");
			               } else if (langCh.equals("en-us"))
			                      { 
			                       out.println("Change Password");  
			                      }	
	            %>																		</a></font></td>
				<td width="4"><img src="image/line.gif" border="0" width="3" height="20"></td>
				<%
				} // end if
				%>
				<td width="70" align="center"><font size="-1" face="Arial" color="#FFFFFF"><a href="./jsp/Logout.jsp" class="bar">				                                                                           
				 <%  if (langCh.equals("zh-tw")) 
	                 {
		              out.println("登出");
		             } else if (langCh.equals("zh-cn"))
		                    {
			                 out.println("注销");
			                } else if (langCh.equals("en-us"))
			                      { 
			                       out.println("Logout");  
			                      }	
	             %>	
				</a></font></td>
				<td></td>
			</tr>
		</table>
	</td>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
</tr>
<!-- 下半部 -->
<tr>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
	<!-- 左半部 -->
	<td width="30%" valign="top">
		<table width="100%">
		<%
		String sSql = "";
		sSql = "SELECT RROOT,RDESC FROM ORADDMAN.MENUROOT ORDER BY RSEQ,RROOT ";
		Statement stRoot=con.createStatement();
		ResultSet rsRoot=stRoot.executeQuery(sSql);
		while (rsRoot.next()) {
		%>
			<tr>
				<td>
				<font size="-1" face="Arial">
				<a href="#" name="link<%=rsRoot.getString("RROOT")%>" id="link<%=rsRoot.getString("RROOT")%>" class="menu" onMouseOver="MM_showMenu(window.mm_menu_<%=rsRoot.getString("RROOT")%>,90,0,null,'link<%=rsRoot.getString("RROOT")%>')" onMouseOut="MM_startTimeout()"><%=rsRoot.getString("RDESC")%><img src="./arrows.gif" border="0"></a>
				</font>
				</td>
			</tr>
			<tr><td><img src="./image/line-2.gif" width="220" height="4" hspace="5"></td></tr>
		<%
		} // end while
		rsRoot.close();
		stRoot.close();
		%>
		</table>
	</td>
	<!-- 右半部 -->	
	<%  String erpURL = "";
	
	try {
	    
		  //String sSqlERP = "select PROFILE_OPTION_VALUE from APPLSYS.FND_PROFILE_OPTION_VALUES where PROFILE_OPTION_VALUE like 'http:%/dev60cgi/f60cgi' ";
		  // 以下改抓Single Sign-On 的SQL取Profile option value的網址
		  String sSqlERP = "select PROFILE_OPTION_VALUE from APPLSYS.FND_PROFILE_OPTION_VALUES where PROFILE_OPTION_VALUE like 'http:%/pls/%' and APPLICATION_ID = 0 ";
		  Statement stERP=con.createStatement();
		  ResultSet rsERP=stERP.executeQuery(sSqlERP);
		  if (rsERP.next())
		  {
		   erpURL = rsERP.getString("PROFILE_OPTION_VALUE");		  
		  } 
		  rsERP.close();
		  stERP.close();
		} catch (Exception ee) { out.println("Exception:"+ee.getMessage());  }
		//out.println(erpURL);
	%>
	<td width="70%" background="image/bd.jpg">
		<table width="100%" height="340">
			<tr><td colspan="2"><font face="Arial" size="-1" color="#3399FF"><%
			                                                                        if (langCh.equals("zh-tw")) 
	                                                                                {
		                                                                             out.println("使用者"+"<font color='#FF0000'><strong>"+UserName+"</strong></font>"+"已登入("+"<font color='#003399'>"+roles+"</font>)"+"<BR>"+"您使用:<font color='#FF0000'><strong>"+authSource+"</strong></font> 密碼認證方式登入本系統");
		                                                                            } else if (langCh.equals("zh-cn"))
		                                                                                   {
			                                                                                out.println("使用者"+"<font color='#FF0000'><strong>"+UserName+"</strong></font>"+"已登入("+"<font color='#003399'>"+roles+"</font>)"+"<BR>"+"您使用:<font color='#FF0000'><strong>"+authSource+"</strong></font> 密码认证方式登入本系统");
			                                                                               } else if (langCh.equals("en-us"))
			                                                                                      { 
			                                                                                       out.println("User "+"<font color='#FF0000'><strong>"+UserName+"</strong></font>"+" Logon("+"<font color='#003399'>"+roles+"</font>)"+"<BR>"+"You are Authenticate by :<font color='#FF0000'><strong>"+authSource+"</strong></font> logon System");
			                                                                                      }	
			                                                                      // out.println(UserName);
																			 %></font></td></tr>
			<tr><td colspan="2"><font face="Arial" size="-1" color="#FF6600">			
			     <%  if (langCh.equals("zh-tw")) 
	                 {
		              out.println("其他系統連結");
		             } else if (langCh.equals("zh-cn"))
		                    {
			                 out.println("其它系统连结");
			                } else if (langCh.equals("en-us"))
			                      { 
			                       out.println("Other System Link");  
			                      }	
	             %>	
			</font></td>
			</tr>
			<tr><td colspan="2"></td></tr>
			<tr><td width="10"><A href='javascript:void(0)' onclick='setSubmitERP("jsp/RFQRedirectURLToERP.jsp");return false;'><img src="image/oracle.bmp" border="0"></a>&nbsp;<a href="http://intranet.ts.com.tw"><img src="image/Intranet.gif" border="0"></a></td><td></td></tr>
			<tr><td colspan="2" ></td></tr>			
			<tr>
			<td width="100%"><font color="#003399" size="2"><div align="center">
				                  
							   <% 
							      //out.println("<BR><div align='center'><img src='jsp/TSRFQFacPlannerConfirmIMap.jsp'></div><BR>");
							       out.println("<BR>"); 
							       //out.println("<BR><div align='left'><img src='jsp/TSSalesRFQOpenRateIMap.jsp'></div><BR>");
							       if (langCh.equals("zh-tw")) 
	                               {
		                            out.println("系統公告欄");
		                           } else if (langCh.equals("zh-cn"))
		                                  {
			                                out.println("系统公告栏");
			                              } else if (langCh.equals("en-us"))
			                                     { 
			                                      out.println("System bulletin board");  
			                                     }	
	                          %>				   	
							 </div></font>
				<table width="580">
				<tr><td colspan="3"><font face="Arial" size="-1" color="#3399FF"><span class="style1">&nbsp;</span>In 3 Days</font></td></tr>
				<%
				try {
					 String sToday = dateBean.getYearMonthDay(); //當日公告
					 dateBean.setAdjDate(-3);
					 String sBefor3Day = dateBean.getYearMonthDay(); //三日前
					 dateBean.setAdjDate(3);
					 //out.println(); out.println();
					Statement st=con.createStatement();
					ResultSet rs=st.executeQuery("SELECT * FROM ORADDMAN.TSNEWS WHERE esdate between '"+sBefor3Day+"' and '"+sToday+"' " );
					while (rs.next()) {
				%>
					
					<tr>
					<td width="15%"><font face="Arial" size="-2" color="#FF00FF"><%=rs.getString("OWNERNAME")%></font></td>
					<td width="15%"><font face="Arial" size="-2" color="#FF00FF"><%=rs.getString("ESDATE")%></font></td>
					<td width="70%">
						<font face="Arial" size="-2" color="#FF00FF">
						<a href='./jsp/NewsShowDetail.jsp?NEWSID=<%=rs.getString("NEWSID")%>' class="show1"><%=rs.getString("NEWSDESC")%></a>
						</font>
					</td>
					</tr>
				<%

					} // end while
					rs.close();
					st.close();
				} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
				%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
				} // end try-catch
				%>
			    <tr>
				  <td colspan="3">
                    <!-- 20091117 liling disable
				    <%@ include file="jsp/TSSalesRFQOpenRateChart.jsp"%>
			        <!--% out.println("<BR>");  %-->
			        <!--%@ include file="jsp/TSRFQTEWFacPlannerConfirmChart.jsp"%-->
			        <%@ include file="jsp/TSRFQYEWFacPlannerConfirmChart.jsp"%>
				  </td>
				</tr>
				</table>
			</td>
		</tr>
		<tr>
		  <td colspan="3"><font face="Arial" size="-1" color="#3399FF"><span class="style1">&nbsp;</span>In 7 Days</font></td>
		</tr>
		<tr>
			<td width="100%">
				<div id="marquees">
				<marquee direction="up" scrollamount="1">
				<table width="600">

					<%
					try {
						int i = 0;
						String sColor = "#0000FF";
						dateBean.setAdjDate(-3);
						String sToday = dateBean.getYearMonthDay();
						dateBean.setAdjDate(3);
						dateBean.setAdjDate(-7);
						String sDate = dateBean.getYearMonthDay(); //10日內公告
						dateBean.setAdjDate(7);
						Statement st=con.createStatement();
						ResultSet rs=st.executeQuery("SELECT * FROM ORADDMAN.TSNEWS WHERE esdate<"+sToday+" AND ESDATE>="+sDate+" ORDER BY ESDATE");
						while (rs.next()) {
							//if (i==0) { i=1; sColor = "#000000"; }
							//else { i=0; sColor = "#808000"; }

					%>
					<tr>
					<td width="15%"><font face="Arial" size="-3" color=<%=sColor%>><%=rs.getString("OWNERNAME")%></font></td>
					<td width="15%"><font face="Arial" size="-3" color=<%=sColor%>><%=rs.getString("ESDATE")%></font></td>
					<td width="70%">
						<font face="Arial" size="-3" color=<%=sColor%>>
						<a href='./jsp/NewsShowDetail.jsp?NewsID=<%=rs.getString("NEWSID")%>' class="show2"><%=rs.getString("NEWSDESC")%></a>
						</font>
					</td>
					</tr>
					<%
						} // end while
						rs.close();
						st.close();

					} catch (Exception ee) { out.println("Exception:"+ee.getMessage());
					%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
					}// end try-catch

					%>

				</table>
				</marquee>
				</div>

			 </td>
		   </tr>
		</table>
	</td>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
</tr>
</table>
<!--%
                    for (int i=0;i<userCompCodeArray.length;i++)
					{
					 out.println("userCompCodeArray[0][i]="+userCompCodeArray[0][i]);
					 out.println("userCompCodeArray[0][i]="+userCompCodeArray[1][i]);
					}
					out.println("UserRegionSet="+UserRegionSet);
%-->
  <INPUT TYPE="hidden" NAME="i_1" VALUE="<%=userId%>">
  <INPUT TYPE="hidden" NAME="i_2" VALUE="<%=decryptPassword%>">
  <INPUT TYPE="hidden" NAME="rmode" VALUE="2">
  <INPUT TYPE="hidden" NAME="home_url" VALUE="">
</form>
<%

						//int i = 0;
						//String sColor = "#0000FF";
						//dateBean.setAdjDate(-3);
						String sTodayNew = dateBean.getYearMonthDay();
						dateBean.setAdjDate(3);
						dateBean.setAdjDate(-10);
						String sDateNew = dateBean.getYearMonthDay(); //10日內公告
						dateBean.setAdjDate(10);
						Statement stNew=con.createStatement();
						//out.println("SELECT * FROM ORADDMAN.TSNEWS WHERE esdate between '"+sDateNew+"' and '"+sTodayNew+"' ORDER BY ESDATE");
						ResultSet rsNew=stNew.executeQuery("SELECT * FROM ORADDMAN.TSNEWS WHERE esdate between '"+sDateNew+"' and '"+sTodayNew+"' ORDER BY ESDATE");
						while (rsNew.next())
						{

%>
<!------------ 移動開關公告插入控制碼區段開始 ------------>
<!--20091123 Liling disable
<!--div id="showimage" style="position: absolute; width: 250; left: 440; top: 26; height: 99">
<table border="0" width="300" bgcolor="#FFFFFF" cellspacing="0" cellpadding="2">
<tr><td width="100%" align="center" valign="middle"><table border="0" width="100%" cellspacing="0" cellpadding="0"
height="36"><tr>
<td bgcolor="#6699CC" onMousedown="initializedragie()" style="cursor:hand" width="100%" align="left"><font size="2"><ilayer width="100%"><layer width="100%" onMouseover="dragswitch=1;drag_dropns(showimage)" onMouseout="dragswitch=0"><font color="#FFFFFF"><div align="center">企業內部網站-公告視窗</div></font></layer></ilayer></font></td><td style="cursor:hand"><a href="#" onClick="hidebox();return false">
<img src="./image/close.gif" alt="關閉" width="15" height="15" border=0></font></a></td></tr>

<tr><td width="100%" background="./jsp/NewsShowDetail.jsp?NEWSID=<!--%=rsNew.getString("NEWSID")%>" style="padding:4px" colspan="2" align="left">
<font size="2" color="#FFFFCC" ><a href="./jsp/NewsShowDetail.jsp?NEWSID=<!--%=rsNew.getString("NEWSID")%>">
<!--%=rsNew.getString("NEWSDESC")%>
</a>
</font>
</td></tr> </table></td></tr> </table></div-->
<script language="JavaScript1.2">
var dragswitch=0
var nsx

function drag_dropns(name){
temp=eval(name)
temp.captureEvents(Event.MOUSEDOWN | Event.MOUSEUP)
temp.onmousedown=gons
temp.onmousemove=dragns
temp.onmouseup=stopns
}

function gons(e){
temp.captureEvents(Event.MOUSEMOVE)
nsx=e.x
nsy=e.y
}
function dragns(e){
if (dragswitch==1){
temp.moveBy(e.x-nsx,e.y-nsy)
return false
}
}

function stopns(){
temp.releaseEvents(Event.MOUSEMOVE)
}

//drag drop function for IE 4+////
/////////////////////////////////

var dragapproved=false

function drag_dropie(){
if (dragapproved==true){
document.all.showimage.style.pixelLeft=tempx+event.clientX-iex
document.all.showimage.style.pixelTop=tempy+event.clientY-iey
return false
}
}

function initializedragie(){
iex=event.clientX
iey=event.clientY
tempx=showimage.style.pixelLeft
tempy=showimage.style.pixelTop
dragapproved=true
document.onmousemove=drag_dropie
}

if (document.all){
document.onmouseup=new Function("dragapproved=false")
}

////drag drop functions end here//////

function hidebox(){
if (document.all)
showimage.style.visibility="hidden"
else if (document.layers)
document.showimage.visibility="hide"
}
</script>
<!------------ 移動開關公告插入控制碼區段結束 ------------>
<script language=javascript src="../down.js"></script>
<script language=javascript src="../Copyright.js"></script>  
<%                      
          } // ENd of while
		  rsNew.close();
		  stNew.close();
				 
			//	 } catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%> 
</body>
</html>
<!--<script language="javascript">

marqueesHeight=380; 

stopscroll=false;
with(marquees){
noWrap=true; 
style.width=600;
style.height=marqueesHeight;
style.overflowY="hidden"; 

onmouseover=new Function("stopscroll=true"); 
onmouseout=new Function("stopscroll=false"); 
}

document.write('<div id="templayer" style="position:absolute;z-index:1;top:0px;visibility:hidden"></div>');

function init(){

while(templayer.offsetHeight<marqueesHeight){
templayer.innerHTML+=marquees.innerHTML;
}

marquees.innerHTML=templayer.innerHTML+templayer.innerHTML;

setInterval("scrollUp()",200);
}
document.body.onload=init;

preTop=0; 

function scrollUp(){ 
if(stopscroll==true) return; 
preTop=marquees.scrollTop; 
marquees.scrollTop+=1; 
if(preTop==marquees.scrollTop){
marquees.scrollTop=templayer.offsetHeight-marqueesHeight+1;
}
}
//
function setSubmitERP(URL)
{
 document.MAINFORM.action=URL;
 document.MAINFORM.submit();
}
</script>-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>