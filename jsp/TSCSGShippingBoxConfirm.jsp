<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	var id ="";
	if (document.MYFORM.chk1.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk1.length ;i++)
		{
			document.MYFORM.chk1[i].checked= document.MYFORM.chkall.checked;
		}
	}
	else
	{
		if (document.MYFORM.chk1.disabled==false)
		{
			document.MYFORM.chk1.checked = document.MYFORM.chkall.checked;
		}
	}
}
function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var carton_num=0;
	var SNO="",ENO="",SHIPPING_METHOD="",CUST_PO="";

	document.MYFORM.save1.disabled=true;
	document.MYFORM.exit1.disabled=true;

	if (document.MYFORM.chk1.length != undefined)
	{
		iLen = document.MYFORM.chk1.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=0; i< iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk1.checked;
			lineid = document.MYFORM.chk1.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk1[i].checked;
			lineid = document.MYFORM.chk1[i].value;
		}
		if (chkvalue==true)
		{
			if (document.MYFORM.elements["SNO_"+lineid].value ==null || document.MYFORM.elements["SNO_"+lineid].value =="")
			{
				alert("項次"+i+":起始箱號不可空白!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;				
			}
			if (document.MYFORM.elements["ENO_"+lineid].value ==null || document.MYFORM.elements["ENO_"+lineid].value =="")
			{
				alert("項次"+i+":結束箱號不可空白!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;				
			}
			if (parseInt(document.MYFORM.elements["ENO_"+lineid].value)<parseInt(document.MYFORM.elements["SNO_"+lineid].value))
			{
				alert("項次"+i+":結束箱號不可小於起始箱號!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;		
			}
			if (document.MYFORM.elements["BOX_CODE_"+lineid].value==null || document.MYFORM.elements["BOX_CODE_"+lineid].value=="" || document.MYFORM.elements["BOX_CODE_"+lineid].value=="null")
			{
				alert("項次"+i+":箱碼不可空白!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;		
			}
			carton_num = parseInt(document.MYFORM.elements["ENO_"+lineid].value)-parseInt(document.MYFORM.elements["SNO_"+lineid].value)+1; 
			if ((carton_num * document.MYFORM.elements["CARTON_QTY_"+lineid].value) != document.MYFORM.elements["SHIP_QTY_"+lineid].value)
			{
				alert("項次"+i+":總出貨量必須等於出貨數量!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;		
			}
			//檢查淨重,add by Peggy 20141121
			if (document.MYFORM.elements["NW_"+lineid].value==null || document.MYFORM.elements["NW_"+lineid].value=="")
			{
				alert("項次"+i+":淨重不可為空值!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;				
			}
			else if (parseFloat(document.MYFORM.elements["NW_"+lineid].value)<=0)
			{
				alert("項次"+i+":淨重不可小於0!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;		
			}	
			if (document.MYFORM.elements["GW_"+lineid].value==null || document.MYFORM.elements["GW_"+lineid].value=="")
			{
				alert("項次"+i+":毛重不可為空值!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;					
			}
			//檢查毛重,add by Peggy 20141121
			else if (parseFloat(document.MYFORM.elements["GW_"+lineid].value)<=0)
			{
				alert("項次"+i+":毛重不可小於0!");
				document.MYFORM.save1.disabled=false;
				document.MYFORM.exit1.disabled=false;
				return false;		
			}	
			
			SHIPPING_METHOD = document.MYFORM.elements["SHIPPING_METHOD_"+lineid].value;
			CUST_PO = document.MYFORM.elements["CUST_PO_"+lineid].value;
			for (var j = i+1; j < iLen ;j++)
			{
				SNO = parseInt(document.MYFORM.elements["SNO_"+document.MYFORM.chk1[j].value].value);
				ENO = parseInt(document.MYFORM.elements["ENO_"+document.MYFORM.chk1[j].value].value);
			 	if ((SNO >= parseInt(document.MYFORM.elements["SNO_"+lineid].value) && SNO <=parseInt(document.MYFORM.elements["ENO_"+lineid].value)) || 
				    (ENO >= parseInt(document.MYFORM.elements["SNO_"+lineid].value) && ENO <=parseInt(document.MYFORM.elements["ENO_"+lineid].value)))
				{
					if ((SHIPPING_METHOD.indexOf("UPS") <0 && SHIPPING_METHOD.indexOf("TNT") <0 && SHIPPING_METHOD.indexOf("DHL") <0 && SHIPPING_METHOD.indexOf("FEDEX")<0 && SHIPPING_METHOD.indexOf("AIR")<0 && SHIPPING_METHOD.indexOf("SEA")<0 && SHIPPING_METHOD.indexOf("TRUCK")<0) || (SHIPPING_METHOD!= document.MYFORM.elements["SHIPPING_METHOD_"+document.MYFORM.chk1[j].value].value))
					{
						alert("項次"+j+"與項次"+i+" 箱號重覆!");
						document.MYFORM.save1.disabled=false;
						document.MYFORM.exit1.disabled=false;
						return false;				
					}
				}
			}	
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		document.MYFORM.save1.disabled=false;
		document.MYFORM.exit1.disabled=false;
		return false;
	}
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{   
	if (confirm("您確定要離開回到上頁功能嗎?")==true) 
	{
		document.MYFORM.ADVISE_NO.value="";
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setSubmit3(URL)
{   
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var pc_advise_id ="";
	var carton_qty=0;
	if (document.MYFORM.chk1.length != undefined)
	{
		iLen = document.MYFORM.chk1.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=0; i< iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk1.checked;
			lineid = document.MYFORM.chk1.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk1[i].checked;
			lineid = document.MYFORM.chk1[i].value;
			pc_advise_id = document.MYFORM.elements["PC_ADVISE_ID_"+lineid].value;
			carton_qty =  document.MYFORM.elements["CARTON_QTY_"+lineid].value;  //add by Peggy 20160607
			if (chkvalue==true && carton_qty !=0)
			{
				for (var j = i+1; j < iLen ;j++)
				{
					if (pc_advise_id==document.MYFORM.elements["PC_ADVISE_ID_"+document.MYFORM.chk1[j].value].value && document.MYFORM.chk1[j].checked==false)
					{
						alert("同一筆訂單的箱號必須一起刪除!");
						return false;
					}
				}
			}
		}
		if (chkvalue==true)
		{
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}

	if (confirm("您確定要刪除此筆編箱資料?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setSubmit4(URL)
{   
	var iLen=0,gw_cnt=0,cbm_cnt=0,tot_carton_num=0,tt_gw =0,tt_nw=0,tt_ship_qty=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var pc_advise_id ="",v_chk="";
	var carton_qty=0;
	var s_nw="",s_gw="";
	if (document.MYFORM.chk2.length != undefined)
	{
		iLen = document.MYFORM.chk2.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=0; i< iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk2.checked;
			lineid = document.MYFORM.chk2.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk2[i].checked;
			lineid = document.MYFORM.chk2[i].value;
		}
		document.MYFORM.elements["NW_"+lineid].style.backgroundColor="#E4EDE2";
		document.MYFORM.elements["GW_"+lineid].style.backgroundColor="#E4EDE2";
		
		if (chkvalue==true)
		{
			document.MYFORM.elements["SNO_"+lineid].style.backgroundColor="#E4EDE2";
			document.MYFORM.elements["ENO_"+lineid].style.backgroundColor="#E4EDE2";		
		 	chkcnt ++;
		}
		//檢查總箱數與原箱數是否一致,add by Peggy 20200805
		tot_carton_num =eval(document.MYFORM.elements["ENO_"+lineid].value)-eval(document.MYFORM.elements["SNO_"+lineid].value)+1;
		if (tot_carton_num != eval(document.MYFORM.elements["TOT_CARTON_NUM_"+lineid].value))
		{
			alert("總箱數須與原箱數("+document.MYFORM.elements["TOT_CARTON_NUM_"+lineid].value+")一致!");
			document.MYFORM.elements["SNO_"+lineid].style.backgroundColor="#AA0000";
			document.MYFORM.elements["ENO_"+lineid].style.backgroundColor="#AA0000";
			document.MYFORM.elements["ENO_"+lineid].focus();
			return false;
		}
		//檢查淨毛重位數只到小數點第二位
		tt_gw =0;tt_nw=0;tt_ship_qty=0;  //add by Peggy 20201211
		s_nw=document.MYFORM.elements["NW_"+lineid].value;
		s_gw=document.MYFORM.elements["GW_"+lineid].value;
		if (s_nw.indexOf(".")>=0 && s_nw.substring(s_nw.indexOf(".")+1).length>2)
		{
			document.MYFORM.elements["NW_"+lineid].style.backgroundColor="#FF9999";
			alert("淨重只允許到小數點第二位!");
			document.MYFORM.elements["NW_"+lineid].focus();
			return false;
		}
		if (s_gw.indexOf(".")>=0 && s_gw.substring(s_gw.indexOf(".")+1).length>2)
		{
			document.MYFORM.elements["GW_"+lineid].style.backgroundColor="#FF9999";
			alert("毛重只允許到小數點第二位!");
			document.MYFORM.elements["GW_"+lineid].focus();
			return false;
		}
				
		gw_cnt =0;cbm_cnt=0;
		v_chk="N";
		if (iLen!=1)
		{
			for (var k=0 ; k <i; k++)
			{
				if ( document.MYFORM.elements["SNO_"+document.MYFORM.chk2[k].value].value ==document.MYFORM.elements["SNO_"+lineid].value && document.MYFORM.elements["ENO_"+document.MYFORM.chk2[k].value].value ==document.MYFORM.elements["ENO_"+lineid].value)
				{
					v_chk="Y";	
					break;
				}
			}
			if (v_chk=="Y") continue;		
		
			for (var j=i ;j < iLen ; j++)
			{
				if ( document.MYFORM.elements["SNO_"+lineid].value ==document.MYFORM.elements["SNO_"+document.MYFORM.chk2[j].value].value && document.MYFORM.elements["ENO_"+lineid].value ==document.MYFORM.elements["ENO_"+document.MYFORM.chk2[j].value].value)
				{
					if (document.MYFORM.elements["CUBE_"+lineid].value !=document.MYFORM.elements["CUBE_"+document.MYFORM.chk2[j].value].value)
					{
						alert("Carton#"+document.MYFORM.elements["SNO_"+lineid].value+" size different!!");
						return false;
					}
					if (document.MYFORM.elements["GW_"+document.MYFORM.chk2[j].value].value!="")
					{
						tt_gw = eval(tt_gw) + eval(document.MYFORM.elements["GW_"+document.MYFORM.chk2[j].value].value);
						gw_cnt++;
					}
					if (document.MYFORM.elements["NW_"+document.MYFORM.chk2[j].value].value!="")
					{
						tt_nw = eval(tt_nw) + eval(document.MYFORM.elements["NW_"+document.MYFORM.chk2[j].value].value);
					}					
					if (document.MYFORM.elements["CBM_"+document.MYFORM.chk2[j].value].value!="0")
					{
						cbm_cnt++;
					}
					tt_ship_qty=tt_ship_qty+eval(document.MYFORM.elements["SHIP_QTY_"+document.MYFORM.chk2[j].value].value); //add by Peggy 20201211
				}		
			}
		}
		else
		{
			if (document.MYFORM.elements["GW_"+document.MYFORM.chk2.value].value!="")
			{
				gw_cnt++;
			}
			if (document.MYFORM.elements["CBM_"+document.MYFORM.chk2.value].value!="0")
			{
				cbm_cnt++;
			}		
		}
		
		if (gw_cnt ==0)
		{
			alert("Carton#"+document.MYFORM.elements["SNO_"+lineid].value+" gross weight can not empty!");
			return false;
		}
		else if (gw_cnt>1)
		{
			alert("Carton#"+document.MYFORM.elements["SNO_"+lineid].value+" please input only one on gross weight filed!");
			return false;
		}
		if (cbm_cnt ==0)
		{
			alert("Carton#"+document.MYFORM.elements["SNO_"+lineid].value+" cubic metert can not empty!");
			return false;
		}	
		var v_num = eval(tt_ship_qty) % eval(document.MYFORM.elements["FULL_CARTON_QTY_"+lineid].value);
		
		if (eval(v_num) ==0)
		{
			
			if (eval(tt_nw)-eval(document.MYFORM.elements["ORIG_NW_1_"+lineid].value)>0.1)
			{
				alert("Carton#"+document.MYFORM.elements["SNO_"+lineid].value+" net weight("+tt_nw+") can not greater than " +eval(document.MYFORM.elements["ORIG_NW_1_"+lineid].value)+"!");
				return false;						
			}
			if (eval(tt_gw) - eval(document.MYFORM.elements["ORIG_GW_1_"+lineid].value)>1)
			{
				alert("Carton#"+document.MYFORM.elements["SNO_"+lineid].value+" gross weight("+tt_gw+") can not greater than " +eval(document.MYFORM.elements["ORIG_GW_1_"+lineid].value)+"!");
				return false;						
			}	
		}	
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}

	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk1.length != undefined)
	{
		chkflag = document.MYFORM.chk1[irow].checked; 
		lineid = document.MYFORM.chk1[irow].value;
	}
	else
	{
		chkflag = document.MYFORM.chk1.checked; 
		lineid = document.MYFORM.chk1.value;
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#E4EDE2";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
	}
}

function setSubmit5(URL)
{
	document.MYFORM.delete1.disabled= true;
	document.MYFORM.exit1.disabled= true;
	subWin=window.open(URL,"subwin","left=200,width=800,height=600,scrollbars=yes,menubar=no");
}

function objCarton(objid)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var icnt=0,iseq=0;
	var lineid="",id1="",id2="";v_chk="";objValue="";
	var TOT_NW=0,TOT_GW=0,TNW=0,TGW=0,TOT_QTY=0,NW=0,GW=0,TT_NW=0;TT_GW=0;TT_C_NUM=0;TT_C_CBM=0,FULL_QTY=0;
	var SHIPPING_METHOD ="";
	if (document.MYFORM.chk2.length != undefined)
	{
		iLen = document.MYFORM.chk2.length;
	}
	else
	{
		iLen = 1;
	}
	if ( document.MYFORM.elements["SNO_"+objid].value == document.MYFORM.elements["ENO_"+objid].value)
	{
		//add by Peggy 20200508,check siemens 
		if (iLen != 1 && document.MYFORM.elements["REGION_CODE_"+objid].value=="TSCE" && document.MYFORM.elements["SHIPPING_REMARKS_"+objid].value.toUpperCase().indexOf("SIEMENS")>=0)
		{
			if (!chkMergeCarton(objid,"CUST_PO"))
			{
				alert("You can not merge to same carton when customer purchase number is diffrent!");
				document.MYFORM.elements["SNO_"+objid].value="";
				document.MYFORM.elements["ENO_"+objid].value="";
				return false;				
			}
		}
		//add by Peggy 20231019,check GENSEMI
		if (iLen != 1 && document.MYFORM.elements["REGION_CODE_"+objid].value=="TSCR-ROW" && document.MYFORM.elements["SHIPPING_REMARKS_"+objid].value.toUpperCase().indexOf("GENSEMI")>=0)
		{
			if (!chkMergeCarton(objid,"SO_LINE"))
			{
				alert("You can not merge to same carton when mo line number is diffrent!");
				document.MYFORM.elements["SNO_"+objid].value="";
				document.MYFORM.elements["ENO_"+objid].value="";
				return false;				
			}
		}		 
		for (var i=0; i<iLen ; i++)
		{
			TOT_QTY=0;
			if (iLen==1)
			{
				lineid = document.MYFORM.chk2.value;
				TOT_NW = document.MYFORM.elements["ORIG_NW_1_"+lineid].value;
				FULL_QTY = document.MYFORM.elements["FULL_CARTON_QTY_"+lineid].value;
				TNW=Math.round((eval(document.MYFORM.elements["SHIP_QTY_"+lineid].value)/eval(FULL_QTY))*eval(TOT_NW)*100)/100;
				if (TNW<0.01) TNW=0.01;
								
				TOT_QTY += eval(document.MYFORM.elements["SHIP_QTY_"+lineid].value);
				document.MYFORM.elements["GW_"+lineid].value="";
				document.MYFORM.elements["NW_"+lineid].value=TNW;
				id2 = document.MYFORM.chk2.value;		
				icnt=1;
			}
			else
			{
				//chkvalue = document.MYFORM.chk1[i-1].checked;
				lineid = document.MYFORM.chk2[i].value;
				if (document.MYFORM.elements["SNO_"+lineid].value != document.MYFORM.elements["ENO_"+lineid].value) continue;
				if ((eval(document.MYFORM.elements["SNO_"+lineid].value) < eval(document.MYFORM.elements["ORIG_SNO_"+objid].value) || eval(document.MYFORM.elements["ENO_"+lineid].value) > eval(document.MYFORM.elements["ORIG_ENO_"+objid].value))
				 && (eval(document.MYFORM.elements["SNO_"+lineid].value) < eval(document.MYFORM.elements["SNO_"+objid].value) || eval(document.MYFORM.elements["ENO_"+lineid].value) > eval(document.MYFORM.elements["ENO_"+objid].value))) continue;
				for (var y=0; y<document.MYFORM.elements["rdo_"+lineid].length; y++)
				{
					if (document.MYFORM.elements["rdo_"+lineid][y].checked) objValue=y;
				}
				
								
				v_chk="N";
				for (var k=0 ; k <i; k++)
				{
					id1 = document.MYFORM.chk2[k].value;
					if ( document.MYFORM.elements["SNO_"+id1].value ==document.MYFORM.elements["SNO_"+lineid].value && document.MYFORM.elements["ENO_"+id1].value ==document.MYFORM.elements["ENO_"+lineid].value)
					{
						v_chk="Y";	
						break;
					}
				}
				if (v_chk=="Y") continue;
				
				for (var j=iLen-1; j>=i ;j--)
				{
					id1 = document.MYFORM.chk2[j].value;
					if ( document.MYFORM.elements["SNO_"+lineid].value ==document.MYFORM.elements["SNO_"+id1].value && document.MYFORM.elements["ENO_"+lineid].value ==document.MYFORM.elements["ENO_"+id1].value)
					{
						TOT_NW = document.MYFORM.elements["ORIG_NW_1_"+id1].value;
						FULL_QTY = document.MYFORM.elements["FULL_CARTON_QTY_"+id1].value;
						TNW=Math.round((eval(document.MYFORM.elements["SHIP_QTY_"+id1].value)/eval(FULL_QTY))*eval(TOT_NW)*100)/100;
						if (TNW<0.01) TNW=0.01;
										
						TOT_QTY += eval(document.MYFORM.elements["SHIP_QTY_"+id1].value);
						document.MYFORM.elements["GW_"+id1].value="";
						document.MYFORM.elements["NW_"+id1].value=TNW;
						
						document.MYFORM.elements["rdo_"+id1][objValue].checked=true;
						if (objValue !="0")
						{
							document.MYFORM.elements["CUBE_"+id1].disabled=true;
						}
						else
						{
							document.MYFORM.elements["CUBE_"+id1].disabled=false;
						}						
						//document.MYFORM.elements["CUBE_"+id1].value=document.MYFORM.elements["CUBE_"+lineid].value;
						if (j!=i) document.MYFORM.elements["CBM_"+id1].value="0";
						id2=id1;
						icnt ++;
					}
				}
				TOT_GW = document.MYFORM.elements["ORIG_GW_1_"+id2].value;
				FULL_QTY = document.MYFORM.elements["FULL_CARTON_QTY_"+id2].value;
				TGW=Math.round((TOT_QTY/eval(FULL_QTY))*eval(TOT_GW)*100)/100;
				if (TGW<1) TGW=1;
				document.MYFORM.elements["GW_"+id2].value = TGW;	
				if (objValue==0)
				{
					document.MYFORM.elements["CBM_"+id2].value = getCBM(document.MYFORM.elements["CUBE_"+id2].value);
				}
				else if (objValue==1)
				{
					document.MYFORM.elements["CBM_"+id2].value = getCBM(document.MYFORM.PACK_1.value);
				}
				else if (objValue==2)
				{
					document.MYFORM.elements["CBM_"+id2].value = getCBM(document.MYFORM.PACK_2.value);
				}
			}
		}
	}
	for (var i=0; i<iLen ; i++)
	{
		if (iLen==1)
		{
			TT_NW = document.MYFORM.elements["NW_"+document.MYFORM.chk2.value].value;
			TT_GW = document.MYFORM.elements["GW_"+document.MYFORM.chk2.value].value;
			TT_C_NUM = eval(document.MYFORM.elements["ENO_"+document.MYFORM.chk2.value].value)-eval(document.MYFORM.elements["SNO_"+document.MYFORM.chk2.value].value)+1;
			TT_C_CBM = document.MYFORM.elements["CBM_"+document.MYFORM.chk2.value].value*1000;
		}
		else
		{
			chkvalue = document.MYFORM.chk2[i].checked;
			lineid = document.MYFORM.chk2[i].value;
			
			TT_NW += (eval(document.MYFORM.elements["NW_"+lineid].value)*100)*(eval(document.MYFORM.elements["ENO_"+lineid].value)-eval(document.MYFORM.elements["SNO_"+lineid].value)+1);
			if (document.MYFORM.elements["GW_"+lineid].value!="")
			{			
				TT_GW += (eval(document.MYFORM.elements["GW_"+lineid].value)*100)*(eval(document.MYFORM.elements["ENO_"+lineid].value)-eval(document.MYFORM.elements["SNO_"+lineid].value)+1);
			}
			v_chk="N";
			for (var k=0 ; k <i; k++)
			{
				id1 = document.MYFORM.chk2[k].value;
				if ( document.MYFORM.elements["SNO_"+id1].value ==document.MYFORM.elements["SNO_"+lineid].value && document.MYFORM.elements["ENO_"+id1].value ==document.MYFORM.elements["ENO_"+lineid].value)
				{
					v_chk="Y";	
					break;
				}
			}
			if (v_chk=="N")
			{
				TT_C_NUM = TT_C_NUM+ eval(document.MYFORM.elements["ENO_"+lineid].value)-eval(document.MYFORM.elements["SNO_"+lineid].value)+1;
			}
							
			TT_C_CBM += eval(document.MYFORM.elements["CBM_"+lineid].value)*1000;
		}
	}
	
	TT_NW = TT_NW/100;
	TT_GW = TT_GW/100;
	TT_C_CBM = TT_C_CBM/1000;
	document.MYFORM.elements["TOT_C_NW"].value = TT_NW;
	document.MYFORM.elements["TOT_C_GW"].value = TT_GW;
	document.MYFORM.elements["TOT_C_NUM"].value = TT_C_NUM;
	document.MYFORM.elements["TOT_C_CBM"].value = TT_C_CBM;
}

function chkMergeCarton(objid,objname)
{
	var iLen=0;
	var lineid="";
	var v_res="";
	if (document.MYFORM.chk2.length != undefined)
	{
		iLen = document.MYFORM.chk2.length;
	}
	else
	{
		iLen = 1;
		return true;
	}
	for (var i=0; i<= iLen-1 ; i++)
	{
		chkvalue = document.MYFORM.chk2[i].checked;
		lineid = document.MYFORM.chk2[i].value;
		if ( lineid ==objid) continue;
		v_res=eval(document.MYFORM.elements["SNO_"+ lineid].value)<=eval(document.MYFORM.elements["SNO_"+objid].value) && eval(document.MYFORM.elements["ENO_"+ lineid].value)>=eval(document.MYFORM.elements["SNO_"+objid].value);
		if (v_res)
		{
			if (objname=="CUST_PO")
			{
				if (document.MYFORM.elements["CUST_PO_"+ lineid].value!=document.MYFORM.elements["CUST_PO_"+objid].value)
				{
					return false;
				}
			}
			else if (objname=="SO_LINE")
			{
				if (document.MYFORM.elements["SO_LINE_"+ lineid].value!=document.MYFORM.elements["SO_LINE_"+objid].value)
				{
					return false;
				}			
			}
		}
	}
	return true;
}
function setUpdate(URL)
{
	var w_width=200;
	var w_height=200;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x+',scrollbars=no';
	subWin=window.open(URL,"subwin",ww);
}
function chkCTNSize(objid)
{
	var CTNSIZE = document.MYFORM.elements["CUBE_"+objid].value;
	if (CTNSIZE.length>0)
	{
		if (CTNSIZE.length!=11)	
		{
			alert("Carton Size is invalid!");
			document.MYFORM.elements["CUBE_"+objid].value="";
			document.MYFORM.elements["CUBE_"+objid].focus();
			return false;
		}
		else if (CTNSIZE.substring(3,4)!="*" || CTNSIZE.substring(7,8)!="*")
		{
			alert("Please use asterisks to separate!");
			document.MYFORM.elements["CUBE_"+objid].value="";
			document.MYFORM.elements["CUBE_"+objid].focus();
			return false;
		}
		else
		{
			if (isNaN(CTNSIZE.substring(0,2)) || isNaN(CTNSIZE.substring(4,6)) || isNaN(CTNSIZE.substring(8,10)))
			{
				alert("Carton Size is invalid!");
				document.MYFORM.elements["CUBE_"+objid].value="";
				document.MYFORM.elements["CUBE_"+objid].focus();				
				return false;
			}
		}
		var iLen=0,icnt=0;
		var lineid="";
		var cno = document.MYFORM.elements["SNO_"+objid].value;
		if (document.MYFORM.chk2.length != undefined)
		{
			iLen = document.MYFORM.chk2.length;
		}
		else
		{
			iLen = 1;
		}
		for (var i=0; i< iLen ; i++)
		{
			if (iLen==1)
			{
				lineid = document.MYFORM.chk2.value;
			}
			else
			{
				lineid = document.MYFORM.chk2[i].value;
			}
			if (cno==document.MYFORM.elements["SNO_"+lineid].value && cno==document.MYFORM.elements["ENO_"+lineid].value)
			{
				if (lineid != objid )
				{
					document.MYFORM.elements["CUBE_"+lineid].value=document.MYFORM.elements["CUBE_"+objid].value;
				} 
				if (icnt==0)
				{
					document.MYFORM.elements["CBM_"+lineid].value=getCBM(document.MYFORM.elements["CUBE_"+lineid].value);
				}
				else
				{
					document.MYFORM.elements["CBM_"+lineid].value="0";
				}
				icnt++;
			}			
		}
	}
}
function getCBM(v_carton_size)
{
	var v_len=v_carton_size.substring(0,3);
	var v_width=v_carton_size.substring(4,7);
	var v_height=v_carton_size.substring(8,11);
	var v_cbm=Math.round((v_len*v_width*v_height*0.000000001)*1000);
	v_cbm=v_cbm/1000;
	return v_cbm;
}

function rdochk(lineid,objValue)
{
	var csize="";
	var icnt=0;
	if (objValue !="0")
	{
		document.MYFORM.elements["CUBE_"+lineid].disabled=true;
		if (objValue==1)
		{
			csize = document.MYFORM.PACK_1.value;
		}
		else if (objValue==2) 
		{
			csize = document.MYFORM.PACK_2.value;
		}
		else
		{
			csize="";
		}
	}
	else
	{
		document.MYFORM.elements["CUBE_"+lineid].disabled=false;
		csize=document.MYFORM.elements["CUBE_"+lineid].value;
	}
	
	if (document.MYFORM.elements["SNO_"+lineid].value == document.MYFORM.elements["ENO_"+lineid].value)
	{
		var cno = document.MYFORM.elements["SNO_"+lineid].value;
		var iLen=0;
		if (document.MYFORM.chk2.length == undefined) return true;
		document.MYFORM.elements["CBM_"+lineid].value = "0";				
		iLen = document.MYFORM.chk2.length;
		for (var i=0; i< iLen ; i++)
		{
			if (cno==document.MYFORM.elements["SNO_"+document.MYFORM.chk2[i].value].value && cno==document.MYFORM.elements["ENO_"+document.MYFORM.chk2[i].value].value)
			{
				icnt++;
				if (icnt==1)
				{
					document.MYFORM.elements["CBM_"+document.MYFORM.chk2[i].value].value = getCBM(csize);				
				}
				else
				{
					document.MYFORM.elements["CBM_"+document.MYFORM.chk2[i].value].value = "0";
				}
			
				if (document.MYFORM.chk2[i].value==lineid) continue;
				document.MYFORM.elements["rdo_"+document.MYFORM.chk2[i].value][objValue].checked=true;
				if (objValue !="0")
				{
					document.MYFORM.elements["CUBE_"+document.MYFORM.chk2[i].value].disabled=true;
				}
				else
				{
					document.MYFORM.elements["CUBE_"+document.MYFORM.chk2[i].value].disabled=false;
				}
			}
		}		
	}
	else
	{
		document.MYFORM.elements["CBM_"+lineid].value = getCBM(csize);	
	}
}

</script>
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
<title>SG Carton Confirm</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String sql = "",sql1="",sql2="";
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null) ADVISE_NO="";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String ADVISE_NO_LIST="",SSD="",pick_flag="N";
String chk[] = request.getParameterValues("chk");
float TOT_CARTON_NW=0,TOT_CARTON_GW=0;
float TOT_CARTON_CBM=0;
int limit_cnt=50,i_loop_cnt=0,i_err_cnt=0;
String S_BOXCODE="";

if (!ATYPE.equals("Q"))
{
	if (chk.length <=0)
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("未勾選編箱資料,請重新確認,謝謝!");
			location.href="/oradds/jsp/TSCSGShippingBoxConfirmQuery.jsp";
		</script>
	<%
	}
	else
	{
		for(int i=0; i< chk.length ;i++)
		{
			if (ADVISE_NO.equals("")) ADVISE_NO = chk[i];
			if (ADVISE_NO_LIST.length() >0) ADVISE_NO_LIST +=",";
			ADVISE_NO_LIST += "'"+chk[i]+"'";
		}
	}
}
int SNO =0,ENO=0,TOT_CARTON_NUM=0,MAX_CARTON_NUM=0,icnt =0,confirm_cnt=0;
String ERPUSERID="",modify_flag="";
String pack1="261*203*220",pack2="440*220*230";
PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where exists (select 1 from oraddman.wsuser x where x.username=? and x.erp_user_id=a.user_id)");
statement8.setString(1,UserName);
ResultSet rs8=statement8.executeQuery();
if (rs8.next())
{
	ERPUSERID = rs8.getString(1);
}
else
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您沒有ERP帳號權限,請先向資訊單位申請,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%
}
rs8.close();
statement8.close();

%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGShippingBoxConfirm.jsp?ATYPE=<%=ATYPE%>&ADVISE_NO=<%=ADVISE_NO%>" METHOD="post" NAME="MYFORM">
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<HR>
<%
sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{	
	if (!ATYPE.equals("Q"))
	{
		sql = " select group_by,count(1)"+
			  " from (select distinct tssg_ship_pkg.GET_ADVISE_GROUP_VALUE(pc_advise_id,org_id) GROUP_BY"+
			  ",SHIPPING_METHOD"+
			  ",CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') OR (a.to_tw='Y' and  SUBSTR(a.SO_NO,1,4) IN ('1214'))  THEN '1' ELSE a.FOB_CODE END FOB_CODE"+
			  ",CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') OR (a.to_tw='Y' and  SUBSTR(a.SO_NO,1,4) IN ('1214'))  THEN 1 ELSE a.PAYMENT_TERM_ID END PAYMENT_TERM_ID"+
			  ",CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') OR (a.to_tw='Y' and  SUBSTR(a.SO_NO,1,4) IN ('1214'))  THEN 1 ELSE a.SHIP_TO_ORG_ID END SHIP_TO_ORG_ID"+
			  ",CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') OR (a.to_tw='Y' and  SUBSTR(a.SO_NO,1,4) IN ('1214'))  THEN 'TWD' ELSE CURRENCY_CODE end CURRENCY_CODE"+
			  ",CUSTOMER_ID"+ //回T訂單不考慮currency,modify by Peggy 20180309
			  " FROM tsc.tsc_shipping_advise_pc_sg a "+
			  " WHERE ORIG_ADVISE_NO in ("+ADVISE_NO_LIST+")  order by GROUP_BY)  group by  GROUP_BY"+
			  " having count(1) >1";
		//out.println(sql);
		PreparedStatement statement1 = con.prepareStatement(sql);
		ResultSet rs1=statement1.executeQuery();
		i_loop_cnt=0;	
		while (rs1.next())
		{
			if (i_loop_cnt==0)
			{
				out.println("<div><font color='red'>訂單條件不一致,不允許進行編箱作業!!</font></div>");
			}
			sql = " select group_by,SO_NO,SO_LINE_NUMBER "+  
                  ",SHIPPING_METHOD,FOB_CODE,PAYMENT_TERM_ID,SHIP_TO_ORG_ID,CURRENCY_CODE"+
                  " from (select distinct tssg_ship_pkg.GET_ADVISE_GROUP_VALUE(pc_advise_id,org_id) GROUP_BY"+
                  ",SO_NO"+
                  ",SO_LINE_NUMBER"+            
                  ",SHIPPING_METHOD"+
                  ",CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') OR (a.to_tw='Y' and  SUBSTR(a.SO_NO,1,4) IN ('1214'))  THEN '1' ELSE a.FOB_CODE END FOB_CODE"+
                  ",CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') OR (a.to_tw='Y' and  SUBSTR(a.SO_NO,1,4) IN ('1214'))  THEN '1' ELSE (select NAME from RA_TERMS_VL x where x.TERM_ID=a.PAYMENT_TERM_ID)  END PAYMENT_TERM_ID"+
                  ",CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') OR (a.to_tw='Y' and  SUBSTR(a.SO_NO,1,4) IN ('1214'))  THEN 1 ELSE a.SHIP_TO_ORG_ID END SHIP_TO_ORG_ID"+
                  ",CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') OR (a.to_tw='Y' and  SUBSTR(a.SO_NO,1,4) IN ('1214'))  THEN 'TWD' ELSE CURRENCY_CODE end CURRENCY_CODE"+
                  ",CUSTOMER_ID"+
                  " FROM tsc.tsc_shipping_advise_pc_sg a "+
                  " WHERE ORIG_ADVISE_NO in ("+ADVISE_NO_LIST+")  order by GROUP_BY)"+
                  " where group_by='"+rs1.getString(1)+"'";
			PreparedStatement statement7 = con.prepareStatement(sql);
			ResultSet rs7=statement7.executeQuery();
			i_err_cnt=0;	
			while (rs7.next())
			{	
				if (i_err_cnt==0)
				{
					out.println("<table border='1' cellSpacing='0'><tr><td>Customer</td><td>SO</td><td>SO line</td><td>Shipping Method</td><td>FOB Term</td><td>Payment Term</td><td>Ship to id</td><td>Currency</td></tr>");
				}
				out.println("<tr><td>"+rs7.getString(1)+"</td><td>"+rs7.getString(2)+"</td><td>"+rs7.getString(3)+"</td><td>"+rs7.getString(4)+"</td><td>"+rs7.getString(5)+"</td><td>"+rs7.getString(6)+"</td><td>"+rs7.getString(7)+"</td><td>"+rs7.getString(8)+"</td></tr>");
				i_err_cnt ++;
			}
			rs7.close();  
			statement7.close();	
			if (i_err_cnt>0) out.println("</table>");
								  
			i_loop_cnt ++;
		}
		rs1.close();  
		statement1.close();
		
		if (i_loop_cnt>0)
		{
			throw new Exception("Error");
		}
		
	
		//檢查型號筆數是否超過50筆
		sql = " select count(distinct vendor_site_id||'.'||item_desc)"+  //add vendor_site_id by Peggy 20210521
			  " FROM tsc.tsc_shipping_advise_pc_sg a "+
			  " WHERE ORIG_ADVISE_NO in ("+ADVISE_NO_LIST+",'"+ADVISE_NO+"')"+
			  " having count(distinct vendor_site_id||'.'||item_desc)>"+limit_cnt+" ";
		//out.println(sql);
		PreparedStatement statement11 = con.prepareStatement(sql);
		ResultSet rs11=statement11.executeQuery();	
		if (rs11.next())
		{
			out.println("<div><font color='red'>型號筆數超過"+limit_cnt+"筆!!</font></div>");
			throw new Exception("Error");
		}
		rs11.close();  
		statement11.close();			
	}
	
	if (ADVISE_NO.equals(ADVISE_NO_LIST.replace("'","")))
	{
		sql = " SELECT 1"+
			  " FROM tsc.tsc_shipping_advise_lines x"+
			  " where x.TEW_ADVISE_NO=? ";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ADVISE_NO);
		ResultSet rs=statement.executeQuery();	
		if (rs.next())
		{
			out.println("<div><font color='red'>出貨通知單不可重複編箱,謝謝!</font></div>");
			throw new Exception("Error");
		}
	}

	
	if (!ADVISE_NO.equals(""))
	{
		if (ATYPE.equals("Q"))
		{
			sql = " select 1 from tsc.tsc_advise_dn_header_int a where advise_no=? and status not in ('X')";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,ADVISE_NO);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				pick_flag="Y";
			}
			rs.close();
			statement.close();
		}
			
		/*sql = " SELECT x.advise_line_id"+
		      ",99999 SEQNO"+
			  ",z.VENDOR_ID"+
			  ",z.VENDOR_SITE_CODE"+
			  ",y.ADVISE_NO"+
			  ",x.PC_ADVISE_ID"+
			  ",x.SO_NO"+
			  ",x.ITEM_DESC"+
			  ",x.SHIPPING_REMARK"+
			  ",y.SHIPPING_METHOD"+
			  ",x.PO_NO CUST_PO_NUMBER"+
			  ",to_char(x.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE"+
			  ",x.SHIP_QTY ACT_SHIP_QTY"+
			  ",TO_CHAR(x.SHIP_QTY/1000,'99999.000') ACT_SHIP_QTY_S"+
			  ",x.CARTON_PER_QTY ACT_CARTON_QTY"+
			  ",TO_CHAR(x.CARTON_PER_QTY/1000,'99999.000') ACT_CARTON_QTY_S"+
			  ",x.CUBE CARTON_SIZE"+
			  ",x.NET_WEIGHT NW"+
			  ",x.GROSS_WEIGHT GW"+
			  ",1 as ROWSEQ"+
			  ",x.CARTON_QTY TOT_CARTON_NUM "+
			  ",x.post_code BOX_CODE"+
		      ",tssg_ship_pkg.GET_ADVISE_GROUP_VALUE(x.pc_advise_id,x.org_id) group_by"+
			  ",x.advise_header_id"+
			  ",CARTON_NUM_FR"+
			  ",CARTON_NUM_TO"+
			  ",nvl((select count(distinct a.advise_line_id) from tsc.TSC_PICK_CONFIRM_LINES a where a.advise_line_id = x.advise_line_id),0) allot_cnt"+
			  ",x.cubic_meter cbm"+	
			  ",x.REGION_CODE"+		  
			  " FROM tsc.tsc_shipping_advise_lines x"+
			  ",tsc.tsc_shipping_advise_headers y"+
			  ",ap.ap_supplier_sites_all z"+
			  " where x.ADVISE_HEADER_ID = y.ADVISE_HEADER_ID"+
			  " AND x.VENDOR_SITE_ID=z.VENDOR_SITE_ID"+
			  " AND x.TEW_ADVISE_NO=? "+
			  " order by x.CARTON_NUM_FR,x.CARTON_NUM_TO,x.advise_line_id";*/
		sql = " select tt1.*,(SELECT  SUM(CARTON_NUM_TO -CARTON_NUM_FR+1) FROM (select distinct CARTON_NUM_FR, CARTON_NUM_TO FROM TSC.TSC_SHIPPING_ADVISE_LINES X WHERE X.TEW_ADVISE_NO=?)) TOT_CTM_NUM "+  //add TOT_CTM_NUM by Peggy 20210716
		      " from (select tt.*,tipm.carton_qty,tipm.nw act_nw_1,tipm.gw act_gw_1,tipm.carton_size std_carton, row_number() over (partition by tt.advise_line_id order by decode(tt.ITEM_DESC,tipm.TSC_PARTNO,1,2)) row_seq"+
              "                from (SELECT x.advise_line_id"+
              "                     ,99999 SEQNO"+
              "                     ,z.VENDOR_ID"+
              "                     ,z.VENDOR_SITE_CODE"+
              "                     ,y.ADVISE_NO"+
              "                     ,x.PC_ADVISE_ID"+
              "                     ,x.SO_NO"+
              "                     ,x.ITEM_DESC"+
              "                     ,x.SHIPPING_REMARK"+
              "                     ,y.SHIPPING_METHOD"+
              "                     ,x.PO_NO CUST_PO_NUMBER"+
              "                     ,to_char(x.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE"+
              "                     ,x.SHIP_QTY ACT_SHIP_QTY"+
              "                     ,TO_CHAR(x.SHIP_QTY/1000,'99999.000') ACT_SHIP_QTY_S"+
              "                     ,x.CARTON_PER_QTY ACT_CARTON_QTY"+
              "                     ,TO_CHAR(x.CARTON_PER_QTY/1000,'99999.000') ACT_CARTON_QTY_S"+
              "                     ,x.CUBE CARTON_SIZE"+
              "                     ,x.NET_WEIGHT NW"+
              "                     ,x.GROSS_WEIGHT GW"+
              "                     ,1 as ROWSEQ"+
              "                     ,x.CARTON_QTY TOT_CARTON_NUM "+
              "                     ,x.post_code BOX_CODE"+
              "                     ,tssg_ship_pkg.GET_ADVISE_GROUP_VALUE(x.pc_advise_id,x.org_id) group_by"+
              "                     ,x.advise_header_id"+
              "                     ,CARTON_NUM_FR"+
              "                     ,CARTON_NUM_TO"+
              "                     ,nvl((select count(distinct a.advise_line_id) from tsc.TSC_PICK_CONFIRM_LINES a where a.advise_line_id = x.advise_line_id),0) allot_cnt"+
              "                     ,x.cubic_meter cbm"+
              "                     ,x.REGION_CODE  "+
              "                     ,x.product_group"+
              "                     ,x.TSC_PACKAGE"+
              "                     ,x.PACKING_CODE "+   
			  "                     ,x.so_line_id"+
              "                     FROM tsc.tsc_shipping_advise_lines x"+
              "                     ,tsc.tsc_shipping_advise_headers y"+
              "                     ,ap.ap_supplier_sites_all z"+
              "                      where x.ADVISE_HEADER_ID = y.ADVISE_HEADER_ID"+
              "                      AND x.VENDOR_SITE_ID=z.VENDOR_SITE_ID"+
              "                      AND x.TEW_ADVISE_NO=?) tt"+              
              "                     ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y' ) tipm"+ 
              "                 where  decode(tt.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',tt.product_group)= tipm.tsc_prod_group(+)"+
              "                 and tt.TSC_PACKAGE=tipm.TSC_PACKAGE(+)"+
              "                 and tt.PACKING_CODE =tipm.PACKING_CODE(+)"+
              "                 and tt.vendor_id = tipm.vendor_id(+)) tt1"+
              "                 where tt1.row_seq=1 "+ 
              "           order by tt1.CARTON_NUM_FR,tt1.CARTON_NUM_TO,nvl(tt1.GW,0) desc,tt1.advise_line_id";	 
		//out.println(sql);
		//out.println(ADVISE_NO);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ADVISE_NO);
		statement.setString(2,ADVISE_NO);
		ResultSet rs=statement.executeQuery();
		while (rs.next())
		{
			if (icnt ==0)
			{
		%>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" >
					<tr><td colspan="3"><div id="div1" style="font-size:13px">出貨日期：<font color="#0000CC"><%=rs.getString("PC_SCHEDULE_SHIP_DATE")%></font></div></td><td colspan="11"><div id="div2" align="right" style="font-size:13px">Advise No：<font color="#0000CC"><%=(ADVISE_NO.equals("")?ADVISE_NO_LIST.replace("'",""):ADVISE_NO)%></font></div></td>
					<tr bgcolor="#538079" style="text-shadow:#FFFFFF;color:#FFFFFF;font-family:'細明體';font-size:11px">
						<td width="5%"><input type="checkbox" name="chkall"  onClick="checkall()">項次</td>
						<td width="6%">MO#</td>
						<td width="8%">型號</td>            
						<td width="4%" align="right">數量(KPC)</td>            
						<td width="10%" align="center">C/NO</td>            
						<td width="3%" align="center">C/Code</td>            
						<td width="5%" align="right">Carton Qty</td>            
						<td width="5%" align="right">N.W.</td>            
						<td width="5%" align="right">G.W.</td>            
						<td width="14%" align="center">Carton Size</td>            
						<td width="5%" align="center">Cubic Meter</td>            
						<td width="11%">Cust P/O</td>            
						<td width="9%">嘜頭</td>
						<td width="6%">出貨方式</td>            
						<td width="5%">供應商</td>
					</tr>
				
	<%		
			}
			SNO = Integer.parseInt(rs.getString("CARTON_NUM_FR"));
			ENO = Integer.parseInt(rs.getString("CARTON_NUM_TO"));
			//TOT_CARTON_NUM=Integer.parseInt(rs.getString("CARTON_NUM_TO"));
			MAX_CARTON_NUM=Integer.parseInt(rs.getString("CARTON_NUM_TO")); //add by Peggy 20210723
			TOT_CARTON_NUM=rs.getInt("TOT_CTM_NUM");  //modify by Peggy 20210716
			TOT_CARTON_NW+=((rs.getFloat("NW")*1000)*rs.getInt("TOT_CARTON_NUM"));
			TOT_CARTON_GW+=((rs.getFloat("GW")*1000)*rs.getInt("TOT_CARTON_NUM"));
			TOT_CARTON_CBM+=((rs.getFloat("CBM")*1000)*rs.getInt("TOT_CARTON_NUM"));
			S_BOXCODE=rs.getString("BOX_CODE"); //add by Peggy 20200608
			if (S_BOXCODE==null) S_BOXCODE="";
			//out.println("TOT_CARTON_CBM"+TOT_CARTON_CBM);	
			//if (ATYPE.equals("Q") && pick_flag.equals("N") && rs.getString("CARTON_NUM_FR").equals(rs.getString("CARTON_NUM_TO")))
			//if (ATYPE.equals("Q") && pick_flag.equals("N") && rs.getString("CARTON_NUM_FR").equals(rs.getString("CARTON_NUM_TO")) && rs.getInt("allot_cnt")==0)
			if (ATYPE.equals("Q") && pick_flag.equals("N") && rs.getInt("allot_cnt")==0) //modify by Peggy 20200805,起訖箱數不同也可以改,須檢查調整後總箱數是否與原來相同
			{	
				modify_flag = "Y";
			}
			else
			{
				modify_flag = "N";
			}
	%>
			<tr style="font-size:11px" id="tr_<%=rs.getString("advise_line_id")%>">
				<td><input type="checkbox"  name="chk1" onClick="setCheck(<%=(icnt)%>)" value="<%=rs.getString("advise_line_id")%>" <%=((ATYPE.equals("Q") && rs.getInt("allot_cnt")==0)?"":"style='visibility:hidden'")%> <%=(modify_flag.equals("Y")?"checked":"")%>><%=(icnt+1)%><input type="checkbox"  name="chk2" value="<%=rs.getString("advise_line_id")%>" style="visibility:hidden" checked><input type="hidden" name="PC_ADVISE_ID_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("PC_ADVISE_ID")%>"><input type="hidden" name="SEQNO_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("SEQNO")%>"></td>
				<td><%=(rs.getString("SO_NO")==null?"&nbsp;":rs.getString("SO_NO"))%><input type="hidden" name="SO_LINE_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("so_line_id")==null?"":rs.getString("so_line_id"))%>"></td>
				<td><%=rs.getString("ITEM_DESC")%></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_SHIP_QTY_S")))%><input type="hidden" name="SHIP_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_SHIP_QTY")==null?"":rs.getString("ACT_SHIP_QTY"))%>"></td>
				<td align="center"><input type="text" name="SNO_<%=rs.getString("advise_line_id")%>" value="<%=""+SNO%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-weight:bold;font-size:13px;color:#0000FF;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>   onChange="objCarton('<%=rs.getString("advise_line_id")%>');"  onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)"><input type="hidden" name="ORIG_SNO_<%=rs.getString("advise_line_id")%>" value="<%=""+SNO%>"> 
				&nbsp;-&nbsp;
				<input type="text" name="ENO_<%=rs.getString("advise_line_id")%>" value="<%=""+ENO%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-weight:bold;font-size:13px;color:#0000FF;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>   onChange="objCarton('<%=rs.getString("advise_line_id")%>');"  onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)"><input type="hidden" name="ORIG_ENO_<%=rs.getString("advise_line_id")%>" value="<%=""+ENO%>">
				<%=((ATYPE.equals("Q") && pick_flag.equals("N") && rs.getInt("allot_cnt")==0)?"<input type='button' name='split"+rs.getString("advise_line_id")+"' value='拆箱' style='background-color:#FFCC66;height:17;font-size:11px;vertical-align:middle;font-family:細明體' onClick='setSubmit5("+'"'+"../jsp/TSCSGShippingBoxSplit.jsp?ADVISENO="+ADVISE_NO+"&ID="+rs.getString("advise_line_id")+'"'+")'>":"")%>
				</td>
				<td align="center"><input type="text" name="BOX_CODE_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("BOX_CODE")==null?"":rs.getString("BOX_CODE"))%>" style="background-color:#E4EDE2;text-align:center;border-top:none;border-right:none;border-left:none;font-family: Tahoma,Georgia;border-bottom:none;<%=(modify_flag.equals("N")?"color:#000000;":"font-weight:bold;color:#0000FF;")%>" readonly size="2"></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_CARTON_QTY_S")))+" KPC"%><input type="hidden" name="CARTON_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_CARTON_QTY")==null?"":rs.getString("ACT_CARTON_QTY"))%>"><input type="hidden" name="FULL_CARTON_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("CARTON_QTY")==null?"":rs.getString("CARTON_QTY"))%>"></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("NW")))+" KGS"%><input type="hidden" name="NW_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("NW")==null?"":rs.getString("NW"))%>"><input type="hidden" name="ORIG_NW_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("NW")%>"><input type="hidden" name="ORIG_NW_1_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("ACT_NW_1")%>"></td>
				<td align="right"><input type="text" name="GW_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("GW")==null?"":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("GW"))))%>" style="text-align:right;font-size:11px;background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;font-family: Tahoma,Georgia;border-bottom:none;" size="3">KGS<input type="hidden" name="ORIG_GW_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("GW")%>"><input type="hidden" name="ORIG_GW_1_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("ACT_GW_1")%>"></td>
				<td align="center">
				 <input type="radio" name="rdo_<%=rs.getString("advise_line_id")%>" value="0" onClick="rdochk(<%=rs.getString("advise_line_id")%>,'0')" <%=(!rs.getString("CARTON_SIZE").equals(pack1) && !rs.getString("CARTON_SIZE").equals(pack2)?" checked":"")%>>
				 <input type="text" name="CUBE_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("CARTON_SIZE")%>" style="font-size:11px;background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:center;font-family: Tahoma,Georgia;border-bottom:none;" size="12" maxlength="11"  onBlur="chkCTNSize('<%=rs.getString("advise_line_id")%>')" <%=(!rs.getString("CARTON_SIZE").equals(pack1) && !rs.getString("CARTON_SIZE").equals(pack2)?" ":" disabled")%>>
				 <input type="radio" name="rdo_<%=rs.getString("advise_line_id")%>" value="1" title="<%=pack1%>" onClick="rdochk(<%=rs.getString("advise_line_id")%>,'1')" <%=(pack1.equals(rs.getString("CARTON_SIZE"))?" checked":"")%>>中1
				 <input type="radio" name="rdo_<%=rs.getString("advise_line_id")%>" value="2" title="<%=pack2%>" onClick="rdochk(<%=rs.getString("advise_line_id")%>,'2')" <%=(pack2.equals(rs.getString("CARTON_SIZE"))?" checked":"")%>>中2
				<input type="hidden" name="STD_CUBE_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("STD_CARTON")%>">
				<!--<img border="0" src="images/updateicon_enabled.gif" height="16" title="modify" onClick="setUpdate('../jsp/subwindow/TSCSGCartonSize.jsp?ADVISE_ID=<%=rs.getString("ADVISE_LINE_ID")%>&SID=<%=rs.getString("SO_LINE_ID")%>')">-->
				<input type="hidden" name="TOT_CARTON_NUM_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("TOT_CARTON_NUM")%>"></td>
				<td align="right"><input type="text" name="CBM_<%=rs.getString("advise_line_id")%>" value="<%=(new DecimalFormat("######0.###")).format(rs.getFloat("CBM"))%>" size="5" style="font-size:11px;background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;border-bottom:none;" readonly><input type="hidden" name="ORIG_CBM_<%=rs.getString("advise_line_id")%>" value="<%=(new DecimalFormat("######0.###")).format(rs.getFloat("CBM"))%>"></td>
				<td align="left"><%=rs.getString("CUST_PO_NUMBER")%><input type="hidden" name="CUST_PO_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("CUST_PO_NUMBER")==null?"":rs.getString("CUST_PO_NUMBER"))%>"></td>
				<td align="left"><%=(rs.getString("shipping_remark")==null?"":rs.getString("shipping_remark"))%><input type="hidden" name="SHIPPING_REMARKS_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("shipping_remark")==null?"":rs.getString("shipping_remark"))%>"></td>
				<td align="left"><%=rs.getString("SHIPPING_METHOD")%><input type="hidden" name="REGION_CODE_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("REGION_CODE")==null?"":rs.getString("REGION_CODE"))%>"></td>
				<td><%=(rs.getString("vendor_site_code")==null?"&nbsp;":rs.getString("vendor_site_code"))%></td>
			</tr>
	<%
			icnt++;
		}
		//TOT_CARTON_NW=TOT_CARTON_NW/1000;
		//TOT_CARTON_GW=TOT_CARTON_GW/1000;
		//TOT_CARTON_CBM = TOT_CARTON_CBM/1000;
		rs.close();
		statement.close();
		if (icnt>0)
		{
		%>
			<!--</table>-->
		<%
		}

	}
	if (S_BOXCODE.equals(""))
	{
		if (!ATYPE.equals("Q"))
		{	
			//for Tantron因當周未出,延後隔周出貨,導致客戶同一周收到重複箱碼 by Peggy 20221028
			sql = "select distinct post_fix_code from tsc.tsc_shipping_advise_pc_sg x where x.customer_id=? and ','||?||',' like ','||x.orig_advise_no||','";
			//out.println(sql);
			//out.println(ADVISE_NO_LIST);
			PreparedStatement statement3 = con.prepareStatement(sql);
			statement3.setInt(1,449294);
			statement3.setString(2,ADVISE_NO_LIST.replace("'",""));
			ResultSet rs3=statement3.executeQuery();
			if (rs3.next())
			{
				S_BOXCODE = rs3.getString("post_fix_code");
			}
			else
			{
				sql = " select CHR(ASCII(x.post_code) +case x.post_code when 'A' THEN 12 WHEN 'N' THEN 2 ELSE 1 END ) POST_CODE"+
					  " from (select max(a.post_code) post_code"+
					  " from tsc.tsc_shipping_advise_lines a"+
					  ",tsc.tsc_shipping_advise_headers b"+
					  ",tsc.tsc_shipping_advise_pc_sg c"+
					  ",inv.mtl_parameters mp"+
					  " where a.advise_header_id = b.advise_header_id"+
					  " and a.organization_id=mp.organization_id"+
					  " and a.pc_advise_id=c.pc_advise_id"+
					  " and a.tew_advise_no is not null"+
					  " and c.SHIPPING_FROM='SG2'"+ //只有外銷才需要,add by Peggy 20200629
					  //" and c.region_code in ('TSCC-SH','TSCH-HK')"+ //add by Peggy 20200623
					  " and exists (select 1 from tsc.TSC_SHIPPING_ADVISE_PC_SG x "+
					  "             where x.shipping_from = b.shipping_from "+
					  "             and case when x.to_tw ='Y' then 'SEA(C)' else x.SHIPPING_METHOD end=b.SHIPPING_METHOD "+
					  "             and x.organization_id=a.organization_id"+
					  "             and x.TO_TW=b.TO_TW"+
					  //"             and CASE WHEN x.TO_TW='Y' THEN 'TSCT' ELSE decode(x.REGION_CODE,'TSCC-SH','TSCH-HK',x.REGION_CODE) END =CASE WHEN b.TO_TW='Y' THEN 'TSCT' ELSE decode(a.REGION_CODE,'TSCC-SH','TSCH-HK',a.REGION_CODE) END  "+
					  "             and CASE WHEN x.TO_TW='Y' THEN CASE WHEN substr(x.so_no,1,4)='1121' then 'SAMPLE' ELSE '' END|| 'TSCT' ELSE decode(x.REGION_CODE,'TSCC-SH','TSCH-HK',x.REGION_CODE) END =CASE WHEN b.TO_TW='Y' THEN CASE WHEN substr(a.so_no,1,4)='1121' then 'SAMPLE' ELSE '' END|| 'TSCT' ELSE decode(a.REGION_CODE,'TSCC-SH','TSCH-HK',a.REGION_CODE) END "+  //回T sample與一般訂單區分,避免誤判箱碼,add by Peggy 20200617
					  "             and x.PC_SCHEDULE_SHIP_DATE = a.PC_SCHEDULE_SHIP_DATE "+
					  "             and case when x.REGION_CODE ='TSCT-Disty' and length(x.SHIPPING_REMARK)>=7 and substr(x.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD'"+
					  "                 when x.REGION_CODE <>'TSCH-HK' and length(x.SHIPPING_REMARK)>=7 and substr(x.SHIPPING_REMARK,1,7)='PHIHONG' and length(x.CUST_PO_NUMBER)>=3 and substr(x.CUST_PO_NUMBER,1,1)= '1' and substr(x.CUST_PO_NUMBER,1,3) not in ('104','151') then 'PHIHONG(1)' "+ 
					  "                 when x.REGION_CODE <>'TSCH-HK' and length(x.SHIPPING_REMARK)>=7 and substr(x.SHIPPING_REMARK,1,7)='PHIHONG' and length(x.CUST_PO_NUMBER)>=3 and substr(x.CUST_PO_NUMBER,1,1)= '1' and substr(x.CUST_PO_NUMBER,1,3)  ='151' then 'PHIHONG(3)' "+ 
					  "                 when x.REGION_CODE <>'TSCH-HK' and length(x.SHIPPING_REMARK)>=7 and substr(x.SHIPPING_REMARK,1,7)='PHIHONG' and length(x.CUST_PO_NUMBER)>=3 and (substr(x.CUST_PO_NUMBER,1,1)<> '1' or substr(x.CUST_PO_NUMBER,1,3)  ='104') then 'PHIHONG(2)' "+ 
					  "                 when x.REGION_CODE ='TSCT-DA' and length(x.SHIPPING_REMARK)>=12 and substr(x.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
					  "                 when x.REGION_CODE ='TSCT-DA' and instr(x.SHIPPING_REMARK,'駱騰') > 0 THEN '駱騰' "+
					  "                 when x.REGION_CODE ='TSCT-DA' and instr(upper(x.CUSTOMER_NAME),'DELTA') >0 and instr(upper(x.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(x.CUST_PO_NUMBER,1,2)"+
					  "                 when x.to_tw ='Y' then 'T'"+ 
					  "                 else 'N/A' END=	 case when a.REGION_CODE ='TSCT-Disty' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='MUSTARD' THEN 'MUSTARD'"+
					  "                 when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.PO_NO)>=3 and substr(a.PO_NO,1,1)= '1' and substr(a.PO_NO,1,3) not in ('104','151') then 'PHIHONG(1)' "+ 
					  "                 when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.PO_NO)>=3 and substr(a.PO_NO,1,1)= '1' and substr(a.PO_NO,1,3)  ='151' then 'PHIHONG(3)' "+ 
					  "                 when a.REGION_CODE <>'TSCH-HK' and length(a.SHIPPING_REMARK)>=7 and substr(a.SHIPPING_REMARK,1,7)='PHIHONG' and length(a.PO_NO)>=3 and (substr(a.PO_NO,1,1)<> '1' or substr(a.PO_NO,1,3)  ='104') then 'PHIHONG(2)' "+ 
					  "                 when a.REGION_CODE ='TSCT-DA' and length(a.SHIPPING_REMARK)>=12 and substr(a.SHIPPING_REMARK,1,12)='CHANNEL WELL' THEN 'CHANNEL WELL' "+
					  "                 when a.REGION_CODE ='TSCT-DA' and instr(a.SHIPPING_REMARK,'駱騰') > 0 THEN '駱騰' "+
					  "                 when a.REGION_CODE ='TSCT-DA' and instr(upper(c.CUSTOMER_NAME),'DELTA') >0 and instr(upper(c.CUSTOMER_NAME),'THAILAND') >0 then 'DELTA-'||substr(a.PO_NO,1,2)"+
					  "                 when b.to_tw ='Y' then 'T'"+ 
					  "                 else 'N/A' END"+
					  "             and case when x.to_tw ='N' and (x.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or (a.REGION_CODE in ('TSCK') and instr(a.SHIPPING_REMARK,'LG DD')>0)  or substr(x.so_no,1,1) in ('8')) THEN  x.SHIP_TO_ORG_ID ELSE 0 END=case when b.to_tw ='N' and (a.REGION_CODE in ('TSCJ','TSCT-Disty','TSCT','TSCH-HK') or (a.REGION_CODE in ('TSCK') and instr(a.SHIPPING_REMARK,'LG DD')>0)  or substr(a.so_no,1,1) in ('8')) THEN  b.SHIP_TO_ORG_ID ELSE 0 END"+		  
					  "             and x.orig_advise_no in ("+ADVISE_NO_LIST+"))"+
					  //" group by a.post_code"+ //mark by Peggy 20220311
					  " ) x";
				PreparedStatement statement2 = con.prepareStatement(sql);
				//statement2.setString(1,ADVISE_NO_LIST);
				//out.println(sql);
				//out.println(ADVISE_NO_LIST);
				ResultSet rs2=statement2.executeQuery();
				if (rs2.next())
				{
					S_BOXCODE=rs2.getString(1);
					if (S_BOXCODE==null) S_BOXCODE ="A";
				}
				else
				{
					S_BOXCODE ="A";
				}
				rs2.close();
				statement2.close();	
			}			
			rs3.close();
			statement3.close();	
		}						  
	}
	
	if (!ADVISE_NO_LIST.equals(""))
	{
		sql = " select tsc_shipping_advise_lines_s.nextval advise_line_id"+
		      ",box.*"+
			  ",case WHEN ACT_GW2 > GW THEN GW ELSE ACT_GW2 END ACT_GW"+
			  ",case WHEN ACT_SHIP_QTY < CARTON_QTY THEN ACT_SHIP_QTY ELSE CARTON_QTY END AS ACT_CARTON_QTY"+
			  ",case WHEN ACT_SHIP_QTY_S < CARTON_QTY_S THEN ACT_SHIP_QTY_S ELSE CARTON_QTY_S END AS ACT_CARTON_QTY_S"+
			  ",tssg_ship_pkg.get_cubic_meter(box.carton_size,3) cbm"+
			  " from (SELECT 1 as seq"+
			  "              , y.*"+
			  "              ,floor(y.SHIP_QTY/y.CARTON_QTY) * y.CARTON_QTY ACT_SHIP_QTY"+
			  "              ,TO_CHAR(floor(y.SHIP_QTY/y.CARTON_QTY) * y.CARTON_QTY /1000,'99999.000') ACT_SHIP_QTY_S"+
			  "              ,floor(y.SHIP_QTY/y.CARTON_QTY) TOT_CARTON_NUM"+
			  "              ,y.NW as ACT_NW"+
			  "              ,y.GW as ACT_GW2"+
			  "              ,y.NW as ACT_NW_1"+
			  "              ,y.GW as ACT_GW_1"+
			  "       FROM (SELECT x.* ,row_number() over (partition by x.PC_ADVISE_ID order by SEQNO) ROWSEQ"+
			  "            FROM (select 1 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.so_line_id,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,nvl('"+S_BOXCODE+"',a.post_fix_code) BOX_CODE,a.product_group,a.tsc_package,a.packing_code "+
			  "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_sg a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
			  "                      ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y') b"+
			  "                  where orig_ADVISE_NO in ("+ADVISE_NO_LIST+")";
		sql2= "                  and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
			  "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
			  "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
			  "                  and a.vendor_id = b.vendor_id(+)"+
			  "                  and a.ITEM_DESC =b.TSC_PARTNO(+)"+
			  "                  and b.TSC_PARTNO is not null"+
			  "                  UNION ALL"+
			  "                  select 2 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.so_line_id,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,nvl('"+S_BOXCODE+"',a.post_fix_code) BOX_CODE,a.product_group,a.tsc_package,a.packing_code "+
			  "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_sg a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
			  "                       ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y' ) b"+
			  "                  where orig_ADVISE_NO in ("+ADVISE_NO_LIST+")"+
			  "                  and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
			  "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
			  "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
			  "                  and a.vendor_id = b.vendor_id(+)"+
			  "                  and b.TSC_PARTNO is null"+
			  "                  ORDER BY vendor_site_code,REGION_CODE,CUSTOMER_ID,SHIPPING_REMARK"+
			  "                  ) x"+
			  "            ) y where ROWSEQ=1 AND  floor(y.SHIP_QTY/NVL(y.CARTON_QTY,1)) >0";
		sql1 ="      union all "+
			  "      SELECT 2 as seq"+
			  "             , y.*"+
			  "             ,mod(y.SHIP_QTY,y.CARTON_QTY) ACT_SHIP_QTY"+
			  "             ,TO_CHAR(mod(y.SHIP_QTY,y.CARTON_QTY) /1000,'99999.000') ACT_SHIP_QTY_S"+
			  "             ,ceil(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY) TOT_CARTON_NUM"+
			  "             ,case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,2) < 0.01 then 0.01 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,2) end as ACT_NW"+ //modify by Peggy 20201123,小數位數改兩位
			  //"             ,case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) < 1 then 1 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) end + case when instr(SHIPPING_METHOD,'UPS')>0 OR instr(SHIPPING_METHOD,'FEDEX')>0  OR instr(SHIPPING_METHOD,'TNT')>0  OR instr(SHIPPING_METHOD,'DHL')>0 THEN 1.5 ELSE 0 END as ACT_GW2"+ //modify by Peggy 20201123,小數位數改兩位
			  "             ,case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) < 1 then 1 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) end as ACT_GW2"+ //modify by Peggy 20201123,小數位數改兩位,,快遞不自動加1.5
			  "             ,round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,2) ACT_NW_1"+  //modify by Peggy 20201123,小數位數改兩位
			  //"             ,round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) + case when instr(SHIPPING_METHOD,'UPS')>0 OR instr(SHIPPING_METHOD,'FEDEX')>0  OR instr(SHIPPING_METHOD,'TNT')>0  OR instr(SHIPPING_METHOD,'DHL')>0 THEN 1.5 ELSE 0 END as ACT_GW_1"+ //modify by Peggy 20201123,小數位數改兩位
			  "             ,round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,2) as ACT_GW_1"+ //modify by Peggy 20201123,小數位數改兩位,快遞不自動加1.5
			  "      FROM (SELECT x.* ,row_number() over (partition by x.PC_ADVISE_ID order by SEQNO) ROWSEQ"+
			  "           FROM (select 1 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.so_line_id,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,nvl('"+S_BOXCODE+"',a.post_fix_code) BOX_CODE,a.product_group,a.tsc_package,a.packing_code "+
			  "                 FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_sg a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
			  "                     ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y') b"+
			  "                 where orig_ADVISE_NO in ("+ADVISE_NO_LIST+")"+
			  "                 and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
			  "                 and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
			  "                 and a.PACKING_CODE =b.PACKING_CODE(+)"+
			  "                 and a.vendor_id = b.vendor_id(+)"+
			  "                 and a.ITEM_DESC =b.TSC_PARTNO(+)"+
			  "                 and b.TSC_PARTNO is not null"+
			  "                 UNION ALL"+
			  "                 select 2 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.so_line_id,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,round(b.NW,2) NW,round(b.GW,2) GW,nvl('"+S_BOXCODE+"',a.post_fix_code) BOX_CODE,a.product_group,a.tsc_package,a.packing_code "+
			  "                 FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_sg a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
			  "                      ,(select b.* from tsc_item_packing_master b where  INT_TYPE='SG' and STATUS='Y' ) b"+
			  "                 where orig_ADVISE_NO in ("+ADVISE_NO_LIST+")"+
			  "                 and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
			  "                 and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
			  "                 and a.PACKING_CODE =b.PACKING_CODE(+)"+
			  "                 and a.vendor_id = b.vendor_id(+)"+
			  "                 and b.TSC_PARTNO is null"+
			  "                  ORDER BY vendor_site_code,REGION_CODE,CUSTOMER_ID,SHIPPING_REMARK"+
			  "                 ) x"+
			  "       ) y "+
			  "       where ROWSEQ=1 "+
			  "       AND  mod(y.SHIP_QTY,y.CARTON_QTY) >0"+
			  //"       order by  3,23,24,5,10,12,9,7,1,24 DESC ) box "; //prod group第二順位,zhangdi 11/15要求
			  "       order by  2,25,5,10,12,9,7,1,24 DESC) box "; //按SHIPPING ADVISE文件順序 modify by Peggy 20240702
		//out.println(sql+sql2+sql1);
		//out.println(sql1);
		//out.println(ADVISE_NO_LIST.substring(1,ADVISE_NO_LIST.length()-1));
		PreparedStatement statement = con.prepareStatement(sql+sql2+sql1);
		ResultSet rs=statement.executeQuery();
		while (rs.next())
		{
			if (icnt ==0)
			{
		%>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" >
					<tr><td colspan="3"><div id="div1" style="font-size:13px">出貨日期：<font color="#0000CC"><%=rs.getString("PC_SCHEDULE_SHIP_DATE")%></font></div></td><td colspan="11"><div id="div2" align="right" style="font-size:13px">Advise No：<font color="#0000CC"><%=(ADVISE_NO.equals("")?ADVISE_NO_LIST.replace("'",""):ADVISE_NO)%></font></div></td>
					<tr bgcolor="#538079" style="text-shadow:#FFFFFF;color:#FFFFFF;font-family:'細明體';font-size:11px">
						<td width="5%">項次</td>
						<td width="6%">MO#</td>
						<td width="8%">型號</td>            
						<td width="4%" align="right">數量(KPC)</td>            
						<td width="10%" align="center">C/NO</td>            
						<td width="3%" align="center">C/Code</td>            
						<td width="5%" align="right">Carton Qty</td>            
						<td width="5%" align="center">N.W.</td>            
						<td width="5%" align="center">G.W.</td>            
						<td width="14%" align="center">Carton Size</td>            
						<td width="5%" align="center">Cubic Meter</td>            
						<td width="11%">Cust P/O</td>            
						<td width="9%">嘜頭</td>
						<td width="6%">出貨方式</td>            
						<td width="5%">供應商</td>
					</tr>
				
	<%		
			}
			if (rs.getString("CARTON_SIZE")==null || rs.getString("CARTON_SIZE").equals(""))
			{
				out.println("<div><font color='red'>型號:"+rs.getString("ITEM_DESC")+"未定義編箱基本資料(供應商:"+rs.getString("VENDOR_SITE_CODE")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TSC Package:"+rs.getString("tsc_package")+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Packing:"+rs.getString("packing_code")+")!</font></div>");
				throw new Exception("Error");
			}
			SNO = MAX_CARTON_NUM+1;
			MAX_CARTON_NUM+=Integer.parseInt(rs.getString("TOT_CARTON_NUM"));  //modify by Peggy 20210723
			TOT_CARTON_NUM+=Integer.parseInt(rs.getString("TOT_CARTON_NUM"));  
			//ENO =TOT_CARTON_NUM;
			ENO=MAX_CARTON_NUM;
			
			TOT_CARTON_NW+=((rs.getFloat("ACT_NW")*1000)*rs.getInt("TOT_CARTON_NUM"));
			TOT_CARTON_GW+=((rs.getFloat("ACT_GW")*1000)*rs.getInt("TOT_CARTON_NUM"));
			TOT_CARTON_CBM+=((rs.getFloat("CBM")*1000)*rs.getInt("TOT_CARTON_NUM"));
			modify_flag = "Y";
	%>
			<tr style="font-size:11px">
				<td><input type="checkbox"  name="chk1" onClick="setCheck(<%=(icnt)%>)" value="<%=rs.getString("advise_line_id")%>" style="visibility:hidden" <%=(modify_flag.equals("Y")?"checked":"")%>><%=(icnt+1)%><input type="checkbox"  name="chk2" value="<%=rs.getString("advise_line_id")%>" style="visibility:hidden" checked><input type="hidden" name="PC_ADVISE_ID_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("PC_ADVISE_ID")%>"><input type="hidden" name="SEQNO_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("SEQNO")%>"></td>
				<td><%=(rs.getString("SO_NO")==null?"&nbsp;":rs.getString("SO_NO"))%><input type="hidden" name="SO_LINE_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("so_line_id")==null?"":rs.getString("so_line_id"))%>"></td>
				<td><%=rs.getString("ITEM_DESC")%></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_SHIP_QTY_S")))%><input type="hidden" name="SHIP_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_SHIP_QTY")==null?"":rs.getString("ACT_SHIP_QTY"))%>"></td>
				<td align="center">
				<input type="text" name="SNO_<%=rs.getString("advise_line_id")%>" value="<%=""+SNO%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-weight:bold;font-size:13px;color:#0000FF;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onChange="objCarton('<%=rs.getString("advise_line_id")%>');" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)"> 
				&nbsp;-&nbsp;
				<input type="text" name="ENO_<%=rs.getString("advise_line_id")%>" value="<%=""+ENO%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-weight:bold;font-size:13px;color:#0000FF;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onChange="objCarton('<%=rs.getString("advise_line_id")%>');" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">
				</td>
				<td align="center"><input type="text" name="BOX_CODE_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("BOX_CODE")==null?"":rs.getString("BOX_CODE"))%>" style="background-color:#E4EDE2;text-align:center;border-top:none;border-right:none;border-left:none;font-family: Tahoma,Georgia;border-bottom:none;<%=(modify_flag.equals("N")?"color:#000000;":"font-weight:bold;color:#0000FF;")%>" readonly size="2"></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_CARTON_QTY_S")))+" KPC"%><input type="hidden" name="CARTON_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_CARTON_QTY")==null?"":rs.getString("ACT_CARTON_QTY"))%>"><input type="hidden" name="FULL_CARTON_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("CARTON_QTY")==null?"":rs.getString("CARTON_QTY"))%>"></td>
				<td align="right"><input type="text" name="NW_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_NW")==null?"":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_NW"))))%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-size:11px;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onKeyPress="return ((event.keyCode>=48 && event.keyCode <=57) || event.keyCode ==46)"> KGS<input type="hidden" name="ORIG_NW_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("NW")%>"><input type="hidden" name="ORIG_NW_1_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("ACT_NW_1")%>"></td>
				<td align="right"><input type="text" name="GW_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_GW")==null?"":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_GW"))))%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-size:11px;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onKeyPress="return ((event.keyCode>=48 && event.keyCode <=57) || event.keyCode ==46)"> KGS<input type="hidden" name="ORIG_GW_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("GW")%>"><input type="hidden" name="ORIG_GW_1_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("ACT_GW_1")%>"></td>
				<td align="center"> 
				<input type="radio" name="rdo_<%=rs.getString("advise_line_id")%>" value="0" style="visibility:hidden" checked><%=rs.getString("CARTON_SIZE")%>
				<input type="radio" name="rdo_<%=rs.getString("advise_line_id")%>" value="1" title="<%=pack1%>" style="visibility:hidden">
				<input type="radio" name="rdo_<%=rs.getString("advise_line_id")%>" value="2" title="<%=pack2%>" style="visibility:hidden">
				<input type="hidden" name="CUBE_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("CARTON_SIZE")%>"><input type="hidden" name="TOT_CARTON_NUM_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("TOT_CARTON_NUM")%>"><input type="hidden" name="STD_CUBE_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("CARTON_SIZE")%>"></td>
				<td align="right"><input type="text" name="CBM_<%=rs.getString("advise_line_id")%>" value="<%=(new DecimalFormat("######0.###")).format(rs.getFloat("CBM"))%>" size="5" style="font-size:11px;background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;border-bottom:none;" readonly><input type="hidden" name="ORIG_CBM_<%=rs.getString("advise_line_id")%>" value="<%=(new DecimalFormat("######0.###")).format(rs.getFloat("CBM"))%>"></td>
				<td align="left"><%=rs.getString("CUST_PO_NUMBER")%><input type="hidden" name="CUST_PO_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("CUST_PO_NUMBER")%>"></td>
				<td align="left"><%=(rs.getString("shipping_remark")==null?"&nbsp;":rs.getString("shipping_remark"))%><input type="hidden" name="SHIPPING_REMARKS_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("shipping_remark")==null?"":rs.getString("shipping_remark"))%>"></td>
				<td align="left"><%=rs.getString("SHIPPING_METHOD")%><input type="hidden" name="SHIPPING_METHOD_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("SHIPPING_METHOD")%>"><input type="hidden" name="REGION_CODE_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("REGION_CODE")==null?"":rs.getString("REGION_CODE"))%>"></td>
				<td><%=(rs.getString("vendor_site_code")==null?"&nbsp;":rs.getString("vendor_site_code"))%></td>
			</tr>
	<%
			icnt++;
			confirm_cnt++;
		}
		rs.close();
		statement.close();		
	}
	if (icnt >0)
	{
		TOT_CARTON_NW=TOT_CARTON_NW/1000;
		TOT_CARTON_GW=TOT_CARTON_GW/1000;
		TOT_CARTON_CBM = TOT_CARTON_CBM/1000;
		//TOT_CARTON_CBM = Math.round(TOT_CARTON_CBM);
%>
			</table>
			<HR>
			<table width="100%">
				<tr>
					<td width="22%" style="font-family: Tahoma,Georgia;font-size:12px" align="right">Total:</td>
					<td width="10%"align="right"><input type="text" name="TOT_C_NUM" value="<%=TOT_CARTON_NUM%>" size="5" style="color:#0000ff;font-weight:bold;background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;border-bottom:none;font-size:12px;" readonly></td>
					<td width="12%" style="font-family: Tahoma,Georgia;" align="right"><input type="text" name="TOT_C_NW" value="<%=TOT_CARTON_NW%>" size="5" style="color:#0000ff;font-weight:bold;background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;border-bottom:none;font-size:12px;" readonly></td>
					<td width="5%" style="font-family: Tahoma,Georgia;" align="right"><input type="text" name="TOT_C_GW" value="<%=TOT_CARTON_GW%>" size="5" style="color:#0000ff;font-weight:bold;background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;border-bottom:none;font-size:12px;" readonly></td>
					<td width="21%" style="font-family: Tahoma,Georgia;" align="right"><input type="text" name="TOT_C_CBM" value="<%=TOT_CARTON_CBM%>" size="5" style="color:#0000ff;font-weight:bold;background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;border-bottom:none;font-size:12px;" readonly></td>
					<td width="30%" style="font-family: Tahoma,Georgia;" align="right">&nbsp;</td>
				</tr>
			</table>	
			<hr>
<%
		if (!ATYPE.equals("Q") && confirm_cnt >0)
		{
%>		
			<table width="100%">
				<tr>
				  <td align="center"><input type="button" name="save1" value="編箱確認" style="font-family:'細明體'" onClick="setSubmit1('../jsp/TSCSGShippingBoxConfirmProcess.jsp')">				    &nbsp;&nbsp;&nbsp;
			    	                 <input type="button" name="exit1" value="取消，回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TSCSGShippingBoxConfirmQuery.jsp')">				
				  </td>
				</tr>
			</table>
<%
		}
		else if (ATYPE.equals("Q"))
		{
%>
			<table width="100%">
				<tr><td align="center">
				<%
				if (pick_flag.equals("N"))
				{
				%>
					<input type='button' name='delete1' value='刪除' style='vertical-align:middle;font-family:細明體' onClick='setSubmit3("../jsp/TSCSGShippingBoxConfirmProcess.jsp?TYPE=DELETE")'> 
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type='button' name='save1' value='儲存' style='vertical-align:middle;font-family:細明體' onClick='setSubmit4("../jsp/TSCSGShippingBoxConfirmProcess.jsp?TYPE=REVISE")'> 
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<%
				}
				%>
				<input type="button" name="exit1" value="回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TSCSGShippingBoxHistoryQuery.jsp')">
				</td></tr>
			</table>
<%
		}
	}
	else
	{
%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料,請重新確認,謝謝!");
		</script>
<%
	}
}
catch(Exception e)
{
	out.println("<font style='color:#ff0000;font-size:12px'>搜尋資料發生異常!!請洽系統管理人員,謝謝!</font>");
%>
	<table width="100%">
		<tr>
			<td align="center">
<%
		if (!ATYPE.equals("Q"))		
		{
%>
  		  <input type="button" name="exit1" value="取消，回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TSCSGShippingBoxConfirmQuery.jsp')">
<%
		}
		else
		{
%>
	  	<input type="button" name="exit1" value="回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TSCSGShippingBoxHistoryQuery.jsp')">
<%
		}
%>
		  </td>
	  </tr>
	</table>
<%
}

sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
PreparedStatement pstmt2=con.prepareStatement(sql2);
pstmt2.executeUpdate(); 
pstmt2.close();	
%>
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
<input type="hidden" name="ADVISE_NO" value="<%=ADVISE_NO%>">
<input type="hidden" name="ADVISE_NO_LIST" value="<%=ADVISE_NO_LIST%>">
<input type="hidden" name="PACK_1" value="<%=pack1%>">
<input type="hidden" name="PACK_2" value="<%=pack2%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

