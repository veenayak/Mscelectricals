<%-- 
    Document   : nav.jsp
    Created on : 5 Jul, 2020, 3:45:39 PM
    Author     : winayak
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <script>
            $(document).ready(function(){
                $("#logout").click(function(){
                  $.ajax({
                        type:"Get",
                        url:"Logout",
                        success:function(res){
                            window.location.replace("/MSCElectricals/");
                        },
                        error: function (res) {
                            alert(res);
                        }
                     });  
                });
                $("#home").click(function(){
                    window.location.replace("/MSCElectricals/MSCElectricalsGSTBill.jsp");
                })
            });
        </script>
    </head>
    <body>
        <div id="nav_div">
            <img src="images/MSCE.png">
            <div>
                <h2>MSC</h2>
                <span>Electricals</span>
            </div>               
            <div id="logout_div">
                <i class="fa fa-home" id="home"></i>
                <i class="fa fa-sign-out" id="logout"></i>
            </div>
        </div>
    </body>
</html>
