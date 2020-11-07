<%-- 
    Document   : MSElectricalsMain.jsp
    Created on : 5 Jul, 2020, 6:03:10 PM
    Author     : winayak
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
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
        <script src="js/index.js"></script>
        <title>MSC Electricals Impress GST Bills</title>
        <style>
            .tabs:nth-child(1),.tabs2:nth-child(1){
                color: #7579de!important;
                font-weight: bold;
                border-radius: 5px;
            }
            #modal_content{
                width: 100%;
                height: 100vh;
                overflow-y: scroll;
            }
            #modal_content>div{
                padding: 10px;
                margin: auto;                
            }
            #modal_content input,#modal_content select{
                width: 200px;
                border-radius: 0px;
                outline: 0;
                padding: 5px;
                margin: 0;
                background: #ffffff;
                min-height: 30px;
            }
            textarea{    
                border: 1px solid #cacaca;
                border-radius: 5px;
                outline: 0;
                padding: 10px;
                background: #ffffff;
            }
            textarea:focus{
                border: 1px solid #7579de;
            }
            #modal_content::-webkit-scrollbar {
                width: 10px;
            }

            /* Track */
            #modal_content::-webkit-scrollbar-track {
              background: #f1f1f1;
            }

            /* Handle */
            #modal_content::-webkit-scrollbar-thumb {
              background: #dadada;
            }

            /* Handle on hover */
            #modal_content::-webkit-scrollbar-thumb:hover {
              background: #999;
            }
            #modal_content button{
                width: 200px;
            }
            #after_tax,#before_tax,#total_cgst,#total_sgst,#total_igst,#total_discount,#total_tax,.item_code,.item_qty,.item_rate,.item_unit,.gst,.amount,.discount,.tax_value,.igst_amount,.igst_rate,.cgst_amount,.cgst_rate,.sgst_amount,.sgst_rate,.total_amt{
                width: 100%!important;
                min-width: 80px;
            }
            #man_disp{
                float: left;
                margin-top: 10px;
            }
            #man_calc{
                width: 50px!important;
            }
            #add_row{
                float: right;
                width: 30px!important;
                border-radius: 30px;
                height: 30px;
                padding: 5px;
                margin-right: 10px;
            }
            table p{
                font-weight: bold;
                letter-spacing: 1.5px;
                text-transform: uppercase;
            }
            #main_content tbody tr td:nth-child(4),#main_content thead tr th:nth-child(4),#main_content tbody tr td:nth-child(5),#main_content thead tr th:nth-child(5){
                text-align: center;
            }
            #save_edit{
                display: none;
            }
            #amt_words{
                width: 90%!important;
            }
        </style>
        <script>
            $(document).ready(function(){                
                $(document).on("click", function(event){
                    if(!$(event.target).closest(".fa.fa-close") && !$(event.target).closest("#confirm2 div").length){
                        $("#confirm2").remove(); 
                    }
                });
                $(document).on("click", function(event){
                    if(!$(event.target).closest(".fa.fa-trash").length && !$(event.target).closest("#modal_content2").length && !$(event.target).closest("#modal_content1").length && !$(event.target).closest("#modal_content").length && !$(event.target).closest("#modal_display").length&&!$(event.target).closest("#dropdown").length&&!$(event.target).closest("table span").length ){
                        $("#modal").hide(); 
                        $("#modal_edit").hide(); 
                        $("#modal_item").hide(); 
                        $("#dropdown").remove(); 
                    }
                });
                item_display();
                $("#add_row").click(function(){
                    $("#items_tbody").prepend('<tr class="items">'+
                                        '<td class="sno">'+parseInt($(".items").length+1)+'</td>'+
                                        '<td>'+
                                            '<input type="text" class="item_name">'+
                                        '</td>'+
                                        '<td align="right">'+
                                         '   <input type="number" class="item_code">'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="text" class="item_unit">'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="item_qty">'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="item_rate">'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="gst">'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="amount" disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="discount">'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="tax_value" disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                         '   <input type="number" class="cgst_amount" disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                         '   <input type="number" class="cgst_rate" disabled>'+
                                        '</td>               '+                         
                                        '<td align="right">'+
                                        '    <input type="number" class="sgst_rate" disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                        '    <input type="number" class="sgst_amount" disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                        '    <input type="number" class="igst_rate" disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                        '    <input type="number" class="igst_amount" disabled>'+
                                       ' </td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="total_amt" disabled>'+
                                        '</td>'+
                                        '<td align="center">'+
                                            '<span><i class="fa fa-trash"></i></span>'+
                                        '</td>'+
                                      '</tr>');
                              sno();
                });
                function sno(){
                    var count = 0;
                    $(".sno").each(function(){
                        count++;
                        $(this).html(count);
                        
                    })
                }
                $(document).on("click",".fa.fa-trash",function(){
                    $(this).parent().parent().parent().remove();
                    sno();
                    total();
                });
               
               $("#save").click(function(){
                   var buyer = $("#buyer").val();
                   var consignee = $("#consignee").val();
                   var billno = $("#table_billno").val();
                   var poid = $("#po_id").val();
                   var state = $("#state").val();
                   var mod = $("#mod").val();
                   var v_no = $("#v_no").val();
                   var state_code = $("#state_code").val();
                   var in_date = $("#invoice_date").val();
                   var po_date = $("#po_date").val();
                   var ch_date = $("#challan_date").val();
                   var be_tax = $("#before_tax").val();
                   var discount = $("#total_discount").val();
                   var af_tax = $("#after_tax").val()-discount;
                   var total_cgst = $("#total_cgst").val();
                   var total_sgst = $("#total_sgst").val();
                   var total_igst = $("#total_igst").val();
                   var amt_words = $("#amt_words").val();
                   var re_charge = $("#reverse_charge").val();
                   var t_c = $("#t_c").val();
                   $("#empty_after").remove();
                   var flag = 0;
                   $("#modal_content input").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $("#modal_content select").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".item_name").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".item_qty").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".item_code").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".item_rate").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".gst").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".amount").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".discount").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".tax_value").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".total_amt").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                    setTimeout(function(){
                        $("#modal_content input").attr("placeholder","");
                    },2000);
                   if(flag == 0){                      
                      var list = [];                      
                      $(".items").each(function(){
                        var obj = {};
                        obj.name = $(this).find(".item_name").val();
                        obj.code = $(this).find(".item_code").val();
                        obj.uom = $(this).find(".item_unit").val();
                        obj.qty = $(this).find(".item_qty").val();
                        obj.rate = $(this).find(".item_rate").val();
                        obj.gst = $(this).find(".gst").val();
                        obj.amount = $(this).find(".amount").val();
                        if($(this).find(".discount").val()=="")
                          obj.discount = 0;
                        else
                            obj.discount = $(this).find(".discount").val();
                        obj.tval = $(this).find(".tax_value").val();
                        if($(this).find(".cgst_amount").val()=="")
                          obj.camt = 0;
                        else
                            obj.camt = $(this).find(".cgst_amount").val();
                        if($(this).find(".sgst_amount").val()=="")
                          obj.samt = 0;
                        else
                            obj.samt = $(this).find(".sgst_amount").val();
                        if($(this).find(".sgst_rate").val()=="")
                          obj.srate = 0;
                        else
                            obj.srate = $(this).find(".sgst_rate").val();
                        if($(this).find(".cgst_rate").val()=="")
                          obj.crate = 0;
                        else
                            obj.crate = $(this).find(".cgst_rate").val();
                        if($(this).find(".igst_amount").val()=="")
                          obj.iamt = 0;
                        else
                            obj.iamt = $(this).find(".igst_amount").val();
                        if($(this).find(".igst_rate").val()=="")
                          obj.irate = 0;
                        else
                            obj.irate = $(this).find(".igst_rate").val();
                    
                        obj.tamt = $(this).find(".total_amt").val();
                        list.push(obj);
                        console.log(list);
                      });
                      var json = JSON.stringify(list);
                      console.log(json);
                      $.ajax({
                         type:"Post",
                         url:"ImpressBill",
                         data:{json:json,buyer:buyer,consignee:consignee,billno:billno,poid:poid,state:state,state_code:state_code,v_no:v_no,mod:mod,in_date:in_date,po_date:po_date,ch_date:ch_date,total_cgst:total_cgst,total_sgst:total_sgst,total_igst:total_igst,amt_words:amt_words,re_charge:re_charge,t_c:t_c,af_tax:af_tax,be_tax:be_tax,type:"add"},
                         success:function(res){
                            item_display();
                            alert(res);
                            $("#modal").hide();
                         },
                         error: function (res) {
                             alert(res);
                         }
                      }); 
                   }
               });
                $(document).on("click","#main_content table span",function(){
                     $("#dropdown").remove(); 
                     $(this).parent().css("position","relative");
                     $(this).after("<div id=\'dropdown\'><a id=\"edit\"><i class=\"fa fa-edit\"></i></a><a id=\"delete\"><i class=\"fa fa-trash\"></i></a><a id=\"ori_bill\">Original</a></div>");
                 });                
                 $("#modal_display").click(function(){
                     $("#dropdown").remove();

                     $("#modal_content select").val("");
                     $("#modal_content input").val("");
                     $("#modal_content textarea").val("");
                     $(".items").remove();
                     $("#save").show();
                    $("#save_edit").hide();
                    $.ajax({
                        type:"get",
                        url:"ImpressBillNo",
                        success:function(count){
                             var d = new Date();
                             var last = d.getFullYear()+1;
                             var billyear = d.getFullYear().toString().substr(2,2)+"-"+last.toString().substr(2,2);
                             var str = count;
                             var billno = "MSCE/IM/"+str.replace(/\s/g, '')+"/"+billyear
                            $("#table_billno").val(billno);
                            $("#table_challanno").val(billno);
                            $("#state").val("Assam");
                            $("#state_code").val(18);
                        },
                        error:function(res){
                            alert(res);
                        }
                    }) ;
                 });
                 $(document).on("click",".fa.fa-close",function(){
                    var id = $(this).next().val();
                    var name = $(this).parent().parent().children("td:nth-child(2)").html();
                    var text = "Are you sure you want to set "+name+" to paid";
                    console.log(id);
                    $("#dropdown").remove(); 
                    confirm2( text,function(){
                        $("#confirm2").remove();
                         $.ajax({
                            type:"Post",
                            url:"ImpressBillPaid",
                            data:{"id":id},
                            success:function(res){
                                if(res==1){
                                    item_display();
                                }
                                else{
                                    alert(res);
                                }
                            },
                            error: function (res) {
                                alert(res);
                            }
                        });  
                    },function(){
                        $("#confirm2").remove();
                    });

                 });
                 $(document).on("click","#delete",function(){

                    var id = $(this).parent().next().val(); 
                    var name = $(this).parent().parent().parent().children("td:nth-child(2)").html();
                    var text = "Are you sure you want to delete "+name;
                    $("#dropdown").remove(); 
                    confirm2( text,function(){
                        $("#confirm2").remove();
                         $.ajax({
                            type:"Post",
                            url:"ImpressBill",
                            data:{id:id,type:"delete"},
                            success:function(res){
                                if(res==1){
                                    item_display();
                                }
                                else{
                                    alert(res);
                                }
                            },
                            error: function (res) {
                                alert(res);
                            }
                        });  
                    },function(){
                        $("#confirm2").remove();
                    });

                });
                $(document).on("click","#edit",function(){
                    $("#modal").show(); 
                    var id = $(this).parent().next(".id").val(); 
                    $("#edit_id").val(id);
                    $("#save").hide();
                    $("#save_edit").show();
                    $("#dropdown").remove(); 
                    $.ajax({
                        type:"get",
                        url:"ImpressBillDetails",
                        data:{type:"get",id:id},
                        success:function(list){   
                            if(list!=0){
                                var list = JSON.parse(list);
                                $("#id").val(list[0].bill_id);
                                $("#buyer").val(list[0].buyer);
                                $("#consignee").val(list[0].consignee);
                                $("#table_billno").val(list[0].billno);
                                $("#table_challanno").val(list[0].billno);
                                $("#po_id").val(list[0].pono);
                                $("#state").val(list[0].state);
                                $("#mod").val(list[0].mod);
                                $("#v_no").val(list[0].vno);
                                $("#state_code").val(list[0].scode);
                                $("#invoice_date").val(list[0].billdate);
                                $("#po_date").val(list[0].podate);
                                $("#challan_date").val(list[0].challandate);
                                $("#before_tax").val(list[0].betax);
                                $("#total_discount").val(list[0].tdisc);
                                $("#after_tax").val(list[0].aftax);
                                $("#total_cgst").val(list[0].tcgst);
                                $("#total_sgst").val(list[0].tsgst);
                                $("#total_igst").val(list[0].tigst);
                                $("#cgst_display").html(list[0].tcgst);
                                $("#sgst_display").html(list[0].tsgst);
                                $("#igst_display").html(list[0].tigst);
                                $("#amt_words").val(list[0].amtwords);
                                $("#reverse_charge").val(list[0].rcharge);
                                $("#t_c").val(list[0].tc);
                                $(".items").remove();
                                var length = list[1].length;
                                var total_value = 0;
                                var before_tax = 0;
                                var after_tax = 0;
                                var total_amt = 0;
                                for(var i = 0; i < list[1].length; i++) {
                                    var obj2 = list[1][i];
                                    var value = parseFloat(obj2.qty*obj2.rate*obj2.tax/100);
                                    var amt = (obj2.qty*obj2.rate).toFixed(2);
                                    before_tax = parseFloat(before_tax)+parseFloat(amt)-obj2.discount;
                                    total_amt = parseFloat(amt)+parseFloat(total_amt);
                                    total_value = parseFloat(value)+parseFloat(total_value);
                                    
                                    var total = (parseFloat(obj2.rate-obj2.discount)*obj2.qty+value).toFixed(2);  
                                    $("#items_tbody").prepend('<tr class="items">'+
                                        '<td class="sno">'+length+'</td>'+
                                        '<td>'+
                                            '<input type="text" class="item_name" value="'+obj2.name+'">'+
                                        '</td>'+
                                        '<td align="right">'+
                                         '   <input type="number" class="item_code" value='+obj2.code+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="text" class="item_unit" value="'+obj2.uom+'">'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="item_qty" value='+obj2.qty+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="item_rate" value='+obj2.rate+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="gst" value='+obj2.tax+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="amount" value='+amt+' disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="discount" value='+obj2.discount+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="tax_value" value='+value+' disabled>'+
                                        '</td>'+
                                                 '<td align="right">'+
                                         '   <input type="number" class="cgst_rate" value='+obj2.tax/2+' disabled>'+
                                        '</td>               '+                         
                                        '<td align="right">'+
                                         '   <input type="number" class="cgst_amount" value='+value/2+' disabled>'+
                                        '</td>'+
                                        
                                        '<td align="right">'+
                                        '    <input type="number" class="sgst_rate" value='+obj2.tax/2+' disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                        '    <input type="number" class="sgst_amount" value='+value/2+' disabled>'+
                                        '</td>'+
                                        
                                        
                                        '<td align="right">'+
                                        '    <input type="number" class="igst_rate" disabled>'+
                                        '</td>'+
                                        '<td align="right">'+
                                        '    <input type="number" class="igst_amount" disabled>'+
                                       ' </td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="total_amt" value='+total+' disabled>'+
                                        '</td>'+
                                        '<td align="center">'+
                                            '<span><i class="fa fa-trash"></i></span>'+
                                        '</td>'+
                                      '</tr>');
                                    length--;
                                }
                                after_tax = parseFloat(before_tax+total_value);
                                $("#total_tax").val(total_value.toFixed(2));
                                $("#total_cgst").val((total_value/2).toFixed(2));
                                
                                $("#total_sgst").val((total_value/2).toFixed(2));
                                $("#cgst_display").html((total_value/2).toFixed(2));
                                $("#sgst_display").html((total_value/2).toFixed(2));
                                $("#total_cgst").val((total_value/2).toFixed(2));
                                $("#gst_display").html(total_value.toFixed(2));
                                $("#before_tax").val(total_amt);
                                $("#before_tax_display").html(before_tax.toFixed(2));
                               var word = price_in_words(Math.floor(after_tax));
                                var dec = after_tax.toFixed(2).toString().split(".");
                                var dec = dec[1];
                                var word2 = price_in_words(dec);
                                if(dec!=0){
                                    var word2 = price_in_words(dec);
                                    var final =  "Rupees"+word+'and'+word2+'Paise Only';
                                }
                                else{
                                    var final =  "Rupees"+word+' Only';
                                }
                                $("#amt_words").val(final);
                                $("#after_tax").val(after_tax.toFixed(2));
                                $("#after_tax_display").html(after_tax.toFixed(2));
                             }
                             else{
                                 window.location.replace("MSCElectricalsLogin.jsp");
                             }
                        },
                        error: function (res) {
                            alert(res);
                        }     
                    });
                });
             $("#save_edit").click(function(){
                    var id = $("#edit_id").val();
                   var buyer = $("#buyer").val();
                   var consignee = $("#consignee").val();
                   var poid = $("#po_id").val();
                   var state = $("#state").val();
                   var mod = $("#mod").val();
                   var v_no = $("#v_no").val();
                   var state_code = $("#state_code").val();
                   var in_date = $("#invoice_date").val();
                   var po_date = $("#po_date").val();
                   var ch_date = $("#challan_date").val();
                   var be_tax = $("#before_tax_display").html();
                   var discount = $("#total_discount").val();
                   var af_tax = $("#after_tax").val()-discount;
                   var total_cgst = $("#total_cgst").val();
                   var total_sgst = $("#total_sgst").val();
                   var total_igst = $("#total_igst").val();
                   var amt_words = $("#amt_words").val();
                   var re_charge = $("#reverse_charge").val();
                   var t_c = $("#t_c").val();
                   $("#empty_after").remove();
                   var flag = 0;
                   $("#modal_content input").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $("#modal_content select").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".item_name").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".item_qty").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".item_code").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".item_rate").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".gst").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".amount").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".discount").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".tax_value").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                   $(".total_amt").each(function(){
                      if($(this).val()=="" && $(this).prop("required")){
                          $(this).focus();
                          $(this).attr("placeholder","Required!");
                          flag = 1;
                          return false;
                      } 
                   });
                    setTimeout(function(){
                        $("#modal_content input").attr("placeholder","");
                    },2000);
                   if(flag == 0){                      
                      var list = [];                      
                      $(".items").each(function(){
                        var obj = {};
                        obj.name = $(this).find(".item_name").val();
                        obj.code = $(this).find(".item_code").val();
                        obj.uom = $(this).find(".item_unit").val();
                        obj.qty = $(this).find(".item_qty").val();
                        obj.rate = $(this).find(".item_rate").val();
                        obj.gst = $(this).find(".gst").val();
                        obj.amount = $(this).find(".amount").val();
                        if($(this).find(".discount").val()=="")
                          obj.discount = 0;
                        else
                            obj.discount = $(this).find(".discount").val();
                        obj.tval = $(this).find(".tax_value").val();
                        if($(this).find(".cgst_amount").val()=="")
                          obj.camt = 0;
                        else
                            obj.camt = $(this).find(".cgst_amount").val();
                        if($(this).find(".sgst_amount").val()=="")
                          obj.samt = 0;
                        else
                            obj.samt = $(this).find(".sgst_amount").val();
                        if($(this).find(".sgst_rate").val()=="")
                          obj.srate = 0;
                        else
                            obj.srate = $(this).find(".sgst_rate").val();
                        if($(this).find(".cgst_rate").val()=="")
                          obj.crate = 0;
                        else
                            obj.crate = $(this).find(".cgst_rate").val();
                        if($(this).find(".igst_amount").val()=="")
                          obj.iamt = 0;
                        else
                            obj.iamt = $(this).find(".igst_amount").val();
                        if($(this).find(".igst_rate").val()=="")
                          obj.irate = 0;
                        else
                            obj.irate = $(this).find(".igst_rate").val();
                    
                        obj.tamt = $(this).find(".total_amt").val();
                        list.push(obj);
                        console.log(list);
                      });
                      var json = JSON.stringify(list);
                      console.log(json);
                      $.ajax({
                         type:"Post",
                         url:"ImpressBill",
                         data:{id:id,json:json,buyer:buyer,consignee:consignee,poid:poid,state:state,state_code:state_code,v_no:v_no,mod:mod,in_date:in_date,po_date:po_date,ch_date:ch_date,total_cgst:total_cgst,total_sgst:total_sgst,total_igst:total_igst,amt_words:amt_words,re_charge:re_charge,t_c:t_c,af_tax:af_tax,be_tax:be_tax,type:"update"},
                         success:function(res){
                            item_display();
                            alert(res);
                            $("#modal").hide();
                         },
                         error: function (res) {
                             alert(res);
                         }
                      }); 
                   }
                }); 
               $(document).on("keyup",".item_qty",function(){
                   var tar = $(this);
                    calc(tar);    
                    
               }) ;
               $(document).on("keyup",".item_rate",function(){
                   var tar = $(this);
                    calc(tar);   
                    
               });
               $(document).on("keyup",".amount",function(){
                   var tar = $(this);
                    calc(tar);               
                    
               });
               $(document).on("keyup",".gst",function(){
                   var tar = $(this);
                    calc(tar);  
                    
               });
               $(document).on("keyup",".discount",function(){
                   var tar = $(this);
                    calc(tar);           
                  
               });
               $(document).on("click","#ori_bill",function(){
                    var id = $(this).parent().next().val(); 
                    var name = $(this).parent().parent().parent().children("td:nth-child(2)").html();
                    $("#dropdown").remove(); 
                    window.open("ImpressBillPrint.jsp?offset=0&id="+id+"&type=\'o\'");                    
                });

                $("#table_billno").keyup(function(){
                    var val = $(this).val();
                    $("#table_challanno").val(val);
                });
                
               
            });
           
        function calc(tar){
            var rate = tar.parent().parent().find(".item_rate").val();
            var tax = tar.parent().parent().find(".gst").val();
            var qty = tar.parent().parent().find(".item_qty").val();
            var discount = tar.parent().parent().find(".discount").val();
            if(rate==""){
                rate=0;
            }
            if(tax==""){
                tax=0;
            }
            if(qty==""){
                qty=0;
            }
            if(discount==""){
                discount=0;
            }
            rate =rate-discount;
            tar.parent().parent().find(".tax_value").val((qty*rate*tax/100).toFixed(2));
            tar.parent().parent().find(".amount").val((rate*qty).toFixed(2));
            tar.parent().parent().find(".total_amt").val((rate*qty+qty*rate*tax/100).toFixed(2)); 
            tar.parent().parent().find(".cgst_rate").val((tax/2).toFixed(2));
            tar.parent().parent().find(".cgst_amount").val((qty*rate*tax/100/2).toFixed(2));
            tar.parent().parent().find(".sgst_rate").val((tax/2).toFixed(2));
            tar.parent().parent().find(".sgst_amount").val((qty*rate*tax/100/2).toFixed(2));
            total();
        }
        function total(){
            var amount = 0;
            var tax_value = 0;            
            var total_discount = 0;
            var after_tax = 0;
            var cgst_amount = 0;
            var igst_amount = 0;
            var sgst_amount = 0;
            $(".items").each(function(){
                amount = amount+parseInt($(this).find(".amount").val()); 
                tax_value = tax_value+parseFloat($(this).find(".tax_value").val()); 
                total_discount = total_discount+parseFloat($(this).find(".discount").val()); 
                after_tax = after_tax+parseFloat($(this).find(".total_amt").val());
                cgst_amount = cgst_amount+parseFloat($(this).find(".cgst_amount").val());
                sgst_amount = sgst_amount+parseFloat($(this).find(".sgst_amount").val());

            });
           var word = price_in_words(Math.floor(after_tax));
            var dec = after_tax.toFixed(2).toString().split(".");
            var dec = dec[1];
            var word2 = price_in_words(dec);
            if(dec!=0){
                var word2 = price_in_words(dec);
                var final =  "Rupees"+word+'and'+word2+'Paise Only';
            }
            else{
                var final =  "Rupees"+word+' Only';
            }
            $("#amt_words").val(final);
            $("#before_tax").val((amount).toFixed(2));
            $("#before_tax_display").html((after_tax-tax_value).toFixed(2));
            $("#total_discount").val((total_discount).toFixed(2));
            $("#after_tax").val(after_tax.toFixed(2));
            $("#after_tax_display").html(after_tax.toFixed(2));
            $("#total_tax").val(tax_value.toFixed(2));
            $("#gst_display").html(tax_value.toFixed(2));
            $("#total_cgst").val((cgst_amount).toFixed(2));
            $("#cgst_display").html((cgst_amount).toFixed(2));
            $("#total_sgst").val((sgst_amount).toFixed(2));
            $("#sgst_display").html((sgst_amount).toFixed(2));
            
        }
        function item_display(){
            $.ajax({
            type:"get",
            url:"ImpressBill",
            data:{type:"get"},
            success:function(res){   
                if(res!=0){
                     var list = JSON.parse(res);
                     $("#main_content tbody").empty();
                     for(var i = 0; i < list.length; i++) {
                         var obj = list[i];
                         var paid = "";
                         if(obj.paid)
                             paid = '<i class="fa fa-check"></i><input type=\"number\" class=\"id\" value="'+obj.id+'" hidden disabled>';
                         else
                             paid = '<i class="fa fa-close"></i><input type=\"number\" class=\"id\" value="'+obj.id+'" hidden disabled>';
                         console.log(obj);
                         $("#main_content tbody").append("<tr><td>"+obj.sno+"</td><td>"+obj.billno+"</td><td>"+obj.billdate+"</td><td>"+paid+"</td><td><span><i class=\"fa fa-caret-down\"></i></span><input type=\"number\" class=\"id\" value="+obj.id+" hidden disabled></tr>");

                     }
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
     function price_in_words(price) {
        var sglDigit = ["Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"],
          dblDigit = ["Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"],
          tensPlace = ["", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"],
          handle_tens = function(dgt, prevDgt) {
            return 0 == dgt ? "" : " " + (1 == dgt ? dblDigit[prevDgt] : tensPlace[dgt])
          },
          handle_utlc = function(dgt, nxtDgt, denom) {
            return (0 != dgt && 1 != nxtDgt ? " " + sglDigit[dgt] : "") + (0 != nxtDgt || dgt > 0 ? " " + denom : "")
          };

        var str = "",
          digitIdx = 0,
          digit = 0,
          nxtDigit = 0,
          words = [];
        if (price += "", isNaN(parseInt(price))) str = "";
        else if (parseInt(price) > 0 && price.length <= 10) {
          for (digitIdx = price.length - 1; digitIdx >= 0; digitIdx--) switch (digit = price[digitIdx] - 0, nxtDigit = digitIdx > 0 ? price[digitIdx - 1] - 0 : 0, price.length - digitIdx - 1) {
            case 0:
              words.push(handle_utlc(digit, nxtDigit, ""));
              break;
            case 1:
              words.push(handle_tens(digit, price[digitIdx + 1]));
              break;
            case 2:
              words.push(0 != digit ? " " + sglDigit[digit] + " Hundred" + (0 != price[digitIdx + 1] && 0 != price[digitIdx + 2] ? " and" : "") : "");
              break;
            case 3:
              words.push(handle_utlc(digit, nxtDigit, "Thousand"));
              break;
            case 4:
              words.push(handle_tens(digit, price[digitIdx + 1]));
              break;
            case 5:
              words.push(handle_utlc(digit, nxtDigit, "Lakh"));
              break;
            case 6:
              words.push(handle_tens(digit, price[digitIdx + 1]));
              break;
            case 7:
              words.push(handle_utlc(digit, nxtDigit, "Crore"));
              break;
            case 8:
              words.push(handle_tens(digit, price[digitIdx + 1]));
              break;
            case 9:
              words.push(0 != digit ? " " + sglDigit[digit] + " Hundred" + (0 != price[digitIdx + 1] || 0 != price[digitIdx + 2] ? " and" : " Crore") : "")
          }
          str = words.reverse().join("");
        } else str = "";
        return str

      }
        </script>
    </head>
    <body>
        <%@include file="ImpressNav.jsp" %>
        <%@include file="ImpressSide.jsp" %>
        <div id="main_div">
            <div>
                <h2>GST Bill</h2>
                <span id="modal_display">New</span>
            </div>             
            <div id="search_div">
                <div class="search">
                    <input type="text" placeholder="Enter Bill No" id="main_input">
                    <span> <i class="fa fa-search" id="main_search"></i></span>
                </div>
<!--                <div class="search">
                    <input type="date" placeholder="From">
                </div>
                <div class="search">
                    <input type="date" placeholder="To">
                </div>         -->
            </div>
            <div id="main_content">
                <table>
                    <thead>
                        <tr>
                            <th>S.No</th>                            
                            <th>Bill No</th>
                            <th>Date</th>
                            <th>Paid</th>
                            <th>Options</th>
                        </tr>                            
                    </thead>
                    <tbody>
                           
                    </tbody>
                </table>
            </div>
        </div>    
        <div id="modal">
            <div id="modal_content">
                <div style="width:1200px;">
                    <table width="100%" border="0">
                        <tr>
                        
                            <td width="20%"><input id="edit_id" type="number" hidden disabled></td>
                            <td width="60%" align="center">
                            <b align="center" style="font-size:22px;">M/S. MSC </b><br />
                            <div align="center" style="font-size:18px;">Dolaigaon, New Bongaigaon, Dist-Bongaigaon, Assam - 783381</div>
                            <div align="center" style="margin:5px;font-size:18px;"><strong>GSTIN: 18ASRPC7468B1ZI / PAN No: ASRPC7468B</strong></div>
                            </td>
                             <td width="20%">
                                [ ] ORIGINAL for Recipient<br>
                                [ ] DUPLICATE for Transporter<br>
                                [ ] TRIPLICATE for Supplier<br>
                            </td>
                        </tr>
                    </table>

                </div>
                            <div>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td style="border:solid 1px black;">
                                        <table width="100%" border="0">
                                            <tr>
                                              <td width="25%"></td>
                                              <td width="50%"><div align="center" class="style2">TAX INVOICE</div></td>
<!--                                              <td width="25%" align="right"><b>Page: </b>1/1</td>-->
                                            <td width="25%"></td>
                                            </tr>

                                        </table>
                                    </tr>
                                    <tr>
                                        <td style="border:solid 1px black; border-bottom:none; border-top:none">
                                            <table width="100%" border="0" cellpadding="3">
                                                <tr>
                                                  <td width="6%">&nbsp;</td>
                                                  <td width="24%"><div align="right"><strong>DETAILS OF BUYER | </strong></div></td>
                                                  <td width="10%"><strong>BILLED TO </strong></td>
                                                  <td width="13%"><div align="right"></div></td>
                                                  <td width="11%"><strong>Invoice /Bill No </strong></td>
                                                  <td width="16%"><input type="text" id="table_billno"></td>
                                                  <td width="8%"><strong>Date </strong></td>
                                                  <td width="12%"><input type="date" id="invoice_date" required="required"></td>
                                                </tr>
                                                <tr>
                                                  <td>Name</td>
                                                  <td><select id="buyer" required="required"><option value=""></option><%
                                                        Class.forName("com.mysql.cj.jdbc.Driver");  
                                                         Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/MSCELECTRICALS?useSSL = false","root","NovoDB123#$");  
                                                        String query = "select * from buyer_consignee where type=?";
                                                        PreparedStatement ps = con.prepareStatement(query);  
                                                        ps.setString(1, "b");
                                                        try{
                                                            ResultSet rs = ps.executeQuery();
                                                            while(rs.next()){                
                                                                out.println("<option value=\""+rs.getString("id")+"\">"+rs.getString("name")+"</option>");
                                                            }                
                                                        }
                                                        catch(Exception e){
                                                            out.println(e.getMessage());                    
                                                        }                             
                                                    %>
                                                      </select>
                                                  </td>
                                                  <td>GSTIN No </td>
                                                  <td>: 18AAAGM0289C1ZI</td>
                                                  
                                                    
                                                  
                                                </tr>
                                                <tr>
                                                    <td valign="top"></td>
                                                    <td valign="top"></td>
<!--                                                <td valign="top">Address</td>
                                                <td valign="top">: N.F RAILWAY, NEW BONGAIGAON</td>-->
                                                <td valign="top">State</td>
                                                <td valign="top">: Assam</td>
                                                <td valign="top"><strong>Challan No </strong></td>
                                                <td valign="top"><input type="text" id="table_challanno" disabled></td>
                                                <td valign="top"><strong>Date </strong></td>
                                                <td valign="top"><input type="date" id="challan_date" required="required"></td>
                                              </tr>
                                              <tr>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                
                                                <td valign="top">State Code</td>
                                                <td valign="top">: 18</td>
                                                <td valign="top"><strong>State</strong></td>
                                                <td valign="top"><input type="text" id="state" required="required" value="Assam"></td>
                                                <td valign="top"><strong>State Code </strong> </td>
                                                <td valign="top"><input type="number" id="state_code" required="required" value="Assam"></td>
                                                
                                                
                                              </tr>
                                              <tr>
                                                <td>&nbsp;</td>
                                                <td><div align="right"><strong>DETAILS OF CONSIGNEE | </strong></div></td>
                                                <td><strong>SHIPPED TO</strong> </td>
                                                <td><div align="right"></div></td>
                                                <td><strong>Mode of Dispatch </strong></td>
                                                <td>
                                                    <select id="mod"><option value=""></option><%
                                                        String query4 = "select * from mode_of_dispatch";
                                                        PreparedStatement ps4 = con.prepareStatement(query4);  
                                                        try{
                                                            ResultSet rs4 = ps4.executeQuery();
                                                            while(rs4.next()){                
                                                                out.println("<option value=\""+rs4.getString("id")+"\">"+rs4.getString("name")+"</option>");
                                                            }                
                                                        }
                                                        catch(Exception e){
                                                            out.println(e.getMessage());                    
                                                        }                             
                                                    %>
                                                    </select>
                                                </td>
                                                <td><strong>Vehicle No </strong></td>
                                                <td><input type="text" id="v_no"></td>
                                              </tr>
                                              <tr>
                                                <td>Name</td>
                                                <td><select id="consignee" required="required"><option value=""></option><%
                                                    String query2 = "select * from buyer_consignee where type=?";
                                                    PreparedStatement ps2 = con.prepareStatement(query2);  
                                                    ps2.setString(1, "c");
                                                    try{
                                                        ResultSet rs2 = ps2.executeQuery();
                                                        while(rs2.next()){                
                                                            out.println("<option value=\""+rs2.getString("id")+"\">"+rs2.getString("name")+"</option>");
                                                        }                
                                                    }
                                                    catch(Exception e){
                                                        out.println(e.getMessage());                    
                                                    }                             
                                                    %></select></td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td></td>
                                                <td><button id="add_row">+</button></td>
<!--                                                <td><span id="man_disp">Manual Calculation</span><input type="checkbox" id="man_calc"></td>-->
                                              </tr>
                                              <tr>
<!--                                                <td valign="top">Address</td>
                                                <td valign="top" colspan="4">: N.F .RAILWAY ,NEW BONGAIGAON</td>-->
                                                    <td valign="top"></td>
                                                    <td valign="top"  colspan="4"></td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
 
                                            </table>                                
                                        </td>
                                    </tr>
                                    <tr>
                                    <td><table width="100%" border="1" cellpadding="3" id="parts" style="border-collapse:collapse; border:solid 1px black" >
                                    <thead>
                                      <tr>
                                        <td rowspan="2">SN</td>
                                        <td rowspan="2"><span >Description of Product/Service</span></td>
                                        <td rowspan="2"><div align="center" >HSN <br />
                                          SAC </div></td>
                                        <td rowspan="2"><div align="center" >UOM</div></td>
                                        <td rowspan="2"><div align="center" >Qty</div></td>
                                        <td rowspan="2"><div align="center" >Rate</div></td>
                                                <td rowspan="2"><div align="center" >GST<br />(%)</div></td>
                                        <td rowspan="2"><div align="center" >Amt</div></td>
                                                <td rowspan="2"><div align="center" >Disc</div></td>
                                        <td rowspan="2"><div align="center" >Taxable <br />Value </div></td>
                                        <td colspan="2"><div align="center" >CGST</div></td>
                                        <td colspan="2"><div align="center" >SGST</div></td>
                                        <td colspan="2"><div align="center" >IGST</div></td>
                                        <td rowspan="2"><div align="center" >Total</div></td>
                                        <td rowspan="2"><div align="center" >Delete</div></td>
                                      </tr>
                                      <tr>
                                        <td><div align="center" >Rate</div></td>
                                        <td><div align="center" >Amt</div></td>
                                        <td><div align="center" >Rate</div></td>
                                        <td><div align="center" >Amt</div></td>
                                        <td><div align="center" >Rate</div></td>
                                        <td><div align="center" >Amt</div></td>
                                       </tr>

                                      
                                    </thead>
                                    <tbody id="items_tbody">
                                        <tr class="items">
                                            <td class="sno">1</td>
                                            <td>
                                                <input type="text" class="item_name">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="item_code">
                                            </td>
                                            <td align="right">
                                                <input type="text" class="item_unit">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="item_qty">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="item_rate">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="gst">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="amount">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="discount">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="tax_value">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="cgst_amount">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="cgst_rate">
                                            </td>                                        
                                            <td align="right">
                                                <input type="number" class="sgst_rate">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="sgst_amount">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="igst_rate">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="igst_amount">
                                            </td>
                                            <td align="right">
                                                <input type="number" class="total_amt">
                                            </td>
                                            <td align="center">
                                                <span><i class="fa fa-trash"></i></span>
                                            </td>
                                      </tr>
                                      
                                      <tr>
                                        <td colspan="7"><div align="right" ><strong>Total : </strong></div></td>
                                        <td><div align="center"><input type="number" id="before_tax"></div></td>
                                                <td><div align="center"><input type="number" id="total_discount" disabled></div></td>
                                        <td><div align="center"><input type="number" id="total_tax" disabled></div></td>
                                        <td>&nbsp;</td>
                                        <td><div align="center"><input type="number" id="total_cgst" disabled></div></td>
                                        <td>&nbsp;</td>
                                        <td><div align="center"><input type="number" id="total_sgst" disabled></div></td>
                                        <td>&nbsp;</td>
                                        <td><div align="center"><input type="number" id="total_igst" disabled></div></td>
                                        <td><div align="right"><input type="number" id="after_tax" disabled></div></td>
                                        <td><div align="right"></td>
                                      </tr>
                                      <tr>
                                        <td colspan="9" rowspan="7" align="center" valign="top"><p><strong>Total Invoice Amount in Word:</strong> </p>
<!--                                          <p><strong>INDIAN RUPEES FOURTEEN THOUSAND NINE HUNDRED AND EIGHTY SIX ONLY</strong></p>-->
                                        
                                        <input type="text" id="amt_words">
                                        </td>

                                        <td colspan="7"><strong>Total Amount Before Tax </strong></td>
                                        <td colspan="2"><div align="right" id="before_tax_display"></div></td>
                                        </tr>
                                      <tr>
                                        <td colspan="7"><strong>Add : CGST </strong></td>
                                        <td colspan="2"><div align="right" id="cgst_display"></div></td>
                                      </tr>
                                      <tr>
                                        <td colspan="7"><strong>Add : SGST </strong></td>
                                        <td colspan="2"><div align="right" id="sgst_display"></div></td>
                                      </tr>
                                      <tr>
                                        <td colspan="7"><strong>Add : IGST </strong></td>
                                        <td colspan="2"><div align="right" id="igst_display"></div></td>
                                      </tr>
                                      <tr>
                                        <td colspan="7"><strong>Tax Amount : GST </strong></td>
                                        <td colspan="2"><div align="right" id="gst_display"></div></td>
                                      </tr>
                                      <tr>
                                        <td colspan="7"><strong>Total Amount After Tax </strong></td>
                                        <td colspan="2"><div align="right" id="after_tax_display"></div></td>
                                      </tr>
                                      <tr>
                                        <td colspan="7"><strong>GST Payable on Reverse Charge </strong></td>
                                        <td colspan="2"><div align="right"><input type="number" id="reverse_charge"></div></td>
                                      </tr>      <tr>
                                        <td colspan="18" style="padding:0px"><table width="100%" border="0">
                                          <tr>
                                            <td width="33%" valign="top" style="border-right:solid 1px black"><strong>Term &amp; Conditions :</strong><br />
                                                        <div>
                                                            <textarea id="t_c"></textarea>
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                            <br />
                                                        </div>			</td>
                                            <td width="33%" valign="top" style="border-right:solid 1px black">
                                                        <u>BANK DETAILS:</u><BR />
                                                        <div style="line-height:18px;">
                                            <B>
                                                        PUNJAB NATIONAL BANK<br />
                                                        A/C No: 1201002100019087<BR />
                                                        MICR Code: 783024002<br />
                                                        IFSC Code: PUNB0120100<BR />
                                                        PAN No: ASRPC7468B<br />
                                                        BONGAIGAON, ASSAM - 783380			</B>			</div>              </td>
                                            <td width="33%" valign="top"><p align="center">Certified that the particulars given above are true and correct.</p>
                                              <p align="center"><em>For</em> <strong>M/S MSC</strong></p>
                                              <p align="center" style="height:0px;">&nbsp;</p>
                                              <p align="center" style="margin-bottom:5px; margin-top:0px;">Authorised Signatory   </p></td>
                                          </tr>
                                          </tbody>
                                        </table></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                              <td>&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    <div style="text-align: center;">
                        <button id="save">Save</button>
                        <button id="save_edit">Save</button>
                        <button id="close">Close</button>
                    </div>
        </div>
    </body>
</html>
