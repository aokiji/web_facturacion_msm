$(document).ready(function(){
   $(".menu01").click(function(){
       if(false == $(this).next().is(":visible")) {
           $(".menu02").slideUp(300);
       }
       $(this).next().slideToggle("normal");
   });     
});