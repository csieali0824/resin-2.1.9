<%
	'�U���|�]�w
	logon_web_path		=	"/maintain"
	logon_web_index		=	"index.asp"
	admin_web_path 		= 	""		
	web_path			=	""
	
	'connection setting
	
	 Set Ora_conn=Server.CreateObject("ADODB.Connection") 'oracle connection 
     Ora_conn.open "file name=" & server.mappath("Oracle.UDL") 

   '�y�t�]�w
   	default_language			=	"TW"
   	
   '�Ϥ����|�ΦW��
    default_menu_pic_path		=	web_path & "/Download/menu"			'���عw�]���|
 	default_menu_pic_name		=	"Menu_"								'���عw�]�ɦW
 	
 	default_product_pic_path	=	web_path & "/tsc_euro_po/upload"		'���~
 	'default_productm_bpic_name	=	"PMB_"								'���~����
 	default_productm_spic_name	=	"CO_"								'���~�p�ϥ���
 	'default_productm_mpic_name	=	"PMM_"								'���~������
 	'default_productd_pic_name	=	"PD_"								'���~���Ө�L��
	
	'default_news_pic_path		=	web_path & "/Download/news"			'�s�D�Ϥ�
	'default_news_pic_name		=	"News_"								'�s�D�w�]�ɦW
%>

