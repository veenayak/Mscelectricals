<%-- 
    Document   : LetterPad1Print
    Created on : 28 Jul, 2020, 11:32:14 PM
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
        <title>MSCElectricals Letter Pad One Print</title>
        <style>
            body{
                height: auto;
                overflow: auto;
            }
            .style2 {
                    font-size: 54px;
                    font-weight: bold;
                    font-family: Arial, Helvetica, sans-serif;
            }
            label{
                width: 100%;
            }
            input{
                margin-bottom: 0;
                min-height: auto;
                padding: 5px;
            }
            .hide{
                border: 0;
                padding: 0;
                color: blue;
                font-size: 15px;
                display : block;
                min-height: auto;
            }
            .style2 {
                font-size: 54px;
                font-weight: bold;
                font-family: Arial, Helvetica, sans-serif;
            }
            br{
                clear: both;
                float: left;
            }
            #add{
                position: fixed;
                bottom: 25px;
                right: 25px;
                width: 50px;
                border-radius: 30px;
                height: 50px;
            }
            .fa.fa-trash{
                font-size: 24px;
            }
            input:focus,select:focus{
                border: 1px solid #7579de!important;
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
            #printbtn,#savebtn,#updatebtn{
                border: 1px solid #cacaca!important;
            }
            #printbtn:hover,#savebtn:hover,#updatebtn:hover{
                background: #fafafa
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
            td{
                white-space: nowrap;
            }
            #subject,#header,#offer_valid,#comp_day{
                width: calc(100% - 200px);
                float: right;       
                padding: 0;
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
            }
            #name,#address{
                width: calc(100% - 50px);
                float: right;
            }
        </style>
        <script>
            $(document).ready(function(){
                id = <%=request.getParameter("id")%>; 

                $("#printbtn").click(function(){
                    $("#printbtn").hide();
                    $("input").css("border","0");
                    $("textarea").css("border","0");
                    $("#rows2 td:last-child").remove();
                    $("#rows td:last-child").remove();
                    $("#add").hide();
                    $("#rows3 td:last-child").remove();
                    $("#printbtn").hide();
                    $("#updatebtn").hide();
                    $("#savebtn").hide();
                    if(!window.print()){
                        $("#printbtn").show();
                        console.log(id);
                        if(id==null)
                            $("#savebtn").show();
                        else{
                            $("#updatebtn").show();
                        }
                        $("#add").show();
                        $("#rows2 tr").append('<td width="7%" align="center">Delete</td>');
                        $("#rows tr").append('<td align=\'center\' valign=top><i class=\'fa fa-trash\'></i></td>');
                        $("#rows3 tr").append('<td align=\'center\' valign=top></td>');
                    }
                });
                $("#add").click(function(){
                    var l =$(".items").length+1;
                   $("#rows").append('<tr class=\'items\'>'+
			'<td align=\'center\' valign=top class=\'sno\'>'+l+'</td>'+
			'<td valign=top><input type=\'text\' class=\'name\'></td>'+
			'<td align=\'center\' valign=top><input type=\'number\' class=\'code\'></td>'+
			'<td align=\'center\' valign=top><input type=\'text\' class=\'unit\'></td>'+
			'<td align=\'center\' valign=top><input type=\'number\' class=\'qty\'></td>'+
			'<td align=\'center\' valign=top><input type=\'number\' class=\'rate\'></td>'+
			'<td align=\'right\' valign=top><input type=\'number\' class=\'amt\'></td>'+
			'<td align=\'center\' valign=top><input type=\'number\' class=\'gst\'></td>'+
                        '<td align=\'center\' valign=top><i class=\'fa fa-trash\'></i></td>'+

                    ' </tr>');
                });
                $(document).on("click",".fa.fa-trash",function(){
                   $(this).parent().parent().remove(); 
                   sno();
                });
                $("#savebtn").click(function(){
                    var refno = $("#refno").val();
                    var date = $("#dt").val();
                    var name = $("#name").val();
                    var address = $("#address").val();
                    var ovalid = $("#offer_valid").val();
                    var cday = $("#comp_day").val();
                    var subject = $("#subject").val();
                    var header = $("#header").val();
                    var total = $("#total").val();
                    var array = [];
                    
                    $(".items").each(function(){
                        var obj = {};
                       obj.name = $(this).find(".name").val();
                       obj.code = $(this).find(".code").val();
                       obj.unit = $(this).find(".unit").val();
                       obj.qty = $(this).find(".qty").val();
                       obj.rate = $(this).find(".rate").val();
                       obj.amt = $(this).find(".amt").val();
                       obj.gst = $(this).find(".gst").val();
                       array.push(obj);
                    });
                    var json = JSON.stringify(array);
                    console.log(json);
                    $("#empty_after").remove();
                    var flag = 0;
                    $("input").each(function(){
                       if($(this).val()==""){
                           $(this).focus();
                           $(this).prop("placeholder","This field is required");
                           flag = 1;
                           return false;
                       } 
                    });  
                     setTimeout(function(){
                           $("input").prop("placeholder","");
                     },2000);
                    if(flag == 0){
                        $.ajax({
                           type:"post",
                           url:"LetterPad",
                           data:{json:json,total:total,refno:refno,date:date,name:name,address:address,ovalid:ovalid,cday:cday,subject:subject,header:header,type:"add"},
                           success:function(res){
                               alert(res);
                               window.close();
                           },
                           error:function(res){
                               alert(res);
                           }
                        });
                    }
                });
                $("#updatebtn").click(function(){
                    var id = <%=request.getParameter("id")%>; 
                    var refno = $("#refno").val();
                    var date = $("#dt").val();
                    var name = $("#name").val();
                    var address = $("#address").val();
                    var ovalid = $("#offer_valid").val();
                    var cday = $("#comp_day").val();
                    var subject = $("#subject").val();
                    var header = $("#header").val();
                    var total = $("#total").val();
                    var array = [];
                    
                    $(".items").each(function(){
                        var obj = {};
                       obj.name = $(this).find(".name").val();
                       obj.code = $(this).find(".code").val();
                       obj.unit = $(this).find(".unit").val();
                       obj.qty = $(this).find(".qty").val();
                       obj.rate = $(this).find(".rate").val();
                       obj.amt = $(this).find(".amt").val();
                       obj.gst = $(this).find(".gst").val();
                       array.push(obj);
                    });
                    var json = JSON.stringify(array);
                    console.log(json);
                    $("#empty_after").remove();
                    var flag = 0;
                    $("input").each(function(){
                       if($(this).val()==""){
                           $(this).focus();
                           $(this).prop("placeholder","This field is required");
                           flag = 1;
                           return false;
                       } 
                    });  
                     setTimeout(function(){
                           $("input").prop("placeholder","");
                     },2000);
                    if(flag == 0){
                        $.ajax({
                           type:"post",
                           url:"LetterPad",
                           data:{id:id,json:json,total:total,refno:refno,date:date,name:name,address:address,ovalid:ovalid,cday:cday,subject:subject,header:header,type:"update"},
                           success:function(res){
                               alert(res);
                               window.close();
                           },
                           error:function(res){
                               alert(res);
                           }
                        });
                    }
                });
                getlp();
                $(document).on("keyup",".qty",function(){
                    var qty = $(this).val();
                    var rate = $(this).parent().parent().find(".rate").val();
                    $(this).parent().parent().find(".amt").val(qty*rate)                    
                });
                $(document).on("keyup",".rate",function(){
                    var rate = $(this).val();
                    var qty = $(this).parent().parent().find(".qty").val();
                    $(this).parent().parent().find(".amt").val(qty*rate)                    
                });
                
            });
            function sno(){
                var count = 0
                $(".items").each(function(){
                    count++;
                   $(this).children(".sno").html(count); 
                });
                total();
            }
            function getlp(){
                var id = <%=request.getParameter("id")%>; 
                console.log(id);
                $("#edit_id").val(id);
                $("#save").hide();
                $("#save_edit").show();
                $("#dropdown").remove(); 
                console.log(id);
                if(id!="" && id!=null){
                    $("#savebtn").hide();
                    $.ajax({
                        type:"get",
                        url:"LetterPadDetails",
                        data:{type:"get",id:id},
                        success:function(list){   
                            if(list!=0){
                                var list = JSON.parse(list);                                
                                $("#refno").val(list[0].refno);
                                $("#dt").val(list[0].date);
                                $("#name").val(list[0].name);
                                $("#address").val(list[0].address);
                                $("#offer_valid").val(list[0].ovalid);
                                $("#comp_day").val(list[0].cday);
                                $("#subject").val(list[0].subject);
                                $("#header").val(list[0].header);
                                $("#total").val(list[0].total);

                                $(".items").remove();
                                var length = list[1].length;
                                for(var i = 0; i < list[1].length; i++) {
                                    var obj2 = list[1][i];
                                    $("#rows").append('<tr class=\'items\'>'+
                                    '<td align=\'center\' valign=top class=\'sno\'>'+length+'</td>'+
                                    '<td valign=top><input type=\'text\' class=\'name\' value=\''+obj2.name+'\'></td>'+
                                    '<td align=\'center\' valign=top><input type=\'number\' class=\'code\' value=\''+obj2.code+'\'></td>'+
                                    '<td align=\'center\' valign=top><input type=\'text\' class=\'unit\'value=\''+obj2.unit+'\'></td>'+
                                    '<td align=\'center\' valign=top><input type=\'number\' class=\'qty\' value=\''+obj2.qty+'\'></td>'+
                                    '<td align=\'center\' valign=top><input type=\'number\' class=\'rate\' value=\''+obj2.rate+'\'></td>'+
                                    '<td align=\'right\' valign=top><input type=\'number\' class=\'amt\' value=\''+obj2.amt+'\'></td>'+
                                    '<td align=\'center\' valign=top><input type=\'number\' class=\'gst\' value=\''+obj2.tax+'\'></td>'+
                                    '<td align=\'center\' valign=top><i class=\'fa fa-trash\'></i></td>'+

                                ' </tr>');
                                    length--;
                                }
                                total();
                             }
                             else{
                                 window.location.replace("MSCElectricalsLogin.jsp");
                             }
                        },
                        error: function (res) {
                            alert(res);
                        }     
                    });
                }
                else{
                    $("#updatebtn").hide();
                }
                $("#rows").keyup(function(){
                   total(); 
                });
            } 
            function total(){
                var total = 0;
                $(".items").each(function(){
                   var rate = $(this).find(".rate").val(); 
                   var qty = $(this).find(".qty").val(); 
                   var gst = $(this).find(".gst").val(); 
                   total = total + parseFloat(qty*(parseFloat(rate)+rate*gst/100));
                });
                $("#total").val(total.toFixed(0));
            }
        </script>
    </head>
    <body style="color:blue; font-family:arial;">
<table width="800" height="541" border="0" align="center" style="margin-bottom: 20px;border:solid 0px red; background-color:#FFFFFF;font-size: 15px;">
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
        <td width="50"  style="vertical-align: middle;">REF. NO. MSCE/</td>
        <td width="150" valign="top" style="border-bottom:solid 1px blue; border-bottom-style:groove;color:black;"><input type="text" id="refno" style="font-size:16px; width:159"></td>
        <td width="350" valign="top" >&nbsp;</td>
        <td width="80" valign="top" >&nbsp;</td>
        <td width="50" style="vertical-align: middle;">DATE</td>
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
    <td height="720" valign="top" style="padding-left:25px;padding-right:25px; color:black; font-size:14px;"><label> To,<br>
        <input type="text" id="name" required="required">    <br>
                <input type="text" id="address" required="required"><br>
        <br>
        <br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subject: 
    <input type="text" id="subject" required="required">
    <br>
    <br>
    Dear Sir,<br>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="text" id="header" required="required"> <br>
    <br>
    </label>
      <table width="100%" border="1" style="border-collapse:collapse; font-size:14px; color:black" cellpadding="3" cellspacing="0" bordercolor="#000000">
          <thead id="rows2">
        <tr style="font-weight:bold">
          <td width="5%" align="center"><p>Sl. No.</p>            </td>
          <td width="37%" align="center">Description of Work </td>
          <td width="8%" align="center"><p>HSN Code</p>            </td>
          <td width="7%" align="center">Unit</td>
          <td width="7%" align="center">Qty</td>
          <td width="11%" align="center">Rate</td>
          <td width="16%" align="center">Amount</td>
          <td width="7%" align="center">GST % Extra </td>
          <td width="7%" align="center">Delete</td>
        </tr>
          </thead>
          <tbody id="rows">
              
          </tbody>
        
					
          <tfoot id="rows3">
		<tr>
        	<td colspan="6" style="border-right:none"><div align="right"><strong>TOTAL</strong></div></td>
        	<td  align='right' style="border-right:none;border-left:none" >                <input type="number" id="total" required="required"><br>
</td>
			<td style="border-left:none"></td>
                        	<td style="border-left:none"></td>
		  </tr>
          </tfoot>
      </table>
	  	<div style="padding:10px; text-align:center">
	<i style="color:black;">Kindly favour us your valued offer to prove our workmanship and efficiency.</i> 
	</div>

	  </td>
  </tr>
  <tr>
    <td style="padding-left:25px; padding-right:25px;"><table width="100%" border="0">
      <tr>
        <td width="67%" valign="top" style="font-size:14px; color:black"><u>Terms & Condition:</u><br>
          1. Date of Completion	- <input type="text" id="comp_day" required="required"><br>
		  2. Offer Validity     - <input type="text" id="offer_valid" required="required"><br>
		  3. Payment 100% Against Bill
		  
		  </td>
        <td width="33%" valign="top"><div align="right">

                <p><div align="right"><input class="hide" type="text" value="M/s. MSC ELECTRICALS" style="text-align:right"> </p>
        </div></td>
      </tr>
	 
    </table>
	<center>
	<div>
        <input type="button" id="savebtn" value="Save" style="height:40px; width:80px;margin-right: 10px;" >
        <input type="button" id="updatebtn" value="Edit" style="height:40px; width:80px;margin-right: 10px;" >
	<input type="button" id="printbtn" value="Print" style="height:40px; width:80px;" >
	</div>
	</center>
	
	</td>
  </tr>
</table>
        <button id="add">+</button>
    </body>
</html>
