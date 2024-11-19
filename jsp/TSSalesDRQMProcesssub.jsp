<%@ page language="java" import="java.sql.*,java.text.*"%>
<html>
<title></title>
<body>
<%
	String stockArray[][]= StockInfoBean.getArray2DContent();
	if (stockArray!=null)
	{	
		for( int j=0 ; j< stockArray.length ; j++ ) 
		{
			if (stockArray[j][0].equals(dnDocNo) && stockArray[j][1].equals(aFactoryArrangedCode[i][0]))
			{
				if (stockArray[j][2].equals("Y"))
				{
					sql = " update tsc_po_unallocated"+
						  " set rfq_allocated_quantity=nvl(rfq_allocated_quantity,0)+(?*1000)"+
						  " where organization_id=?"+
						  " and inventory_item_id=?"+
						  " and type_id=?"+
						  " and po_line_location_id is null";
					//out.println(sql);
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,aFactoryArrangedCode[i][2]);
					pstmt.setString(2,stockArray[j][8]);
					pstmt.setString(3,stockArray[j][7]);
					pstmt.setString(4,"2");
					pstmt.executeUpdate(); 
					pstmt.close();   
				}
				else if (stockArray[j][3].equals("Y"))
				{
					ship_qty = Long.parseLong(aFactoryArrangedCode[i][2]) *1000;
					allot_qty =0;
					
					sql = " select po_unallocated_id,nvl(quantity,0)-nvl(rfq_allocated_quantity,0) unallot_qty "+
						  " from tsc_po_unallocated a"+
						  " where organization_id=?"+
						  " and inventory_item_id=?"+
						  " and type_id<>?"+
						  " and po_line_location_id is not null"+
						  " and nvl(quantity,0)-nvl(rfq_allocated_quantity,0)>0"+
						  " order by need_by_date";
					//out.println(sql);
					PreparedStatement statementx = con.prepareStatement(sql);
					statementx.setString(1,stockArray[j][8]);
					statementx.setString(2,stockArray[j][7]);
					statementx.setString(3,"3");
					ResultSet rsx=statementx.executeQuery();	
					while(rsx.next())
					{											  
						if (rsx.getInt("unallot_qty")>=ship_qty)
						{
							allot_qty = ship_qty;
						}
						else
						{
							allot_qty =rsx.getLong("unallot_qty"); 	
						}
						ship_qty -= allot_qty;
						
						sql = " update tsc_po_unallocated"+
							  " set rfq_allocated_quantity=nvl(rfq_allocated_quantity,0)+?"+
							  " where po_unallocated_id=?";
						//out.println(sql);
						pstmt=con.prepareStatement(sql);
						pstmt.setString(1,""+allot_qty);
						pstmt.setString(2,rsx.getString("po_unallocated_id"));
						pstmt.executeUpdate(); 
						pstmt.close(); 
						
						if (ship_qty<=0) break;
					}
					rsx.close();
					statementx.close();																				
				}
				else if (stockArray[j][4].equals("Y"))
				{
					vendor_site_id = stockArray[j][5];
					vendor_ssd=	stockArray[j][6];								
				}
			}
		}
	}

%>
</body>
</html>
