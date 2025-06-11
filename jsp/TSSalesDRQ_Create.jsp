<!-- 20101222 LILING 卡CRD 要大於開單日7日 -->
<!-- 20141211 by Peggy,EDI客戶的RFQ也須要求輸入CUSTOMER PO LINE NUMBER-->
<!-- 20150416 by Peggy,java script function:subWindowOrderTypeFind加customerid參數-->
<!-- 20150515 by Peggy,add column "tsch orderl line id" for tsch case-->
<!-- 20150625 by Peggy,qp_secu_list_headers_v change to qp_list_headers_v -->
<!-- 20150908 by Peggy,sample區yew交期只要大於系統日即可-->
<!-- 20151008 by Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!-- 20151026 by Peggy,get_ssd  arrow ssd+運輸天數>=crd -->
<!-- 20160219 by Peggy,上海內銷012 end customer設為必填-->
<!-- 20160308 by Peggy,for sample order add direct_ship_to_cust column-->
<!-- 20160318 by Peggy,客戶單價有定義時,自動帶入-->
<!-- 20160512 by Peggy,tscj,tsca rfq type預設normal-->
<!-- 20161228 by Peggy,ITEM STATUS=NRND FOR SAMPLE ALERT-->
<!-- 20170216 by Peggy,add sales region for bi-->
<!-- 20170425 by Peggy,market group=AU & product package=SMA,當型號有assign到YEW,必須判002,否則依預設工廠別顯示(與CELINE討論)-->
<!-- 20170511 by Peggy,add end cust ship to id-->
<!-- 20171221 Peggy,TSCH-HK RFQ region code from 002 change to 018-->
<!-- 20180518 Peggy,TSCC內銷012,022,外銷002客戶8103 RFQ必須輸入END CUSTOMER-->
<!-- 20180720 Peggy,for TSCA CUSTOMER DIGIKEY ISSUE-->
<!-- 20190225 Peggy,add End customer part name-->
<%@ page language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<html>
<head>
	<title>Sales Delivery Request Questionnaire Input Form</title>
	<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
	<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
	<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
	<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
	<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
	<jsp:useBean id="dateBeanss" scope="page" class="DateBean"/>
	<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
	<!--=================================-->
	<STYLE TYPE='text/css'>
		BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
		P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
		TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
		TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}
		A         { text-decoration: underline }
		A:link    { color: #003399; text-decoration: underline }
		A:visited { color: #990066; text-decoration: underline }
		A:active  { color: #FF0000; text-decoration: underline }
		A:hover   { color: #FF0000; text-decoration: underline }
		.hotnews  {
			border-style: solid;
			border-width: 1px;
			border-color: #b0b0b0;
			padding-top: 2px;
			padding-bottom: 2px;
		}

		.head0    { background-color: #999999 }

		.head     { background-image: url(images_zh_TW/blue.gif) }
		.neck     { background-color: #CCCCCC }
		.odd      { background-color: #e3e3e3 }
		.even     { background-color: #f7f7f7}
		.board    { background-color: #D6DBE7}

		.nav         { text-decoration: underline; color:#000000 }
		.nav:link    { text-decoration: underline; color:#000000 }
		.nav:visited { text-decoration: underline; color:#000000 }
		.nav:active  { text-decoration: underline; color:#FF0000 }
		.nav:hover   { text-decoration: none; color:#FF0000 }
		.topic         { text-decoration: none }
		.topic:link    { text-decoration: none; color:#000000 }
		.topic:visited { text-decoration: none; color:#000080 }
		.topic:active  { text-decoration: none; color:#FF0000 }
		.topic:hover   { text-decoration: underline; color:#FF0000 }
		.ilink         { text-decoration: underline; color:#0000FF }
		.ilink:link    { text-decoration: underline; color:#0000FF }
		.ilink:visited { text-decoration: underline; color:#004080 }
		.ilink:active  { text-decoration: underline; color:#FF0000 }
		.ilink:hover   { text-decoration: underline; color:#FF0000 }
		.mod         { text-decoration: none; color:#000000 }
		.mod:link    { text-decoration: none; color:#000000 }
		.mod:visited { text-decoration: none; color:#000080 }
		.mod:active  { text-decoration: none; color:#FF0000 }
		.mod:hover   { text-decoration: underline; color:#FF0000 }
		.thd         { text-decoration: none; color:#808080 }
		.thd:link    { text-decoration: underline; color:#808080 }
		.thd:visited { text-decoration: underline; color:#808080 }
		.thd:active  { text-decoration: underline; color:#FF0000 }
		.thd:hover   { text-decoration: underline; color:#FF0000 }
		.curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
		.page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
		.page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
		.page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
		.page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
		.page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
		.subject  { font-family: Tahoma,Georgia; font-size: 12px }
		.text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
		.codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
		.smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:12px }
		.verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
		.member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
		.btnStyle  { background-color: #5D7790; border-width:2;
			border-color: #E9E9E9; color: #FFFFFF; cursor: hand;
			font-family: Tahoma,Georgia; font-size: 12px }
		.selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid;
			border-left: black 1px solid; border-right: black 1px solid;
			border-top: black 1px solid; color: #000000; cursor: hand;
			font-family: Tahoma,Georgia; font-size: 12px }
		.inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid;
			border-left: black 1px solid; border-right: black 1px solid;
			border-top: black 1px solid; color: #000000;
			font-family: Tahoma,Georgia; font-size: 12px }
		.titleStyle
		{
			COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
			padding: 2px;   margin: 1px; text-align: center;}
		.gogo{
			border:0;
			color:#FF0000; text-decoration: underline ;font-family: Tahoma,Georgia; font-size: 11px}
		.style1 { font-family: Tahoma,Georgia; font-size: 12px }
		.style2 { font-family: Tahoma,Georgia; font-size: 10px }
	</STYLE>
	<script language="JavaScript" type="text/JavaScript">
		var checkflag = "false";
		document.onclick=function(e)
		{
			var t=!e?self.event.srcElement.name:e.target.name;
			if (t!="popcal")
				gfPop.fHideCal();

		}
		// 限制使用者直接按 F5 重新整理,導致 arrayBean 取值異常的問題

		//FOR EDGE/CHROME Brower issue by Peggy20220401
		/*function document.onkeydown()
	{
    	if (event.keyCode==116)
    	{
        	event.keyCode = 0;
        	event.cancelBubble = true;
        	return false;
    	}
	}
	*/
		//
		function check(field)
		{
			if (checkflag == "false")
			{
				for (i = 0; i < field.length; i++)
				{
					field[i].checked = true;
				}
				checkflag = "true";
				return "取消選取";
			}
			else
			{
				for (i = 0; i < field.length; i++)
				{
					field[i].checked = false;
				}
				checkflag = "false";
				return "全部選取";
			}
		}

		function submitCheck(field)
		{
			// 確認送出前先提示使用者是否存為草稿
			if (document.MYFORM.ACTIONID.value=="002")  //表示為確認送出產生訂單動作
			{
				flag=confirm(ms1);
				if (flag==false)
				{
					return(false);
				}
				else
				{   // 若確認送出再檢查
					return (true);
				}


				//檢查是否選取的資料有填入相對應的DATA
				if (field.length==null)
				{
					if (field.checked==true)
					{
						if (document.MYFORM.elements["DUEDATE-"+field.value].value=="" || document.MYFORM.elements["DUEDATE-"+field.value].value==null || document.MYFORM.elements["QTY-"+field.value].value=="" || document.MYFORM.elements["QTY-"+field.value].value==null)
						{
							alert("Before you submit, please do not let the data that you choosed be Null !!");
							return(false);
						}

						txt1=document.MYFORM.elements["QTY-"+field.value].value;
						txt2=document.MYFORM.elements["DUEDATE-"+field.value].value;
						for (j=0;j<txt1.length;j++)
						{
							c=txt1.charAt(j);
							if ("0123456789.".indexOf(c,0)<0)
							{
								alert("The data that you inputed should be numerical!!");
								return(false);
							}
						}

						for (j=0;j<txt2.length;j++)
						{
							c=txt2.charAt(j);
							if ("0123456789.".indexOf(c,0)<0)
							{
								alert("The data that you inputed should be numerical!!");
								return(false);
							}
						}
					}
				}
				else
				{
					for (i = 0; i < field.length; i++)
					{
						if (field[i].checked == true)
						{
							if (document.MYFORM.elements["DUEDATE-"+field[i].value].value=="" || document.MYFORM.elements["DUEDATE-"+field[i].value].value==null || document.MYFORM.elements["QTY-"+field[i].value].value=="" || document.MYFORM.elements["QTY-"+field[i].value].value==null)
							{
								alert("Before you submit, please do not let the data that you choosed be Null !!");
								return(false);
							}

							txt1=document.MYFORM.elements["QTY-"+field[i].value].value;
							txt2=document.MYFORM.elements["DUEDATE-"+field[i].value].value;
							for (j=0;j<txt1.length;j++)
							{
								c=txt1.charAt(j);
								if ("0123456789.".indexOf(c,0)<0)
								{
									alert("The data that you inputed should be numerical!!");
									return(false);
								}
							}

							for (j=0;j<txt2.length;j++)
							{
								c=txt2.charAt(j);
								if ("0123456789.".indexOf(c,0)<0)
								{
									alert("The data that you inputed should be numerical!!");
									return(false);
								}
							}
						} //end of if =>if (field[i].checked == true)
					} //END OF 檢查是否選取的資料有填入相對應的DATA
				}	//end of if=>field.length==null

				var pass = "NO";
				if (field.length==null)
				{
					if (field.checked==true) pass="YES";
				}
				else
				{
					for (i = 0; i < field.length; i++)
					{
						if (field[i].checked == true)
						{
							pass="YES";
							break;
						}
					}
				}

				if (pass == "NO")
				{
					alert("You can not submit while you are not choosing any one!!");
					return false;
				}

			}  // End of if 最外層 if (document.MYFORM.ACTIONID.value=="002")
			document.MYFORM.submit();
		}

		function check(field)
		{
			if (checkflag == "false")
			{
				for (i = 0; i < field.length; i++)
				{
					field[i].checked = true;}
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

		function NeedConfirm()
		{
			flag=confirm("是否確定刪除?");
			return flag;
		}

		function setSubmit(URL)
		{
			var myDate = document.MYFORM.maxDate.value;
			var myDate1 = document.MYFORM.maxDate1.value;
			if (document.MYFORM.PLANTCODE.value=="002" && document.MYFORM.SALESAREANO.value=="020")
			{
				if (document.MYFORM.REQUESTDATE.value <= myDate1 && document.MYFORM.REQUESTDATE.value!= "")
				{
					alert("The Request Date must greater than leadtime "+myDate1);
					document.MYFORM.REQUESTDATE.focus();
					return (false);
				}
			}
			else
			{
				if (document.MYFORM.REQUESTDATE.value <= myDate && document.MYFORM.REQUESTDATE.value!= "")
				{
					alert("The Request Date must greater than leadtime "+myDate);
					document.MYFORM.REQUESTDATE.focus();
					return (false);
				}
			}
			// 呼叫另一個java script 檢查是否符合SPQ/MOQ Rule 2006/05/30
			if ( (document.MYFORM.SPQP.value==null || document.MYFORM.SPQP.value=="") && (document.MYFORM.MOQP.value==null || document.MYFORM.MOQP.value=="") ) //若未取到MOQ/SPQ 表示使用者直接點擊Add按鈕,則再取一次
			{
				subWindowItemFind(window.document.MYFORM.INVITEM.value,window.document.MYFORM.ITEMDESC.value,eval(window.document.MYFORM.SAMPLEORDER.checked),window.document.MYFORM.CUSTOMERID.value,window.document.MYFORM.SALESAREANO.value,document.MYFORM.FIRMPRICELIST.value);
				setSPQCheck(window.document.MYFORM.ORDERQTY.value,window.document.MYFORM.SPQP.value,window.document.MYFORM.MOQP.value);

			} // End of if
			else
			{
				// 呼叫另一個java script 檢查是否符合SPQ/MOQ Rule 2006/05/30
				warray=new Array(document.MYFORM.INVITEM.value,document.MYFORM.ITEMDESC.value,document.MYFORM.ORDERQTY.value,document.MYFORM.REQUESTDATE.value,document.MYFORM.SPQP.value,document.MYFORM.CUSTOMERID.value,document.MYFORM.CUSTACTIVE.value,document.MYFORM.MOQP.value);
				for (i=0;i<8;i++)
				{
					if (i<=1)
					{
						if ((warray[0]=="" || warray[0]==null || warray[0]=="--") && (warray[1]=="" || warray[1]==null || warray[1]=="--"))
						{
							alert("TSC Item or Item Description must be input, please do not let the data field be Null !!");
							document.MYFORM.ITEMDESC.focus();
							return(false);
						}
					}
					else if (i==2)
					{
						if (warray[i]=="" || warray[i]==null || warray[i]=="0")
						{
							alert("Please Input Order Quantity!!");
							document.MYFORM.ORDERQTY.focus();
							return(false);
						}
					} // End of else if (warray[i]=="")
					else if (i==3)
					{
						if (warray[i]=="" || warray[i]==null)
						{
							alert("Please Input Request Date!!");
							document.MYFORM.REQUESTDATE.focus();
							return(false);
						}
					} // End of else if (warray[i]=="")
					else if (i==5)
					{
						if (warray[i]=="" || warray[i]==null)
						{
							alert("Please Choose Customer Name!!");
							document.MYFORM.CUSTOMERNAME.focus();
							return(false);
						}
					} // End of else if (warray[i]=="")
					else if (i==6)
					{    //alert(warray[6]);
						if (warray[6]!="A")
						{
							alert(" Warning !!\n The Customer what you choose should be set ACTIVE in Oracle.");
						}
					}
				} //end of for  null check

				if (warray[4]!=null) // 若系統取得該次料項最小包裝量,則計算是否輸入訂購數量為最小包裝量之倍數
				{
					if (warray[4]==0) //若系統取得0, 表示尚未設定該料號最小包裝量, 不得詢問
					{
						//alert("The Item SPQP not be defaule, Please contact with Item Administroatr!!"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
						//document.MYFORM.ITEMDESC.focus();
						//return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
					}
					else
					{
						var sourcespq=warray[4]; // SPQ
						var base=warray[7] * 1000; // MOQ
						var oQTY=warray[2] * 1000; // OrderQty
						oQTY = oQTY.toFixed(4);  //add by Peggy 20120206,解決精確度問題
						var spqQty=sourcespq * 1000; // SPQ
						if (base==0 && spqQty==0) //若系統取得0, 表示尚未設定該料號最小包裝量(MOQ及SPQ), 不得詢問
						{
							//alert("The Item MOQ/SPQ not be default, Please contact with Item Administroatr!!"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
							//document.MYFORM.REQUESTDATE.focus();
							//return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
						}
						else
						{ // 開始判斷取 MOQ /SPQ 規則2006/06/05_起
							if (base >0 && spqQty>0) // 若兩者皆大於零
							{
								var baseSPQ=spqQty;
								var baseMOQ=base;

								if (oQTY<baseMOQ) // 若輸入數量小於 MOQ 則警告
								{
									if (window.document.MYFORM.SAMPLEORDER.checked == false)
									{
										alert("The Order Q'ty which you input less than MOQ setting !!!\n                  MOQP= "+warray[7]+" KPC");
										document.MYFORM.ORDERQTY.focus();
										return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
									}
									else
									{ //若是選擇樣品訂單,則直接以SPQ計算
										var n = oQTY % baseSPQ;
										if (n != 0)
										{
											alert("The Order Q'ty which you input not acceptable by Sample Order Q'ty rule !!!\n                          				SPQP= "+sourcespq+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
											document.MYFORM.ORDERQTY.focus();
											return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
										} // End of if
									} // End of else
								}
								else
								{ // 輸入的訂單數量,大於等於MOQ, 且選擇一般訂單,則以SPQ的倍數允許輸入
									if (window.document.MYFORM.SAMPLEORDER.checked == false)
									{
										var n = oQTY % baseSPQ;
										if (n != 0)
										{
											alert("The Order Q'ty which you input not acceptable by MOQ / Plus SPQP rule !!!\n                          SPQP= "+sourcespq+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
											document.MYFORM.ORDERQTY.focus();
											return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
										} // End of if
									}
									else
									{
										//var n = oQTY % baseMOQ;
										var n = oQTY % baseSPQ; //modify by Peggy 20120516
										//alert("n="+n);
										if (n != 0)
										{
											alert("The Order Q'ty which you input not acceptable by SPQP rule !!!\n                          SPQP= "+sourcespq+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
											document.MYFORM.ORDERQTY.focus();
											return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
										} // End of if
									}
								} // end of else
							} // enf of if
						} // end else
					} // end if
				}
				// 檢查Order Qty 欄位是否為數值
				for (i=2;i<3;i++)
				{
					txt=warray[i];
					for (j=0;j<txt.length;j++)
					{
						c=txt.charAt(j);
					}
					if ("0123456789.".indexOf(c,0)<0)
					{
						alert("The Quantity data that you inputed should be numerical!!");
						return(false);
					}
				} //end of for  null check

				// 檢查日期是否符合日期格式
				var datetime;
				var year,month,day;
				var gone,gtwo;
				if(warray[3]!="")
				{
					datetime=warray[3];
					if(datetime.length==8)
					{
						year=datetime.substring(0,4);
						if(isNaN(year)==true)
						{
							alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
							document.MYFORM.REQUESTDATE.focus();
							return(false);
						}
						gone=datetime.substring(4,5);
						month=datetime.substring(4,6);
						if(isNaN(month)==true)
						{
							alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
							document.MYFORM.REQUESTDATE.focus();
							return(false);
						}
						gtwo=datetime.substring(7,8);
						day=datetime.substring(6,8);
						if(isNaN(day)==true)
						{
							alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
							document.MYFORM.REQUESTDATE.focus();
							return(false);
						}
						if(month<1||month>12)
						{
							alert("Month must between 01 and 12 !!");
							document.MYFORM.REQUESTDATE.focus();
							return(false);
						}
						if(day<1||day>31)
						{
							alert("Day must between 01 and 31!!");
							document.MYFORM.REQUESTDATE.focus();
							return(false);
						}
						else
						{
							if(month==2)
							{
								if(isLeapYear(year)&&day>29)
								{
									alert("February between 01 and 29 !!");
									document.MYFORM.REQUESTDATE.focus();
									return(false);
								}
								if(!isLeapYear(year)&&day>28)
								{
									alert("February between 01 and 29 !!");
									document.MYFORM.REQUESTDATE.focus();
									return(false);
								}
							} // End of if(month==2)
							if((month==4||month==6||month==9||month==11)&&(day>30))
							{
								alert("Apr., Jun., Sep. and Nov. \n Must between 01 and 30 !!");
								document.MYFORM.REQUESTDATE.focus();
								return(false);
							}
						} // End of else
						today = new Date();
						xday = new Date(year,month,day);
						dayMS = 24*60*60*1000;
						n = Math.floor((xday.getTime()-today.getTime())/dayMS)+1;
						if (n < 0)
						{
							alert("<jsp:getProperty name='rPH' property='pgRFQRequestDateMsg'/>");
							document.MYFORM.REQUESTDATE.focus();
							return(false);
						}
					}
					else
					{ // End Else of if(datetime.length==10)
						alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
						document.MYFORM.REQUESTDATE.focus();
						return(false);
					}
				}
				// 檢查日期是否符合日期格式
			} //end of if ()

			// 2006/12/28 檢查是否輸入客戶訂購單號_起
			if (document.MYFORM.CUSTOMERPO.value==null || document.MYFORM.CUSTOMERPO.value=="")
			{
				alert("Please Input Customer PO !!! ");
				document.MYFORM.CUSTOMERPO.focus();
				return (false);
			}
			// 2006/12/28 檢查是否輸入客戶訂購單號_迄

			// 2009/03/02 檢查是否輸訂單類型_起
			if (document.MYFORM.PREORDERTYPE.value=="--" || document.MYFORM.PREORDERTYPE.value=="" || document.MYFORM.PREORDERTYPE.value==null)
			{
				alert("Please Select Order Type !!! ");
				document.MYFORM.PREORDERTYPE.focus();
				return (false);
			}
			// 2009/03/02 檢查是否輸訂單類型_迄

			// 2009/03/02 檢查是否有預設料號判別地
			if (document.MYFORM.PLANTCODE.value==null || document.MYFORM.PLANTCODE.value=="" || document.MYFORM.PLANTCODE.value=="null")
			{
				alert("This Item has no Plant Code!!! \n please contact DCC or MIS. ");
				document.MYFORM.ITEMDESC.focus();
				return (false);
			}
			// 2009/03/02 檢查是否有預設料號判別地_迄

			if (document.MYFORM.showCRD.value =="Y")
			{
				if (document.MYFORM.CRD.value==null || document.MYFORM.CRD.value =="" || document.MYFORM.CRD.value.length != 8)
				{
					alert("please input a value on CRD field!");
					document.MYFORM.CRD.focus();
					return (false);
				}
				else if (eval(document.MYFORM.CRD.value)<eval(document.MYFORM.RECEPTDATE.value)) //add by Peggy 20210308
				{
					alert("CRD must be greater than or equals the today!");
					document.MYFORM.CRD.focus();
					return (false);
				}
			}
			//modify by Peggy 20120209
			if (document.MYFORM.showCRD.value =="Y" || document.MYFORM.showCRD.value =="S")
			{
				if (document.MYFORM.SHIPPINGMETHOD.value == null || document.MYFORM.SHIPPINGMETHOD.value =="")
				{
					alert("please input a value on shippingmethod field!");
					document.MYFORM.SHIPPINGMETHOD.focus();
					return (false);
				}
			}

			//add by Peggy 20111011,歐洲區+SMA ITEM或AU類別客戶皆不接受外購品
			if (document.MYFORM.PLANTCODE.value=="008")
			{
				//if ( document.MYFORM.CUSTOMERNO.value !="1521" && document.MYFORM.CUSTMARKETGROUP.value=="AU")
				//{
				//	alert("The AU market group customer does not accept a outsource goods!");
				//	document.MYFORM.btplant.disabled=false;
				//	return false;
				//}
				if ( document.MYFORM.SALESAREANO.value=="001" && document.MYFORM.CUSTMARKETGROUP.value=="AU" && document.MYFORM.TSCPACKAGE.value=="SMA" && document.MYFORM.YEWFLAG.value=="1")
				{
					alert("The SMA item does not accept a outsource goods!");
					document.MYFORM.btplant.disabled=false;
					return false;
				}
			}

			//add by Peggy 20120303
			var RFQ_TYPE = "";
			var radioLength = document.MYFORM.rfqtype.length;
			for(var i = 0; i < radioLength; i++)
			{
				if ( document.MYFORM.rfqtype[i].checked)
				{
					RFQ_TYPE = document.MYFORM.rfqtype[i].value;
				}
			}

			//add by Peggy 20120305
			if (document.MYFORM.LINEODRTYPE.value==null || document.MYFORM.LINEODRTYPE.value=="" || document.MYFORM.LINEODRTYPE.value=="null")
			{
				alert("The ORDER TYPE is not empty!");
				document.MYFORM.LINEODRTYPE.focus();
				return (false);
			}
			//add by Peggy 20120427
			else if (( document.MYFORM.CURR.value =="NTD" || document.MYFORM.CURR.value =="TWD") && document.MYFORM.LINEODRTYPE.value != "1131")
			{
				alert("The Order Type is not available!");
				document.MYFORM.LINEODRTYPE.focus();
				return (false);
			}
			//else if (document.MYFORM.LINEODRTYPE.value == "1132" && document.MYFORM.SALES_GROUP_ID.value !="509")  //add by Peggy 20210528
			//{
			//	alert("This customer is not allowed to book 1132 order type!!");
			//	document.MYFORM.LINEODRTYPE.focus();
			//	return (false);
			//}
			//else if (document.MYFORM.LINEODRTYPE.value != "1132" && document.MYFORM.SALES_GROUP_ID.value =="509")  //add by Peggy 20210528
			//{
			//	alert("This customer must book 1132 order type!!");
			//	document.MYFORM.LINEODRTYPE.focus();
			//	return (false);
			//}

			//add by Peggy 20120305
			if (document.MYFORM.LINETYPE.value==null || document.MYFORM.LINETYPE.value=="" || document.MYFORM.LINETYPE.value=="null")
			{
				alert("The LINE TYPE is not empty!");
				document.MYFORM.LINETYPE.focus();
				return (false);
			}

			//add by Peggy 20120329
			if ((document.MYFORM.FOBPOINT.value==null || document.MYFORM.FOBPOINT.value=="") && (document.MYFORM.LINEFOB.value==null || document.MYFORM.LINEFOB.value==""))
			{
				alert("Please Input FOB !!! ");
				document.MYFORM.FOB.focus();
				return (false);
			}

			//add by Peggy 20120522
			if (document.MYFORM.showCRD.value =="X" || document.MYFORM.showCRD.value=="S")
			{
				var isExit = false;
				var SHIPPINGMETHOD =document.MYFORM.SHIPPINGMETHOD.value;
				for (var j = 0; j < document.MYFORM.SHIPMETHODLIST.options.length; j++)
				{
					if (document.MYFORM.SHIPMETHODLIST.options[j].value == SHIPPINGMETHOD)
					{
						isExit = true;
						break;
					}
				}
				if (!isExit)
				{
					alert("Shipping Method:"+SHIPPINGMETHOD+" is not available!!");
					document.MYFORM.SHIPPINGMETHOD.focus();
					return(false);
				}
			}

			//add by Peggy 20120601
			if (document.MYFORM.ENDCUSTPOLINENO!=undefined)
			{
				if (document.MYFORM.ENDCUSTPOLINENO.value=="" ||document.MYFORM.ENDCUSTPOLINENO.value=="null" || document.MYFORM.ENDCUSTPOLINENO.value==null)
				{
					alert("Please input the cust po line no value!!");
					document.MYFORM.ENDCUSTPOLINENO.focus();
					return(false);
				}
			}

			//add by Peggy 20140424
			if ( document.MYFORM.SALESAREANO.value=="001")
			{
				if (document.MYFORM.LINEFOB.value.toUpperCase().indexOf("FOB")>=0 || document.MYFORM.LINEFOB.value.toUpperCase()=="EX WORKS" || document.MYFORM.LINEFOB.value.toUpperCase()=="EX-WORK" || document.MYFORM.LINEFOB.value.toUpperCase()=="C&F H.K." || document.MYFORM.LINEFOB.value.toUpperCase()=="EXW I-LAN" || document.MYFORM.LINEFOB.value.toUpperCase()=="CIF H.K.")
				{
					if (document.MYFORM.SHIPPINGMETHOD.value.toUpperCase()=="AIR(C)" || document.MYFORM.SHIPPINGMETHOD.value.toUpperCase()=="SEA(C)")
					{
						if (document.MYFORM.LINEODRTYPE.value!="1214" || document.MYFORM.LINEFOB.value.toUpperCase()!="EX WORKS")  //1214 EX WORKS排外 ADD BY PEGGY 20220105
						{
							alert("Shipping Method not match FOB Term!");
							document.MYFORM.SHIPPINGMETHOD.focus();
							return false;
						}
					}
					//add by Peggy 20140529
					if (document.MYFORM.LINEFOB.value.toUpperCase()=="FOB TAIWAN" && (document.MYFORM.LINEODRTYPE.value=="1142" || document.MYFORM.LINEODRTYPE.value=="1156"))
					{
						alert("Order Type not match FOB Term!");
						return false;
					}
				}
			}

			//add by Peggy 20160219,012業務區內銷訂單 end customer必填
			//if ( document.MYFORM.SALESAREANO.value=="012")
			//if ( document.MYFORM.SALESAREANO.value=="012" || document.MYFORM.SALESAREANO.value=="022" || (document.MYFORM.SALESAREANO.value=="002" && document.MYFORM.CUSTOMERNO.value=="8103")) //modify by Peggy 20180518
			//拿掉022 from sansan by Peggy 20211019
			if ( document.MYFORM.SALESAREANO.value=="012" || (document.MYFORM.SALESAREANO.value=="002" && document.MYFORM.CUSTOMERNO.value=="8103")) //modify by Peggy 20180518
			{
				if (document.MYFORM.ENDCUSTOMER.value == null || document.MYFORM.ENDCUSTOMER.value =="" || document.MYFORM.ENDCUSTOMERID.value ==null || document.MYFORM.ENDCUSTOMERID.value=="")
				{
					alert("Please input a end customer!!");
					document.MYFORM.ENDCUSTOMER.focus();
					return false;
				}
			}
			//add by Peggy 20140812
			if (document.MYFORM.ENDCUSTOMER.value != null && document.MYFORM.ENDCUSTOMER.value !="")
			{
				if ( document.MYFORM.SALESAREANO.value!="009" && document.MYFORM.SALESAREANO.value!="006" && (document.MYFORM.ENDCUSTOMERID.value ==null || document.MYFORM.ENDCUSTOMERID.value==""))  //add 006 by Peggy 20221028
				{
					alert("Please choose erp end customer!!");
					document.MYFORM.ENDCUSTOMER.focus();
					return false;
				}
				if (document.MYFORM.ENDCUSTOMERID.value==document.MYFORM.CUSTOMERID.value)
				{
					alert("End customer can not be the same with rfq customer!!");
					document.MYFORM.ENDCUSTOMER.focus();
					return false;
				}
			}

			if (document.MYFORM.LINEODRTYPE.value=="1121" || document.MYFORM.LINEODRTYPE.value=="4121") //add by Peggy 20161228
			{
				if (document.MYFORM.ITEMSTATUS.value=="NRND")
				{
					if (confirm("Are you sure to order this item(status="+document.MYFORM.ITEMSTATUS.value+")")==false)
					{
						return false;
					}
				}
			}

			//add by Peggy 20170220
			if (document.MYFORM.CUSTOMERID.value=="14980" || document.MYFORM.CUSTOMERID.value=="15540")
			{
				if (document.MYFORM.BI_REGION.value==""||document.MYFORM.BI_REGION.value==null|| document.MYFORM.BI_REGION.value=="--")
				{
					alert("Please choose a BI Region!");
					document.MYFORM.BI_REGION.focus();
					return false;
				}
			}

			//add by Peggy 20190306
			if (document.MYFORM.SALESAREANO.value=="001" && document.MYFORM.ITEMDESC.value.toUpperCase().indexOf("-ON")>=0)
			{
				if (document.MYFORM.EndCustPartNo.value=="" || document.MYFORM.EndCustPartNo.value==null)
				{
					alert("End Cust Part No can not empty!");
					return false;
				}
			}

			document.MYFORM.action=URL+"&RFQTYPE="+RFQ_TYPE;
			//document.MYFORM.action=URL;
			document.MYFORM.submit();
		}

		function setSPQCheck(xORDERQTY,xSPQP,xMOQP)
		{ //alert("xSPQP="+xSPQP);
			//alert("xMOQP="+xMOQP);
			if (event.keyCode==13 || event.keyCode==9 ) // event.keycode = 9 --> Tab 鍵
			{
				if (xSPQP!=null) // 若系統取得該次料項最小包裝量,則計算是否輸入訂購數量為最小包裝量之倍數
				{
					if (xSPQP==0 && xMOQP==0) //若系統取得0, 表示尚未設定該料號最小包裝量(MOQ及SPQ), 不得詢問
					{
						alert("The Item SPQP not be default, Please contact with Item Administrator!!"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
						document.MYFORM.REQUESTDATE.focus();
						return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
					}
					else
					{ // 開始判斷取 MOQ /SPQ 規則2006/06/05_起
						if (xMOQP >0 && xSPQP>0) // 若兩者皆大於零
						{
							var baseSPQ= xSPQP * 1000;
							var baseMOQ=xMOQP * 1000;
							var oQTY=xORDERQTY * 1000;
							if (oQTY<baseMOQ) // 若輸入數量小於 MOQ 則警告
							{
								if (window.document.MYFORM.SAMPLEORDER.checked == false)
								{
									alert("The Order Q'ty which you input less than MOQ setting !!!\n  MOQP= "+xMOQP+" KPC");
									document.MYFORM.ORDERQTY.focus();
									return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
								}
								else
								{ //若是選擇樣品訂單,則直接以SPQ計算
									var n = oQTY % baseSPQ;
									if (n != 0)
									{
										alert("The Order Q'ty which you input not acceptence by Sample Order Q'ty rule !!!\n  SPQP= "+xSPQP+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
										document.MYFORM.ORDERQTY.focus();
										return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
									} // End of if
								} // End of else
							}
							else
							{ // 輸入的訂單數量,大於等於MOQ, 且選擇一般訂單
								if (window.document.MYFORM.SAMPLEORDER.checked == false)
								{
									var n = oQTY % baseSPQ;
									if (n != 0)
									{
										alert("The Order Q'ty which you input not acceptence by MOQ/SPQP rule !!!\n   SPQP= "+xSPQP+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
										document.MYFORM.ORDERQTY.focus();
										return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
									} // End of if
								}
								else
								{
									var n = oQTY % baseSPQ;
									if (n != 0)
									{
										alert("The Order Q'ty which you input not acceptence by SPQP rule !!!\n   SPQP= "+xSPQP+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
										document.MYFORM.ORDERQTY.focus();
										return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
									} // End of if
								}
							} // end of else
						} // enf of if
					} // end else
					document.MYFORM.REQUESTDATE.focus();
				} //end null if
			} //end keydown if
		}

		function setSubmit1(URL)
		{
			var linkURL = "#ACTION";
			var RFQ_TYPE = "";
			var radioLength = document.MYFORM.rfqtype.length;
			for(var i = 0; i < radioLength; i++)
			{
				if ( document.MYFORM.rfqtype[i].checked)
				{
					RFQ_TYPE = document.MYFORM.rfqtype[i].value;
				}
			}
			document.MYFORM.action=URL+"&RFQTYPE="+RFQ_TYPE+linkURL;
			document.MYFORM.submit();
		}

		function setSubmit2(URL,dim1,dim2,ms1)
		{
			//add by Peggy 20130522
			if (document.MYFORM.ACTIONID.value =="--")
			{
				alert("Please choose the action code!!");
				document.MYFORM.ACTIONID.focus();
				return false;
			}

			//add by Peggy 20120316
			if (document.MYFORM.SPQCHECKED.value=="N")
			{
				alert("Please check MOQ!");
				return false;
			}

			//add by Peggy 20120302
			var chkflag = false;
			var RFQ_TYPE = "";
			var radioLength = document.MYFORM.rfqtype.length;
			if(radioLength == undefined)
			{
				return;
			}
			for(var i = 0; i < radioLength; i++)
			{
				if ( document.MYFORM.rfqtype[i].checked)
				{
					RFQ_TYPE = document.MYFORM.rfqtype[i].value;
					chkflag=true;
					break;
				}
			}
			if (chkflag == false)
			{
				alert("Please choose the RFQ type!");
				return false;
			}

			//add by Peggy 20120305
			if (window.document.MYFORM.SHIPTOORG.value == "")
			{
				alert("Shipto ID can not empty!");
				window.document.MYFORM.SHIPTOORG.focus();
				return false;
			}

			//add by Peggy 20120305
			if (window.document.MYFORM.SHIPADDRESS.value == "")
			{
				alert("Shipto Address can not empty!");
				window.document.MYFORM.SHIPADDRESS.focus();
				return false;
			}

			//add by Peggy 20120305
			if (window.document.MYFORM.FOBPOINT.value == "")
			{
				alert("FOB can not empty!");
				window.document.MYFORM.FOBPOINT.focus();
				return false;
			}

			//add by Peggy 20120305
			if (window.document.MYFORM.BILLTO.value == "")
			{
				alert("Billto ID can not empty!");
				window.document.MYFORM.BILLTO.focus();
				return false;
			}

			//add by Peggy 20120305
			if (window.document.MYFORM.BILLADDRESS.value == "")
			{
				alert("Billto Address can not empty!");
				window.document.MYFORM.BILLADDRESS.focus();
				return false;
			}

			//add by Peggy 20120305
			if (window.document.MYFORM.PAYTERM.value == "")
			{
				alert("Payment term can not empty!");
				window.document.MYFORM.PAYTERM.focus();
				return false;
			}

			//add by Peggy 20120326
			if (document.MYFORM.FIRMPRICELIST.value=="--" || document.MYFORM.FIRMPRICELIST.value=="" || document.MYFORM.FIRMPRICELIST.value==null)
			{
				alert("Please choose the price list value!!! ");
				document.MYFORM.FIRMPRICELIST.focus();
				return (false);
			}
			else if (document.MYFORM.SALESAREANO.value=="001" && document.MYFORM.PREORDERTYPE.value!="1342" && document.MYFORM.CUSTOMERNO.value!="13503") //add by Peggy20130909
			{
				if (document.MYFORM.FIRMPRICELIST.value != document.MYFORM.ORIGPRICELIST.value)
				{
					alert("Price List does not meet customer requirement!");
					return false;
				}
			}

			//add by Peggy 20120327
			if (document.MYFORM.CURR.value=="" || document.MYFORM.CURR.value==null || document.MYFORM.CURR.value=="null")
			{
				alert("Please input the currency value!!! ");
				document.MYFORM.CURR.focus();
				return (false);
			}
			else if (document.MYFORM.CURR.value!="EUR" && document.MYFORM.CURR.value !="TWD" && document.MYFORM.CURR.value != "USD" && document.MYFORM.CURR.value != "CNY")
			{
				alert("The currency is not available!!! ");
				document.MYFORM.CURR.focus();
				return (false);
			}
			else if (document.MYFORM.SALESAREANO.value=="001" && document.MYFORM.PREORDERTYPE.value!="1342" && document.MYFORM.CUSTOMERNO.value!="13503") //add by Peggy20130909
			{
				if (document.MYFORM.CURR.value != document.MYFORM.ORIGCURR.value)
				{
					alert("Currency does not meet customer requirement!");
					return false;
				}
			}

			if (window.document.MYFORM.SAMPLEORDER.checked == true)
			{
				if (window.document.MYFORM.SAMPLECHARGE.value=="--" || document.MYFORM.SAMPLECHARGE.value=="")
				{
					alert("Please choose sample order charge Option before you submit this form!!!");
					window.document.MYFORM.SAMPLECHARGE.focus();
					return(false); // 若要卡住選擇樣品訂單卻未選擇收費與否
				}
			}

			if (document.MYFORM.CUSTOMERPO.value==null || document.MYFORM.CUSTOMERPO.value=="")
			{
				alert("Please Input Customer PO before you submit this form!!!");
				window.document.MYFORM.CUSTOMERPO.focus();
				return(false); // 要卡住客戶PO號為必填欄位
			}

			//add by Peggy 20130222
			if (document.MYFORM.SALESAREANO.value=="001")
			{
				if (document.MYFORM.SHIPTOCONTACT.value==null || document.MYFORM.SHIPTOCONTACT.value=="")
				{
					alert("Please choose the ship_to_contact !!! ");
					document.MYFORM.SHIPTOCONTACT.focus();
					return (false);
				}
				if (document.MYFORM.PREORDERTYPE.value != "1342" && (document.MYFORM.TAXCODE.value==null || document.MYFORM.TAXCODE.value==""))
				{
					alert("Please choose the Tax Code !!! ");
					document.MYFORM.TAXCODE.focus();
					return (false);
				}
				if (RFQ_TYPE=="NORMAL" && document.MYFORM.SUPPLIER_FLAG.value=="Y" && (document.MYFORM.SUPPLIER_NUMBER.value=="" || document.MYFORM.SUPPLIER_NUMBER.value==null))
				{
					alert("Please input the supplier number!!! ");
					document.MYFORM.SUPPLIER_NUMBER.focus();
					return (false);
				}

			}

			//檢查FOB,add by Peggy 20130219
			for (i=0;i<dim1;i++)
			{
				if(document.MYFORM.FOBLIST.value.indexOf(";"+document.MYFORM.elements["MONTH"+i+"-18"].value+";")<0)
				{
					alert("Line"+(i+1)+": FOB is invalid!!");
					document.MYFORM.ACTIONID.value = "--";
					return(false);
				}
				//add by Peggy 20140424
				if (document.MYFORM.ACTIONID.value=="002" && document.MYFORM.SALESAREANO.value=="001")
				{
					if (document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase().indexOf("FOB")>=0 || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()=="EX WORKS" || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()=="EX-WORK" || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()=="FCA TAIWAN" || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()=="FCA I-LAN"  || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()=="FCA YANGXIN XIAN" || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()=="C&F H.K." || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()=="EXW I-LAN" || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()=="CIF H.K.")
					{
						if (document.MYFORM.elements["MONTH"+i+"-6"].value.toUpperCase()=="AIR(C)" || document.MYFORM.elements["MONTH"+i+"-6"].value.toUpperCase()=="SEA(C)")
						{
							if (document.MYFORM.elements["MONTH"+i+"-16"].value.toUpperCase()!="1214" || document.MYFORM.elements["MONTH"+i+"-18"].value.toUpperCase()!="EX WORKS")  //1214 EX WORKS排外 ADD BY PEGGY 20220105
							{
								alert("Line"+(i+1)+":Shipping Method not match FOB Term!");
								document.MYFORM.ACTIONID.value = "--";
								return(false);
							}
						}
					}
				}
				//add by Peggy 20170220
				if (document.MYFORM.CUSTOMERID.value=="14980" || document.MYFORM.CUSTOMERID.value=="15540")
				{
					if (document.MYFORM.elements["MONTH"+i+"-27"].value==""||document.MYFORM.elements["MONTH"+i+"-27"].value===null|| document.MYFORM.elements["MONTH"+i+"-27"].value==="--")
					{
						alert("Line"+(i+1)+":BI Region can not be empty!");
						document.MYFORM.ACTIONID.value = "--";
						return false;
					}
				}

			}

			// 確認送出前先提示使用者是否存為草稿
			if (document.MYFORM.ACTIONID.value=="002")  //表示為確認送出產生訂單動作
			{
				flag=confirm(ms1);
				if (flag==false)
				{
					return(false);
				}
				else
				{
				}

				if (dim1<1)  //若沒有任何資料則不能存檔
				{
					alert("No Need to Save because there is no any data being Added!!");
					return(false);
				}

				var myDate = document.MYFORM.maxDate.value; //add by Peggy 20120403
				var myDate1 = document.MYFORM.maxDate1.value; //add by Peggy 20150914
				for (i=0;i<dim1;i++)
				{
					for (j=1;j<dim2;j++) // Line Remark allow null
					{
						if (j!=9)
						{
							//if  ((j!=5 && j!=6) || (( j==5 || j==6 )&& document.MYFORM.showCRD.value =="Y"))
							//modify by Peggy 20120209
							//if  ((j!=5 && j!=6 && j!=14 && j!=15 && j!=19 && j!=20 && j!=21 && j!=22 && j!=23) || (( j==5 || j==6 )&& document.MYFORM.showCRD.value =="Y") || ( j==6 && document.MYFORM.showCRD.value =="S"))
							if  (((j >= 1 && j <=4) || (j >=7 && j <=13) || (j>=16 && j <=18)) || (( j==5 || j==6 )&& document.MYFORM.showCRD.value =="Y") || ( j==6 && document.MYFORM.showCRD.value =="S"))
							{
								if(document.MYFORM.elements["MONTH"+i+"-"+j].value=="" || document.MYFORM.elements["MONTH"+i+"-"+j].value==null)
								{
									alert("Before you want to save , please do not let the any filed of product detail be Null !!");
									document.MYFORM.ACTIONID.value = "--";
									return(false);
								}
							}

							//add by Peggy 20210309
							if (j==5)
							{
								if (document.MYFORM.showCRD.value =="Y")
								{
									if (document.MYFORM.elements["MONTH"+i+"-"+j].value==null || document.MYFORM.elements["MONTH"+i+"-"+j].value =="" || document.MYFORM.elements["MONTH"+i+"-"+j].value.length != 8)
									{
										alert("LineNo"+ (i+1) +":please input a value on CRD field!");
										document.MYFORM.ACTIONID.value = "--";
										return (false);
									}
									else if (eval(document.MYFORM.elements["MONTH"+i+"-"+j].value)<eval(document.MYFORM.RECEPTDATE.value)) //add by Peggy 20210308
									{
										alert("LineNo"+ (i+1) +":CRD must be greater than or equals the today!");
										document.MYFORM.ACTIONID.value = "--";
										return (false);
									}
								}
							}
							else if (j==7)
							{
								//add by Peggy 20150914
								if (document.MYFORM.elements["MONTH"+i+"-13"].value=="002" && document.MYFORM.SALESAREANO.value=="020")
								{
									if  (document.MYFORM.elements["MONTH"+i+"-"+j].value <= myDate1 && document.MYFORM.elements["MONTH"+i+"-"+j].value != "")
									{
										alert("LineNo"+ (i+1) +":The Request Date must greater than leadtime "+myDate1);
										document.MYFORM.ACTIONID.value = "--";
										return (false);
									}
								}
								else
								{
									if (document.MYFORM.elements["MONTH"+i+"-"+j].value <= myDate && document.MYFORM.elements["MONTH"+i+"-"+j].value != "")
									{
										alert("LineNo"+ (i+1) +":The Request Date must greater than leadtime "+myDate);
										document.MYFORM.ACTIONID.value = "--";
										return (false);
									}
								}
							}
							//add by Peggy 20120427
							if (j==16)
							{
								if (document.MYFORM.elements["MONTH"+i+"-"+j].value != "1131" && (document.MYFORM.CURR.value =="TWD" || document.MYFORM.CURR.value =="NTD"))
								{
									alert("Line"+(i+1)+":The Order Type is not available!");
									document.MYFORM.ACTIONID.value = "--";
									return (false);
								}
								//else if (document.MYFORM.elements["MONTH"+i+"-"+j].value == "1132" && document.MYFORM.SALES_GROUP_ID.value != "509") //add by Peggy 20210528
								//{
								//	alert("Line"+(i+1)+":This customer is not allowed to book 1132 order type!!");
								//	document.MYFORM.ACTIONID.value = "--";
								//	return (false);
								//}
								//else if (document.MYFORM.elements["MONTH"+i+"-"+j].value !="1132" && document.MYFORM.SALES_GROUP_ID.value =="509") //add by Peggy 20210528
								//{
								//	alert("Line"+(i+1)+":This customer must book 1132 order type!!");
								//	document.MYFORM.ACTIONID.value = "--";
								//	return (false);
								//}
							}
						}
					} //enf for of jj
				} //end of for null check

				for (i=0;i<dim1;i++)
				{
					for (k=1;k<dim2;k++)
					{
						txt=document.MYFORM.elements["MONTH"+i+"-"+k].value;
						for (j=0;j<txt.length;j++)
						{
							c=txt.charAt(j);
						}
					} //enf for of k
				} //end of for  null check
			}  // 最外層 End of if (document.MYFORM.ACTIONID.value=="002")

			document.MYFORM.action=URL+"?RFQTYPE="+RFQ_TYPE;
			document.MYFORM.submit();
		}

		function setSubmit3(URL)
		{
			// 重選業務地區別,需將客戶清空,使其重選業務區對應之客戶資訊
			document.MYFORM.CUSTOMERNO.value = "";
			document.MYFORM.CUSTOMERNAME.value = "";
			document.MYFORM.CUSTOMERID.value = "";
			document.MYFORM.INVITEM.value = "";       //add by Peggy 20111228
			document.MYFORM.ITEMDESC.value = "";      //add by Peggy 20111228
			document.MYFORM.PLANTCODE.value = "";     //add by Peggy 20111228
			document.MYFORM.ORDERQTY.value = "";      //add by Peggy 20111228
			document.MYFORM.REQUESTDATE.value = "";   //add by Peggy 20111228
			document.MYFORM.UOM.value = "";           //add by Peggy 20111228
			document.MYFORM.LNREMARK.value = "";      //add by Peggy 20111228
			document.MYFORM.SPQP.value = "";          //add by Peggy 20111228
			document.MYFORM.SPQRULE.value = "";       //add by Peggy 20120516
			document.MYFORM.SHIPADDRESS.value = "";   //add by Peggy 20120303
			document.MYFORM.SHIPTOORG.value = "";     //add by Peggy 20120303
			document.MYFORM.PAYTERM.value= "";        //add by Peggy 20120303
			document.MYFORM.BILLTO.value = "";        //add by Peggy 20120303
			document.MYFORM.BILLADDRESS.value ="";    //add by Peggy 20120303
			document.MYFORM.FOBPOINT.value="";        //add by Peggy 20120303
			document.MYFORM.DELIVERYTO.value="";      //add by Peggy 20130418
			document.MYFORM.DELIVERYADDRESS.value=""; //add by Peggy 20130418
			document.MYFORM.DELIVERYCOUNTRY.value=""; //add by Peggy 20130418
			document.MYFORM.TAXCODE.value="";         //add by Peggy 20130418
			//document.MYFORM.SALES_GROUOP_ID.value=""; //add by Peggy 20210528
			if (document.MYFORM.ENDCUSTPOLINENO!=undefined)
			{
				document.MYFORM.ENDCUSTPOLINENO.value=""; //add by Peggy 20120601
			}
			document.MYFORM.action=URL;
			document.MYFORM.submit();
		}

		function setSubmit6(URL)
		{
			//add by Peggy 20120303
			var RFQ_TYPE = "";
			var radioLength = document.MYFORM.rfqtype.length;
			for(var i = 0; i < radioLength; i++)
			{
				if ( document.MYFORM.rfqtype[i].checked)
				{
					RFQ_TYPE = document.MYFORM.rfqtype[i].value;
				}
			}

			document.MYFORM.action=URL+"&RFQTYPE="+RFQ_TYPE;
			// 刪除特定已輸入陣列內容
			//document.MYFORM.action=URL;
			document.MYFORM.submit();
		}

		// 20110407 Marvie Update : Add CustomerID for FairChild MOQ
		function subWindowItemFind(invItem,itemDesc,sampleOrdCh,sCustomerId,salesAreaNo,orderType,fob)
		{
			subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh+"&CUSTOMERID="+sCustomerId+"&sType=D1001&SALESAREA="+salesAreaNo+"&ORDERTYPE="+orderType+"&FOB="+fob+"&PRICELIST="+document.MYFORM.FIRMPRICELIST.value+"&deliverid="+document.MYFORM.DELIVERYTO.value,"subwin","width=800,height=480,scrollbars=yes,menubar=no");
		}

		//20110906 add by Peggy
		function subItemFindincludePlant(invItem,itemDesc,sampleOrdCh,sCustomerId,sPlantCode,salesAreaNo,orderType,fob)
		{
			if (invItem != "" && invItem != null && itemDesc != "" && itemDesc != null && sPlantCode != "" && sPlantCode != null)
			{
				subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh+"&CUSTOMERID="+sCustomerId+"&PLANTCODE="+sPlantCode+"&sType=D1001&SALESAREA="+salesAreaNo+"&ORDERTYPE="+orderType+"&FOB="+fob+"&PRICELIST="+document.MYFORM.FIRMPRICELIST.value+"&deliverid="+document.MYFORM.DELIVERYTO.value,"subwin","width=800,height=480,scrollbars=yes,menubar=no");
			}
		}
		// 20110407 Marvie Update : Add CustomerID for FairChild MOQ
		function tabWindowItemFind(invItem,itemDesc,sampleOrdCh,sCustomerId,salesAreaNo,orderType,fob)
		{
			if ( (document.MYFORM.SPQP.value==null || document.MYFORM.SPQP.value=="") &&(document.MYFORM.MOQP.value==null || document.MYFORM.MOQP.value=="") )
			{
				if (document.MYFORM.INVITEM.value!="" && document.MYFORM.ITEMDESC.value!="")
				{
					subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh+"&CUSTOMERID="+sCustomerId+"&sType=D1001&SALESAREA="+salesAreaNo+"&ORDERTYPE="+orderType+"&FOB="+fob+"&PRICELIST="+document.MYFORM.FIRMPRICELIST.value+"&deliverid="+document.MYFORM.DELIVERYTO.value,"subwin","width=800,height=480,scrollbars=yes,menubar=no");
				}
			}
		}

		function subWindowCustInfoFind(custNo,custName,parOrgID,chAreaNo)
		{  //alert(parOrgID);
			if (event.keyCode==13)
			{
				subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName+"&ORGID="+parOrgID+"&SAREANO="+chAreaNo+"&FuncName=D1001","subwin","width=640,height=480,scrollbars=yes,menubar=no");
			}
		}

		function setCustInfoFind(custID,custName,parOrgID,chAreaNo)
		{
			//add by Peggy 20220808
			if (document.MYFORM.SALESAREANO.value=="001")
			{
				if (document.MYFORM.PREORDERTYPE.value==null || document.MYFORM.PREORDERTYPE.value=="" || document.MYFORM.PREORDERTYPE.value=="--")
				{
					alert("Please choose a order type!!");
					document.MYFORM.PREORDERTYPE.focus();
					return false;
				}
			}
			subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custID+"&NAME="+custName+"&ORGID="+parOrgID+"&SAREANO="+chAreaNo+"&FuncName=D1001&ODRTYPE="+document.MYFORM.PREORDERTYPE.value,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}

		function setSubmit4(URL,insertPage)
		{
			var InsertPage="?INSERT="+document.MYFORM.INSERT.value;
			warray=new Array(document.MYFORM.INVITEM.value,document.MYFORM.ITEMDESC.value,document.MYFORM.ORDERQTY.value,document.MYFORM.REQUESTDATE.value);
			for (i=0;i<4;i++)
			{
				if (i<=1)
				{
					if ((warray[0]=="" || warray[0]==null || warray[0]=="--") && (warray[1]=="" || warray[1]==null || warray[1]=="--"))
					{
						alert("TSC Item or Item Description must input,please do not let them's data be Null !!");
						return(false);
					}
				}
				else if (warray[i]=="" || warray[i]==null || warray[i]=="--" )
				{
					alert("Before you want to add, please do not let the any fields of data be Null !!");
					return(false);
				} // End of else if (warray[i]=="")
			} //end of for  null check

			for (i=2;i<3;i++)
			{
				txt=warray[i];
				for (j=0;j<txt.length;j++)
				{
					c=txt.charAt(j);
				}
				if ("0123456789.".indexOf(c,0)<0)
				{
					alert("The Quantity data that you inputed should be numerical!!");
					return(false);
				}
			} //end of for  null check

			document.MYFORM.action=URL+InsertPage;
			document.MYFORM.submit();
		}

		// 2006/05/29 Add By Kerwin 增加判斷是否使用者設為樣品訂單_起
		function setSubmit5(URL,sampleOrder,inpJudge)
		{
			//alert(sampleOrder);
			var sOrderCheck = window.document.MYFORM.SAMPLEORDER;
			//alert(eval(sOrderCheck.checked));
			//alert(sOrderCheck.value);
			if (inpJudge>0)
			{
				alert("<jsp:getProperty name='rPH' property='pgAlertSampleCheckMsg'/>");
				if (sampleOrder=="" || sampleOrder=="off")
				{
					window.document.MYFORM.SAMPLEORDER.checked = false;
				}
				else if (sampleOrder=="on")
				{
					window.document.MYFORM.SAMPLEORDER.checked = true;
				}
				return false;
			}
			else
			{
				if (sampleOrder=="" || sampleOrder=="off")
				{
					window.document.MYFORM.SAMPLEORDER.checked = true;
				}
				else if (sampleOrder=="on")
				{
					window.document.MYFORM.SAMPLEORDER.checked = false;
				}
			}
			//add by Peggy 20120303
			var RFQ_TYPE = "";
			var radioLength = document.MYFORM.rfqtype.length;
			for(var i = 0; i < radioLength; i++)
			{
				if ( document.MYFORM.rfqtype[i].checked)
				{
					RFQ_TYPE = document.MYFORM.rfqtype[i].value;
				}
			}

			document.MYFORM.action=URL+"&RFQTYPE="+RFQ_TYPE;
			document.MYFORM.submit();
		}

		// 20060529 Add By Kerwin 增加判斷是否使用者設為樣品訂單_迄
		//Enter Keycode = 13, Tab Keycode = 9
		// 20110407 Marvie Update : Add CustomerID for FairChild MOQ
		function setItemFindCheck(invItem,itemDesc,sampleOrdCh,sCustomerId,salesAreaNo,orderType,fob)
		{
			if (event.keyCode==13 || document.MYFORM.INVFLAG.value =="1")
			{
				subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh+"&CUSTOMERID="+sCustomerId+"&sType=D1001&SALESAREA="+salesAreaNo+"&ORDERTYPE="+orderType+"&FOB="+fob+"&PRICELIST="+document.MYFORM.FIRMPRICELIST.value+"&deliverid="+document.MYFORM.DELIVERYTO.value,"subwin","width=800,height=480,scrollbars=yes,menubar=no");
			}
		}

		// 檢查閏年,判斷日期輸入合法性
		function isLeapYear(year)
		{
			if((year%4==0&&year%100!=0)||(year%400==0))
			{
				return true;
			}
			return false;
		}

		// Add by Peggychen 20110614
		function subWindowSSDFind(sKind,plant)
		{
			var itemdesc = document.MYFORM.INVITEM.value;
			var crdate = document.MYFORM.CRD.value;
			//var plant = document.MYFORM.PLANTCODE.value;
			//var odrtype = document.MYFORM.PREORDERTYPE.value;
			var odrtype = document.MYFORM.LINEODRTYPE.value;  //modify by Peggy 20120905
			var region = document.MYFORM.SALESAREANO.value;
			var createdt = document.MYFORM.SYSDATE.value;
			var shippingMethod = document.MYFORM.SHIPPINGMETHOD.value;
			var SSDate = document.MYFORM.REQUESTDATE.value;
			var lineFOB = document.MYFORM.LINEFOB.value; //add by Peggy 20140424
			var custid = document.MYFORM.CUSTOMERID.value; //add by Peggy 20151026
			var deliver_to_id= document.MYFORM.DELIVERYTO.value; //add by Peggy 20210208
			if (sKind == "1" || sKind == "3")
			{
				//if (sKind == "3" && shippingMethod != "") return; //add by Peggy 20130122
				//modify by Peggy 20140424
				if (sKind == "3" && (shippingMethod != "" || (region=="001" && (lineFOB.toUpperCase().indexOf("FOB")>=0 || (odrtype!="1214" && lineFOB.toUpperCase()=="EX WORKS") || lineFOB.toUpperCase()=="EX-WORK" || lineFOB.toUpperCase()=="FCA TAIWAN" || lineFOB.toUpperCase()=="FCA TIANJIN" || lineFOB.toUpperCase()=="FCA I-LAN" || lineFOB.toUpperCase()=="FCA YANGXIN XIAN" || lineFOB.toUpperCase()=="C&F H.K." || lineFOB.toUpperCase()=="EXW I-LAN" || lineFOB.toUpperCase()=="CIF H.K."))) ) return; //modify by Peggy 20140424,1214 EX WORKS 排除 by Peggy 20220413

				if (sKind == "1")
				{
					shippingMethod = "";
				}
				else if (sKind == "3")
				{
					shippingMethod = "*";
				}
				if (itemdesc =="" || itemdesc == null)
				{
					alert("Please input the item !!! ");
					document.MYFORM.INVITEM.focus();
					return (false);
				}

				if (odrtype == "--" || odrtype == ""  || odrtype == null)
				{
					alert("Please choice the Order Type !!! ");
					document.MYFORM.PREORDERTYPE.focus();
					return (false);
				}

				if (crdate=="" || crdate==null)
				{
					alert("Please input a value on CRD field !!! ");
					document.MYFORM.CRD.focus();
					return (false);
				}

				if (crdate.length!= 8)
				{
					alert("The format of CRD field must be yyyymmdd !!! ");
					document.MYFORM.CRD.focus();
					return (false);
				}
				else
				{
					var year = crdate.substring(0,4);
					var mon = crdate.substring(4,6);
					var dd = crdate.substring(6,8);
					if (year.substring(0,1) != 2)
					{
						alert("The year is invalid on CRD field!!! ");
						document.MYFORM.CRD.focus();
						return (false);
					}
					else if (mon <1 || mon>12)
					{
						alert("The month is invalid on CRD field!!! ");
						document.MYFORM.CRD.focus();
						return (false);
					}
					else if (dd <1 || dd>31)
					{
						alert("The date is invalid on CRD field!!! ");
						document.MYFORM.CRD.focus();
						return (false);
					}
					else
					{
						if (((mon == 4 || mon == 6 || mon == 9 || mon == 11) && dd >30)
								|| ((mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12) && dd >31)
								|| (isLeapYear(year) && mon == 2 && dd>29)
								|| (!isLeapYear(year) && mon == 2 && dd>28))
						{
							alert("The date is invalid on CRD field!!! ");
							document.MYFORM.CRD.focus();
							return (false);
						}
					}
				}

				if (plant=="" || plant==null)
				{
					alert("Please choise the item !!!");
					document.MYFORM.INVITEM.focus();
					return (false);
				}
				subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod+"&itemname="+itemdesc+"&custid="+custid+"&fob="+lineFOB.replace("&","\"")+"&deliverid="+deliver_to_id,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); //add by Peggy 20210207
			}
			else
			{
				if (shippingMethod != "" && shippingMethod != null && crdate != "" && crdate != null && (SSDate == "" || SSDate == null))
				{
					subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod+"&itemname="+itemdesc+"&custid="+custid+"&fob="+lineFOB.replace("&","\"")+"&deliverid="+deliver_to_id,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); //add by Peggy 20210207
				}
			}
		}

		function setValue()
		{
			if (document.MYFORM.showCRD.value =="Y")
			{
				document.MYFORM.SHIPPINGMETHOD.value ="";
			}
			//add by Peggy 20130411
			setCurrency(document.MYFORM.CUSTOMERPO.value);
		}

		// 20110815 add by Peggy
		function subWindowPlantFind()
		{
			var salesAreaCode = document.MYFORM.SALESAREANO.value;
			var invItem = document.MYFORM.INVITEM.value;
			var custName = document.MYFORM.CUSTOMERNAME.value;
			var PlantCode = document.MYFORM.PLANTCODE.value;
			var marketGroup = document.MYFORM.CUSTMARKETGROUP.value;
			var tscPackage = document.MYFORM.TSCPACKAGE.value;

			if (salesAreaCode == null || salesAreaCode == "")
			{
				alert("Please input a value on Sales Area field!");
				document.MYFORM.SALESAREANO.focus();
				return (false);
			}

			if (custName == null || custName == "")
			{
				alert("Please input a value on customer name field!");
				document.MYFORM.CUSTOMERNAME.focus();
				return (false);
			}

			if (invItem == null || invItem == "")
			{
				alert("Please input a value on TSC Item Name field!");
				document.MYFORM.INVITEM.focus();
				return (false);
			}

			if (salesAreaCode=="001" && tscPackage =="SMA")
			{
				marketGroup = "AU";
			}

			if (document.MYFORM.showCRD.value=="Y")
			{
				var CRD = document.MYFORM.CRD.value;
				var ShippingMethod = document.MYFORM.SHIPPINGMETHOD.value;
				subWin=window.open("../jsp/subwindow/TSDRQPlantFind.jsp?SALESAREANO="+salesAreaCode+"&INVITEM="+invItem+"&CUSTNAME="+custName+"&CRD="+CRD+"&SHIPPINGMETHOD="+ShippingMethod+"&PLANTCODE="+PlantCode+"&MARKETGP="+marketGroup,"subwin","location=no,left=450,top=300,width=280,height=150,scrollbars=no,menubar=no");
			}
			else
			{
				subWin=window.open("../jsp/subwindow/TSDRQPlantFind.jsp?SALESAREANO="+salesAreaCode+"&INVITEM="+invItem+"&CUSTNAME="+custName+"&PLANTCODE="+PlantCode+"&MARKETGP="+marketGroup,"subwin","location=no,left=450,top=300,width=280,height=150,scrollbars=no,menubar=no");
			}
		}
		//add by Peggy 20120209
		function subWindowShipMethodFind(primaryFlag)
		{
			subWin=window.open("../jsp/subwindow/TSDRQShippingMethodFind.jsp?PRIMARYFLAG="+primaryFlag+"&SEARCHSTRING="+primaryFlag+"&sType=D1001","subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20120215
		function subWindowShipToFind(siteUseCode,customerID,shipToOrg,salesAreaNo,address)
		{
			if (salesAreaNo == null || salesAreaNo =="")
			{
				alert("please choose the sales area!");
				return false;
			}

			if (customerID == null || customerID =="")
			{
				alert("please choose the customer!");
				return false;
			}

			//add by Peggy 20220808
			if (document.MYFORM.SALESAREANO.value=="001")
			{
				if (document.MYFORM.PREORDERTYPE.value==null || document.MYFORM.PREORDERTYPE.value=="" || document.MYFORM.PREORDERTYPE.value=="--")
				{
					alert("Please choose a order type!!");
					document.MYFORM.PREORDERTYPE.focus();
					return false;
				}
			}
			subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&SHIPTOORG="+shipToOrg+"&SALESAREANO="+salesAreaNo+"&FUNC=D1001&ADDRESS="+address,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20120215
		function subWindowFOBPointFind(primaryFlag,fieldType)
		{
			subWin=window.open("../jsp/subwindow/TSDRQFOBPointFind.jsp?PRIMARYFLAG="+primaryFlag+"&FUNC=D1001&FTYPE="+fieldType,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20120215
		function subWindowPayTermFind(primaryFlag)
		{
			subWin=window.open("../jsp/subwindow/TSDRQPaymentTermFind.jsp?PRIMARYFLAG="+primaryFlag+"&FUNC=D1001","subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20120303
		function subWindowOrderTypeFind(primaryFlag,salesAreaNo,plantCode,customerID)
		{
			if (salesAreaNo == null || salesAreaNo =="")
			{
				alert("please choose the sales area!");
				return false;
			}

			if (plantCode == null || plantCode =="")
			{
				alert("please choose the manufacture factory!");
				return false;
			}
			subWin=window.open("../jsp/subwindow/TSDRQOrderTypeFind.jsp?PRIMARYFLAG="+primaryFlag+"&SalesAreaNo="+salesAreaNo+"&MANUFACTORY="+plantCode+"&CUSTOMERID="+customerID,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20120303
		function subWindowLineTypeFind(primaryFlag,salesAreaNo,orderType)
		{
			if (salesAreaNo == null || salesAreaNo =="")
			{
				alert("please choose the sales area!");
				return false;
			}

			if (orderType == null || orderType =="")
			{
				alert("please choose the order type!");
				return false;
			}
			subWin=window.open("../jsp/subwindow/TSDRQLineTypeFind.jsp?PRIMARYFLAG="+primaryFlag+"&SalesAreaNo="+salesAreaNo+"&orderType="+orderType,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20120306
		function subWindowCustItemFind()
		{
			var CUSTOMERID = document.MYFORM.CUSTOMERID.value;
			var INVITEM = document.MYFORM.INVITEM.value;
			var CITEMDESC = document.MYFORM.CITEMDESC.value;  //add by Peggy 20130412
			if (CUSTOMERID == null || CUSTOMERID =="")
			{
				alert("please choose the customer!");
				return false;
			}
			if ((INVITEM == null || INVITEM == "") && (CITEMDESC == null || CITEMDESC == ""))
			{
				alert("please choose the tsc item or customer item name!");
				return false;
			}
			subWin=window.open("../jsp/subwindow/TSDRQCustomerItemFind.jsp?INVITEM="+INVITEM+"&CUSTOMERID="+CUSTOMERID+"&CUSTITEM="+CITEMDESC,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}

		function subWindowCustItemCheck()
		{
			if (event.keyCode==13)
			{
				subWindowCustItemFind();
			}
		}

		//add by Peggy 20120316
		function setSPQImportCheck()
		{
			//add by Peggy 20140408
			var RFQ_TYPE = "";
			var radioLength = document.MYFORM.rfqtype.length;
			for(var i = 0; i < radioLength; i++)
			{
				if ( document.MYFORM.rfqtype[i].checked)
				{
					RFQ_TYPE = document.MYFORM.rfqtype[i].value;
				}
			}
			SQPWindow=window.open("../jsp/subwindow/TSCRFQImportSPQCheck.jsp?PCODE=D1001&RFQTYPE="+RFQ_TYPE+"&SAMPLEORDER="+document.MYFORM.SAMPLEORDER.checked+"&SHIPTOORGID="+document.MYFORM.SHIPTOORG.value,"spqwin","width=780,height=500,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20120423
		function setLineCustPO()
		{
			document.MYFORM.ENDCUSTPO.value = document.MYFORM.CUSTOMERPO.value;
			//add by Peggy 20130411
			setCurrency(document.MYFORM.CUSTOMERPO.value);
		}

		//add by Peggy 20120427
		function clearLineType()
		{
			document.MYFORM.LINETYPE.value = "";
		}

		//add by Peggy 20130219
		function subWindowShipToContactFind()
		{
			var CUSTOMERID=document.MYFORM.CUSTOMERID.value;
			var customerName=document.MYFORM.CUSTOMERNAME.value;
			var SHIPTOCONTACT=document.MYFORM.SHIPTOCONTACT.value;
			subWin=window.open("../jsp/subwindow/TscShipToContact.jsp?PROGRAMID=D1001&CUSTOMERNUMBER="+CUSTOMERID+"&CUSTOMERNAME="+customerName+"&SHIPTOCONTACT="+SHIPTOCONTACT,"subwin","top=200,left=400,width=550,height=300,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20130411
		function setCurrency(custpo)
		{
			var salesAreaCode = document.MYFORM.SALESAREANO.value;
			var orderType = document.MYFORM.PREORDERTYPE.value;
			if (salesAreaCode=="001" &&  orderType=="1342" && custpo.length >=2)
			{
				var idx = custpo.substring(0,custpo.indexOf("-"));
				if (custpo.indexOf("-")<0 && custpo.length ==2)
				{
					idx = custpo.substring(0,2);
				}
				if (idx==1 || idx ==4 || idx==5 || idx==8 || idx ==9 || idx==10 || idx ==12 || idx==14 || idx==20 || idx==23 || idx==29 || idx==30 || idx==35 ||
						idx==47 || idx==49 || idx==50 || idx==53 || idx==55 || idx==56 || idx==57 || idx==59 || idx==60 || idx==63 || idx==64 || idx==65 || idx==66 ||
						idx==68 || idx==73 || idx==74 || idx==75 || idx==79 || idx==80 || idx==84 || idx==85 || idx==88 || idx==90 || idx==100)
				{
					document.MYFORM.CURR.value = "USD";
					document.MYFORM.FIRMPRICELIST.value = "6038";
				}
				else
				{
					document.MYFORM.CURR.value = "EUR";
					document.MYFORM.FIRMPRICELIST.value = "7331";
				}
			}
		}

		//add by Peggy 20130424
		function subWindowTaxCodeFind()
		{
			subWin=window.open("../jsp/subwindow/TSDRQTaxCodeFind.jsp","subwin","width=500,height=480,scrollbars=yes,menubar=no");
		}

		function setsubmitChg()
		{
			if (document.MYFORM.ACTIONID.value !="--")
			{
				document.MYFORM.ACTIONID.value="--";
			}
		}
		//add by Peggy 20140812
		function subWindowEndCustFind(custnumber,salesarea,endcustomer)
		{
			if (custnumber==null || custnumber=="")
			{
				alert("Please choose ERP customer!");
				document.MYFORM.CUSTOMERNO.focus();
				return false;
			}
			if (salesarea==null || salesarea=="")
			{
				alert("Please choose sales area!");
				document.MYFORM.SALESAREANO.focus();
				return false;
			}
			subWin=window.open("../jsp/subwindow/TSDRQERPEndCustFind.jsp?CUSTNUMBER="+custnumber+"&SALESAREA="+salesarea+"&ENDCUST="+endcustomer,"subwin","width=600,height=480,scrollbars=yes,menubar=no");
		}

		//add by Peggy 20140813
		function custChange()
		{
			document.MYFORM.ENDCUSTOMERID.value="";
		}

		function setPOObject(salesarea,customerpo)
		{
			if (salesarea=="020")
			{
				if (customerpo.toUpperCase().indexOf("(K)",0)>=0 || customerpo.toUpperCase().indexOf("KOREA",0)>=0)
				{
					document.MYFORM.DIRECT_SHIP_TO_CUST.value="1";
				}
				else
				{
					document.MYFORM.DIRECT_SHIP_TO_CUST.value="";
				}
			}
		}

		function setPrice(salesarea,quotenum,tscpartno,tscitem)
		{
			if (event.keyCode==13)
			{
				subWin=window.open("../jsp/subwindow/TSDRQQuoteInfoFind.jsp?QNO="+quotenum+"&PNO="+tscpartno+"&PITEM="+tscitem,"subwin","top=400,left=600,width=500,height=100,scrollbars=yes,menubar=no");
			}
		}
	</script>
	<%
		String docNo=request.getParameter("DOCNO");
		String targetYear="";
		String targetMonth="";
		String customerNo = "";
		String customerName= "";
		String customerId=request.getParameter("CUSTOMERID");
//		String customerNo=request.getParameter("CUSTOMERNO");
//		String customerName=request.getParameter("CUSTOMERNAME");
		String custActive=request.getParameter("CUSTACTIVE");
		String salesAreaNo=request.getParameter("SALESAREANO");
		String salesPersonID=request.getParameter("SALESPERSONID");
		String customerPO=request.getParameter("CUSTOMERPO");
		String receptDate=request.getParameter("RECEPTDATE");
		String curr=request.getParameter("CURR");
		String remark=request.getParameter("REMARK");
		String requireReason=request.getParameter("REQUIREREASON");
		String preOrderType=request.getParameter("PREORDERTYPE");
		String isModelSelected=request.getParameter("ISMODELSELECTED");
		String processArea=request.getParameter("PROCESSAREA");
		String salesPerson=request.getParameter("SALESPERSON");
		String toPersonID=request.getParameter("TOPERSONID");
		String customerIdTmp=request.getParameter("CUSTOMERIDTMP");
		String insertPage=request.getParameter("INSERT");
		String preSeqNo=request.getParameter("PREDNDOCNO");
		String repeatInput=request.getParameter("REPEATINPUT");
		String custAROverdue=request.getParameter("CUSTOMERAROVERDUE");
		String sampleOrder=request.getParameter("SAMPLEORDER");
		String sOrderCheck=request.getParameter("SORDERCHECK");
		String sampleCharge=request.getParameter("SAMPLECHARGE");
		String spqCheck=request.getParameter("SPQCHECK");
		String nSpqCheck=request.getParameter("NSPQCHECK");
		String parOrgID=request.getParameter("PARORGID");  // 業務地區對應的ORG_ID
		String modelN = StringUtils.isNullOrEmpty(request.getParameter("modelN")) ? "" : request.getParameter("modelN");
		String groupByType = StringUtils.isNullOrEmpty(request.getParameter("groupByType")) ? "" : request.getParameter("groupByType");
//String allowCRD="";
		String computeSSD="N";
		String strdisable = "";
		//String custINo=request.getParameter("CUSTINO"); // 客戶項次編號
		String ShipToOrg = request.getParameter("SHIPTOORG");      //add by Peggy 20120215
		if (ShipToOrg==null) ShipToOrg="";
		String billTo = request.getParameter("BILLTO");            //add by Peggy 20120215
		if (billTo==null) billTo="";
		String shipAddress = request.getParameter("SHIPADDRESS");  //add by Peggy 20120215
		if (shipAddress==null) shipAddress="";
		String billAddress = request.getParameter("BILLADDRESS");  //add by Peggy 20120215
		if (billAddress==null) billAddress="";
		String shipCountry = request.getParameter("SHIPCOUNTRY");  //add by Peggy 20120215
		if (shipCountry==null) shipCountry="";
		String billCountry = request.getParameter("BILLCOUNTRY");  //add by Peggy 20120215
		if (billCountry==null) billCountry="";
		String deliveryTo = request.getParameter("DELIVERYTO");    //add by Peggy 20130218
		if (deliveryTo==null) deliveryTo="";
		String deliveryAddress = request.getParameter("DELIVERYADDRESS"); //add by Peggy 20130218
		if (deliveryAddress==null) deliveryAddress="";
		String deliveryCountry = request.getParameter("DELIVERYCOUNTRY"); //add by Peggy 20130218
		if (deliveryCountry==null) deliveryCountry="";
		String shipToContact = request.getParameter("SHIPTOCONTACT");  //add by Peggy 20130218
		if (shipToContact ==null) shipToContact="";
		String shipToContactid = request.getParameter("SHIPTOCONTACTID");  //add by Peggy 20130220
		if (shipToContactid ==null) shipToContactid="";
		String paymentTerm = request.getParameter("PAYTERM");      //add by Peggy 20120215
		if (paymentTerm==null || paymentTerm.equals("")) paymentTerm="";
		String payTermID = request.getParameter("PAYTERMID");      //add by Peggy 20120215
		if (payTermID==null) payTermID="";
		String fobPoint = request.getParameter("FOBPOINT");        //add by Peggy 20120215
		if (fobPoint==null) fobPoint="";
		String firmPriceList = request.getParameter("FIRMPRICELIST"); //add by Peggy 20120215
		if (firmPriceList==null || firmPriceList.equals("--")) firmPriceList="";
		String custPartNo = request.getParameter("CITEMDESC");    //add by Peggy 20120301
		if (custPartNo==null) custPartNo = "";
		String sellingPrice = request.getParameter("UPRICE");     //add by Peggy 20120301
		if (sellingPrice==null) sellingPrice = "";
		String orderType = request.getParameter("LINEODRTYPE");   //add by peggy 20120301
		if (orderType==null) orderType = "";
		String lineType = request.getParameter("LINETYPE");      //add by peggy 20120301
		if (lineType==null) lineType = "";
		String programName = request.getParameter("PROGRAMNAME");  //add by Peggy 20120303
		if (programName==null) programName="D1-001";
		String rfqType = request.getParameter("RFQTYPE");    //add by Peggy 20120303
		String salesarealist = ","+UserRegionSet.replace("'","")+",";
		if (rfqType==null)
		{
			rfqType="";
			//if (userActCenterNo.equals("001")) //tsce rfq_type default value=NORMAL,add by Peggy 20140325
			if (salesarealist.indexOf(",001,")>0 || salesarealist.indexOf(",003,")>0 || salesarealist.indexOf(",008,")>0) //modify by Peggy 20160509
			{
				rfqType="NORMAL";
			}
		}
		String rfqTypeNormal = "";
		String rfqTypeForecast = "";
		if (rfqType.equals("NORMAL"))
		{
			rfqTypeNormal="checked";
		}
		else if (rfqType.equals("FORECAST"))
		{
			rfqTypeForecast="checked";
		}
		String ship_via = request.getParameter("SHIPVIA"); //add by Peggy 20120309
		if (ship_via == null) ship_via="";
		String SPQChecked=request.getParameter("SPQCHECKED"); //add by Peggy 20120316
		if (SPQChecked==null) SPQChecked="Y";
		String lineFob=request.getParameter("LINEFOB"); //add by Peggy 20120329
		if (lineFob==null) lineFob="";
		int commitmentMonth=0;
		arrayRFQDocumentInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
		String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
		String comp=request.getParameter("COMP");
		String actionID = request.getParameter("ACTIONID");  //add by Peggy 20121115
		String CUSTMARKETGROUP=request.getParameter("CUSTMARKETGROUP"); //add by Peggy 20111004
		if (CUSTMARKETGROUP ==null) CUSTMARKETGROUP = ""; //add by Peggy 20111004
		String TSCPACKAGE=request.getParameter("TSCPACKAGE"); //add by Peggy 20111004
		if (TSCPACKAGE==null) TSCPACKAGE = "";            //add by Peggy 20111004
		String defaultOdrType="",defaultLineType="",defaultShipMethod="";      //add by Peggy 20120417
		String QUOTENUMBER = request.getParameter("QUOTENUMBER");  //add by Peggy 20120904
		if (QUOTENUMBER ==null) QUOTENUMBER = "";                  //add by Peggy 20120904
		String ENDCUSTOMER = request.getParameter("ENDCUSTOMER");  //add by Peggy 20121107
		if (ENDCUSTOMER ==null) ENDCUSTOMER = "";                  //add by Peggy 20121107
		String ENDCUSTOMERID = request.getParameter("ENDCUSTOMERID");  //add by Peggy 20140812
		if (ENDCUSTOMERID ==null) ENDCUSTOMERID = "";                  //add by Peggy 20140812
		String [] addItems=request.getParameterValues("ADDITEMS");
//String custINo=request.getParameter("CUSTINO"),
		String iNo=request.getParameter("INO"),invItem=request.getParameter("INVITEM"),itemDesc=request.getParameter("ITEMDESC"),orderQty=request.getParameter("ORDERQTY"),uom=request.getParameter("UOM"),requestDate=request.getParameter("REQUESTDATE"),lnRemark=request.getParameter("LNREMARK"),sPQP=request.getParameter("SPQRULE"),endCustPO=request.getParameter("ENDCUSTPO");
		String customerPOLineNo=request.getParameter("ENDCUSTPOLINENO"); //Add by Peggy 20120531
		if (customerPOLineNo==null) customerPOLineNo="";
		String SAMPLESPQ=request.getParameter("SAMPLESPQ");
		String custrequestDate=request.getParameter("CRD"),shippingMethod=request.getParameter("SHIPPINGMETHOD");  //add by Peggychen 20110614
		String custPOLineNo_flag="";    //add by Peggy 20120601
		String taxcode = request.getParameter("TAXCODE");
		if (taxcode ==null) taxcode ="";  //add by Peggy 20130410
		String LIMITDAYS=request.getParameter("LIMITDAYS");
		if (LIMITDAYS == null)
		{
			LIMITDAYS ="6";
		}
		else if (LIMITDAYS.equals("0"))
		{
			LIMITDAYS ="-1";
		}
		String LIMITDAYS1="6";
		if ((salesAreaNo==null && userActCenterNo.equals("020")) || (salesAreaNo!= null && salesAreaNo.equals("020"))) //add by Peggy 20150908,sample區交期只要大於系統日即可
		{
			LIMITDAYS1 ="0";
		}
		dateBeans.setAdjDate(Integer.parseInt(LIMITDAYS));
		String maxDate = dateBeans.getYearMonthDay();
		dateBeanss.setAdjDate(Integer.parseInt(LIMITDAYS1));
		String maxDate1 = dateBeanss.getYearMonthDay();
		if (custrequestDate == null) custrequestDate = "";
		if (shippingMethod == null) shippingMethod = "";
		String fobList = request.getParameter("FOBLIST");  //add by Peggy 20130219
		if (fobList==null) fobList="";
		String shipto = request.getParameter("SHIPTO");
		if (shipto==null) shipto=""; //add by Peggy 20160302
		String BI_REGION=request.getParameter("BI_REGION");  //add by Peggy 20170218
		if (BI_REGION==null||BI_REGION.equals("--")) BI_REGION="";
		String direct_ship_to_cust=request.getParameter("DIRECT_SHIP_TO_CUST");  //add by Peggy 20160308
		if (direct_ship_to_cust==null||direct_ship_to_cust.equals("--")) direct_ship_to_cust="";
		String end_cust_ship_to_id = request.getParameter("end_cust_ship_to_id");  //add by Peggy 20170512
		if (end_cust_ship_to_id==null) end_cust_ship_to_id="";
		String endCustPartNo=request.getParameter("EndCustPartNo"); //add by Peggy 20190225
		if (endCustPartNo==null) endCustPartNo="";
//String [] allMonth={iNo,invItem,itemDesc,orderQty,uom,requestDate,endCustPO,lnRemark};
//add two parameters by Peggy 20110614
		String [] allMonth={iNo,invItem,itemDesc,orderQty,uom,custrequestDate,shippingMethod,requestDate,endCustPO,lnRemark};
		String entry=request.getParameter("ENTRY");
		if (entry==null || entry.equals("") )
		{
		}
		else
		{
			arrayRFQDocumentInputBean.setArray2DString(null);
		}
		String ORIGPRICELIST = request.getParameter("ORIGPRICELIST");
		if (ORIGPRICELIST==null) ORIGPRICELIST=""; //add by Peggy 20130909
		String ORIGCURR = request.getParameter("ORIGCURR");
		if (ORIGCURR==null) ORIGCURR ="";          //add by Peggy 20130909
		String UPLOAD_TEMP_ID = request.getParameter("UPLOAD_TEMP_ID");
		if (UPLOAD_TEMP_ID==null) UPLOAD_TEMP_ID="";  //add by Peggy 20160309
		String ShipToOrgID = request.getParameter("SHIPTOORGID");      //add by Peggy 20180720
		if (ShipToOrgID==null) ShipToOrgID="";
		String SALES_GROUP_ID=request.getParameter("SALES_GROUP_ID"); //add by Peggy 20210528
		if (SALES_GROUP_ID==null) SALES_GROUP_ID="";
		String SUPPLIER_NUMBER=request.getParameter("SUPPLIER_NUMBER"); //add by Peggy 20220428
		if (SUPPLIER_NUMBER==null) SUPPLIER_NUMBER="";
		String SUPPLIER_FLAG=request.getParameter("SUPPLIER_FLAG"); //add by Peggy 20220428
		if (SUPPLIER_FLAG==null) SUPPLIER_FLAG="";
		String v_normal_inactive_flag=""; //add by Peggy 20230113

//if (custINo==null || custINo.equals("")) custINo = "1";
		if (iNo==null || iNo.equals("")) iNo = "1";
		if (receptDate==null || receptDate.equals("")) receptDate=dateBean.getYearMonthDay();
		if (curr==null || curr.equals("")) curr="";
		if (remark==null || remark.equals("")) remark="";
		if (requireReason==null || requireReason.equals("")) requireReason="";
		if (customerPO==null || customerPO.equals("")) customerPO="";
		if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N"; // 預設未輸入任一筆明細
		if (salesPerson==null || salesPerson.equals("")) salesPerson="";
		if (customerId==null || customerId.equals("")) customerId="";
		if (customerNo==null || customerNo.equals("")) customerNo="";
		if (customerName==null || customerName.equals("")) customerName="";
		if (custActive==null || custActive.equals("")) custActive="";
		if (custAROverdue==null || custAROverdue.equals("")) custAROverdue="N";

		if (sampleCharge==null || sampleCharge.equals("")) sampleCharge="";

		if (salesAreaNo==null)
		{
			salesAreaNo = userActCenterNo; // 若未選擇其他任何一業務區,則以使用者Login預設
			//parOrgID = userParOrgID; // 預設是User的Primary Sale Area
		}
		int tabidx = 1;
//else
		if (salesAreaNo!=null)
		{  // 否則,以選擇的業務地區找其Parent Organization作為 ORG_ID_起
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSSALES_AREA where SALES_AREA_NO='"+salesAreaNo+"'");
			if (rs.next())
			{
				parOrgID=rs.getString("PAR_ORG_ID");
				computeSSD=rs.getString("SSD_FLAG");  //add by Peggychen 20110614
				processArea=rs.getString("SALES_AREA_NO")+"("+rs.getString("SALES_AREA_NAME")+")";   //add by Peggy 20130516
				sampleCharge=rs.getString("SAMPLE_CHARGE");                     //modify by Peggy 20150715
				sampleOrder=(rs.getString("SAMPLE_AREA").equals("Y")?"on":"");  //modify by Peggy 20150715
				if (sampleOrder.equals("on"))
				{
					toPersonID="100001180";
					salesPerson="SAMPLE";
				}
			}
			rs.close();
			statement.close();
			// 否則,以選擇的業務地區找其Parent Organization作為 ORG_ID_迄
		}

		try
		{
			//20110107 liling__sample 固定 TSCE
			if (salesAreaNo=="020" || salesAreaNo.equals("020") || salesAreaNo=="021" || salesAreaNo.equals("021")) //add salesno:021 by Peggy 20120517
			{
				customerNo ="10877";
				customerName="TAIWAN SEMICONDUCTOR CO.,LTD";
				customerId= "20100";
				custActive="A";
				curr="USD";
				//salesPerson="SAMPLE";
				//toPersonID="100001180";
				//sampleOrder="on";
				//sampleCharge="N";
				preOrderType="1015";
				defaultOdrType="1121";                   //add by Peggy 20120417
				defaultLineType="1013";                  //add by Peggy 20120417
				defaultShipMethod="000001_TRUCK_L_LTL"; //add by Peggy 20120417
			}
			else if (salesAreaNo=="022" || salesAreaNo.equals("022")) //add by Peggy 20120517
			{
				customerNo ="7883";
				customerId= "14980";
				custActive="A";
				curr="CNY";
				//salesPerson="SAMPLE";
				//sampleOrder="on";
				//sampleCharge="N";
				//toPersonID="100001180";
				preOrderType="1302";
				defaultOdrType="4121";
				defaultLineType="1163";
				CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
				cs1.setString(1,parOrgID);  // 取業務員隸屬ParOrgID
				cs1.execute();
				cs1.close();
				Statement statementa=con.createStatement();
				ResultSet rsa=statementa.executeQuery("select CUSTOMER_NAME from ar_CUSTOMERS where status = 'A'  and CUSTOMER_ID ='"+customerId+"'");
				if(rsa.next())
				{
					customerName=rsa.getString("CUSTOMER_NAME");
				}
				rsa.close();
				statementa.close();
			}
			else
			{
				//sampleCharge="Y";
				defaultOdrType="";    //add by Peggy 20120417
				defaultLineType="";   //add by Peggy 20120417
				defaultShipMethod=""; //add by Peggy 20120417
			}
			//20110107 liling
		} //end of try
		catch (Exception e)
		{
			out.println("Exception 020:"+e.getMessage());
		}

//add by Peggy 20120531
		if (customerId!=null && salesAreaNo!=null)
		{
			Statement statementa=con.createStatement();
			ResultSet rsa=statementa.executeQuery(" SELECT distinct 1 FROM ORADDMAN.tscust_special_setup WHERE sales_area_no ='"+salesAreaNo+"' AND customer_id='"+ customerId+"' and active_flag='A'"+
					" UNION ALL"+
					" SELECT distinct 1 FROM TSC_EDI_CUSTOMER WHERE SALES_AREA_NO ='"+salesAreaNo+"' AND CUSTOMER_ID ='"+ customerId+"' and (INACTIVE_DATE IS NULL OR INACTIVE_DATE > TRUNC(SYSDATE))"); //add by Peggy 20141211
			if (rsa.next())
			{
				custPOLineNo_flag = "Y";
			}
			else
			{
				custPOLineNo_flag = "N";
			}
			rsa.close();
			statementa.close();
		}
		else
		{
			custPOLineNo_flag = "N";
		}

// 20110209 Marvie Add : Add field  SPQ
		String spqp=request.getParameter("SPQP");
		String moqp=request.getParameter("MOQP");
//out.println("<BR>spqp="+spqp+"moqp="+moqp+"<BR>");
		String plantCode=request.getParameter("PLANTCODE"); //2009/03/02 liling add default item attribute3 plantcode
//out.println("PLANTCODE="+plantCode);
		String plantDesc="";
		String seqno=null;
		String seqkey=null;
		String dateString=null,def_ship_org_id="";  //add def_ship_org_id by Peggy 20180726
		String shipping_Marks="",remarks="",tsc_prod_group=""; //add by Peggy 20130305
		String v_conti_msg=""; //add by Peggy 202209
		String sql="";
		int inpLen = 0;  // 全域變數 inpLen

		if (insertPage==null) // 若輸入模式離開此頁面,則BeanArray內容清空
		{
			arrayRFQDocumentInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
		}
		else
		{
			if (salesAreaNo.equals("001") && insertPage.equals("Y"))
			{
				if (preOrderType.equals("1342")) //1214
				{
					sql = "SELECT TSC_CHECK_CONTI_ITEM((SELECT CUSTOMER_ID FROM AR_CUSTOMERS WHERE CUSTOMER_NUMBER=?),?,?) FROM DUAL";
				}
				else
				{
					sql = "SELECT TSC_CHECK_CONTI_ITEM(?,?,?) FROM DUAL";
				}
				PreparedStatement statement = con.prepareStatement(sql);
				if (preOrderType.equals("1342")) //1214
				{
					statement.setString(1,ENDCUSTOMERID);
				}
				else
				{
					statement.setString(1,customerId);
				}
				statement.setString(2,custPartNo);
				statement.setString(3,invItem);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{
					v_conti_msg=rs.getString(1);
				}
				rs.close();
				statement.close();

				if (!v_conti_msg.equals("OK"))
				{
	%>
	<SCRIPT>
		alert("<%=v_conti_msg%>");
	</script>
	<%
				}
			}

			String sp[][]=arrayRFQDocumentInputBean.getArray2DContent();//若為輸入模式,且內容不為null,則將陣列entity給全域變數 inpLen
			if (sp != null)
			{
				inpLen = sp.length; // 把已輸入的內容個數傳給此全域變數,做為判斷是否可重選樣本訂單依據
				//out.println("inpLen ="+inpLen);
			}
		}

		try
		{
			String at[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容
			//*************依Detail資料user可能再修改內容,故必須將其內容重寫入陣列內
			if (at!=null)
			{
				for (int ac=0;ac<at.length;ac++)
				{
					for (int subac=1;subac<at[ac].length;subac++)
					{
						//add by peggy 20120301
						if (request.getParameter("MONTH"+ac+"-"+subac)!=null && request.getParameter("MONTH"+ac+"-"+subac).trim()!="")
						{
							at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
						}
						//add by Peggy 20180720,FOR TSCA CUSTOMER=DIGIKEY issue
						if (programName.equals("D4-004") || programName.equals("D4-020"))
						{
							if ( SPQChecked.equals("Y") && ShipToOrgID.equals("55839") && (subac==6 || subac==18))
							{
								if (at[ac][16]!=null && at[ac][16].equals("1141"))
								{
									if (subac==6) at[ac][subac]="UPS EXPEDITED";
									if (subac==18) at[ac][subac]="FCA";
								}
							}

							if (ac==0)
							{
								if (subac==21 && (at[ac][subac].equals("25091") || at[ac][subac].equals("32712") || at[ac][subac].equals("32713")))
								{
									def_ship_org_id="55839";
								}
								//else if (subac==24 && at[ac][subac].toUpperCase().equals("FUTURE"))
								//{
								//	def_ship_org_id="58239";
								//}
								//else if (subac==24 && at[ac][subac].toUpperCase().equals("AVNET"))
								//{
								//	def_ship_org_id="43598";
								//}
							}
						}
						else if (programName.equals("TSCH"))  //add by Peggy 20190108
						{
							if (ac==0 && subac==21)
							{
								if (at[ac][subac].equals("26851")) def_ship_org_id="58178";
								if (at[ac][subac].equals("23080")) def_ship_org_id="40434";
								if (at[ac][subac].equals("29612")) def_ship_org_id="76338";  //Continental Automotive Singapore Pte Ltd add by Peggy 20201027
								if (at[ac][subac].equals("26971")) def_ship_org_id="67510";  //CONTINENTAL AUTOMOTIVE COMPONENTS MALAYSIA SDN. BH add by Peggy 20210506
								if (at[ac][subac].equals("30032")) def_ship_org_id="68010";  //Enics Malaysia  add by Peggy 20210720
								if (at[ac][subac].equals("31332")) def_ship_org_id="71434";  //Conti Philippines  add by Peggy 20220802
								if (at[ac][subac].equals("31912")) def_ship_org_id="72702";  //GPV add by Peggy 20230130
								if (at[ac][subac].equals("32932")) def_ship_org_id="75995";  //GPV(THAILAND) add by Peggy 20240304
								if (at[ac][subac].equals("33652")) def_ship_org_id="78652";  //Continental Autonomous Philippines ,ADD BY Mars 20250107
								if (at[ac][subac].equals("23121")) def_ship_org_id="65310";  //Continental Autonomous Philippines ,ADD BY Mars 20250107
							}
						}
					}  //end for array second layer count
				} //end for array first layer count
				//out.println("at.length="+at.length);
				arrayRFQDocumentInputBean.setArray2DString(at);  //reset Array
			}   //end if of array !=null
			//********************************************************************

			// 把 at.length() 值給 custINo作為目前預設的項次編號 kerwin 2006/02/17
			//if (custINo==null || custINo.equals("")) custINo="1";
			//else custINo = at.length();

			if (addItems!=null) //若有選取則表示要刪除
			{
				String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//重新取得陣列內容
				if (a!=null && addItems.length>0)
				{
					if (a.length>addItems.length)
					{
						String t[][]=new String[a.length-addItems.length][a[0].length];
						int cc=0;
						for (int m=0;m<a.length;m++)
						{
							String inArray="N";
							for (int n=0;n<addItems.length;n++)
							{
								if (addItems[n].equals(a[m][0])) inArray="Y";
							} //end of for addItems.length
							if (inArray.equals("N"))
							{
								// 20110307 Marvie Update : fix bug
								//for (int gg=0;gg<8;gg++) //置入陣列中元素數(注意..此處決定了陣列的Entity數目,若不同Entity數,必需修改此處,否則Delete 不Work)
								for (int gg=0;gg<a[m].length;gg++)
								{                          // 目前共8個{ iNo,invItem,itemDesc,orderQty,uom,requestDate,endCustPO,lnRemark }
									if (gg==0)
									{
										t[cc][gg]= Integer.toString(cc+1); // 把第一行的值重算
									}
									else
									{
										t[cc][gg]=a[m][gg];
									}
								}
								cc++;
							}
						} //end of if a.length
						arrayRFQDocumentInputBean.setArray2DString(t);
					}
					else
					{ 	//else (a!=null && addItems.length>0 )
						//arrayRFQDocumentInputBean.setArray2DString(null); //若陣列內容不為空,且addItems.length>0,則將陣列內容清空
						if (a.length==addItems.length)
						{
							arrayRFQDocumentInputBean.setArray2DString(null); //若陣列內容不為空,且陣列的Entity=addItems.length,則將陣列內容清空
							inpLen = 0; // 清空,則重設為零
						} // End of if (a.length==addItems.length)
					}
				}//end of if a!=null
			}

			if ( bringLast!=null  && bringLast.equals("Y"))  //若要帶出前一版本資料則執行以下動作
			{

			} //enf of bringLast if
			//dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
		} //end of try
		catch (Exception e)
		{
			out.println("Exception12:"+e.getMessage());
		}

		// 若單號未取得,則呼叫取號程序
		try
		{
			if (docNo==null || docNo.equals(""))
			{
				dateString=dateBean.getYearMonthDay();
				//seqkey="TS"+userActCenterNo+dateString;  //salesAreaNo
				//out.println("salesAreaNo="+salesAreaNo);
				if (salesAreaNo==null || salesAreaNo.equals("--")) seqkey="TS"+userActCenterNo+dateString; //但仍以預設為使用者地區
				else seqkey="TS"+salesAreaNo+dateString;         // 2006/01/10 改以選擇的業務地區代號產生單號
				//====先取得流水號=====
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");
				if (rs.next()==false)
				{
					String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";
					PreparedStatement seqstmt=con.prepareStatement(seqSql);
					seqstmt.setString(1,seqkey);
					seqstmt.setInt(2,1);

					seqstmt.executeUpdate();
					seqno=seqkey+"-001";
					seqstmt.close();
				}
				else
				{
					int lastno=rs.getInt("LASTNO");

					sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey
							+"' and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
					ResultSet rs2=statement.executeQuery(sql);
					//===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
					if (rs2.next())
					{
						lastno++;
						String numberString = Integer.toString(lastno);
						String lastSeqNumber="000"+numberString;
						lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
						seqno=seqkey+"-"+lastSeqNumber;

						String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";
						PreparedStatement seqstmt=con.prepareStatement(seqSql);
						seqstmt.setInt(1,lastno);

						seqstmt.executeUpdate();
						seqstmt.close();
					}
					else
					{
						//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
						String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO from ORADDMAN.TSDELIVERY_NOTICE"+
								" where substr(DNDOCNO,1,13)='"+seqkey+"' ";
						ResultSet rs3=statement.executeQuery(sSql);

						if (rs3.next()==true)
						{
							int lastno_r=rs3.getInt("LASTNO");
							lastno_r++;
							String numberString_r = Integer.toString(lastno_r);
							String lastSeqNumber_r="000"+numberString_r;
							lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
							seqno=seqkey+"-"+lastSeqNumber_r;

							String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";
							PreparedStatement seqstmt=con.prepareStatement(seqSql);
							seqstmt.setInt(1,lastno_r);

							seqstmt.executeUpdate();
							seqstmt.close();
						}  // End of if (rs3.next()==true)

					} // End of Else  //===========(處理跳號問題)
				} // End of Else
				docNo = seqno; // 把取到的號碼給本次輸入
			} // End of if (docNo==null || docNo.equals(""))
			else
			{
			}
		} //end of try
		catch (Exception e)
		{
			out.println("Exception1:"+e.getMessage());
		}
		//out.println(customerId);
		//out.println(customerIdTmp);
		// 取客戶ID對應的業務員
		try
		{
			if ((customerId !=null && !customerId.equals(customerIdTmp)) || toPersonID==null)// 若輸入過程變更客戶,則找新的負責的業務員資料及客戶對應的預設幣別
			{
				// 先由客戶ID取客戶的Site Use ID
				Statement statement=con.createStatement();
				//String sSql = "select b.PRIMARY_SALESREP_ID, c.NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,jtf_rs_salesreps c "+
				//              "where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and a.CUST_ACCOUNT_ID ='"+customerId+"' "+
				//			  "and a.STATUS = 'A' and a.ORG_ID = b.ORG_ID "+
				//			  //"and a.ORG_ID ='"+userParOrgID+"' and a.SHIP_TO_FLAG='P' "+
				//			  "and a.ORG_ID ='"+parOrgID+"' and a.SHIP_TO_FLAG='P' "+ // 2006/12/26 更正為取主要的Parent Organization ID
				//			  "and c.SALESREP_ID  = b.PRIMARY_SALESREP_ID "+
				//			  "and b.STATUS = 'A'"; //add by Peggy 20140623
				//change jtf_rs_salesreps to tsc_crm_lov_v for R12,modif by Peggy 20190723
				String sSql = " select distinct b.PRIMARY_SALESREP_ID, c.LOV_MEANING NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,tsc_crm_lov_v c "+
						" where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
						" and a.CUST_ACCOUNT_ID ='"+customerId+"' "+
						" and a.STATUS = 'A'"+
						" and a.ORG_ID = b.ORG_ID "+
						" and a.ORG_ID ='"+parOrgID+"'"+
						" and a.SHIP_TO_FLAG='P' "+
						" and c.LOV_CODE = to_char(b.PRIMARY_SALESREP_ID) "+
						" and b.STATUS = 'A'";
				//out.println(sSql);
				ResultSet rsSalsPs=statement.executeQuery(sSql);
				if (rsSalsPs.next())
				{
					//modify by Peggy 20130131
					if (salesAreaNo!="020" && !salesAreaNo.equals("020") && salesAreaNo!="021" && !salesAreaNo.equals("021") && salesAreaNo!="022" && !salesAreaNo.equals("022"))
					{
						salesPerson = rsSalsPs.getString("NAME");
						toPersonID = rsSalsPs.getString("PRIMARY_SALESREP_ID");
					}
				}
				else
				{
					toPersonID=userSalesResID; // 找不到客戶負責的業務人員,則以業務地區主要負責業務員
				}
				rsSalsPs.close();
				//out.print(sSql);
				//
				customerIdTmp = customerId;  // 把這次的客戶代號記入客戶代號暫存變數,作為下次判斷是否重取業務員之用
				// 取此客戶對應的 預設Profile Amount內的幣別檔
				//20091230 liling performance issue
				//sSql = "select CURRENCY_CODE from AR_CUSTOMER_PROFILE_AMOUNTS where to_char(customer_ID) ='"+customerId+"' ";
				sSql = "select CURRENCY_CODE from AR.AR_CUSTOMER_PROFILE_AMOUNTS where customer_ID ='"+customerId+"' ";
				ResultSet rsSCurr=statement.executeQuery(sSql);
				if (rsSCurr.next())
				{
					if (curr==null || curr.equals(""))
					{
						curr=rsSCurr.getString("CURRENCY_CODE");
					}
				}
				rsSCurr.close();
				statement.close();
				//out.print(sSql);
				if (SPQChecked.equals("N"))  //add by Peggy 20121114
				{
					session.setAttribute("CURR", curr);
					session.setAttribute("SALESPERSONID",salesPersonID);
					session.setAttribute("SALESPERSON",salesPerson);
				}

			} // End of if

		}
		catch (Exception e)
		{
			out.println("Exception2:"+e.getMessage());
		}
//add by Peggy 20130219
		if (fobList==null || fobList.equals(""))
		{
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate();
			pstmt1.close();

			//FOB list
			sql = "select distinct a.FOB_CODE from OE_FOBS_ACTIVE_V a ";
			Statement statet=con.createStatement();
			ResultSet rst=statet.executeQuery(sql);
			while (rst.next())
			{
				fobList += (";"+rst.getString("FOB_CODE"));
			}
			if (fobList.length()>0) fobList += ";";
			rst.close();
			statet.close();

			String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";
			PreparedStatement pstmt2=con.prepareStatement(sql2);
			pstmt2.executeUpdate();
			pstmt2.close();

		}
//add by Peggy 20150515
		if ((customerName.equals("") || customerNo.equals("")) && !customerId.equals(""))
		{
			String sqlx = " select customer_number,customer_name from ar_customers "+
					" where customer_id='"+customerId+"'";
			Statement statementx=con.createStatement();
			ResultSet rsx=statementx.executeQuery(sqlx);
			if (rsx.next())
			{
				customerName = rsx.getString("customer_name");
				customerNo = rsx.getString("customer_number");
			}
			rsx.close();
			statementx.close();

		}

		if (ShipToOrg.equals("") && !customerId.equals(""))
		{

			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate();
			pstmt1.close();

			//add by Peggy 20120224
			CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
			cs1.setString(1,parOrgID);  // 取業務員隸屬ParOrgID
			cs1.execute();
			cs1.close();
			Statement statementa=con.createStatement();
			ResultSet rsa=null;
			String sqla = //" select case when upper(a.site_use_code)='BILL_TO' then 1 else 2 end as segno,"+ //add by Peggy 20120914
					" select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,"+ //fob 先依ship_to為主,若無,再依deliver_to為主,modify by Peggy 20121026
							" a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+
							" a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,d.CURRENCY_CODE"+
							",a.tax_code" + //add by Peggy 20140312
							" from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c,SO_PRICE_LISTS d"+
							" where  a.ADDRESS_ID = b.cust_acct_site_id"+
							" AND b.party_site_id = party_site.party_site_id"+
							" AND loc.location_id = party_site.location_id "+
							" and a.STATUS='A' "+
							" and b.CUST_ACCOUNT_ID ='"+customerId+"'"+
							" and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
							" and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)";
			//add by peggy 20180726
			if (def_ship_org_id.equals(""))
			{
				sqla += " and a.PRIMARY_FLAG='Y'";
			}
			else
			{
				if (def_ship_org_id.equals("55839"))
				{
					sqla+= " and ((a.SITE_USE_ID in ('"+def_ship_org_id+"','55838')) or (a.SITE_USE_CODE NOT IN ('SHIP_TO','DELIVER_TO') and a.PRIMARY_FLAG='Y'))";
				}
				else if (def_ship_org_id.equals("58239")) //add by Peggy 20190114
				{
					sqla+= " and ((a.SITE_USE_ID in ('"+def_ship_org_id+"','58238')) or (a.SITE_USE_CODE NOT IN ('SHIP_TO','DELIVER_TO') and a.PRIMARY_FLAG='Y'))";
				}
				//else if (def_ship_org_id.equals("43598")) //add by Peggy 20190116
				//{
				//	sqla+= " and ((a.SITE_USE_ID in ('"+def_ship_org_id+"','43599')) or (a.SITE_USE_CODE NOT IN ('SHIP_TO','DELIVER_TO') and a.PRIMARY_FLAG='Y'))";
				//}
				else if (def_ship_org_id.equals("40434")) //add by Peggy 20190108
				{
					sqla+= " and ((a.SITE_USE_ID in ('"+def_ship_org_id+"','19974')) or (a.SITE_USE_CODE NOT IN ('SHIP_TO','DELIVER_TO') and a.PRIMARY_FLAG='Y'))";
				}
				else
				{
					sqla+= " and ((a.SITE_USE_CODE='SHIP_TO' and a.SITE_USE_ID='"+def_ship_org_id+"') or (a.SITE_USE_CODE<>'SHIP_TO' and a.PRIMARY_FLAG='Y'))";
				}
			}
			if (salesAreaNo.equals("009") || salesAreaNo.equals("002") || salesAreaNo.equals("005") || salesAreaNo.equals("008") || salesAreaNo.equals("018")) //add 018 by Mars 20250425 ,for cust price issue
			{
				sqla +=" order by case when upper(a.site_use_code)='SHIP_TO' then 1 when upper(a.site_use_code)='BILL_TO' then 2 else 3 end";
			}
			else
			{
				sqla +=" order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end";
			}
			//out.println(sqla);
			rsa=statementa.executeQuery(sqla);
			while (rsa.next())
			{
				if (rsa.getString("SITE_USE_CODE").equals("SHIP_TO"))
				{
					ShipToOrg =rsa.getString("SITE_USE_ID");
					shipAddress = rsa.getString("ADDRESS1");
					shipCountry = rsa.getString("COUNTRY");

					if (!salesAreaNo.equals("001"))
					{
						if (payTermID == null || payTermID.equals(""))
						{
							payTermID = rsa.getString("PAYMENT_TERM_ID");
							paymentTerm = rsa.getString("PAYMENT_TERM_NAME");
						}
						//if (fobPoint== null || fobPoint.equals("") || salesAreaNo.equals("001") || ShipToOrg.equals("58239") || ShipToOrg.equals("43598"))
						if (fobPoint== null || fobPoint.equals("") || salesAreaNo.equals("001") || ShipToOrg.equals("58239") )
						{
							fobPoint = rsa.getString("FOB_POINT");
						}
						if (firmPriceList == null || firmPriceList.equals(""))
						{
							firmPriceList = rsa.getString("PRICE_LIST_ID");
							if (ORIGPRICELIST==null || ORIGPRICELIST.equals(""))  //add by Peggy 20140310
							{
								ORIGPRICELIST= rsa.getString("PRICE_LIST_ID");
							}
						}
						if (curr ==null || curr.equals(""))
						{
							curr = rsa.getString("CURRENCY_CODE");
							if (ORIGCURR==null || ORIGCURR.equals(""))  //add by Peggy 20140310
							{
								ORIGCURR= rsa.getString("CURRENCY_CODE");
							}
						}
					}
					//if (ship_via==null || ship_via.equals("") || ShipToOrg.equals("58239") || ShipToOrg.equals("43598"))
					if (ship_via==null || ship_via.equals("") || ShipToOrg.equals("58239"))
					{
						ship_via = rsa.getString("ship_via");
					}
				}
				else if (rsa.getString("SITE_USE_CODE").equals("BILL_TO"))
				{
					billTo = rsa.getString("SITE_USE_ID");
					billAddress = rsa.getString("ADDRESS1");
					billCountry = rsa.getString("COUNTRY");
					if (salesAreaNo.equals("001"))
					{
						curr = rsa.getString("CURRENCY_CODE");
						if (ORIGCURR==null || ORIGCURR.equals(""))  //add by Peggy 20140310
						{
							ORIGCURR= rsa.getString("CURRENCY_CODE");
						}
						payTermID = rsa.getString("PAYMENT_TERM_ID");
						paymentTerm = rsa.getString("PAYMENT_TERM_NAME");
						firmPriceList = rsa.getString("PRICE_LIST_ID");
						if (ORIGPRICELIST==null || ORIGPRICELIST.equals(""))  //add by Peggy 20140310
						{
							ORIGPRICELIST= rsa.getString("PRICE_LIST_ID");
						}
					}
					else
					{
						if (payTermID == null || payTermID.equals(""))
						{
							payTermID = rsa.getString("PAYMENT_TERM_ID");
							paymentTerm = rsa.getString("PAYMENT_TERM_NAME");
						}
						if (fobPoint == null || fobPoint.equals(""))
						{
							fobPoint = rsa.getString("FOB_POINT");
						}
						if (firmPriceList == null || firmPriceList.equals(""))
						{
							firmPriceList = rsa.getString("PRICE_LIST_ID");
							if (ORIGPRICELIST==null || ORIGPRICELIST.equals("")) //add by Peggy 20140310
							{
								ORIGPRICELIST= rsa.getString("PRICE_LIST_ID");
							}
						}
						if (ship_via==null || ship_via.equals(""))
						{
							ship_via = rsa.getString("ship_via");
						}
						if (curr ==null || curr.equals(""))
						{
							curr = rsa.getString("CURRENCY_CODE");
							if (ORIGCURR==null || ORIGCURR.equals(""))  //add by Peggy 20140310
							{
								ORIGCURR= rsa.getString("CURRENCY_CODE");
							}
						}
					}
				}
				else if (rsa.getString("SITE_USE_CODE").equals("DELIVER_TO"))
				{
					deliveryTo = rsa.getString("SITE_USE_ID");
					deliveryAddress = rsa.getString("ADDRESS1");
					deliveryCountry = rsa.getString("COUNTRY");
					if (salesAreaNo.equals("001"))
					{
						fobPoint = rsa.getString("FOB_POINT");
						taxcode = rsa.getString("TAX_CODE");
					}
					else
					{
						if (fobPoint==null || fobPoint.equals(""))
						{
							fobPoint = rsa.getString("FOB_POINT");
						}
						if (taxcode ==null || taxcode.equals("")) taxcode = rsa.getString("TAX_CODE");   //add by Peggy 20140312
					}
				}
			}
			rsa.close();
			statementa.close();

			//add by Peggy 20130222
			if (!salesAreaNo.equals("021") && !salesAreaNo.equals("022") && !salesAreaNo.equals("012") && !salesAreaNo.equals("009") && !salesAreaNo.equals("006")) //add 009 by Peggy 20141212
			{
				Statement statementx=con.createStatement();
				String sqlx = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
						" from ar_contacts_v con,hz_cust_site_uses su,HZ_CUST_SITE_USES_ALL hcsu "+
						" where  con.customer_id ='"+customerId+"'"+
						" and con.status='A'"+
						" AND con.address_id=su.cust_acct_site_id"+
						" AND su.site_use_code='SHIP_TO'"+
						" AND hcsu.CUST_ACCT_SITE_ID =con.address_id(+)"+
						" AND hcsu.SITE_USE_ID='"+ShipToOrg+"'";
				if (shipToContactid  != null && shipToContactid !="")
				{
					sqlx += " and con.contact_id ='" +shipToContactid +"'";
				}
				sqlx += " ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'"+customerId+"',1,2)";
				//out.println(sqlx);
				ResultSet rsx=statementx.executeQuery(sqlx);
				if (rsx.next())
				{
					shipToContact = rsx.getString("contact_name");
					shipToContactid = rsx.getString("contact_id");
				}
				else
				{
					if (!salesAreaNo.equals("004"))
					{
						Statement statementy=con.createStatement();
						sqlx = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
								" from ar_contacts_v con,hz_cust_site_uses su "+
								" where  con.customer_id ='"+customerId+"'"+
								" and con.status='A'"+
								" AND con.address_id=su.cust_acct_site_id"+
								" AND su.site_use_code='SHIP_TO'";
						//if (UserName.equals("COCO") || (shipToContactid != null && shipToContactid !=""))
						if (salesAreaNo.equals("018") || (shipToContactid != null && shipToContactid !=""))  //modify by Peggy 20171221
						{
							sqlx += " and con.contact_id ='" +shipToContactid +"'";
						}
						sqlx += " ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'"+customerId+"',1,2)";
						//out.println(sqlx);
						ResultSet rsy=statementy.executeQuery(sqlx);
						if (rsy.next())
						{
							shipToContact = rsy.getString("contact_name");
							shipToContactid= rsy.getString("contact_id");
						}
						rsy.close();
						statementy.close();
					}
				}
				rsx.close();
				statementx.close();
			}
		}

//add by Peggy 20160302
		if (shipto!=null && !shipto.equals(""))
		{
			Statement statementa=con.createStatement();
			String sqla = " select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+
					" a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,d.CURRENCY_CODE"+
					",a.tax_code" +
					" from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c,SO_PRICE_LISTS d"+
					" where  a.ADDRESS_ID = b.cust_acct_site_id"+
					" AND b.party_site_id = party_site.party_site_id"+
					" AND loc.location_id = party_site.location_id "+
					" and a.STATUS='A' "+
					" and b.CUST_ACCOUNT_ID ='"+customerId+"'"+
					" and a.SITE_USE_ID='"+shipto+"'"+
					" and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
					" and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)";
			//out.println(sqla);
			ResultSet rsa=statementa.executeQuery(sqla);
			if (rsa.next())
			{
				ShipToOrg =rsa.getString("SITE_USE_ID");
				shipAddress = rsa.getString("ADDRESS1");
				shipCountry = rsa.getString("COUNTRY");
				if (salesAreaNo.equals("005")) fobPoint=rsa.getString("FOB_POINT");
			}
			rsa.close();
			statementa.close();

			//add by Peggy 20221018
			if (!salesAreaNo.equals("021") && !salesAreaNo.equals("022") && !salesAreaNo.equals("012") && !salesAreaNo.equals("009") && !salesAreaNo.equals("006")) //add 009 by Peggy 20141212
			{
				Statement statementx=con.createStatement();
				String sqlx = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
						" from ar_contacts_v con,hz_cust_site_uses su,HZ_CUST_SITE_USES_ALL hcsu "+
						" where  con.customer_id ='"+customerId+"'"+
						" and con.status='A'"+
						" AND con.address_id=su.cust_acct_site_id"+
						" AND su.site_use_code='SHIP_TO'"+
						" AND hcsu.CUST_ACCT_SITE_ID =con.address_id(+)"+
						" AND hcsu.SITE_USE_ID='"+ShipToOrg+"'";
				sqlx += " ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'"+customerId+"',1,2)";
				//out.println(sqlx);
				ResultSet rsx=statementx.executeQuery(sqlx);
				if (rsx.next())
				{
					shipToContact = rsx.getString("contact_name");
					shipToContactid = rsx.getString("contact_id");
				}
			}
		}
	%>
</head>
<body>
<FORM ACTION="TSSalesDRQ_Create.jsp" METHOD="post" NAME="MYFORM">
	<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font  color="#000099" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman">
	<strong><jsp:getProperty name="rPH" property="pgSalesDRQ"/></strong></font>
	<BR>
	<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHome"/></A>&nbsp;&nbsp;&nbsp;<img src="../image/point.gif"><font color="#FF6600"><jsp:getProperty name="rPH" property="pgNoBlankMsg"/></font>
	<%
		if (preSeqNo==null || preSeqNo.equals(""))
		{
		}
		else if (preSeqNo !=null && !preSeqNo.equals(""))
		{
	%>
	<font color="#330099"><a href="TSSalesDRQDisplayPage.jsp?DNDOCNO=<%=preSeqNo%>" id="myLINK"><jsp:getProperty name="rPH" property="pgPrevious"/>
		<jsp:getProperty name="rPH" property="pgQDocNo"/></a></font><%out.println(":<font color='#FF0000'><strong>"+preSeqNo+"</strong></font>"); %>
	<%
		}
	%>
	<input type="hidden" size="1" name="CUSTOMERAROVERDUE" style="border:0 solid #CC0066" value=<%=custAROverdue%>>&nbsp;&nbsp;&nbsp;
	<font color="#FF0000"><input type="text" size="30" name="AROVERDUEDESC" class="gogo" readonly></font>
	<%
		if (custAROverdue=="Y" || custAROverdue.equals("Y") )
		{
			out.println("&nbsp;&nbsp;&nbsp;<font color='#FF0000'>");
			out.println("Customer AR Overdue 90 days !!");
			out.println("</font>");
		}
		else
		{
			out.println(" ");
		}
	%>
	<table cellSpacing="1" bordercolordark="#66CC99"  cellPadding="1" width="100%" align="center"  border="1" bordercolor="#66CC99">
		<tr bgcolor="#CCFFCC">
			<td width="100%" style="font-size:12px;font-family:Tahoma,Georgia;"><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><strong><jsp:getProperty name="rPH" property="pgQDocNo"/></strong></font><font face="Arial" color="#003366"><span class="style1">&nbsp;</span><strong><%=docNo%></strong></font></td>
		</tr>
	</table>

	<table cellSpacing="1" bordercolordark="#66CC99" cellPadding="1" width="100%" align="center" bordercolor="#66CC99" border="1">
		<%
			if (salesAreaNo=="020" || salesAreaNo.equals("020") || salesAreaNo=="021" || salesAreaNo.equals("021") || salesAreaNo=="022" || salesAreaNo.equals("022"))  //sample area 才顯示,其餘不允許勾訂單  20110222 liling for cy issue
			{
		%>
		<tr bgcolor="#CCFFCC">
			<td width="15%"><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgSampleOrderCh"/></font><font face="Arial" color="#003366"><span class="style1">&nbsp;</span><strong></strong></font></td>
			<td colspan="5"><font face="Arial" color="#3366FF"><input name="SAMPLEORDER" type="checkbox"
				<%
			if (sampleOrder.equals("on"))
			{
				out.print("checked");
				//add by Peggy 20120413
				if (rfqTypeNormal.equals("") && rfqTypeForecast.equals(""))
				{
					rfqTypeNormal="checked";
				}
			}
			%>
																	  onClick='setSubmit5("../jsp/TSSalesDRQ_Create.jsp","<%=sampleOrder%>","<%=inpLen%>")' style="vertical-align:middle " ></font><font face="Arial" color="#FF6600"><jsp:getProperty name="rPH" property="pgSetSampleOrder"/></font>
				&nbsp;&nbsp;
				<%
					if (sampleOrder.equals("on"))
					{
						try
						{
							String orderbyType = "  ";
							String whereOType="";
							Statement statement=con.createStatement();
							ResultSet rs=null;
							String sqlOrgInf = " select CHARGE_CODE, CHARGE_NAME "+
									" from ORADDMAN.TSCHARGE_DEF "+
									" where CHARGE_TYPE ='01'"+
									" and CHARGE_CODE ='"+sampleCharge+"' "; //modify by Peggy 20150715
							//20110107 LILING
							//String whereOType = " where CHARGE_TYPE ='01' ";
							//if (salesAreaNo=="020" || salesAreaNo.equals("020") || salesAreaNo=="021" || salesAreaNo.equals("021") || salesAreaNo=="022" || salesAreaNo.equals("022"))
							//{
							//	whereOType = " where CHARGE_TYPE ='01' and CHARGE_CODE ='N' ";
							//}
							//else
							//{
							//	whereOType = " where CHARGE_TYPE ='01' and CHARGE_CODE ='Y' ";
							//}

							sqlOrgInf = sqlOrgInf + whereOType;
							//out.println(sqlOrgInf);
							rs=statement.executeQuery(sqlOrgInf);
							comboBoxBean.setRs(rs);
							comboBoxBean.setSelection(sampleCharge);
							comboBoxBean.setFieldName("SAMPLECHARGE");
							out.println(comboBoxBean.getRsString());

							rs.close();
							statement.close();
						} //end of try
						catch (Exception e)
						{
							out.println("Exception3:"+e.getMessage());
						}
				%>
				<!-- 2009/03/23 liling disable
             &nbsp;&nbsp;<input name="SPQCHECK" type="checkbox"  style="vertical-align:middle " ><font face="Arial" color="#FF6600">Don't Check SPQ</font>
-->
				<%
					}
				%>
			</td>
		</tr>
		<%
		}	//end area=020	 //20110222 liling
		else
		{
		%>
		<input type="hidden" name="SAMPLEORDER" value="<%=sampleOrder%>">
		<Script type="text/javascript">
			document.MYFORM.SAMPLEORDER.disabled = true;
		</Script>
		<%
			}   //20110222 liling
		%>
		<tr bgcolor="#CCFFCC">
			<td width="12%" ><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgSalesArea"/></font><img src="../image/point.gif"></td>
			<td width="15%">
				<%
					try
					{
						//20101222 LILING 卡CRD 要大於開單日7日____起
						//Statement stateAD=con.createStatement();
						//ResultSet rsAD=stateAD.executeQuery(" SELECT to_char(SYSDATE+7,'yyyymmdd') ALLOWCRD FROM DUAL ");
						//if (rsAD.next())
						//{
						//	allowCRD =  rsAD.getString(1);
						//}
						//rsAD.close();
						//stateAD.close();

						//20101222 LILING 卡CRD 要大於開單日7日____迄
						//out.println("UserRegionSet="+UserRegionSet);
						Statement statement=con.createStatement();
						ResultSet rs=null;
						sql = "select SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA ";
						String sWhere = "where SALES_AREA_NO > 0 ";
						String sOrder = "Order by 1";
						if (UserRoles=="admin" || UserRoles.equals("admin"))
						{
						}  // 若為管理員,可開立任何一區詢問單
						//else {  sWhere = sWhere + "and SALES_AREA_NO='"+userActCenterNo+"' ";}  // 否則,就只能開立所屬區域單
						else
						{
							//modify by Peggy 20130516
							sWhere += " and SALES_AREA_NO in (select tssaleareano from oraddman.tsrecperson "+
									" where USERNAME='"+UserName+"')";
							//if (UserRegionSet==null || UserRegionSet.equals(""))
							//{
							//	sWhere = sWhere + "and SALES_AREA_NO='"+userActCenterNo+"' "; // 若是空的地區集,則以主要的業務區
							//}
							//else
							//{
							//	sWhere = sWhere + "and SALES_AREA_NO in ("+UserRegionSet+") ";
							//}
						}  // 否則,就只能開立所屬區域單
						sql = sql + sWhere + sOrder;
						//out.println(sql);
						//out.println(UserGroupSet);
						rs=statement.executeQuery(sql);
			/*
			comboBoxBean.setRs(rs);
			if (salesAreaNo==null)
		    { comboBoxBean.setSelection(userActCenterNo); }
			else { comboBoxBean.setSelection(salesAreaNo); }
	        comboBoxBean.setFieldName("SALESAREANO");
            out.println(comboBoxBean.getRsString());
			*/
						out.println("<select NAME='SALESAREANO' tabindex='"+(tabidx++)+"' class='style1' onChange='setSubmit3("+'"'+"../jsp/TSSalesDRQ_Create.jsp?INSERT=Y"+'"'+")'>");
						out.println("<OPTION VALUE=-->--");
						while (rs.next())
						{
							String s1=(String)rs.getString(1);
							String s2=(String)rs.getString(2);
							//if (s1.equals(salesAreaNo) || s1.equals(userActCenterNo))
							if (s1.equals(salesAreaNo))
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
							}
							else
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}
						} //end of while
						out.println("</select>");
						rs.close();
						statement.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception4:"+e.getMessage());
					}
				%>
			</td>
			<td width="15%"><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCreateFormDate"/></font></td>
			<td width="12%" bgColor="#ffffff">
				<input name="RECEPTDATE" tabindex="<%=(tabidx++)%>" type="text" size="8" value="<%=receptDate%>" class="style1" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
			</td>
			<td width="12%"><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCreateFormUser"/></font></td>
			<td width="34%" bgColor="#ffffff" nowrap>
				<font color='#000000'><%out.println(userID+"("+UserName+")"); salesPersonID = userID; %></font>
			</td>
		</tr>
		<tr bgcolor="#CCFFCC">
			<td height="22"><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgPreOrderType"/></font><img src="../image/point.gif"></td>
			<td><font face="Arial">
				<%
					try
					{
						Statement statement=con.createStatement();
						ResultSet rs=null;
						String sqlOrgInf = "select DISTINCT OTYPE_ID, ORDER_NUM||'('||DESCRIPTION||')' as TRANSACTION_TYPE_CODE "+
								"from ORADDMAN.TSAREA_ORDERCLS ";
						String whereOType = "where  ACTIVE ='Y'  ";
						String orderbyType = "order by 2 ";

						if (UserRoles=="admin" || UserRoles.equals("admin"))
						{
						}  // 若為管理員,可開立任何一訂單類型詢問單
						//else {  whereOType = whereOType + "and SAREA_NO = '"+userActCenterNo+"' and PAR_ORG_ID = '"+userParOrgID+"' "; }  // 否則,就只能開立所屬區域單
						else
						{  // 2006/12/25 山東廠上線,導入大陸內銷區,一個使用者可隸屬多個業務地區
							if (salesAreaNo !="")  //add by Peggy 20120517
							{
								whereOType = whereOType + "and SAREA_NO = '"+salesAreaNo+"'";
							}
							else
							{
								if (UserRegionSet==null || UserRegionSet.equals(""))
								{  // 未取到業務地區集,則以主要的業務區
									whereOType = whereOType + "and SAREA_NO = '"+userActCenterNo+"' and PAR_ORG_ID = '"+parOrgID+"' ";
								}
								else
								{
									whereOType = whereOType + "and SAREA_NO in ("+UserRegionSet+") and PAR_ORG_ID = '"+parOrgID+"' ";
								}
							}
						}  // 否則,就只能開立所屬區域單
						// 2006/05/30 加入若選樣品訂單,則只挑出樣品訂單類型供選擇
						if ( sampleOrder==null || sampleOrder.equals(""))
						{
							whereOType = whereOType + "and ORDER_NUM not in ('1121','1122','4121') ";
						}
						else
						{
							//  whereOType = whereOType + "and ORDER_NUM = '1121' ";
							whereOType = whereOType ;
							//preOrderType = "1015"; // 且預設選出類型即為樣品訂單
						}
						sqlOrgInf = sqlOrgInf + whereOType+orderbyType;
						//out.println(sqlOrgInf);
						rs=statement.executeQuery(sqlOrgInf);
						//comboBoxBean.setRs(rs);
						//comboBoxBean.setSelection(preOrderType);
						//comboBoxBean.setFieldName("PREORDERTYPE");
						//out.println(comboBoxBean.getRsString());
						out.println("<select NAME='PREORDERTYPE' tabindex='"+(tabidx++)+"' class='style1' onChange='setValue();'>");
						out.println("<OPTION VALUE=-->--");
						while (rs.next())
						{
							String s1=(String)rs.getString(1);
							String s2=(String)rs.getString(2);
							if (s1.equals(preOrderType))
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
							}
							else
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}
						} //end of while
						out.println("</select>");
						rs.close();
						statement.close();

					} //end of try
					catch (Exception e)
					{
						out.println("Exception5:"+e.getMessage());
					}
				%>
			</font>
			</td>
			<td><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCustPONo"/><img src="../image/point.gif"></font></td>
			<td colspan="1"><input size="30" name="CUSTOMERPO" tabindex="<%=(tabidx++)%>" value="<%=customerPO%>"  onKeyUp="setLineCustPO();"  onBlur="setPOObject(this.form.SALESAREANO.value,this.form.CUSTOMERPO.value)" class="style1"></td>
			<td><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCurr"/></font></td>
			<td colspan="1"><input size="40" name="CURR" tabindex="<%=(tabidx++)%>" value="<%=curr%>"  class="style1" ><input type="hidden" name="ORIGCURR" value="<%=ORIGCURR%>"></td>
		</tr>
		<tr bgcolor="#CCFFCC">
			<td height="22"><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCustomerName"/></font><img src="../image/point.gif"></td>
			<td colspan="3"><font face="Arial">
				<input type="text" size="10" name="CUSTOMERNO" tabindex="<%=(tabidx++)%>"  class="style1" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.PARORGID.value,this.form.SALESAREANO.value)' value="<%=customerNo%>">
				<input name="button3" type="button" tabindex="<%=(tabidx++)%>"  class="style1" onClick='setCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.PARORGID.value,this.form.SALESAREANO.value)' value="..">
				<input type="text" size="80" name="CUSTOMERNAME" tabindex="<%=(tabidx++)%>"  class="style1" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.PARORGID.value,this.form.SALESAREANO.value)' value="<%=customerName%>"> </font>
				<input type="hidden" name="SALES_GROUP_ID" value="<%=SALES_GROUP_ID%>">
			</td>
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgSalesMan"/></font>
			</td>
			<td width="16%" bgColor="#ffffff"><font color='#000000'><%if (salesPerson=="") out.println("&nbsp;"); else out.println(salesPerson); %></font>
			</td>
		</tr>
		<!--add by Peggy 20120215-->
		<tr bgcolor="#CCFFCC">
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1"></span>&nbsp;<jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></font>
			</td>
			<td colspan="3"><font face="Arial">
				<input type="text" size="10" name="SHIPTOORG" tabindex="<%=(tabidx++)%>"  class="style1"  value="<%=ShipToOrg%>">
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>"  value=".."  class="style1" onClick='subWindowShipToFind("SHIP_TO",this.form.CUSTOMERID.value,this.form.SHIPTOORG.value,this.form.SALESAREANO.value,this.form.SHIPADDRESS.value)'>
				<INPUT TYPE="text" NAME="SHIPADDRESS" SIZE=80 value="<%=shipAddress%>"  class="style1" >
				<INPUT TYPE="text" NAME="SHIPCOUNTRY" SIZE=3 value="<%=shipCountry%>"  class="style1" readonly> </font>
				<INPUT TYPE="hidden" NAME="SHIPVIA" value="<%=ship_via%>"  class="style1"  readonly> </font>
			</td>
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgPaymentTerm"/></font>
			</td>
			<td>
				<input type="text" size="35" name="PAYTERM"  value="<%=paymentTerm%>"  class="style1"  readonly >
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value=".."  class="style1"  onClick='subWindowPayTermFind(this.form.PAYTERMID.value)'>
				<input type="hidden" size="10" name="PAYTERMID" value="<%=payTermID%>"  class="style1" >
			</td>
		</tr>
		<!--add by Peggy 20120215-->
		<tr bgcolor="#CCFFCC">
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1"></span>&nbsp;<jsp:getProperty name="rPH" property="pgBillTo"/></font></td>
			<td colspan="3"><font face="Arial">
				<input type="text" size="10" name="BILLTO" tabindex="<%=(tabidx++)%>" value="<%=billTo%>"  class="style1"  >
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>"  value=".."  class="style1"  onClick='subWindowShipToFind("BILL_TO",this.form.CUSTOMERID.value,this.form.BILLTO.value,this.form.SALESAREANO.value,this.form.BILLADDRESS.value)'>
				<INPUT TYPE="text" NAME="BILLADDRESS" SIZE=80 value="<%=billAddress%>"  class="style1" >
				<INPUT TYPE="text" NAME="BILLCOUNTRY" SIZE=3 value="<%=billCountry%>"  class="style1" readonly> </font>
			</td>
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgFOB"/></font>
			</td>
			<td>
				<input type="text" size="35" name="FOBPOINT" value="<%=fobPoint%>"  class="style1" readonly>
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value=".."  class="style1" onClick='subWindowFOBPointFind(this.form.FOBPOINT.value,"HEADER")'>
			</td>
		</tr>
		<!-- add by Peggy 20130218-->
		<tr bgcolor="#CCFFCC">
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1"></span>&nbsp;<jsp:getProperty name="rPH" property="pgDeliverTo"/></font></td>
			<td colspan="3"><font face="Arial">
				<input type="text" size="10" name="DELIVERYTO" tabindex="<%=(tabidx++)%>" value="<%=deliveryTo%>"  class="style1" >
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>"  value=".."  class="style1" onClick='subWindowShipToFind("DELIVER_TO",this.form.CUSTOMERID.value,this.form.DELIVERYTO.value,this.form.SALESAREANO.value,this.form.DELIVERYADDRESS.value)'>
				<INPUT TYPE="text" NAME="DELIVERYADDRESS" SIZE=80  class="style1" value="<%=deliveryAddress%>">
				<INPUT TYPE="text" NAME="DELIVERYCOUNTRY" SIZE=3  class="style1" value="<%=deliveryCountry%>" readonly></font>
			</td>
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span>Ship To Contact</font></td>
			<td>
				<input type="text" size="35" name="SHIPTOCONTACT"  class="style1" value="<%=shipToContact%>">
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>"  class="style1" value=".." onClick='subWindowShipToContactFind()'>
				<input type="hidden" size="35" name="SHIPTOCONTACTID"  class="style1" value="<%=shipToContactid%>" readonly>
			</td>
		</tr>
		<tr bgcolor="#CCFFCC">
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgRequireReason"/></font>
			</td>
			<td bgColor="#ffffff"><font face="Arial"><input name="REQUIREREASON" tabindex="<%=(tabidx++)%>" type="text" size="50"  class="style1" value="<%=requireReason%>" maxlength="60">
			</td>
			<td nowrap><font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgPriceList"/></font>
			</td>
			<td>
				<%
					try
					{
						CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
						cs1.setString(1,parOrgID);  // 取業務員隸屬ParOrgID
						cs1.execute();
						cs1.close();

						String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
						PreparedStatement pstmt1=con.prepareStatement(sql1);
						pstmt1.executeUpdate();
						pstmt1.close();

						Statement statement=con.createStatement();
						ResultSet rs=null;
						sql = " select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE, CURRENCY_CODE "+
								//" from qp_secu_list_headers_v "+
								" from qp_list_headers_v "+ //因價格表改為 User 權限 , 取消所有 OU 權限,故改用qp_list_headers_v by Peggy 20150625
								" where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' "+
								"  AND (ORIG_ORG_ID ="+parOrgID+" or ORIG_ORG_ID IS NULL ) ";
						rs=statement.executeQuery(sql);
						out.println("<select NAME='FIRMPRICELIST' tabindex='"+(tabidx++)+"' class='style2' >");
						out.println("<OPTION VALUE=-->--");
						while (rs.next())
						{
							String s1=(String)rs.getString(1);
							String s2=(String)rs.getString(2);
							String s3=(String)rs.getString(3);
							if (s1==firmPriceList || s1.equals(firmPriceList))
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
							}
							else
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}
						}
						out.println("</select>");
						statement.close();
						rs.close();
					}
					catch (Exception e)
					{
						out.println("Exception3:"+e.getMessage());
					}
				%>
				<input type="hidden" name="ORIGPRICELIST" value="<%=ORIGPRICELIST%>"><!--add by Peggy 20130909-->
			</td>
			<td>
				<font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgRFQType"/></font>
			</td>
			<td><font face="Arial" color="#3366FF"><span class="style1">
			<%
				v_normal_inactive_flag="";
				if (salesAreaNo.equals("002") || salesAreaNo.equals("012") || salesAreaNo.equals("023"))
				{
					if (!UserName.equals("TSCC JOYCE") && !UserName.equals("SU CS-001") && !UserName.equals("SU SALES-001") && !UserName.equals("SH SALES-011")  && !UserName.equals("SH CS-011"))
					{
						v_normal_inactive_flag="disabled";
					}
				}
			%>
		   <input type="radio" name="rfqtype" value="NORMAL" <%=rfqTypeNormal%> <%=v_normal_inactive_flag%>>NORMAL
		   &nbsp;&nbsp;&nbsp;&nbsp;
		   <input type="radio" name="rfqtype" value="FORECAST" <%=rfqTypeForecast%>>FORECAST</span></font>
			</td>
		</tr>
		<tr bgcolor="#CCFFCC">
			<td>
				<font face="Arial" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgRemark"/></font>
			</td>
			<td>
				<input name="REMARK" tabindex="<%=(tabidx++)%>" type="text" size="50" value="<%=remark%>" maxlength="80"  class="style1" >
			</td>
			<td>
				<font face="Arial" color="#3366FF">Supplier</font><br>
				<font face="Arial" color="#3366FF" style="visibility:hidden">Number</font>
			</td>
			<td>
				<%
					try
					{
						Statement statement=con.createStatement();
						ResultSet rs=null;
						sql = " select A_VALUE,A_VALUE"+
								" from oraddman.tsc_rfq_setup a "+
								" where A_CODE='TSCE_SUPPLIER_NUMBER'"+
								" ORDER BY A_SEQ ";
						rs=statement.executeQuery(sql);
						out.println("<select NAME='SUPPLIER_NUMBER' tabindex='"+(tabidx++)+"' style='font-family:Tahoma,Georgia;font-size:10px;"+ (!salesAreaNo.equals("001")?";visibility:hidden":"")+"'>");
						out.println("<OPTION VALUE=>");
						while (rs.next())
						{
							if (rs.getString(1).equals(SUPPLIER_NUMBER))
							{
								out.println("<OPTION VALUE='"+rs.getString(1)+"' SELECTED>"+rs.getString(2));
							}
							else
							{
								out.println("<OPTION VALUE='"+rs.getString(1)+"'>"+rs.getString(2));
							}
						}
						out.println("</select>");
						statement.close();
						rs.close();
					}
					catch (Exception e)
					{
						out.println("Exception3:"+e.getMessage());
					}
				%>
				<input type="hidden" name="SUPPLIER_FLAG" value="<%=SUPPLIER_FLAG%>">
			</td>
			<td>
				<font face="Arial" color="#3366FF">Tax Code</font>
			</td>
			<td>
				<input name="TAXCODE" tabindex="<%=(tabidx++)%>" type="text" size="20" value="<%=(taxcode==null?"":taxcode)%>" onKeyDown="return (event.keyCode!=8);"  class="style1" readonly>
				<INPUT TYPE="button"  value="..." onClick='subWindowTaxCodeFind()'>
			</td>
		</tr>
	</table>
	<table cellSpacing="1" bordercolordark="#66CC99"cellPadding="1" width="102%" align="center" bordercolor="#66CC99" border="1">
		<tr bgcolor="#CCFFCC">
			<!--td width="3%"><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgAnItem"/></font></div></td-->
			<%
				if(salesAreaNo.equals("001"))  //add by Peggy 20130628
				{
			%>
			<!-- add by Peggy 20120215-->
			<td width="22%" colspan="1">
				<div align="center">
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgCustItemNo"/>
						<jsp:getProperty name="rPH" property="pgDesc"/></font>
				</div>
			</td>
			<%
				}
			%>
			<td width="21%">
				<div align="center"><font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgTSCAlias"/>
					<jsp:getProperty name="rPH" property="pgOrderedItem"/></font><img src="../image/point.gif">
				</div>
			</td>
			<td width="11%">
				<div align="center">
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgOrderedItem"/>
						<jsp:getProperty name="rPH" property="pgDesc"/></font><img src="../image/point.gif">
				</div>
			</td>
			<td width="7%">
				<div align="center"><font face="Arial" color="#3366FF">Plant</font>
				</div>
			</td>
			<td width="17%" colspan="1">
				<div align="center">
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgQty"/>
						<img src="../image/point.gif"><jsp:getProperty name="rPH" property="pgUOM"/>:</font><font color="#FF0000">
					<jsp:getProperty name="rPH" property="pgKPC"/></font></div>
			</td>
			<%
				if(!salesAreaNo.equals("001"))  //add by Peggy 20130628
				{
			%>
			<!-- add by Peggy 20120215-->
			<td width="22%" colspan="1">
				<div align="center">
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgCustItemNo"/>
						<jsp:getProperty name="rPH" property="pgDesc"/></font>
				</div>
			</td>
			<%
				}
			%>
			<!-- add by Peggy 20120215-->
			<td>
				<div align="center">
					<font face="Arial" color="#3366FF">Selling<br>Price</font></div>
			</td>
			<%
				if (computeSSD.equals("Y") || computeSSD.equals("X")) //顯示CRD
				{
			%>
			<td colspan="1">
				<div align="center"><font face="Arial" color="#3366FF">
					<jsp:getProperty name="rPH" property="pgCRDate"/><BR>(CRD)
				</font></div>
			</td>
			<%
				}
				if (computeSSD.equals("Y") || computeSSD.equals("S") || computeSSD.equals("X")) //顯示SHIPPINGMETHOD,modify by Peggy 20120209
				{
			%>
			<td colspan="1">
				<div align="center"><font face="Arial" color="#3366FF">
					<jsp:getProperty name="rPH" property="pgShippingMethod"/>
					<img src="../image/point.gif">
				</font></div>
			</td>
			<%
				}
			%>
			<td width="10%" colspan="1">
				<div align="center">
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgDeliveryDate"/></font>
					<img src="../image/point.gif"></div>
			</td>
			<!--add by Peggy 20120215-->
			<td>
				<div align="center">
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgFirmOrderType"/>
						<img src="../image/point.gif">
					</font></div>
			</td>
			<!--add by Peggy 20120215-->
			<td>
				<div align="center">
					<font face="Arial" color="#3366FF">Line<BR>Type
						<img src="../image/point.gif">
					</font></div>
			</td>
			<!--add by Peggy 20120329-->
			<td>
				<div align="center">
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgFOB"/>
					</font></div>
			</td>
			<td width="17%" colspan="1" nowrap>
				<div align="center">
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgCustPONo"/>
					</font></div>
			</td>
			<td  nowrap>
				<div align="center">
					<font face="Arial" color="#3366FF">Quote#</font><img src="../image/point.gif"></div>
			</td>
			<%
				if(custPOLineNo_flag.equals("Y"))
				{
			%>
			<div align="center">
				<td nowrap>
					<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgCustPOLineNo"/><img src="../image/point.gif"></font>
				</td>
			</div>
			<%
				}
				//if(salesAreaNo.equals("008"))  //add by Peggy 20121107
				//{
			%>
			<td  nowrap>
				<div align="center">
					<font face="Arial" color="#3366FF">End Customer</font></div>
			</td>
			<%
				//}
			%>
			<td width="7%" colspan="1">
				<div align="center"><font face="Arial" color="#3366FF">
					<jsp:getProperty name="rPH" property="pgRemark"/></font>
				</div>
			</td>
			<%
				if(salesAreaNo.equals("020"))  //add by Peggy 20160308
				{
			%>
			<td width="7%"><font face="Arial" color="#3366FF">Delivery Remarks</font></td>
			<%
				}
			%>
			<%
				if(customerId.equals("14980") || customerId.equals("15540"))  //add by Peggy 20170220
				{
			%>
			<td width="7%"><font face="Arial" color="#3366FF">BI Region</font></td>
			<%
				}
				if(salesAreaNo.equals("012"))  //add by Peggy 20170512
				{
			%>
			<td width="7%"><font face="Arial" color="#3366FF">End Cust Ship To ID</font></td>
			<%
				}
			%>
			<!--%<td width="4%" rowspan="2"><div align="center"><INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/TSSalesDRQ_Create.jsp")'></div></td> %-->
			<td width="4%" rowspan="2"><div align="center">
				<%
					if (!programName.equals("TSCH"))
					{
				%>
				<input name="button4" type="button" tabindex="<%=(tabidx++)%>" onClick='setSubmit("../jsp/TSSalesDRQ_Create.jsp?INSERT=Y")' value='<jsp:getProperty name="rPH" property="pgAdd"/>'>
				<%
					}
				%>
			</div>
			</td>
		</tr>
		<tr>
			<!--td valign="middle" width="3%">
	<!div align="center">
	<input name="CUSTINO" type="text" size="3" <%//out.println("value="+custINo);%>>
	</div>
    </td-->
			<%
				if(salesAreaNo.equals("001"))  //add by Peggy 20130628
				{
			%>
			<td>
				<INPUT TYPE="text" NAME="CITEMDESC"  tabindex="<%=(tabidx++)%>"  size="15"  class="style2" onKeyPress="subWindowCustItemCheck()">
				<INPUT TYPE="button"  NAME='button' tabindex="<%=(tabidx++)%>" VALUE='.'  class="style3" onClick='subWindowCustItemFind()'>
				<INPUT TYPE="text" NAME="EndCustPartNo" style="border:none;color:#0000ff;font-family:Tahoma,Georgia;font-size:9px" onKeypress="return false">
			</td>
			<%
				}
			%>
			<td width="20%" nowrap> <div align="center">
				<input name="INO" type="hidden" size="2" <%if (iNo==null) out.println("value=1"); else out.println("value="+iNo);%>>
				<input type="text" name="INVITEM" tabindex="<%=(tabidx++)%>" size="20"   class="style2"  onFocus='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,eval(this.form.SAMPLEORDER.checked),this.form.CUSTOMERID.value,this.form.SALESAREANO.value,this.form.PREORDERTYPE.value,this.form.LINEFOB.value)' onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,eval(this.form.SAMPLEORDER.checked),this.form.CUSTOMERID.value,this.form.SALESAREANO.value,this.form.PREORDERTYPE.value,this.form.LINEFOB.value)' maxlength="30" <%if (allMonth[1]!=null) out.println("value="); else out.println("value=");%>>
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value="."  class="style3" onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value,eval(this.form.SAMPLEORDER.checked),this.form.CUSTOMERID.value,this.form.SALESAREANO.value,this.form.PREORDERTYPE.value,this.form.LINEFOB.value)'>
				<input type="hidden" NAME="INVFLAG" value="">
				<input type="hidden" NAME="ITEMSTATUS" value="">
				<input type="hidden" NAME="YEWFLAG" value="">
				<%
					if(salesAreaNo.equals("001"))  //add by Peggy 20190521
					{
				%>
				<br><INPUT TYPE="text" NAME="tsceonhand" style="border:none;color:#0000ff;font-family:Tahoma,Georgia;font-size:9px" onKeypress="return false">
				<%
					}
				%>
			</div>
			</td>
			<td width="11%" nowrap>  <div align="center">
				<input type="text" name="ITEMDESC" tabindex="<%=(tabidx++)%>" size="15"  class="style2" onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,eval(this.form.SAMPLEORDER.checked),this.form.CUSTOMERID.value,this.form.SALESAREANO.value,this.form.PREORDERTYPE.value,this.form.LINEFOB.value)' maxlength="40" <%if (allMonth[2]!=null) out.println("value="); else out.println("value=");%>>
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>"  value="."  class="style3" onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value,eval(this.form.SAMPLEORDER.checked),this.form.CUSTOMERID.value,this.form.SALESAREANO.value,this.form.PREORDERTYPE.value,this.form.LINEFOB.value)'>
			</div>
			</td>
			<td width="6%" nowrap>
				<input type="text" name="PLANTCODE" size="2" align="right"  class="gogo" onblur='subItemFindincludePlant(this.form.INVITEM.value,this.form.ITEMDESC.value,eval(this.form.SAMPLEORDER.checked),this.form.CUSTOMERID.value,this.form.PLANTCODE.value,this.form.SALESAREANO.value,this.form.PREORDERTYPE.value,this.form.LINEFOB.value)' readonly <%if (plantCode!=null) out.println("value="); else out.println("value=");%> >
				<%
					//2009/03/23 liling 顯示料號工廠別_start

					String sqli = " select MANUFACTORY_NAME from oraddman.TSPROD_MANUFACTORY where MANUFACTORY_NO= nvl('"+plantCode+"','X') " ;
					// out.print("sqli="+sqli);
					Statement statei=con.createStatement();
					ResultSet rsi=statei.executeQuery(sqli);
					if (rsi.next())
					{
						plantDesc = rsi.getString("MANUFACTORY_NAME");
					}
					rsi.close();
					statei.close();
					//2009/03/23 liling 顯示料號工廠別_end
				%>
				<%
					if (computeSSD.equals("Y") || CUSTMARKETGROUP.equals("AU")) //顯示Plant code
					{
						strdisable = "";
					}
					else
					{
						strdisable = "disabled";
					}
				%>
				<INPUT TYPE="button" id="btn1" name="btplant" tabindex="<%=(tabidx++)%>"  value="." class="style3"  onClick='subWindowPlantFind()' <%=strdisable%>>
			</td>
			<td width="17%" nowrap><div align="center">
				<input type="text" name="ORDERQTY" tabindex="<%=(tabidx++)%>" size="4"  class="style2" onBlur='tabWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value,eval(this.form.SAMPLEORDER.checked),this.form.CUSTOMERID.value,this.form.SALESAREANO.value,this.form.PREORDERTYPE.value,this.form.LINEFOB.value)' maxlength="60"  <%if (allMonth[3]!=null) out.println("value="); else out.println("value=");%> >
				<%
					if (sampleOrder==null || sampleOrder.equals(""))
					{
						out.println("<font color='#FF0000' class='style2'><strong>MOQ: ");
					}
					else
					{
						out.println("<font color='#0000CC' class='style2'><strong>SPQ: ");
					}
				%>
				<input type="text" name="SPQRULE" size="2" align="right"  class="gogo" readonly <%if (sPQP!=null) out.println("value="); else out.println("value=");%>>
				<%
					out.println("K");
					out.println("</strong></font>");
				%>
			</div>
			</td>
			<%
				if(!salesAreaNo.equals("001"))  //add by Peggy 20130628
				{
			%>
			<td><div align="center">
				<INPUT TYPE="text" NAME="CITEMDESC"  tabindex="<%=(tabidx++)%>"  size="15"  class="style2" onKeyPress="subWindowCustItemCheck()">
				<INPUT TYPE="button"  NAME='button' tabindex="<%=(tabidx++)%>" VALUE='.'  class="style3" onClick='subWindowCustItemFind()'></div>
			</td>
			<%
				}
			%>
			<!--add by Peggy 20120215-->
			<td width="10%" bgColor="#ffffff" nowrap>
				<input name='UPRICE' type='text' tabindex="<%=(tabidx++)%>"  size='5' class="style2" >
			</td>
			<%
				if (computeSSD.equals("Y") || computeSSD.equals("X")) //顯示CRD
				{
			%>
			<td width="10%" bgColor="#ffffff" nowrap>
				<input name="CRD" tabindex="<%=(tabidx++)%>" type="text" size="7" maxlength="8"  class="style2" onKeyPress="if(window.event.keyCode<48 || window.event.keyCode>57) window.event.keyCode = 0;" <%if (allMonth[5]!=null) out.println("value="); else out.println("value=");%>>
				<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.CRD);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
			</td>
			<%
				}
				if (computeSSD.equals("Y")) //SHIPPINGMETHOD
				{
			%>
			<td width="10%" nowrap>
				<input type="text" name="SHIPPINGMETHOD" tabindex="<%=(tabidx++)%>" size="8" maxlength="20"   class="style2" onFocus="subWindowSSDFind(3,this.form.PLANTCODE.value)" <%if (allMonth[6]!=null && !allMonth[6].equals("") && !allMonth[6].equals("&nbsp;")) out.println("value=''"); else out.println("value=''");%>>
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>"  value="."  class="style3" onClick='subWindowSSDFind(1,this.form.PLANTCODE.value)'>
			</td>
			<%
			}
			else if (computeSSD.equals("S") || computeSSD.equals("X")) //顯SHIPPINGMETHOD,modify by Peggy 20120209
			{
			%>
			<td width="10%" nowrap>
				<input type="text" name="SHIPPINGMETHOD" tabindex="<%=(tabidx++)%>" size="8" maxlength="20"  class="style2" onChange="subWindowShipMethodFind(this.form.SHIPPINGMETHOD.value)" <%if (allMonth[6]!=null && !allMonth[6].equals("") && !allMonth[6].equals("&nbsp;")) out.println("value='"+allMonth[6]+"'"); else out.println("value='"+defaultShipMethod+"'");%>>
				<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value="." class="style3"  onClick='subWindowShipMethodFind(this.form.SHIPPINGMETHOD.value)'>
			</td>
			<%
					String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
					PreparedStatement pstmt1=con.prepareStatement(sql1);
					pstmt1.executeUpdate();
					pstmt1.close();

					//add by Peggy 20120522
					Statement stateX=con.createStatement();
					String sqlX = "select a.SHIPPING_METHOD_CODE,a.SHIPPING_METHOD_CODE from ASO_I_SHIPPING_METHODS_V a";
					ResultSet rsX=stateX.executeQuery(sqlX);
					out.println("<select NAME='SHIPMETHODLIST' style='visibility: hidden;'>");
					out.println("<OPTION VALUE=-->--");
					while (rsX.next())
					{
						String s1=(String)rsX.getString(1);
						String s2=(String)rsX.getString(2);
						out.println("<OPTION VALUE='"+s1+"'>"+s2);
					}
					out.println("</select>");
					stateX.close();
					rsX.close();
				}
			%>
			<td width="10%" bgColor="#ffffff" nowrap>
				<input name="TSCPACKAGE" type="hidden" value=<%=TSCPACKAGE%>>
				<input name="showCRD" type="hidden" size="2" value=<%=computeSSD%>>
				<input name="LIMITDAYS" type="hidden" size="2" value=<%=LIMITDAYS%>>
				<input name="UOM" type="hidden" size="8" <%if (allMonth[4]!=null) out.println("value="); else out.println("value=");%>>
				<input name="REQUESTDATE" tabindex="<%=(tabidx++)%>" type="text" size="7"  maxlength="8"  class="style2"  <%if (computeSSD.equals("Y")) out.println("onfocus='subWindowSSDFind(2,this.form.PLANTCODE.value)'");%> <%if (allMonth[7]!=null) out.println("value="); else out.println("value=");%>>
				<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.REQUESTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>	    </td>
			<td nowrap>
				<div align="center">
					<input type="text" name="LINEODRTYPE" size="3" maxlength="4"  value="<%=defaultOdrType%>"  class="style2" onChange="clearLineType();">
					<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value="."  class="style3" onClick='subWindowOrderTypeFind(this.form.LINEODRTYPE.value,this.form.SALESAREANO.value,this.form.PLANTCODE.value,this.form.CUSTOMERID.value)'>
				</div>
			</td>
			<td nowrap>
				<div align="center">
					<input type="text" name="LINETYPE" size="3" maxlength="5"  class="style2" value="<%=defaultLineType%>" readonly>
					<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value="."  class="style3" onClick='subWindowLineTypeFind(this.form.LINETYPE.value,this.form.SALESAREANO.value,this.form.LINEODRTYPE.value)'>
				</div>
			</td>
			<td nowrap>
				<div align="center">
					<input type="text" name="LINEFOB" size="10" class="style2" value="<%=fobPoint%>" readonly>
					<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value="."  class="style3" onClick='subWindowFOBPointFind(this.form.LINEFOB.value,"LINE")'>
				</div>
			</td>
			<td nowrap>
				<div align="center">
					<input type="text" name="ENDCUSTPO" tabindex="<%=(tabidx++)%>"  class="style2" size="10" maxlength="60"  value="<%=customerPO%>" onBlur="setPOObject(this.form.SALESAREANO.value,this.form.ENDCUSTPO.value)">
				</div>
			</td>
			<td nowrap>
				<div align="center">
					<input type="text" name="QUOTENUMBER" tabindex="<%=(tabidx++)%>"  class="style2" size="8" maxlength="10"  value="<%=QUOTENUMBER%>" onKeyPress="setPrice(this.form.SALESAREANO.value,this.form.QUOTENUMBER.value,this.form.ITEMDESC.value,this.form.INVITEM.value)">
				</div>
			</td>
			<%
				if(custPOLineNo_flag.equals("Y"))
				{
			%>
			<td nowrap>
				<div align="center">
					<input type="text" name="ENDCUSTPOLINENO" tabindex="<%=(tabidx++)%>"  class="style2" size="6" maxlength="50"  value="">
				</div>
			</td>
			<%
				}
				//if(salesAreaNo.equals("008"))
				//{
			%>
			<td nowrap>
				<div align="center">
					<input type="text" name="ENDCUSTOMER" tabindex="<%=(tabidx++)%>"  class="style2" size="10" maxlength="50"  value="" onChange="custChange()">
					<input type="hidden" name="ENDCUSTOMERID" tabindex="<%=(tabidx++)%>"  class="style3"  value="">
					<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value="."  class="style2" onClick='subWindowEndCustFind(this.form.CUSTOMERNO.value,this.form.SALESAREANO.value,this.form.ENDCUSTOMER.value)'>
				</div>
			</td>
			<%
				//}
			%>
			<td nowrap><div align="center">
				<input type="text" name="LNREMARK" tabindex="<%=(tabidx++)%>" size="7"  class="style2" maxlength="200"   <%if (allMonth[9]!=null) out.println("value="); else out.println("value=");%>>
			</div>
			</td>
			<%
				if(salesAreaNo.equals("020"))  //add by Peggy 20160308
				{
			%>
			<td nowrap>
				<%
					try
					{
						String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
						PreparedStatement pstmt=con.prepareStatement(sql1);
						pstmt.executeUpdate();
						pstmt.close();

						sql = " SELECT flv.lookup_code,flv.meaning"+
								" FROM fnd_lookup_values flv"+
								" WHERE flv.LOOKUP_TYPE = 'TSC_OM_DELIVERY_INS' "+
								" AND flv.language ='US'";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						if (customerPO.toUpperCase().indexOf("(K)")>=0 || customerPO.toUpperCase().indexOf("KOREA")>=0)
						{
							comboBoxBean.setSelection("1");
						}
						else
						{
							comboBoxBean.setSelection("");
						}
						comboBoxBean.setFieldName("DIRECT_SHIP_TO_CUST");
						comboBoxBean.setFontName("Tahoma,Georgia");
						comboBoxBean.setFontSize(10);
						out.println(comboBoxBean.getRsString());
						rs.close();
						statement.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
			</td>
			<%
				}
			%>

			<%
				if(customerId.equals("14980") || customerId.equals("15540"))  //add by Peggy 20170220
				{
			%>
			<td nowrap>
				<%
					try
					{
						sql = " SELECT A_VALUE,A_VALUE"+
								" FROM oraddman.tsc_rfq_setup a"+
								" WHERE A_CODE = 'BI_REGION' "+
								" order by A_SEQ";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						//comboBoxBean.setSelection(direct_ship_to_cust);
						comboBoxBean.setFieldName("BI_REGION");
						comboBoxBean.setFontName("Tahoma,Georgia");
						comboBoxBean.setFontSize(10);
						out.println(comboBoxBean.getRsString());
						rs.close();
						statement.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
			</td>
			<%
				}
				if (salesAreaNo.equals("012"))  //add by Peggy 20170512
				{
			%>
			<td nowrap>
				<input type="text" name="end_cust_ship_to_id" size="2" maxlength="8">
			</td>
			<%
				}
			%>
		</tr>
		<tr bgcolor="#CCFFCC">
			<td colspan="16"><div align="center"><strong>
				<%
					try
					{
						if (!salesAreaNo.equals("001") || v_conti_msg.equals("") ||  v_conti_msg.equals("OK") || v_conti_msg.startsWith("Notice:")) //add by Peggy 20220921
						{
							//String oneDArray[]= {"","<jsp:getProperty name='rPH' property='pgInvItem'/>","<jsp:getProperty name='rPH' property='pgQty'/>","<jsp:getProperty name='rPH' property='pgDeliveryDate'/>","<jsp:getProperty name='rPH' property='pgRemark'/>"};
							// 20110209 Marvie Update : Add Field  SPQ MOQ
							//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","End-Customer PO","Remark","SPQ_CHECK"};
							//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","End-Customer PO","Remark","SPQ_CHECK","SPQ","MOQ"};
							//add CRD & SHIPPINGMETHOD by Peggychen 20110614
							//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","CRD","Shipping Method","Request Date","End-Customer PO","Remark","SPQ_CHECK","SPQ","MOQ"};
							//20111228 add Plantcode field by Peggy
							String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","CRD","Shipping Method","Request Date","End-Customer PO","Remark","SPQ_CHECK","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust PO Line","Quote#","EndCustID","Shipping Marks","Remarks","EndCustomer","ORIG SO ID","Delivery Remarks","BI Region","End Cust Ship to","End Cust PartNo"}; //modify by Peggy 20150515
							arrayRFQDocumentInputBean.setArrayString(oneDArray);
							String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容
							int i=0,j=0,k=0;
							String dupFLAG="FALSE";
							if (( (invItem!=null && !invItem.equals("")) || (itemDesc!=null && !itemDesc.equals("")) ) && orderQty!=null && !orderQty.equals("") && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
							{
								//out.println("step1");
								String sqlUOM = "";
								if (invItem!=null && !invItem.equals("")) // 若輸入料號,抓說明及單位
								{
									sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE ,TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP "+ //20130319 add by Peggy TSC_PROD_GROUP
											" from APPS.MTL_SYSTEM_ITEMS "+
											" where ORGANIZATION_ID = '49' "+
											" and SEGMENT1 = '"+invItem+"' "+
											" and NVL(CUSTOMER_ORDER_FLAG,'N')='Y'"+ //add by Peggy 20151008
											" and NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"; //add by Peggy 20151008
								}
								else
								{ // 否則若輸入料號說明,抓料號及單位
									sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE ,TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP "+ //20130319 add by Peggy TSC_PROD_GROUP
											" from APPS.MTL_SYSTEM_ITEMS "+
											" where ORGANIZATION_ID = '49' "+
											" and DESCRIPTION = '"+itemDesc+"' "+
											" and NVL(CUSTOMER_ORDER_FLAG,'N')='Y'"+ //add by Peggy 20151008
											" and NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"; //add by Peggy 20151008
								}
								// 依使用者輸入的料號ID取其單位
								Statement stateUOM=con.createStatement();
								ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
								//===(
								if (rsUOM.next())
								{
									uom =  rsUOM.getString("PRIMARY_UOM_CODE");
									invItem = rsUOM.getString("SEGMENT1");
									itemDesc = rsUOM.getString("DESCRIPTION");
									tsc_prod_group = rsUOM.getString("TSC_PROD_GROUP");  //add by Peggy 20130319
									if (tsc_prod_group==null) tsc_prod_group="";
								}
								else
								{
				%>
				<script LANGUAGE="JavaScript">
					subWindowItemFind("<%=invItem%>","<%=itemDesc%>","<%=sampleOrder%>","<%=customerId%>","<%=salesAreaNo%>");
				</script>
				<%
									// 若找不到,則呼叫料號尋找視窗,並將料號及料號說明給沒填入的欄位
									if (itemDesc==null || itemDesc.equals("")) itemDesc = invItem;
									else if (invItem==null || invItem.equals("")) invItem = itemDesc;
									uom = "KPC";
									tsc_prod_group =""; //add by Peggy 20130319
								}
								rsUOM.close();
								stateUOM.close();
								// 依使用者輸入的料號ID取其單位

								// 判斷若End-CustPO號未填,則以CUST PO作為 End-Cust PO號
								if (endCustPO==null || endCustPO.equals(""))
								{
									endCustPO = customerPO;
								}
								// 判斷若End-CustPO號未填,則以CUST PO作為 End-Cust PO號

								//20090309 liling add
								if (spqCheck==null || spqCheck.equals("") || spqCheck.equals("null"))
								{
									spqCheck = "N";
								}
								else if (spqCheck.equals("on") )
								{
									spqCheck = "Y";
								}

								//add by Peggy 20130305
								Statement statea=con.createStatement();
								String sqla = " SELECT 1,substr(replace(replace('"+endCustPO+"','（','('),'）',')'),instr(replace(replace('"+endCustPO+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+endCustPO+"','（','('),'）',')'),')')-(instr(replace(replace('"+endCustPO+"','（','('),'）',')'),'(')+1)) customer,a.shipping_marks, a.remarks"+
										" FROM oraddman.tsc_om_remarks_setup a "+
										" where TSAREANO='"+salesAreaNo+"'"+
										//" AND USER_NAME ='"+UserName+"'"+
										" AND substr(replace(replace('"+endCustPO+"','（','('),'）',')'),instr(replace(replace('"+endCustPO+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+endCustPO+"','（','('),'）',')'),')')-(instr(replace(replace('"+endCustPO+"','（','('),'）',')'),'(')+1)) LIKE '%' ||customer ||'%'"+
										" AND ORDER_TYPE ='"+orderType+"'"+
										" UNION ALL"+
										" SELECT 2,substr(replace(replace('"+endCustPO+"','（','('),'）',')'),instr(replace(replace('"+endCustPO+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+endCustPO+"','（','('),'）',')'),')')-(instr(replace(replace('"+endCustPO+"','（','('),'）',')'),'(')+1)) customer,a.shipping_marks, a.remarks"+
										" FROM oraddman.tsc_om_remarks_setup a "+
										" where TSAREANO='"+salesAreaNo+"'"+
										//" AND USER_NAME ='"+UserName+"'"+
										" AND customer='ALL'"+
										" AND ORDER_TYPE ='"+orderType+"'"+
										" ORDER BY 1";
								//out.println(sqla);
								ResultSet rsa=statea.executeQuery(sqla);
								if (rsa.next())
								{
									shipping_Marks= rsa.getString("shipping_marks");
									shipping_Marks = shipping_Marks.replace("?01",(rsa.getString("customer")==null?endCustPO:rsa.getString("customer")));
									remarks = rsa.getString("remarks");
									//if (invItem.substring(10,11).equals("1"))
									if (invItem.substring(10,11).equals("1") || (tsc_prod_group.equals("PMD") && invItem.substring(3,4).equals("G"))) //PMD料號22碼中第四碼為G表GREEN COMPOUND,add by Peggy 20130319
									{
										remarks = remarks.replace("?02","green compound");
									}
									else
									{
										remarks = remarks.replace("?02","");
									}
								}
								else
								{
									shipping_Marks="";
									remarks ="";
								}
								rsa.close();
								statea.close();

								if (a!=null)
								{ //out.println("step2");
									String b[][]=new String[a.length+1][a[i].length];
									for (i=0;i<a.length;i++)
									{ //out.println("step3");
										for (j=0;j<a[i].length;j++)
										{ //out.println("step4");
											b[i][j]=a[i][j];
											//if (a[k][0].equals(orderQty)) { dupFLAG = "TRUE"; }
										} // End of for (j=0)
										k++;
									}// End of for (i=0)
									iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
									//out.println(iNo);
									b[k][0]=iNo;
									b[k][1]=invItem;
									b[k][2]=itemDesc;
									b[k][3]=orderQty;
									b[k][4]=uom;
									b[k][5]=(custrequestDate=="")?"&nbsp;":custrequestDate; //add by Peggychen 20110614
									b[k][6]=(shippingMethod.equals("")||shippingMethod==null||shippingMethod.equals("&nbsp;"))?ship_via:shippingMethod; //add by Peggychen 20110614
									b[k][7]=requestDate;
									b[k][8]=((salesAreaNo.equals("001") && !endCustPO.equals(customerPO))?customerPO:endCustPO);
									b[k][9]=lnRemark;
									b[k][10]=spqCheck;
									// 20110209 Marvie Add : Add Field  SPQ MOQ
									b[k][11]=spqp; // SPQ
									b[k][12]=moqp; // MOQ
									b[k][13]=plantCode; //Add by Peggy 20111228
									b[k][14]=custPartNo;   //客戶料號,add by Peggy 20120301
									b[k][15]=sellingPrice; //單價,add by Peggy 20120301
									b[k][16]=orderType;    //訂單類型,add by Peggy 20120301
									b[k][17]=lineType;     //LineType,add by Peggy 20120301
									b[k][18]=(lineFob==null||lineFob.equals(""))?fobPoint:lineFob;      //fob,add by Peggy 20120329
									//b[k][19]=customerPOLineNo; //add by Peggy 20120531
									b[k][19]=customerPOLineNo;   //modify by Peggy 20121106
									b[k][20]=QUOTENUMBER;        //add by Peggy 20120905
									b[k][21]=ENDCUSTOMERID;        //add by Peggy 20140812
									b[k][22]=shipping_Marks;     //add by Peggy 201302227
									b[k][23]=remarks;            //add by Peggy 201302227
									b[k][24]=ENDCUSTOMER;        //add by Peggy 20140819
									b[k][25]="";           //add by Peggy 20150519
									b[k][26]=direct_ship_to_cust; //add by Peggy 20160308
									b[k][27]=BI_REGION;           //add by Peggy 20170218
									b[k][28]="";                  //add by Peggy 20170511
									b[k][29]=endCustPartNo;       //add by Peggy 20190225
									arrayRFQDocumentInputBean.setArray2DString(b);
								}
								else
								{
									//out.println("step5: 若為第一筆資料,則填入抬頭");
									// 20110209 Marvie Update : Add Field  SPQ MOQ
									//String c[][]={{iNo,invItem,itemDesc,orderQty,uom,requestDate,endCustPO,lnRemark,spqCheck}};
									//String c[][]={{iNo,invItem,itemDesc,orderQty,uom,requestDate,endCustPO,lnRemark,spqCheck,moqp,spqp}};
									//add CRD & SHIPPINGMETHOD by Peggychen 20110614
									//String c[][]={{iNo,invItem,itemDesc,orderQty,uom,custrequestDate,shippingMethod,requestDate,endCustPO,lnRemark,spqCheck,moqp,spqp}};
									//String c[][]={{iNo,invItem,itemDesc,orderQty,uom,custrequestDate,shippingMethod,requestDate,endCustPO,lnRemark,spqCheck,moqp,spqp,plantCode}};	//modify by Peggy 20111228
									//String c[][]={{iNo,invItem,itemDesc,orderQty,uom,custrequestDate,shippingMethod,requestDate,endCustPO,lnRemark,spqCheck,spqp,moqp,plantCode,custPartNo,sellingPrice,orderType,lineType,(lineFob==null||lineFob.equals(""))?fobPoint:lineFob}};	//modify by Peggy 20120301
									String c[][]={{iNo,invItem,itemDesc,orderQty,uom,custrequestDate,shippingMethod,requestDate,((salesAreaNo.equals("001") && !endCustPO.equals(customerPO))?customerPO:endCustPO),lnRemark,spqCheck,spqp,moqp,plantCode,custPartNo,sellingPrice,orderType,lineType,(lineFob==null||lineFob.equals(""))?fobPoint:lineFob,customerPOLineNo,QUOTENUMBER,ENDCUSTOMERID,shipping_Marks,remarks,ENDCUSTOMER,"",direct_ship_to_cust,BI_REGION,"",endCustPartNo}};
									arrayRFQDocumentInputBean.setArray2DString(c);
								}
							}
							else
							{ //out.println("step6:未輸入欄位內容作 Add ,表示點擊刪除鍵");
								if (a!=null)
								{ //out.println("step7:若陣列內原已有存入內容,則把內容在置入");
									arrayRFQDocumentInputBean.setArray2DString(a);
								}
							}
						}
						//end if of chooseItem is null

						//###################針對目前陣列內容進行檢查機制#############################
						Statement chkstat=con.createStatement();
						ResultSet chkrs=null;
						String T2[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容做為暫存用;
						String tp[]=arrayRFQDocumentInputBean.getArrayContent();
						if  (T2!=null)
						{
							//-------------------------取得轉存用陣列--------------------
							String temp[][]=new String[T2.length][T2[0].length];
							for (int ti=0;ti<T2.length;ti++)
							{
								for (int tj=0;tj<T2[ti].length;tj++)
								{
									temp[ti][tj]=T2[ti][tj];
									//out.println("temp[ti][tj]="+temp[ti][tj]);
								}
							}
							//--------------------------------------------------------------------
							int ti = 0;
							int tj = 0;

							temp[ti][tj]="N";
							arrayRFQDocumentInputBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用
						}
						else
						{
							arrayRFQDocumentInputBean.setArray2DCheck(null);
						}	 //end if of T2!=null
						if (chkrs!=null) chkrs.close();
						chkstat.close();
						//##############################################################
					} //end of try
					catch (Exception e)
					{
						out.println("Exception6:"+e.getMessage());
					}
				%>
				<%
					try
					{
						String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容
						float total=0;
					} //end of try
					catch (Exception e)
					{
						out.println("Exception7:"+e.getMessage());
					}
				%>
			</strong></div>	  </td>
		</tr>
	</table>
	<HR>
	<table cellSpacing="1" bordercolordark="#66CC99"cellPadding="1" width="100%" align="center" bordercolor="#66CC99" border="1">
		<tr bgcolor="#CCFFCC">
			<td>
				<%
					if (!programName.equals("TSCH"))
					{
				%>
				<input name="button" tabindex="<%=(tabidx++)%>" type=button onClick="this.value=check(this.form.ADDITEMS)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
				<%
					}
				%>
				<font color="#336699">-----DETAIL you choosed to be saved----------------------------------------------------------------------------------------------------</font>
			</td>
		</tr>
		<tr bgcolor="#CCFFCC">
			<td>
				<%
					int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
					try
					{
						String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容
						if (a!=null)
						{
							div1=a.length;
							div2=a[0].length;
							arrayRFQDocumentInputBean.setFieldName("ADDITEMS");
							arrayRFQDocumentInputBean.setEventName(" onChange=setsubmitChg();");
							//if (programName.equals("D4-004")) //add by Peggy 20121114
							if (programName.equals("D4-004") || programName.equals("D4-020") || (programName.equals("D4-011") && salesAreaNo.equals("002")))  //modify by Peggy 20130219
							{
								div1=a.length-1;
								String cct[][] = new String[a.length][a[0].length];
								for (int x=0;x<a.length;x++)
								{
									for (int y=0;y<a[x].length;y++)
									{
										if (y==0)
										{
											cct[x][y]=a[x][y];
										}
										else if (SPQChecked.equals("Y") && (programName.equals("D4-004") || programName.equals("D4-020")) && (y==5 || y==6 || y ==7 || y ==8 || y ==9 || y ==15 || y ==18 || y ==21))
										{
											cct[x][y]="U";
										}
										else if (SPQChecked.equals("Y") && programName.equals("D4-011") && (y==6 || y ==7 || y ==8 || y ==9 || y ==15 || y ==18 || y ==22 || y ==23))  //add by Peggy 20130219
										{
											//if (UserName.equals("COCO") && (y ==22 || y ==23))
											if (salesAreaNo.equals("018") && (y ==22 || y ==23)) //modify by Peggy 20171221
											{
												cct[x][y]="T";
											}
											else
											{
												cct[x][y]="U";
											}
										}
										else
										{
											cct[x][y]="D";
										}
									}
								}
								arrayRFQDocumentInputBean.setArray2DCheck(cct);
								out.println(arrayRFQDocumentInputBean.getArray2DTempString());  // 用Item 及Item Description 作為Key 的Method
							}
							else
							{
								arrayRFQDocumentInputBean.setLineNum(0);
								String cct[][] = new String[a.length][a[0].length];
								for (int x=0;x<a.length;x++)
								{
									for (int y=0;y<a[x].length;y++)
									{
										if (y==0)
										{
											cct[x][y]=a[x][y];
										}
										//else if (salesAreaNo.equals("002") && UserName.equals("COCO") && ( y==9 || y ==22 || y ==23))
										else if (salesAreaNo.equals("018")  && ( y==9 || y ==22 || y ==23))  //modify by Peggy 20171221
										{
											cct[x][y]="T";
										}
										else
										{
											cct[x][y]="D";
										}
									}
								}
								arrayRFQDocumentInputBean.setArray2DCheck(cct);
								//out.println(arrayRFQDocumentInputBean.getArray2DRFQString());  // 用Item 及Item Description 作為Key 的Method
								//out.println(arrayRFQDocumentInputBean.getArray2D2KeyString());
								out.println(arrayRFQDocumentInputBean.getArray2DTempString());  // 用Item 及Item Description 作為Key 的Method
							}
							isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y"
							inpLen = div1; // 第一筆Item 被寫入時
						}	//enf of a!=null if
					} //end of try
					catch (Exception e)
					{
						out.println("Exception9:"+e.getMessage());
					}
				%>
			</td>
		</tr>
		<tr bgcolor="#CCFFCC">
			<td>
				<%
					if (!programName.equals("TSCH"))
					{
				%>
				<INPUT name="button2" tabindex="<%=(tabidx++)%>" TYPE="button" onClick='setSubmit6("../jsp/TSSalesDRQ_Create.jsp?INSERT=Y")'  value='<jsp:getProperty name="rPH" property="pgDelete"/>' >
				<%
					}
					if (isModelSelected =="Y" || isModelSelected.equals("Y")) out.println("<font color='#336699'>-----CLICK checkbox and choice to delete---------------------------------------------------------------------------------------------------");
				%>
			</td>
		</tr>
	</table>
	<HR>
	<table cellSpacing="1" bordercolordark="#66CC99"cellPadding="1" width="100%" align="center" bordercolor="#66CC99" border="1">
		<tr bgcolor="#CCFFCC">
			<td>
				<strong><font color="#3366FF" face="Arial"><jsp:getProperty name="rPH" property="pgProcessUser"/></font></strong> </td>
			<td width="18%" bgcolor="#FFFFFF" nowrap>
				<font color='#000099' face="Arial"><strong><%=userID+"("+UserName+")"%></strong></font> </td>
			<td width="16%" bgcolor="#CCFFCC">
				<strong><font color="#3366FF" face="Arial"><jsp:getProperty name="rPH" property="pgProcessDate"/></font></strong> </td>
			<td width="15%" bgcolor="#FFFFFF"><font color="#000099" face="Arial"><strong><%=dateBean.getYearMonthDay()%></strong></font></td>
			<td width="16%" bgcolor="#CCFFCC">
				<strong><font color="#3366FF" face="Arial"><jsp:getProperty name="rPH" property="pgProcessTime"/></font></strong> </td>
			<td width="19%" bgcolor="#FFFFFF">
				<font color='#000099' face="Arial"><strong><%=dateBean.getHourMinuteSecond()%></strong></font> </td>
		</tr>
		<tr>
			<td width="16%" bgcolor="#CCFFCC">
				<strong><font color="#3366FF" face="Arial"><jsp:getProperty name="rPH" property="pgAction"/></font></strong> </td>
			<td colspan="1">
				<%
					if (SPQChecked.equals("Y"))  //add by Peggy 20120316
					{
						try
						{
							Statement statement=con.createStatement();
							ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 "+
									" WHERE FORMID='TS'AND TYPENO='001' AND FROMSTATUSID='001' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'"+
									" AND x1.ACTIONID <> '021'");
							comboBoxBean.setRs(rs);
							comboBoxBean.setFieldName("ACTIONID");
							if (programName.equals("D4-004") || programName.equals("D4-020")|| programName.equals("D4-016") || (programName.equals("D4-011") && salesAreaNo.equals("002")) || programName.equals("TSCH")) //add by Peggy 20121114
							{
								comboBoxBean.setOnChangeJS("setSubmit1("+'"'+"../jsp/TSSalesDRQ_Create.jsp?INSERT=Y"+'"'+")");
								comboBoxBean.setSelection((actionID==null?"--":actionID));
							}
							else
							{
								comboBoxBean.setSelection("002"); // 2006/01/03 設定預設為開立交期詢問單
							}
							out.println(comboBoxBean.getRsString());

							rs.close();
							statement.close();
						} //end of try
						catch (Exception e)
						{
							out.println("Exception10:"+e.getMessage());
						}
					}
					else
					{
						out.println("<INPUT TYPE='button' value='MOQ Check' onClick='setSPQImportCheck();'>");  //add by Peggy 20120316
					}
				%>
				&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td bgcolor="#CCFFCC">
				<strong><font color="#3366FF" face="Arial"><jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgDeptArea"/></font></strong>   </td>
			<td width="15%" bgcolor="#FFFFFF" colspan="3">
				<font color='#000099' face="Arial"><strong>
					<%
						try
						{
							if (processArea==null || processArea.equals(""))
							{
								Statement statement=con.createStatement();
								ResultSet rs=null;
								sql = "select SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA "+
										" WHERE SALES_AREA_NO='"+userActCenterNo+"' ";
								rs=statement.executeQuery(sql);
								if (rs.next())
								{
									processArea=rs.getString(2);
									out.println(processArea);
								}
								rs.close();
								statement.close();
							}
							else
							{
								out.println(processArea);
							}
						} //end of try
						catch (Exception e)
						{
							out.println("Exception11:"+e.getMessage());
						}
					%>
				</strong></font>   </td>
		</tr>
	</table>
	<script LANGUAGE="JavaScript">
		<!--
		//alert("Testing")
		// -->
	</script>
	<BR>
	<INPUT TYPE="button" tabindex="<%=(tabidx++)%>" value='<jsp:getProperty name="rPH" property="pgSave"/>' onClick='setSubmit2("../jsp/TSSalesDRQ_MInsert.jsp",<%=div1%>,<%=div2%>,"<jsp:getProperty name="rPH" property="pgAlertCreateDRQ"/>")' >
	&nbsp;<font color="#CC0066"><strong><input name="REPEATINPUT" type="checkbox" <% if (repeatInput==null || repeatInput.equals("")) { out.println("checked");  } else if (repeatInput=="on" || repeatInput.equals("on")){ out.println("checked"); } else {} %>><jsp:getProperty name="rPH" property="pgRepeatRepInput"/></strong></font>
	<!-- 表單參數 -->
	<input name="FORMID" type="HIDDEN" value="TS">
	<input name="FROMSTATUSID" type="HIDDEN" value="001">
	<input name="ISMODELSELECTED" type="HIDDEN" value="<%=isModelSelected%>" size=2>  <!--做為判斷是否已選取新增機型明細-->
	<input name="FROMPAGE" type="HIDDEN" value="TSSalesDRQ_Create.jsp">
	<input name="SALESPERSONID" type="HIDDEN" value="<%=salesPersonID%>">
	<input name="PROCESSAREA" type="HIDDEN" value="<%=processArea%>">
	<input name="SALESPERSON" type="HIDDEN" value="<%=salesPerson%>">
	<input name="TOPERSONID" type="HIDDEN" value="<%=toPersonID%>">
	<input name="CUSTOMERIDTMP" type="HIDDEN" value="<%=customerIdTmp%>">
	<input name="INSERT" type="HIDDEN" value="<%=insertPage%>">
	<input type="hidden" size="10" name="CUSTOMERID" value="<%=customerId%>">
	<input type="hidden" size="10" name="CUSTACTIVE" value="<%=custActive%>">
	<input type="hidden" size="10" name="SORDERCHECK" value="<%=sampleOrder%>">
	<input type="hidden" size="10" name="NSPQCHECK" value="<%=spqCheck%>">
	<input type="hidden" size="10" name="MOQP" <%if (moqp!=null) out.println("value="); else out.println("value=");%>>
	<input type="hidden" size="10" name="SPQP" <%if (spqp!=null) out.println("value="); else out.println("value=");%>>	<!--ADD BY Peggy 20120516-->
	<input name="PARORGID" type="hidden" value="<%=parOrgID%>">
	<input name="SYSDATE" type="hidden" value="<%=dateBean.getYearMonthDay()%>">
	<input name="maxDate" type="hidden" value="<%=maxDate%>">
	<input name="maxDate1" type="hidden" value="<%=maxDate1%>">
	<input name="CUSTMARKETGROUP" type="hidden" value="<%=CUSTMARKETGROUP%>">
	<input type="hidden" name="PROGRAMNAME" value="<%=programName%>">
	<input type="hidden" name="SPQCHECKED" value="<%=SPQChecked%>">
	<input type="hidden" name="FOBLIST" value="<%=fobList%>">
	<input type="hidden" name="UPLOAD_TEMP_ID" value="<%=UPLOAD_TEMP_ID%>">
	<input type="hidden" name="modelN" value="<%=modelN%>">
	<input type="hidden" name="groupByType" value="<%=groupByType%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
