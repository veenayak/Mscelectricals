/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
$(window).on("resize",function(){
    var h = $(window).height()-$("#nav_div").outerHeight()-30;
    $("#main_div").height(h);
    $("#tabs_div").height(h);                
    var side = window.localStorage.getItem("side");            
    if(side != null && side =="0"){
        $("#tabs_div>span").addClass("tabs_icon_inactive"); 
        $(".tabs").addClass("tabs_inactive");
        $("#tabs_div").addClass("tabs_div_inactive");   
        $("#tabs2_div").show();
        var w = $(window).width() - 80;                                                   
        $("#main_div").css("width",w);
        $("#tabs_div>span").attr("disabled",false);
        window.localStorage.setItem("side","0");
    }
});
function side_true(){
    $("#tabs_div>span").removeClass("tabs_icon_inactive"); 
    $("#main_div").animate({width:"80%"},20,function(){
        $("#tabs_div>span").attr("disabled",false);
    });
    $(".tabs").removeClass("tabs_inactive");
    $("#tabs_div").removeClass("tabs_div_inactive");
    $("#tabs2_div").hide();    
    window.localStorage.setItem("side","1");
}
function side_false(){
    $("#tabs_div>span").addClass("tabs_icon_inactive"); 
    $(".tabs").addClass("tabs_inactive");
    $("#tabs_div").addClass("tabs_div_inactive");   
    $("#tabs2_div").show();
    var w = $(window).width() - 80;                                                   
    $("#main_div").animate({width:w},1000,function(){
        $("#tabs_div>span").attr("disabled",false);
    });
    window.localStorage.setItem("side","0");
}
function confirm2(msg,yescallback,nocallback){
    $("body").append("<div id=\'confirm2\'><div><p>"+msg+"</p><button id=\'true\'>Yes</button><button id=\'false\'>No</button></div></div>");
    var confirmBox = $("#confirm2").show();
    $(document).off("click","#true");
    $(document).off("click","#false");
    $(document).on("click","#true",function(){
        confirmBox.hide();
        confirmBox.remove();
        yescallback();
    });
    $(document).on("click","#false",function(){
        confirmBox.hide();
        confirmBox.remove();
        nocallback();
    });

}
$(document).on("change",'input[type="number"]', function(event){
    if($(this).val()<0){
        $(this).val(0);

    }
});
$(document).on("keyup",'input[type="number"]', function(event){
    if($(this).val()<0){
        $(this).val(0);

    }
});
$(document).ready(function(){
    
    var h = $(window).height()-$("#nav_div").outerHeight()-30;
    $("#main_div").height(h);
    $("#tabs_div").height(h);
    var side = window.localStorage.getItem("side");            
    if(side != null && side =="0"){
        side_false();
    }
    
    $("#modal_display").click(function(){
        $("#modal").show(); 
    });
    $("#close").click(function(){
        $("#modal").hide(); 
        $("#modal_item").hide(); 
        $("#modal_edit").hide(); 
    });
    $("#close2").click(function(){
        $("#modal").hide(); 
        $("#modal_item").hide(); 
        $("#modal_edit").hide(); 
    });
    $("#main_input").focusin(function(){
        $(this).parent().css("box-shadow","0px 0px 4px #7479de");
    });
    $("#main_input").focusout(function(){
        $(this).parent().css("box-shadow","none");
    });
    $("#main_search").click(function(){
        if($("#main_input").val()!=""){
            $("table tbody tr").hide();
            $("table tbody tr td:nth-child(2)").each(function(){                
                if($(this).html()==$("#main_input").val()){                    
                    $(this).parent().show();
                }
            });
        }
        else{
            $("table tbody tr").show();
        }
    });
    $("#main_input").keyup(function(){
        if($("#main_input").val()!=""){
            $("table tbody tr").hide();
            $("table tbody tr td:nth-child(2)").each(function(){
                if($(this).html().toLowerCase().includes($("#main_input").val())){                    
                    $(this).parent().show();
                }
            });
        }
        else{
            $("table tbody tr").show();           
        }
    });  
    
    $("#tabs_div>span").click(function(){
        var dis = $(this);
        if(!dis.attr("disabled")){
            dis.attr("disabled",true);
            if($(this).attr("class")=="tabs_icon_inactive"){                            
                side_true();
            }
            else{

                side_false();
            }
        }
    }); 

});

