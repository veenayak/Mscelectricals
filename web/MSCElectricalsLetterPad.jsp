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
        <title>MSC Electricals Letter Pad</title>        
        <style>
            .tabs:nth-child(2),.tabs2:nth-child(2){
                color: #7579de!important;
                font-weight: bold;
                border-radius: 5px;
            }
            #dropdown{
                color: black;
                font-weight: normal;
                position: absolute;
                border: 1px solid #dedede;
                font-size: initial;
                border-radius: 5px;
                padding: 10px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 9999;
                top: 100%;
                width: auto;
                text-align: left;
                margin-top: 5px;
                background: #ffffff;
            }
            table #dropdown{
                margin: 0;
            }
            #main_content tbody tr td:nth-child(4),#main_content thead tr th:nth-child(4){
                text-align: center;
            }
        </style>
        <script>            
            $(document).ready(function(){
                $(document).on("click", function(event){
                    if(!$(event.target).closest("#new").length && !$(event.target).closest(".fa.fa-trash").length && !$(event.target).closest("#modal_content2").length && !$(event.target).closest("#modal_content1").length && !$(event.target).closest("#modal_content").length && !$(event.target).closest("#modal_display").length && !$(event.target).closest("#dropdown").length && !$(event.target).closest("table span").length && !$(event.target).closest("#confirm2 div").length ){
                        $("#modal").hide(); 
                        $("#modal_edit").hide(); 
                        $("#modal_item").hide(); 
                        $("#dropdown").remove(); 
                        $("#confirm2").remove();         
                    }
                });
                item_display();
                $(document).on("click","#main_content table span",function(){
                    $("#dropdown").remove(); 
                    $(this).parent().css("position","relative");
                    $(this).after("<div id=\'dropdown\'><a id=\"edit\"><i class=\"fa fa-edit\"></i></a><a id=\"delete\"><i class=\"fa fa-trash\"></i></a></div>")
                });
                $("#new").click(function(){
                    $("#dropdown").remove();
                   $(this).append('<div id="dropdown"><a id="lp1">LP1</a><a id="lp2">LP2</a><a id="lp3">LP3</div>'); 
                }); 
                $(document).on("click","#lp1",function(){
                    window.open("LetterPadPrintOne.jsp");
                });                
                $(document).on("click","#lp2",function(){
                    window.open("LetterPadPrintTwo.jsp");
                });      
                $(document).on("click","#lp3",function(){
                    window.open("LetterPadPrintThree.jsp");
                });   
                item_display();                
                $(document).on("click","#delete",function(){

                    var id = $(this).parent().next().val(); 
                    var name = $(this).parent().parent().parent().children("td:nth-child(2)").html();
                    var text = "Are you sure you want to delete "+name;
                    $("#dropdown").remove(); 
                    confirm2( text,function(){
                        $("#confirm2").remove();
                         $.ajax({
                            type:"Post",
                            url:"LetterPad",
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
            });
            function item_display(){
                    $.ajax({
                        type:"get",
                        url:"LetterPad",
                        data:{type:"get"},
                        success:function(res){   
                            if(res!=0){
                                 var list = JSON.parse(res);
                                 $("#main_content tbody").empty();
                                 for(var i = 0; i < list.length; i++) {
                                     var obj = list[i];
                                     $("#main_content tbody").append("<tr><td>"+obj.sno+"</td><td>"+obj.refno+"</td><td>"+obj.date+"</td><td><span><i class=\"fa fa-caret-down\"></i></span><input type=\"number\" class=\"id\" value="+obj.id+" hidden disabled></td></tr>");

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
                $(document).on("click","#edit",function(){
                    var id = $(this).parent().next().val(); 
                    window.open("LetterPadPrintOne.jsp?id="+id+"");                    
                });
            
        </script>
        <style>
            #new {
                position: relative;
            }
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
                <h2>Letter Pad</h2>
                <span id="new"><i class="fa fa-caret-down"></i></span>
            </div>            
            <div id="search_div">
                <div class="search">
                    <input type="text" placeholder="Enter Ref No" id="main_input">
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
                            <th>Sno</th>
                            <th>Ref No</th>
                            <th>Date</th>
                            <th>Options</th>
                        </tr>                            
                    </thead>
                    <tbody>
                          
                    </tbody>
                </table>
            </div>            
        </div>    
    </body>
</html>
