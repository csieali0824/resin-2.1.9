<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,java.lang.Math.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%//@ include file="/jsp/include/ConnREPAIRPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>

<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>最大可產出套數</title>
</head>

<body>
<%

try {  
	String sMODELNO = request.getParameter("MODELNO");
	  
	String  sModel = "",sProd = "",sItem ="",sItemClass="",sGood="",sSqlProd="";
	int nPinv = 0,nMaxQty=0,nMaxQty1=0,nMaxQty2=0,nMinQty=0,nCount=0,nCount2=0,nCount4=0;
	int nInventory = 0,nIqcRev = 0,nSoQty =0,nStock=0,nGood=0;
	double nCount1,nCount5,nDGood;
	float nQty=0,nCost=0;
	ResultSet  rsDChangeItem=null,rsDtlMinQty=null,rsDtlMaxQty=null;
	ResultSet  rsHProd=null,rsHPinv=null,rsHPWip=null,rsHPMaxQty=null,rsHExQty,rsExvQty,rsShipHQty,rsShipHQty2,rsBPR,rsFPR,rsFPRrsSample,rsHCount,rsSample,rsPWip,rsBeforeShipHQty;
	String sSqlModel="",sSqlChangeItem="",sInsert="",sSqlHPinv="",sSqlHPWip="",sSqlHProd="",sSqlHPMaxQty="",sDtlMinQty="",sSqlHShip="",sSqlPWip="",sSqlSample="",sSqlBPR="",sSqlFPR="",sSqlUpdMod="",sSqlHCount="",sSqlHShip2="",sDtlMaxQty="",sPMaxQty="",sSqlBeforeHShip="",sSqlCost="";
	int nYear=0,nMonth=0,nEndYear=0,nEndMonth0=0,nEndMonth=0;
	int nHPinv =0,nPWip=0,nPWip1=0,nPWip2=0,nHShipQty=0,nHShipQty2=0,nBPRQty=0,nFPRQty=0,nSample=0,nAfterShipQty=0,nBeforeHShipQty=0;
	int nSumStockQty=0,nSumWipQty=0,nSumSampQty=0,nSumSaleQty=0,nSumMinQty=0,nSumMinQty1=0,nMaterialLoading=0;
	
	String sSqlDInv="",sSqlDIqcRev="",sSqlDInsDtl="",sChangeIns = "",sChangeItem ="",sChangeStock="",sChangeIqc="",sChangeSO="";
	int nChangeInv=0,nChangeIqc=0,nChangeSoQty=0;
	ResultSet rsDInv,rsChangeStock,rsChangeIqc,rsChangeSO,rsCost;    

	String sToday = dateBean.getYearMonthDay();
	String sYearToday = sToday.substring(0,4);
	String sMonthToday = sToday.substring(4,6);
	out.println("<br>"+" Today="+sToday+" Year="+sYearToday+" Month="+sMonthToday) ;


	PreparedStatement ptment = null;
	// insert into log file
	ptment = dmcon.prepareStatement("INSERT INTO t_ctl (cname,cdesc,cpara,cstdt,cendt,csts,cerr) "
	+" VALUES ('T_STOCK_BATCH','STOCK BATCH','DATE="+sToday+",MODELNO="+sMODELNO+"',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),0,'R','')");
	ptment.executeUpdate();
	ptment.close();


	//Create Temp Table for BOM
	String sTmp ="CREATE TEMP TABLE  tmpcherry010(bprod  char(15) not null,level1 int  not null,levelseq1  int  not null,"+
	"level2  int  not null,levelseq2  int  not null,level3  int  not null,levelseq3  int  not null,level4  int  not null,"+
	"levelseq4  int  not null,level5  int  not null,levelseq5  int  not null,level6  int  not null,levelseq6  int  not null,"+
	"level7  int  not null,levelseq7  int  not null,level8  int  not null,levelseq8  int  not null,level9  int  not null,"+
	"levelseq9  int  not null,level10 int  not null,levelseq10 int  not null,bmwhs  char(2) not null,bmbomm  char(2) not null,"+
	"bseq int,bchld  char(15) not null,itype  char(1),itype1 char(1),itype2  char(1),loc char(50),idesc char(60),"+
	"bqreq  decimal(15,6),qty  decimal(15,6),iums  char(2),ecn  char(10),apr1 char(30),apr2 char(30),apr3 char(30),"+
	"apr4  char(30),apr5  char(30),apr6 char(30),ven1 char(10),ven2  char(10),ven3  char(10),ven4  char(10),ven5  char(10),ven6  char(10),new char(3),serialcolumn serial not null)";
	//out.println("sTmp"+sTmp);
	ptment = bpcscon.prepareStatement(sTmp);
	ptment.executeUpdate();
	ptment.close();
	//out.print("temp ok");

     //取得統計機種代碼
	  sSqlModel ="SELECT  mmmodelno as MODEL,mmcutdate "
	  +" FROM matestockmod" +" WHERE mmmodelno is not null ";
	  if ( sMODELNO!=null ) {
		  sSqlModel = sSqlModel + " AND mmmodelno='"+sMODELNO+"' ";
	  }
	  //out.println("sSqlModel"+sSqlModel);
	  Statement stModel = dmcon.createStatement();
	  ResultSet  rsModel = stModel.executeQuery(sSqlModel);
	  while (rsModel.next()) {
		sModel=rsModel.getString("MODEL");
		String sDateCut = rsModel.getString("mmcutdate");
		String sYearCut = sDateCut.substring(0,4);
		String sMonthCut = sDateCut.substring(4,6);
		out.println("<br>"+"Model="+sModel+" Cut DATE="+sDateCut+" Cut Year="+sYearCut+" Cut Month="+sMonthCut) ;

	     //取得統計成品料號
	     sSqlProd ="SELECT mitem  as PROD FROM prodmodel WHERE mproj='"+sModel+"'  and  mcountry='886' " ;
		 //out.println( sSqlProd);
		 Statement stProd = con.createStatement();
	     ResultSet rsProd=stProd.executeQuery(sSqlProd); 
	     while (rsProd.next()) {
			sProd = rsProd.getString("PROD").trim();
			//sProd = sProd;
			out.println("<br>"+"Prod="+sProd);

			PreparedStatement ptdmment = dmcon.prepareStatement("DELETE FROM matestockdtl WHERE mdprodno='"+sProd+"' ");
			ptdmment.executeUpdate();
			ptdmment.close();
			//out.print("delete matestockdtl ok");
		 
			ptdmment = dmcon.prepareStatement("DELETE FROM matestock WHERE mprodno='"+sProd+"' ");
			ptdmment.executeUpdate();
			ptdmment.close();
			//out.print("delete matestock ok");


			//Delete Temp Table Data
			ptment = bpcscon.prepareStatement("DELETE FROM tmpcherry010 " );
			ptment.executeUpdate();
			ptment.close();
			//out.print("delete tmpcherry010 ok");
 
			sInsert ="INSERT INTO tmpcherry010 (bprod,level1, levelseq1, level2, levelseq2,level3, levelseq3, level4, levelseq4,"+
			"level5, levelseq5, level6, levelseq6,level7, levelseq7, level8, levelseq8,level9, levelseq9, level10, levelseq10,"+
			"bmwhs, bmbomm, bseq, bchld,bqreq, qty, serialcolumn) "+
			"VALUES (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','',0,'"+sProd+"',1,1,0)";
			ptment = bpcscon.prepareStatement(sInsert);
			ptment.executeUpdate();
			ptment.close();
			//out.print("insert ok");
			boolean bBom = false ;
			CallableStatement cs = bpcscon.prepareCall("{call pcherry010}");
			bBom = cs.execute();
			cs.close();
			//out.print("bBom"+bBom);

			if (bBom ) { 
				//out.println("Procedure Success !!! ");
				// 採購件下階不展, 只考慮電子料(item type="EX"), 取得子階料號及用量
				String sStockdtl="SELECT  bchld,iclas,SUM(qty) AS qty FROM  tmpcherry010,iim WHERE  tmpcherry010.bchld=iim.iprod "+
				" AND itype IN ('R','C')  AND qty>0 "+
				" AND bchld NOT IN (SELECT bchld FROM mbm,iim WHERE bprod=iprod AND iim.iityp IN ('R','C') AND mbm.bchld= tmpcherry010.bchld ) "+
				" GROUP BY bchld,iclas ORDER BY bChld";
				//out.print(sStockdtl);
				Statement stStockdtl = bpcscon.createStatement();
				ResultSet rsStockdtl=stStockdtl.executeQuery(sStockdtl);
				while (rsStockdtl.next()) {
					nQty = 0;
					sItem = rsStockdtl.getString("bchld").trim();
					nQty = rsStockdtl.getFloat("qty");
					sItemClass = rsStockdtl.getString("iclas").trim();
					out.print("<br>"+" "+sItem);
					out.print("用量"+nQty);

					//庫存數量
					nInventory = 0;
					sSqlDInv="SELECT SUM(lopb+lrct-lissu+ladju) FROM ili WHERE lwhs='01' AND lprod= '"+sItem+"' ";
					ptment=bpcscon.prepareStatement(sSqlDInv);
					rsDInv=ptment.executeQuery();
					if (rsDInv.next()) {
						nInventory = rsDInv.getInt(1);
						//out.print("Item"+sItem);
						//out.print("Inv"+nInventory);
					}// end of if
					else {
						nInventory=0;
						//out.print("Inv"+nInventory);
					}	
					out.println("庫存="+nInventory);
					ptment.close();
					rsDInv.close();
					
					//暫收數量
					nIqcRev=0;
					sSqlDIqcRev="SELECT SUM(hqins) FROM hpo WHERE pwhse='01' AND pprod ='"+sItem+"' ";
					ptment =bpcscon.prepareStatement(sSqlDIqcRev);
					//out.print("sIqcRev"+sIqcRev);
					ResultSet  rsIqcRev= ptment.executeQuery();
					if (rsIqcRev.next()) {
						nIqcRev= rsIqcRev.getInt(1);
						//out.print("nIqcRev"+nIqcRev);
					}		         
					else {
						nIqcRev=0;
						//out.print("nIqcRev"+nIqcRev);
					}	 
					out.println("暫收="+nIqcRev);
					ptment.close();
					rsIqcRev.close();
				
					//工單未發料數量
					nSoQty=0;
					String sSoQty ="SELECT SUM(mqreq-mqiss) FROM  fma WHERE mid='MA'  AND  mwhs='01' AND mqreq>mqiss AND mprod='"+sItem+"' ";
					//out.print("sSoQty"+sSoQty);
					ptment=bpcscon.prepareStatement(sSoQty);
					ResultSet rsSoQty = ptment.executeQuery();
					if (rsSoQty.next()) {	
						nSoQty=rsSoQty.getInt(1);
						//out.print("SOQTY"+nSoQty);
					}
					else {
						nSoQty = 0 ;
						//out.print("SOQTY"+nSoQty);
					}	
					out.println("工單="+nSoQty);
					ptment.close();
					rsSoQty.close();
						
					nGood = 0 ;
					nStock = 0 ;
					nMaxQty = 0;
					sGood="";
					//計算可產出套數
					nStock = nInventory + nIqcRev - nSoQty;
					
					//將算出來的數量無條件捨去	   
					nDGood = Math.floor(nStock / nQty) ;
					//out.print("nDGood"+nDGood);
					//sGood = Double.toString(nDGood);
					//sGood = String.valueOf(nDGood);
					//out.print("sGood"+sGood);
					nGood = (int)nDGood;
					//out.print("nGood"+nGood);
				
					out.println("可產出套數="+nGood);
					
					//最大可產出套數
					if (nMaxQty > nGood && nGood>0 ) {
						nMaxQty = nGood;
						//out.println("nMaxQty"+nMaxQty);
					}//end of if nMaxQty  
					//out.println("nMaxQty"+nMaxQty);
						
					sSqlDInsDtl="INSERT INTO matestockdtl(mddate,mdmodelno,mdprodno,mdchldno,mdreq,mdstockqty,"+
					"mdinsqty,mdwipqty,mdmaxqty,mdclas) VALUES (?,?,?,?,?,?,?,?,?,?) ";
					//out.print("sSqlDInsDtl"+sSqlDInsDtl);
					ptdmment = dmcon.prepareStatement(sSqlDInsDtl);
					ptdmment.setString(1,sToday); 
					ptdmment.setString(2,sModel);
					ptdmment.setString(3,sProd);
					ptdmment.setString(4,sItem);
					//ptInsdtl.setInt(5,nQty);
					ptdmment.setFloat(5,nQty);
					ptdmment.setInt(6,nInventory );
					ptdmment.setInt(7,nIqcRev);
					ptdmment.setInt(8,nSoQty);
					ptdmment.setInt(9,nGood);
					ptdmment.setString(10,sItemClass);
					ptdmment.executeUpdate();
					ptdmment.close();

				} //end of while rsStockdtl
				stStockdtl.close();
				rsStockdtl.close();	   
                 

			} //end of  if bBom



			nCount = 0;nCount1 = 0;nCount4=0;nMaxQty1=0;nMaxQty2=0;nMinQty=0;
			
			// 電子材料總數
			sSqlHPMaxQty="SELECT count(*) FROM matestockdtl WHERE mdprodno='"+sProd+"' AND mdreq>0 AND mdclas='EX' ";  
			ptdmment=dmcon.prepareStatement(sSqlHPMaxQty);
			rsHPMaxQty=ptdmment.executeQuery();
			if (rsHPMaxQty.next()) {
				nCount = rsHPMaxQty.getInt(1);
				//out.print("nCount "+nCount);
			}
			else  {
				nCount = 0;
				//out.print("nCount "+nCount);
			}	 
			out.print("<br>"+"電子材料總數="+nCount);
			ptdmment.close();
			rsHPMaxQty.close();
		 
			nCount1 = nCount * 0.2;
			//out.println("nCount1"+nCount1);
			nCount4 = 1;
			//out.println("nCount4"+nCount4);
		 
			//計算電子料80%齊套數
			sDtlMaxQty=sDtlMaxQty="SELECT mdmaxqty FROM matestockdtl WHERE mdprodno='"+sProd+"' AND mdreq > 0 AND mdclas='EX' ORDER BY mdmaxqty";
			//out.print(sStockdtl);
			ptdmment=dmcon.prepareStatement(sDtlMaxQty);
			rsDtlMaxQty=ptdmment.executeQuery();
			while (rsDtlMaxQty.next() && nCount4 < nCount1 ) {
				//nCount2=rsDtlMaxQty.getInt("mdmaxqty");
				//nMaxQty1 = nCount2 ;
				nMaxQty1 = rsDtlMaxQty.getInt("mdmaxqty");
				nCount4 = nCount4 + 1;
			}//end of if rsDtlMaxQty
			//out.print("nCount4 "+nCount4);
			if (nMaxQty1<0) {nMaxQty1 =0; }
			ptdmment.close();
			rsDtlMaxQty.close(); 
	 
			//電子料齊套數=抓電子料可產出套數最小值
			sDtlMinQty="SELECT MIN(mdmaxqty) AS mdmaxqty FROM matestockdtl WHERE mdprodno='"+sProd+"' AND  mdclas='EX' ";
			//out.print(sStockdtl);
			ptdmment=dmcon.prepareStatement(sDtlMinQty);
			rsDtlMinQty=ptdmment.executeQuery();
			while (rsDtlMinQty.next()) {
				nMinQty=rsDtlMinQty.getInt("mdmaxqty");
			 }//end of if rsDtlMinQty
			if (nMinQty<0) { nMinQty = 0; }
			out.println("電子料齊套數="+nMinQty);
			ptdmment.close();
			rsDtlMinQty.close(); 
		  
			//電子料80%齊套數 = 電子料80%齊套數 - 電子料齊套數
			nMaxQty2 = nMaxQty1 - nMinQty;
			out.print("電子料80%齊套數="+nMaxQty2);

			  
			//成品WIP
			nPWip= 0;
			sSqlPWip="SELECT SUM(sqreq-sqfin) FROM fso WHERE sid='SO' AND sprod ='"+sProd+"' ";  
			ptment=bpcscon.prepareStatement(sSqlPWip);
			rsPWip=ptment.executeQuery();
			if (rsPWip.next()) {
				nPWip = rsPWip.getInt(1);
				//out.print("nPWip "+nPWip);
			}
			else  {
				nPWip = 0 ;
				//out.print("nPWip "+nPWip);
			}	 
			out.print("成品WIP= "+nPWip);
			ptment.close();
			rsPWip.close();
			//成品庫存
			nHPinv = 0;
			sSqlHPinv="SELECT SUM(wopb+wrct-wiss+wadj) FROM iwi WHERE wwhs IN ('52','71','72','73') AND wprod='"+sProd+"' ";  
			ptment=bpcscon.prepareStatement(sSqlHPinv);
			rsHPinv=ptment.executeQuery();
			if (rsHPinv.next()) {
				nHPinv = 0;
				nHPinv = rsHPinv.getInt(1);
				//out.print("nHPinv "+nHPinv);
			}
			else  {
				nHPinv = 0 ;
				//out.print("nHPinv "+nHPinv);
			}	 
			out.print("成品庫存="+nHPinv);
			ptment.close();
			rsHPinv.close();

			/*
			//計算截止日後出貨數量 *注意跨年處理
			sSqlHShip2="SELECT SUM(ssqty) FROM stock_ship_mon "+
			"WHERE ((ssyear="+sYearCut+"  AND ssmonth>"+sMonthCut+") OR (ssyear>"+sYearCut+" AND ssyear<"+sYearToday+") OR (ssyear="+sYearToday+"  AND ssmonth<="+sMonthToday+")) "+
			"AND ssmodelno='"+sModel+"' AND ssitemno='"+sProd+"' ";
			//out.println("sSqlHShip2"+sSqlHShip2);
			ptdmment=dmcon.prepareStatement(sSqlHShip2);
			rsShipHQty2=ptdmment.executeQuery(); 
			if (rsShipHQty2.next()) {
				nHShipQty2=0;
				nHShipQty2=rsShipHQty2.getInt(1);
				//out.println("nHShipQty2"+nHShipQty2);
			} //end of if
			else {
				nHShipQty2=0;
				//out.println("nHShipQty2"+nHShipQty2); 
			}
			out.println("截止日後出貨="+nHShipQty2);
			ptdmment.close();
			rsShipHQty2.close();

			 
			//截止年/月以後之出貨數 = 結算年/月後累計之銷售數量-截止年/月前累計之銷售數量
			//nAfterShipQty = 0;
			//nAfterShipQty = nHShipQty2 - nHShipQty;

			//計算累計樣品領用數量
			sSqlSample="SELECT SUM(stqty) AS stqty FROM stock_sample_mon "+
			" WHERE ssmodelno='"+sModel+"'  AND ssitemno='"+sProd+"' "+
			" AND ssyear="+sYearToday+"  AND ssmonth="+sMonthToday+" ";
			//out.println("sSqlSample"+sSqlSample);
			ptdmment=dmcon.prepareStatement(sSqlSample);
			rsSample=ptdmment.executeQuery();
			if (rsSample.next()) {
				nSample=0;
				nSample=rsSample.getInt("stqty");
				//out.println("nSample"+nSample);
			}
			else {
				nSample=0;
				//out.println("nSample"+nSample);
			}
			out.println("累計樣品領用="+nSample);
			ptdmment.close();
			rsSample.close();	 

			//最新標準材料成本
			sSqlCost="SELECT cftlvl+cfplvl FROM cmf WHERE cffac='' AND cfcset=2 AND cfcbkt=1 AND cfprod='"+sProd+"' ";
			ptment=bpcscon.prepareStatement(sSqlCost);
			rsCost=ptment.executeQuery();
			if (rsCost.next()) {
				nCost = 0;
				nCost = rsCost.getFloat(1);
				//out.print("nCost"+nCost);
			}
			else  {
				nCost = 0;
				//out.print("nCost"+nCost);
			}	 
			ptment.close();
			rsCost.close();
			*/
			 
			String sInsMateStock="INSERT INTO matestock(mdate,mmodelno,mprodno,mstdcst,mstockqty,mmaxqty,mmaxqty1,"+
			"mwipqty,mexqty,mexqty1,mexvqty,msaleqty,msampqty) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
			//String sInsMateStock="INSERT INTO matestock(mdate,mmodelno,mprodno,mstdcst,mstockqty,mexqty,mexqty1,"+
			//                                   "mdexvqty,msaleqty) VALUES (?,?,?,?,?,?,?,?,?)";
			//out.println("sInsMateStock"+sInsMateStock);
			ptdmment = dmcon.prepareStatement(sInsMateStock);
			//ptdmment.setInt(1,Integer.parseInt(dateBean.getYearMonthDay()));
			ptdmment.setString(1,sToday);
			ptdmment.setString(2,sModel);
			ptdmment.setString(3,sProd);
			ptdmment.setFloat(4,nCost);
			ptdmment.setInt(5,nHPinv);
			ptdmment.setInt(6,0);
			ptdmment.setInt(7,0);
			ptdmment.setInt(8,nPWip);
			ptdmment.setInt(9,nMinQty);
			ptdmment.setInt(10,nMaxQty2);
			ptdmment.setInt(11,0);	  
			ptdmment.setInt(12,nHShipQty2);	  
			ptdmment.setInt(13,nSample);	
			ptdmment.executeUpdate();
			ptdmment.close();
			
	  
		} //end of while Prod
		stProd.close();
		rsProd.close();

		//
		/*
		sSqlHCount="SELECT SUM(mstockqty) AS mstockqty,SUM(mwipqty) AS mwipqty,SUM(msaleqty) AS msaleqty,SUM(msampqty) AS msampqty, MIN(mexqty) AS mexqty,MIN(mexqty1) AS mexqty1,MAX(mstdcst) AS mstdcst "+
		"FROM matestock WHERE mmodelno='"+sModel+"' ";
		PreparedStatement ptdmment=dmcon.prepareStatement(sSqlHCount);
		rsHCount=ptdmment.executeQuery();
		if (rsHCount.next()) {
			nSumStockQty=0;nSumWipQty=0;nSumSaleQty=0;nSumSampQty=0;nSumMinQty=0;nSumMinQty1=0;
			nSumStockQty=rsHCount.getInt("mstockqty");
			nSumWipQty=rsHCount.getInt("mwipqty");
			nSumSaleQty=rsHCount.getInt("msaleqty");
			nSumSampQty=rsHCount.getInt("msampqty");
			nSumMinQty=rsHCount.getInt("mexqty");
			nSumMinQty1=rsHCount.getInt("mexqty1");
			nCost=rsHCount.getFloat("mstdcst");
		}
		else  { nSumStockQty=0;nSumWipQty=0;nSumSaleQty=0;nSumSampQty=0;nSumMinQty=0;nSumMinQty1=0;}
		//out.println("<br>"+"機種庫存數="+nSumStockQty);
		out.println("截止日後出貨="+nSumSaleQty);
		ptdmment.close();
		rsHCount.close();
		
		//計算截止年/月前之己核准PR數量
		sSqlBPR="SELECT SUM(l.rqqty) as RQTY FROM psales_fore_app_ln l,psales_fore_app_hd h "+
		"WHERE l.docno=h.docno AND h.cancel !='Y' AND h.approved='Y' AND h.country='886' AND l.prjcd='"+sModel+"' "+
		" AND ((h.rqyear="+sYearCut+"  AND h.rqmonth<="+sMonthCut+") OR h.rqyear<"+sYearCut+" )";
		//out.println("sSqlBPR"+sSqlBPR);
		ptment=con.prepareStatement(sSqlBPR);
		rsBPR=ptment.executeQuery();
		nBPRQty=0;
		if (rsBPR.next()) {
			float f1 = rsBPR.getFloat("RQTY");			
			if (f1>0) {f1 = f1 * 1000; nBPRQty = (int) Math.floor(f1);}
			//nBPRQty =rsBPR.getInt("RQTY");
			
		}
		else {nBPRQty=0;}
		out.println("<br>"+"截止日前之己核准PR="+nBPRQty);
		rsBPR.close();
		ptment.close();
		 
		//計算截止日前出貨數量
		sSqlBeforeHShip="SELECT SUM(stqty) AS stqty FROM stock_ship_mon "+
			"WHERE (ssyear="+sYearCut+"  AND ssmonth="+sMonthCut+") "+
			"AND ssmodelno='"+sModel+"' ";
		//out.println("sSqlHShip"+sSqlHShip);
		ptdmment=dmcon.prepareStatement(sSqlBeforeHShip);
		rsBeforeShipHQty=ptdmment.executeQuery();
		if (rsBeforeShipHQty.next()) {
			nBeforeHShipQty=0;
			nBeforeHShipQty=rsBeforeShipHQty.getInt("stqty");
		}
		else {nHShipQty=0;};
		out.println("<br>"+"截止日前出貨="+nBeforeHShipQty);
		rsBeforeShipHQty.close();	 
		ptdmment.close();
		   
		//截止日 MaterialLoading = 截止日前 PR - 截止日前出貨
		nMaterialLoading = nBPRQty -  nBeforeHShipQty;
		
		//計算截止年/月後之己核准PR數量, 以K為單位, 需轉換
		sSqlFPR="SELECT SUM(l.rqqty) as RQTY FROM psales_fore_app_ln l,psales_fore_app_hd h "+
		"WHERE l.docno=h.docno AND h.cancel !='Y' AND h.approved='Y' AND h.country='886' AND l.prjcd='"+sModel+"' "+
		" AND ((h.rqyear="+sYearCut+"  AND h.rqmonth>"+sMonthCut+") OR (h.rqyear>"+sYearCut+" AND h.rqyear<"+sYearToday+") OR (h.rqyear="+sYearToday+"  AND h.rqmonth<="+sMonthToday+") )";
		ptment=con.prepareStatement(sSqlFPR);
		rsFPR=ptment.executeQuery();
		if (rsFPR.next()) {
			float f1 = rsFPR.getFloat("RQTY");
			if (f1>0) {f1 = f1 * 1000; nFPRQty = (int) Math.floor(f1);}
		}
		else {nFPRQty=0;}
		out.println("<br>"+"截止日後之己核准PR="+nFPRQty);		
		ptment.close();
		rsFPR.close();
		   
		//update matestockmod
		sSqlUpdMod="UPDATE matestockmod SET mmdate=?,mmloadqty=?,mmsaleqty=?,mmprqty=?,"+
		"mmsampqty=?,mmstockqty=?,mmwipqty=?,mmqty=?,mmqty1=?,mmexqty=?, mmexqty1=?,mmcst=? WHERE mmmodelno='"+sModel+"' ";
		ptdmment=dmcon.prepareStatement(sSqlUpdMod);
		ptdmment.setString(1,sToday);
		ptdmment.setInt(2,nMaterialLoading);
		ptdmment.setInt(3,nSumSaleQty);
		ptdmment.setInt(4,nFPRQty);
		ptdmment.setInt(5,nSumSampQty);
		ptdmment.setInt(6,nSumStockQty);
		ptdmment.setInt(7,nSumWipQty);
		ptdmment.setInt(8,0);
		ptdmment.setInt(9,0);
		ptdmment.setInt(10,nSumMinQty);
		ptdmment.setInt(11,nSumMinQty1);
		ptdmment.setFloat(12,nCost);
		ptdmment.executeUpdate();
		ptdmment.close();
		*/

	}  // end while stModel
	stModel.close();
	rsModel.close();	 

	ptment = bpcscon.prepareStatement("DROP TABLE tmpcherry010");
	ptment.executeUpdate();
	ptment.close();

	// update log file
	ptment = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='S' "
	+" WHERE cname='T_STOCK_BATCH' AND csts='R' AND cpara='DATE="+sToday+",MODELNO="+sMODELNO+"' ");
	ptment.executeUpdate();
	ptment.close();


}//end of try
catch (Exception ee) { 
	out.println("Exception:"+ee.getMessage()); 	
/*
	PreparedStatement ptment = bpcscon.prepareStatement("DROP TABLE tmpcherry010");
	ptment.executeUpdate();
	ptment.close();
*/
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><%

	if (bpcsPoolBean.getDriver()!=null) {   
		bpcsPoolBean.emptyPool();   
		bpcsPoolBean.resetPool();    
	} //end of if 
}//end of catch
		
%>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%//@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%
if (bpcsPoolBean.getDriver()!=null) {   
	bpcsPoolBean.emptyPool();   
	bpcsPoolBean.resetPool();    
} 
%>	