<%-- 
    Document   : MSElectricalsMain.jsp
    Created on : 5 Jul, 2020, 6:03:10 PM
    Author     : winayak
--%>

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
        <title>MSC Electricals Purchase Order</title>       
        <style>
            .tabs:nth-child(3),.tabs2:nth-child(3){
                color: #7579de!important;
                font-weight: bold;
                border-radius: 5px;
            }
            #main_content tbody tr td:nth-child(7),#main_content thead tr th:nth-child(7),#modal_content1 tbody tr td:nth-child(7),#modal_content1 thead tr th:nth-child(7){
                text-align: center;
            }
        </style>
        <script>
            
            $(document).on("click", function(event){
                if(!$(event.target).closest(".fa.fa-trash").length && !$(event.target).closest("#modal_content2").length && !$(event.target).closest("#modal_content1").length && !$(event.target).closest("#modal_content").length && !$(event.target).closest("#modal_display").length&&!$(event.target).closest("#dropdown").length&&!$(event.target).closest("table span").length && !$(event.target).closest("#confirm2 div").length ){
                    $("#modal").hide(); 
                    $("#modal_edit").hide(); 
                    $("#modal_item").hide(); 
                    $("#dropdown").remove(); 
                    $("#confirm2").remove();         
                }
            });
            $(document).ready(function(){    
                $("#modal_content2 #close").click(function(){
                   $("#modal_item").hide(); 
                });
                item_display();
                $(document).on("click","#main_content table span",function(){
                    $("#dropdown").remove(); 
                    $(this).parent().css("position","relative");
                    $(this).after("<div id=\'dropdown\'><a id=\"items\">Items</a><a id=\"edit\"><i class=\"fa fa-edit\"></i></a><a id=\"delete\"><i class=\"fa fa-trash\"></i></a></div>")
                });
                $(document).on("click","#modal_content1 table span",function(){
                    $("#dropdown").remove(); 
                    $(this).parent().css("position","relative");
                    $(this).after("<div id=\'dropdown\'><a id=\"edit_item\"><i class=\"fa fa-edit\"></i></a><a id=\"delete_item\"><i class=\"fa fa-trash\"></i></a></div>")
                });
                $(document).on("click","#items",function(){
                    $("#modal_item").show(); 
                    var name = $(this).parent().parent().parent().children("td:nth-child(2)").html();
                    var id = $(this).parent().next(".id").val(); 
                    $("#dropdown").remove(); 
                    $("#modal_item h2").html("Enter "+name+" details");     
                    $("#modal_content2 input").val("");
                    $("#item_id").val(0);
                    $("#poid").val(id);                    
                    var h  = $("#modal_content2").height()-30;
                    $("#modal_content1").height(h);
                    item_display2(id);
                    
                });   
                $("#new").click(function(){
                    $("#save_item").show();
                   $("#modal_content2 #close").show();
                   $("#save_edit_item").hide();
                   $("#new").hide();                   
                    var name = $("#poid").val();          
                    $("#modal_content2 input").val("");
                    $("#poid").val(name);
                    $("#item_id").val(0);
                    $("#modal_item h2").html("Enter "+name+" details");       
                });
               $("#save_item").click(function(){
                    var item = $("#item").val();
                    var code = $("#code").val();
                    var rate = $("#rate").val();
                    var tax = $("#tax").val();
                    var unit = $("#unit").val();
                    var qty = $("#qty").val();                    
                    var poid = $("#poid").val();
                    $("#empty_after").remove();
                    var flag = 0;
                    $("#modal_content2 input").each(function(){
                       if($(this).val()==""){
                           $(this).focus();
                           $(this).after("<p id=\"empty_after\">This field is required</p>");
                           flag = 1;
                           return false;
                       } 
                    });  
                     setTimeout(function(){
                         $("#empty_after").remove();
                     },2000);
                    if(flag == 0){
                       $.ajax({
                          type:"Post",
                          url:"POItems",
                          data:{item:item,code:code,rate:rate,tax:tax,poid:poid,unit:unit,qty:qty,type:"add"},
                          success:function(res){
                              if(res==1){
                                  item_display2($("#poid").val());
                              }
                              else{
                                  alert(res);
                              }
                          },
                          error: function (res) {
                              alert(res);
                          }
                       });                      
                    }
               });
               $("#save_edit_item").click(function(){
                    var item = $("#item").val();
                    var code = $("#code").val();
                    var rate = $("#rate").val();
                    var tax = $("#tax").val();
                    var unit = $("#unit").val();
                    var qty = $("#qty").val();                    
                    var item_id = $("#item_id").val();
                    var poid = $("#poid").val();
                    $("#empty_after").remove();
                    var flag = 0;
                    $("#modal_content2 input").each(function(){
                       if($(this).val()==""){
                           $(this).focus();
                           $(this).after("<p id=\"empty_after\">This field is required</p>");
                           flag = 1;
                           return false;
                       } 
                    });  
                     setTimeout(function(){
                         $("#empty_after").remove();
                     },2000);
                    if(flag == 0){
                       $.ajax({
                          type:"Post",
                          url:"POItems",
                          data:{item_id:item_id,item:item,code:code,rate:rate,tax:tax,unit:unit,qty:qty,type:"update"},
                          success:function(res){
                              if(res==1){
                                  item_display2($("#poid").val());
                                  $("#modal_item h2").html("Edit "+item);   
                              }
                              else{
                                  alert(res);
                              }
                          },
                          error: function (res) {
                              alert(res);
                          }
                       });                      
                    }
               });
               $("#save").click(function(){
                   var po_date = $("#po_date").val();
                   var dp_date = $("#dp_date").val();
                   var desc = $("#desc").val();
                   var consignee = $("#consignee").val();
                   var pono = $("#po_no").val();
                   $("#empty_after").remove();
                   var flag = 0;
                   $("#modal #modal_content input").each(function(){
                      if($(this).val()==""){
                          $(this).focus();
                          $(this).after("<p id=\"empty_after\">This field is required</p>");
                          flag = 1;
                          return false;
                      } 
                   });  
                    setTimeout(function(){
                        $("#empty_after").remove();
                    },2000);
                   if(flag == 0){
                      $.ajax({
                         type:"Post",
                         url:"PurchaseOrder",
                         data:{pono:pono,po_date:po_date,dp_date:dp_date,desc:desc,consignee:consignee,type:"add"},
                         success:function(res){
                             if(res==1){
                                 item_display();
                                 $("#modal").hide();
                             }
                             else{
                                 alert(res);
                             }
                         },
                         error: function (res) {
                             alert(res);
                         }
                      });                      
                   }
               });
               $(document).on("click","#edit",function(){

                   $("#modal_edit").show(); 
                   var id = $(this).parent().next(".id").val(); 
                   $("#id").val(id);
                   var po_no = $(this).parent().parent().parent().children("td:nth-child(2)").html();
                   var po_date = $(this).parent().parent().parent().children("td:nth-child(3)").html();
                   var dp_date = $(this).parent().parent().parent().children("td:nth-child(4)").html();
                   var desc = $(this).parent().parent().parent().children("td:nth-child(5)").html();
                   var con = $(this).parent().parent().parent().children("td:nth-child(6)").html();

                   $("#modal_edit h2").html("Edit "+po_no);                                       
                   $("#dropdown").remove(); 
                   $("#po_no2").val(po_no);
                   $("#po_date2").val(po_date);
                   $("#dp_date2").val(dp_date);
                   $("#desc2").val(desc);
                   $("#consignee2 option").each(function () {
                        if ($(this).html() == con) {
                            $(this).attr("selected", "selected");
                            return;
                        }
                    });
               });
               $(document).on("click","#edit_item",function(){

                   var id = $(this).parent().next().val(); 
                   $("#item_id").val(id);
                   var name = $(this).parent().parent().parent().children("td:nth-child(1)").html();
                   var code = $(this).parent().parent().parent().children("td:nth-child(2)").html();
                   var unit = $(this).parent().parent().parent().children("td:nth-child(3)").html();
                   var tax = $(this).parent().parent().parent().children("td:nth-child(4)").html();
                   var rate = $(this).parent().parent().parent().children("td:nth-child(5)").html();
                   var qty = $(this).parent().parent().parent().children("td:nth-child(6)").html();

                   $("#modal_item h2").html("Edit "+name);                                       
                   $("#item").val(name);
                   $("#code").val(code);
                   $("#unit").val(unit);
                   $("#tax").val(tax);
                   $("#rate").val(rate);
                   $("#qty").val(qty);
                   $("#save_item").hide();
                   $("#modal_content2 #close").hide();
                   $("#save_edit_item").show();
                   $("#new").show();
               });
               $(document).on("click","#delete_item",function(){
                    var id = $(this).parent().next().val(); 
                    $.ajax({
                       type:"Post",
                       url:"POItems",
                       data:{id:id,type:"delete"},
                       success:function(res){
                           if(res==1){
                               item_display2($("#poid").val());
                           }
                           else{
                               alert(res);
                           }
                       },
                       error: function (res) {
                           alert(res);
                       }
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
                           url:"PurchaseOrder",
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
               $("#save_edit").click(function(){                    
                   var id = $("#id").val();
                   var po_no = $("#po_no2").val();
                   var po_date = $("#po_date2").val();
                   var dp_date = $("#dp_date2").val();
                   var desc = $("#desc2").val();
                   var consignee = $("#consignee2").val();
                   $("#empty_after").remove();
                   var flag = 0;
                   $("#modal_edit #modal_content input").each(function(){
                      if($(this).val()==""){
                          $(this).focus();
                          $(this).after("<p id=\"empty_after\">This field is required</p>");
                          flag = 1;
                          return false;
                      } 
                   });  
                    setTimeout(function(){
                        $("#empty_after").remove();
                    },2000);
                   if(flag == 0){
                      $.ajax({
                         type:"Post",
                         url:"PurchaseOrder",
                         data:{id:id,po_no:po_no,po_date:po_date,dp_date:dp_date,desc:desc,consignee:consignee,type:"update"},
                         success:function(res){
                             if(res==1){
                                 item_display();
                                 $("#modal_edit").hide();
                             }
                             else{
                                 alert(res);
                             }
                         },
                         error: function (res) {
                             alert(res);
                         }
                      });                      
                   }
               });

               function item_display(){
                    $.ajax({
                       type:"get",
                       url:"PurchaseOrder",
                       data:{type:"get"},
                       success:function(obj){                           
                           if(obj!=0){
                               var json = JSON.parse(obj);
                                $("#main_content tbody").empty();
                                var res = "";
                                for(var i = 0; i < json.length; i++) {
                                    var obj2 = json[i];
                                    
                                    res = res+"<tr>";    
                                    res = res+"<td>"+obj2.sno+"</td>";
                                    res = res+"<td>"+obj2.pono+"</td>";
                                    res = res+"<td>"+obj2.podate+"</td>";
                                    res = res+"<td>"+obj2.dpdate+"</td>";
                                    res = res+"<td>"+obj2.podesc+"</td>";
                                    res = res+"<td>"+obj2.name+"</td>";
                                    res = res+"<td><span><i class=\"fa fa-caret-down\"></i></span><input type=\"number\" class=\"id\" value="+obj2.id+" hidden disabled></td>";
                                    res = res+"</tr>";                                    
                                }
                                $("#main_content tbody").append(res);
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
                function item_display2(name){
                     $.ajax({
                        type:"get",
                        url:"POItems",
                        data:{poid:name,type:"get"},
                        success:function(obj){                            
                            if(obj!=0){
                                var json = JSON.parse(obj);
                                var res = "";
                                $("#modal_content1 tbody").empty();
                                for(var i = 0; i < json.length; i++) {
                                    var obj2 = json[i];
                                    res = res+"<tr>";    
                                    res = res+"<td>"+obj2.name+"</td>";

                                    res = res+"<td>"+obj2.code+"</td>";
                                    res = res+"<td>"+obj2.uom+"</td>";
                                    res = res+"<td>"+obj2.tax.toFixed(2)+"</td>";
                                    res = res+"<td>"+obj2.rate.toFixed(2)+"</td>";
                                    res = res+"<td>"+obj2.qty+"</td>";
                                    res = res+"<td><span><i class=\"fa fa-caret-down\"></i></span><input class=\"item_table_id\" type=\'number\' hidden value=\'"+obj2.id+"\'></td>";
                                    res = res+"</tr>";
                                }
                                $("#modal_content1 tbody").append(res);
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
            });
            
        </script>
        <style>
            #modal_item>div{
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%,-50%);
                width: 80%;
            }
            
        </style>
    </head>
    <body>
        <%@include file="nav.jsp" %>
        <%@include file="side.jsp" %>        

        <div id="main_div">
            <div>
                <h2>Purchase Order</h2>
                <span id="modal_display">New</span>
            </div>             
            <div id="search_div">
                <div class="search">
                    <input type="text" placeholder="Enter PO No" id="main_input">
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
                            <th>PO No</th>
                            <th>PO Date</th>
                            <th>DP Upto Date</th>
                            <th>Description</th>
                            <th>Consignee</th>
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
                <h2>New Purchase Order</h2>
                <label>PO No</label>               
                <input type="text" placeholder="PO NO" id="po_no">
                <label>Purchase Order Date</label>
                <input type="date" placeholder="PO Date" id="po_date">
                <label>DP Upto Date</label>
                <input type="date" placeholder="PO Date" id="dp_date">
                <label>Description</label>
                <input type="text" placeholder="Description" id="desc">
                <label>Consignee</label>
                <select id="consignee">
                <%
                    Class.forName("com.mysql.cj.jdbc.Driver");  
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/MSCELECTRICALS?useSSL = false","root","NovoDB123#$");  
                    String query = "select * from buyer_consignee where type=?";
                    PreparedStatement ps = con.prepareStatement(query);  
                    ps.setString(1, "c");
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
                <button id="save">Save</button>
                <button id="close">Close</button>
            </div>
        </div>
        <div id="modal_edit">
            <div id="modal_content">
                <h2>Edit Purchase Order</h2>
                <input type="text" placeholder="id" id="id" disabled hidden>
                <label>PO No</label>               
                <input type="text" placeholder="PO NO" id="po_no2">
                <label>Purchase Order Date</label>                
                <input type="date" placeholder="PO Date" id="po_date2">
                <label>DP Upto Date</label>
                <input type="date" placeholder="PO Date" id="dp_date2">
                <label>Description</label>
                <input type="text" placeholder="Description" id="desc2">
                <label>Consignee</label>
                <select id="consignee2">
                <%
                    Class.forName("com.mysql.cj.jdbc.Driver");  
                    PreparedStatement ps2 = con.prepareStatement(query);  
                    ps2.setString(1, "c");
                    try{
                        ResultSet rs = ps.executeQuery();
                        while(rs.next()){                
                            out.println("<option value=\""+rs.getString("id")+"\">"+rs.getString("name")+"</option>");
                        }                
                    }
                    catch(Exception e){
                        out.println(e.getMessage());                    
                    }
                    finally{
                        con.close();    
                    }                                  
                %>
                
                </select>
                <button id="save_edit">Save</button>
                <button id="close2">Close</button>
            </div>
        </div>
        <div id="modal_item">
            <div style="box-shadow:0px 3px 5px #dedede;border-radius: 10px;">
                <div id="modal_content1">
                    <table>
                        <thead>
                            <tr>
                                <th>Product/Service</th>
                                <th>HSN/SAC</th>
                                <th>Unit</th>
                                <th>GST%</th>
                                <th>Rate</th>
                                <th>Qty</th>
                                <th>Options</th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                </div>
                <div id="modal_content2">
                    <h2>Enter details</h2>
                    <input type="number" placeholder="poid" id="poid" disabled hidden>
                    <input type="number" placeholder="id" id="item_id" disabled hidden>
                    <label>Product/Service Description</label>
                    <input type="text" placeholder="Product/Service Description" id="item">
                    <label>HSN/SAC</label>
                    <input type="number" placeholder="HSN/SAC" id="code">
                    <label>Unit</label>
                    <input type="text" placeholder="Unit" id="unit">
                    <label>GST%</label>
                    <input type="number" placeholder="GST%" id="tax">
                    <label>Rate</label>
                    <input type="number" placeholder="Rate" id="rate">
                    <label>Quantity</label>
                    <input type="number" placeholder="Quantity" id="qty">
                    <button id="save_item">Save</button>                    
                    <button id="save_edit_item">Edit</button>
                    <button id="new">New</button>
                    <button id="close">Close</button>
                </div>
            </div>
        </div>
    </body>
</html>
