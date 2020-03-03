<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=iso-8859-1"%>
<%@taglib uri="http://marcioduques.com/duquesLib" prefix="duques"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<meta http-equiv="Content-Type"
	content="text/html; charset=windows-1252" />
<title>PopupManager</title>
</head>
<body>

<script language="javascript">
        
            function submetePopup(){
            
                <% if ("H".equals(request.getParameter("TIPO"))){%>
                    submeteHospede();
                <%}else if ("C".equals(request.getParameter("TIPO"))){%>
                    submeteComplemento();
                <%}%>
                
            }
    
            function submeteHospede(){
                vForm = document.forms[0];
                vForm.idxCheckin.value = '<%=request.getParameter("idxCheckin")%>';
                vForm.qtdePax.value = '<%=request.getParameter("qtdePax")==null?"":request.getParameter("qtdePax") %>';
                vForm.seguro.value = '<%=request.getParameter("seguro")==null?"":request.getParameter("seguro") %>';
                vForm.action = '<s:url action="popupHospede!prepararPopupHospede.action" namespace="/app/checkin" />';
                vForm.submit();        
            }    

            function submeteComplemento(){
                vForm = document.forms[0];
                vForm.idxCheckin.value = '<%=request.getParameter("idxCheckin")%>';
                vForm.action = '<s:url action="popupComplemento!prepararPopupComplemento.action" namespace="/app/checkin" />';
                vForm.submit();        
            }    
            
    
    </script>

<s:form action="popupHospede!prepararPopupHospede.action"
	namespace="/app/checkin" theme="simple">
	<s:hidden name="idxCheckin" />
	<s:hidden name="qtdePax" />
	<s:hidden name="seguro" />
</s:form>

<script>
    submetePopup();
  </script>

</body>
</html>