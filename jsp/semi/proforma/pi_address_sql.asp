<%

I6 (CN) hk & KOREA

		deliver_to_sql =" select oola.line_id ,prl.requisition_line_id, hl.ADDRESS_KEY, "&_    
						" hl.city , hl.POSTAL_CODE, hps.ADDRESSEE, FTT.TERRITORY_SHORT_NAME country,  "&_ 
						" hcsua.CUST_ACCT_SITE_ID "&_  
						" from PO_HEADERS_ALL poh ,PO_LINES_ALL pol ,RCV_SHIPMENT_HEADERS rsh ,RCV_SHIPMENT_LINES rsl , "&_    
						" PO_DISTRIBUTIONS_ALL PODIS ,PO_REQUISITION_HEADERS_ALL PRH ,PO_REQUISITION_LINES_ALL PRL, "&_     
						" PO_REQ_DISTRIBUTIONS_ALL PRDIS ,oe_order_lines_all oola ,oe_order_headers_all ooha, "&_  
						" HZ_CUST_ACCOUNTS hca, HZ_CUST_ACCT_SITES_ALL hcasa ,HZ_CUST_SITE_USES_ALL hcsua , "&_     
						" HZ_LOCATIONS hl ,HZ_PARTY_SITES hps ,FND_TERRITORIES_TL FTT  "&_  
						" where poh.po_header_id =  pol.po_header_id and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "&_    
						" and rsl.po_header_id  = pol.po_header_id and rsl.PO_LINE_ID = pol.PO_LINE_ID "&_      
						" and prdis.requisition_line_id = prl.requisition_line_id   "&_     
						" and prh.requisition_header_id = prl.requisition_header_id "&_   
						" and podis.req_distribution_id = prdis.distribution_id  "&_             
						" and poh.po_header_id = podis.po_header_id and podis.po_header_id  =  pol.po_header_id "&_      
						" and podis.po_line_id = pol.po_line_id and oola.line_id = prl.attribute1 "&_          
						" and oola.HEADER_ID=ooha.header_id "&_   
						" and ooha.SHIP_TO_ORG_ID  =  hcsua.site_use_id  "&_  
						" and  hcasa.cust_acct_site_id = hcsua.cust_acct_site_id "&_    
						" and  hps.PARTY_SITE_ID =  hcasa.PARTY_SITE_ID "&_  
						" and  hps.PARTY_ID = hca.PARTY_ID  "&_  
						" and podis.PO_DISTRIBUTION_ID = rsl.PO_DISTRIBUTION_ID  "&_ 
						" and hps.PARTY_SITE_ID =  hcasa.PARTY_SITE_ID "&_     
						" and  hps.LOCATION_ID = hl.LOCATION_ID "&_     
						" and  hl.COUNTRY = FTT.TERRITORY_CODE "&_      
						" and  FTT.LANGUAGE = 'US' "&_     
						" and  rsh.PACKING_SLIP = '" & invoice_no & "'" 
						
I6 (CN) hk & KOREA
							bill_to_sql=" select oola.line_id , prl.requisition_line_id ,hl.ADDRESS_KEY,  "&_   
				" hl.city ,hl.POSTAL_CODE, hps.ADDRESSEE, FTT.TERRITORY_SHORT_NAME country,  "&_     
				" hcsua.CUST_ACCT_SITE_ID from PO_HEADERS_ALL poh ,PO_LINES_ALL pol ,    "&_ 
				" RCV_SHIPMENT_HEADERS rsh ,RCV_SHIPMENT_LINES rsl ,"&_     
				" PO_DISTRIBUTIONS_ALL PODIS ,PO_REQUISITION_HEADERS_ALL PRH , PO_REQUISITION_LINES_ALL PRL, "&_    
				" PO_REQ_DISTRIBUTIONS_ALL PRDIS ,  "&_     
				" oe_order_lines_all oola , oe_order_headers_all ooha , "&_    
				" HZ_CUST_ACCOUNTS  hca ,HZ_CUST_ACCT_SITES_ALL hcasa ,"&_     
				" HZ_CUST_SITE_USES_ALL hcsua ,HZ_LOCATIONS hl ,HZ_PARTY_SITES hps , "&_     
				" FND_TERRITORIES_TL FTT  "&_     
				" where poh.po_header_id =  pol.po_header_id and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID  "&_      
				" and rsl.po_header_id  = pol.po_header_id and rsl.PO_LINE_ID = pol.PO_LINE_ID   "&_    
				" and prdis.requisition_line_id = prl.requisition_line_id     "&_    
				" and prh.requisition_header_id = prl.requisition_header_id   "&_  
				" and podis.req_distribution_id = prdis.distribution_id and poh.po_header_id = podis.po_header_id  "&_     
				" and podis.PO_DISTRIBUTION_ID = rsl.PO_DISTRIBUTION_ID     "&_ 
				" and podis.po_header_id  =  pol.po_header_id and podis.po_line_id=pol.po_line_id   "&_     
				" and oola.line_id = prl.attribute1 "&_ 
				" and oola.HEADER_ID=ooha.header_id "&_  
				" and  ooha.INVOICE_TO_ORG_ID  =  hcsua.site_use_id  "&_   
				" and  hcsua.cust_acct_site_id = hcasa.cust_acct_site_id  "&_   
				" AND hps.party_site_id = hcasa.party_site_id   "&_ 
				" and  hps.PARTY_ID = hca.PARTY_ID     "&_    
				" and hps.LOCATION_ID = hl.LOCATION_ID  "&_     
				" and hl.COUNTRY = FTT.TERRITORY_CODE "&_      
				" and hcasa.ORG_ID=41   "&_  
				" and  FTT.LANGUAGE = 'US' "&_      
				" and  rsh.PACKING_SLIP = '" & invoice_no & "' "






%>