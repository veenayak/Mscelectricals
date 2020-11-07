<%-- 
    Document   : MSElectricalsMain.jsp
    Created on : 5 Jul, 2020, 6:03:10 PM
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

        <title>MSC Electricals Buyers</title>
        <script>
            $(document).on("click","table span",function(){
                $("#dropdown").remove(); 
                $(this).parent().css("position","relative");
                $(this).after("<div id=\'dropdown\'><a id=\"edit\"><i class=\"fa fa-edit\"></i></a><a id=\"delete\"><i class=\"fa fa-trash\"></i></a></div>")
            });
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
                item_display();
                $("#save").click(function(){
                    var item = $("#item").val();
                    var address = $("#item_address").val();
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
                          url:"BuyerConsignee",
                          data:{item:item,address:address,subtype:"b",type:"add"},
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
                    $("#item_id").val(id);
                    var name = $(this).parent().parent().parent().children("td:nth-child(2)").html();
                    var address = $(this).parent().parent().parent().children("td:nth-child(3)").html();
                    $("#modal_edit h2").html("Edit "+name);                                       
                    $("#dropdown").remove(); 
                    $("#item2").val(name);
                    $("#item2_address").val(address);
                });
                $(document).on("click","#delete",function(){
                    
                    var id = $(this).parent().next(".id").val(); 
                    var name = $(this).parent().parent().parent().children("td:nth-child(2)").html();
                    var text = "Are you sure you want to delete "+name+"?";
                    $("#dropdown").remove(); 
                    confirm2( text,function(){
                        $("#confirm2").remove();
                         $.ajax({
                            type:"Post",
                            url:"BuyerConsignee",
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
                    var id = $("#item_id").val();
                    var item = $("#item2").val();
                    var address = $("#item2_address").val();
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
                          url:"BuyerConsignee",
                          data:{id:id,item:item,address:address,type:"update"},
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
                        url:"BuyerConsignee",
                        data:{type:"get",subtype:"b"},
                        success:function(obj){                           
                            if(obj!=0){
                                var json = JSON.parse(obj);
                                var res = "";
                                $("tbody").empty();
                                for(var i = 0; i < json.length; i++) {
                                    var obj2 = json[i];
                                    res = "";
                                    res = res+"<tr>";    
                                    res = res+"<td>"+obj2.sno+"</td>";
                                    res = res+"<td>"+obj2.name+"</td>";
                                    res = res+"<td>"+obj2.address+"</td>";
                                    res = res+"<td><span><i class=\"fa fa-caret-down\"></i></span><input type=\"number\" class=\"id\" value="+obj2.id+" hidden disabled></td>";
                                    res = res+"</tr>";
                                    $("tbody").append(res);
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
            });
        </script>
        <style>
            .tabs:nth-child(4),.tabs2:nth-child(4){
                color: #7579de!important;
                font-weight: bold;
                border-radius: 5px;
            }
            #main_content tbody tr td:nth-child(4),#main_content thead tr th:nth-child(4){
                text-align: center;
            }
        </style>
    </head>
    <body>
        <%@include file="nav.jsp" %>
        <%@include file="side.jsp" %>
        <div id="main_div">
            <div>
                <h2>Buyers</h2>
                <span id="modal_display">New</span>
            </div>            
            <div id="search_div">
                <div class="search">
                    <input type="text" placeholder="Enter Buyer Name" id="main_input">
                    <span> <i class="fa fa-search" id="main_search"></i></span>
                </div>
            </div>
            <div id="main_content">
                <table>
                    <thead>
                        <tr>
                            <th>S.No</th>
                            <th>Buyer Name</th>
                            <th>Address</th>
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
                <h2>New Buyer</h2>
                <input type="text" placeholder="Buyer Name" id="item">
                <input type="text" placeholder="Buyer Address" id="item_address">
                <button id="save">Save</button>
                <button id="close">Close</button>
            </div>
        </div>
        <div id="modal_edit">
            <div id="modal_content">
                <h2></h2>
                <input type="text" placeholder="id" id="item_id" hidden disabled>
                <input type="text" placeholder="Buyer Name" id="item2">
                <input type="text" placeholder="Buyer Address" id="item2_address">
                <button id="save_edit">Save</button>
                <button id="close2">Close</button>
            </div>
        </div>
    </body>
</html>
