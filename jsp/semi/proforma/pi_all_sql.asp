<%
I6 CN HK & KOREA

    sql="insert into DAPHNE_INVOICE_OTHER "&_
   		"select   data.NAME,data.ITEM_DESCRIPTION, data.INITIAL_PICKUP_DATE,data.INITIAL_PICKUP_DATE, "&_  
                "data.CUST_PO_NUMBER,data.SRC_REQUESTED_QUANTITY,data.UNIT_SELLING_PRICE,data.CURRENCY_CODE, "&_  
                "data.AMOUNT,data.NET_INVOICE_VALUE,'0', (data.NET_INVOICE_VALUE ) TOTAL_AMOUNT, "&_   
                "data.FOB_POINT_CODE,"&_
		"'" & V_Shipto & "',"&_
		"data.TERMS,decode(DATA.itype,'Customer',DATA.customer_job,null) customer_job,data.PARTY_NAME,data.tax_reference , "&_   
                "data.CCCODE,data.TAX_CODE,data.PACKING_INSTRUCTIONS,"&_
				" data.SHIP_TO_ADDRESS1 , "&_  
				"'" & Deliver_city & "' ,"&_
				"'" & Deliver_postal_code & "' ,"&_
				"'" & Deliver_country	 & "' ,"&_  
                " DATA.INVOICE_TO_ADDRESS1, "&_
				"'" & Cust_city & "' ,"&_
				"'" & Cust_postal_code & "' ,"&_
				"'" & Cust_country	 & "' ,"&_
				"'0000', "&_
				"'" & Deliver_addressee & "' ,"&_  
				"'HK & KOREA','Y', "&_   
                "data.ORDER_NUMBER ,  '" & request("V_ShipFrom") & "'  ,null,data.header_id,null   "&_  
                "from "&_ 
              " ( select oola.line_id ,prl.requisition_line_id, rsh.PACKING_SLIP NAME, pol.ITEM_DESCRIPTION, "&_  
                          " pol.item_id INVENTORY_ITEM_ID ,rsh.creation_date INITIAL_PICKUP_DATE, ooha.CUST_PO_NUMBER, "&_  
                          " oola.SHIPPED_QUANTITY, decode (rsl.UNIT_OF_MEASURE,'KPC',rsl.QUANTITY_RECEIVED*1000,rsl.QUANTITY_RECEIVED) SRC_REQUESTED_QUANTITY, "&_  
                          " oola.UNIT_SELLING_PRICE, ooha.TRANSACTIONAL_CURR_CODE  CURRENCY_CODE, "&_  
                          " ( decode (rsl.UNIT_OF_MEASURE,'KPC',rsl.QUANTITY_RECEIVED*1000,rsl.QUANTITY_RECEIVED)) * oola.UNIT_SELLING_PRICE AMOUNT , "&_  
                          " ( select sum(( decode (rsl.UNIT_OF_MEASURE,'KPC',rsl.QUANTITY_RECEIVED*1000,rsl.QUANTITY_RECEIVED)) * oola.UNIT_SELLING_PRICE ) "&_   
                          " from PO_HEADERS_ALL poh ,PO_LINES_ALL pol ,RCV_SHIPMENT_HEADERS rsh ,RCV_SHIPMENT_LINES rsl ,PO_DISTRIBUTIONS_ALL PODIS , "&_   
                                "PO_REQUISITION_HEADERS_ALL PRH , PO_REQUISITION_LINES_ALL PRL ,PO_REQ_DISTRIBUTIONS_ALL PRDIS, "&_   
                                "oe_order_lines_all oola ,oe_order_headers_all ooha "&_   
                          " where poh.po_header_id =  pol.po_header_id and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "&_ 	   
                            "and rsl.po_header_id  = pol.po_header_id and rsl.PO_LINE_ID = pol.PO_LINE_ID "&_    
                            "and prdis.requisition_line_id = prl.requisition_line_id "&_     
                            "and prh.requisition_header_id = prl.requisition_header_id "&_   
                            "and podis.req_distribution_id = prdis.distribution_id "&_
							"and podis.PO_DISTRIBUTION_ID = rsl.PO_DISTRIBUTION_ID "&_
                            "and poh.po_header_id = podis.po_header_id and podis.po_header_id=pol.po_header_id "&_    
                            "and podis.po_line_id = pol.po_line_id and oola.line_id = prl.attribute1 "&_       
                            "and  oola.HEADER_ID=ooha.header_id and rsh.PACKING_SLIP = '" & invoice_no & "' "&_            
                          " ) NET_INVOICE_VALUE, "&_  
       "  (select sum(( decode (rsl.UNIT_OF_MEASURE,'  & kp &  ',rsl.QUANTITY_RECEIVED*1000,rsl.QUANTITY_RECEIVED)) * oola.UNIT_SELLING_PRICE )  "&_  
            " from  PO_HEADERS_ALL poh ,PO_LINES_ALL pol , "&_  
                  " RCV_SHIPMENT_HEADERS rsh ,RCV_SHIPMENT_LINES rsl , "&_   
                  " PO_DISTRIBUTIONS_ALL PODIS ,PO_REQUISITION_HEADERS_ALL PRH ,"&_
                  " PO_REQUISITION_LINES_ALL PRL, PO_REQ_DISTRIBUTIONS_ALL PRDIS  , "&_
                  " oe_order_lines_all oola , "&_   
                  " oe_order_headers_all ooha "&_   
            "where poh.po_header_id =  pol.po_header_id "&_   
              "and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "&_   
              "and rsl.po_header_id = pol.po_header_id "&_   
              "and rsl.PO_LINE_ID = pol.PO_LINE_ID "&_   
              "and prdis.requisition_line_id = prl.requisition_line_id "&_    
              "and prh.requisition_header_id = prl.requisition_header_id "&_  
			  "and podis.PO_DISTRIBUTION_ID = rsl.PO_DISTRIBUTION_ID "&_  
              "and podis.req_distribution_id = prdis.distribution_id "&_            
              "and poh.po_header_id = podis.po_header_id "&_    
              "and podis.po_header_id  =  pol.po_header_id "&_   
              "and podis.po_line_id    =  pol.po_line_id "&_     
              "and oola.line_id = prl.attribute1 and oola.HEADER_ID=ooha.header_id "&_
              "and rsh.PACKING_SLIP = '" & invoice_no & "' "&_
              ") VAT, oola.FOB_POINT_CODE, oola.SHIPPING_METHOD_CODE, ooha.TERMs , "&_
              "oola.ORDERED_ITEM customer_job, hp.PARTY_NAME, hp.person_first_name ,hp.person_last_name , "&_    
              "hp.tax_reference ,tc.CCCODE,oola.TAX_CODE,oola.PACKING_INSTRUCTIONS,ooha.invoice_to_address1, "&_   
              "ooha.DELIVER_TO_ADDRESS1,ooha.HEADER_ID,ooha.order_number, ooha.ship_to_address1 ,oola.ITEM_IDENTIFIER_TYPE itype "&_   
        "from PO_HEADERS_ALL poh ,PO_LINES_ALL pol,RCV_SHIPMENT_HEADERS rsh, RCV_SHIPMENT_LINES rsl, "&_  
             "PO_DISTRIBUTIONS_ALL PODIS ,PO_REQUISITION_HEADERS_ALL PRH ,PO_REQUISITION_LINES_ALL PRL, "&_   
             "PO_REQ_DISTRIBUTIONS_ALL PRDIS , "&_    
             "oe_order_lines_all oola, oe_order_headers_v ooha, "&_  
             "mtl_system_items_b msi, mtl_item_categories mc, mtl_categories_tl mct , "&_   
             "tsc_cccode tc, HZ_CUST_ACCOUNTS  hca ,HZ_PARTIES hp "&_
        "where poh.po_header_id =  pol.po_header_id and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "&_  
          "and rsl.po_header_id  = pol.po_header_id and rsl.PO_LINE_ID = pol.PO_LINE_ID "&_    
          "and prdis.requisition_line_id = prl.requisition_line_id "&_  
          "and prh.requisition_header_id = prl.requisition_header_id "&_   
          "and podis.req_distribution_id = prdis.distribution_id "&_     
		  "and podis.PO_DISTRIBUTION_ID = rsl.PO_DISTRIBUTION_ID "&_      
          "and poh.po_header_id = podis.po_header_id and podis.po_header_id  =  pol.po_header_id "&_    
          "and podis.po_line_id    =  pol.po_line_id and oola.line_id = prl.attribute1 "&_      
          "and oola.HEADER_ID=ooha.header_id and pol.ITEM_ID=msi.INVENTORY_ITEM_ID "&_    
          "and rsl.to_ORGANIZATION_ID=msi.ORGANIZATION_ID "&_   
          "and  msi.inventory_item_id = mc.inventory_item_id "&_   
          "and  msi.organization_id   = mc.organization_id "&_  
          "and  mc.CATEGORY_SET_ID=6 "&_   
          "and  mc.category_id = mct.category_id "&_   
          "and  mct.language = 'US' "&_   
          "and  tc.category_id(+) = mct.category_id "&_    
          "and  tc.language(+) = mct.language "&_   
          "and  ooha.SOLD_TO_ORG_ID =  hca.cust_account_id "&_    
          "and  hp.party_id = hca.party_id "&_           
          "and  rsh.PACKING_SLIP  ='" & invoice_no & "' "&_
          " ) data "




%>