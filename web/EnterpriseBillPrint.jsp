<%-- 
    Document   : BillPrint
    Created on : 28 Jul, 2020, 6:28:39 AM
    Author     : winayak
--%>

<%@page import="java.sql.DriverManager"%>
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
        <title>MSC Enterprise Bill Print</title>
        <script>
            $(document).ready(function(){
                var id = <%=request.getParameter("id")%>;   
                function data(){                    
                    var offset = <%=request.getParameter("offset")%>;
                    console.log(id);
                    $("#edit_id").val(id);
                    $("#save").hide();
                    $("#save_edit").show();
                    $("#dropdown").remove(); 
                    $.ajax({
                        type:"get",
                        url:"LimitBillEnterpriseDetails",
                        data:{type:"get",id:id,offset:offset},
                        success:function(list){   
                            if(list!=0){
                                var list = JSON.parse(list);

                                console.log(list[0].buyer);
                                $.ajax({
                                    url:"Address",
                                    type:"get",
                                    data:{id:list[0].buyer},
                                    success:function(obj){
                                        var json = JSON.parse(obj);
                                       $("#baddr").html(json.add);
                                    },
                                    error:function(res){
                                        alert(res);
                                    },
                                });
                                $.ajax({
                                    url:"Address",
                                    type:"get",
                                    data:{id:list[0].consignee},
                                    success:function(obj){
                                        var json = JSON.parse(obj);
                                       $("#caddr").html(json.add);
                                    },
                                    error:function(res){
                                        alert(res);
                                    },
                                });
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
                                $("#total_cgst").val(list[0].tcgst.toFixed(2));
                                $("#total_sgst").val(list[0].tsgst.toFixed(2));
                                $("#total_igst").val(list[0].tigst);
                                $("#cgst_display").html(list[0].tcgst.toFixed(2));
                                $("#sgst_display").html(list[0].tsgst.toFixed(2));
                                $("#igst_display").html(list[0].tigst);
                                $("#amt_words").val(list[0].amtwords);
                                $("#reverse_charge").val(list[0].rcharge);
                                $("#total_tax").val((list[0].tcgst+list[0].tsgst).toFixed(2));                                                                
                                $("#gst_display").html((list[0].tcgst+list[0].tsgst).toFixed(2));
                                $("#before_tax").val(list[0].betax);
                                $("#before_tax_display").html(list[0].betax);
                                
                                if(list[0].tc==""){
                                    $("#t_c").val("GST DECLARATION ANY ADDITIONAL INPUT TAX CREDIT (ITC) BENEFIT,\nIF BECOME AVLIABLE TO US,\nTHE SAME  SHALL BE PASSED ON PURCHASER WITHOUT ANY UNDUE DELAY");                                    
                                }
                                else{
                                    $("#t_c").val(list[0].tc);
                                }
                                $(".items").remove();
                                var length = list[1].length;
                                var total_value = 0;
                                var before_tax = 0;
                                var after_tax = 0;
                                var total_amt = 0;
                                var sum = 0;
                                for(var i = 0; i < list[1].length; i++) {
                                    var obj2 = list[1][i];
                                    var value = obj2.qty*obj2.rate*obj2.tax/100;
                                    var amt = obj2.qty*obj2.rate;
                                    before_tax = before_tax+obj2.qty*obj2.rate-obj2.discount;
                                    total_amt = amt+total_amt;
                                    total_value = parseFloat(value+total_value);
                                    
                                    var total = (obj2.rate-obj2.discount)*obj2.qty+value;  
                                    sum = sum+total;
                                    $("#items_tbody").prepend('<tr class="items">'+
                                        '<td class="sno">'+parseInt(length+offset)+'</td>'+
                                        '<td>'+
                                            '<p style="margin: 0;width:300px;word-break:break-all;">'+obj2.name+'</p>'+
                                        '</td>'+
                                        '<td align="right">'+
                                         '   <input type="text" class="item_code" value='+obj2.code+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="text" class="item_unit" value="'+obj2.uom+'">'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="text" class="item_qty" value='+obj2.qty+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="item_rate" value='+obj2.rate.toFixed(2)+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="gst" value='+obj2.tax.toFixed(2)+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="amount" value='+amt.toFixed(2)+' >'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="discount" value='+obj2.discount+'>'+
                                        '</td>'+
                                        '<td align="right">'+
                                            '<input type="number" class="tax_value" value='+value.toFixed(2)+' >'+
                                        '</td>'+
                                        
                                        '<td align="right">'+
                                         '   <input type="number" class="cgst_rate" value='+(obj2.tax/2).toFixed(2)+' >'+
                                        '</td>               '+                         
                                        '<td align="right">'+
                                         '   <input type="number" class="cgst_amount" value='+(value/2).toFixed(2)+' >'+
                                        '</td>'+
                                        
                                        '<td align="right">'+
                                        '    <input type="number" class="sgst_rate" value='+(obj2.tax/2).toFixed(2)+' >'+
                                        '</td>'+
                                        '<td align="right">'+
                                        '    <input type="number" class="sgst_amount" value='+(value/2).toFixed(2)+' >'+
                                        '</td>'+
                                        
                                        
                                        '<td align="right">'+
                                        '    <input type="text" class="igst_rate" >'+
                                        '</td>'+
                                        '<td align="right">'+
                                        '    <input type="text" class="igst_amount" >'+
                                       ' </td>'+
                                        '<td align="right">'+
                                            '<input type="text" class="total_amt" value='+total+' >'+
                                        '</td>'+
                                      '</tr>');
                                    length--;
                                }
                                $("#after_tax").val(sum.toFixed(2));
                                $("#after_tax_display").html(sum.toFixed(2));
                                
                                var count = list[2].count;
                                var count2 = parseInt(count/7);
                                if(count%7!=0)
                                    count2++;
                                
                                $("#page").empty();
                                for(i=0;i<count2;i++){
                                    $("#page").append('<option value="'+i*7+'">'+parseInt(i+1)+'/'+count2+'</option>');
                                }
                                $("#page").val(offset);
                                if(offset/7+1!=count2){
                                    $("#amt_words").val("");
                                    $("#total_tax").val("");
                                    $("#total_cgst").val("");

                                    $("#total_sgst").val("");
                                    $("#cgst_display").html("");
                                    $("#sgst_display").html("");
                                    $("#igst_display").html("");
                                    $("#total_cgst").val("");
                                    $("#reverse_charge").val("");
                                    $("#gst_display").html("");
                                    $("#before_tax").val("");
                                    $("#before_tax_display").html("");
                                    $("#after_tax").val("");
                                    $("#after_tax_display").html("");
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
                    var type = <%=request.getParameter("type")%>;
                    if(type=="o"){
                        $("#odt").html("[<i class=\'fa fa-check\'></i>] ORIGINAL for Recipient<br>[ ] DUPLICATE for Transporter<br>[ ] TRIPLICATE for Supplier<br>");                    
                    }
                    else if(type=="d"){
                        $("#odt").html("[ ] ORIGINAL for Recipient<br>[ <i class=\'fa fa-check\'></i>] DUPLICATE for Transporter<br>[ ] TRIPLICATE for Supplier<br>");                    

                    }
                    else if(type=="t"){
                        $("#odt").html("[] ORIGINAL for Recipient<br>[ ] DUPLICATE for Transporter<br>[<i class=\'fa fa-check\'></i> ] TRIPLICATE for Supplier<br>");                    

                    }
                }

                    $("#printbtn").click(function(){
                        $("#printbtn").hide();
                        if(!window.print()){
                            $("#printbtn").show();
                        }
                    });
                    data();
                    $("#page").change(function(){
                        var offset = $(this).val();
                        window.location.replace("EnterpriseBillPrint.jsp?offset="+offset+"&id="+id+"&type=\'o\'");                    

                    });

                });

        </script>
        <style>
            body{
                height: auto;
                overflow: auto;
            }
            #page{
                width: 50px;
            }
            #amt_words{
                text-align: center;
            }
            input,select,textarea{
                border: 0;
                margin: 0;
                -webkit-appearance: none;
                -moz-appearance: none;
                padding: 0;
                appearance: none;
                min-height: auto;                
            }
            #add_row{
                display: none;
            }
            #printbtn{
                border: 1px solid #cacaca;
                border-radius: 5px;
                margin-bottom: 30px;
                outline: 0;
                padding: 10px;
                background: #ffffff;
                min-height: 40px;
            }
            #printbtn:focus{
                border : 1px solid #7579de;
            }
            .fa.fa-check{
                color: black;
            }
            textarea{                
                margin: 0px;
                width: 400px;
                height: 120px;
            }
            .items input{
                text-align: center;
                width: 60px;
                display: block;
                margin: auto;
            }
            .items{
                vertical-align: text-top;
            }
            #tot input{
                text-align: center;
            }
            .total_amt{
                text-align: right!important;
                width: 100px;
            }
            #after_tax{
                text-align: right!important;
            }
        </style>
    </head>
    <body>
        <div >
            
        
        <div style="width:1400px;margin:auto">
                    <table width="100%" border="0">
                        <tr>
                        
                            <td width="20%"><input id="edit_id" type="text" hidden ></td>
                            <td width="60%" align="center">
                            <b align="center" style="font-size:22px;"><input type="text" value="M/S. MSC ENTERPRISE" style="    font-size: 22px;text-align: center;font-weight: bold;"> </b><br />
                            <div align="center" style="font-size:18px;"><input type="text" value="Dhaligaon, New Bongaigaon, Dist-Bongaigaon, Assam - 783381" style="    font-size: 18px;text-align: center;"></div>
                            <div align="center" style="margin:5px;font-size:18px;"><strong><input type="text" value="GSTIN: 18BFFPP035P1ZX/PAN No: BFFPP4035" style="    font-size: 18px;text-align: center;"> </strong></div>
                            </td>
                             <td width="20%" id="odt">
                                [ ] ORIGINAL for Recipient<br>
                                [ ] DUPLICATE for Transporter<br>
                                [ ] TRIPLICATE for Supplier<br>
                            </td>
                        </tr>
                    </table>

                </div>
                            <div style="width:1400px;margin:auto">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td style="border:solid 1px black;">
                                        <table width="100%" border="0">
                                            <tr>
                                              <td width="25%"></td>
                                              <td width="50%"><div align="center" class="style2">TAX INVOICE</div></td>
                                                <td width="25%" align="right"><b>Page: </b>
                                                  <select id="page">
                                                      <option val=""></option>
                                                  </select></td>
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
                                                  <td><input type="text"  value="18BFFPP035P1ZX" required="required" style="font-size: 12px;"></td>
                                                  <td><strong>P.O /Order No </strong></td>
                                                  <td> <select id="po_id" required="required">
                                                          <option value=""></option>
                                                      <%
                                                            String query3 = "select * from purchase_order";
                                                            PreparedStatement ps3 = con.prepareStatement(query3);  
                                                            try{
                                                                ResultSet rs3 = ps3.executeQuery();
                                                                while(rs3.next()){                
                                                                    out.println("<option value=\""+rs3.getString("id")+"\">"+rs3.getString("po_no")+"</option>");
                                                                }                
                                                            }
                                                            catch(Exception e){
                                                                out.println(e.getMessage());                    
                                                            }                             
                                                        %>
                                                      </select>
                                                  </td>
                                                  <td><strong>Date </strong></td>
                                                  <td><input type="date" id="po_date" required="required"></td>
                                                </tr>
                                                <tr>
                                                <td valign="top">Address</td>
                                                <td valign="top"><span id="baddr"></span></td>
                                                <td valign="top">State</td>
                                                <td valign="top"> Assam</td>
                                                <td valign="top"><strong>Challan No </strong></td>
                                                <td valign="top"> <input type="text" id="table_challanno"></td>
                                                <td valign="top"><strong>Date </strong></td>
                                                <td valign="top"><input type="date" id="challan_date" required="required"></td>
                                              </tr>
                                              <tr>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                
                                                <td valign="top">State Code</td>
                                                <td valign="top"> 18</td>
                                                <td valign="top"><strong>State</strong></td>
                                                <td valign="top"><input type="text" id="state" required="required"></td>
                                                <td valign="top"><strong>State Code </strong> </td>
                                                <td valign="top"><input type="text" id="state_code" required="required"></td>
                                                
                                                
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
                                                <td><span id="add_row">Row +<span></td>
<!--                                                <td><span id="man_disp">Manual Calculation</span><input type="checkbox" id="man_calc"></td>-->
                                              </tr>
                                              <tr>
                                                <td valign="top">Address</td>
                                                <td valign="top"  colspan="4"><span id="caddr"></span></td>
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
                                    <thead style="text-align: center;vertical-align: text-bottom;">
                                      <tr>
                                        <td rowspan="2">SN</td>
                                        <td rowspan="2" style="text-align: left"><span >Description of Product/Service</span></td>
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
                                            
                                      </tr>
                                      
                                      <tr id="tot">
                                        <td colspan="7"><div align="right" ><strong>Total : </strong></div></td>
                                        <td><div align="center"><input type="text" id="before_tax"></div></td>
                                                <td><div align="center"><input type="text" id="total_discount" ></div></td>
                                        <td><div align="center"><input type="text" id="total_tax" ></div></td>
                                        <td>&nbsp;</td>
                                        <td><div align="center"><input type="text" id="total_cgst" ></div></td>
                                        <td>&nbsp;</td>
                                        <td><div align="center"><input type="text" id="total_sgst" ></div></td>
                                        <td>&nbsp;</td>
                                        <td><div align="center"><input type="text" id="total_igst" ></div></td>
                                        <td><div align="right"><input type="text" id="after_tax" ></div></td>
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
                                        <td colspan="2"><div align="right"><input type="text" id="reverse_charge"></div></td>
                                      </tr>      <tr>
                                        <td colspan="18" style="padding:0px"><table width="100%" border="0">
                                          <tr>
                                            <td width="33%" valign="top" style="border-right:solid 1px black"><strong>Term &amp; Conditions :</strong><br />
                                                        <div>
                                                            <textarea id="t_c"></textarea>
                                                        </div>			</td>
                                            <td width="33%" valign="top" style="border-right:solid 1px black">
                                                        <u>BANK DETAILS:</u><BR />
                                                        <div style="line-height:18px;">
                                            <B>
                                                <input type="text" value="ICICI BANK"><br />
                                                        <input type="text" value="A/C No: 070805000936"><BR />
                                                          <input type="text" value="MICR Code: 783229002"><br />
                                                         <input type="text" value="IFSC Code: ICIC0000708"><BR />
                                                         <input type="text" value="PAN No: BFFPP4035"><br />
                                                        <input type="text" value="BONGAIGAON, ASSAM - 783380">			</B>			</div>              </td>
                                            <td width="33%" valign="top"><p align="center">Certified that the particulars given above are true and correct.</p>
                                              <p align="center"><em>For</em> <strong> <input type="text" value="M/S MSC ENTERPRISE" style="text-align:center;">	</strong></p>
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
                                                	<center><input type="button" name="printbtn" id="printbtn" value="Print" style="height:30px; width:80px;" "></center>

                    </div>
            </div>
    </body>
</html>
