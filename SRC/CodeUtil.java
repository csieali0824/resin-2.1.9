import java.io.*;
public class CodeUtil
{
	public static String big5ToUnicode(String s)
	{
		try
		{
			return new String(s.getBytes("ISO8859_1"),"Big5");
		} //end of try
		catch (UnsupportedEncodingException uee)
		{
			return s;
		} //end of UnsupportedEncodingException
	}//end of big5toUnicode

	public static String unicodeToBig5(String s)
	{
		try
		{
			return new String(s.getBytes("Big5"),"ISO8859_1");
		}//end of try
		catch (UnsupportedEncodingException uee)
		{
			return s;
		} //end of catch
	} //end of unicodeToBig5

	public static String toHexString(String s)
	{
		String str="";
		for (int i=0;i<s.length();i++)
		{
			int ch=(int)s.charAt(i);
			String s4="0000"+Integer.toHexString(ch);
			str=str+s4.substring(s4.length()-4)+"";
		} //end of for
		return str;
	}// end of toHexString

	public static String stringToHex(String s)
	{
		String str="";
		for (int i=0;i<s.length();i++)
		{
			int ch=(int)s.charAt(i);
			String s2="00"+Integer.toHexString(ch).toUpperCase();
			str=str+s2.substring(s2.length()-2)+"";
		} //end of for
		return str;
	}// end of toHexString

	public static String hexToString(String strValue)
	{
		int intCounts = strValue.length() / 2;
		String strReturn = "";
		String strHex = "";
		int intHex = 0;
		byte byteData[] = new byte[intCounts];
		try
		{
			for (int intI = 0; intI < intCounts; intI++)
			{
				strHex = strValue.substring(0, 2);
				strValue = strValue.substring(2);
				intHex = Integer.parseInt(strHex, 16);
				if (intHex > 128)
					intHex = intHex - 256;
				byteData[intI] = (byte) intHex;
			}
			strReturn = new String(byteData,"ISO8859-1");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return strReturn;
	} //end of hexToString

	public static String convertFullorHalf(String originalStr, int option)
	{
		String[] asciiTable = {" ", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/",
				"0", "1", "2", "3", "4", "5","6", "7", "8", "9",  ":", ";", "<", "=", ">", "?", "@",
				"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
				"[", "\\", "]", "^", "_", "`",
				"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
				"{", "|", "}", "~"};
		String[] big5Table = {"　", "！", "”", "＃", "＄", "％", "＆", "’", "（", "）", "＊", "＋", "，", "－", "‧", "／",
				"０", "１", "２", "３", "４", "５","６", "７", "８", "９",  "：", "；", "＜", "＝", "＞", "？", "＠",
				"Ａ", "Ｂ", "Ｃ", "Ｄ", "Ｅ", "Ｆ", "Ｇ", "Ｈ", "Ｉ", "Ｊ", "Ｋ", "Ｌ", "Ｍ", "Ｎ", "Ｏ", "Ｐ", "Ｑ", "Ｒ", "Ｓ", "Ｔ", "Ｕ", "Ｖ", "Ｗ", "Ｘ", "Ｙ", "Ｚ",
				"〔", "＼", "〕", "︿", "＿", "‘",
				"ａ", "ｂ", "ｃ", "ｄ", "ｅ", "ｆ", "ｇ", "ｈ", "ｉ", "ｊ", "ｋ", "ｌ", "ｍ", "ｎ", "ｏ", "ｐ", "ｑ", "ｒ", "ｓ", "ｔ", "ｕ", "ｖ", "ｗ", "ｘ", "ｙ", "ｚ",
				"｛", "｜", "｝", "～"};

		if(asciiTable.length == big5Table.length)
		{
			//System.out.println("對照表長度正確！ 長度為： " + asciiTable.length);
			//開始轉換
			if(originalStr == null || "".equalsIgnoreCase(originalStr))
			{
				return "";
			}
			for(int i = 0 ; i < asciiTable.length; i++)
			{
				//印出對照表
				//System.out.println((i + 1) + ":  " + asciiTable[i] + "\t" + big5Table[i]);
				//開始轉換
				if(option == 0)//to Half
				{
					originalStr = originalStr.replace(big5Table[i], asciiTable[i]);//不可以用replaceAll，會因regular expression出錯
				}
				if(option == 1)//to Full
				{
					originalStr = originalStr.replace(asciiTable[i], big5Table[i]);//不可以用replaceAll，會因regular expression出錯
				}
			}
			return originalStr;
		}
		else
		{
			//System.out.println("對照表長度不正確！ asciiTable長度為： " + asciiTable.length);
			//System.out.println("對照表長度不正確！ big5Table長度為： " + big5Table.length);
			return originalStr;
		}
	}

}


