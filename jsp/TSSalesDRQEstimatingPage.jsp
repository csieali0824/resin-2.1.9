<!-- 20101112 liling 把重新指派或批退說明加到history -->
<!-- 20101203 liling 新增PC_COMMENT,原REMARK改UPDATE至PC_COMMENT,避免蓋掉SALES打的 -->
<!-- 20141013 Peggy,加入D1-010 CCYANG轉SLOW MOVING備註-->
<!-- 20141210 Peggy,供應商交期不可小於系統日-->
<!-- 20150123 Peggy,修正客戶品號顯示應抓raddman.tsdelivery_notice_detail.ordered_item-->
<!-- 20150813 Peggy,當TSCE ORDER PC交期晚於SSD且為SEA(C)計算工廠交期+FOB TERM是否在CRD前後兩天,若是,則PASS,否則自動UPDATE SHIPPING METHOD=AIR(C),重新計算SSD-->
<!-- 20160825 Peggy,工廠CONFIRM SEA(UC)無法滿足客戶CRD,運輸方式由SEA(UC)改成AIR(UC),系統重新計算AIR(UC)交期供工廠確認
<!-- 20160913 Peggy,check customer:GE tsch rfq yew 1156 回覆交期是否符合客戶出貨日-->
<!-- 20161019 Peggy,停用function:TSC_RFQ_GET_TSCA_SSD,改用TSCA_GET_ORDER_SSD-->
<!-- 20170510 Peggy,yew回T交期統一為週一-->
<!-- 20170711 Peggy,TSCA遇20990101交期,不重算SSD及SHIPPING METHOD-->
<!-- 20180207 Peggy,供應商=蘇固且訂單類型=1142,訂單類型自動轉換為1141, FOB設定為FOB TAIWAN-->
<!-- 20181113 Peggy,MUSTARD固定週一出貨(BY SEA),但急料排外-->
<!-- 20181221 Peggy,顯示package-->
<%@ page  contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.text.*"%>
<html>
<head>
	<title>Sales Delivery Request Data Edit Page for Assign</title>
	<!--=============以下區段為安全認證機制==========-->
	<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
	<!--=============以下區段為取得連結池==========-->
	<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
	<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
	<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
	<%@ page import="SalesDRQPageHeaderBean" %>
	<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
	<jsp:useBean id="array2DEstimateFactoryBean" scope="session" class="Array2DimensionInputBean"/>
	<jsp:useBean id="StockInfoBean" scope="session" class="Array2DimensionInputBean"/>
	<script language="JavaScript" type="text/JavaScript">
		var checkflag = "false";
		function check(field)
		{
			if (checkflag == "false")
			{
				for (i = 0; i < field.length; i++)
				{
					field[i].checked = true;
				}
				checkflag = "true";
				return "Cancel Selected";
			}
			else
			{
				for (i = 0; i < field.length; i++)
				{
					field[i].checked = false;
				}
				checkflag = "false";
				return "Select All";
			}
		}

		document.onclick=function(e)
		{
			var t=!e?self.event.srcElement.name:e.target.name;
			//if (t!="popcal")
			//gfPop.fHideCal();
		}

		//function submitCheck(ms1,ms2,ms3,ms4,ms5,ms6,pgRow)
		function submitCheck(ms1,ms2,ms3,ms4,ms5,ms6)
		{
			var ship_frequency ="";
			var chinese_day = ["日","一","二","三","四","五","六"];
			var rec_year="",rec_month="",rec_day="",pc_date="",sysdate="";
			document.DISPLAYREPAIR.submit2.disabled=true;
			if (document.DISPLAYREPAIR.ACTIONID.value=="004")  //表示為CANCE動作
			{
				flag=confirm(ms1);
				if (flag==false)
				{
					document.DISPLAYREPAIR.submit2.disabled=false;
					return(false);
				}
			}

			if (document.DISPLAYREPAIR.ACTIONID.value=="--" || document.DISPLAYREPAIR.ACTIONID.value==null)
			{
				alert(ms2);
				document.DISPLAYREPAIR.submit2.disabled=false;
				return(false);
			}
			else if (document.DISPLAYREPAIR.ACTIONID.value!="008" && document.DISPLAYREPAIR.ACTIONID.value!="005" && document.DISPLAYREPAIR.ACTIONID.value!="006" && document.DISPLAYREPAIR.ACTIONID.value!="007")
			{   //表示動作清單不為CONFIRM、cancel、Transfer、Reassign ,可能是自行輸入LINE_ID,因此需卡住網頁動作
				alert(" Error Action Process!!!\n Don't try key-in invalid line No in this page...");
				document.DISPLAYREPAIR.submit2.disabled=false;
				return(false);
			}

			// 若未選擇任一Line 作動作,則警告
			var lineid="";
			var iLen=0,chkcnt=0;
			var chkvalue=false;
			if (document.DISPLAYREPAIR.CHKFLAG.length != undefined)
			{
				iLen=document.DISPLAYREPAIR.CHKFLAG.length;
			}
			else
			{
				iLen=1;
			}
			for (i=0;i<iLen;i++)
			{
				if (iLen==1)
				{
					chkvalue =document.DISPLAYREPAIR.CHKFLAG.checked;
					lineid = document.DISPLAYREPAIR.CHKFLAG.value;
				}
				else
				{
					chkvalue =document.DISPLAYREPAIR.CHKFLAG[i].checked;
					lineid = document.DISPLAYREPAIR.CHKFLAG[i].value;
				}
				if (chkvalue==true)
				{
					chkcnt ++;
					if (document.DISPLAYREPAIR.ACTIONID.value=="008")
					{
						rec_year = document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.substr(0,4);
						rec_month= document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.substr(4,2);
						rec_day  = document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.substr(6,2);
						ship_frequency = document.DISPLAYREPAIR.elements["SHIP_FREQUENCY_"+lineid].value;
						pc_date  = document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value;
						sysdate  = document.DISPLAYREPAIR.SYSDATE.value;

						if (document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.length!=8)
						{
							alert("line"+lineid+":The date value error!!");
							document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
							document.DISPLAYREPAIR.ACTIONID.value=="--";
							document.DISPLAYREPAIR.submit2.disabled=false;
							return false;
						}
						else if (rec_month <1 || rec_month >12)
						{
							alert("line"+lineid+":The month value error!!");
							document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
							document.DISPLAYREPAIR.ACTIONID.value=="--";
							document.DISPLAYREPAIR.submit2.disabled=false;
							return false;
						}
						else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
						{
							alert("line"+lineid+":The date value error!!");
							document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
							document.DISPLAYREPAIR.ACTIONID.value=="--";
							document.DISPLAYREPAIR.submit2.disabled=false;
							return false;
						}
						else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
						{
							alert("line"+lineid+":The date value error!!");
							document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
							document.DISPLAYREPAIR.ACTIONID.value=="--";
							document.DISPLAYREPAIR.submit2.disabled=false;
							return false;
						}
						else if (rec_month == 2)
						{
							if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
							{
								alert("line"+lineid+":The date value error!!");
								document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
								document.DISPLAYREPAIR.ACTIONID.value=="--";
								document.DISPLAYREPAIR.submit2.disabled=false;
								return false;
							}
						}
						if (eval(pc_date)<eval(sysdate))
						{
							alert("line"+lineid+":The date value error!!");
							document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
							document.DISPLAYREPAIR.ACTIONID.value=="--";
							document.DISPLAYREPAIR.submit2.disabled=false;
							return false;
						}
						if (ship_frequency!=0)
						{
							var pc_date = new Date(Date.parse(rec_month+"-"+rec_day+"-"+ rec_year));
							if ((ship_frequency-1) != pc_date.getDay())
							{
								alert("line"+lineid+":客戶交期為周"+chinese_day[(ship_frequency-1)]+",請Confirm周"+chinese_day[(ship_frequency-1)]+"交期!!");
								document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
								document.DISPLAYREPAIR.ACTIONID.value=="--";
								document.DISPLAYREPAIR.submit2.disabled=false;
								return false;
							}
						}
					}
					else if (document.DISPLAYREPAIR.ACTIONID.value=="005") //批退
					{
						document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].style.backgroundColor="#FFFFFF";
						document.DISPLAYREPAIR.elements["REASON_"+lineid].style.backgroundColor="#FFFFFF";
						if (document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].value=="00" || document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].value=="--" || document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].value=="") //批退
						{
							alert("Please choose a reject reason code!!");
							document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].style.backgroundColor="#FFCCCC";
							document.DISPLAYREPAIR.submit2.disabled=false;
							return false;
						}
						else if (document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].value=="07") //批退-其他
						{
							if (document.DISPLAYREPAIR.elements["REASON_"+lineid].value=="" || document.DISPLAYREPAIR.elements["REASON_"+lineid].value=="null")
							{
								alert("Please enter a reason!!");
								document.DISPLAYREPAIR.elements["REASON_"+lineid].style.backgroundColor="#FFCCCC";
								document.DISPLAYREPAIR.submit2.disabled=false;
								return false;
							}
						}
					}
				}
			}
			if (chkcnt<=0 && document.DISPLAYREPAIR.CHKFLAG.length!=null)
			{
				alert(ms4);
				document.DISPLAYREPAIR.submit2.disabled=false;
				return(false);
			}

			//var setFlag="FALSE";

			//for (k=0;k<pgRow;k++)
			//{  //alert(document.DISPLAYREPAIR.elements["REASONCODE"+k].value);
			//	if (document.DISPLAYREPAIR.elements["REASONCODE"+k].value !=null && document.DISPLAYREPAIR.elements["REASONCODE"+k].value != "00"  && document.DISPLAYREPAIR.elements["REASONCODE"+k].value != "--" && document.DISPLAYREPAIR.elements["REASONCODE"+k].value != "null")
			// 	{
			//  		setFlag="TRUE";
			// 	}
			//}

			//for (j=0;j<pgRow;j++)
			//{
			//	if (document.DISPLAYREPAIR.elements["REASON"+j].value !=null && document.DISPLAYREPAIR.elements["REASON"+j].value != "N/A" && document.DISPLAYREPAIR.elements["REASON"+j].value != "null")
			// 	{//alert(document.DISPLAYREPAIR.elements["ASSIGN_FACT"+j].value);
			//  		setFlag="TRUE";
			// 	}
			//}

			//if (setFlag=="FALSE")
			//{
			//	if (document.DISPLAYREPAIR.ACTIONID.value=="007")
			//	{
			//   		alert(ms5);
			//		document.DISPLAYREPAIR.submit2.disabled=false;
			//  		return(false);
			//	}
			//	else if (document.DISPLAYREPAIR.ACTIONID.value=="005")
			//	{
			// 		alert(ms6);
			//		document.DISPLAYREPAIR.submit2.disabled=false;
			// 		return(false);
			//	}
			//}
			//document.DISPLAYREPAIR.submit2.disabled=false;
			return(true);
		}

		//function setSubmit1(URL)
		//{ //alert();
		//	var linkURL = "#ACTION";
		//  	document.DISPLAYREPAIR.action=URL+linkURL;
		//  	document.DISPLAYREPAIR.submit();
		//}

		/*function setSubmit2(URL,LINKREF,DATECURR)
        {
            warray=new Array(document.DISPLAYREPAIR.FACTORYDATE.value);
              // 檢查日期是否符合日期格式
               var datetime;
               var year,month,day;
               var gone,gtwo;
            var ship_frequency = document.DISPLAYREPAIR.elements["SHIP_FREQUENCY_"+LINKREF].value;
            var chinese_day = ["日","一","二","三","四","五","六"];
               if(warray[0]!="")
               {
                datetime=warray[0];
                 if(datetime.length==8)
                 {
                    year=datetime.substring(0,4);
                    if(isNaN(year)==true)
                    {
                         alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
                         document.DISPLAYREPAIR.FACTORYDATE.focus();
                         return(false);
                    }
                    gone=datetime.substring(4,5);
                    month=datetime.substring(4,6);
                    if(isNaN(month)==true)
                    {
                          alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
                          document.DISPLAYREPAIR.FACTORYDATE.focus();
                          return(false);
                    }
                    gtwo=datetime.substring(7,8);
                    day=datetime.substring(6,8);
                    if(isNaN(day)==true)
                    {
                          alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
                          document.DISPLAYREPAIR.FACTORYDATE.focus();
                          return(false);
                    }
                      if(month<1||month>12)
                      {
                        alert("Month must between 01 and 12 !!");
                        document.DISPLAYREPAIR.FACTORYDATE.focus();
                        return(false);
                      }
                      if(day<1||day>31)
                      {
                        alert("Day must between 01 and 31!!");
                        document.DISPLAYREPAIR.FACTORYDATE.focus();
                        return(false);
                      }
                    else
                    {
                        if(month==2)
                        {
                            if(isLeapYear(year)&&day>29)
                            {
                                alert("February between 01 and 29 !!");
                                  document.DISPLAYREPAIR.FACTORYDATE.focus();
                                  return(false);
                            }
                            if(!isLeapYear(year)&&day>28)
                            {
                                alert("February between 01 and 29 !!");
                                 document.DISPLAYREPAIR.FACTORYDATE.focus();
                                 return(false);
                            }
                        } // End of if(month==2)
                        if((month==4||month==6||month==9||month==11)&&(day>30))
                        {
                             alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                               document.DISPLAYREPAIR.FACTORYDATE.focus();
                               return(false);
                        }
                       } // End of else

                    //add by Peggy 20160913
                    if (ship_frequency!=0)
                    {
                        var pc_date = new Date(Date.parse(month+"-"+day+"-"+ year));
                        if ((ship_frequency-1) != pc_date.getDay())
                        {
                            alert("客戶交期為周"+chinese_day[(ship_frequency-1)]+",請Confirm周"+chinese_day[(ship_frequency-1)]+"交期!!");
                            return false;
                        }
                    }
                }
                else
                { // End Else of if(datetime.length==10)
                    alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
                      document.DISPLAYREPAIR.FACTORYDATE.focus();
                      return(false);
                }
            }

               if(document.DISPLAYREPAIR.REMARK.value=="" && document.DISPLAYREPAIR.ACTIONID.value=="007") // 若是選擇REASIGN但Remark 未輸入,則不允許
               {
                alert("Please Input Re-Assign Reason before you Set this item...");
                 document.DISPLAYREPAIR.ACTIONID.value="--";
                 document.DISPLAYREPAIR.REMARK.focus();
                 return (false);
               }

               if(document.DISPLAYREPAIR.TSREASONNO.value=="--" && (document.DISPLAYREPAIR.ACTIONID.value=="007" || document.DISPLAYREPAIR.ACTIONID.value=="005")) // 若是選擇REASIGN或REJECT但 未選擇原因,則不允許 Set
               {
                alert("Please choose Re-Assign/Reject Reason before you Set this item...");
                 document.DISPLAYREPAIR.ACTIONID.value="--";
                 document.DISPLAYREPAIR.TSREASONNO.focus();
                 return (false);
               }

               if(document.DISPLAYREPAIR.FACTORYDATE.value=="" && document.DISPLAYREPAIR.TSREASONNO.value=="--") // 若是未給定排定日期,且亦未選定批退原因,則不允許 Set
               {
                alert("Please Input Factory Delivery Date before you Set this item...");
                 document.DISPLAYREPAIR.ACTIONID.value="--";
                 document.DISPLAYREPAIR.FACTORYDATE.focus();
                 return (false);
               }
              // 檢查日期是否符合日期格式

              if (document.DISPLAYREPAIR.FACTORYDATE.value < DATECURR && document.DISPLAYREPAIR.FACTORYDATE.value!= "")
              {
                alert("<jsp:getProperty name='rPH' property='pgAlertDateSet'/>");
     	document.DISPLAYREPAIR.FACTORYDATE.focus();
	 	return (false);
  	} 
	else if (document.DISPLAYREPAIR.FACTORYDATE.value=="")
    {
		document.DISPLAYREPAIR.FACTORYDATE.value==DATECURR;
	}
  
  	//add by Peggy 20130417
	if (document.DISPLAYREPAIR.TSREASONNO.value=="08")
	{
		if (document.DISPLAYREPAIR.ALLOTQTY.value =="" || document.DISPLAYREPAIR.ALLOTQTY.value =="0")
		{
			alert("please input a slow moving quantity in the ALLOT QTY field!!");
			document.DISPLAYREPAIR.ALLOTQTY.focus();
			return false;
		}
		else if (parseInt(document.DISPLAYREPAIR.ALLOTQTY.value) > parseInt(document.DISPLAYREPAIR.elements["QTY"+LINKREF].value))
		{
			alert("The allot qty must be less than "+document.DISPLAYREPAIR.elements["QTY"+LINKREF].value +"K !!");
			document.DISPLAYREPAIR.ALLOTQTY.focus();
			return false;
		}
	}

  	document.DISPLAYREPAIR.ACTIONID.value="--"; // 避免使用者先選動作再設定各項目

  	var factoryDate="&FACTORYDATE="+document.DISPLAYREPAIR.FACTORYDATE.value; 
  	var linkURL = "#"+LINKREF;
  	document.DISPLAYREPAIR.action=URL+factoryDate+linkURL;
  	document.DISPLAYREPAIR.submit();    
}
*/

		// 檢查閏年,判斷日期輸入合法性
		function isLeapYear(year)
		{
			if((year%4==0&&year%100!=0)||(year%400==0))
			{
				return true;
			}
			return false;
		}
		//add by Peggy 20130409
		function showIdleStockInfo(itemname,itemdesc)
		{
			subWin=window.open("../jsp/TscSlowMovingQueryAll.jsp?TSCDESC="+itemname+"&ITEMDESC="+itemdesc+"&QTYPE=sub","subwin","width=1000,height=350,toolbar=no,location=no,resizable=yes,scrollbars=yes,menubar=no");
		}

		function setReasonCode(lineid)
		{
			if (document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].value=="08")
			{
				document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].value="";
				document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].disabled=false;
			}
			else
			{
				document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].value="";
				document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].disabled=true;
			}
		}

		function numCheckInt()
		{
			if ((event.keyCode < 48 || window.event.keyCode > 57) && event.keyCode != 46 ) event.returnValue = false;
		}
		//add by Peggy 20140328
		function setVendorInfo(itemid,lineno,rfqno)
		{
			subWin=window.open("../jsp/subwindow/TSCApprovalSupplierFind.jsp?ITEMID="+itemid+"&LINENO="+lineno+"&rfqno="+rfqno+"&PG=D1003","subwin","location=no,left=450,top=300,width=500,height=300,scrollbars=no,menubar=no");
		}
		function checkall()
		{
			if (document.DISPLAYREPAIR.CHKFLAG.length != undefined)
			{
				for (var i =0 ; i < document.DISPLAYREPAIR.CHKFLAG.length ;i++)
				{
					if (document.DISPLAYREPAIR.CHKFLAG[i].disabled==false)
					{
						document.DISPLAYREPAIR.CHKFLAG[i].checked= document.DISPLAYREPAIR.chkall.checked;
						//setCheck(i);
					}
				}
			}
			else
			{
				if (document.DISPLAYREPAIR.CHKFLAG.disabled==false)
				{
					document.DISPLAYREPAIR.CHKFLAG.checked = document.DISPLAYREPAIR.chkall.checked;
					//setCheck(1);
				}
			}
		}
		function setCheck(irow)
		{
			/*var chkflag ="";
            var lineid="";
            if (document.DISPLAYREPAIR.CHKFLAG.length != undefined)
            {
                chkflag = document.DISPLAYREPAIR.CHKFLAG[irow].checked;
                lineid = document.DISPLAYREPAIR.CHKFLAG[irow].value;
            }
            else
            {
                chkflag = document.DISPLAYREPAIR.CHKFLAG.checked;
                lineid = document.DISPLAYREPAIR.CHKFLAG.value;
            }
            if (chkflag == true)
            {
                document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].disabled=false;
                document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value=document.DISPLAYREPAIR.elements["REQUESTDATE_"+lineid].value;
                document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].value="";
                document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].disabled=false;
                document.DISPLAYREPAIR.elements["REASON_"+lineid].value="";
                document.DISPLAYREPAIR.elements["REASON_"+lineid].disabled=false;
                document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].value="";
                document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].disabled=true;
                document.DISPLAYREPAIR.elements["img_"+lineid].style.visibility="visible";
            }
            else
            {
                document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].disabled=true;
                document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].value="";
                document.DISPLAYREPAIR.elements["REASONCODE_"+lineid].disabled=true;
                document.DISPLAYREPAIR.elements["REASON_"+lineid].value="";
                document.DISPLAYREPAIR.elements["REASON_"+lineid].disabled=true;
                document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].value="";
                document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].disabled=true;
                document.DISPLAYREPAIR.elements["img_"+lineid].style.visibility="hidden";
            }*/
		}
		function chkDate(lineid,dndocno)
		{
			var ship_frequency = document.DISPLAYREPAIR.elements["SHIP_FREQUENCY_"+lineid].value;
			var chinese_day = ["日","一","二","三","四","五","六"];
			var rec_year="",rec_month="",rec_day="",pc_date="",sysdate="";

			if (document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.length>8)
			{
				alert("line"+lineid+":The date value error!!");
				document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
				document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value="";
				return false;
			}
			else if (document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.length==8)
			{
				rec_year = document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.substr(0,4);
				rec_month= document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.substr(4,2);
				rec_day  = document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.substr(6,2);
				pc_date  = document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value;
				sysdate  = document.DISPLAYREPAIR.SYSDATE.value;

				if (rec_month <1 || rec_month >12)
				{
					alert("line"+lineid+":The month value error!!");
					document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
					document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value="";
					return false;
				}
				else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
				{
					alert("line"+lineid+":The date value error!!");
					document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
					document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value="";
					return false;
				}
				else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
				{
					alert("line"+lineid+":The date value error!!");
					document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
					document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value="";
					return false;
				}
				else if (rec_month == 2)
				{
					if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
					{
						alert("line"+lineid+":The date value error!!");
						document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
						document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value="";
						return false;
					}
				}

				if (eval(pc_date)<eval(sysdate))
				{
					alert("line"+lineid+":The date value error!!");
					document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
					document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value="";
					return false;
				}
				if (ship_frequency!=0)
				{
					var pc_date = new Date(Date.parse(rec_month+"-"+rec_day+"-"+ rec_year));
					if ((ship_frequency-1) != pc_date.getDay())
					{
						alert("line"+lineid+":客戶交期為周"+chinese_day[(ship_frequency-1)]+",請Confirm周"+chinese_day[(ship_frequency-1)]+"交期!!");
						document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].focus();
						document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value="";
						return false;
					}
				}

				if (((document.DISPLAYREPAIR.salesarea.value=="001" && document.DISPLAYREPAIR.elements["SHIPPING_METHOD_"+lineid].value=="SEA(C)") || (document.DISPLAYREPAIR.salesarea.value=="008" && document.DISPLAYREPAIR.elements["SHIPPING_METHOD_"+lineid].value=="SEA(UC)")) && document.DISPLAYREPAIR.elements["ORIG_SHIPPING_METHOD_"+lineid].value=="NULL")
				{
					document.DISPLAYREPAIR.action="../jsp/TSSalesDRQEstimatingPage.jsp?LINENO="+lineid+"&DNDOCNO="+dndocno+"&SALESAREA="+document.DISPLAYREPAIR.salesarea.value;
					document.DISPLAYREPAIR.submit();
				}
				else
				{
					document.DISPLAYREPAIR.elements["ORIG_REQUESTDATE_"+lineid].value=document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value;
				}
			}
		}
		function checkqty(lineid)
		{
			var slowmovingqty=document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].value;
			var qty=document.DISPLAYREPAIR.elements["QTY"+lineid].value;
			if (eval(slowmovingqty) > eval(qty))
			{
				alert("消庫存數量不可大於原申請數量!");
				document.DISPLAYREPAIR.elements["ALLOTQTY_"+lineid].focus();
				return false;
			}

		}
		//function setChangeValue(lineid)
		//{
		//	document.DISPLAYREPAIR.elements["ORIG_REQUESTDATE_"+lineid].value="00000000";
		//	return true;
		//}
		function chkDate1(lineid,dndocno)
		{
			//if (document.DISPLAYREPAIR.elements["ORIG_REQUESTDATE_"+lineid].value=="00000000")
			//{
			if (document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value.length==8)
			{
				//if (document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value != document.DISPLAYREPAIR.elements["REQUESTDATE_"+lineid].value)
				if (document.DISPLAYREPAIR.elements["FACTORYDATE_"+lineid].value != document.DISPLAYREPAIR.elements["ORIG_REQUESTDATE_"+lineid].value)
				{
					chkDate(lineid,dndocno);
				}
			}
			return true;
		}
		function setStockInfo(dndocno,lineno,itemid,qty,reqdate,ordertype)
		{
			subWin=window.open("../jsp/subwindow/TSDRQItemSupplyInfo.jsp?DNDOCNO="+dndocno+"&LINENO="+lineno+"&ITEMID="+itemid+"&REQQTY="+qty+"&REQDATE="+reqdate+"&ORDERTYPE="+ordertype+"&PGCODE=D1003","subwin","location=no,left=450,top=300,width=700,height=300,scrollbars=yes,menubar=no");
		}
	</script>
	<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
	<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<body>
<%
	//request.setCharacterEncoding("UTF-8");
//response.setContentType("text/html; charset=big5"); 
	String dnDocNo=request.getParameter("DNDOCNO");
	String prodManufactory=request.getParameter("PRODMANUFACTORY");
	String lineNo=request.getParameter("LINENO");
	String actionID = request.getParameter("ACTIONID");
	String sDate=request.getParameter("SDATE");
	String remark=request.getParameter("REMARK");
	String processRemark=request.getParameter("PROC_REMARK");
	String tsReasonNo=request.getParameter("TSREASONNO");// 重新指派或批退原因
	String line_No=request.getParameter("LINE_NO");
	String processFocus=request.getParameter("PROCESSFOCUS");
//String [] check=request.getParameterValues("CHKFLAG");
	String allotQty = request.getParameter("ALLOTQTY"); //add by Peggy 20130422
	String vendor_flag = request.getParameter("VENDOR_FLAG");
	if (vendor_flag==null) vendor_flag="";//add by Peggy 20140328
	String vendor_site_code ="",vendor_site_id =""; //add by Peggy 20140328
	if (allotQty ==null || !tsReasonNo.equals("08")) allotQty ="0";
	String TEWTOTW = request.getParameter("TEWTOTW"); //add by Peggy 20180207
	if (TEWTOTW==null) TEWTOTW="N";
//int pageResultRow = 0;
	String salesarea=request.getParameter("salesarea");
	if (lineNo==null) { lineNo="";}
//if (factoryDate==null) { factoryDate="";}
	if (remark==null) { remark=""; }
	if (processRemark==null) { processRemark=""; }
	if (processFocus==null) { processFocus="";  }
	if (actionID==null) { actionID = ""; }
	String sql ="";
	String [] choice=request.getParameterValues("CHKFLAG");
	String choiceLine="";
	if (choice!=null)
	{
		for (int i=0;i<choice.length;i++)
		{
			choiceLine +=(choice[i]+",");
		}
		if (choiceLine.length()>0) choiceLine =","+choiceLine;
	}
//out.println("choiceLine="+choiceLine);
	boolean checkflag=false;
	String factoryDate=request.getParameter("FACTORYDATE_"+lineNo);//新交期預設帶pc回覆日.
	if (factoryDate==null) factoryDate="";
	String newShipDate=factoryDate;
	String totwdays=request.getParameter("totw_days_"+lineNo);
	if (totwdays==null) totwdays="0";
	String FIRTIME=request.getParameter("FIRTIME");
	if (FIRTIME==null) FIRTIME="1";
	if (FIRTIME.equals("1"))
	{
		StockInfoBean.setArray2DString(null);
		FIRTIME="2";
	}

// 取本次清單列數 
//int rowLength = 0;
//String sqlCount = null;
//Statement stateCNT=con.createStatement();
//if (UserRoles.indexOf("admin")>=0) { sqlCount = "select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '003' ";  }
//else { sqlCount = "select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and ASSIGN_MANUFACT = '"+userProdCenterNo+"' and LSTATUSID = '003'"; }
//ResultSet rsCNT=stateCNT.executeQuery(sqlCount);	
//if (rsCNT.next()) rowLength = rsCNT.getInt(1);
//rsCNT.close();
//stateCNT.close();
//pageResultRow = rowLength; //給本頁的項數,用於判斷是否有任何指派迴圈

//統一在第二關confirm供應商
//add by Peggy 20140328
	if (vendor_flag.equals(""))
	{
		String sqlx = "select vendor_flag from ORADDMAN.TSPROD_MANUFACTORY  where MANUFACTORY_NO= '"+userProdCenterNo+"'";
		Statement statex=con.createStatement();
		ResultSet rsx=statex.executeQuery(sqlx);
		if (rsx.next()) vendor_flag = rsx.getString("vendor_flag");
		rsx.close();
		statex.close();
	}

	if (lineNo !=null && !lineNo.equals(""))
	{
		//if (factoryDate=="" || factoryDate.equals(""))
		//{
		//	Statement stateFACT=con.createStatement();
		//	ResultSet rsFACT=stateFACT.executeQuery("select REQUEST_DATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ");
		//	if (rsFACT.next())
		//	{
		//		factoryDate= rsFACT.getString(1).substring(0,8);
		//	}
		//	rsFACT.close();
		//	stateFACT.close();
		//}
		//String newShipDate=""; //新交期預設帶pc回覆日.
		//Statement stateFACT=con.createStatement();
		//String sqlFACT=" select  b.TSAREANO,TO_CHAR(TO_DATE(SUBSTR(nvl('"+factoryDate+"',REQUEST_DATE),1,8),'YYYYMMDD')+NVL((SELECT TRANSPORTATION_DAYS FROM ORADDMAN.TSC_CHINA_TO_TAIWAN_DAYS d WHERE a.ASSIGN_MANUFACT=d.PLANT_CODE"+
		//			   " and c.ORDER_NUM=d.ORDER_NUM),0),'yyyymmdd') TOTW_DATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,  ORADDMAN.TSDELIVERY_NOTICE b,ORADDMAN.TSAREA_ORDERCLS c"+
		//			   " where a.DNDOCNO='"+dnDocNo+"' and a.LINE_NO='"+lineNo+"' "+
		//			   " and a.DNDOCNO = b.DNDOCNO "+
		//			   " and b.TSAREANO=c.SAREA_NO"+
		//			   " and nvl(a.ORDER_TYPE_ID,b.ORDER_TYPE_ID) = c.OTYPE_ID";
		////out.println(sqlFACT);
		//ResultSet rsFACT=stateFACT.executeQuery(sqlFACT);
		//if (rsFACT.next())
		//{
		//	salesarea =rsFACT.getString(1);
		//	newShipDate= rsFACT.getString(2);
		//}
		//rsFACT.close();
		//stateFACT.close();

		////供應商=蘇固,貨要回台,add by Peggy 20180207
		//if (TEWTOTW.equals("Y"))
		//{
		//	sql = " select  b.TSAREANO,a.ASSIGN_MANUFACT,a.CUST_REQUEST_DATE,a.SHIPPING_METHOD,b.TSCUSTOMERID "+
		//		  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
		//		  ",oraddman.TSDELIVERY_NOTICE b"+
		//		  " where a.DNDOCNO='"+dnDocNo+"' "+
		//		  " and to_char(a.LINE_NO)="+lineNo+""+
		//		  " and a.dndocno=b.dndocno"+
		//		  " and a.ASSIGN_MANUFACT='008'"+
		//		  " and NVL(a.ORDER_TYPE_ID,b.ORDER_TYPE_ID)='1322'";
		//	//out.println(sql);
		//	Statement statex=con.createStatement();
		//	ResultSet rsx=statex.executeQuery(sql);
		//	if (rsx.next())
		//	{
		//		if (salesarea.equals("001"))
		//		{
		//			CallableStatement csg = con.prepareCall("{call tsc_edi_pkg.GET_SSD(?,?,?,?,?,?,?,sysdate)}");
		//			csg.setString(1,rsx.getString("TSAREANO"));
		//			csg.setString(2,rsx.getString("ASSIGN_MANUFACT"));
		//			csg.setString(3,rsx.getString("CUST_REQUEST_DATE"));
		//			csg.setString(4,rsx.getString("SHIPPING_METHOD"));
		//			csg.setString(5,"1141");
		//			csg.registerOutParameter(6, Types.VARCHAR);
		//			csg.setString(7,rsx.getString("TSCUSTOMERID"));
		//			csg.execute();
		//			newShipDate = (csg.getString(6)==null?"":csg.getString(6));
		//			csg.close();
		//
		//			sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set ORIG_SSD=NVL(ORIG_SSD,REQUEST_DATE),FTACPDATE=?,SHIP_DATE=?,PROMISE_DATE=?,REQUEST_DATE=?,ORDER_TYPE_ID=? where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
		//			PreparedStatement pstmt=con.prepareStatement(sql);
		//			pstmt.setString(1,newShipDate);
		//			pstmt.setString(2,newShipDate);
		//			pstmt.setString(3,newShipDate);
		//			pstmt.setString(4,newShipDate);
		//			pstmt.setString(5,"1022");
		//			pstmt.executeUpdate();
		//			pstmt.close();
		//			lineNo="";
		//			//factoryDate = "";
		//
%>
<!--			<script language="JavaScript" type="text/JavaScript">
					alert("供應商蘇固出貨須為1141訂單,系統已重新計算SSD,請確認交期,謝謝!");
				</script> 
	
	//			<%	
	//		}
	//		else
	//		{
	//			try
	//			{
	//				//sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set FTACPDATE=to_char(to_date(?,'yyyymmdd')+0.9993,'yyyymmddhh24miss'),ORDER_TYPE_ID=?,PC_COMMENT=PC_COMMENT||'1142=>1141 For Vendor Issue' where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
	//				sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set FTACPDATE=to_char(to_date(?,'yyyymmdd')+0.9993,'yyyymmddhh24miss')"+
	//				   " ,ORDER_TYPE_ID=?"+
	//				   " ,REASON_CODE='"+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"00":tsReasonNo):"REASON_CODE")+"'"+
	//				   " ,REASONDESC='"+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"N/A":remark):"REASONDESC")+"'"+
	//				   " ,PC_COMMENT=PC_COMMENT||'1142=>1141 For Vendor Issue'||'"+((tsReasonNo!=null && !tsReasonNo.equals("")) || (remark!=null && !remark.equals(""))?remark:"")+"'"+
	//				   " ,SLOW_MOVING_ALLOT_QTY="+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"0":allotQty):"SLOW_MOVING_ALLOT_QTY")+
	//				   " where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
	//				PreparedStatement pstmt=con.prepareStatement(sql);  		  
	//				pstmt.setString(1,factoryDate);  // 工廠交期安排
	//				pstmt.setString(2,"1022");  
	//				pstmt.executeUpdate(); 
	//				pstmt.close();	
					%>
					<!--<script language="JavaScript" type="text/JavaScript">
						alert("供應商蘇固出貨須為1141訂單,系統已將訂單類型從1142調整為1141,請確認交期,謝謝!");
					</script>-->
<%
	//			}
	//			catch(Exception e)
	//			{
	//				out.println(e.getMessage());
	//			}	
	//		}
	//	}
	//	rsx.close();
	//	statex.close();				
	//}
	//add by Peggy 20150812,TSCE ORDER PC交期晚於SSD且為SEA(C)計算工廠交期+FOB TERM是否在CRD前後兩天,若是,則PASS,否則自動UPDATE SHIPPING METHOD=AIR(C),重新計算SSD
	//else if (salesarea.equals("001"))
	if (salesarea.equals("001"))
	{
		sql = " select  b.TSAREANO,a.ASSIGN_MANUFACT,a.CUST_REQUEST_DATE,a.SHIPPING_METHOD,c.ORDER_NUM,b.TSCUSTOMERID,nvl(a.fob,b.FOB_POINT) FOB_POINT,b.delivery_to_org "+
				" from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,oraddman.TSDELIVERY_NOTICE b,oraddman.tsarea_ordercls c ,oraddman.tsprod_manufactory d,inv.mtl_system_items_b e "+
				" where a.DNDOCNO='"+dnDocNo+"' "+
				" and a.LINE_NO='"+lineNo+"'"+
				" and a.SHIPPING_METHOD='SEA(C)'"+
				" and to_date('"+newShipDate+"','yyyymmdd')+"+totwdays+" > to_date(substr(a.REQUEST_DATE,1,8),'yyyymmdd') "+
				" and abs(to_date('"+newShipDate+"','yyyymmdd')+"+totwdays+"+tsce_get_fob_term_days(a.SHIPPING_METHOD,a.FOB,c.ORDER_NUM,d.ALNAME,'OC',b.tscustomerid,null,b.delivery_to_org)-TO_DATE(SUBSTR(a.CUST_REQUEST_DATE,1,8),'yyyymmdd'))>2"+
				" and a.dndocno =b.dndocno"+
				" and b.TSAREANO=c.SAREA_NO"+
				" and a.ORDER_TYPE_ID=c.OTYPE_ID"+
				" and a.ASSIGN_MANUFACT=d.MANUFACTORY_NO"+
				" and a.inventory_item_id=e.inventory_item_id"+
				" and e.organization_id=49"+
				" and tsc_freight_rule_chk(b.TSAREANO, e.inventory_item_id,'AIR(C)','CHKFLAG')='1'"; //modify by Peggy 20200930
		//" and (select COUNT(1) from oraddman.tsce_air_sea_freight_rule x "+
		//"      where x.FREIGHT='AIR(C)' "+
		//"      and x.SALES_AREA_NO=b.TSAREANO"+
		//"      and x.tsc_package=tsc_om_category(e.inventory_item_id,49,'TSC_Package') "+
		//"      and x.TSC_FAMILY=tsc_om_category(e.inventory_item_id,49,'TSC_Family'))>0";
		//out.println(sql);
		Statement statex=con.createStatement();
		ResultSet rsx=statex.executeQuery(sql);
		if (rsx.next())
		{
			CallableStatement csg = con.prepareCall("{call tsc_edi_pkg.GET_SSD(?,?,?,?,?,?,?,sysdate,?,?)}");
			csg.setString(1,rsx.getString("TSAREANO"));
			csg.setString(2,rsx.getString("ASSIGN_MANUFACT"));
			csg.setString(3,rsx.getString("CUST_REQUEST_DATE"));
			csg.setString(4,"AIR(C)");
			csg.setString(5,rsx.getString("ORDER_NUM"));
			csg.registerOutParameter(6, Types.VARCHAR);
			csg.setString(7,rsx.getString("TSCUSTOMERID"));
			csg.setString(8,rsx.getString("FOB_POINT"));   //add by Peggy 20210207 
			csg.setString(9,rsx.getString("delivery_to_org"));   //add by Peggy 20210207 
			csg.execute();
			newShipDate = (csg.getString(6)==null?"":csg.getString(6));
			csg.close();

			sql = " update ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
					" set ORIG_SHIPPING_METHOD=NVL(ORIG_SHIPPING_METHOD,SHIPPING_METHOD)"+
					",ORIG_SSD=NVL(ORIG_SSD,REQUEST_DATE)"+
					",FTACPDATE=?"+
					",SHIP_DATE=?"+
					",PROMISE_DATE=?"+
					",REQUEST_DATE=?"+
					",SHIPPING_METHOD=?"+
					",ORIG_PC_SSD=?"+
					" where DNDOCNO='"+dnDocNo+"' "+
					" and LINE_NO='"+lineNo+"' ";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,newShipDate);
			pstmt.setString(2,newShipDate);
			pstmt.setString(3,newShipDate);
			pstmt.setString(4,newShipDate);
			pstmt.setString(5,"AIR(C)");
			pstmt.setString(6,factoryDate);
			pstmt.executeUpdate();
			pstmt.close();
			//factoryDate = "";            

%>
<script language="JavaScript" type="text/JavaScript">
	alert("因工廠交期+海運船期無法meet客戶CRD,運輸方式將從SEA(C)改為AIR(C)且重新計算SSD,請確認AIR(C)交期,謝謝!");
</script>
<%
	}
	else
	{
		lineNo="";
	}
	//else
	//{
	//	try
	//	{
	//		//sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set FTACPDATE=to_char(to_date(?,'yyyymmdd')+0.9993,'yyyymmddhh24miss') where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
	//		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set FTACPDATE=to_char(to_date(?,'yyyymmdd')+0.9993,'yyyymmddhh24miss')"+
	//		   " ,REASON_CODE='"+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"00":tsReasonNo):"REASON_CODE")+"'"+
	//		   " ,REASONDESC='"+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"N/A":remark):"REASONDESC")+"'"+
	//		   " ,PC_COMMENT=PC_COMMENT||'"+((tsReasonNo!=null && !tsReasonNo.equals("")) || (remark!=null && !remark.equals(""))?remark:"")+"'"+
	//		   " ,SLOW_MOVING_ALLOT_QTY="+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"0":allotQty):"SLOW_MOVING_ALLOT_QTY")+
	//		   " where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
	//		PreparedStatement pstmt=con.prepareStatement(sql);
	//		pstmt.setString(1,factoryDate);  // 工廠交期安排
	//		pstmt.executeUpdate();
	//		pstmt.close();
	//	}
	//	catch(Exception e)
	//	{
	//		out.println(sql+e.getMessage());
	//	}
	//}
	rsx.close();
	statex.close();
}
else if (salesarea.equals("008") && !newShipDate.startsWith("2099")) //add by Peggy 20160825,工廠CONFIRM SEA(UC)無法滿足客戶CRD,運輸方式由SEA(UC)改成AIR(UC),系統重新計算AIR(UC)交期供工廠確認
{
	sql = " select '1' as data_type, b.TSAREANO,a.ASSIGN_MANUFACT,a.CUST_REQUEST_DATE,f.meaning SHIPPING_METHOD,c.ORDER_NUM,b.TSCUSTOMERID ,tsc_om_category(e.inventory_item_id,49,'TSC_Package') tsc_package,tsc_om_category(e.inventory_item_id,49,'TSC_Family') tsc_family"+
			//",TSC_RFQ_GET_TSCA_SSD(c.ORDER_NUM,'AIR(UC)',SUBSTR(a.CUST_REQUEST_DATE,1,8)) NEW_SSD"+
			",TSCA_GET_ORDER_SSD(c.ORDER_NUM,'AIR(UC)',SUBSTR(a.CUST_REQUEST_DATE,1,8),'CRD',trunc(sysdate),null) NEW_SSD"+  //modify by Peggy 20161019
			",(SELECT lookup_code e FROM fnd_lookup_values lv WHERE  language ='US' AND view_application_id = 3  AND lookup_type = 'SHIP_METHOD' AND security_group_id = 0 and meaning='AIR(UC)') NEW_SHIPPING_METHOD"+
			" from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,oraddman.TSDELIVERY_NOTICE b,oraddman.tsarea_ordercls c,inv.mtl_system_items_b e,"+
			" (SELECT lookup_code, meaning,description,enabled_flag,start_date_active,end_date_active FROM fnd_lookup_values lv"+
			" WHERE  language ='US' AND view_application_id = 3   AND lookup_type = 'SHIP_METHOD' AND security_group_id = 0) f"+
			" where a.DNDOCNO='"+dnDocNo+"' "+
			" and to_char(a.LINE_NO)="+lineNo+""+
			" and a.SHIPPING_METHOD=f.lookup_code"+
			" and f.meaning='SEA(UC)'"+
			" and to_date('"+newShipDate+"','yyyymmdd')+"+totwdays+" > to_date(substr(a.REQUEST_DATE,1,8),'yyyymmdd') "+
			" and a.dndocno =b.dndocno"+
			" and a.inventory_item_id=e.inventory_item_id"+
			" and e.organization_id=49"+
			" and b.TSAREANO=c.SAREA_NO"+
			" and a.ORDER_TYPE_ID=c.OTYPE_ID"+
			" and TO_DATE(SUBSTR(a.CUST_REQUEST_DATE,1,8),'yyyymmdd')-to_date('"+newShipDate+"','yyyymmdd')+"+totwdays+" < tsc_freight_rule_chk(b.TSAREANO, e.inventory_item_id,f.meaning,'START_DAY')"+  //modify by Peggy 20200930
			" and tsc_freight_rule_chk(b.TSAREANO, e.inventory_item_id,'AIR(UC)','CHKFLAG')='1'"+ //modify by Peggy 20200930
			//" and TO_DATE(SUBSTR(a.CUST_REQUEST_DATE,1,8),'yyyymmdd')-to_date('"+newShipDate+"','yyyymmdd')+"+totwdays+" < (select  SDAYS from oraddman.tsce_air_sea_freight_rule m where m.tsc_package=tsc_om_category(e.inventory_item_id,49,'TSC_Package') "+
			//" and m.TSC_FAMILY=tsc_om_category(e.inventory_item_id,49,'TSC_Family') and m.SALES_AREA_NO=b.TSAREANO and m.FREIGHT=f.meaning)"+
			//" and (select COUNT(1) from oraddman.tsce_air_sea_freight_rule x "+
			//"    where x.FREIGHT='AIR(UC)' "+
			//"    and x.SALES_AREA_NO=b.TSAREANO"+
			//"    and x.tsc_package=tsc_om_category(e.inventory_item_id,49,'TSC_Package') "+
			//"    and x.TSC_FAMILY=tsc_om_category(e.inventory_item_id,49,'TSC_Family'))>0"+
			//針對出貨方式只有海運的材料,工廠確認交期後不要連動交期需求日的重新計算,維持原先交期需求日 for cindy 20190627 issue,add by Peggy 20190628
			// " union all"+
			// " select '2' as  data_type,b.TSAREANO,a.ASSIGN_MANUFACT,a.CUST_REQUEST_DATE,d.meaning SHIPPING_METHOD,c.ORDER_NUM,b.TSCUSTOMERID ,tsc_om_category(a.inventory_item_id,49,'TSC_Package') tsc_package,tsc_om_category(a.inventory_item_id,49,'TSC_Family') tsc_family,"+
			// " TSCA_GET_ORDER_SSD(c.ORDER_NUM,d.meaning,'"+newShipDate+"','SSD',trunc(sysdate),null) NEW_SSD,d.lookup_code new_shipping_method "+
			// " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,oraddman.TSDELIVERY_NOTICE b, oraddman.tsarea_ordercls c,(SELECT lookup_code,meaning FROM fnd_lookup_values lv WHERE  language ='US' AND view_application_id = 3  AND lookup_type = 'SHIP_METHOD' AND security_group_id = 0) d"+
			// " where a.DNDOCNO='"+dnDocNo+"' "+
			// " and to_char(a.LINE_NO)="+lineNo+""+
			// " and a.dndocno=b.dndocno "+
			// " and b.TSAREANO=c.SAREA_NO"+
			// " and a.ORDER_TYPE_ID=c.OTYPE_ID"+
			// " and a.shipping_method=d.lookup_code"+
			// " and d.meaning='SEA(UC)'"+
			// " and to_date('"+newShipDate+"','yyyymmdd') > to_date(substr(a.REQUEST_DATE,1,8),'yyyymmdd')	"+
			" order by 1";
	Statement statex=con.createStatement();
	ResultSet rsx=statex.executeQuery(sql);
	if (rsx.next())
	{
		newShipDate = rsx.getString("new_ssd");

		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set ORIG_SHIPPING_METHOD=NVL(ORIG_SHIPPING_METHOD,SHIPPING_METHOD),ORIG_SSD=NVL(ORIG_SSD,REQUEST_DATE),FTACPDATE=?,SHIP_DATE=?,PROMISE_DATE=?,REQUEST_DATE=?,SHIPPING_METHOD=? ,ORIG_PC_SSD=? where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);
		pstmt.setString(1,newShipDate);
		pstmt.setString(2,newShipDate);
		pstmt.setString(3,newShipDate);
		pstmt.setString(4,newShipDate);
		pstmt.setString(5,rsx.getString("NEW_SHIPPING_METHOD"));
		pstmt.setString(6,factoryDate);
		pstmt.executeUpdate();
		pstmt.close();
		//factoryDate = "";

%>
<script language="JavaScript" type="text/JavaScript">
	<%
    if (rsx.getString("data_type").equals("1"))
    {
    %>
	alert("因工廠交期+海運船期無法meet客戶CRD,運輸方式將從SEA(UC)改為AIR(UC)且重新計算SSD,請確認AIR(UC)交期,謝謝!");
	<%
    }
    else
    {
    %>
	alert("因工廠交期無法meet TSCA船期,系統將依工廠交期計算符合TSCA船期的SSD,請重新確認新交期,謝謝!");
	<%
    }
    %>
</script>
<%
			}
			else
			{
				lineNo="";
			}
			//else
			//{
			//	try
			//	{
			//		//sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set FTACPDATE=to_char(to_date(?,'yyyymmdd')+0.9993,'yyyymmddhh24miss') where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
			//		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set FTACPDATE=to_char(to_date(?,'yyyymmdd')+0.9993,'yyyymmddhh24miss')"+
			//		   " ,REASON_CODE='"+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"00":tsReasonNo):"REASON_CODE")+"'"+
			//		   " ,REASONDESC='"+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"N/A":remark):"REASONDESC")+"'"+
			//		   " ,PC_COMMENT=PC_COMMENT||'"+((tsReasonNo!=null && !tsReasonNo.equals("")) || (remark!=null && !remark.equals(""))?remark:"")+"'"+
			//		   " ,SLOW_MOVING_ALLOT_QTY="+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"0":allotQty):"SLOW_MOVING_ALLOT_QTY")+
			//		   " where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
			//		PreparedStatement pstmt=con.prepareStatement(sql);
			//		pstmt.setString(1,factoryDate);  // 工廠交期安排
			//		pstmt.executeUpdate();
			//		pstmt.close();
			//	}
			//	catch(Exception e)
			//	{
			//		out.println(e.getMessage());
			//	}
			//}
			rsx.close();
			statex.close();
		}
		//else
		//{
		//	try
		//	{
		//		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set FTACPDATE=to_char(to_date(?,'yyyymmdd')+0.9993,'yyyymmddhh24miss')"+
		//			   " ,REASON_CODE='"+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"00":tsReasonNo):"REASON_CODE")+"'"+
		//			   " ,REASONDESC='"+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"N/A":remark):"REASONDESC")+"'"+
		//			   " ,PC_COMMENT=PC_COMMENT||'"+((tsReasonNo!=null && !tsReasonNo.equals("")) || (remark!=null && !remark.equals(""))?remark:"")+"'"+
		//			   " ,SLOW_MOVING_ALLOT_QTY="+(tsReasonNo!=null && !tsReasonNo.equals("")?(tsReasonNo.equals("--")?"0":allotQty):"SLOW_MOVING_ALLOT_QTY")+
		//			   " where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
		//		//out.println(sql);
		//		PreparedStatement pstmt=con.prepareStatement(sql);
		//		pstmt.setString(1,factoryDate);  // 工廠交期安排
		//		pstmt.executeUpdate();
		//		pstmt.close();
		//	}
		//	catch(Exception e)
		//	{
		//		out.println(e.getMessage());
		//	}
		//}

	
	/*if (tsReasonNo!=null && !tsReasonNo.equals(""))
	{
		if (tsReasonNo.equals("--"))
		{
			String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set REASON_CODE=?,REASONDESC=?, PC_COMMENT=PC_COMMENT||?,SLOW_MOVING_ALLOT_QTY=0 where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
			PreparedStatement pstmt=con.prepareStatement(sql);  
			pstmt.setString(1,"00");  // 重新指派或批退原因碼 
			pstmt.setString(2,"N/A");  // 批退原因
			pstmt.setString(3,remark);  //add by Peggy 20140402
			pstmt.executeUpdate(); 
			pstmt.close();	
		}
		else
		{		
			String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set REASON_CODE=?,REASONDESC=?, PC_COMMENT=PC_COMMENT||?,SLOW_MOVING_ALLOT_QTY=? where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
			PreparedStatement pstmt=con.prepareStatement(sql);  
			pstmt.setString(1,tsReasonNo);  // 重新指派或批退原因碼 
			pstmt.setString(2,remark);  // 批退原因
			pstmt.setString(3,remark);  // 20101203
			pstmt.setString(4,allotQty);  //add by Peggy 20130422
			pstmt.executeUpdate(); 
			pstmt.close();	
		}	
	}
	else if (remark!=null && !remark.equals(""))
	{
		String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set PC_COMMENT=PC_COMMENT||? where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO)='"+lineNo+"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);  
		pstmt.setString(1,remark);  // 詢問單號	 20101112	
		pstmt.executeUpdate(); 
		pstmt.close();
	}*/

	}

%>
<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>","<jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/>","<jsp:getProperty name="rPH" property="pgAlertReassign"/>","<jsp:getProperty name="rPH" property="pgAlertRPReason"/>")' ACTION="../jsp/TSSalesDRQMProcessNew.jsp?DNDOCNO=<%=dnDocNo%>" METHOD="post">
	<!--=============以下區段為取得維修基本資料==========-->
	<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
	<!--=================================-->
	<HR>
	<table border="1" cellpadding="1" cellspacing="0" align="center" width="97%" bordercolor="#999966"  bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
		<tr bgcolor='#D5D8A7'>
			<td colspan="3"><font color="#000066">
				<jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/></font>
				:&nbsp;&nbsp;&nbsp;<img src="../image/point.gif"><jsp:getProperty name="rPH" property="pgNoBlankMsg"/><BR>
					<%
try
{   
	//String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    //array2DEstimateFactoryBean.setArrayString(oneDArray);
	//String b[][]=new String[rowLength+1][9]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
   	out.println("<TABLE border='1' cellpadding='0' cellspacing='1' align='center' width='100%'  bordercolor='#999966' bordercolorlight='#999999' bordercolordark='#CCCC99' bgcolor='#CCCC99'>");
	out.println("<tr bgcolor='#D5D8A7'>");
	out.println("<td nowrap>");   
%>
				<div align="center">
					<!--<input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>-->
					<input type="checkbox" name="chkall"onClick="checkall()">
				</div>
					<%
	out.println("</td>");
	//out.println("<td><font color='#000000'>&nbsp;</td>");
	out.println("<td nowrap width='1%'><font color='#000000'>");
%>
				<jsp:getProperty name="rPH" property="pgFDeliveryDate"/>
					<%
	//if (orderTypeID.equals("1021") || orderTypeID.equals("1022")) 
	//{ 
%>
				<!--< <jsp:getProperty name="rPH" property="pgReturnTWN"/> > -->
					<%
	//} // 若是訂單類型屬於1131或1141則顯示<回T> 
%>
					<%
	//改放至每一個line,modify by Peggy 20191024
	/*out.println("</div>");
	try
    { 
		out.println("<input name='FACTORYDATE' type='text' size='8' ");
		if (lineNo!=null) out.println("value="+factoryDate); 
		else out.println("value="+factoryDate); 
		out.println("><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.FACTORYDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");	   
	} //end of try		 
    catch (Exception e) 
	{ 
		out.println("Exception3:"+e.getMessage()); 
	} 
	*/
	out.println("</font>");
	out.println("</td>");
	out.println("<td width='12%'><font color='#000000'>");
%>
				Slow Moving/<jsp:getProperty name="rPH" property="pgASResActInput"/>
					<%
	out.println("</div>");
	//改放至每一個line,modify by Peggy 20191024
	/*out.println("<div align='center'>");
	try
    { // 動態去取重新分派或批退原因資訊 						  
		Statement stateGetP=con.createStatement();
        ResultSet rsGetP=null;				      									  
		String sqlGetP = "select TSREASONNO, REASONCODE||'('||REASONDESC||')' as RREASON "+
		                 "from ORADDMAN.TSREASON "+
		                 "where LOCALE = '"+locale+"' "+																  
		  		         "order by TSREASONNO "; 		  
        rsGetP=stateGetP.executeQuery(sqlGetP);
		comboBoxBean.setRs(rsGetP);
		comboBoxBean.setSelection(tsReasonNo);
	    comboBoxBean.setFieldName("TSREASONNO");
		comboBoxBean.setOnChangeJS("setReasonCode()");	 //add by Peggy 20130423				     
        out.println(comboBoxBean.getRsString());				
		stateGetP.close();		  		  
		rsGetP.close();
	} //end of try		 
    catch (Exception e) 
	{ 
		out.println("Exception4:"+e.getMessage()); 
	} 
	out.println("</div>");
	*/
	out.println("</font></td>");
	out.println("<td nowrap width='12%'><font color='#000000'>");
%>
				Slow Moving<jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgReAssign"/><br><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgReject"/><jsp:getProperty name="rPH" property="pgDesc"/>
					<%
	//改放至每一個line,modify by Peggy 20191024
	/*out.println("<div align='center'>");
	try
    { 
		out.print("<input name='REMARK' type='text' size='12' ");
		out.print("value="+remark); 
		out.println(">");	   
	} //end of try		 
    catch (Exception e) 
	{ 
		out.println("Exception5:"+e.getMessage()); 
	}
    out.println("</div>");
	*/
	out.println("</font></td>");
	out.println("<td width='8%' nowrap><font color='#000000'>Allot Qty(K)</font>");
	//out.println("<div align='center'><input name='ALLOTQTY' type='text' size='10' onkeypress='numCheckInt();' "+ (tsReasonNo == null || !tsReasonNo.equals("08")?"disabled":"")+"></div>");
	out.println("</td>"); //add by Peggy 20130419
	out.println("<td width='8%' align='center'>Slow<BR>Moving");
	%><jsp:getProperty name="rPH" property="pgRemark"/><%
	out.println("</td>");
	//add by Peggy 20140328
	if (vendor_flag.equals("Y") || vendor_flag.equals("2"))
	{
		out.println("<td width='6%' align='center'><font color='#000000'>Stock Info");
		out.println("</font></td>");		
	}
	out.println("<td width='1%' nowrap><font color='#000000'>");
%>

				<jsp:getProperty name="rPH" property="pgAnItem"/>
					<%
	out.println("</font></td><td><font color='#000000'>");
%>
				<jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>
					<%
   	out.println("</font></td><td><font color='#000000'>End Cust</font></td>");
   	out.println("<td><font color='#000000'>Package</font></td><td><font color='#000000'>");
%>
				<jsp:getProperty name="rPH" property="pgCustItemNo"/>
					<%
	out.println("</font></td><td><font color='#000000'>");
%>
				<jsp:getProperty name="rPH" property="pgQty"/>
					<%
	out.println("</font></td><td><font color='#000000'>");
%>
				<jsp:getProperty name="rPH" property="pgUOM"/>
					<%
	out.println("</font></td><td><font color='#000000'>");
%>
				<jsp:getProperty name="rPH" property="pgRequestDate"/>
					<%
	out.println("</font></td><td><font color='#000000'>");
%>
				<jsp:getProperty name="rPH" property="pgRemark"/>
					<%
	out.println("</font></td>");
	int k=0,linecnt=0;
	String sqlEst = "";
	sqlEst = " select y.*"+
	         ",(SELECT COUNT (1) FROM oraddman.tsc_idle_stock_detail x WHERE  EXISTS (SELECT 1 FROM oraddman.tsc_idle_stock_header b WHERE b.version_id = x.version_id  AND b.version_flag = 'A') and x.item_desc1 = y.TSC_desc) idle_cnt"+
	         ",count(1) over (partition by y.dndocno) line_cnt"+ //add by Peggy 20191025
			 " from (SELECT a.dndocno,a.line_no,a.item_segment1,a.item_description, a.quantity,a.uom, a.request_date,a.remark, a.pc_comment, a.assign_manufact,a.ftacpdate, a.reasondesc, a.reason_code,a.inventory_item_id,a.slow_moving_allot_qty,"+
			 " CASE WHEN INSTR (a.item_description, '-') > 0 THEN SUBSTR (a.item_description,0,INSTR (a.item_description, '-') - 1) ELSE SUBSTR (a.item_description,0, LENGTH (a.item_description)- LENGTH (apps.tsc_get_item_packing_code (49,inventory_item_id)) - 1) END AS TSC_desc"+
			 ",a.vendor_site_id,nvl(c.vendor_site_code,'') vendor_site_code "+ //add by Peggy 20140328
			 ",'原訂單'|| (NVL(a.SMC_QTY,0)+nvl(a.QUANTITY,0)) ||'K<BR>消庫存'||(NVL(a.SMC_QTY,0)+nvl(a.SLOW_MOVING_ALLOT_QTY,0))||'K' AS SMC_REMARKS,(NVL(a.SMC_QTY,0)+nvl(a.SLOW_MOVING_ALLOT_QTY,0)) SMC_QTY"+ //add by Peggy 20141013
			 ",a.ORDERED_ITEM"+ //add by Peggy 20150123
			 ",case when a.ORDER_TYPE_ID=1175 and instr(a.CUST_PO_NUMBER, '(GE)')>0 then TSCH_GET_CUST_SHIP_FREQUENCY(a.orig_so_line_id) "+
			 " when a.order_type_id = 1175 AND '"+tsAreaNo+"'='003' THEN tsc_get_cust_ship_frequency (a.SHIP_TO_ORG) "+
			 " when a.assign_manufact ='002' and nvl(a.order_type_id,a.order_type_id1) in ('1021','1022') then 2 "+ //yew回t統一為周一,add by Peggy 20170510
			 " when a.tscustomerid=4985 and a.assign_manufact ='002' and a.shipping_method='SEA' and instr(a.remark,'急料')<=0 then 2"+  //add by Peggy 20181113,MUSTARD固定週一出貨(BY SEA),但急料排外
			 " else 0 end SHIP_FREQUENCY"+ //add by Peggy 20160913
			 ",nvl(a.order_type_id,a.order_type_id1) order_type_id"+  //add by Peggy 20180207
			 ",TSC_INV_Category(a.inventory_item_id, 49, 23)  tsc_package"+ //add by Peggy 20181221
			 //",tsc_get_china_to_tw_days(null,e.order_num,a.inventory_item_id,a.assign_manufact,a.tscustomerid,null) * CASE WHEN a.direct_ship_to_cust =1  and a.assign_manufact='002' THEN 0 ELSE 1 END TOTW_DAYS"+ //add by Peggy 20191028
			 ",tsc_get_china_to_tw_days(( select ALNAME FROM ORADDMAN.TSPROD_MANUFACTORY A WHERE A.MANUFACTORY_NO=a.assign_manufact),e.order_num,a.inventory_item_id,a.assign_manufact,a.tscustomerid,to_char(sysdate,'yyyymmdd'),a.CUST_PO_NUMBER) * CASE WHEN a.direct_ship_to_cust =1  and a.assign_manufact='002' THEN 0 ELSE 1 END TOTW_DAYS"+ //add by Peggy 20200911
			 ",nvl(a.ORIG_SHIPPING_METHOD,'NULL') ORIG_SHIPPING_METHOD"+ //add by Peggy 20191103
			 ",(SELECT  meaning FROM fnd_lookup_values lv WHERE  lv.language ='US' AND lv.view_application_id = 3   AND lv.lookup_type = 'SHIP_METHOD' AND lv.security_group_id = 0 AND lv.LOOKUP_CODE=a.SHIPPING_METHOD) shipping_method_name"+ //add by Peggy 20191115
			 //",(select NVL(msi.attribute16,'N') from inv.mtl_system_items_b msi where a.inventory_item_id=msi.inventory_item_id and msi.organization_id=mp.organization_Id) forecastitem_flag"+ //add by Peggy 20191031
			 //",NVL((select  distinct 'Y' from oraddman.tssg_forecast_item_history x,inv.mtl_system_items_b msi,tsc_po_unallocated y where x.organization_id(+)=msi.organization_id and x.item_name(+)=msi.segment1 and y.type_id=3 and msi.organization_id=y.organization_id and msi.inventory_item_id=y.inventory_item_id and nvl(y.quantity,0)-nvl(y.rfq_allocated_quantity,0)>0  and a.inventory_item_id=msi.inventory_item_id and msi.organization_id=mp.organization_Id),'N') forecastitem_flag"+ //add by Peggy 20191120
			 ",NVL((select  distinct 'Y' from oraddman.tssg_forecast_item_history x,inv.mtl_system_items_b msi,tsc_po_unallocated y where x.organization_id=msi.organization_id and x.item_name=msi.segment1 and msi.organization_id=y.organization_id and msi.inventory_item_id=y.inventory_item_id and nvl(y.quantity,0)-nvl(y.rfq_allocated_quantity,0)>0  and a.inventory_item_id=msi.inventory_item_id and msi.organization_id=mp.organization_Id),'N') forecastitem_flag"+ //add by Peggy 20200714
			 ",e.order_num"+ //add by Peggy 20191031
			 //" FROM oraddman.tsdelivery_notice_detail a"+
			 ",a.end_customer"+ //add by Peggy 20240220
             " FROM (select a.*,d.SHIP_TO_ORG ,nvl(a.order_type_id,d.order_type_id) order_type_id1,d.tscustomerid,d.tsareano from  oraddman.tsdelivery_notice_detail a,oraddman.tsdelivery_notice d where  a.dndocno =d.dndocno ) a"+
			 ",ap.ap_supplier_sites_all c"+
			 //",oraddman.tsdelivery_notice d"+
			 ",oraddman.tsarea_ordercls e"+
			 ",inv.mtl_parameters mp"+
			 " WHERE a.vendor_site_id = c.vendor_site_id(+)"+
			 " and a.dndocno ='"+dnDocNo+"' "+
			 " AND a.lstatusid = '"+frStatID+"'"+
			 " and a.tsareano=e.sarea_no(+)"+
			 //" and mp.organization_code =case when a.assign_manufact in ('005','008') then case when substr(e.order_num,1,1) in ('8') then 'SG1' else 'SG2' end else 'I1' end"+
			 " and mp.organization_code =case when a.assign_manufact in ('005','008') then case when substr(e.order_num,1,1) in ('8') then 'SG1' else 'SG2' end else 'I1' end"+
             " and a.order_type_id1=e.otype_id(+)";
			 //" and a.dndocno =d.dndocno	";
	if (UserRoles.indexOf("admin")<0) sqlEst += " and a.ASSIGN_MANUFACT = '"+userProdCenterNo+"'";
	sqlEst +=") y ORDER BY line_no";
	//out.println(sqlEst);
    Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sqlEst);
	while (rs.next())
	{
		String custItem = rs.getString("ORDERED_ITEM"); //modify by Peggy 20150123

	    //String reasonDesc = "";
	    //Statement stateReason=con.createStatement();
		//if (tsReasonNo ==null || tsReasonNo.equals("")) tsReasonNo = rs.getString("REASON_CODE");
	    ////ResultSet rsReason=stateReason.executeQuery("select * from ORADDMAN.TSREASON where TSREASONNO='"+rs.getString("REASON_CODE")+"'");
		//ResultSet rsReason=stateReason.executeQuery("select * from ORADDMAN.TSREASON where TSREASONNO='"+rs.getString("REASON_CODE")+"' and LOCALE ='"+locale+"'");
		//if (rsReason.next())
		//{
		//	reasonDesc = "("+rsReason.getString("REASONCODE")+")"+rsReason.getString("REASONDESC");
		//}
		//rsReason.close();
		//stateReason.close();
	    out.print("<TR bgcolor='#D5D8A7' onMouseOut='chkDate1("+'"'+rs.getString("LINE_NO")+'"'+","+'"'+dnDocNo+'"'+")'>");

		out.println("<TD width='1%'>");
		if (rs.getInt("line_cnt")==1 || choiceLine.indexOf(","+rs.getString("LINE_NO")+",")>=0)
		{
			checkflag=true;
		}
		else
		{
			checkflag=false;
		}
		out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' onClick='setCheck("+(linecnt++)+")' "+(checkflag?"checked":"")+">");
		//if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		//{  //out.println("111");
		//	for (int j=0;j<check.length;j++)
		//	{
		//		if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO"))) out.println("checked");
		//	}
		// 	if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); // 給定生產日期即設定欲結轉
		//}
		//else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉
		//if (rowLength==1) out.println("checked >"); else out.println(" >");
		out.println("</TD>");
		//out.println("<TD width='1%' nowrap><font color='#000000'>");
		//out.println("<INPUT TYPE='button' value='Set' onClick='setSubmit2("+'"'+"../jsp/TSSalesDRQEstimatingPage.jsp?LINENO="+rs.getString("LINE_NO")+"&DNDOCNO="+dnDocNo+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+","+'"'+dateBean.getYearMonthDay()+'"'+")'>");
		//out.println("</TD>");
      	out.println("<TD width='5%' nowrap><font color='#000000'><input type='hidden' name='order_type_id_"+rs.getString("LINE_NO")+"' value='"+rs.getString("order_type_id")+"'><input type='hidden' name='totw_days_"+rs.getString("LINE_NO")+"' value='"+rs.getString("TOTW_DAYS")+"'><input type='hidden' name='ORIG_SHIPPING_METHOD_"+rs.getString("LINE_NO")+"' value='"+rs.getString("ORIG_SHIPPING_METHOD")+"'><input type='hidden' name='SHIPPING_METHOD_"+rs.getString("LINE_NO")+"' value='"+rs.getString("SHIPPING_METHOD_NAME")+"'>");
		/*if (rs.getString("FTACPDATE")==null || rs.getString("FTACPDATE").equals("") || rs.getString("FTACPDATE")=="N/A" || rs.getString("FTACPDATE").equals("N/A"))
		{
			if (lineNo==null || lineNo.equals(""))
		  	{
				out.println("<font color='#000099'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font>"+"</font>");
			}
		  	else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO")))
		  	{
				out.println(factoryDate+"</font>");
			}
		  	else
			{
				out.println("<font color='#000099'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font>"+"</font>");
			}
		}
		else
		{
			out.println("<font color='#FF0000'>");
			if (lineNo!=rs.getString("LINE_NO") && !lineNo.equals(rs.getString("LINE_NO")))
			{
				out.println(rs.getString("FTACPDATE").substring(0,8)+"</font>");
			}
			else
			{
				out.println(factoryDate+"</font>");
			}
		}*/

		out.println("<input name='FACTORYDATE_"+rs.getString("LINE_NO")+"'"+" type='text' size='8' value='"+(request.getParameter("FACTORYDATE_"+rs.getString("LINE_NO"))==null || rs.getString("LINE_NO").equals(lineNo)?rs.getString("REQUEST_DATE").substring(0,8):request.getParameter("FACTORYDATE_"+rs.getString("LINE_NO")))+"' style='font-size:11px;font-family: Tahoma,Georgia' onKeyPress='return (event.keyCode >=48 && event.keyCode <=57)'  onBlur='chkDate("+'"'+rs.getString("LINE_NO")+'"'+","+'"'+dnDocNo+'"'+")' "+(checkflag?"":" ")+">");
		out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.FACTORYDATE_"+rs.getString("LINE_NO")+");return false;'><img name='img_"+rs.getString("LINE_NO")+"' border='0' src='../image/calbtn.gif'></A>");
		out.println((rs.getInt("totw_days")>0?"<font color='#0000ff'><回T></font>":""));
		out.println("<input type='text' name='ORIG_REQUESTDATE_"+rs.getString("LINE_NO")+"' value='"+(request.getParameter("FACTORYDATE_"+rs.getString("LINE_NO"))==null || rs.getString("LINE_NO").equals(lineNo)?rs.getString("REQUEST_DATE").substring(0,8):request.getParameter("FACTORYDATE_"+rs.getString("LINE_NO")))+"' style='width:1'></TD>");
		// 重新指派或批退代碼選擇
		out.println("<TD width='10%' nowrap><font color='#000000'>");
		/*if (rs.getString("REASON_CODE")==null || rs.getString("REASON_CODE").equals("00"))
		{
			out.println("<font color='#000000'>");
		  	if (lineNo.equals(rs.getString("LINE_NO")) || lineNo==rs.getString("LINE_NO"))
		  	{
				out.println(tsReasonNo+reasonDesc+"</font>");
			}
		  	else
		  	{
				out.println("</font>");
			}
		}
		else
		{
			out.println("<font color='#FF0000'>");
			if (lineNo!=rs.getString("LINE_NO") && !lineNo.equals(rs.getString("LINE_NO")))
			{
				out.println(rs.getString("REASON_CODE")+reasonDesc+"</font>");
			}
			else
			{
				out.println(tsReasonNo+reasonDesc+"</font>");
			}
		}
		out.println("<INPUT TYPE='hidden' NAME='REASONCODE"+k+"' value='"+rs.getString("REASON_CODE")+"'>"); // 隱藏被指派工廠物件,以便由 java _script判斷是否使用者未指派即送出網頁
		*/
		Statement stateGetP=con.createStatement();
		String sqlGetP = " select TSREASONNO, REASONCODE||'('||REASONDESC||')' as RREASON,rownum ,count(1) over (partition by 1) tot_row"+
		                 " from ORADDMAN.TSREASON "+
		                 " where LOCALE = '"+locale+"' "+
		  		         " order by TSREASONNO ";
         ResultSet rsGetP=stateGetP.executeQuery(sqlGetP);
		//comboBoxBean.setRs(rsGetP);
		//comboBoxBean.setSelection(tsReasonNo);
	    //comboBoxBean.setFieldName("REASONCODE_"+rs.getString("LINE_NO"));
		//comboBoxBean.setOnChangeJS("setReasonCode("+'"'+rs.getString("LINE_NO")+'"'+")");	 //add by Peggy 20130423
        //out.println(comboBoxBean.getRsString());
		while (rsGetP.next())
		{
			if (rsGetP.getInt("rownum")==1)
			{
			%>
				<select  NAME="REASONCODE_<%=rs.getString("LINE_NO")%>" onChange="setReasonCode('<%=rs.getString("LINE_NO")%>')" style="font-family: Tahoma,Georgia; font-size:11px" <%=(checkflag?"":"")%>>
					<OPTION VALUE=-- <%if (request.getParameter("REASONCODE_"+rs.getString("LINE_NO"))==null) out.println("selected");%>>--</OPTION>
					<%
						}
					%>
					<OPTION VALUE="<%=rsGetP.getString("TSREASONNO")%>" <%=(request.getParameter("REASONCODE_"+rs.getString("LINE_NO"))!=null && (request.getParameter("REASONCODE_"+rs.getString("LINE_NO"))).equals(rsGetP.getString("TSREASONNO"))?"selected":"")%>><%=rsGetP.getString("RREASON")%></OPTION>
					<%
						if (rsGetP.getInt("rownum")==rsGetP.getInt("tot_row"))
						{
					%>
				</select>
					<%
			}
			%>
					<%
		}
		stateGetP.close();
		rsGetP.close();
		out.println("</TD>"); // // 重新指派或批退代碼選擇
		// 重新指派使用者自行輸入說明
		out.println("<TD width='10%' align='center' nowrap>");
		/*if (rs.getString("REASONDESC")==null || rs.getString("REASONDESC").equals("") || rs.getString("REASONDESC").equals("N/A"))
		{
			out.println("<font color='#000000'>");
		  	if (lineNo.equals(rs.getString("LINE_NO")) || lineNo==rs.getString("LINE_NO"))
		  	{
				out.println(remark+"</font>");
			}
		  	else
		  	{
				//out.println("</font>");
				//out.println(rs.getString("PC_COMMENT")+"</font>");  //modify by Peggy 20111103
				out.println(((rs.getString("PC_COMMENT")==null || rs.getString("PC_COMMENT").equals(""))?"&nbsp;":rs.getString("PC_COMMENT"))+"</font>");  //modify by Peggy 20120629
			}
		}
		else
		{
			out.println("<font color='#FF0000'>");
			if (lineNo!=rs.getString("LINE_NO") && !lineNo.equals(rs.getString("LINE_NO")))
			{
				//out.println(rs.getString("REASONDESC")+"</font>");
				out.println(((rs.getString("REASONDESC")==null || rs.getString("REASONDESC").equals(""))?"&nbsp;":rs.getString("REASONDESC"))+"</font>");
			}
			else
			{
				out.println(remark+"</font>");
			}
		}
		out.println("<INPUT TYPE='hidden' NAME='REASON"+k+"' value='"+rs.getString("REASONDESC")+"'>"); // 隱藏被指派工廠物件,以便由 java _script判斷是否使用者未指派即送出網頁
		*/
		out.println("<INPUT TYPE='text' NAME='REASON_"+rs.getString("LINE_NO")+"' value='"+(request.getParameter("REASON_"+rs.getString("LINE_NO"))!=null?request.getParameter("REASON_"+rs.getString("LINE_NO")):"")+"' size='15'  style='font-size:11px;font-family: Tahoma,Georgia' "+(checkflag?"":"")+">"); // 隱藏被指派工廠物件,以便由 java _script判斷是否使用者未指派即送出網頁
		out.println("</TD>");
		out.println("<td align='center'>");//add by Peggy 20130419
		/*
		out.println("<font color='#FF0000'>");
		if (lineNo.equals(rs.getString("LINE_NO")) || lineNo==rs.getString("LINE_NO"))
		{
			out.println(((!tsReasonNo.equals("08") || allotQty==null || allotQty.equals("0"))?"&nbsp;":allotQty));
		}
		else
		{
			out.println(((rs.getString("SLOW_MOVING_ALLOT_QTY")==null || rs.getString("SLOW_MOVING_ALLOT_QTY").equals("0"))?"&nbsp;":(new DecimalFormat("######.###")).format(rs.getFloat("SLOW_MOVING_ALLOT_QTY"))));
		}
		out.println("</font>");
		*/
		out.println("<input name='ALLOTQTY_"+rs.getString("LINE_NO")+"' type='text' value='"+(request.getParameter("ALLOTQTY_"+rs.getString("LINE_NO"))!=null?request.getParameter("ALLOTQTY_"+rs.getString("LINE_NO")):"")+"' size='10' onBlur='checkqty("+'"'+rs.getString("LINE_NO")+'"'+")' onkeypress='numCheckInt();' style='font-size:11px;font-family: Tahoma,Georgia' "+(request.getParameter("REASON_"+rs.getString("LINE_NO"))!=null && request.getParameter("REASON_"+rs.getString("LINE_NO")).equals("08")?"":" disabled")+">");
		out.println("</td>");
		//add by Peggy 20141013
		if (rs.getString("SMC_QTY").equals("0"))
		{
			out.println("<TD>--</TD>");
		}
		else
		{
			out.println("<TD><font color='red'>"+rs.getString("SMC_REMARKS")+"</font></TD>");
		}

		//add by Peggy 20140328
		//if (vendor_flag.equals("Y"))
		//{
		//	out.println("<td align='center'><font color='#FF0000'>");
		//	vendor_site_code =request.getParameter("VENDOR_CODE_"+rs.getString("LINE_NO"));
		//	if (vendor_site_code == null) vendor_site_code =rs.getString("vendor_site_code");
		//	if (vendor_site_code == null) vendor_site_code ="";
		//	vendor_site_id =request.getParameter("VENDOR_SITE_ID_"+rs.getString("LINE_NO"));
		//	if (vendor_site_id == null) vendor_site_id=rs.getString("vendor_site_id");
		//	if (vendor_site_id == null) vendor_site_id="";
		//	out.println("<input type='text' name='VENDOR_CODE_"+rs.getString("LINE_NO")+"' value='"+vendor_site_code+"' size='8' readonly><input type='hidden' name='VENDOR_SITE_ID_"+rs.getString("LINE_NO")+"' value='"+vendor_site_id+"'><input type='button' name='btn_"+rs.getString("LINE_NO")+"' value='..' onClick='setVendorInfo("+'"'+rs.getString("inventory_item_id")+'"'+","+'"'+rs.getString("line_no")+'"'+","+'"'+dnDocNo+'"'+")'>");
		//	out.println("</font></td>");
		//	out.println("<td align='center'><font color='#FF0000'><input type='text' name='VENDOR_SSD_"+rs.getString("LINE_NO")+"' value='"+(request.getParameter("VENDOR_SSD_"+rs.getString("LINE_NO"))==null?"":request.getParameter("VENDOR_SSD_"+rs.getString("LINE_NO")))+"' size='7' onKeyPress='return (event.keyCode >= 48 && event.keyCode <=57)'><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.VENDOR_SSD_"+rs.getString("LINE_NO")+");return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></font></td>");
		//}
		if (vendor_flag.equals("Y") || vendor_flag.equals("2"))
		{
			out.println("<td align='center'>");
			if (rs.getString("forecastitem_flag").equals("Y"))  //add by Peggy 20140804
			{
				out.println("<a href='javaScript:setStockInfo("+'"'+dnDocNo+'"'+","+'"'+rs.getString("LINE_NO")+'"'+","+'"'+rs.getString("inventory_item_id")+'"'+","+'"'+rs.getString("QUANTITY")+'"'+","+'"'+rs.getString("REQUEST_DATE").substring(0,8)+'"'+","+'"'+rs.getString("order_num")+'"'+")'><image id='imgstock_"+rs.getString("LINE_NO")+"'  src='../image/light_yellow.gif' style='border:none' "+(checkflag?" style='visibility:visible'":" style='visibility:visible'")+"></a>");
			}
			else
			{
				out.println("--");
			}
			out.println("</td>");
		}

		// 重新指派使用者自行輸入說明
		out.println("<TD width='1%'><font color='#000000'><a name="+rs.getString("LINE_NO")+">");
		//out.println(rs.getString("LINE_NO")+"</a></font></TD>");
		out.println(rs.getString("LINE_NO")+"</a></font><input type='hidden' name='SHIP_FREQUENCY_"+rs.getString("LINE_NO")+"' value='"+rs.getString("SHIP_FREQUENCY")+"'></TD>"); //modify by Peggy 20160913
		out.println("<TD><font color='#000000'>");
		out.println("<a href='javaScript:TSCInvItemQtyDetail("+'"'+rs.getString("INVENTORY_ITEM_ID")+'"'+","+'"'+rs.getString("ASSIGN_MANUFACT")+'"'+")'>");
        out.println(rs.getString("ITEM_DESCRIPTION")+"</a></font></TD>");
		out.println("<TD><font color='#000000'>"+(rs.getString("end_customer")==null?"":rs.getString("end_customer"))+"</a></font></TD>");  //add by Peggy 20240221
		out.println("<TD><font color='#000000'>"+rs.getString("tsc_package")+"</a></font></TD>");  //add by Peggy 20181221
		out.println("<TD><font color='#000000'>"+custItem+"</font></TD>");
		out.println("<TD><font color='#000000'>"+(new DecimalFormat("######.###")).format(rs.getFloat("QUANTITY"))+"<input type='hidden' name='QTY_"+rs.getString("LINE_NO")+"' value='"+rs.getString("QUANTITY")+"'><input type='hidden' name='SUPPLY_SOURCE_"+rs.getString("LINE_NO")+"' value=''></font></TD>");
		out.println("<TD><font color='#000000'>"+rs.getString("UOM")+"</font></TD>");
		out.println("<TD><font color='#000000'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font><input type='hidden' name='REQUESTDATE_"+rs.getString("line_no")+"' value='"+rs.getString("REQUEST_DATE").substring(0,8)+"'></TD>");
		out.println("<TD><font color='#000000'>"+((rs.getString("REMARK")==null || rs.getString("REMARK").equals(""))?"&nbsp;":rs.getString("REMARK"))+"</font></TD>");
		out.println("</TR>");
		//b[k][0]=rs.getString("LINE_NO");
		//b[k][1]=rs.getString("ITEM_SEGMENT1");
		//b[k][2]=rs.getString("QUANTITY");
		//b[k][3]=rs.getString("UOM");
		//b[k][4]=rs.getString("REQUEST_DATE");
		//b[k][5]=rs.getString("REMARK");
		//b[k][6]=rs.getString("FTACPDATE");
		//b[k][7]=rs.getString("ASSIGN_MANUFACT");
        //b[k][8]=rs.getString("PC_COMMENT");		 
		//array2DEstimateFactoryBean.setArray2DString(b);
		//k++;
	}    // End of While	   	   	 
	out.println("</TABLE>");
	statement.close();
    rs.close();  	         

} //end of try
catch (Exception e)
{
	out.println("Exception1:"+e.getMessage());
}

String a[][]=array2DEstimateFactoryBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
if (a!=null) 
{		  
}	//enf of a!=null if		
%>
		</tr>
		<tr bgcolor='#D5D8A7'>
			<td colspan="3"><font color='#000000'><jsp:getProperty name="rPH" property="pgProcessMark"/>:
				<INPUT TYPE="TEXT" NAME="PROC_REMARK" SIZE=60 maxlength="60" value="<%=processRemark%>"></font>
			</td>
		</tr>
		<tr bgcolor='#D5D8A7'>
			<td>
				<font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessUser"/>:</font><font color="#0080C0"><%=userID+"("+UserName+")"%></font>
			</td>
			<td>
				<font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessDate"/>:<%=dateBean.getYearMonthDay()%></font>
			</td>
			<td>
				<font color="#0080C0"><jsp:getProperty name="rPH" property="pgProcessTime"/>:<%=dateBean.getHourMinuteSecond()%></font>
			</td>
		</tr>
	</table>
	<table align="left"><tr><td colspan="3">
		<strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</font></strong>
		<a name='#ACTION'>
			<%
				try
				{
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' order by x2.ACTIONNAME ");
					//out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQEstimatingPage.jsp?DNDOCNO="+dnDocNo+'"'+")'>");
					out.println("<select NAME='ACTIONID'>");
					out.println("<OPTION VALUE=-->--");
					while (rs.next())
					{
						String s1=(String)rs.getString(1);
						String s2=(String)rs.getString(2);
						if (s1.equals(actionID))
						{
							out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
						}
						else
						{
							out.println("<OPTION VALUE='"+s1+"'>"+s2);
						}
					} //end of while
					out.println("</select>");

					rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
					rs.next();
					if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
					{
						out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
						if (actionID.equals("006") || actionID.equals("007")) // 產地移轉或要求企劃重新指派,則E-Mail 功能 enable
						{
							out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
					}
				}
				rs.close();
				statement.close();
			} //end of try
			catch (Exception e)
			{
				out.println("Exception2:"+e.getMessage());
			}
		%>
		</a></td></tr></table>
	<!-- 表單參數 -->
	<input name="SDATE" type="hidden" value="<%=factoryDate%>">
	<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >
	<input name="VENDOR_FLAG" type="hidden" value="<%=vendor_flag%>">
	<input name="SYSDATE" type="hidden" value="<%=dateBean.getYearMonthDay()%>">
	<input name="salesarea" type="hidden" value="<%=tsAreaNo%>">
	<input name="CHKLINE" type="hidden" value="<%=lineNo%>">
	<input name="FIRTIME" type="hidden" value="<%=FIRTIME%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
