<%
	'各路徑設定
	logon_web_path		=	"/maintain"
	logon_web_index		=	"index.asp"
	admin_web_path 		= 	""		
	web_path			=	""
	
	'connection setting
	
	 Set Ora_conn=Server.CreateObject("ADODB.Connection") 'oracle connection 
     Ora_conn.open "file name=" & server.mappath("Oracle.UDL") 

   '語系設定
   	default_language			=	"TW"
   	
   '圖片路徑及名稱
    default_menu_pic_path		=	web_path & "/Download/menu"			'項目預設路徑
 	default_menu_pic_name		=	"Menu_"								'項目預設檔名
 	
 	default_product_pic_path	=	web_path & "/tsc_euro_po/upload"		'產品
 	'default_productm_bpic_name	=	"PMB_"								'產品圖檔
 	default_productm_spic_name	=	"CO_"								'產品小圖示檔
 	'default_productm_mpic_name	=	"PMM_"								'產品型號檔
 	'default_productd_pic_name	=	"PD_"								'產品明細其他檔
	
	'default_news_pic_path		=	web_path & "/Download/news"			'新聞圖片
	'default_news_pic_name		=	"News_"								'新聞預設檔名
%>

