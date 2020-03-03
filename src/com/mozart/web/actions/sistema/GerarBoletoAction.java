package com.mozart.web.actions.sistema;






import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.ejb.entity.ControlaDataEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartWebUtil;


public class GerarBoletoAction extends BaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = -75928571429384561L;
	
	private Double valor;
	private Integer vencimento;
	private Long nossoNumero;
	private Long idHotel;
	private String email;
	


	public GerarBoletoAction (){
			
			
	}
	
	
	 
	public String gerarBoleto(){
		
		try{
		
			String[] destinatario=null;
			
			if (email.indexOf("," )>0){
					destinatario = email.split(",");
				
			}else{
					destinatario= new String[1];
					destinatario[0]=email;
			}
			HotelEJB hotelEJB = new HotelEJB();
			hotelEJB.setIdHotel(idHotel);
			hotelEJB = getUsuario().getRedeHotelEJB().getHoteis().get(
							getUsuario().getRedeHotelEJB().getHoteis().indexOf(hotelEJB)
						);
			
			ControlaDataEJB cd = (ControlaDataEJB)CheckinDelegate.instance().obter(ControlaDataEJB.class, idHotel);
			
			MozartWebUtil.gerarBoletoSeguro(cd, vencimento.intValue(), hotelEJB, destinatario, valor);		
			addMensagemSucesso(MSG_SUCESSO);
			
		}catch(MozartSessionException ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
	
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
		}
		
		return SUCESSO_FORWARD;
		
	}
	
	
	
	public String prepararGerarBoleto(){
			
			
			return SUCESSO_FORWARD;
			
		}



	public Double getValor() {
		return valor;
	}



	public void setValor(Double valor) {
		this.valor = valor;
	}



	public Integer getVencimento() {
		return vencimento;
	}



	public void setVencimento(Integer vencimento) {
		this.vencimento = vencimento;
	}



	public Long getNossoNumero() {
		return nossoNumero;
	}



	public void setNossoNumero(Long nossoNumero) {
		this.nossoNumero = nossoNumero;
	}



	public Long getIdHotel() {
		return idHotel;
	}



	public void setIdHotel(Long idHotel) {
		this.idHotel = idHotel;
	}



	public String getEmail() {
		return email;
	}



	public void setEmail(String email) {
		this.email = email;
	}

		
}
