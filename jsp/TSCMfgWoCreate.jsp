<!-- 20151026 liling 增加 custtype=1-->
<!-- 20190614 liling ADD ONSEMI CUSTOMER LOT RULE-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayWODocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=================================-->
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
	var checkflag = "false";
	document.onclick=function(e)
	{
		var t=!e?self.event.srcElement.name:e.target.name;
		if (t!="popcal")
			gfPop.fHideCal();

	}
	// 限制使用者直接按 F5 重新整理,導致 arrayBean 取值異常的問題
	//function document.onkeydown()
	//{
	//    if (event.keyCode==116)
	//   {
	//        event.keyCode = 0;
	//       event.cancelBubble = true;
	//        return false;
	//    }
	//}
	//
	function check(field)
	{
		if (checkflag == "false") {
			for (i = 0; i < field.length; i++) {
				field[i].checked = true;}
			checkflag = "true";
			return "Cancel Selected"; }
		else {
			for (i = 0; i < field.length; i++) {
				field[i].checked = false; }
			checkflag = "false";
			return "Select All"; }
	}

	function setSubmit(URL)
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}

	function setSubmit3(URL)    //array delete
	{
		document.MYFORM.WOQTY.value ="";
		document.MYFORM.WOUOM.value ="";
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}

	function setSubmitAdd(URL,woType)
	{
		if (document.MYFORM.MFGDEPTNO.value==null ||  document.MYFORM.MFGDEPTNO.value=="--")
		{
			alert("              部門別不得為空值\n系統已預設帶入您所屬部門資訊,請勿變更!!!");
			document.MYFORM.MFGDEPTNO.focus();
			return(false);
		}

		if ( document.MYFORM.MARKETTYPE.value==null ||  document.MYFORM.MARKETTYPE.value=="--")
		{
			alert("Please Choose the MARKET TYPE!!");
			document.MYFORM.MARKETTYPE.focus();
			return(false);
		}
		if ( document.MYFORM.WOTYPE.value==null ||  document.MYFORM.WOTYPE.value=="--")
		{
			alert("Please Choose the Work Order Type!!");
			document.MYFORM.WOTYPE.focus();
			return(false);
		} else if (document.MYFORM.WOTYPE.value=="1")
		{
			/*
                  if (document.MYFORM.WAFERLOT.value=="" || document.MYFORM.WAFERIQCNO.value=="")
                  {
                    alert("切割及前段工令之晶片批號及檢驗單號,此二欄位為必填\n          請您由查詢鈕選擇晶片批來源為輸入依據!!!");
                    window.document.MYFORM.DICESIZECH.focus();
                    return(false);
                  }
           */
			//
			if (document.MYFORM.WAFERUSEDPCE.value==null || document.MYFORM.WAFERUSEDPCE.value=="")
			{
				alert("切割工令請務必輸下線片數資訊!!!");
				document.MYFORM.WAFERUSEDPCE.focus();
				return(false);
			}
		} else if (document.MYFORM.WOTYPE.value=="2")
		{
			if (document.MYFORM.WAFERLOT.value=="" || document.MYFORM.WAFERIQCNO.value=="")
			{
				alert("切割及前段工令之晶片批號及檢驗單號,此二欄位為必填\n          請您由查詢鈕選擇晶片批來源為輸入依據!!!");
				window.document.MYFORM.DICESIZECH.focus();
				return(false);
			}
		}
		else if (document.MYFORM.WOTYPE.value=="3") // 後段工令限制條件
		{
			if (document.MYFORM.ALTERNATEROUTING.value=="2")
			{}   // 若手動開立有庫存MO單 Mark 此段落_起
			else if (window.document.MYFORM.FRONTRUNCARD.value==null || document.MYFORM.OEORDERNO.value=="" || document.MYFORM.OELINEQTY.value=="" || document.MYFORM.CUSTOMERNAME.value=="")
			{
				alert("不允許後段工令無銷售訂單資訊(訂單號、項次數量及客戶資訊),這些欄位為必填項目\n    請您由查詢鈕選擇前段完工工令為輸入依據,並選擇可開立工令之銷售訂單!!!");
				//window.document.MYFORM.FRONTRUNCARD.focus();
				if (window.document.MYFORM.SEMIITEMID.value==null)
				{
					subWinFrontRunCardFindCheck(document.MYFORM.FRONTRUNCARD.value,document.MYFORM.MARKETTYPE.value,document.MYFORM.INVITEM.value,document.MYFORM.ITEMDESC.value,document.MYFORM.OEORDERNO.value,document.MYFORM.ITEMID.value,document.MYFORM.SEMIITEMID.value,document.MYFORM.ALTERNATEROUTING.value);
				} else { // subWinMoFindCheck(invItemNo,invItemDesc,oeOrderNo,marketType,semiItemID,runCardNo,oeLineQty,alternateRouting)

					subWinMoFindCheck(document.MYFORM.INVITEM.value,document.MYFORM.ITEMDESC.value,document.MYFORM.OEORDERNO.value,document.MYFORM.MARKETTYPE.value,document.MYFORM.SEMIITEMID.value,window.document.MYFORM.FRONTRUNCARD.value,window.document.MYFORM.OELINEQTY.value,window.document.MYFORM.ALTERNATEROUTING.value);

				}
				return(false);
			}
			// 若手動開立有庫存MO單 Mark 此段落_迄

		} else if (document.MYFORM.WOTYPE.value=="7") // 請輸入工程實驗用晶片批號
		{
			if (document.MYFORM.WAFERLOT.value==null || document.MYFORM.WAFERLOT.value=="")
			{
				alert("       為生產資訊完整\n請輸入工程實驗用晶片批號!!!");
				return false;
			}
		}

		if ( document.MYFORM.ALTERNATEROUTING.value==null || document.MYFORM.ALTERNATEROUTING.value=="--")
		{
			alert("Please Choose the Alternate Routing!!");
			document.MYFORM.ALTERNATEROUTING.focus();
			return(false);
		}

		if ( document.MYFORM.WOQTY.value==null || document.MYFORM.WOQTY.value=="" || document.MYFORM.WOQTY.value=="0" || document.MYFORM.WOQTY.value=="0.0")
		{
			alert("The Work Qty cannot be '0' !!");
			document.MYFORM.WOQTY.focus();
			return(false);
		} else if (document.MYFORM.INVITEM.value==null || document.MYFORM.INVITEM.value=="")
		{
			alert("請輸入工令生產料號資訊!!!");
			document.MYFORM.INVITEM.focus();
			return(false);
		}
		else if (document.MYFORM.WOUOM.value==null || document.MYFORM.WOUOM.value=="")
		{
			alert("請輸入工令生產數量對應單位資訊!!!");
			document.MYFORM.WOUOM.focus();
			return(false);
		}

		txt1=document.MYFORM.WOQTY.value;	    //檢查工令數量是否為數字
		for (j=0;j<txt1.length;j++)
		{
			c=txt1.charAt(j);
			if ("0123456789.".indexOf(c,0)<0)
			{
				alert("The work Qty that you inputed should be numerical!!");
				document.MYFORM.WOQTY.focus();
				return(false);
			}
		}

		// 判斷工令單位用量是否有輸入,否則警告
		if (document.MYFORM.WOUNITQTY.value==null || document.MYFORM.WOUNITQTY.value=="")
		{
			alert("請務必輸入工令製成品單位用量資訊!!!");
			document.MYFORM.WOUNITQTY.focus();
			return(false);
		}

		// 判斷工令單位是否為'KPC',否則警告  20100414
		if (document.MYFORM.WOUOM.value=="PCE" || document.MYFORM.WOUOM.value=="PCE")
		{
			alert("請確認此料號單位PCE是否正確!!!");
			document.MYFORM.WOUOM.focus();
			return(false);
		}

		// 判斷工令入庫倉別,否則警告
		if (document.MYFORM.SUBINVENTORY.value==null || document.MYFORM.SUBINVENTORY.value=="")
		{
			alert("請務必輸入入庫倉別!!!");
			document.MYFORM.SUBINVENTORY.focus();
			return(false);
		}



		/*
         txt2=document.MYFORM.WOUNITQTY.value;	    //檢查工單位用數量是否為數字
         for (k=0;k<txt2.length;j++)
         {
           c=txt2.charAt(k);
           if ("0123456789.".indexOf(c,0)<0)
           {
           alert("工令單位用量應為數值型態,請重新輸入!!");
           document.MYFORM.WOUNITQTY.focus();
           return(false);
           }
         }
         */
		document.MYFORM.action=URL;
		document.MYFORM.submit();
		//document.MYFORM.WOTYPE.value="";
	}

	function setSubmitSave(URL,altBomSeqID,routingRefID)
	{
		//判斷料號是否有設lot control
		if (document.MYFORM.LOTCONTROL.value==1 || document.MYFORM.LOTCONTROL.value=="1")
		{
			alert("此料號無設定批號控管,請通知工程或MIS啟動!!!");
			// document.MYFORM.SUBINVENTORY.focus();
			return(false);
		}

		// 2007/08/12 特殊客戶批號警告訊息_起
		// if (document.MYFORM.WOTYPE.value =="3" && document.MYFORM.CUSTLOTALERT.value=="Y")
		if (document.MYFORM.CUSTLOTALERT.value=="Y")   //20121222 liling 改善FSC料號要ALTER '特殊批號'
		{


			//  alert("此銷售訂單對應客戶存在產生客戶批號需求\n            您未選擇正確客戶批號!!!");
			//  document.MYFORM.CUSTTYPE.focus();
			//  return(false);
			if (document.MYFORM.CUSTTYPE.value == "0")  //alert =Y,且又沒選到客戶批號1就詢問  20151026 加if
			{
				flag=confirm("此銷售訂單對應客戶存在產生客戶批號需求\n            是否選擇更改為客戶批號!!!?");
				if (flag==false)
				{
					document.MYFORM.CUSTTYPE.value = "0"; // 表示不產生客戶批號
					document.MYFORM.CUSTLOTALERT.value = "N";
					//return(true);
				}
				else {
					document.MYFORM.CUSTTYPE.value = "1";
					document.MYFORM.CUSTLOTALERT.value = "Y";
					//return(true);
				}
			}
		}
		// 2007/08/12 特殊客戶批號警告訊息_迄

		if (document.MYFORM.WOTYPE.value !="4")
		{
			if (altBomSeqID==null || altBomSeqID=="" || altBomSeqID=="0" || routingRefID==null || routingRefID=="" || routingRefID=="0")
			{
				alert("此工令製成品的料號無BOM表或Routing於Oracle系統,您不能儲存此工令!!!");
				return false;
			} else {
				flag=confirm("是否確認儲存工令?");
				if (flag==false) return(false);
				else {
					/// 如為外購工令再判斷
					if (document.MYFORM.ALTERNATEROUTING.value=="2")
					{
						if (document.MYFORM.OPSUPPLIERLOT.value==null || document.MYFORM.OPSUPPLIERLOT.value=="")
						{  // 未使用選擇外購工令子視窗,避免後段生產時無法寫入廠商批號
							alert("您未使用選擇外購工令廠商半成品批號\n     無廠商批號不能產生外購工令!!!");
							return false;
						}
						else
						{ // 使用者選到外購工令之廠商批號
							if (document.MYFORM.ALTBOMSEQID.value==null || document.MYFORM.ALTBOMSEQID.value=="" || document.MYFORM.ROUTINGREFID.value==null || document.MYFORM.ROUTINGREFID.value=="")
							{
								flag=confirm("此為外購工令,您確定不選擇自製BOM及Routing嗎?");
								if (flag==false) return(false);
								else { // 外購工令
									document.MYFORM.action=URL;
									document.MYFORM.submit();
								}
							} // End of if
						}
					} else { // 一般自製工令
						document.MYFORM.action=URL;
						document.MYFORM.submit();
					}
				}
			} //End of else	 有BOM 表的
		}
		else
		{
			flag=confirm("是否確認儲存工令?");
			if (flag==false) return(false);
			else {
				document.MYFORM.action=URL;
				document.MYFORM.submit();
			}
		}

	}

	function setItemFindCheck(invItem,itemDesc,organizationId)
	{
		if (event.keyCode==13)
		{
			subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&ORGANIZATIONID="+organizationId,"subwin","width=640,height=480,scrollbars=yes");
			//  subWin=window.open("../jsp/subwindow/TSMfgItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}
	}

	function subWindowItemFind(invItem,itemDesc,organizationId)
	{
		subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&ORGANIZATIONID="+organizationId,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
	}

	function subWindowBomRefFind(organizationId,itemId)
	{
		//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationId+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");
		//subWin=window.open("../jsp/subwindow/TSMfgBomRoutingFind.jsp?ORGANIZATIONID="+organizationId+"&PRIMARYITEMID="+itemId+"&ROUTINGREFID="+routingRefID+"&ALTROUTINGDEST="+altRoutingDest,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");
		subWin=window.open("../jsp/subwindow/TSMfgBomFind.jsp?ORGANIZATIONID="+organizationId+"&PRIMARYITEM="+document.MYFORM.INVITEM.value,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes,menubar=yes");
	}


	function subWindowRoutingRefFind(organizationId,invItem)
	{
		//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationId+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");
		//subWin=window.open("../jsp/subwindow/TSMfgBomRoutingFind.jsp?ORGANIZATIONID="+organizationId+"&PRIMARYITEMID="+itemId+"&ROUTINGREFID="+routingRefID+"&ALTROUTINGDEST="+altRoutingDest,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");
		//subWin=window.open("../jsp/subwindow/TSMfgBomRoutingFind.jsp?ORGANIZATIONID="+organizationId+"&PRIMARYITEMID="+itemId+"&ROUTINGREFID="+routingRefID+"&ALTROUTINGDEST="+altRoutingDest,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");
		subWin=window.open("../jsp/subwindow/TSMfgRoutingFind.jsp?ORGANIZATIONID="+organizationId+"&PRIMARYITEM="+document.MYFORM.INVITEM.value,"subwin","width=640,height=480,status=yes,scrollbars=yes,resizable=yes");
	}

	// 用前段工令需求的晶粒產品型號去找可用的合格檢驗批晶片_
	function setFrontProdNameFindCheck(invItem,itemDesc,waferResist,diceSize,waferLot,woType,marketType,mfgDeptNo,prodSource)
	{
		//alert("diceSize="+diceSize);
		if (event.keyCode==13)
		{ alert("1");
			//if (waferResist!=null && waferResist!="" && diceSize!=null && diceSize!="")
			//{
			if (woType=="1")
			{
				subWin=window.open("../jsp/subwindow/TSMfgWaferCharactFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes,toolbar=yes");
			} else if (woType=="2") // 前段工令,區分來源
			{  //alert("2");
				if (mfgDeptNo=="1") // 製造一部,來源一律是IQC收料
				{
					subWin=window.open("../jsp/subwindow/TSMfgWaferCharactFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes,toolbar=yes");
				} else if (mfgDeptNo=="2")   // 製造二部,來源可能是IQC收料或製造二部完工工令
				{ //alert("3");
					if (prodSource=="--" || prodSource=="1")
					{	//alert("4");
						subWin=window.open("../jsp/subwindow/TSMfgWaferCharactFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes,toolbar=yes");
					} else if (prodSource=="2")
					{ //alert("5");
						subWin=window.open("../jsp/subwindow/TSMfgWaferWipFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType+"&MFGDEPTNO="+mfgDeptNo+"&PRODSOURCE="+prodSource,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
					}
					else if (mfgDeptNo=="3")   // 製造三部
					{
						subWin=window.open("../jsp/subwindow/TSMfgWaferCharactFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes,toolbar=yes");
					}
				} // end else if (mfgDeptNo=="2")
			} // End of if (woType=="2")
			// } else {
			//          alert("請確實輸入電阻係數及切割尺寸作查詢!!!");
			//		  if (document.MYFORM.WFRESIST.value==null) document.MYFORM.WFRESIST.focus();
			//		  else document.MYFORM.DICESIZE.focus();
			//       }
//    subWin=window.open("../jsp/subwindow/TSMfgWaferLotFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WAFERLOTNO="+waferLotNo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}
	}
	// 用前段工令需求的晶粒產品型號去找可用的合格檢驗批晶片_迄
	function subWinFrontProdNameFindCheck(invItem,itemDesc,waferResist,diceSize,waferLot,woType,marketType,mfgDeptNo,prodSource,supplierLot)
	{
		// if (waferResist!=null && waferResist!="" && diceSize!=null && diceSize!="")
		// {
		//alert("diceSize="+diceSize);
		if (woType=="1") // 切割工令
		{
			subWin=window.open("../jsp/subwindow/TSMfgWaferCharactFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType+"&SUPPLIERLOT="+supplierLot,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes,toolbar=yes");
		} else if (woType=="2") // 前段工令,區分來源
		{
			if (mfgDeptNo=="1") // 製造一部,來源一律是IQC收料
			{
				subWin=window.open("../jsp/subwindow/TSMfgWaferCharactFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType+"&SUPPLIERLOT="+supplierLot,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes,toolbar=yes");
			} else if (mfgDeptNo=="2")   // 製造二部,來源可能是IQC收料或製造二部完工工令
			{
				if (prodSource=="--" || prodSource=="1")
				{
					subWin=window.open("../jsp/subwindow/TSMfgWaferCharactFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType+"&SUPPLIERLOT="+supplierLot,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes,toolbar=yes");
				} else if (prodSource=="2")
				{
					subWin=window.open("../jsp/subwindow/TSMfgWaferWipFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType+"&MFGDEPTNO="+mfgDeptNo+"&PRODSOURCE="+prodSource+"&SUPPLIERLOT="+supplierLot+"&CELLSOURCE="+document.MYFORM.CELLSOURCE.value,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
				}
			} // end else if (mfgDeptNo=="2")
			else if (mfgDeptNo=="3")   // 製造三部
			{
				subWin=window.open("../jsp/subwindow/TSMfgWaferCharactFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WFRESIST="+waferResist+"&DICESIZE="+diceSize+"&WAFERLOT="+waferLot+"&WOTYPE="+woType+"&MARTETTYPE="+marketType+"&SUPPLIERLOT="+supplierLot,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes,toolbar=yes");
			}
		} // End of if (woType=="2")

		// } else {
		//         alert("請確實輸入電阻係數及切割尺寸作查詢!!!");
		//		  if (document.MYFORM.WFRESIST.value==null) document.MYFORM.WFRESIST.focus();
		//		  else document.MYFORM.DICESIZE.focus();
		//       }
	}

	// 用前段流程卡找後段可用工令開立來源_起
	function subWinFrontRunCardFindCheck(runCardNo,marketType,invItem,itemDesc,oeOrderNo,itemId,semiItemID,altRouting)
	{
		if (altRouting=="2") // 若是外購工令,依選擇的廠商批號帶入
		{
			subWin=window.open("../jsp/subwindow/TSMfgOPSupplierLotFind.jsp?RUNCARD_NO="+runCardNo+"&MARKETTYPE="+marketType+"&INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&OEORDERNO="+oeOrderNo+"&ITEMID="+itemId+"&SEMIITEMID="+semiItemID,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
		}
		else {
			subWin=window.open("../jsp/subwindow/TSMfgRunCardFind.jsp?RUNCARD_NO="+runCardNo+"&MARKETTYPE="+marketType+"&INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&OEORDERNO="+oeOrderNo+"&ITEMID="+itemId+"&SEMIITEMID="+semiItemID,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
		}
	}
	//this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.OEORDERNO.value,this.form.ITEMID.value,this.form.SEMIITEMID.value
	function setFrontRunCardFindCheck(runCardNo,marketType,invItem,itemDesc,oeOrderNo,itemId,semiItemID,altRouting)
	{
		if (event.keyCode==13)
		{
			if (altRouting=="2") // 若是外購工令,則以檢驗入庫廠商批號帶入
			{
				subWin=window.open("../jsp/subwindow/TSMfgOPSupplierLotFind.jsp?RUNCARD_NO="+runCardNo+"&MARKETTYPE="+marketType+"&INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&OEORDERNO="+oeOrderNo+"&ITEMID="+itemId+"&SEMIITEMID="+semiItemID,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
			} else {
				subWin=window.open("../jsp/subwindow/TSMfgRunCardFind.jsp?RUNCARD_NO="+runCardNo+"&MARKETTYPE="+marketType+"&INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&OEORDERNO="+oeOrderNo+"&ITEMID="+itemId+"&SEMIITEMID="+semiItemID,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
			}
			//    subWin=window.open("../jsp/subwindow/TSMfgWaferLotFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WAFERLOTNO="+waferLotNo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}
	}
	// 用前段流程卡找後段可用工令開立來源_迄
	function setWaferLotFindCheck(invItemNo,invItemDesc,waferLot,marketType)
	{
		if (event.keyCode==13)
		{
			subWin=window.open("../jsp/subwindow/TSMfgWaferLotFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&WAFERLOT="+waferLot+"&MARKETTYPE="+marketType,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
//    subWin=window.open("../jsp/subwindow/TSMfgWaferLotFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&WAFERLOTNO="+waferLotNo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
		}
	}

	function subWinWaferLotFindCheck(invItemNo,invItemDesc,waferLot,marketType)
	{
		subWin=window.open("../jsp/subwindow/TSMfgWaferLotFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&WAFERLOT="+waferLot+"&MARKETTYPE="+marketType,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
	}

	function setMoFindCheck(invItemNo,invItemDesc,oeOrderNo,itemId,marketType,semiItemID,runCardNo,oeLineQty,alternateRouting)
	{ //alert(marketType);
		if (event.keyCode==13)
		{
			if (alternateRouting=="" || alternateRouting=="--")
			{
				alert("請務必選取AlternaterRouting !!!");
				window.document.MYFORM.ALTERNATEROUTING.focus();
				return(false);
			} else {
				subWin=window.open("../jsp/subwindow/TSMfgMOFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&OEORDERNO="+oeOrderNo+"&MARKETTYPE="+marketType+"&SEMIITEMID="+semiItemID+"&RUNCARDNO="+runCardNo+"&OELINEQTY="+oeLineQty+"&ALTERNATEROUTING="+alternateRouting,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
			}
		}
	}

	function subWinMoFindCheck(invItemNo,invItemDesc,oeOrderNo,marketType,semiItemID,runCardNo,oeLineQty,woType,alternateRouting)  //20090120
	{
		if (alternateRouting=="" || alternateRouting=="--")
		{
			alert("請務必選取AlternaterRouting !!!");
			window.document.MYFORM.ALTERNATEROUTING.focus();
			return(false);
		} else {
			subWin=window.open("../jsp/subwindow/TSMfgMOFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&OEORDERNO="+oeOrderNo+"&MARKETTYPE="+marketType+"&SEMIITEMID="+semiItemID+"&RUNCARDNO="+runCardNo+"&OELINEQTY="+oeLineQty+"&WOTYPE="+woType+"&ALTERNATEROUTING="+alternateRouting,"subwin","width=800,height=600,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
		}
	}

	function calDefaultIssQty(xWOQTY,xINVITEM,xWAFERLOT,xORGANIZATIONID)
	{
		//alert(xWOQTY+"     "+xWAFERLOT);
		subWin=window.open("../jsp/subwindow/TSMfgWaferPceSet.jsp?INVITEM="+xINVITEM+"&WOQTY="+xWOQTY+"&WAFERLOT="+xWAFERLOT+"&ORGANIZATIONID="+xORGANIZATIONID,"subwin","width=400,height=300,scrollbars=yes,menubar=yes,status=yes,resizable=yes");
	}

	function setSubmitDiceSize(URL)
	{
		//var extInfo = "&SUPPLIERID="+supplierID+"&PONUMBER="+poNumber;
		document.MYFORM.action=URL+"?DICESIZECH="+document.MYFORM.DICESIZECH.value;
		document.MYFORM.submit();
	}

	function setMOFind(marketType,oeOrderNo)
	{ //alert("marketType="+marketType);
		subWin=window.open("../jsp/subwindow/TSMfgMOAdmFind.jsp?MARKETTYPE="+marketType+"&OEORDERNO="+oeOrderNo,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes");
	}


	function subWindowSupplierFind(vndNo, vndName)
	{
		subWin=window.open("../jsp/subwindow/TSCVendorInfoFind.jsp?SUPPLYVNDNO="+vndNo+"&SUPPLYVND="+vndName,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes");
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

	function setReset(URL)
	{
		document.MYFORM.INVITEM.value="";
		document.MYFORM.ITEMDESC.value="";
		document.MYFORM.WOQTY.value="";
		document.MYFORM.WOUNITQTY.value="";
		document.MYFORM.SEMIITEMTITLE.value="";
		document.MYFORM.SEMIITEMID.value="";
		document.MYFORM.SEMIINVITEM.value="";
		document.MYFORM.SEMIITEMDESC.value="";
		document.MYFORM.OEORDERNO.value="";
		document.MYFORM.OELINEQTY.value="";
		document.MYFORM.OEQTYUOM.value="";
		document.MYFORM.CUSTOMERNAME.value="";
		document.MYFORM.CUSTOMERPO.value="";
		document.MYFORM.TSCPACKAGE.value="";
		document.MYFORM.TSCFAMILY.value="";
		document.MYFORM.TSCPACKING.value="";
		document.MYFORM.ALTBOMSEQID.value="";
		document.MYFORM.ROUTINGREFID.value="";
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}

	function submitReset(URL)
	{
		document.MYFORM.INVITEM.value="";
		document.MYFORM.ITEMDESC.value="";
		document.MYFORM.WOQTY.value="";
		document.MYFORM.WOUNITQTY.value="";
		document.MYFORM.SEMIITEMTITLE.value="";
		document.MYFORM.SEMIITEMID.value="";
		document.MYFORM.SEMIINVITEM.value="";
		document.MYFORM.SEMIITEMDESC.value="";
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	function subWindowSubInventoryFind(organizationID,subInv,subInvDesc)
	{
		//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");
		subWin=window.open("../jsp/subwindow/TSCInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,scrollbars=yes");
	}

	//add by Peggy 20181121
	function checkDate(p_value,p_date)
	{
		var rec_year  = p_date.substr(0,4);
		var rec_month = p_date.substr(4,2);
		var rec_day   = p_date.substr(6,2);
		if (rec_month <1 || rec_month >12)
		{
			if (p_value=="sdate")
			{
				alert("預計投入日的月份有誤!!");
				document.MYFORM.STARTDATE.focus();
			}
			else
			{
				alert("預計完工日的月份有誤!!");
				document.MYFORM.ENDDATE.focus();
			}
			return false;
		}
		else if (((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)  && rec_day > 31)
				||  ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11) && rec_day > 30)
				||  ((rec_month == 2) && ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))))
		{
			if (p_value=="sdate")
			{
				alert("預計投入日的天數有誤!!");
				document.MYFORM.STARTDATE.focus();
			}
			else
			{
				alert("預計完工日的天數有誤!!");
				document.MYFORM.ENDDATE.focus();
			}
			return false;
		}

		var newDate =null;
		if (p_value=="sdate")
		{
			newDate= new Date(rec_year+"/"+rec_month+"/"+rec_day+" 00:00:00");
		}
		else
		{
			newDate= new Date(document.MYFORM.STARTDATE.value.substr(0,4)+"/"+document.MYFORM.STARTDATE.value.substr(4,2)+"/"+document.MYFORM.STARTDATE.value.substr(6,2)+" 00:00:00");
		}
		newDate.setDate(newDate.getDate() + 7);
		rec_year = newDate.getYear().toString();
		rec_month = ("0"+(newDate.getMonth()+1).toString());
		rec_month = rec_month.substr(rec_month.length-2);
		rec_day = ("0"+newDate.getDate().toString());
		rec_day = rec_day.substr(rec_day.length-2);
		document.MYFORM.ENDDATE.value = rec_year+rec_month+rec_day;
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
</script>

<%
	//String woNo=request.getParameter("WONO");
	String marketType=request.getParameter("MARKETTYPE");
	String mfgDeptNo=request.getParameter("MFGDEPTNO");
	String prodSource=request.getParameter("PRODSOURCE");
	String cellSource=request.getParameter("CELLSOURCE");

	String custType=request.getParameter("CUSTTYPE");  // 2007/08/02 定義不同的客戶流程卡編碼
	String custLotAlert=request.getParameter("CUSTLOTALERT");  // 2007/08/02 定義客戶流程卡編碼的警告(使用者未選擇特殊客戶編號,當選定的銷售訂單對應客戶被定義於特殊批號)

	String woType=request.getParameter("WOTYPE");
	String woKind=request.getParameter("WOKIND");         //工單類別 1:標準,2:非標準
	String startDate=request.getParameter("STARTDATE");
	String endDate=request.getParameter("ENDDATE");
	String woQty=request.getParameter("WOQTY");
	String invItem=request.getParameter("INVITEM");
	String itemId=request.getParameter("ITEMID");

	String itemDesc=request.getParameter("ITEMDESC");
	String woUom=request.getParameter("WOUOM");
	String woUnitQty=request.getParameter("WOUNITQTY"); // 工令製成品的單位用量,必填
	if (woUnitQty==null) woUnitQty="";
	String waferLot=request.getParameter("WAFERLOT");
	String waferQty=request.getParameter("WAFERQTY");          //使用晶片數量
	String waferUom=request.getParameter("WAFERUOM");          //晶片單位
	String waferYld=request.getParameter("WAFERYLD");          //晶片良率
	String waferVendor=request.getParameter("WAFERVENDOR");   //晶片供應商
	String waferKind=request.getParameter("WAFERKIND");       //晶片類別
	String waferElect=request.getParameter("WAFERELECT");     //電阻系數
	String waferPcs=request.getParameter("WAFERPCS");         //使用晶片片數
	String waferIqcNo=request.getParameter("WAFERIQCNO");     //檢驗單號
	String tscPackage=request.getParameter("TSCPACKAGE");     //
	String tscFamily=request.getParameter("TSCFAMILY");     //
	String tscPacking=request.getParameter("TSCPACKING");
	String opSupplierLot=request.getParameter("OPSUPPLIERLOT");
	String tscAmp=request.getParameter("TSCAMP");		      //安培數
	String alternateRouting=request.getParameter("ALTERNATEROUTING");
	String customerName=request.getParameter("CUSTOMERNAME");
	String customerNo=request.getParameter("CUSTOMERNO");
	String customerId=request.getParameter("CUSTOMERID");
	String customerPo=request.getParameter("CUSTOMERPO");
	String oeOrderNo=request.getParameter("OEORDERNO");
	String oeLineQty=request.getParameter("OELINEQTY");
	String oeQtyUom=request.getParameter("OEQTYUOM");

	String deptNo=request.getParameter("DEPT_NO");
	String deptName=request.getParameter("DEPT_NAME");
	String preFix=request.getParameter("PREFIX");
	String oeHeaderId=request.getParameter("OEHEADERID");
	String oeLineId=request.getParameter("OELINEID");
	String organizationId=request.getParameter("ORGANIZATION_ID");
	String waferLineNo=request.getParameter("WAFERLINENO");
	String orderQty=request.getParameter("ORDERQTY");

	String iNo=request.getParameter("INO");
	String isModelSelected=request.getParameter("ISMODELSELECTED");
	String woRemark=request.getParameter("WOREMARK");
	String [] addItems=request.getParameterValues("ADDITEMS");
	String [] allMonth={iNo,invItem,itemDesc,woQty,woUom,startDate,endDate};
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
	String frontRunCard=request.getParameter("FRONTRUNCARD");
	String semiItemTitle=request.getParameter("SEMIITEMTITLE");
	String semiItemID=request.getParameter("SEMIITEMID");
	String semiInvItem=request.getParameter("SEMIINVITEM");
	String semiItemDesc=request.getParameter("SEMIITEMDESC");
	String seqno=null;
	String seqkey=null;
	String dateString=null;

	String dateStringBegin=request.getParameter("DATEBEGIN");
	String dateStringEnd=request.getParameter("DATEEND");
	String dateSetBegin=request.getParameter("DATESETBEGIN");
	String dateSetEnd=request.getParameter("DATESETEND");
	String YearFr=request.getParameter("YEARFR");
	String MonthFr=request.getParameter("MONTHFR");
	String DayFr=request.getParameter("DAYFR");
	if (dateSetBegin==null) dateSetBegin=YearFr+MonthFr+DayFr;

	String YearTo=request.getParameter("YEARTO");
	String MonthTo=request.getParameter("MONTHTO");
	String DayTo=request.getParameter("DAYTO");
	if (dateSetEnd==null) dateSetEnd=YearTo+MonthTo+DayTo;

	String altBomSeqID=request.getParameter("ALTBOMSEQID");
	String altBomDest=request.getParameter("ALTBOMDEST");
	String waferUsedPce=request.getParameter("WAFERUSEDPCE");
	String altRoutingDest=request.getParameter("ALTROUTINGDEST");
	String routingRefID=request.getParameter("ROUTINGREFID");
	String alternateRoutingDesignator="";   //
	// String waferPce=request.getParameter("WAFERUSEDPCE");

	String diceSizeCh=request.getParameter("DICESIZECH");
	String wfResistCh=request.getParameter("WFRESISTCH");

	String diceSize=request.getParameter("DICESIZE");
	String wfResist=request.getParameter("WFRESIST");

	String supplyVnd=request.getParameter("SUPPLYVND");
	String subInv=request.getParameter("SUBINVENTORY");
	String lotControl=request.getParameter("LOTCONTROL");
// String subInvDesc="";

	if (diceSizeCh==null || diceSizeCh.equals("")) diceSizeCh = "";
	if (wfResistCh==null || wfResistCh.equals(""))
	{
		if (waferElect==null || waferElect.equals(""))
		{
			wfResistCh = "";
		} else {  wfResistCh = waferElect; }
	}
	if (diceSize==null || diceSize.equals("")) diceSize = "";
	if (wfResist==null || wfResist.equals(""))
	{
		if (waferElect==null || waferElect.equals(""))
		{
			wfResist = "";
		} else {  wfResist = waferElect; }
	}

	if (waferKind==null || waferKind.equals("")) waferKind = "";

	if (waferLot==null || waferLot.equals("")) waferLot = "";

	if (supplyVnd==null || supplyVnd.equals("")) supplyVnd = "";

	String [] selectFlag=request.getParameterValues("SELECTFLAG");
//  String code=request.getParameter("CODE");
//  if (code==null) code="--";

	int inpLen = 0;

	if (iNo==null || iNo.equals("")) iNo = "1";
	if (startDate==null || startDate.equals("")) startDate=dateBean.getYearMonthDay();
	if (endDate==null || endDate.equals(""))
	{
		//endDate=dateBean.getYearMonthDay();
		//20181113 add by Peggy,預計完工日=預計投入日+7
		dateBean.setAdjDate(7);
		endDate=dateBean.getYearMonthDay();
		dateBean.setAdjDate(-7);
	}
	if (woQty==null || woQty.equals("")) woQty="0";
	if (woType==null || woType.equals("")) woType="--";
	if (woType=="4" || woType.equals("4")) { woKind="2"; } else {woKind="1";}  //woKind=2 重工屬於非標準型工單

	if (prodSource==null || prodSource.equals("")) prodSource = "1"; // 預設生產來源是IQC檢驗批
	if (cellSource==null || cellSource.equals("")) cellSource = "1"; // 預設CELL來源是CELL第一張工令,2 是舊庫存批

	if (custType==null || custType.equals("")) custType = "0"; // 預設客戶流程卡編號為 0:一般客戶流程卡, 1:特殊客戶流程卡(FairChild 1107)
	if (custLotAlert==null || custLotAlert.equals("")) custLotAlert = "N"; // 預設值是 N , 當出現選定後段工令對應銷售訂單客戶是需要特定批號卻選擇一般客戶,則系統警告訊息

//  if (alternateRouting =="--" || alternateRouting.equals("--")) alternateRouting="" ;
	if (woUom==null || woUom.equals("")) woUom="";
	if (waferQty==null || waferQty.equals("")) waferQty="0";
	if (waferUom==null || waferUom.equals("")) waferUom="";
	if (waferYld==null || waferYld.equals("")) waferYld="0";
	if (tscPackage==null || tscPackage.equals("")) tscPackage="";
	if (tscFamily==null || tscFamily.equals("")) tscFamily="";
	if (tscPacking==null || tscPacking.equals("")) tscPacking="";
	if (opSupplierLot==null || opSupplierLot.equals("")) opSupplierLot="";
	if (tscAmp==null || tscAmp.equals("")) tscAmp="";
	if (waferElect==null || waferElect.equals("")) waferElect="";
	if (customerName==null || customerName.equals("")) customerName="";
	if (waferVendor==null || waferVendor.equals("")) waferVendor="";
	if (woRemark==null || woRemark.equals("")) woRemark="";
	if (oeOrderNo==null || oeOrderNo.equals("")) oeOrderNo="";
	if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N";
	if (customerPo==null || customerPo.equals("") || customerPo.equals("null")) customerPo="";

	if (frontRunCard==null || frontRunCard.equals("")) frontRunCard = "";
	if (semiItemID==null || semiItemID.equals("")) semiItemID = "";
	if (semiInvItem==null || semiInvItem.equals("")) semiInvItem = "";
	if (semiItemDesc==null || semiItemDesc.equals("")) semiItemDesc = "";
	if (semiItemTitle==null || semiItemTitle.equals("")) semiItemTitle = "";
	if (oeLineQty==null || oeLineQty.equals("")) oeLineQty = "";
	if (oeQtyUom==null || oeQtyUom.equals("")) oeQtyUom = "";


	if (altBomSeqID==null || altBomSeqID.equals("")) altBomSeqID = "";
	if (altBomDest==null || altBomDest.equals("")) altBomDest = "";
	if (altRoutingDest==null || altRoutingDest.equals("")) altRoutingDest = "";
	if (routingRefID==null || routingRefID.equals("")) routingRefID = "";
	if (waferUsedPce==null || waferUsedPce.equals("")) waferUsedPce = "";
	if (subInv==null || subInv.equals("")) subInv="";

	//依工單類別自動顯示預設值
	if (woType.equals("2") || woType.equals("7")) //2:前段,7:工程實驗/換貨
	{
		alternateRouting="1"; //自制
		subInv="02"; //倉別
	}
	else if (woType.equals("3") || woType.equals("5"))  //3:後段,5:樣品
	{
		alternateRouting="1"; //自制
		woUnitQty="1";  //單位用量
		subInv="03"; //倉別
	}

	//out.println("insertPage="+insertPage);
	//  設定Array 初始內容_起
	if (insertPage==null || insertPage.equals("")) // 若輸入模式離開此頁面,則BeanArray內容清空
	{
		arrayWODocumentInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
	} else {

		String sp[][]=arrayWODocumentInputBean.getArray2DContent();//若為輸入模式,且內容不為null,則將陣列entity給全域變數 inpLen
		if (sp != null)
		{
			inpLen = sp.length; // 把已輸入的內容個數傳給此全域變數,做為判斷是否可重選樣本訂單依據
			//out.println("inpLen ="+inpLen);
		}
	}
/*
 try
 {

  if (oeOrderNo != null || !oeOrderNo.equals(""))
   {
    String sqlOrdCust = " select H.SOLD_TO as CUSTOMERNAME,L.SCHEDULE_SHIP_DATE as ENDDATE ,L.ORDERED_QUANTITY as WOQTY "+
						"       ,L.INVENTORY_ITEM_ID from OE_ORDER_HEADERS_V h,OE_ORDER_LINES_ALL L "+
						" where ORDER_NUMBER= '"+oeOrderNo+"' and  H.HEADER_ID=L.HEADER_ID "+
						"   and  L.INVENTORY_ITEM_ID = "+itemId;
      // out.println("<BR>sqlOrdCust="+sqlOrdCust);
	 Statement stateOrdCust=con.createStatement();
     ResultSet rsOrdCust=stateOrdCust.executeQuery(sqlOrdCust);
	 if (rsOrdCust.next())
		 {
			customerName  = rsOrdCust.getString("CUSTOMERNAME");
			endDate       = rsOrdCust.getString("ENDDATE");
			woQty         = rsOrdCust.getString("WOQTY");
		  }
		  rsOrdCust.close();
          stateOrdCust.close();
    }//end if (oeOrderNo != null



  } //end of try
  catch (Exception e)
  {
   out.println("Exception 1:"+e.getMessage());
  }
 */



	try
	{

		String at[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容
		//*************依Detail資料user可能再修改內容,故必須將其內容重寫入陣列內
		if (at!=null)
		{
			for (int ac=0;ac<at.length;ac++)
			{
				for (int subac=1;subac<at[ac].length;subac++)
				{
					at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
				}  //end for array second layer count
			} //end for array first layer count
			arrayWODocumentInputBean.setArray2DString(at);  //reset Array
		}   //end if of array !=null
		//********************************************************************

		// 把 at.length() 值給 custINo作為目前預設的項次編號 kerwin 2006/02/17
		//if (custINo==null || custINo.equals("")) custINo="1";
		//else custINo = at.length();

		if (addItems!=null) //若有選取則表示要刪除
		{
			String a[][]=arrayWODocumentInputBean.getArray2DContent();//重新取得陣列內容
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
							for (int gg=0;gg<25;gg++) //置入陣列中元素數(注意..此處決定了陣列的Entity數目,若不同Entity數,必需修改此處,否則Delete 不Work)
							{                          // 目前共20個{ iNo,woNo,invItem,itemDesc,woQty,wouom,startDate,enddate }
								// t[cc][gg]=a[m][gg];  //原先直接將暫存內容置入,
								if (gg==0)
								{
									t[cc][gg]= Integer.toString(cc+1); // 把第一行的值重算
								}
								else {
									t[cc][gg]=a[m][gg];
								}
							}
							cc++;
						}
					} //end of if a.length
					arrayWODocumentInputBean.setArray2DString(t);
				} else { 	//else (a!=null && addItems.length>0 )
					//arrayWODocumentInputBean.setArray2DString(null); //若陣列內容不為空,且addItems.length>0,則將陣列內容清空
					if (a.length==addItems.length)
					{
						arrayWODocumentInputBean.setArray2DString(null); //若陣列內容不為空,且陣列的Entity=addItems.length,則將陣列內容清空
						inpLen = 0; // 清空,則重設為零
					} // End of if (a.length==addItems.length)
				}
			}//end of if a!=null
		}


	} //end of try
	catch (Exception e)
	{
		out.println("Exception 2:"+e.getMessage());
	}

	// 2007/08/13 增加判斷  是否後段工令選擇之生產銷售訂單客戶為 定義在特殊客戶批號的 Customer_起
	try
	{
		String sqlCustLotT = " select ALTERNATE_ROUTING "+
				"      from YEW_MFG_DEFDATA "+
				" where DEF_TYPE= 'CUST_TYPE' and CODE != '0' "+
				"   and ALTERNATE_ROUTING = '"+customerId+"' ";
		// out.println("<BR>sqlOrdCust="+sqlOrdCust);
		Statement stateCustLotT=con.createStatement();
		ResultSet rsCustLotT=stateCustLotT.executeQuery(sqlCustLotT);
		if (rsCustLotT.next())
		{
			custLotAlert  = "Y";
		} else { custLotAlert  = "N"; }
		rsCustLotT.close();
		stateCustLotT.close();

		//20121222 liling 改善FSC料號要ALTER '特殊批號',由料號判斷Fairchild 字樣.
		//20190614 liling for ON SEMI料號要要ALTER '特殊批號',由料號判斷-ON 字樣.
		if (itemId==null || itemId.equals("")) itemId="0";
		String sqlCustLotTi = " select UPPER(DESCRIPTION) "+
				"      from MTL_SYSTEM_ITEMS "+
				" where ORGANIZATION_ID=327 "+
				"   and INVENTORY_ITEM_ID = '"+itemId+"' "+
				//	 "   and UPPER(DESCRIPTION) LIKE '%FAIRCHILD%' ";
				"    AND ( UPPER(DESCRIPTION) LIKE '%-FAIRCHILD%' or  UPPER(DESCRIPTION) LIKE '%-ON%' ) ";  //20190614 liling add -ON
		//  out.println("<BR>sqlCustLotTi="+sqlCustLotTi);
		Statement stateCustLotTi=con.createStatement();
		ResultSet rsCustLotTi=stateCustLotTi.executeQuery(sqlCustLotTi);
		if (rsCustLotTi.next())
		{
			custLotAlert  = "Y";
			custType ="1";   //20151026
		} else { custLotAlert  = "N"; }
		rsCustLotTi.close();
		stateCustLotTi.close();

		//  out.println("<BR>custLotAlert2="+custLotAlert);

	} //end of try
	catch (Exception e)
	{
		out.println("Exception CustLot:"+e.getMessage());
	}
	// 2007/08/13 增加判斷  是否後段工令選擇之生產銷售訂單客戶為 定義在特殊客戶批號的 Customer_迄

%>

<html>
<head>
	<title>MFG System Work Order Create Form</title>
	<STYLE TYPE='text/css'>
		BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
		P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
		TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}
		TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
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
		.smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
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
	</STYLE>
	<Style type="text/css">
		.koko{
			border:0;
			color:#FF0000; text-decoration: underline ;font:"Comic Sans MS"; font-style:italic;
			background-color:#D1E2FE;
			border-style: solid;
		}
	</Style>
	<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="TSCMfgWoCreate.jsp" METHOD="post" NAME="MYFORM">
	<font size="+3" face="Arial Black" color="#000099"><em>TSC</em></font><font face="Courier, MS Sans Serif"></font><font color="#000000" size="+2" face="Times New Roman">
	<strong><font color="#0033CC" face="MS Sans Serif">工令新增</font></strong></font><font face="Arial" size="2" color="#330099">
</font><font color="#000000" size="+2" face="Times New Roman"><strong>
</strong></font>
	<BR>
	<img src="../image/point.gif"><font color="#FF6600">為必填欄位,請務必輸入</font>
	<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td><font color="#330099"><span class="style1">&nbsp;</span>製造部門別<img src="../image/point.gif"></font>
				<%
					try
					{
						//-----取製造部別
						Statement statement=con.createStatement();
						ResultSet rs=null;
						String sqlDeptNo = " select CODE,CODE_DESC from apps.YEW_MFG_DEFDATA ";
						String whereDeptNo = " where DEF_TYPE='MFG_DEPT_NO'  ";
						if (UserMfgDeptSet!=null && !UserMfgDeptSet.equals("")) whereDeptNo = whereDeptNo + "and CODE in ("+UserMfgDeptSet+") "; // 僅能以被給定的部門開工令
						String orderDeptNo = "  ";

						if (mfgDeptNo==null) mfgDeptNo = userMfgDeptNo; // 若未選擇,則以登入時取到的為預設值

						sqlDeptNo = sqlDeptNo + whereDeptNo;
						//out.println(sqlDeptNo);
						rs=statement.executeQuery(sqlDeptNo);
						// comboBoxBean.setRs(rs);
						// comboBoxBean.setSelection(mfgDeptNo);
						// comboBoxBean.setFieldName("MFGDEPTNO");
						// out.println(comboBoxBean.getRsString());
						out.println("<select NAME='MFGDEPTNO' onChange='setSubmit("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
						out.println("<OPTION VALUE=-->--");
						while (rs.next())
						{
							String s1=(String)rs.getString(1);
							String s2=(String)rs.getString(2);

							if (s1.equals(mfgDeptNo))
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
					{ out.println("Exception:"+e.getMessage()); }
				%>	</td>
			<td><font color="#330099"><span class="style1">&nbsp;</span>內銷/外銷<img src="../image/point.gif"></font>
				<%
					try
					{
						//-----取內外銷別
						Statement statement=con.createStatement();
						ResultSet rs=null;
						String sqlOrgInf = " select CODE,CODE_DESC from apps.YEW_MFG_DEFDATA ";
						String whereOType = " where DEF_TYPE='MARKETTYPE'  ";
						String orderType = "  ";

						sqlOrgInf = sqlOrgInf + whereOType;
						//out.println(sqlOrgInf);
						rs=statement.executeQuery(sqlOrgInf);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(marketType);
						comboBoxBean.setFieldName("MARKETTYPE");
						out.println(comboBoxBean.getRsString());
						rs.close();
						statement.close();


						//--- organization_id
						String sqli = " select ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE='MARKETTYPE' and CODE= '"+marketType+"' " ;
						//out.print("sqli="+sqli);
						Statement statei=con.createStatement();
						ResultSet rsi=statei.executeQuery(sqli);
						if (rsi.next())
						{ 	organizationId   = rsi.getString("ORGANIZATION_ID");   }
						rsi.close();
						statei.close();


					} //end of try
					catch (Exception e) { out.println("Exception:"+e.getMessage()); }

				%>     </td>
			<td colspan="2"><font color="#330099"><span class="style1">&nbsp;</span>工令類別<img src="../image/point.gif"></font>
				<%
					try
					{
						//-----取工單類別
						Statement statement=con.createStatement();
						ResultSet rs=null;
						String sqlOrgInf = " select CODE as WOTYPE,CODE_DESC from apps.YEW_MFG_DEFDATA ";
						String whereOType = " where DEF_TYPE='WO_TYPE'  ";
						String orderType = "  ";

						sqlOrgInf = sqlOrgInf + whereOType;
						//out.println(sqlOrgInf);
						rs=statement.executeQuery(sqlOrgInf);

						out.println("<select NAME='WOTYPE' onChange='setSubmit("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
						out.println("<OPTION VALUE=-->--");
						while (rs.next())
						{
							String s1=(String)rs.getString(1);
							String s2=(String)rs.getString(2);

							if (s1.equals(woType))
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
						// Add By Kerwin 限制要先選擇內外銷型態_起
						if (marketType==null) { }
						else if (marketType.equals("--"))
						{
				%>
				<script language="javascript">
					alert("Please Choose Market Type !!!");
					document.MYFORM.WOTYPE.value="--";
					document.MYFORM.MARKETTYPE.focus();
				</script>
				<%
						}
						// Add By Kerwin 限制要先選擇內外銷型態_迄
						//依工令及內外銷別,取得工令前置碼
						String sqlwoprefix = " select decode('"+marketType+"','1',IN_WO_PREFIX,'2',EX_WO_PREFIX) as PREFIX "+
								"  from YEW_MFG_DEFDATA where DEF_TYPE='WO_TYPE' and CODE='"+woType+"' ";
						//out.println("<BR>sqlwoprefix="+sqlwoprefix);
						Statement statewoprefix=con.createStatement();
						ResultSet rswoprefix=statewoprefix.executeQuery(sqlwoprefix);
						if (rswoprefix.next())
						{
							preFix  = rswoprefix.getString("PREFIX");
						}
						rswoprefix.close();
						statewoprefix.close();

						if (woType=="1" || woType.equals("1") || woType=="4" || woType.equals("4"))   //切割站一律為自制 2006/11/22增加重工亦為'1'
						{ alternateRouting="1";}

						//預設入庫倉別___起
						if (woType=="1" || woType.equals("1"))   //若為切割預設倉別 '01'
						{ // subInv="00" ;   //20160222 liling for 山東需求,取消
						}
						else if (woType=="2" || woType.equals("2") ||  ( woType=="7" || woType.equals("7"))  ) // 若為前段或為工程實驗工令預設倉別 '02'
						{  subInv="02" ; }
						else if (woType=="3" || woType.equals("3") ||  ( woType=="5" || woType.equals("5"))) // 若為後段預設倉別 '03' ,20090114 liling add wotype=5
						{  subInv="03"; }
						//預設入庫倉別___迄


						//------計算切割工令數量換算晶片下線片數---起----------------------2006/12/16
						if (woType=="1" || woType.equals("1"))
						{
							float waferUsedQty=0;
							String sqlRate = " SELECT TransOut.PRIMARY_QUANTITY OUTQTY,TransIn.PRIMARY_QUANTITY INQTY, "+
									" 		  round(abs(transin.primary_quantity) / abs(transout.primary_quantity),2) rate "+
									"   FROM "+
									"     ( SELECT MTL.TRANSACTION_ID,MTL.PRIMARY_QUANTITY ,MMT.TRANSACTION_REFERENCE,MTL.LOT_NUMBER "+
									"         FROM MTL_TRANSACTION_LOT_NUMBERS MTL,MTL_MATERIAL_TRANSACTIONS MMT "+
									"        WHERE MTL.TRANSACTION_SOURCE_ID=( SELECT A.DISPOSITION_ID FROM MTL_GENERIC_DISPOSITIONS A  "+
									"											 WHERE A.ORGANIZATION_ID="+organizationId+"  AND A.SEGMENT1='重分轉出' ) "+
									"          AND MTL.TRANSACTION_ID=MMT.TRANSACTION_ID AND MTL.ORGANIZATION_ID= "+organizationId+" "+
									"          AND MTL.LOT_NUMBER='"+waferLot+"' ) TransOut , "+
									"     ( SELECT MTL.TRANSACTION_ID,MTL.PRIMARY_QUANTITY ,MMT.TRANSACTION_REFERENCE,MTL.LOT_NUMBER "+
									"         FROM MTL_TRANSACTION_LOT_NUMBERS MTL,MTL_MATERIAL_TRANSACTIONS MMT "+
									"        WHERE MTL.TRANSACTION_SOURCE_ID=( SELECT A.DISPOSITION_ID FROM MTL_GENERIC_DISPOSITIONS A  "+
									"	                                         WHERE A.ORGANIZATION_ID="+organizationId+"  AND A.SEGMENT1='重分轉入' ) "+
									"          AND MTL.TRANSACTION_ID=MMT.TRANSACTION_ID AND MTL.ORGANIZATION_ID="+organizationId+" "+
									"		    AND MTL.LOT_NUMBER='"+waferLot+"' ) TransIn "+
									"   WHERE TransOut.TRANSACTION_REFERENCE=TransIn.TRANSACTION_REFERENCE "+
									"     AND TransOut.LOT_NUMBER=TransIn.LOT_NUMBER ";


							//out.println("sqlRate="+sqlRate);
							Statement stateRate=con.createStatement();
							ResultSet rsRate=stateRate.executeQuery(sqlRate);
							if (rsRate.next())
							{

								//waferUsedQty=Float.parseFloat(woQty)*rsRate.getFloat(3);    //下線片數=工令數量*重分轉出入換算
								waferUsedPce=String.valueOf(Float.parseFloat(woQty)*rsRate.getFloat(3));
								//out.print("<br>waferUsedPce="+waferUsedPce);
							}
							rsRate.close();
							stateRate.close();
						}
						//------計算切割工令數量換算晶片下線片數---起----------------------2006/12/16


					} //end of try
					catch (Exception e) { out.println("Exception:"+e.getMessage()); }
				%>     </td>
			<td colspan="2" nowrap><font color="#330099"><span class="style1">&nbsp;</span>Alternate Routing</font>
				<%
					try
					{
						//-----Alternate Routing
						Statement statement=con.createStatement();
						ResultSet rs=null;
						String sqlOrgInf = " select CODE as ALTERNATEROUTING,CODE_DESC from apps.YEW_MFG_DEFDATA ";
						String whereOType = " where DEF_TYPE='ALT_ROUTING'  ";
						String orderType = "  ";

						sqlOrgInf = sqlOrgInf + whereOType;
						//out.println(sqlOrgInf);
						rs=statement.executeQuery(sqlOrgInf);

						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(alternateRouting);
						comboBoxBean.setFieldName("ALTERNATEROUTING");
						// out.println(comboBoxBean.getRsString());

						//  選擇清單後 reflash
						out.println("<select NAME='ALTERNATEROUTING' onChange='setSubmit("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
						out.println("<OPTION VALUE=-->--");
						while (rs.next())
						{
							String s1=(String)rs.getString(1);
							String s2=(String)rs.getString(2);

							if (s1.equals(alternateRouting))
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
					catch (Exception e) { out.println("Exception:"+e.getMessage()); }
				%>     </td>
			<td nowrap><font color="#330099"><span class="style1">&nbsp;</span>客戶批號</font>
				<%
					try
					{
						//-----取客戶流程卡別
						Statement statement=con.createStatement();
						ResultSet rs=null;
						String sqlOrgInf = " select CODE, CODE_DESC from apps.YEW_MFG_DEFDATA ";
						String whereOType = " where DEF_TYPE='CUST_TYPE'  ";
						String orderType = "  ";

						sqlOrgInf = sqlOrgInf + whereOType;
						//out.println(sqlOrgInf);
						rs=statement.executeQuery(sqlOrgInf);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(custType);
						comboBoxBean.setFieldName("CUSTTYPE");
						out.println(comboBoxBean.getRsString());

						rs.close();
						statement.close();

					} //end of try
					catch (Exception e) { out.println("Exception:"+e.getMessage()); }
				%>
			</td>
		</tr>
		<tr bgcolor="#D1E2FE">
			<td width="20%"><font color="#330099"><span class="style1">&nbsp;</span>料號<img src="../image/point.gif"></font></td>
			<td width="22%"><font color="#330099"><span class="style1">&nbsp;</span>品名</font></td>
			<td width="9%"><font color="#330099"><span class="style1">&nbsp;</span>工令數量<img src="../image/point.gif"></font></td>
			<td width="8%" nowrap><font color="#330099"><span class="style1">&nbsp;</span>單位用量<img src="../image/point.gif"></font></td>
			<td width="9%"><font color="#330099"><span class="style1">&nbsp;</span>單位<img src="../image/point.gif"></font></td>
			<td width="11%"><font color="#330099"><span class="style1">&nbsp;</span>預計投入日<img src="../image/point.gif"></font></td>
			<td width="15%"><font color="#330099"><span class="style1">&nbsp;</span>預計完工日</font></td>
		</tr>
		<tr>
			<td nowrap><span class="style1">&nbsp;</span><input type="text" name="INVITEM" tabindex="4" size="23" onKeyDown="setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.ORGANIZATIONID.value)"><INPUT TYPE="button" tabindex="5" value="..." onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.ORGANIZATIONID.value)'>     </td>
			<td nowrap><span class="style1">&nbsp;</span><input type="text" name="ITEMDESC" tabindex="6"  size="25" onKeyDown="setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)"><INPUT TYPE="button" tabindex="7"   value="..." onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)'></td>
			<%
				if (woType=="1" || woType.equals("1"))
				{
			%>
			<td><input size="8" name="WOQTY" tabindex="8"  value="<%=%>" onBlur='calDefaultIssQty(this.form.WOQTY.value,this.form.INVITEM.value,this.form.WAFERLOT.value,"<%=organizationId%>")'></td>
			<% }else {
			%>	  	<td><input size="8" name="WOQTY" tabindex="8"  value="<%=%>"></td>
			<%      }%>
			<td><input size="5" name="WOUNITQTY" tabindex="9"  value="<%=woUnitQty%>"></td>
			<td><input size="8" name="WOUOM" tabindex='10' value="<%=%>" readonly></td>
			<td bgcolor="#ffffff"><input name="STARTDATE" tabindex="11" type="text" size="8" value="<%=startDate%>" onBlur="checkDate('sdate',this.value)" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)">
				<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.MYFORM.STARTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></a></td>
			<td width="6%" bgcolor="#ffffff"><input name="ENDDATE" tabindex="12" type="text" size="8" value="<%=endDate%>" onFocus="checkDate('edate',this.value)" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)">
				<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.MYFORM.ENDDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></a></td>
		</tr>
	</table>
	<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td width="8%"><font color="#330099"><span class="style1">&nbsp;</span>Altnate BOM</font></td>
			<td nowrap width="18%">
				<INPUT TYPE='TEXT' NAME='ALTBOMSEQID' SIZE=5 value="<%=%>" readonly>
				<input type='button' name='BOMREFCH' value='...' onClick='subWindowBomRefFind(<%=organizationId%>,document.MYFORM.INVITEM.value)'>
				<INPUT TYPE='TEXT' NAME='ALTBOMDEST' SIZE=10 readonly="" value="<%=%>">
			</td>
			<td width="10%"><font color="#330099"><span class="style1">&nbsp;</span>Altnate Routing</font></td>
			<td nowrap  width="18%">
				<INPUT TYPE='TEXT' NAME='ROUTINGREFID' SIZE=5 value="<%=%>" readonly>
				<input type='button' name='ROUTINGREFCH' value='...' onClick='subWindowRoutingRefFind(<%=organizationId%>,document.MYFORM.INVITEM.value)'>
				<INPUT TYPE='TEXT' NAME="ALTROUTINGDEST" SIZE=10 readonly="" value="<%=%>">
			</td>
			<!--2007/03/12 liling 新增入庫倉別提示-->
			<td width="9%"><font color="#330099"><span class="style1">&nbsp;</span>入庫倉別<img src="../image/point.gif"></font></td>
			<td nowrap  width="8%">
				<!--INPUT TYPE="TEXT" NAME="SUBINVENTORY" SIZE=5 value="<%//=subInv%>" readonly--> <!--20090114 liling -->
				<INPUT TYPE="TEXT" NAME="SUBINVENTORY" SIZE=5 value="<%=subInv%>" readonly>
				<input type='BUTTON' name='SUBINVCH' value='...' onClick='subWindowSubInventoryFind(<%=organizationId%>,this.form.SUBINVENTORY.value,this.form.SUBINVDESC.value)'>
				<INPUT TYPE="HIDDEN" NAME="SUBINVDESC" value="<%=%>">
			</td>
			<td width="38%" >
				<%
					if (woType=="2" || woType.equals("2"))
					{
				%>
				<font color="#330099"><span class="style1">&nbsp;</span>銷售訂單號</font>&nbsp;
				<input type="text" name="OEORDERNO" tabindex="41" size="15" value="<%=oeOrderNo%>">
			</td>
			<%
			} else if ( woType=="4" || woType.equals("4"))
			{
			%>
			<font color="#330099"><span class="style1">&nbsp;</span>銷售訂單號</font>&nbsp;
			<input type="text" name="OEORDERNO" tabindex="41" size="15" value="<%=oeOrderNo%>">
			<input name="CHMO" type="button" tabindex="42" onClick='setMOFind(this.form.MARKETTYPE.value,this.form.OEORDERNO.value)' value="...">
			<input type="hidden" name="OEQTYUOM"  value="<%=%>">
			<input type="hidden" name="CUSTOMERNAME"  value="<%=%>">
			<input type="hidden" name="CUSTOMERPO"  value="<%=%>">
			<input type="hidden" name="CUSTOMERID"  value="<%=%>">
			<input type="hidden" name="FRONTRUNCARD"  value="<%=%>">
			<input type="hidden" name="TSCPACKAGE"  value="<%=%>">
			<input type="hidden" name="TSCFAMILY"  value="<%=%>">
			<input type="hidden" name="TSCPACKING"  value="<%=%>">
			<input type="hidden" name="ORDERQTY"  value="<%=%>">
			</td>
			<%  } else { %> &nbsp; </td>
			<%          } %>
			</td>
		</tr>
	</table>
	<%
		// 目前IQC系統可用阻值(電壓)列表_起
		Statement stateRes=con.createStatement();
		String wfResistSug = "";
		//String sqlRes = " select DISTINCT WF_RESIST||','||DICE_SIZE||'(Ω,mil)' from ORADDMAN.TSCIQC_LOTINSPECT_HEADER ";
		String sqlRes = " select DISTINCT WF_RESIST || '(Ω/V)' from ORADDMAN.TSCIQC_LOTINSPECT_HEADER ";
		String whereRes = " where WF_RESIST IS NOT NULL and trim(WF_RESIST) !='null' and DICE_SIZE IS NOT NULL and trim(DICE_SIZE) !='null' and STATUSID='010' ";
		//" order by LAST_UPDATE_DATE ASC ";
		sqlRes = sqlRes + whereRes;
		//out.println(sqlOrgInf);
		ResultSet rsRes=stateRes.executeQuery(sqlRes);
		while (rsRes.next())
		{
			wfResistSug=wfResistSug+rsRes.getString(1)+"<BR>";
		}
		rsRes.close();
		stateRes.close();
		// 目前IQC系統可用阻值(電壓)列表_迄

		// 目前IQC系統可用切割尺寸列表_起
		Statement stateDice=con.createStatement();
		String diceSizeSug = "";
		String sqlDice = " select DISTINCT DICE_SIZE || '(mil)' from ORADDMAN.TSCIQC_LOTINSPECT_HEADER ";
		String whereDice = " where WF_RESIST IS NOT NULL and trim(WF_RESIST) !='null' and DICE_SIZE IS NOT NULL and trim(DICE_SIZE) !='null' and STATUSID='010' ";
		sqlDice = sqlDice + whereDice;
		//out.println(sqlOrgInf);
		ResultSet rsDice=stateDice.executeQuery(sqlDice);
		while (rsDice.next())
		{
			diceSizeSug=diceSizeSug+rsDice.getString(1)+"<BR>";
		}
		rsDice.close();
		stateDice.close();
		// 目前IQC系統可用切割尺寸列表_迄

		if( woType == "1" || woType.equals("1"))  //切割工單的輸入畫面
		{
	%>
	<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td colspan="9">
				<font color="#330099"><span class="style1">&nbsp;</span>切割尺寸</font>
				<%
					try
					{
						String sSqlMIL = "";
						String sWhereMIL = "";

						sSqlMIL = "select Unique DICE_MIL as x ,DICE_MIL from APPS.YEW_WFDICE_FACTOR ";
						sWhereMIL= "where DICE_MIL IS NOT NULL order by DICE_MIL";		// 20250606 modify by JB - xxx * xxx issue
						//sWhereMIL= "where DICE_MIL IS NOT NULL order by to_number(DICE_MIL)";
						sSqlMIL = sSqlMIL+sWhereMIL;
						//out.println(sSqlC);
						Statement statementMIL=con.createStatement();
						ResultSet rsMIL=statementMIL.executeQuery(sSqlMIL);
						out.println("<select NAME='DICESIZECH' onChange='setSubmitDiceSize("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
						out.println("<OPTION VALUE=-->--");
						while (rsMIL.next())
						{
							String s1=(String)rsMIL.getString(1);
							String s2=(String)rsMIL.getString(2);

							if (s1.equals(diceSizeCh) || s1.equals(diceSize))
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
							}
							else
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}
						} //end of while
						out.println("</select>");
						rsMIL.close();
						statementMIL.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
				<input type="hidden" tabindex="14" name="DICESIZE" size="5" onMouseOver='this.T_ABOVE=false;this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=diceSizeSug%>")' onKeyDown='setFrontProdNameFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WFRESISTCH.value,this.form.DICESIZECH.value,this.form.WAFERLOT.value,this.form.WOTYPE.value,this.form.MARKETTYPE.value,this.form.MFGDEPTNO.value)' value="<%=diceSize%>"><font color="#CC3300">mil</font>
				<font color="#330099"><span class="style1">&nbsp;</span>阻值(電壓)</font>
				<%
					try
					{
						String sSqlVTG = "";
						String sWhereVTG = "";

						sSqlVTG = "select Unique VOTAGE_RESIST as x ,VOTAGE_RESIST from APPS.YEW_WFDICE_FACTOR ";
						sWhereVTG= "where DICE_MIL = '"+diceSizeCh+"' order by VOTAGE_RESIST ";
						sSqlVTG = sSqlVTG+sWhereVTG;
						//out.println(sSqlC);
						Statement statementVTG=con.createStatement();
						ResultSet rsVTG=statementVTG.executeQuery(sSqlVTG);
						comboBoxBean.setRs(rsVTG);
						if (wfResistCh!=null && !wfResistCh.equals("--")) comboBoxBean.setSelection(wfResistCh);
						comboBoxBean.setFieldName("WFRESISTCH");
						out.println(comboBoxBean.getRsString());
						rsVTG.close();
						statementVTG.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
				<input type="hidden" tabindex="13" name="WFRESIST" size="5" onMouseOver='this.T_ABOVE=false;this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=wfResistSug%>")' value="<%=wfResist%>"><font color="#CC3300">Ω-cm(V)</font>
				<input type="text" name="SUPPLIER_LOT" size="20" value="<%=%>"><font color="#CC3300">檢驗批號</font>
				<input name="BUTTON3" type="button" tabindex="15" onClick='subWinFrontProdNameFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WFRESISTCH.value,this.form.DICESIZECH.value,this.form.WAFERLOT.value,this.form.WOTYPE.value,this.form.MARKETTYPE.value,this.form.MFGDEPTNO.value,1,this.form.SUPPLIER_LOT.value)' value="查詢">
			</td>
		</tr>
		<tr bgcolor="#D1E2FE">
			<td width="18%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>晶片批號<img src="../image/point.gif"></font></td>
			<td width="15%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>供應商</font></td>
			<td width="8%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>下線片數<img src="../image/point.gif"></font></td>
			<td width="8%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>晶片數量</font></td>
			<td width="8%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>晶片單位</font></td>
			<td width="8%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>晶片良率</font></td>
			<td width="8%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>電阻系數</font></td>
			<td width="8%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>檢驗單號<img src="../image/point.gif"></font></td>
			<td width="8%" align="left"><font color="#330099"><span class="style1">&nbsp;</span>晶片類別</font></td>
		</tr>
		<tr>
			<td align="left"><span class="style1">&nbsp;</span><input type="text" name="WAFERLOT" tabindex="16" size="18" onKeyDown='setWaferLotFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WAFERLOT.value)'>
				<input name="BUTTON3" type="button" tabindex="17" onClick='subWinWaferLotFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WAFERLOT.value,this.form.MARKETTYPE.value)' value="...">
			</td>
			<td align="left"><span class="style1">&nbsp;</span><input size="18" name="WAFERVENDOR" tabindex='18' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERUSEDPCE" tabindex='19' value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERQTY" tabindex='20' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERUOM" tabindex='21' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERYLD" tabindex='22' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERELECT" tabindex='23' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="18" name="WAFERIQCNO" tabindex='24' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERKIND" tabindex='25' readonly value="<%=waferKind%>"></td>
			<input name="WAFERLINENO" type="HIDDEN" value="<%=waferLineNo%>">
		</tr></table>
	<% } // end if woType == "1"
		if( woType == "2" || woType.equals("2"))  //前段工單的輸入畫面
		{ %>
	<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td colspan="10">
				<%
					if (mfgDeptNo=="2" || mfgDeptNo.equals("2")) // 如為製造二部,可選生產來源作為查詢條件(OPTION 選項)
					{
						out.println("<font color='#330099'><span class='style1'>&nbsp;</span>生產來源</font>");
						try
						{
							//-----取生產來源別
							Statement statement=con.createStatement();
							ResultSet rs=null;
							String sqlProdSource = " select CODE, CODE_DESC from apps.YEW_MFG_DEFDATA ";
							String whereProdSource = " where DEF_TYPE='PROD_SOURCE'  ";

							sqlProdSource = sqlProdSource + whereProdSource;
							//out.println(sqlOrgInf);
							rs=statement.executeQuery(sqlProdSource);
							out.println("<select NAME='PRODSOURCE' onChange='setSubmit("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
							out.println("<OPTION VALUE=-->--");
							while (rs.next())
							{
								String s1=(String)rs.getString(1);
								String s2=(String)rs.getString(2);

								if (s1.equals(prodSource))
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
						{ out.println("Exception:"+e.getMessage()); }
						// out.println("</td>");

					} // end of 如為製造二部,可選生產來源作為查詢
				%>
				<%
					if (mfgDeptNo=="2" || mfgDeptNo.equals("2"))
					{
						if (prodSource.equals("2")) // 2007/01/25 再區分選擇前段CELL工令號或舊庫存批
						{        out.println("<font color='#330099'><span class='style1'>&nbsp;</span>CELL工令來源</font>");
							//String sqlCellSource = "",whereCellSource="";
							//-----取CELL工令來源別
							Statement stateCell=con.createStatement();
							ResultSet rsCell=null;
							String sqlCellSource = " select CODE, CODE_DESC from apps.YEW_MFG_DEFDATA ";
							String whereCellSource = " where DEF_TYPE='CELL_SOURCE'  ";

							sqlCellSource = sqlCellSource + whereCellSource;
							//out.println(sqlOrgInf);
							rsCell=stateCell.executeQuery(sqlCellSource);
							comboBoxBean.setRs(rsCell);
							comboBoxBean.setSelection(cellSource);
							comboBoxBean.setFieldName("CELLSOURCE");
							out.println(comboBoxBean.getRsString());
							rsCell.close();
							stateCell.close();

						}  // end of prodSource
						else {
				%>
				<font color="#330099"><span class="style1">&nbsp;</span>切割尺寸</font>
				<%
					try
					{
						String sSqlMIL = "";
						String sWhereMIL = "";

						sSqlMIL = "select Unique DICE_MIL as x ,DICE_MIL from APPS.YEW_WFDICE_FACTOR ";
						sWhereMIL= "where DICE_MIL IS NOT NULL order by DICE_MIL";			// 20250606 modify by JB - xxx * xxx issue
						//sWhereMIL= "where DICE_MIL IS NOT NULL order by to_number(DICE_MIL)";
						sSqlMIL = sSqlMIL+sWhereMIL;
						//out.println(sSqlC);
						Statement statementMIL=con.createStatement();
						ResultSet rsMIL=statementMIL.executeQuery(sSqlMIL);
						out.println("<select NAME='DICESIZECH' onChange='setSubmitDiceSize("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
						out.println("<OPTION VALUE=-->--");
						while (rsMIL.next())
						{
							String s1=(String)rsMIL.getString(1);
							String s2=(String)rsMIL.getString(2);

							if (s1.equals(diceSizeCh) || s1.equals(diceSize))
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
							}
							else
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}
						} //end of while
						out.println("</select>");
						rsMIL.close();
						statementMIL.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
				<input type="hidden" tabindex="26" name="DICESIZE" size="5" onMouseOver='this.T_ABOVE=false;this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=diceSizeSug%>")' onKeyDown='setFrontProdNameFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WFRESIST.value,this.form.DICESIZE.value,this.form.WAFERLOT.value,this.form.WOTYPE.value,this.form.MARKETTYPE.value,this.form.MFGDEPTNO.value,this.form.PRODSOURCE.value)' value="<%=diceSize%>"><font color="#CC3300">mil</font>
				<font color="#330099"><span class="style1">&nbsp;</span>阻值(電壓)</font>
				<%
						try
						{
							String sSqlVTG = "";
							String sWhereVTG = "";

							sSqlVTG = "select Unique VOTAGE_RESIST as x ,VOTAGE_RESIST from APPS.YEW_WFDICE_FACTOR ";
							sWhereVTG= "where DICE_MIL = '"+diceSizeCh+"' order by VOTAGE_RESIST ";
							sSqlVTG = sSqlVTG+sWhereVTG;
							//out.println(sSqlC);
							Statement statementVTG=con.createStatement();
							ResultSet rsVTG=statementVTG.executeQuery(sSqlVTG);
							comboBoxBean.setRs(rsVTG);
							if (wfResistCh!=null && !wfResistCh.equals("--")) comboBoxBean.setSelection(wfResistCh);
							comboBoxBean.setFieldName("WFRESISTCH");
							out.println(comboBoxBean.getRsString());
							rsVTG.close();
							statementVTG.close();
						} //end of try
						catch (Exception e)
						{
							out.println("Exception:"+e.getMessage());
						}

					} // End of if (cellSource.equals("1"))
				%>
				<input type="hidden" tabindex="25" name="WFRESIST" size="5" onMouseOver='this.T_ABOVE=false;this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=wfResistSug%>")' value="<%=wfResist%>"><font color="#CC3300">Ω-cm(V)</font>
				<input type="text" name="SUPPLIER_LOT" size="20" value="<%=%>"><font color="#CC3300"><% if (prodSource==null || prodSource.equals("1")) { %>晶片晶粒料號或檢驗批號<% } else if (prodSource.equals("2")) { %>CELL工令號或半成品號<% } %></font>
				<input name="button3" type="button" tabindex="27" onClick='subWinFrontProdNameFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,0,0,this.form.WAFERLOT.value,this.form.WOTYPE.value,this.form.MARKETTYPE.value,this.form.MFGDEPTNO.value,this.form.PRODSOURCE.value,this.form.SUPPLIER_LOT.value)' value="查詢">
				<%

				}
				else {
				%>
				<font color="#330099"><span class="style1">&nbsp;</span>切割尺寸</font>
				<%
					try
					{
						String sSqlMIL = "";
						String sWhereMIL = "";

						sSqlMIL = "select Unique DICE_MIL as x ,DICE_MIL from APPS.YEW_WFDICE_FACTOR ";
						sWhereMIL= "where DICE_MIL IS NOT NULL order by DICE_MIL";		  			// 20250606 modify by JB - xxx * xxx issue
						//sWhereMIL= "where DICE_MIL IS NOT NULL order by to_number(DICE_MIL)";
						sSqlMIL = sSqlMIL+sWhereMIL;
						//out.println(sSqlC);
						Statement statementMIL=con.createStatement();
						ResultSet rsMIL=statementMIL.executeQuery(sSqlMIL);
						out.println("<select NAME='DICESIZECH' onChange='setSubmitDiceSize("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
						out.println("<OPTION VALUE=-->--");
						while (rsMIL.next())
						{
							String s1=(String)rsMIL.getString(1);
							String s2=(String)rsMIL.getString(2);

							if (s1.equals(diceSizeCh) || s1.equals(diceSize))
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
							}
							else
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}
						} //end of while
						out.println("</select>");
						rsMIL.close();
						statementMIL.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
				<input type="hidden" tabindex="26" name="DICESIZE" size="5" onMouseOver='this.T_ABOVE=false;this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=diceSizeSug%>")' onKeyDown='setFrontProdNameFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WFRESIST.value,this.form.DICESIZE.value,this.form.WAFERLOT.value,this.form.WOTYPE.value,this.form.MARKETTYPE.value,this.form.MFGDEPTNO.value,1)' value="<%=diceSize%>"><font color="#CC3300">mil</font>
				<font color="#330099"><span class="style1">&nbsp;</span>阻值(電壓)</font>
				<%
					try
					{
						String sSqlVTG = "";
						String sWhereVTG = "";

						sSqlVTG = "select Unique VOTAGE_RESIST as x ,VOTAGE_RESIST from APPS.YEW_WFDICE_FACTOR ";
						sWhereVTG= "where DICE_MIL = '"+diceSizeCh+"' order by VOTAGE_RESIST ";
						sSqlVTG = sSqlVTG+sWhereVTG;
						//out.println(sSqlC);
						Statement statementVTG=con.createStatement();
						ResultSet rsVTG=statementVTG.executeQuery(sSqlVTG);
						comboBoxBean.setRs(rsVTG);
						if (wfResistCh!=null && !wfResistCh.equals("--")) comboBoxBean.setSelection(wfResistCh);
						comboBoxBean.setFieldName("WFRESISTCH");
						out.println(comboBoxBean.getRsString());
						rsVTG.close();
						statementVTG.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
				<input type="hidden" tabindex="25" name="WFRESIST" size="5" onMouseOver='this.T_ABOVE=true;this.T_WIDTH=120;this.T_OPACITY=80;return escape("<%=wfResistSug%>")' value="<%=wfResist%>"><font color="#CC3300">Ω-cm(V)</font>
				<input type="text" name="SUPPLIER_LOT" size="20" value="<%=%>"><font color="#CC3300">檢驗批號</font>
				<input name="button3" type="button" tabindex="27" onClick='subWinFrontProdNameFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WFRESISTCH.value,this.form.DICESIZECH.value,this.form.WAFERLOT.value,this.form.WOTYPE.value,this.form.MARKETTYPE.value,this.form.MFGDEPTNO.value,1,this.form.SUPPLIER_LOT.value)' value="查詢">
				<%
					} // end of else
				%>
			</td>
		</tr>
		<tr bgcolor="#D1E2FE">
			<td width="16%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>晶片批號<img src="../image/point.gif"></font></td>
			<td width="13%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>供應商</font></td>
			<td width="7%"  align="left"       ><font color="#330099"><span class="style1">&nbsp;</span>下線片數</font></td>
			<td width="7%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>晶片數量</font></td>
			<td width="6%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>晶片單位</font></td>
			<td width="7%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>晶片良率</font></td>
			<td width="7%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>安培數</font></td>
			<td width="16%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>檢驗單號<img src="../image/point.gif"></font></td>
			<td width="10%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>晶片類別</font></td>
			<td width="11%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>切割流程卡號</font></td>
		</tr>
		<tr>
			<td align="left" nowrap><span class="style1">&nbsp;</span><input type="text" name="WAFERLOT" tabindex="28" size="18" onKeyDown='setWaferLotFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WAFERLOT.value)'>
				<input name="button3" type="button" tabindex="29" onClick='subWinWaferLotFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WAFERLOT.value,this.form.MARKETTYPE.value)' value="...">
			</td>
			<td align="left"><span class="style1">&nbsp;</span><input size="15" name="WAFERVENDOR" tabindex='30' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERUSEDPCE" tabindex='19' value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="5" name="WAFERQTY" tabindex='31' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="5" name="WAFERUOM" tabindex='32' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="5" name="WAFERYLD" tabindex='33' readonly value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="5" name="TSCAMP" tabindex='34' readonly value="<%=%>" ></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="20" name="WAFERIQCNO" tabindex='35' value="<%=%>" ></td>
			<input name="WAFERELECT" type="HIDDEN" value="<%=waferElect%>">
			<td align="left"><span class="style1">&nbsp;</span><input name="WAFERKIND" type="TEXT" tabindex='36' size="5" readonly value="<%=waferKind%>"></td>
			<input name="WAFERLINENO" type="HIDDEN" value="<%=waferLineNo%>">
			<td align="left"><span class="style1">&nbsp;</span><input type="text" tabindex="37" name="FRONTRUNCARD" size="12" readonly=""></td>
		</tr></table>
	<% } // end if woType == "2"

		if( woType == "3" || woType.equals("3") ||  (woType=="5" || woType.equals("5")) )  //後段工單的輸入畫面 ,20090114 liling wotype=5
		{ %>
	<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td colspan="8"><font color="#330099"><span class="style1">&nbsp;</span>半成品料號</font>
				<input type="text" tabindex="38" name="FRONTRUNCARD" size="12" onKeyDown='setFrontRunCardFindCheck(this.form.FRONTRUNCARD.value,this.form.MARKETTYPE.value,this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.OEORDERNO.value,this.form.ITEMID.value,this.form.SEMIITEMID.value,this.form.ALTERNATEROUTING.value)'>
				<input name="button3" type="button" tabindex="39" onClick='subWinFrontRunCardFindCheck(this.form.FRONTRUNCARD.value,this.form.MARKETTYPE.value,this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.OEORDERNO.value,this.form.ITEMID.value,this.form.SEMIITEMID.value,this.form.ALTERNATEROUTING.value)' value="查詢">
				<input name="button4" type="button" tabindex="40"  value="重置" onClick='setReset("../jsp/TSCMfgWoCreate.jsp")'>
				<font color="#330099"><span class="style1">&nbsp;</span><input name="SEMIITEMTITLE" type="text" class="koko" size=10  readonly value="<%=semiItemTitle%>"><input name="SEMIITEMID" type="hidden" class="koko" size=5  readonly value=<%=semiItemID%>>
					<input type="text" class="koko" name="SEMIINVITEM" size=15 readonly value=<%=semiInvItem%>>&nbsp;<input type="text" class="koko" name="SEMIITEMDESC" size=25 readonly value=<%=semiItemDesc%>></font>
			</td>
		</tr>
		<tr bgcolor="#D1E2FE">
			<td width="15%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>銷售訂單號<img src="../image/point.gif"></font></td>
			<td width="9%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>訂單項次數量</font></td>
			<td width="19%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>客戶名稱</font></td>
			<td width="13%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>客戶訂購單號</font></td>
			<td width="9%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>TSC_PACKAGE</font></td>
			<td width="10%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>TSC_Family</font></td>
			<td width="9%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>TSC_Packing</font></td>
			<td width="16%" align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>外購供應商批號</font></td>
		</tr>
		<tr>
			<td align="left" nowrap><span class="style1">&nbsp;</span><input type="text" name="OEORDERNO" tabindex="41" size="15" onKeyDown='setMoFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.OEORDERNO.value,this.form.ITEMID.value,"<%=marketType%>",this.form.SEMIITEMID.value,this.form.FRONTRUNCARD.value,this.form.OELINEQTY.value,"<%=alternateRouting%>")' value="<%=oeOrderNo%>">
				<input name="button3" type="button" tabindex="42" onClick='subWinMoFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.OEORDERNO.value,"<%=marketType%>",this.form.SEMIITEMID.value,this.form.FRONTRUNCARD.value,this.form.OELINEQTY.value,this.form.WOTYPE.value,"<%=alternateRouting%>")' value="...">
			</td>
			<td bgcolor="#D1E2FE" align="left" nowrap><input name="OELINEQTY" type="text" size="8" class="koko" readonly value=<%=oeLineQty%>><input name="OEQTYUOM" type="text" size="5" class="koko" readonly value=<%=oeQtyUom%>></td>
			<td bgcolor="#D1E2FE" align="left" nowrap><input name="CUSTOMERNAME" tabindex='43' type="text" size="30" value="<%=customerName%>" class="koko" readonly ></td>
			<td bgcolor="#D1E2FE" align="left" nowrap><input name="CUSTOMERPO" tabindex='44' type="text" size="18" value="<%=customerPo%>" class="koko"  readonly ></td>
			<td bgcolor="#D1E2FE" align="left" nowrap><input name="TSCPACKAGE" tabindex='46' type="text" size="8" value="<%=tscPackage%>" class="koko"  readonly ></td>
			<td bgcolor="#D1E2FE" align="left" nowrap><input name="TSCFAMILY" tabindex='47' type="text" size="8" value="<%=tscFamily%>" class="koko"  readonly ></td>
			<td bgcolor="#D1E2FE" align="left" nowrap><input name="TSCPACKING" tabindex='48' type="text" size="8" value="<%=tscPacking%>" class="koko"  readonly ></td>
			<td bgcolor="#D1E2FE" align="left" nowrap><input name="OPSUPPLIERLOT" tabindex='49' type="text" size="15" value="<%=opSupplierLot%>" class="koko" readonly ></td>
			<input name="WAFERIQCNO" type='hidden' size="18" value="<%=%>" readonly>
			<input name="WAFERLINENO" type="HIDDEN" size="5" value="<%=%>" readonly>
		</tr></table>
	<%  } // end if woType == "3"
		if (woType == "7" || woType.equals("7"))
		{
	%>
	<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td width="15%" align="left"       ><font color="#330099"><span class="style1">&nbsp;</span>工程、實驗晶片批號<img src="../image/point.gif"></font></td>
			<td width="18%" align="left"       ><font color="#330099"><span class="style1">&nbsp;</span>供應商</font></td>
			<td width="10%" align="left"       ><font color="#330099"><span class="style1">&nbsp;</span>晶粒尺寸</font></td>
			<td width="9%"  align="left"       ><font color="#330099"><span class="style1">&nbsp;</span>阻值(電壓)</font></td>
			<td width="7%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>下線片數<img src="../image/point.gif"></font></td>
			<td width="6%"  align="left"       ><font color="#330099"><span class="style1">&nbsp;</span>晶片數量</font></td>
			<td width="6%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>晶片單位</font></td>
			<td width="6%"  align="left" nowrap><font color="#330099"><span class="style1">&nbsp;</span>晶片良率</font></td>
			<td width="9%"  align="left"       ><font color="#330099"><span class="style1">&nbsp;</span>檢驗單號<img src="../image/point.gif"></font></td>
			<td width="8%"  align="left"       ><font color="#330099"><span class="style1">&nbsp;</span>晶片類別</font></td>
		</tr>
		<tr>
			<td align="left" nowrap><span class="style1">&nbsp;</span><input type="text" name="WAFERLOT" tabindex="10" size="15" onKeyDown='setWaferLotFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WAFERLOT.value,this.form.MARKETTYPE.value)' value="<%=waferLot%>">
				<input name="BUTTON3" type="button" tabindex="17" onClick='subWinWaferLotFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WAFERLOT.value)' value="...">
			</td>
			<td align="left" nowrap=><span class="style1">&nbsp;</span><input size="15" name="SUPPLYVND" tabindex='18' value="<%=supplyVnd%>"><input type="hidden" size="3" name="SUPPLYVNDID" value=""><input type="hidden" size="3" name="SUPPLYVNDNO" value="">
				<input name="BUTTON4" type="button" tabindex="20" onClick='subWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)' value="...">
			</td>
			<td align="left"><span class="style1">&nbsp;</span>
				<%//
					try
					{
						String sSqlMIL = "";
						String sWhereMIL = "";

						sSqlMIL = "select Unique DICE_MIL as x ,DICE_MIL from APPS.YEW_WFDICE_FACTOR ";
						sWhereMIL= "where DICE_MIL IS NOT NULL order by DICE_MIL";		  		  			// 20250606 modify by JB - xxx * xxx issue
						//sWhereMIL= "where DICE_MIL IS NOT NULL order by to_number(DICE_MIL)";
						sSqlMIL = sSqlMIL+sWhereMIL;
						//out.println(sSqlC);
						Statement statementMIL=con.createStatement();
						ResultSet rsMIL=statementMIL.executeQuery(sSqlMIL);
						out.println("<select NAME='DICESIZECH' onChange='setSubmitDiceSize("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
						out.println("<OPTION VALUE=-->--");
						while (rsMIL.next())
						{
							String s1=(String)rsMIL.getString(1);
							String s2=(String)rsMIL.getString(2);

							if (s1.equals(diceSizeCh) || s1.equals(diceSize))
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
							}
							else
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}
						} //end of while
						out.println("</select>");
						rsMIL.close();
						statementMIL.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}

				%>
			</td>
			<td align="left"><span class="style1">&nbsp;</span>
				<%//
					try
					{
						String sSqlVTG = "";
						String sWhereVTG = "";

						sSqlVTG = "select Unique VOTAGE_RESIST as x ,VOTAGE_RESIST from APPS.YEW_WFDICE_FACTOR ";
						sWhereVTG= "where DICE_MIL = '"+diceSizeCh+"' order by VOTAGE_RESIST ";
						sSqlVTG = sSqlVTG+sWhereVTG;
						//out.println(sSqlC);
						Statement statementVTG=con.createStatement();
						ResultSet rsVTG=statementVTG.executeQuery(sSqlVTG);
						comboBoxBean.setRs(rsVTG);
						if (wfResistCh!=null && !wfResistCh.equals("--")) comboBoxBean.setSelection(wfResistCh);
						comboBoxBean.setFieldName("WAFERELECT");
						out.println(comboBoxBean.getRsString());
						rsVTG.close();
						statementVTG.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
			</td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERUSEDPCE" tabindex='19' value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERQTY" tabindex='20' value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERUOM" tabindex='21' value="PCE"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="4" name="WAFERYLD" tabindex='22' value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span><input size="10" name="WAFERIQCNO" tabindex='24' value="<%=%>"></td>
			<td align="left"><span class="style1">&nbsp;</span>
				<%
					try
					{
						String sSqlWfType = "";
						sSqlWfType = "select WF_TYPE_NAME as WAFERKIND, WF_TYPE_NAME from ORADDMAN.TSCIQC_WAFER_TYPE ";
						//out.println(sSqlC);
						Statement statementWfType=con.createStatement();
						ResultSet rsWfType=statementWfType.executeQuery(sSqlWfType);
						comboBoxBean.setRs(rsWfType);
						if (waferKind!=null && !waferKind.equals("--")) comboBoxBean.setSelection(waferKind);
						comboBoxBean.setFieldName("WAFERKIND");
						out.println(comboBoxBean.getRsString());
						rsWfType.close();
						statementWfType.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
			</td>
			<input name="WAFERLINENO" type="HIDDEN" value="<%=waferLineNo%>">
		</tr></table>
	<%  } // End of else if (woType=="7" || woType.equals("7"))

		/* ========取 alternaateRouting及Routing Id	 ==============*/
	/*
	try{

	   String sqlb  =  " select distinct ROUTING_SEQUENCE_ID ROUTING_ID from BOM_OPERATIONAL_ROUTINGS ";
	   String whereb = " where ASSEMBLY_ITEM_ID= "+itemId+"  and ORGANIZATION_ID = "+organizationId;

       if (alternateRoutingDesignator !=null && !alternateRoutingDesignator.equals(""))
	   {
	     whereb=whereb+" and ALTERNATE_ROUTING_DESIGNATOR = '"+alternateRoutingDesignator+"'";
	   }
	   else
	   {
	    whereb=whereb+" and ALTERNATE_ROUTING_DESIGNATOR is null ";
	   }

       sqlb=sqlb+whereb;
	   //out.print("sqlb="+sqlb);
	   Statement stateb=con.createStatement();
       ResultSet rsb=stateb.executeQuery(sqlb);
	   if (rsb.next())
	   {
		    routingRefID   = rsb.getString("ROUTING_ID");   // Fix By Kerwin Since rsb write by rsa from liling
	        //out.print("routingId="+routingId);
		}
		else
		{
		 routingRefID="0";
		 //  out.print("routingId="+routingId);
		}
	   rsb.close();
       stateb.close();
	   //out.print("routingId="+routingId);

	     } //end of try
     catch (Exception e)
     {
	    e.printStackTrace();
        out.println("EXCEPTION 97:"+e.getMessage());
     }//end of catch
   */

		/* ========取 判斷item有無lot control 2007/6/13 by liling add	 ==============*/

		try{

			String sqlb  =  "  select LOT_CONTROL_CODE from MTL_SYSTEM_ITEMS  where SEGMENT1='"+invItem+"'   and ORGANIZATION_ID = "+organizationId+" ";
			// out.print("sqlb="+sqlb);
			Statement stateb=con.createStatement();
			ResultSet rsb=stateb.executeQuery(sqlb);
			if (rsb.next())
			{
				lotControl   = rsb.getString("LOT_CONTROL_CODE");   // code=1 not contorl code=2 full control
				//   out.print("<br>lotControl="+lotControl);
			}
			rsb.close();
			stateb.close();
			//out.print("routingId="+routingId);

		} //end of try
		catch (Exception e)
		{
			e.printStackTrace();
			out.println("EXCEPTION sqlb:"+e.getMessage());
		}//end of catch

		/* ========取 判斷item有無lot control 2007/6/13 by liling add	end ==============*/

	%>
	<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td><font color="#330099"><span class="style1">&nbsp;</span>附註</font></td>
			<td colspan="4"><input name="WOREMARK" tabindex='49' type="text" size="80" value="<%=%>"></td>
			<td ><div align="left"><INPUT TYPE="button" tabindex="50" value='新增' onClick='setSubmitAdd("../jsp/TSCMfgWoCreate.jsp?INSERT=Y",this.form.WOTYPE.value)'>
			</div></td>
		</tr>
		<tr bgcolor="#D1E2FE">
			<td colspan="13"><div align="left"><strong>
				<%
					try
					{
						String oneDArray[]= {"","項次","台半品名","品名規格說明","工令數量","單位","工令開始日期","工令完工日","內外銷型態","工令類別","Alt Routing","IQC檢驗批號","晶片(粒)數量","備註","料號識別碼","MO單項次識別碼","客戶識別碼","工令前置碼","MO單項次","追溯序號","製成品單位用量","下線片數","替代BOM識別碼","替代製程識別碼","完工入庫別"};
						//String oneDArray[]= {"","項次","台半品名","品名規格說明","工令數量","單位","工令開始日期","工令完工日","內外銷型態","工令類別","Alt Routing","IQC檢驗批號","晶片(粒)數量","備註","料號識別碼","MO單項次識別碼","客戶識別碼","工令前置碼","MO單項次","追溯序號","製成品單位用量","下線片數","ALTBOMSEQID","ALTROUTINGID","SUBINV"};
						//String oneDArray[]= {"","項次","台半品名","品名規格說明","工令數量","單位","工令開始日期","工令完工日","內外銷型態","工令類別","Alt Routing","IQC檢驗批號","晶片(粒)數量","備註","料號識別碼","MO單項次識別碼","客戶識別碼","工令前置碼","MO單項次","追溯序號","製成品單位用量"};
						arrayWODocumentInputBean.setArrayString(oneDArray);
						String a[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容
						int i=0,j=0,k=0;
						String dupFLAG="FALSE";

						if (( (invItem !=null && !invItem.equals("")) || (itemDesc!=null && !itemDesc.equals("")) ))//bringLast是用來識別是否帶出上一次輸入之最新版本資料
						{  //out.println("step1");

							//若沒選擇alternate bom or routing ,則使用標準的id
							if (woType !="4" && !woType.equals("4"))
							{    //out.print("itemId="+itemId);
								if ( altBomSeqID==null || altBomSeqID.equals(""))
								{
									String BomId=" select BILL_SEQUENCE_ID from BOM_BILL_OF_MATERIALS where ASSEMBLY_ITEM_ID="+itemId+" "+
											"    and alternate_bom_designator is null  and organization_id="+organizationId+" ";
									//out.print("BomId="+BomId);
									Statement stateBomId=con.createStatement();
									ResultSet rsBomId=stateBomId.executeQuery(BomId);
									if (rsBomId.next())
									{
										altBomSeqID = rsBomId.getString(1);
										altBomDest = "";
									} else {
				%>
				<script language="javascript">
					alert("選擇的料號無BOM表於Oracle系統\n此工令將無法成功儲存,請再確認!!!");
				</script>
				<%
							altBomSeqID = "0";
						}
						rsBomId.close();
						stateBomId.close();
					}

					if ( routingRefID==null || routingRefID.equals(""))
					{
						String rId=" select ROUTING_SEQUENCE_ID  from BOM_OPERATIONAL_ROUTINGS where ASSEMBLY_ITEM_ID="+itemId+" "+
								"    and ALTERNATE_ROUTING_DESIGNATOR is null and organization_id="+organizationId+" ";
						Statement staterId=con.createStatement();
						//out.print("rId="+rId);
						ResultSet rsrId=staterId.executeQuery(rId);
						if (rsrId.next())
						{
							routingRefID =  rsrId.getString(1);
							altRoutingDest="";
						} else {
							routingRefID = "0";
				%>
				<script language="javascript">
					alert("選擇的料號無Routing設定於Oracle系統\n此工令將無法成功儲存,請再確認!!!");
				</script>
				<%
									}
									rsrId.close();
									staterId.close();
								}
							}//end if wotype!=4

							// 依使用者輸入的料號ID取其單位
							if (a!=null)
							{ //out.println("step2" );
								//out.println("length"+a[0].length );
								String b[][]=new String[a.length+1][a[i].length];
								for (i=0;i<a.length;i++)
								{ //out.println("step3");
									for (j=0;j<a[i].length;j++)
									{ //out.println("step4");


										b[i][j]=a[i][j];  //

									} // End of for (j=0)
									k++;
								}// End of for (i=0)
								iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
								b[k][0]=iNo;
								b[k][1]=invItem;
								b[k][2]=itemDesc;
								b[k][3]=woQty;
								b[k][4]=woUom;
								b[k][5]=startDate;
								b[k][6]=endDate;
								b[k][7]=marketType;       // 不顯示於JavaBean(Title=8)
								b[k][8]=woType;           // 不顯示於JavaBean(Title=9)
								b[k][9]=alternateRouting; // 不顯示於JavaBean(Title=10)
								b[k][10]=waferIqcNo;
								b[k][11]=waferQty;
								b[k][12]=woRemark;
								b[k][13]=itemId;          // 不顯示於JavaBean(Title=14)
								b[k][14]=oeLineId;        // 不顯示於JavaBean(Title=15)
								b[k][15]=customerId;      // 不顯示於JavaBean(Title=16)
								b[k][16]=preFix;          // 不顯示於JavaBean(Title=17)
								b[k][17]=waferLineNo;     // 不顯示於JavaBean(Title=18)
								b[k][18]=frontRunCard;
								b[k][19]=woUnitQty;       // 不顯示於JavaBean(Title=20)
								b[k][20]=waferUsedPce;
								b[k][21]=altBomSeqID;
								b[k][22]=routingRefID;
								b[k][23]=altBomDest;       // 不顯示於JavaBean(Title=24)
								b[k][24]=altRoutingDest;   // 不顯示於JavaBean(Title=25)
								b[k][25]=oeOrderNo;        // 不顯示於JavaBean(Title=26)
								b[k][26]=oeHeaderId;       // 不顯示於JavaBean(Title=27)
								b[k][27]=oeLineId;         // 不顯示於JavaBean(Title=28)
								b[k][28]=subInv;

								if (woType!=null && woType.equals("1")) // 如為切割工令往前連結為晶片批號,故將晶片批號給予frontRunCard儲存的b[k][18]陣列值
								{
									b[k][18]=waferLot;
								}

								arrayWODocumentInputBean.setArray2DString(b);

							} else {	 //out.println("step5: 若為第一筆資料,則填入抬頭");
								// String c[][]={{iNo,invItem,itemDesc,woQty,woUom,startDate,endDate,marketType,woType,alternateRouting,waferIqcNo,waferQty,woRemark,itemId,oeLineId,customerId,preFix,waferLineNo,frontRunCard,woUnitQty}};
								String c[][]={{iNo,invItem,itemDesc,woQty,woUom,startDate,endDate,marketType,woType,alternateRouting,waferIqcNo,waferQty,woRemark,itemId,oeLineId,customerId,preFix,waferLineNo,frontRunCard,woUnitQty,waferUsedPce,altBomSeqID,routingRefID,altBomDest,altRoutingDest,oeOrderNo,oeHeaderId,oeLineId,subInv}};
								if (woType!=null && woType.equals("1")) // 如為切割工令往前連結為晶片批號,故將晶片批號給予frontRunCard儲存的b[k][18]陣列值
								{
									c[0][18]=waferLot;
								}
								arrayWODocumentInputBean.setArray2DString(c);
							}

						} else { //out.println("step6:未輸入欄位內容作 Add ,表示點擊刪除鍵");
							if (a!=null)
							{ //out.println("step7:若陣列內原已有存入內容,則把內容在置入");
								arrayWODocumentInputBean.setArray2DString(a);
							}
						}
						//###################針對目前陣列內容進行檢查機制#############################
						Statement chkstat=con.createStatement();
						ResultSet chkrs=null;
						String T2[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容做為暫存用;
						String tp[]=arrayWODocumentInputBean.getArrayContent();
						if  (T2!=null)
						{
							//-------------------------取得轉存用陣列--------------------
							String temp[][]=new String[T2.length][T2[0].length];
							for (int ti=0;ti<T2.length;ti++)
							{
								for (int tj=0;tj<T2[ti].length;tj++)
								{
									temp[ti][tj]=T2[ti][tj];
								}
							}
							//--------------------------------------------------------------------
							int ti = 0;
							int tj = 0;

							temp[ti][tj]="N";
							arrayWODocumentInputBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用
						} else {
							arrayWODocumentInputBean.setArray2DCheck(null);
						}	 //end if of T2!=null
						if (chkrs!=null) chkrs.close();
						chkstat.close();
						//##############################################################
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					try
					{
						String a[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容
						float total=0;

					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					try
					{   // 如果INSERT 傳入參數不為 Y ,表示不為輸入模式,清空 Array
						if (insertPage==null || insertPage.equals("")) // 若輸入模式離開此頁面,則BeanArray內容清空
						{
							arrayWODocumentInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
						}

					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%></strong></div>
			</td>
		</tr>
	</table>
	<HR>
	<table cellSpacing="0" bordercolordark="#6699CC"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td>
				<input name="button" tabindex='42' type=button onClick="this.value=check(this.form.ADDITEMS)" value='選擇全部'>
				<font color="#336699" size="2">-----DETAIL you choosed to be saved----------------------------------------------------------------------------------------------------</font>
			</td>
		</tr>
		<tr bgcolor="#D1E2FE">
			<td>
				<%
					int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
					try
					{
						String a[][]=arrayWODocumentInputBean.getArray2DContent();//取得目前陣列內容
						if (a!=null)
						{
							div1=a.length;
							div2=a[0].length;
							arrayWODocumentInputBean.setFieldName("ADDITEMS");
							//out.println(arrayRFQDocumentInputBean.getArray2DString());
							//out.println(arrayWODocumentInputBean.getArray2D2KeyString());  // 用Item 及Item Description 作為Key 的Method
							out.println(arrayWODocumentInputBean.getArray2DWIPString());  // 用Item 及Item Description 作為Key 的Method
							isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y"

							inpLen = div1; // 第一筆Item 被寫入時

						}	//enf of a!=null if
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				%>
			</td>
		</tr>
		<tr bgcolor="#D1E2FE">
			<td>
				<INPUT name="button2" tabindex='43' TYPE="button" onClick='setSubmit3("../jsp/TSCMfgWoCreate.jsp?INSERT=Y")'  value='刪除' >
				<%
					if (isModelSelected =="Y" || isModelSelected.equals("Y")) out.println("<font color='#336699' size='2'>-----CLICK checkbox and choice to delete---------------------------------------------------------------------------------------------------");
				%>
			</td>
		</tr>
	</table>
	<HR>
	<table cellSpacing="0" bordercolordark="#6699CC"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
		<tr bgcolor="#D1E2FE">
			<td width="12%" bgcolor="#D1E2FE" align="center"><strong><font color="#330099" face="Arial">部門名稱</font></strong></td>
			<td width="10%" bgcolor="#FFFFFF" align="center"><font color='#000099' face="Arial"><strong><%=userMfgDeptName%></strong></font></td>
			<td width="12%" align="center"><strong><font color="#330099" face="Arial">處理人員</font></strong></td>
			<td width="15%" bgcolor="#FFFFFF" align="center"><font color='#000099' face="Arial" ><strong><%=userID+"("+UserName+")"%></strong></font></td>
			<td width="10%" bgcolor="#D1E2FE" align="center"><strong><font color="#330099" face="Arial">處理日期</font></strong></td>
			<td width="10%" bgcolor="#FFFFFF" align="center"><font color="#000099" face="Arial"><strong><% out.println(dateBean.getYearMonthDay());%></strong></font></td>
			<td width="10%" bgcolor="#D1E2FE" align="center"><strong><font color="#330099" face="Arial" >處理時間</font></strong></td>
			<td width="10%" bgcolor="#FFFFFF" align="center"><font color='#000099' face="Arial" ><strong><%out.println(dateBean.getHourMinuteSecond());%></strong></font></td>
		</tr>
	</table>
	<BR>
	<INPUT TYPE="button" tabindex='44' value='存檔' onClick='setSubmitSave("../jsp/TSCMfgWoInsert.jsp?INSERT=Y","<%=altBomSeqID%>","<%=routingRefID%>")' >
	&nbsp;<font color="#CC0066"><strong><input name="REPEATINPUT" type="checkbox" <% if (repeatInput==null ||  repeatInput.equals("")) { out.println("unchecked");  } else if (repeatInput=="on" || repeatInput.equals("on")){ out.println("unchecked"); } else {} %>>重覆新增製造工令頁面</strong></font>
	<!-- 表單參數 -->
	<input name="INSERT"          type="HIDDEN" value="<%=%>">
	<input name="ISMODELSELECTED" type="HIDDEN" value="<%=isModelSelected%>" size=2>  <!--做為判斷是否已選取新增機型明細-->
	<input name="SAMPLEORDER"     type="HIDDEN" value="<%=%>">
	<input name="SPQP"            type="HIDDEN" value="<%=%>">
	<input name="MOQP"            type="HIDDEN" value="<%=%>">
	<input name="ORDERQTY"        type="HIDDEN" value="<%=orderQty%>">
	<input name="REQUESTDATE"     type="HIDDEN" value="<%=%>">
	<input name="PREFIX"          type="HIDDEN" value="<%=preFix%>">
	<input name="OELINEQTY"       type="HIDDEN" value="<%=oeLineQty%>">
	<input name="TSCAMP"          type="HIDDEN" value="<%=tscAmp%>">
	<input name="DATECODE"        type="HIDDEN" value="<%=%>">
	<input name="ITEMID"          type="HIDDEN" value="<%=itemId%>">
	<input name="OEHEADERID"      type="HIDDEN" value="<%=oeHeaderId%>">
	<input name="OELINEID"        type="HIDDEN" value="<%=oeLineId%>">
	<input name="CUSTOMERID"      type="HIDDEN" value="<%=customerId%>">
	<input name="ORGANIZATIONID"  type="HIDDEN" value="<%=organizationId%>">
	<input name="LOTCONTROL"      type="HIDDEN" value="<%=lotControl%>">
	<input name="CUSTLOTALERT"    type="HIDDEN" value="<%=custLotAlert%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
