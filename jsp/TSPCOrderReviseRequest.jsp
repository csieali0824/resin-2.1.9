<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
	<STYLE TYPE='text/css'>
		BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
		P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
		TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
		TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}
		TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
		A         { text-decoration: underline }
		A:link    { color: #003399; text-decoration: underline }
		A:visited { color: #990066; text-decoration: underline }
	</STYLE>
	<title>PC Request Order Revise</title>
	<!--=============以下區段為安全認證機制==========-->
	<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
	<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
	<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
	<%@ page import="SalesDRQPageHeaderBean" %>
	<%@ page import="DateBean,ComboBoxBean,,Array2DimensionInputBean"%>
	<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
	<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
	<jsp:useBean id="dateBean1" scope="page" class="DateBean"/>
	<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
	<jsp:useBean id="PCBean" scope="session" class="Array2DimensionInputBean"/>
	<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
	function setQuery(URL)
	{
		if (document.MYFORM.PLANTCODE.value==null || document.MYFORM.PLANTCODE.value=="--" ||  document.MYFORM.PLANTCODE.value=="")
		{
			alert("Please choose a plant name!");
			document.MYFORM.PLANTCODE.focus();
			return false;
		}
		if (document.MYFORM.REQ_TYPE.value==null || document.MYFORM.REQ_TYPE.value=="--" ||  document.MYFORM.REQ_TYPE.value=="")
		{
			alert("Please choose a request type!");
			document.MYFORM.REQ_TYPE.focus();
			return false;
		}
		document.getElementById("alpha").style.width=document.body.clientWidth;
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";

		document.MYFORM.btnQuery.disabled=true;
		document.MYFORM.btnExcel.disabled=true;
		document.MYFORM.btnUpload.disabled=true;
		if (document.MYFORM.save1 != undefined)
		{
			document.MYFORM.save1.disabled=true;
		}
		if (document.MYFORM.exit1 != undefined)
		{
			document.MYFORM.exit1.disabled=true;
		}
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	function setAdd(URL)
	{
		document.getElementById("alpha").style.width=document.body.clientWidth;
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	function setDelete(URL)
	{
		document.getElementById("alpha").style.width=document.body.clientWidth;
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	function setUpload()
	{
		if (document.MYFORM.PLANTCODE.value==null || document.MYFORM.PLANTCODE.value=="--" ||  document.MYFORM.PLANTCODE.value=="")
		{
			alert("Please choose a plant name!");
			document.MYFORM.PLANTCODE.focus();
			return false;
		}
		//if (document.MYFORM.REQ_TYPE.value==null || document.MYFORM.REQ_TYPE.value=="--" ||  document.MYFORM.REQ_TYPE.value=="")
		//{
		//	alert("Please choose a request type!");
		//	document.MYFORM.REQ_TYPE.focus();
		//	return false;
		//}
		/*document.getElementById("alpha").style.width=window.screen.width;
        document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
        //if (document.MYFORM.REQ_TYPE.value=="Pull in")
        //{
        //	subWin=window.open("../jsp/TSPCOrderReviseUploadP.jsp?REQ="+document.MYFORM.REQ_TYPE.value+"&PLANT="+document.MYFORM.PLANTCODE.value+'"',"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");
        //}
        //else
        //{
            subWin=window.open("../jsp/TSPCOrderReviseUpload.jsp?PLANT="+document.MYFORM.PLANTCODE.value,"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");
        //}
        */
		document.MYFORM.action="../jsp/TSPCOrderReviseUpload.jsp?PLANT="+document.MYFORM.PLANTCODE.value;
		document.MYFORM.submit();
	}
	function setClose()
	{
		if (confirm("Are you sure to exit this function?"))
		{
			location.href="/oradds/ORADDSMainMenu.jsp";
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
	function setExcel(URL)
	{
		if (document.MYFORM.PLANTCODE.value==null || document.MYFORM.PLANTCODE.value=="--" ||  document.MYFORM.PLANTCODE.value=="")
		{
			alert("Please choose a plant name!");
			document.MYFORM.PLANTCODE.focus();
			return false;
		}
		if (document.MYFORM.REQ_TYPE.value==null || document.MYFORM.REQ_TYPE.value=="--" ||  document.MYFORM.REQ_TYPE.value=="")
		{
			alert("Please choose a request type!");
			document.MYFORM.REQ_TYPE.focus();
			return false;
		}
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	function setReqType(objValue)
	{
		if (objValue=="Overdue")
		{
			document.MYFORM.btnExcel.style.visibility="visible";
			document.MYFORM.SSD_SDATE.value="";
			document.MYFORM.SSD_SDATE.disabled=true;
			document.MYFORM.SSD_EDATE.disabled=true;
			document.MYFORM.MO_LIST.disabled=true;
			document.MYFORM.SALES_GROUP_LIST.disabled=true;
			document.MYFORM.ITEM_LIST.disabled=true;
			document.MYFORM.SSD_SDATE.value="";
			document.MYFORM.SSD_EDATE.value="";
			document.MYFORM.MO_LIST.value="";
			document.MYFORM.SALES_GROUP_LIST.value="";
			document.MYFORM.ITEM_LIST.value="";
			document.getElementById("div_show").style.visibility="hidden";
			document.MYFORM.ew_show.checked=false;
			//document.MYFORM.cancel1.style.visibility="hidden";
		}
		else if (objValue=="Early Warning")
		{
			document.MYFORM.btnExcel.style.visibility="visible";
			document.MYFORM.SSD_SDATE.disabled=false;
			document.MYFORM.SSD_EDATE.disabled=false;
			document.MYFORM.MO_LIST.disabled=false;
			document.MYFORM.SALES_GROUP_LIST.disabled=false;
			document.MYFORM.ITEM_LIST.disabled=false;
			document.getElementById("div_show").style.visibility="visible";
			document.MYFORM.ew_show.checked=false;
			//document.MYFORM.cancel1.style.visibility="visible";
		}
		else
		{
			document.MYFORM.btnExcel.style.visibility="hidden";
			document.MYFORM.SSD_SDATE.disabled=false;
			document.MYFORM.SSD_EDATE.disabled=false;
			document.MYFORM.MO_LIST.disabled=false;
			document.MYFORM.SALES_GROUP_LIST.disabled=false;
			document.MYFORM.ITEM_LIST.disabled=false;
			document.getElementById("div_show").style.visibility="hidden";
			document.MYFORM.ew_show.checked=false;
		}
	}
	function chk_show()
	{
		if (document.MYFORM.ew_show.checked)
		{
			document.MYFORM.cancel1.style.visibility="visible";
		}
		else
		{
			document.MYFORM.cancel1.style.visibility="hidden";
		}
	}
	function checkall()
	{
		if (document.MYFORM.chk.length != undefined)
		{
			for (var i =0 ; i < document.MYFORM.chk.length ;i++)
			{
				if (document.MYFORM.chk[i].disabled==false)
				{
					document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
					setCheck((i+1));
				}
			}
		}
		else
		{
			if (document.MYFORM.chk.disabled==false)
			{
				document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
				setCheck(1);
			}
		}
	}
	function setCheck(irow)
	{
		var chkflag ="";
		var iLen=0;
		if (document.MYFORM.chk.length != undefined)
		{
			chkflag = document.MYFORM.chk[irow-1].checked;
		}
		else
		{
			chkflag = document.MYFORM.chk.checked;
		}
		if (chkflag == true)
		{
			document.getElementById("tr_"+irow).style.backgroundColor ="#D9E8E3";
			document.MYFORM.elements["REQTYPE_"+irow].style.backgroundColor ="#D9E8E3";

			if (document.MYFORM.elements["chk_"+irow].length != undefined)
			{
				iLen = document.MYFORM.elements["chk_"+irow].length;
			}
			else
			{
				iLen = 1;
			}

			for (var i=1; i<= iLen ; i++)
			{
				if (document.MYFORM.elements["rdo_"+irow+"."+i].length ==undefined)
				{
					document.MYFORM.elements["rdo_"+irow+"."+i].checked=true;
				}

				document.MYFORM.elements["SSD_"+irow+"."+i].style.backgroundColor ="#D9E8E3";
				if (document.MYFORM.elements["SSD_"+irow+"."+i].value=="")
				{
					if (document.MYFORM.elements["NEW_SSD_"+irow+"."+i].value!="")
					{
						document.MYFORM.elements["SSD_"+irow+"."+i].value=document.MYFORM.elements["NEW_SSD_"+irow+"."+i].value;
					}
					else
					{
						//document.MYFORM.elements["SSD_"+irow].value=document.MYFORM.elements["SOURCE_SSD_"+irow].value;
					}
				}
				document.MYFORM.elements["QTY_"+irow+"."+i].style.backgroundColor ="#D9E8E3";
				if (document.MYFORM.elements["QTY_"+irow+"."+i].value=="")
				{
					if (document.MYFORM.elements["NEW_QTY_"+irow+"."+i].value!="")
					{
						document.MYFORM.elements["QTY_"+irow+"."+i].value=document.MYFORM.elements["NEW_QTY_"+irow+"."+i].value;
					}
					else
					{
						document.MYFORM.elements["QTY_"+irow+"."+i].value=document.MYFORM.elements["SOURCE_QTY_"+irow].value;
					}
				}
				if (document.MYFORM.elements["REQTYPE_"+irow].value!="Early Ship")
				{
					document.MYFORM.elements["REASONCODE_"+irow+"."+i].style.backgroundColor ="#D9E8E3";
				}
				document.MYFORM.elements["REMARKS_"+irow+"."+i].style.backgroundColor ="#D9E8E3";
				if (document.MYFORM.elements["REMARKS_"+irow+"."+i].value=="")
				{
					if (document.MYFORM.elements["NEW_REMARKS_"+irow+"."+i].value!="")
					{
						document.MYFORM.elements["REMARKS_"+irow+"."+i].value=document.MYFORM.elements["NEW_REMARKS_"+irow+"."+i].value;
					}
				}
			}
		}
		else
		{
			if (document.MYFORM.elements["chk_"+irow].length != undefined)
			{
				iLen = document.MYFORM.elements["chk_"+irow].length;
			}
			else
			{
				iLen = 1;
			}

			for (var i=1; i<= iLen ; i++)
			{
				if (document.MYFORM.elements["rdo_"+irow+"."+i].length ==undefined)
				{
					document.MYFORM.elements["rdo_"+irow+"."+i].checked=false;
				}
				else
				{
					for (var k =0 ; k <document.MYFORM.elements["rdo_"+irow+"."+i].length ;k++)
					{
						document.MYFORM.elements["rdo_"+irow+"."+i][k].checked=false;
					}
				}
				setRdoObject(irow+"."+i,irow);
				document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
				document.MYFORM.elements["REQTYPE_"+irow].style.backgroundColor ="#FFFFFF";
				document.MYFORM.elements["SSD_"+irow+"."+i].style.backgroundColor ="#FFFFFF";
				document.MYFORM.elements["SSD_"+irow+"."+i].value="";
				document.MYFORM.elements["QTY_"+irow+"."+i].style.backgroundColor ="#FFFFFF";
				document.MYFORM.elements["QTY_"+irow+"."+i].value="";
				if (document.MYFORM.elements["REQTYPE_"+irow].value!="Early Ship")
				{
					document.MYFORM.elements["REASONCODE_"+irow+"."+i].style.backgroundColor ="#FFFFFF";
					document.MYFORM.elements["REASONCODE_"+irow+"."+i].value="";
				}
				document.MYFORM.elements["REMARKS_"+irow+"."+i].style.backgroundColor="#FFFFFF";
				document.MYFORM.elements["REMARKS_"+irow+"."+i].value="";
			}
		}
	}
	function setSubmit(URL)
	{
		var iLen=0,iRow=0,tot_qty=0;
		var chkvalue = false;
		var chkcnt =0;
		var lineid="";
		var chvalue="",so_line_id="";
		var i_year = "",i_month= "",i_day ="";

		if (document.MYFORM.chk.length != undefined)
		{
			iLen = document.MYFORM.chk.length;
		}
		else
		{
			iLen = 1;
		}
		for (var i=1; i<= iLen ; i++)
		{
			if (iLen==1)
			{
				chkvalue =document.MYFORM.chk.checked;
				lineid = document.MYFORM.chk.value;
			}
			else
			{
				chkvalue = document.MYFORM.chk[i-1].checked;
				lineid = document.MYFORM.chk[i-1].value;
			}
			if (chkvalue==true)
			{
				/*so_line_id = document.MYFORM.elements["so_line_id_"+lineid].value;
                if (iLen !=1)
                {
                    for (var j=1 ; j <= iLen ;j++)
                    {
                        if ( j!=i && document.MYFORM.chk[j-1].checked==false)
                        {
                            if (document.MYFORM.elements["so_line_id_"+document.MYFORM.chk[j-1].value].value==so_line_id)
                            {
                                alert("Same order must be together select!");
                                return false;
                            }
                        }
                    }
                }
                */
				if (document.MYFORM.elements["chk_"+lineid].length != undefined)
				{
					iRow = document.MYFORM.elements["chk_"+lineid].length;
				}
				else
				{
					iRow = 1;
				}
				tot_qty=0;
				for (var j=1; j<= iRow ; j++)
				{
					chvalue="";
					if (document.MYFORM.elements["rdo_"+lineid+"."+j].length ==undefined)
					{
						chvalue = document.MYFORM.elements["rdo_"+lineid+"."+j].value;
					}
					else
					{
						for (var k =0 ; k <document.MYFORM.elements["rdo_"+lineid+"."+j].length ;k++)
						{
							if (document.MYFORM.elements["rdo_"+lineid+"."+j][k].checked)
							{
								chvalue = document.MYFORM.elements["rdo_"+lineid+"."+j][k].value;
								break;
							}
						}
					}
					if (chvalue == "")
					{
						alert("Line"+(i)+":Ascription by must be choose!");
						return false;
					}
					if (document.MYFORM.elements["SSD_"+lineid+"."+j].value==null|| document.MYFORM.elements["SSD_"+lineid+"."+j].value=="")
					{
						alert("Line"+(i)+":The New Schedule Ship Date can not empty!");
						document.MYFORM.elements["SSD_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
						document.MYFORM.elements["SSD_"+lineid+"."+j].focus();
						return false;
					}
					else if (document.MYFORM.elements["SSD_"+lineid+"."+j].value.length!=8)
					{
						alert("Line"+(i)+":The New Schedule Ship Date format error(correct format:YYYYMMDD)!");
						document.MYFORM.elements["SSD_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
						document.MYFORM.elements["SSD_"+lineid+"."+j].focus();
						return false;
					}
					else
					{
						i_year = document.MYFORM.elements["SSD_"+lineid+"."+j].value.substr(0,4);
						i_month= document.MYFORM.elements["SSD_"+lineid+"."+j].value.substr(4,2);
						i_day  = document.MYFORM.elements["SSD_"+lineid+"."+j].value.substr(6,2);
						if (i_month <1 || i_month >12)
						{
							alert("Line"+(i)+":Month format error(invalid format:YYYYMMDD)!!");
							document.MYFORM.elements["SSD_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
							return false;
						}
						else if ((i_month ==1 || i_month==3 || i_month == 5 || i_month ==7 || i_month==8 || i_month==10 || i_month ==12)	 && i_day > 31)
						{
							alert("Line"+(i)+":Days format error(invalid format:YYYYMMDD)!!");
							document.MYFORM.elements["SSD_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
							return false;
						}
						else if ((i_month == 4 || i_month==6 || i_month == 9 || i_month ==11)	 && i_day > 30)
						{
							alert("Line"+(i)+":Days format error(invalid format:YYYYMMDD)!!");
							document.MYFORM.elements["SSD_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
							return false;
						}
						else if (i_month == 2)
						{
							if ((isLeapYear(i_year) && i_day > 29) || (!isLeapYear(i_year) && i_day > 28))
							{
								alert("Line"+(i)+":Days format error(invalid format:YYYYMMDD)!!");
								document.MYFORM.elements["SSD_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
								return false;
							}
						}
					}
					if (document.MYFORM.elements["QTY_"+lineid+"."+j].value==null || document.MYFORM.elements["QTY_"+lineid+"."+j].value=="")
					{
						alert("Line"+(i)+":The New Order Qty can not empty!");
						document.MYFORM.elements["QTY_"+lineid+"."+j].focus();
						document.MYFORM.elements["QTY_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
						return false;
					}
					tot_qty+=eval(document.MYFORM.elements["QTY_"+lineid+"."+j].value);

					if (document.MYFORM.elements["REQTYPE_"+lineid].value!="Early Ship")
					{
						if (document.MYFORM.elements["REASONCODE_"+lineid+"."+j].value==null || document.MYFORM.elements["REASONCODE_"+lineid+"."+j].value=="--")
						{
							alert("Line"+(i)+":Please choose a reason!");
							document.MYFORM.elements["REASONCODE_"+lineid+"."+j].focus();
							document.MYFORM.elements["REASONCODE_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
							return false;
						}
						if (document.MYFORM.elements["REASONCODE_"+lineid+"."+j].value=="其他" && (document.MYFORM.elements["REMARKS_"+lineid+"."+j].value==null || document.MYFORM.elements["REMARKS_"+lineid+"."+j].value==""))
						{
							alert("Line"+(i)+":Please enter a remarks reason!");
							document.MYFORM.elements["REMARKS_"+lineid+"."+j].focus();
							document.MYFORM.elements["REMARKS_"+lineid+"."+j].style.backgroundColor="#FFCCCC";
							return false;
						}
					}
				}
				if (tot_qty!=eval(document.MYFORM.elements["SOURCE_QTY_"+lineid].value))
				{
					alert("Line"+(i)+":The New Order Qty("+tot_qty+") must be equals original qty("+document.MYFORM.elements["SOURCE_QTY_"+lineid].value+")!");
					document.MYFORM.elements["QTY_"+lineid+".1"].focus();
					return false;
				}
				chkcnt ++;
			}
		}
		if (chkcnt <=0)
		{
			alert("Please choose data!");
			return false;
		}

		document.getElementById("alpha").style.width=document.body.clientWidth;
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.MYFORM.btnQuery.disabled=true;
		document.MYFORM.btnExcel.disabled=true;
		document.MYFORM.btnUpload.disabled=true;
		if (document.MYFORM.save1 != undefined)
		{
			document.MYFORM.save1.disabled=true;
		}
		if (document.MYFORM.cancel1 != undefined)
		{
			document.MYFORM.cancel1.disabled=true;
		}
		if (document.MYFORM.exit1 != undefined)
		{
			document.MYFORM.exit1.disabled=true;
		}
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}

	function setSubmit1(URL)
	{
		var iLen=0,iRow=0,tot_qty=0;
		var chkvalue = false;
		var chkcnt =0;
		var lineid="";
		var chvalue="",so_line_id="";

		if (document.MYFORM.chk.length != undefined)
		{
			iLen = document.MYFORM.chk.length;
		}
		else
		{
			iLen = 1;
		}
		for (var i=1; i<= iLen ; i++)
		{
			if (iLen==1)
			{
				chkvalue =document.MYFORM.chk.checked;
				lineid = document.MYFORM.chk.value;
			}
			else
			{
				chkvalue = document.MYFORM.chk[i-1].checked;
				lineid = document.MYFORM.chk[i-1].value;
			}
			if (chkvalue==true)
			{
				chkcnt ++;
			}
		}
		if (chkcnt <=0)
		{
			alert("Please choose data!");
			return false;
		}

		if (confirm("您確定要取消Early Warning資料嗎?"))
		{
			document.getElementById("alpha").style.width=document.body.clientWidth;
			document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
			document.MYFORM.btnQuery.disabled=true;
			document.MYFORM.btnExcel.disabled=true;
			document.MYFORM.btnUpload.disabled=true;
			if (document.MYFORM.save1 != undefined)
			{
				document.MYFORM.save1.disabled=true;
			}
			if (document.MYFORM.cancel1 != undefined)
			{
				document.MYFORM.cancel1.disabled=true;
			}
			if (document.MYFORM.exit1 != undefined)
			{
				document.MYFORM.exit1.disabled=true;
			}
			document.MYFORM.action=URL;
			document.MYFORM.submit();
		}
	}
	function setObject(irow)
	{
		var chkvalue=false;
		var iLen=0;
		var totqty=0;
		if (document.MYFORM.elements["chk_"+irow].length != undefined)
		{
			iLen = document.MYFORM.elements["chk_"+irow].length;
			chkvalue=document.MYFORM.elements["chk_"+irow].value;
		}
		else
		{
			iLen = 1;
		}

		for (var i=1; i<= iLen ; i++)
		{
			if (document.MYFORM.elements["QTY_"+irow+"."+i].value==null)
			{
				totqty = totqty +eval(document.MYFORM.elements["SOURCE_QTY_"+irow].value);
			}
			else
			{
				totqty = totqty +eval(document.MYFORM.elements["QTY_"+irow+"."+i].value);
			}
			if (document.MYFORM.elements["QTY_"+irow+"."+i].value!="" || document.MYFORM.elements["SSD_"+irow+"."+i].value!="" || document.MYFORM.elements["REMARKS_"+irow+"."+i].value!="")
			{
				chkvalue=true;
				//break;
			}
		}

		if (document.MYFORM.chk.length != undefined)
		{
			if (document.MYFORM.chk[irow-1].checked != chkvalue)
			{
				document.MYFORM.chk[irow-1].checked = chkvalue;
				setCheck(irow);
			}
		}
		else
		{
			if (document.MYFORM.chk.checked != chkvalue)
			{
				document.MYFORM.chk.checked=chkvalue;
				setCheck(irow);
			}
		}
		//add by Peggy 20221124
		if (totqty < eval(document.MYFORM.elements["SOURCE_QTY_"+irow].value))
		{
			setAdd("../jsp/TSPCOrderReviseRequest.jsp?ATYPE=ADD&LID="+irow+"");
		}
	}
	function setRdoObject(rdoline,irow)
	{
		var chvalue="";
		var chkcnt=0;
		if (document.MYFORM.elements["rdo_"+rdoline].length ==undefined)
		{
			chvalue = document.MYFORM.elements["rdo_"+rdoline].value;
			if (document.MYFORM.elements["rdo_"+rdoline].checked)
			{
				if (chvalue=="Factory")
				{
					chkcnt++;
					document.getElementById(chvalue+"_"+rdoline).style.color="#3300CC";
				}
				else if (chvalue=="Sales")
				{
					chkcnt++;
					document.getElementById(chvalue+"_"+rdoline).style.color="#CC0033";
				}
				else
				{
					document.getElementById(chvalue+"_"+rdoline).style.color="#000000";
				}
			}
		}
		else
		{
			for (var k =0 ; k <document.MYFORM.elements["rdo_"+rdoline].length ;k++)
			{
				chvalue=document.MYFORM.elements["rdo_"+rdoline][k].value;
				if (document.MYFORM.elements["rdo_"+rdoline][k].checked)
				{
					if (chvalue=="Factory")
					{
						chkcnt++;
						document.getElementById(chvalue+"_"+rdoline).style.color="#3300CC";
					}
					else
					{
						chkcnt++;
						document.getElementById(chvalue+"_"+rdoline).style.color="#CC0033";
					}
				}
				else
				{
					document.getElementById(chvalue+"_"+rdoline).style.color="#000000";
				}
			}
		}
		if (document.MYFORM.chk.length != undefined)
		{
			if (chkcnt >0 && document.MYFORM.chk[irow-1].checked != true)
			{
				document.MYFORM.chk[irow-1].checked = true;
				setCheck(irow);
			}
		}
		else
		{
			if (chkcnt >0 && document.MYFORM.chk.checked != true)
			{
				document.MYFORM.chk.checked=true;
				setCheck(irow);
			}
		}
	}

</script>
<%
	String sql = "";
	String ATYPE = request.getParameter("ATYPE");
	if (ATYPE==null) ATYPE="";
	String LID = request.getParameter("LID");
	if (LID==null) LID="";
	String SEQID = request.getParameter("SEQID");
	if (SEQID==null) SEQID="";
	String strBackGround="color:#ff0000;";
	String screenWidth=request.getParameter("SWIDTH");
	if (screenWidth==null) screenWidth="0";
	String screenHeight=request.getParameter("SHEIGHT");
	if (screenHeight==null) screenHeight="0";
	String REQ_TYPE =request.getParameter("REQ_TYPE");
	if (REQ_TYPE==null) REQ_TYPE="";
	String MO_LIST = request.getParameter("MO_LIST");
	if (MO_LIST==null) MO_LIST="";
	String SALES_GROUP_LIST = request.getParameter("SALES_GROUP_LIST");
	if (SALES_GROUP_LIST==null)SALES_GROUP_LIST="";
	String ITEM_LIST = request.getParameter("ITEM_LIST");
	if (ITEM_LIST==null) ITEM_LIST="";
	String PLANTCODE = request.getParameter("PLANTCODE");
	if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
	if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale")<0)
	{
		PLANTCODE=userProdCenterNo;
	}
	String SSD_SDATE = request.getParameter("SSD_SDATE");
	if (SSD_SDATE==null) SSD_SDATE="";
	String SSD_EDATE = request.getParameter("SSD_EDATE");
	if (SSD_EDATE==null) SSD_EDATE="";
	String REASON_CODE=request.getParameter("REASON_CODE");
	if (REASON_CODE==null) REASON_CODE="";
	String rdo1=request.getParameter("rdo1");
	if(rdo1==null) rdo1="";
	String ew_show =request.getParameter("ew_show");
	if (ew_show==null) ew_show="";
	String v_orderno="",v_lineno="";
	String MOArry[][]=null;
	int irow=0,icol=20,i_line=0;

%>
<body>
<FORM ACTION="../jsp/TSPCOrderReviseRequest.jsp" METHOD="post" NAME="MYFORM">
	<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">PC Request to Revise Order</div>
	<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:12px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
	<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;">
		<br>
		<table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
			<tr>
				<td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
					<DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id='alpha' class='hidden' style='width:<%=screenWidth%>;height:<%=screenHeight%>;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
	<TABLE border="1" cellpadding="1" cellspacing="0" width="100%" bgcolor="#CEEAD7" bordercolorlight="#333366" bordercolordark="#ffffff">
		<tr>
			<td width="10%" style="font-size:11px" align="right">Plant Name：</td>
			<td width="18%" >
				<%
					try
					{
						sql = "select MANUFACTORY_NO,'('|| MANUFACTORY_NO||')'|| MANUFACTORY_NAME from oraddman.tsprod_manufactory a where MANUFACTORY_NO not in ('001','003','004') and ALNAME in ('Y','I','T','A','E') ";
						if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale")<0)
						{
							sql += " and a.MANUFACTORY_NO='"+userProdCenterNo+"'";
							PLANTCODE = userProdCenterNo;
						}
						sql += " order by 1";
						Statement st2=con.createStatement();
						ResultSet rs2=st2.executeQuery(sql);
						comboBoxBean.setRs(rs2);
						comboBoxBean.setFontSize(11);
						comboBoxBean.setFontName("Tahoma,Georgia");
						comboBoxBean.setSelection(PLANTCODE);
						comboBoxBean.setFieldName("PLANTCODE");
						if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale")<0)
						{
							comboBoxBean.setOnChangeJS("this.value="+'"'+userProdCenterNo+'"');
						}
						out.println(comboBoxBean.getRsString());
						rs2.close();
						st2.close();
					}
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
			</td>
			<td width="8%" style="font-size:11px" align="right" rowspan="3">MO#/Line#：</td>
			<td width="16%" rowspan="3"><textarea cols="30" rows="5" name="MO_LIST"  style="font-family: Tahoma,Georgia;font-size:12px" <%=(REQ_TYPE.equals("Overdue")?" disabled ":"")%>><%=MO_LIST%></textarea></td>
			<td width="8%" style="font-size:11px" align="right" rowspan="3">Area：</td>
			<td width="12%" rowspan="3"><textarea cols="25" rows="5" name="SALES_GROUP_LIST"  style="font-family: Tahoma,Georgia;font-size:12px" <%=(REQ_TYPE.equals("Overdue")?" disabled ":"")%>><%=SALES_GROUP_LIST%></textarea></td>
			<td width="8%" style="font-size:11px" align="right" rowspan="3">Part Number：</td>
			<td width="15%" rowspan="3"><textarea cols="25" rows="5" name="ITEM_LIST"  style="font-family: Tahoma,Georgia;font-size:12px" <%=(REQ_TYPE.equals("Overdue")?" disabled ":"")%>><%=ITEM_LIST%></textarea></td>
		</tr>
		<tr>
			<td style="font-size:11px" align="right">Request Type：</td>
			<td>
				<select NAME="REQ_TYPE" style="font-family: Tahoma,Georgia;font-size:11px" onChange="setReqType(this.value)">
					<OPTION VALUE="--" <%=(REQ_TYPE.equals("") || REQ_TYPE.equals("--") ?" selected ":"")%>>
					<OPTION VALUE="Early Ship" <%=(REQ_TYPE.equals("Early Ship")?" selected ":"")%>>Early Ship
					<OPTION VALUE="Overdue" <%=(REQ_TYPE.equals("Overdue")?" selected ":"")%>>Overdue
					<OPTION VALUE="Early Warning" <%=(REQ_TYPE.equals("Early Warning")?" selected ":"")%>>Early Warning
				</select>
				<div id="div_show" style="visibility:<%=(REQ_TYPE!=null && REQ_TYPE.equals("Early Warning")?"visible":"hidden")%>"><input type="checkbox" name="ew_show" value="Y" onChange="chk_show()" <%=(ew_show!=null && ew_show.equals("Y")?"CHECKED":"")%>>顯示Early Warning未確認資料</div>
			</td>
		</tr>
		<tr>
			<td style="font-size:11px" align="right">Schedule Ship Date：</td>
			<td><input type="TEXT" NAME="SSD_SDATE" value="<%=SSD_SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57" <%=(REQ_TYPE.equals("Overdue")?" disabled ":"")%>>
				<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SSD_SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
				<input type="TEXT" NAME="SSD_EDATE" value="<%=SSD_EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57" <%=(REQ_TYPE.equals("Overdue")?" disabled ":"")%>>
				<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SSD_EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
			</td>
		</tr>
		<tr>
			<td colspan="10" align="center">
				<input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:11px" onClick="setQuery('../jsp/TSPCOrderReviseRequest.jsp?ATYPE=Q')">
				&nbsp;&nbsp;
				<input type="button" name="btnExcel" value="Export to Excel"  style="visibility:<%=(REQ_TYPE.equals("Early Ship")?"hidden":"visible")%>;font-family:Tahoma,Georgia;font-size:11px" onClick="setExcel('<%=(REQ_TYPE.equals("Early Ship")?"../jsp/TSPCOrderRevisePullinExcel.jsp":"../jsp/TSPCOrderReviseExcel.jsp")%>')">
				&nbsp;&nbsp;
				<input type="button" name="btnUpload" value="Excel Upload"  style="font-family:Tahoma,Georgia;font-size:11px" onClick="setUpload()">
			</td>
		</tr>

	</TABLE>
	<hr>
	<%
		try
		{
			if (ATYPE.equals("Q"))
			{
				PCBean.setArray2DString(null);
				//sql = " SELECT TSC_INTERCOMPANY_PKG.GET_SALES_GROUP(NVL(TSC_OHA.HEADER_ID,OHA.HEADER_ID)) SALES_GROUP"+
				sql = " SELECT TSC_OM_Get_Sales_Group(NVL(TSC_OHA.HEADER_ID,OHA.HEADER_ID)) SALES_GROUP"+
						",OHA.ORG_ID"+
						",'('||ACS.ACCOUNT_NUMBER||')'||NVL(ACS.CUSTOMER_SNAME,ACS.CUSTOMER_NAME) CUSTOMER_NAME"+
						",OHA.HEADER_ID"+
						",OHA.ORDER_NUMBER"+
						//",OHA.VERSION_NUMBER"+
						",TO_NUMBER(OHA.ATTRIBUTE3) VERSION_NUMBER"+
						",OHA.TRANSACTIONAL_CURR_CODE CURR_CODE"+
						",OLA.LINE_ID"+
						",OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER LINE_NO"+
						",DECODE(OLA.ITEM_IDENTIFIER_TYPE,'CUST',OLA.ORDERED_ITEM,'') ORDERED_ITEM"+
						",MSI.SEGMENT1 ITEM_NAME"+
						",MSI.DESCRIPTION ITEM_DESC"+
						",TO_CHAR(OHA.ORDERED_DATE,'yyyymmdd') ORDERED_DATE"+
						",TO_CHAR(OLA.REQUEST_DATE,'yyyymmdd') REQUEST_DATE"+
						",TO_CHAR(OLA.SCHEDULE_SHIP_DATE,'yyyymmdd') SCHEDULE_SHIP_DATE"+
						",OLA.ORDERED_QUANTITY"+
						",OLA.FLOW_STATUS_CODE"+
						",NVL(OLA.CUSTOMER_LINE_NUMBER,OLA.CUST_PO_NUMBER) CUSTOMER_PO_NUMBER"+
						",OLA.CUSTOMER_SHIPMENT_NUMBER"+
						",LC.MEANING SHIPPING_METHOD_NAME"+
						",OLA.ATTRIBUTE20 HOLD_SHIPMENT"+
						",OLA.ATTRIBUTE5 HOLD_REASON"+
						",OLA.PACKING_INSTRUCTIONS"+
						",OLA.SHIP_FROM_ORG_ID"+
						//",CASE WHEN SUBSTR(OHA.ORDER_NUMBER,1,4)='1121' THEN 'CELINE' ELSE (SELECT DISTINCT res.resource_name FROM apps.jtf_rs_salesreps rs,apps.JTF_RS_RESOURCE_EXTNS_VL RES,hr_organization_units hou WHERE hou.organization_id = rs.org_id AND rs.resource_id = res.resource_id AND rs.salesrep_id(+)=NVL(TSC_OHA.salesrep_id,OHA.salesrep_id)) END SALES_NAME"+
						",(SELECT DISTINCT res.resource_name FROM apps.jtf_rs_salesreps rs,apps.JTF_RS_RESOURCE_EXTNS_VL RES,hr_organization_units hou WHERE hou.organization_id = rs.org_id AND rs.resource_id = res.resource_id AND rs.salesrep_id(+)=NVL(TSC_OHA.salesrep_id,OHA.salesrep_id)) SALES_NAME"+
						",to_char(OLA.LAST_UPDATE_DATE,'yyyymmdd') ORDER_LAST_UPDATE_DATE"+
						",TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,23) TSC_PACKAGE"+
						",TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,21) TSC_FAMILY"+
						",HIS.SO_QTY"+
						",CASE WHEN HIS.ASCRIPTION_BY='Sales' then  TO_CHAR(nvl(to_date(ola.ATTRIBUTE12,'yyyy/mm/dd'),HIS.SCHEDULE_SHIP_DATE),'YYYYMMDD') else TO_CHAR(HIS.SCHEDULE_SHIP_DATE,'YYYYMMDD') end NEW_SCHEDULE_SHIP_DATE"+ //先抓FORECASE SHIP DATE BY PEGGY 20230218
						",HIS.REMARKS"+
						",HIS.ASCRIPTION_BY"+
						",HIS.REASON_DESC"+
						",row_number() over ( order by  OLA.SCHEDULE_SHIP_DATE,OHA.ORDER_NUMBER,TO_NUMBER(OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER)) row_no"+
						",DENSE_RANK() OVER (ORDER BY ola.schedule_ship_date, oha.order_number,TO_NUMBER (ola.line_number || '.' || ola.shipment_number)) row_seq"+
						",count(1) over (partition by 1) TOT_CNT"+
						" FROM ONT.OE_ORDER_HEADERS_ALL OHA,"+
						" ONT.OE_ORDER_LINES_ALL OLA,"+
						//" AR_CUSTOMERS ACS,"+
						" TSC_CUSTOMER_ALL_V ACS,"+
						" INV.MTL_SYSTEM_ITEMS_B MSI,"+
						" (SELECT LOOKUP_CODE,MEANING FROM FND_LOOKUP_VALUES WHERE LANGUAGE='US' AND LOOKUP_TYPE='SHIP_METHOD') LC,"+
						" (SELECT HEADER_ID,ORDER_NUMBER,SALESREP_ID FROM ONT.OE_ORDER_HEADERS_ALL WHERE ORG_ID=41) TSC_OHA,"+
						" (SELECT HIS.* FROM (SELECT REQUEST_TYPE,SO_HEADER_ID,SO_LINE_ID,SO_QTY,SCHEDULE_SHIP_DATE,REASON_DESC,REMARKS,ASCRIPTION_BY,DENSE_RANK() OVER (PARTITION BY REQUEST_TYPE,SO_HEADER_ID,SO_LINE_ID ORDER BY REQUEST_NO DESC) ROW_SEQ FROM oraddman.tsc_om_salesorderrevise_pc X WHERE REQUEST_TYPE<>'Early Ship' AND REQUEST_TYPE='"+REQ_TYPE +"') HIS WHERE ROW_SEQ=1) HIS"+
						" WHERE ?01"+
						" AND OHA.HEADER_ID=OLA.HEADER_ID"+
						" AND OHA.ORDER_NUMBER=TSC_OHA.ORDER_NUMBER(+)"+
						" AND OHA.SOLD_TO_ORG_ID=ACS.CUSTOMER_ID"+
						" AND OLA.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID"+
						" AND OLA.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID"+
						" AND OLA.SHIPPING_METHOD_CODE=LC.LOOKUP_CODE"+
						" AND OLA.LINE_ID=HIS.SO_LINE_ID(+)"+
						//" AND OHA.ORDER_NUMBER IN ('11210029656','11410127086','11410127088','11310045359','11310045503')"+
						" AND OLA.FLOW_STATUS_CODE IN ('AWAITING_SHIPPING','AWAITING_APPROVE')";
				//" AND OLA.ATTRIBUTE20 IS NULL"+
				if (REQ_TYPE.equals("Overdue"))
				{
					sql += " AND OLA.SCHEDULE_SHIP_DATE < trunc(SYSDATE)";
				}
				else
				{
					sql += " AND OLA.SCHEDULE_SHIP_DATE >= trunc(SYSDATE)";

					if (!SSD_SDATE.equals("") || !SSD_EDATE.equals(""))
					{
						sql += " AND OLA.SCHEDULE_SHIP_DATE between TO_DATE(nvl('"+SSD_SDATE+"','20110101'),'YYYYMMDD') and TO_DATE(nvl('"+SSD_EDATE+"','20990101'),'YYYYMMDD')+0.99999";
					}
					if (!SALES_GROUP_LIST.equals(""))
					{
						String [] sArray =SALES_GROUP_LIST.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							if (x==0)
							{
								//sql += " and TSC_INTERCOMPANY_PKG.GET_SALES_GROUP(NVL(TSC_OHA.HEADER_ID,OHA.HEADER_ID)) in ( '"+sArray[x].trim()+"'";
								sql += " and TSC_OM_Get_Sales_Group(NVL(TSC_OHA.HEADER_ID,OHA.HEADER_ID)) in ( '"+sArray[x].trim()+"'";
							}
							else
							{
								sql += ",'"+sArray[x].trim()+"'";
							}
							if (x==sArray.length -1) sql += ")";
						}
					}

					if (!MO_LIST.equals(""))
					{
						String [] sArray = MO_LIST.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							v_orderno="";
							v_lineno="";
							if (sArray[x].trim().indexOf("/")>0)
							{
								v_orderno=sArray[x].trim().substring(0,sArray[x].trim().indexOf("/"));
								v_lineno=sArray[x].trim().substring(sArray[x].trim().indexOf("/")+1);
							}
							else
							{
								v_orderno=sArray[x].trim();
							}
							if (x==0)
							{
								sql += " and ((OHA.ORDER_NUMBER ='"+v_orderno+"'";
								if (!v_lineno.equals("")) sql += " and OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER='"+v_lineno+"'";
								sql += ")";
							}
							else
							{
								sql += " or (OHA.ORDER_NUMBER ='"+v_orderno+"'";
								if (!v_lineno.equals("")) sql += " and OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER='"+v_lineno+"'";
								sql += ")";
							}
							if (x==sArray.length -1) sql += ")";
						}
					}
					if (!ITEM_LIST.equals(""))
					{
						String [] sArray = ITEM_LIST.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							if (x==0)
							{
								sql += " and (upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
							}
							else
							{
								sql += " or upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
							}
							if (x==sArray.length -1) sql += ")";
						}
					}
					if (ew_show.equals("Y"))  //add by Peggy 20221130
					{
						sql += " and exists(select 1 from ORADDMAN.TSC_OM_SALESORDERREVISE_PC tosp where tosp.REQUEST_TYPE='"+REQ_TYPE+"' and tosp.STATUS='AWAITING_CONFIRM' and tosp.SO_LINE_ID=ola.line_id)";
					}
				}
				if (PLANTCODE.equals("002"))
				{
					sql= sql.replace("?01"," (OHA.ORG_ID =325 OR (OHA.ORG_ID=41 AND SUBSTR(OHA.ORDER_NUMBER,1,4) IN ('1156','1214'))) AND OLA.PACKING_INSTRUCTIONS='Y'");
				}
				else if (PLANTCODE.equals("005"))
				{
					sql= sql.replace("?01"," (OHA.ORG_ID =906 OR (OHA.ORG_ID=41 AND SUBSTR(OHA.ORDER_NUMBER,1,4) IN ('1142','1214') AND OLA.PACKING_INSTRUCTIONS='T') OR (OHA.ORG_ID=41 AND OLA.PACKING_INSTRUCTIONS='E')) AND TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003)='SSD'");
				}
				else if (PLANTCODE.equals("008"))
				{
					sql= sql.replace("?01"," (OHA.ORG_ID =906 OR (OHA.ORG_ID=41 AND SUBSTR(OHA.ORDER_NUMBER,1,4) IN ('1142','1214'))) AND OLA.PACKING_INSTRUCTIONS='T' AND TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003)='PRD-Subcon'");
				}
				else if (PLANTCODE.equals("006"))
				{
					sql= sql.replace("?01"," OHA.ORG_ID =41 AND OLA.PACKING_INSTRUCTIONS='I' AND TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003) IN ('PMD','PRD','PRD-Subcon')");
				}
				else if (PLANTCODE.equals("010"))
				{
					sql= sql.replace("?01"," OHA.ORG_ID =41 AND OLA.PACKING_INSTRUCTIONS='A' AND TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003) IN ('PMD','PRD','PRD-Subcon')");
				}
				else if (PLANTCODE.equals("011"))
				{
					String condiotion = "((OHA.ORG_ID =906 OR (OHA.ORG_ID=41 AND SUBSTR(OHA.ORDER_NUMBER,1,4) IN ('1142','1214')) AND OLA.PACKING_INSTRUCTIONS='T') \n" +
							"            OR ((OHA.ORG_ID=41 OR OHA.ORG_ID =906) \n" +
							"                AND OLA.PACKING_INSTRUCTIONS = \n" +
							"                    CASE\n" +
							"                        WHEN tsc_tew_pmd_coo(OLA.inventory_item_id) = 'Y'\n" +
							"                        THEN 'T' ELSE 'E' END\n" +
							"                )\n" +
							"         )\n" +
							"    AND TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003)IN ('PMD', 'PRD', 'PRD-Subcon')";
					sql= sql.replace("?01", condiotion);
				}
				sql += " ORDER BY OLA.SCHEDULE_SHIP_DATE,OHA.ORDER_NUMBER,TO_NUMBER(OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER),NVL(HIS.SCHEDULE_SHIP_DATE,OLA.SCHEDULE_SHIP_DATE)";
				//out.println(sql);
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);
				while (rs.next())
				{
					if (rs.getInt("row_no")==1)
					{
						MOArry=new String [rs.getInt("TOT_CNT")][icol];
					}
					irow=rs.getInt("row_no");
					MOArry[irow-1][0]=""+rs.getInt("row_seq");
					MOArry[irow-1][1]=rs.getString("ORDER_NUMBER");
					MOArry[irow-1][2]=rs.getString("LINE_NO");
					MOArry[irow-1][3]=rs.getString("ITEM_DESC");
					MOArry[irow-1][4]=rs.getString("SALES_GROUP");
					MOArry[irow-1][5]=rs.getString("CUSTOMER_NAME");
					MOArry[irow-1][6]=rs.getString("REQUEST_DATE");
					MOArry[irow-1][7]=rs.getString("SCHEDULE_SHIP_DATE");
					MOArry[irow-1][8]=rs.getString("ORDERED_QUANTITY");
					MOArry[irow-1][9]=rs.getString("HOLD_SHIPMENT");
					MOArry[irow-1][10]=rs.getString("HOLD_REASON");
					MOArry[irow-1][11]=rs.getString("NEW_SCHEDULE_SHIP_DATE");
					MOArry[irow-1][12]=rs.getString("SO_QTY");
					MOArry[irow-1][13]=(rs.getString("ASCRIPTION_BY")!=null && rs.getString("ASCRIPTION_BY").equals("Sales")?rs.getString("HOLD_REASON"):rs.getString("REMARKS"));
					MOArry[irow-1][14]=rs.getString("tot_cnt");
					//MOArry[irow-1][15]="checked";
					MOArry[irow-1][15]="";
					MOArry[irow-1][16]=(rs.getString("ASCRIPTION_BY")==null?(REQ_TYPE.equals("Overdue")?"":""):rs.getString("ASCRIPTION_BY"));
					MOArry[irow-1][17]=(rs.getString("REASON_DESC")==null?"":rs.getString("REASON_DESC"));
					MOArry[irow-1][18]=rs.getString("SHIPPING_METHOD_NAME");
					//MOArry[irow-1][19]="1";
				}
				PCBean.setArray2DString(MOArry);
				rs.close();
				statement.close();
			}
			else if (ATYPE.equals("ADD"))
			{
				int ifound=0;
				int iqty=0; //add by Peggy 20221124
				String tmpArry [][]=PCBean.getArray2DContent();
				MOArry=new String [tmpArry.length+1][icol];
				irow=0;
				String chk[]= request.getParameterValues("chk");
				for( int i=0 ; i<tmpArry.length ; i++ )
				{
					if (i==0 || tmpArry[i][0]!=tmpArry[i-1][0])
					{
						ifound=1;
					}
					else
					{
						ifound++;
					}

					MOArry[irow]=tmpArry[i];
					MOArry[irow][11]=(request.getParameter("SSD_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("SSD_"+tmpArry[i][0]+"."+ifound));
					MOArry[irow][12]=(request.getParameter("QTY_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("QTY_"+tmpArry[i][0]+"."+ifound));
					MOArry[irow][13]=(request.getParameter("REMARKS_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("REMARKS_"+tmpArry[i][0]+"."+ifound));
					MOArry[irow][15]="";
					MOArry[irow][16]=(request.getParameter("rdo_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("rdo_"+tmpArry[i][0]+"."+ifound));
					MOArry[irow][17]=(request.getParameter("REASONCODE_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("REASONCODE_"+tmpArry[i][0]+"."+ifound));
					if (chk !=null && chk.length >0)
					{
						for (int x =0 ; x < chk.length ;x++)
						{
							if (tmpArry[i][0].equals(chk[x]))
							{
								MOArry[irow][15]="checked";
								break;
							}
						}
					}
					if(MOArry[irow][12].matches("-?\\d+(\\.\\d+)?")){   //檢查是否為數字 add by JB 20241016
						iqty+= Integer.parseInt(MOArry[irow][12]);  //add by Peggy 20221124
					}
					if (tmpArry[i][0].equals(LID) && (i==tmpArry.length-1 || (i!=(tmpArry.length-1) && tmpArry[i][0]!=tmpArry[i+1][0])))
					{
						irow++;
						for (int j=0 ; j < tmpArry[i].length ; j++)
						{
							if (j==11 || j ==12 || j==13 || j==16 || j==17)
							{
								if (REQ_TYPE.equals("Early Ship") && j==16)
								{
									MOArry[irow][j]="Factory";
								}
								else
								{
									if (j==11)
									{
										MOArry[irow][j]=(request.getParameter("SOURCE_SSD_"+tmpArry[i][0])==null?"":request.getParameter("SOURCE_SSD_"+tmpArry[i][0]));
									}
									else if (j==12)
									{
										if (Integer.parseInt(MOArry[irow][8])-iqty>0)
										{
											MOArry[irow][j] =""+(Integer.parseInt(MOArry[irow][8])-iqty);
										}
										else
										{
											MOArry[irow][j]="";
										}
									}
									else
									{
										MOArry[irow][j]="";
									}
								}
							}
							else
							{
								MOArry[irow][j]=tmpArry[i][j];
							}
						}
						LID="";
					}

					irow++;
				}
				PCBean.setArray2DString(MOArry);
			}
			else if (ATYPE.equals("DEL"))
			{
				int ifound=0;
				String tmpArry [][]=PCBean.getArray2DContent();
				MOArry=new String [tmpArry.length-1][icol];
				String chk[]= request.getParameterValues("chk");
				irow=0;
				for( int i=0 ; i<tmpArry.length ; i++ )
				{
					if (i==0 || tmpArry[i][0]!=tmpArry[i-1][0]) ifound=1;

					if (tmpArry[i][0].equals(LID))
					{
						if (!(""+ifound).equals(SEQID))
						{
							MOArry[irow]=tmpArry[i];
							MOArry[irow][11]=(request.getParameter("SSD_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("SSD_"+tmpArry[i][0]+"."+ifound));
							MOArry[irow][12]=(request.getParameter("QTY_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("QTY_"+tmpArry[i][0]+"."+ifound));
							MOArry[irow][13]=(request.getParameter("REMARKS_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("REMARKS_"+tmpArry[i][0]+"."+ifound));
							MOArry[irow][16]=(request.getParameter("rdo_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("rdo_"+tmpArry[i][0]+"."+ifound));
							MOArry[irow][17]=(request.getParameter("REASONCODE_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("REASONCODE_"+tmpArry[i][0]+"."+ifound));
							if (chk !=null && chk.length >0)
							{
								for (int x =0 ; x < chk.length ;x++)
								{
									if (tmpArry[i][0].equals(chk[x]))
									{
										MOArry[irow][15]="checked";
										break;
									}
								}
							}
							irow++;ifound++;
						}
						else
						{
							ifound++;
						}
					}
					else
					{
						MOArry[irow]=tmpArry[i];
						MOArry[irow][11]=(request.getParameter("SSD_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("SSD_"+tmpArry[i][0]+"."+ifound));
						MOArry[irow][12]=(request.getParameter("QTY_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("QTY_"+tmpArry[i][0]+"."+ifound));
						MOArry[irow][13]=(request.getParameter("REMARKS_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("REMARKS_"+tmpArry[i][0]+"."+ifound));
						MOArry[irow][16]=(request.getParameter("rdo_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("rdo_"+tmpArry[i][0]+"."+ifound));
						MOArry[irow][17]=(request.getParameter("REASONCODE_"+tmpArry[i][0]+"."+ifound)==null?"":request.getParameter("REASONCODE_"+tmpArry[i][0]+"."+ifound));
						if (chk !=null && chk.length >0)
						{
							for (int x =0 ; x < chk.length ;x++)
							{
								if (tmpArry[i][0].equals(chk[x]))
								{
									MOArry[irow][15]="checked";
									break;
								}
							}
						}
						irow++;ifound++;
					}
				}
				PCBean.setArray2DString(MOArry);
			}
			else
			{
				PCBean.setArray2DString(null);
			}

			MOArry=PCBean.getArray2DContent();

			if (MOArry!=null)
			{
				for( int i=0 ; i<MOArry.length ; i++ )
				{
					if ( i==0)
					{

	%>
	<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
		<tr style="background-color:#B4C1EF;">
			<td width="2%" rowspan="2" align="center">&nbsp;</td>
			<td width="6%" rowspan="2" align="center">M/O No</td>
			<td width="3%" rowspan="2" align="center">Line No</td>
			<td width="9%" rowspan="2" align="center">Part Number</td>
			<td width="5%" rowspan="2" align="center">Area</td>
			<td width="9%" rowspan="2" align="center">Customer</td>
			<td width="5%" rowspan="2" align="center">CRD</td>
			<td width="5%" rowspan="2" align="center">Schedule<br>Ship Date</td>
			<td width="4%" rowspan="2" align="center">Order Qty</td>
			<td width="4%" rowspan="2" align="center">Shipping Method</td>
			<td width="3%" rowspan="2" align="center" style="color:#000000;background-color:#FFFF33;">Hold</td>
			<td width="5%" rowspan="2" align="center" style="color:#000000;background-color:#FFFF33;">Hold Reason</td>
			<td width="2%" rowspan="2" align="center" style="background-color:#F36C2C;"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
			<td width="6%" rowspan="2" align="center" style="background-color:#F36C2C;">Request Type</td>
			<td width="31%" align="center" colspan="5" style="background-color:#F36C2C;">Request Info</td>
		</tr>
		<tr>
			<td width="6%" align="center" style="background-color:#F36C2C;">Ascription By</td>
			<td width="7%" align="center" style="background-color:#F36C2C;">New Schedule<br>Ship Date</td>
			<td width="5%" align="center" style="background-color:#F36C2C;"><p>New<br>Order Qty</p></td>
			<td width="13%" align="center" style="background-color:#F36C2C;" colspan="2">Remarks</td>
		</tr>
		<%
			}

			if (i == 0 || !MOArry[i][0].equals(MOArry[i-1][0]))
			{
				i_line=1;
		%>
		<tr id="tr_<%=MOArry[i][0]%>" style="background-color:<%=(MOArry[i][15].equals("")?"#ffffff":"#D9E8E3")%>">
			<td align="center"><%=MOArry[i][0]%></td>
			<td align="center"><%=MOArry[i][1]%><input type="hidden" name="SONO_<%=MOArry[i][0]%>" value="<%=MOArry[i][1]%>"></td>
			<td align="center"><%=MOArry[i][2]%><input type="hidden" name="SOLINE_<%=MOArry[i][0]%>" value="<%=MOArry[i][2]%>"></td>
			<td><%=MOArry[i][3]%></td>
			<td align="center"><%=MOArry[i][4]%></td>
			<td><%=MOArry[i][5]%></td>
			<td align="center"><%=MOArry[i][6]%></td>
			<td align="center"><%=MOArry[i][7]%><input type="hidden" name="SOURCE_SSD_<%=MOArry[i][0]%>" value="<%=MOArry[i][7]%>"></td>
			<td align="right"><%=MOArry[i][8]%><input type="hidden" name="SOURCE_QTY_<%=MOArry[i][0]%>" value="<%=MOArry[i][8]%>"></td>
			<td align="center"><%=(MOArry[i][18]==null?"&nbsp;":MOArry[i][18])%></td>
			<td align="center"><%=(MOArry[i][9]==null?"&nbsp;":MOArry[i][9])%></td>
			<td><%=(MOArry[i][10]==null?"&nbsp;":MOArry[i][10])%></td>
			<td id="tda_<%=MOArry[i][0]%>" align="center"><input type="checkbox" name="chk" value="<%=MOArry[i][0]%>" onClick="setCheck('<%=MOArry[i][0]%>')" <%=MOArry[i][15]%>></td>
			<td align="center">
				<input type="TEXT" NAME="REQTYPE_<%=MOArry[i][0]%>" value="<%=(REQ_TYPE==null?"":REQ_TYPE)%>" style="text-align:center;font-size:11px;font-family: Tahoma,Georgia;background-color:<%=(MOArry[i][15].equals("")?"#ffffff":"#D9E8E3")%>" size="9" readonly>&nbsp;<img border="0" src="images/ico6.gif" title="add new line" onClick="setAdd('../jsp/TSPCOrderReviseRequest.jsp?ATYPE=ADD&LID=<%=MOArry[i][0]%>')">
			</td>
			<td align="center" colspan="5">
				<%
					}

				%>
				<table width="100%" border="0">
					<tr>
						<td width="20%"><div id="<%="Factory_"+MOArry[i][0]+"."+i_line%>" style="color:<%=(MOArry[i][16].equals("Factory")?"#3300CC":"#000000")%>;font-family: Tahoma,Georgia"><input type="radio" name="rdo_<%=MOArry[i][0]+"."+i_line%>"  value="Factory" onClick="setRdoObject('<%=MOArry[i][0]+"."+i_line%>','<%=MOArry[i][0]%>')" <%=(MOArry[i][16].equals("Factory")?"checked":"")%>>Factory</div>
							<%
								if (REQ_TYPE.equals("Overdue"))
								{
							%>
							<div id="<%="Sales_"+MOArry[i][0]+"."+i_line%>" style="color:<%=(MOArry[i][16].equals("Sales")?"#CC0033":"#000000")%>;font-family: Tahoma,Georgia"><input type="radio" name="rdo_<%=MOArry[i][0]+"."+i_line%>" value="Sales" onClick="setRdoObject('<%=MOArry[i][0]+"."+i_line%>','<%=MOArry[i][0]%>')" <%=(MOArry[i][16].equals("Sales")?"checked":"")%>>Sales</div>
							<%
								}
							%>
						</td>
						<td width="22%" align="center"><input type="TEXT" NAME="SSD_<%=MOArry[i][0]+"."+i_line%>" value="<%=(MOArry[i][11]==null?"":MOArry[i][11])%>" size="12" onBlur="setObject(<%=MOArry[i][0]%>)" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" style="text-align:center;font-size:11px;font-family: Tahoma,Georgia;background-color:<%=(MOArry[i][15].equals("")?"#ffffff":"#D9E8E3")%>"><input type="hidden" name="NEW_SSD_<%=MOArry[i][0]+"."+i_line%>" value="<%=(MOArry[i][11]==null?"":MOArry[i][11])%>"></td>
						<td width="19%" align="center"><input type="TEXT" NAME="QTY_<%=MOArry[i][0]+"."+i_line%>" value="<%=(MOArry[i][12]==null?"":MOArry[i][12])%>" size="7" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" onBlur="setObject(<%=MOArry[i][0]%>)" style="text-align:right;font-size:11px;font-family: Tahoma,Georgia;background-color:<%=(MOArry[i][15].equals("")?"#ffffff":"#D9E8E3")%>"><input type="hidden" name="NEW_QTY_<%=MOArry[i][0]+"."+i_line%>" value="<%=(MOArry[i][12]==null?"":MOArry[i][12])%>"></td>
						<td width="38%">
							<%
								if (REQ_TYPE.equals("Overdue") ||  REQ_TYPE.equals("Early Warning"))
								{
									try
									{
										//sql = "select  a.a_value,a.a_value from oraddman.tsc_rfq_setup a where A_CODE='"+userProdCenterNo+"_Overdue' order by A_SEQ";
										sql = "select  a.a_eng_value,a.a_eng_value from oraddman.tsc_rfq_setup a where A_CODE='PC_Overdue' order by A_SEQ";
										Statement st2=con.createStatement();
										ResultSet rs2=st2.executeQuery(sql);
										comboBoxBean.setRs(rs2);
										comboBoxBean.setFontSize(11);
										comboBoxBean.setFontName("Tahoma,Georgia");
										comboBoxBean.setSelection((MOArry[i][17]==null?"":MOArry[i][17]));
										comboBoxBean.setFieldName("REASONCODE_"+MOArry[i][0]+"."+i_line);
										comboBoxBean.setOnChangeJS("");
										out.println(comboBoxBean.getRsString());
										rs2.close();
										st2.close();
									}
									catch (Exception e)
									{
										out.println("Exception:"+e.getMessage());
									}
								}
							%>
							<input type="TEXT" NAME="REMARKS_<%=MOArry[i][0]+"."+i_line%>" value="<%=(MOArry[i][13]==null?"":MOArry[i][13])%>" size="24" style="font-size:11px;font-family: Tahoma,Georgia;background-color:<%=(MOArry[i][15].equals("")?"#ffffff":"#D9E8E3")%>"><input type="hidden" name="NEW_REMARKS_<%=MOArry[i][0]+"."+i_line%>" value="<%=(MOArry[i][13]==null?"":MOArry[i][13])%>" onBlur="setObject(<%=MOArry[i][0]%>)">
						</td>
						<td width="1%"><input type="checkbox" name="chk_<%=MOArry[i][0]%>" value="<%=MOArry[i][0]+"."+i_line%>"  style="width:3;visibility:hidden" checked><img border="0" src="images/delete.png" height="12" title="delete data" onClick="setDelete('../jsp/TSPCOrderReviseRequest.jsp?ATYPE=DEL&LID=<%=MOArry[i][0]%>&SEQID=<%=i_line%>')"></td>
					</tr>
				</table>
				<%
					i_line++;
					if (i==MOArry.length-1 || (i!=MOArry.length-1 && !MOArry[i][0].equals(MOArry[i+1][0])))
					{
				%>
			</td>
		</tr>
		<%
			}
		%>
		<%
			if (i==MOArry.length-1)
			{
		%>
	</table>
	<hr>
	<table border="0" width="100%" bgcolor="#CEEAD7">
		<tr>
			<td align="center">
				<input type="button" name="save1" value="Submit" onClick='setSubmit("../jsp/TSPCOrderReviseProcess.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia;">
				&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="Cancel" onClick='setSubmit1("../jsp/TSPCOrderReviseProcess.jsp?ACODE=CANCEL")' style="font-family: Tahoma,Georgia;">
				&nbsp;&nbsp;&nbsp;<input type="button" name="exit1" value="Exit" onClick='setClose()' style="font-family: Tahoma,Georgia;">
			</td>
		</tr>
	</table>
	<hr>
	<%
					}
				}
			}
			else
			{
				if (!ATYPE.equals(""))	out.println("<div align='center'  style='color:#0000ff'>not data found!</div>");
			}
		}
		catch (Exception e)
		{
			out.println("<DIV align='center' style='font-size:12px;color:#ff0000'>Exception1:"+e.getMessage()+"</div>");
		}
	%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

