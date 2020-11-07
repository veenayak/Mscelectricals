<%-- 
    Document   : MSElectricalsLogin.jsp
    Created on : 5 Jul, 2020, 2:43:19 PM
    Author     : winayak
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/index.css">
        <title>MSC Electricals Login</title>
        <link rel="icon" href="images/MSCE.png">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

        <script>
            $(document).ready(function(){
                $("#login").click(function(){
                   $("#empty_after").remove();
                   var email = $("#username").val();
                   var pwd = $("#pwd").val();
                   var flag = 0;
                   $("#login_div input").each(function(){
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
                          type:"Get",
                          url:"Login",
                          data:{email:email,pwd:pwd},
                          success:function(res){
                              if(res==1){
                                  window.location.replace("MSCElectricalsGSTBill.jsp");
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
            });
        </script>
    </head>
    <body>
        <div id="login_div">
            <img src="images/MSCE.png">
            <h2>Login</h2>
            <input type="text" id="username" placeholder="Your Mail" required>            
            <input type="password" id="pwd" placeholder="Your Password" required>
            <button id="login">Login</button>
            <span>Forgot Password?</span>
        </div>
    </body>
</html>
