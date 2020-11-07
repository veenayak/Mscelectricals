<%-- 
    Document   : ChallanPrint
    Created on : 28 Jul, 2020, 7:39:28 AM
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
        <link rel="stylesheet" href="css/index.css">
        <link rel="icon" href="images/MSCE.png">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <title>MSCElectricals Challan Print</title>
        
        <style>
            body{
                height: auto;
                overflow: auto;
            }
            .style2 {
                    font-size: 54px;
                    font-weight: bold;
                    font-family: "Times New Roman", Times, serif;
            }
            #last td{
                padding: 10px 5px;
            }
            input{
                width: 100%;
                border: 1px solid #cacaca;
                border-radius: 5px;
                margin-bottom: 30px;
                outline: 0;
                padding: 10px;
                background: #ffffff;
                color: red;
                border: 0;
                min-height: auto;
                padding: 0;
                margin: 0;
                font-size: 15px;
            }
            #po_no{
                padding: 0;
                border: 0;
                margin: 0;
                min-height: auto;
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
                color: black;
                opacity: 1;
                font-size: 15px;
            }
        </style>
        <script>
            $(document).ready(function(){
                var id = <%=request.getParameter("id")%>; 
                    console.log(id);
                    $("#edit_id").val(id);
                    $("#save").hide();
                    $("#save_edit").show();
                    $("#dropdown").remove(); 
                    $.ajax({
                        type:"get",
                        url:"BillDetails",
                        data:{type:"get",id:id},
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
                                       $("#address").html(json.add);
                                        $("#buyer").html(json.name);

                                    },
                                    error:function(res){
                                        alert(res);
                                    },
                                });

                                $("#po_date").html(list[0].podate);
                                $("#challan_date").html(list[0].challandate);
                                $("#challan_no").html(list[0].billno);
                                $("#po_no").val(list[0].pono);
                                var length = list[1].length;
                                for(var i = 0; i < list[1].length; i++) {
                                    var obj2 = list[1][i];
$("#last").prepend('<tr class="items"  style="color:black; height:30px"><td style="border-bottom:hidden;" align="center">'+length+'</td><td style="border-bottom:hidden;">'+obj2.name+'</td><td style="border-bottom:hidden;" align="center">'+obj2.qty+" "+obj2.uom+'</td></tr>');                                    length--;
                                }
                                for(var i = 0; i < 30-list[1].length; i++) {
                                    if(i==29-list[1].length)
                                        $("#last").append('<tr class="items"  style="color:black; height:30px"><td align="center"></td><td ></td><td  align="center"></td></tr>');
                                    else
                                        $("#last").append('<tr class="items"  style="color:black; height:30px"><td style="border-bottom:hidden;" align="center"></td><td style="border-bottom:hidden;"></td><td style="border-bottom:hidden;" align="center"></td></tr>');
                                    length--;
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
                        $("#odt").html("ORIGINAL");
                    }
                    else if(type=="d"){
                        $("#odt").html("DUPLICATE");
                    }
                    else if(type=="t"){
                        $("#odt").html("TRIPLICATE");
                    }
                                        
                    $("#printbtn").click(function(){
                        $("#printbtn").hide();
                        if(!window.print()){
                            $("#printbtn").show();
                        }
                    });
                
            });
        </script>
    </head>
    <body style="color: red;">
        <table width="1000" height="604" border="0" align="center" style="font-size: 15px;border:solid 1px red; background-color:#FFFFFF;">
  <tr>
    <td height="209"><table width="100%" border="0">
      <tr>
        <td><input type="text" value="GSTIN : 18ASRPC7468B1ZI"> </td>
        <td align="center"><div align="center" style="border:solid 1px red; border-radius:7px; width:90px; padding:2px;"><strong>CHALLAN</strong></div></td>
        <td><input type="text" value="Mobile No. : 8486109669"> </td>
      </tr>
      <tr>
        <td width="37%">&nbsp;</td>
        <td width="26%" align="center"><strong id="odt">ORIGINAL</strong></td>
        <td width="37%"><input type="text" value="E-mail : mscelectricals2015@gmail.com">  </td>
      </tr>
      <tr>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="3"><div align="center"><span ><input type="text" value="M/s. MSC ELECTRICALS" class="style2" style="text-align:center;">  </span></div></td>
        </tr>
      <tr>
        <td colspan="3"><div align="center"> <input type="text" value="Govt. &amp; Rly. Contractor and Suppliers"  style="text-align:center;"> </div></td>
        </tr>
      <tr>
        <td colspan="3"><div align="center"><input type="text" value="Dolaigaon, New Bongaigaon " style="text-align:center;">  </div></td>
        </tr>
      <tr>
        <td height="22" colspan="3" style="border-bottom:solid 2px red;"><div align="center"> <input type="text" value="All kinds of Electrical Goods, Hardware, Scientific Instruments &amp; Steel Furniture." style="text-align:center;">  </div></td>
        </tr>
      
    </table></td>
  </tr>
  <tr>
    <td height="97">
	<table width="99%" border="0" align="center" cellpadding="3" style="border-collapse:collapse; border-color:red">
      <tr>
        <td width="3%" valign="top">To</td>
        <td width="97%" valign="top" style="border-bottom:solid 2px red; border-bottom-style:dotted;color:black;"><span id="buyer"></span></td>
        </tr>
      <tr>
        <td valign="top" style="border-bottom:solid 2px red; border-bottom-style:dotted;color:black;">&nbsp;</td>
        <td valign="top" style="border-bottom:solid 2px red; border-bottom-style:dotted;color:black;"><span id="address"></span></td>
        </tr>
	</table>
	<table width="1000" align="center" cellpadding="3">
      <tr>
        <td width="84" valign="top" >Challan No. </td>
        <td width="421" valign="top" style="border-bottom:solid 2px red; border-bottom-style:dotted;color:black;"><span id="challan_no"></span></td>
        <td width="35" valign="top" >Date</td>
        <td width="212" valign="top" style="border-bottom:solid 2px red; border-bottom-style:dotted;color:black;"><span id="challan_date"></span></td>
        </tr>
      <tr>
        <td valign="top" >Order No.</td>
        <td valign="top" style="border-bottom:solid 2px red; border-bottom-style:dotted;color:black;">
            <select id="po_no" required="required" disabled>
                    <option value=""></option>
              <%
                  Class.forName("com.mysql.cj.jdbc.Driver");  
                    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/MSCELECTRICALS?useSSL = false","root","NovoDB123#$");  
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
        <td valign="top" >Date</td>
        <td valign="top" style="border-bottom:solid 2px red; border-bottom-style:dotted;color:black;"><span id="po_date"></span></td>
        </tr>
    </table></td>
  </tr>
  <tr>
    <td height="81"><table width="100%"  border="1" style= "border-collapse:collapse;border-color:red">
            <thead>
      <tr>
        <td width="6%" height="33"><div align="center">Sl. No. </div></td>
        <td width="48%"><div align="center">DESCRIPTION</div></td>
        <td width="13%"><div align="center">QUANTITY</div></td>
        </tr>
            </thead>
            <tbody  id="last">
            </tbody>
	
	
    </table></td>
  </tr>
  <tr>
    <td><table width="100%" border="0">
      <tr>
        <td width="67%">&nbsp;</td>
        <td width="33%"><table width="100%" border="0">
          <tr>
            <td width="36%"></td>
            <td width="45%"></td>
            <td width="19%"></td>
          </tr>
        </table></td>
      </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	    </tr>
	  <tr>
        <td></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>Received By: </td>
        <td><div align="right"><input type="text" value="M/s. MSC ELECTRICALS" style="text-align:right"></div></td>
      </tr>
	 
    </table>
	<center><input type="button" name="printbtn" id="printbtn" value="Print" style="height:40px; width:80px;border:1px solid #cacaca;"></center>
	</td>
  </tr>
</table>
    </body>
</html>
