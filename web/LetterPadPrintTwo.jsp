<%-- 
    Document   : LetterPad2Print
    Created on : 28 Jul, 2020, 11:32:33 PM
    Author     : winayak
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width,user-scalable=no">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

        <link rel="stylesheet" href="css/index.css">
        <link rel="icon" href="images/MSCE.png">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <title>MSCElectricals Letter Pad Two Print</title>
        <style>
            body{
                height: auto;
                overflow: auto;
            }
            label{
                width: 100%;
            }
            td{
                white-space: nowrap;
                vertical-align: middle;
            }
            input{
                margin-bottom: 0;
                min-height: auto;
                padding: 5px;
                border : 1px solid #cacaca;
            }
            textarea{
                border : 1px solid #cacaca;
            }
            .hide{
                border: 0;
                padding: 0;
                color: blue;
                font-size: 15px;
                display : block;
            }
            .style2 {
                font-size: 44px;
                font-weight: bold;
                font-family: Arial, Helvetica, sans-serif;
                float: left;
            }
            .style2>input{
                width: calc(100% - 80px);
                float: right;
                text-align: left!important;
            }
            #left{
                float: left;
                width: 650px;
            }
            #right{
                float: right;
                width: 350px;
            }
            hr{
                clear: both;
            }
            #right input{
                text-align: right;
            }
            
            input{
                border: 0!important;
            }
            #printbtn,#savebtn{
                border: 1px solid #cacaca!important;
            }
            #gstin input{
                font-weight: bold;               
                font-size: 20px;
                padding-left: 15px;
            }
            #gstin{
                margin-top: 0;
                float: right;
                width: calc(100% - 80px);
                margin-top: -22px;
            }
            #info input{
                font-weight: bold;               
                font-size: 20px;
                padding-left: 15px;
            }
            #info{
                margin-top: 0;
                float: right;
                width: 100%;
                margin-top: -37px;
            }
            .style2 img{
                float: left;
            }
            #right p{
                margin-bottom: -20px;
            }
            .after_date{

                margin-top: 5px;
                font-size: 16px;
            }
            input.after_date {
                padding: 0;
            }
            .fa.fa-location-arrow,.fa.fa-envelope{
                float: right;
                font-size: 16px;
            }
        </style>
        <script>
            $(document).ready(function(){
                $("#printbtn").click(function(){
                    $("#printbtn").hide();
                    $("input").css("border","0");
                    $("textarea").css("border","0");
                    if(!window.print()){
                        $("input").css("border","1px solid #cacaca");
                        $("textarea").css("border","1px solid #cacaca");
                        $("#printbtn").show();
                    }
                });
            });
        </script>
    </head>
    <body style="color:blue; font-family:arial;">
        <table width="800" height="341" border="0" align="center" style="margin-bottom: 10px;border:solid 0px red; background-color:#FFFFFF;font-size: 15px;">
  <tr>
    <td height="209" style="vertical-align: bottom;">
        <div id="left">
            <div class="style2">
                <img src="images/MSCE.png" height="80" width="80" align="baseline">
                <input class="hide style2" type="text" value="&nbsp;M/s. MSC ELECTRICALS" style="text-align:center;"> 
                <p id="gstin"><input type="text" value="GSTIN: 18ASRPC7468B1ZI/PAN NO: ASRRPC7468B"></p>
            </div>
            <p id="info"><input type="text" value="RLY. GENERAL ORDER SUPPLIER & CONTRACTOR"></p>
        </div>
        <div id="right">
            <p><input type="text" value="Deals In : Electronics"></p>
            <p><input type="text" value="Mechanical,Computer Items & Trading Items"></p>
            <p><input type="text" value="All type of Software make and other items"></p>
            <br>
            <p><input type="text" value="Deals In: Railway Project,IOCL Project,ASEB project"></p>
        </div>
            <hr style="border:solid 1px blue">            
    </td>
      </tr>
        
  <tr>
    <td height="34"><table width="1000" align="center" cellpadding="3">
      <tr>
        <td width="50" valign="top" >REF. NO. MSCE/</td>
        <td width="150" valign="top" style="border-bottom:solid 1px blue; border-bottom-style:groove;color:black;"><input type="text" id="refno" style="font-size:16px; width:159"></td>
        <td width="350" valign="top" >&nbsp;</td>
        <td width="80" valign="top" >&nbsp;</td>
        <td width="50" valign="top" >DATE</td>
        <td width="150" valign="top" style="border-bottom:solid 1px blue; border-bottom-style:groove;color:black;"><input type="date" id="dt" style="font-size:16px; width:159"></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td colspan="3"><input type="text" value="IREPS V-CODE-7100" class="after_date"></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td colspan="3"><input type="text" value="COS REG. NO. 7100 IREPS REGD. RLY" class="after_date"></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td><i class="fa fa-location-arrow"></i></td>
            <td colspan="3"><input type="text" value="H.O. NEW BONGAIGAON,BONGAIGAON" class="after_date"></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td colspan="3"><input type="text" value="P.O. NEW BONGAIGAON-783381" class="after_date"></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td colspan="3"><input type="text" value="DIST. BONGAIGAON (ASSAM)" class="after_date"></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td colspan="3"><span style="color:black;">CONT. </span><i class="fa fa-phone"></i><input type="text" value=" 7002321056" class="after_date" style="width:110px;">,<i class="fa fa-whatsapp"></i><input type="text" value=" 8486109669" class="after_date" style="width:110px;"></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td><i class="fa fa-envelope"></i></td>
            <td colspan="3"><input type="text" value="mscelectricals2015@gmail.com" class="after_date"></td>
        </tr>
        
      
    </table></td>
  </tr>
  <tr>
    <td height="700" valign="top"><label>
      <textarea name="text" id="text" style="height:700px; width:100%; font-size:16px; font-family:arial; padding:20px; line-height:25px;">



To,
     Dy CMM/D/NBQ
     N.F. Railway, New Bongaigaon.


Sub:-  Inspection Clause.

Ref:- Your LPO No- NB175191150221 , Dt- 29/06/17


Dear Sir,
           Most respectfully , In reference the above LPO, Where in the Inspection clause as RITES/Kolkata & DP by 27/07/17, but sir during this short period, it is not possible to inspect the material by RITES/Kolkata.
                                                                              
           Therefore, you are requested arrange to modify the inspection clause as � CONSIGNEE� instead of  RITES/Kolkata. So that we may able to supply the  material in due date please.
	  </textarea>
    </label></td>
  </tr>
  <tr>
    <td><table width="100%" border="0">
      <tr>
        <td width="67%">&nbsp;</td>
        <td width="33%"><div align="right"><input class="hide" type="text" value="M/s. MSC ELECTRICALS" style="text-align:right"> </div></td>
      </tr>
	 
    </table>
	<center> <input type="button" name="printbtn" id="printbtn" value="Print" style="padding:10px;min-height:30px; width:80px;""></center>
	</td>
  </tr>
</table>
    </body>
</html>
