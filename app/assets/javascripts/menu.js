function initialize_menu(){
   $(".menu01").click(function(){
       if(false == $(this).next().is(":visible")) {
           $(".menu02").slideUp(300);
       }
       $(this).next().slideToggle("normal");
   });
   $(".menu01.active").next().slideToggle(0);
}
$(document).ready(initialize_menu);
$(document).on('page:load', initialize_menu);
