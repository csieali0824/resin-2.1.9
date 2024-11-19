import java.io.Serializable;
import java.sql.*;

public class BpcsBomBean implements java.io.Serializable
{
	private Connection conn=null;
	private int x = 9999; //最多只能有999個料號
	private int y = 27;
	private String a[][] = new String[x][y];
	private String itemProperty[] = {"","","",""};
	private int iNext = 0;

	public BpcsBomBean()
	{}
	
	public void setConnection(Connection conn)
	{
		this.conn=conn;
	}
//====== Item
	public void getItemProperty(String prod) throws Exception
	{
		for (int i=0;i<itemProperty.length;i++) itemProperty[i] = "";
		if (prod==null) { 
		} else {
			PreparedStatement st = conn.prepareStatement("SELECT idesc||idsce AS desc,iums,iityp,iclas FROM iim WHERE iprod='"+prod+"' ");
			ResultSet rs = st.executeQuery();
				if (rs.next() ) {
					setItemDesc(rs.getString("desc").trim());
					setItemUM(rs.getString("iums").trim());
					setItemType(rs.getString("iityp").trim());
					setItemClass(rs.getString("iclas").trim());
				}
			rs.close();
			st.close();
		} // end if
	} // end getItemProperty
	public void setItemDesc(String s) throws Exception
	{itemProperty[0] = s;}
	public String getItemDesc() throws Exception
	{return itemProperty[0];}
	public void setItemUM(String s) throws Exception
	{itemProperty[1] = s;}
	public String getItemUM() throws Exception
	{return itemProperty[1];}
	public void setItemType(String s) throws Exception
	{itemProperty[2] = s;}
	public String getItemType() throws Exception
	{return itemProperty[2];}
	public void setItemClass(String s) throws Exception
	{itemProperty[3] = s;}
	public String getItemClass() throws Exception
	{return itemProperty[3];}
//======

	//承認廠商
	public String [][] getVnd(String prod) throws Exception
	{
		int r=0;
		int max=6;
		String vnd[][] = new String[max][2];
		for (r=0;r<max;r++) { vnd[r][0] = ""; vnd[r][1] = ""; }
		if (prod==null) {
		} else {
			PreparedStatement st = conn.prepareStatement("SELECT vendor,dwgid,enter_date FROM venbat WHERE part='"+prod+"' ORDER BY enter_date DESC" );
			ResultSet rs = st.executeQuery();
			r=0;
			while (rs.next() && r<max) {
				vnd[r][0]=rs.getString("vendor").trim();
				vnd[r][1]=rs.getString("dwgid").trim();
				r++;
			} // end while
			rs.close();
			st.close();
		}
		return vnd;
		
	}//end getVnd

	//插件位置
	public String getLoc(String prod, String fac, String method, String seq) throws Exception
	{
		String loc = "";
		String where = "";
		if (fac!=null) { where = where + " AND pnwhs='"+fac+"'";
		}
		if (method!=null) { where = where + " AND pnmeth='"+method+"'";
		}
		PreparedStatement st = conn.prepareStatement("SELECT substr(trim(pndes),5,50) AS loc,pnseq FROM mpn "+
		" WHERE pnid='PN' AND pntype='M' AND substr(trim(pndes),1,4)='LOC:' "+
		" AND pnprod ='"+prod+"' AND pnopn="+seq+where);
		ResultSet rs = st.executeQuery();
		while (rs.next()) {
			loc = loc + rs.getString("loc").trim();
		}
		rs.close();
		st.close();
		return loc;
	}// end getLoc
	
	//清空array
	public void setEmpty() throws Exception
	{
		for (int i=0;i<a.length;i++) {
			for (int j=0;j<a[i].length;j++) {
				a[i][j]="N/A";
			}
		}
	}

	//index
	public int getNext() throws Exception
	{ 
		if (this.iNext<a.length) {this.iNext++;}
		return this.iNext;
	}

	public void setNext(int i) throws Exception
	{
		if (i<a.length) { if (i>=0) {this.iNext=i; }
		} else { this.iNext=a.length-1; }
	}

	//階層碼
	public String getLevelCode() throws Exception
	{ if (this.iNext<a.length) return a[iNext][0]; else return ""; }

	public void setLevelCode(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][0]=s; }

	//階層字串
	public String getLevelString() throws Exception
	{ if (this.iNext<a.length) return a[iNext][1]; else return ""; }

	public void setLevelString(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][1]=s; }

	//展BOM的順序
	public String getOrder() throws Exception
	{ if (this.iNext<a.length) return a[iNext][2]; else return ""; }

	public void setOrder(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][2]=s; }

	//父階料號 
	public String getParent() throws Exception
	{ if (this.iNext<a.length) return a[iNext][3]; else return ""; }

	public void setParent(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][3]=s;}

	//子階料號 
	public String getChild() throws Exception
	{ if (this.iNext<a.length) return a[iNext][4]; else return ""; }

	public void setChild(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][4]=s; }

	//單位用量 
	public String getReq() throws Exception
	{ if (this.iNext<a.length) return a[iNext][5]; else return ""; }

	public void setReq(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][5]=s; }

	//本階用量 
	public String getQty() throws Exception
	{ if (this.iNext<a.length) return a[iNext][6]; else return ""; }

	public void setQty(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][6]=s; }

	//BOM SEQ 
	public String getSeq() throws Exception
	{ if (this.iNext<a.length) return a[iNext][7]; else return ""; }

	public void setSeq(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][7]=s; }

	//ECN#
	public String getECN() throws Exception
	{ if (this.iNext<a.length) return a[iNext][8]; else return ""; }

	public void setECN(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][8]=s; }

	//父階的item type 
	public String getPtype() throws Exception
	{ if (this.iNext<a.length) return a[iNext][9]; else return ""; }

	public void setPtype(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][9]=s; }

	//插件位置
	public String getLoc() throws Exception
	{ if (this.iNext<a.length) return a[iNext][10]; else return ""; }

	public void setLoc(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][10]=s; }

	//取得子階description
	public String getDesc() throws Exception
	{ if (this.iNext<a.length) return a[iNext][11]; else return ""; }

	public void setDesc(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][11]=s; }

	//計量單位
	public String getUM() throws Exception
	{ if (this.iNext<a.length) return a[iNext][12]; else return ""; }

	public void setUM(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][12]=s; }

	//子階item type 
	public String getCtype() throws Exception
	{ if (this.iNext<a.length) return a[iNext][13]; else return ""; }

	public void setCtype(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][13]=s; }

	//子階item class 
	public String getCclass() throws Exception
	{ if (this.iNext<a.length) return a[iNext][14]; else return ""; }

	public void setCclass(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][14]=s; }

	//承認廠商1
	public String getVendApp1() throws Exception
	{ if (this.iNext<a.length) return a[iNext][15]; else return ""; }

	public void setVendApp1(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][15]=s; }

	//承認字號1
	public String getApp1() throws Exception
	{ if (this.iNext<a.length) return a[iNext][16]; else return ""; }

	public void setApp1(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][16]=s; }

	//得承認廠商2
	public String getVendApp2() throws Exception
	{ if (this.iNext<a.length) return a[iNext][17]; else return ""; }

	public void setVendApp2(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][17]=s; }

	//承認字號2
	public String getApp2() throws Exception
	{ if (this.iNext<a.length) return a[iNext][18]; else return ""; }

	public void setApp2(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][18]=s; }

	//承認廠商3
	public String getVendApp3() throws Exception
	{ if (this.iNext<a.length) return a[iNext][19]; else return ""; }

	public void setVendApp3(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][19]=s; }

	//承認字號3
	public String getApp3() throws Exception
	{ if (this.iNext<a.length) return a[iNext][20]; else return ""; }

	public void setApp3(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][20]=s; }

	//承認廠商4
	public String getVendApp4() throws Exception
	{ if (this.iNext<a.length) return a[iNext][21]; else return ""; }

	public void setVendApp4(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][21]=s; }

	//承認字號4
	public String getApp4() throws Exception
	{ if (this.iNext<a.length) return a[iNext][22]; else return ""; }

	public void setApp4(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][22]=s; }

	//承認廠商5
	public String getVendApp5() throws Exception
	{ if (this.iNext<a.length) return a[iNext][23]; else return ""; }

	public void setVendApp5(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][23]=s; }

	//承認字號5
	public String getApp5() throws Exception
	{ if (this.iNext<a.length) return a[iNext][24]; else return ""; }

	public void setApp5(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][24]=s; }

	//承認廠商6
	public String getVendApp6() throws Exception
	{ if (this.iNext<a.length) return a[iNext][25]; else return ""; }

	public void setVendApp6(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][25]=s; }

	//承認字號6
	public String getApp6() throws Exception
	{ if (this.iNext<a.length) return a[iNext][26]; else return ""; }

	public void setApp6(String s) throws Exception
	{ if (this.iNext<a.length) a[iNext][26]=s; }

//======展BOM
	public int getStructure(String prod, String fac, String method, String typ) throws Exception
	{
		setEmpty(); setNext(0); //initial
		setLevelCode("0");
		setLevelString(".0");
		setOrder("0");
		setParent("");
		setChild(prod);
		setReq("1");
		setQty("1");
		setSeq("0");
		getItemProperty(prod);
		setDesc(getItemDesc());
		setUM(getItemUM());
		setCtype(getItemType());
		setCclass(getItemClass());
		getNext();
		getBom(prod,fac,method,typ,0,1,1);
		return this.iNext;
	} // end getStructure
	public boolean getBom(String prod,String fac, String method, String typ, int level, int req, int qty) throws Exception
	{
		String where = "";
		if (fac!=null) { where = where + " AND bmwhs='"+fac+"'";}
		if (method!=null) { where = where + " AND bmbomm='"+method+"'";}
		if (typ!=null) {
			if(typ.equals("1")) { where = where + " AND iityp NOT IN ('C','R') "; } // 採購件下階不展
		}
		DateBean dateBean = new DateBean();
		String sToday = dateBean.getYearMonthDay();
		PreparedStatement st=conn.prepareStatement("SELECT bprod,bchld,bseq,bqreq,bqreq*"+String.valueOf(qty)+" AS qty,bllot,iityp"+
		" FROM mbm,iim "+
		" WHERE bprod=iprod AND bdeff <="+sToday+" AND bddis>="+sToday+" AND bprod='"+prod+"' "+where+" order by bchld");
		ResultSet rs = st.executeQuery();
		boolean eof = !rs.next();
		if (eof) { return false;
		} else {
			while (!eof) {
				if (this.iNext<a.length) {
					String l = String.valueOf(level+1);
					setLevelCode(l);
					setLevelString(padLeft(l,".",level+1));
					setOrder(String.valueOf(this.iNext));
					setParent(prod);
					setChild(rs.getString("bchld").trim());
					setReq(rs.getString("bqreq").trim());
					setQty(rs.getString("qty").trim());
					setSeq(rs.getString("bseq").trim());
					setECN(rs.getString("bllot").trim());
					setPtype(rs.getString("iityp").trim());
					setLoc(getLoc(prod,fac,method,rs.getString("bseq").trim()));
					getItemProperty(rs.getString("bchld").trim());
					setDesc(getItemDesc());
					setUM(getItemUM());
					setCtype(getItemType());
					setCclass(getItemClass());
					String vnd[][]=getVnd(rs.getString("bchld").trim());
					setVendApp1(vnd[0][0]);setApp1(vnd[0][1]);
					setVendApp2(vnd[1][0]);setApp2(vnd[1][1]);
					setVendApp3(vnd[2][0]);setApp3(vnd[2][1]);
					setVendApp4(vnd[3][0]);setApp4(vnd[3][1]);
					setVendApp5(vnd[4][0]);setApp5(vnd[4][1]);
					setVendApp6(vnd[5][0]);setApp6(vnd[5][1]);
					getNext();
					getBom(rs.getString("bchld").trim(),fac,method,typ,level+1,rs.getInt("bqreq"),rs.getInt("qty"));
				} else { return false;
				}// end if
				eof = !rs.next();
			} // end while
		} // end if
		rs.close();
		st.close();	
		return true;
	} //end getBom
//======展BOM

//======where use
	public int getWhereUse(String prod, String fac, String method,String typ) throws Exception
	{
		setEmpty(); setNext(0); //initial
		if (typ==null) { getWhereUseTop(prod,fac,method); //最上階
		} else {
			if (typ.equals("S")) { getWhereUseSingle(prod,fac,method); //single-level
			} else if (typ.equals("M")) { getWhereUseMulti(prod,fac,method,0); //multi-level
			} else { getWhereUseTop(prod,fac,method); //最上階
			}
		}
		return this.iNext;
	} // end getWhereUse

	public boolean getWhereUseTop(String prod, String fac, String method) throws Exception
	{
		String where = "";
		if (fac!=null) { where = where + " AND bmwhs='"+fac+"'";
		}
		if (method!=null) { where = where + " AND bmbomm='"+method+"'";
		}
		DateBean dateBean = new DateBean();
		String sToday = dateBean.getYearMonthDay();
		PreparedStatement st=conn.prepareStatement("SELECT bprod,bchld,bseq,bqreq,iityp,iclas,iums,idesc||idsce AS desc"+
		" FROM mbm,iim "+
		" WHERE bprod=iprod AND bdeff <="+sToday+" AND bddis>="+sToday+" AND bchld='"+prod+"' "+where+" ORDER BY bprod ");
		ResultSet rs = st.executeQuery();
		boolean eof = !rs.next();
		if (eof) { return false;
		} else {
			while (!eof) {
				if ( getWhereUseTop(rs.getString("bprod").trim(),fac,method) ) {
				} else {
					if (this.iNext<a.length) { 
						boolean found=false;
						for (int j=0;j<this.iNext;j++) {
							if (a[j][3].equals(rs.getString("bprod").trim())) { found=true; break; }
						}
						if (!found) {
							setLevelCode("0");
							setLevelString(".0");
							setParent(rs.getString("bprod").trim());
							getItemProperty(rs.getString("bprod").trim());
							setDesc(getItemDesc());
							setUM(getItemUM());
							setCtype(getItemType());
							setCclass(getItemClass());
							getNext();
						}
					} // end if
				} // end if-else
				eof = !rs.next();
			} // end while rs
		}
		rs.close();
		st.close();	
		return true;
	}// end getWhereUseTop
	public boolean getWhereUseSingle(String prod, String fac, String method) throws Exception
	{
		String where = "";
		if (fac!=null) { where = where + " AND bmwhs='"+fac+"'";
		}
		if (method!=null) { where = where + " AND bmbomm='"+method+"'";
		}
		DateBean dateBean = new DateBean();
		String sToday = dateBean.getYearMonthDay();
		PreparedStatement st=conn.prepareStatement("SELECT bprod,bchld,bseq,bqreq,iityp,iclas,iums,idesc||idsce AS desc"+
		" FROM mbm,iim "+
		" WHERE bprod=iprod AND bdeff <="+sToday+" AND bddis>="+sToday+" AND bchld='"+prod+"' "+where+" ORDER BY bprod ");
		ResultSet rs = st.executeQuery();
		boolean eof = !rs.next();
		if (eof) { return false;
		} else {
			while (!eof) {
				if (this.iNext<a.length) { 
					boolean found=false;
					for (int j=0;j<this.iNext;j++) {
						if (a[j][3].equals(rs.getString("bprod").trim())) {found=true; break; }
					}
					if (!found) {
						setLevelCode("0");
						setLevelString(".0");
						setParent(rs.getString("bprod").trim());
						getItemProperty(rs.getString("bprod").trim());
						setDesc(getItemDesc());
						setUM(getItemUM());
						setCtype(getItemType());
						setCclass(getItemClass());
						getNext();
					}
				}
				eof = !rs.next();
			} // end while rs
		}
		rs.close();
		st.close();	
		return true;
	}// end getWhereUseSingle
	public boolean getWhereUseMulti(String prod, String fac, String method, int level) throws Exception
	{
		String where = "";
		if (fac!=null) { where = where + " AND bmwhs='"+fac+"'";
		}
		if (method!=null) { where = where + " AND bmbomm='"+method+"'";
		}
		DateBean dateBean = new DateBean();
		String sToday = dateBean.getYearMonthDay();
		PreparedStatement st=conn.prepareStatement("SELECT bprod,bchld,bseq,bqreq,iityp,iclas,iums,idesc||idsce AS desc"+
		" FROM mbm,iim "+
		" WHERE bprod=iprod AND bdeff <="+sToday+" AND bddis>="+sToday+" AND bchld='"+prod+"' "+where+" ORDER BY bprod ");
		ResultSet rs = st.executeQuery();
		boolean eof = !rs.next();
		if (eof) { return false;
		} else {
			while (!eof) {
				if (this.iNext<a.length) {
					String l = String.valueOf(level+1);
					setLevelCode(l);
					setLevelString(padLeft(l,".",level+1));
					setParent(rs.getString("bprod").trim());
					getItemProperty(rs.getString("bprod").trim());
					setDesc(getItemDesc());
					setUM(getItemUM());
					setCtype(getItemType());
					setCclass(getItemClass());
					getNext();
					getWhereUseMulti(rs.getString("bprod").trim(),fac,method,level+1);
				} else { return false;
				}// end if
				eof = !rs.next();
			} // end while rs
		}
		rs.close();
		st.close();	
		return true;
	}// end getWhereUseMulti

//======where use	

	// 在s1右邊加n次s2
	public String padLeft(String s1, String s2, int n) throws Exception
	{
		if (n>0) {
			for (int i=0;i<n;i++) {
				s1 = s2 + s1;
			}
		}
		return s1;
	}// end padLeft

}

