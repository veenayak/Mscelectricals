<%-- 
    Document   : MSCElectricalsTaxReport
    Created on : 28 Jul, 2020, 9:06:16 AM
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
        <script src="js/index.js"></script>
        <title>MSC Electricals Tax Report</title>

        <script>
            $(document).ready(function(){
                item_display();                
             });
             function item_display(){
                    $.ajax({
                        type:"get",
                        url:"Bill",
                        data:{type:"get"},
                        success:function(res){   
                            if(res!=0){
                                 var list = JSON.parse(res);
                                 $("#main_content tbody").empty();
                                 for(var i = 0; i < list.length; i++) {
                                     var obj = list[i];
                                     var paid = "";
                                     var gst = obj.atax-obj.btax;
                                     if(obj.paid)
                                         paid = '<i class="fa fa-check"></i><input type=\"number\" class=\"id\" value="'+obj.id+'" hidden disabled>';
                                     else
                                         paid = '<i class="fa fa-close"></i><input type=\"number\" class=\"id\" value="'+obj.id+'" hidden disabled>';
                                     $("#main_content tbody").append("<tr><td>"+obj.sno+"</td><td>"+obj.poname+"</td><td>"+obj.billno+"</td><td>"+obj.billdate+"</td><td>"+gst.toFixed(0)+"</td><td>"+obj.tcgst.toFixed(0)+"</td><td>"+obj.tsgst.toFixed(0)+"</td><td>"+obj.btax.toFixed(0)+"</td><td>"+obj.atax.toFixed(0)+"</td><td>"+paid+"</td></tr>");

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
        </script>
        <style>
            .tabs:nth-child(7),.tabs2:nth-child(7){
                color: #7579de!important;
                font-weight: bold;
                border-radius: 5px;
            }
            #main_content tbody tr td:nth-child(10),#main_content thead tr th:nth-child(10){
                text-align: center;
            }
            #main_content td{
                padding: 14px 15px;
            }
        </style>
    </head>
    <body>
        <%@include file="nav.jsp" %>
        <%@include file="side.jsp" %>
        <div id="main_div">
            <div>
                <h2>Tax Report</h2>
            </div>             
            <div id="search_div">
                <div class="search">
                    <input type="text" placeholder="Enter Po No" id="main_input">
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
                            <th>Po No</th>
                            <th>Bill No</th>
                            <th>Bill Date</th>
                            <th>GST</th>
                            <th>CGST</th>
                            <th>SGST</th>
                            <th>Before Tax</th>
                            <th>After Tax</th>
                            <th>Paid</th>
                        </tr>                            
                    </thead>
                    <tbody>
                           
                    </tbody>
                </table>
            </div>
        </div> 
    </body>
</html>
