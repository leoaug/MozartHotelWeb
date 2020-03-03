var tId = "";
var JuFlag = null;
var JdFlag = null;
var num=0;
var toTop = null;
  var up=0;
if(document.all){
   var move=20;
   }
else{
   var move=50;
  }
function Jup(){
toTop = false;
  if(up == 0){
    JuFlag=false;
    JdFlag=true;
    tId=setTimeout('Jdown()',1000);
  }
  else{
        up += 1;
        document.getElementById('JscrollBox').style.top=up+"px";
  }
 if ( JuFlag) setTimeout('Jup()',move);
}
function Jdown(){
toTop = false;
  var topA = document.getElementById('JscrollBox').offsetHeight;
  var topB = document.getElementById('container').offsetHeight;
  var botHeight = topB - topA;

  //document.getElementById('textoI').innerHTML = "topA:"+topA + "_ topB:"+topB + "_Top:"+document.getElementById('JscrollBox').style.top;
  
  
  
  if (topA<topB && topB + parseInt(document.getElementById('JscrollBox').style.top)==topA){
        //tId=setTimeout('resetar()',1000);
       JdFlag=false;
       JuFlag = true;
       tId=setTimeout('Jup()',1000);
        
  }
  if((up == botHeight) || (up == botHeight-1)){
       JdFlag=false;
       JuFlag = true;
       tId=setTimeout('Jup()',1000);
  }
  else{
        up -= 1;
      if(document.all){
          document.getElementById('JscrollBox').style.top=up+"px";
      }
      else{
        document.getElementById('JscrollBox').style.top=up+"px";
      }
  }
  if (JdFlag) tId=setTimeout('Jdown()',move);
}
function stopIt(){
  clearTimeout(tId); // remove all pending requests
  if(JdFlag){
     JdFlag=false;
     num=0;
  }
  else if(JuFlag){
     JuFlag=false;
     num=1;
  }
}
function go(){
  clearTimeout(tId); // remove all pending requests
  var topA = document.getElementById('JscrollBox').offsetHeight;
  var topB = document.getElementById('container').offsetHeight;
  if (topA < topB){
  
  }else{
  if(num == 0){
     if(toTop){        
         document.getElementById('JscrollBox').style.top = '0px';
         up=0;
     }
     JdFlag=true;
     tId=setTimeout('Jdown()',800);
  }
  else{
     if(toTop){        
         document.getElementById('JscrollBox').style.top = '0px';
         JdFlag=true;
         up=0;
         tId=setTimeout('Jdown()',800);
     }
     else{
         JuFlag=true;
         tId=setTimeout('Jup()',800);
     }
  }
  }
}
function resetar(){
    reset();
    go();
}

function reset(){
    JdFlag = false;
    JuFlag = false;
    toTop = true;
    up=0;
    document.getElementById('JscrollBox').style.top = '0px';
}
