package com.mozart.web.actions.operacional;

import java.sql.Timestamp;
import java.util.List;

import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.delegate.OperacionalDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CaixaGeralVO;
import com.mozart.web.actions.BaseAction;

@SuppressWarnings("serial")
public class StatusApartamentoAction extends BaseAction{
	
	//este campo vem mascarado: idApto;status
	private String id, idMarcados;
	private String novoStatus;
	private String antigoStatus;
	
	
	private String obs;
	private Timestamp dataInicioIN;
	private Timestamp dataFimIN;

	
	public StatusApartamentoAction(){
		
		
	}
	
	public String prapararAlteracao(){
		warn("Pesquisando o status apartamento");
		
		try{
			
		    CaixaGeralVO param = new CaixaGeralVO();
            param.setIdHotel( getIdHoteis()[0] );
            param.setCofan("N");
            List<CaixaGeralVO> listaApartamento = CaixaGeralDelegate.instance().pesquisarApartamentoComCheckinEReserva( param );            

			request.getSession().setAttribute("listaApartamento", listaApartamento);
		
		}catch(Exception ex){
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
		}
		return SUCESSO_FORWARD;
	}
	
	public String alterarStatus(){
		warn("Alterando o status de apartamento");
		
		try{

					
			ApartamentoEJB aptoDe = new ApartamentoEJB();
			aptoDe.setUsuario( getUserSession().getUsuarioEJB() );
			if (!MozartUtil.isNull( id )){
				//aptoDe.setIdApartamento( new Long(id.split(";")[0]) );
			}
			aptoDe.setIdHotel( getIdHoteis()[0] );
			aptoDe.setStatus(antigoStatus);

			
			ApartamentoEJB aptoPara = new ApartamentoEJB();
			aptoPara.setIdHotel( getIdHoteis()[0] );
			aptoPara.setStatus(novoStatus);
			aptoPara.setDataEntrada( dataInicioIN );
			aptoPara.setDataSaida(dataFimIN);
			aptoPara.setObservacao(obs);

			aptoDe.setUsuario( getUserSession().getUsuarioEJB());
			OperacionalDelegate.instance().alterarStatusApartamentoLote(aptoDe, aptoPara, idMarcados);
			
			addMensagemSucesso(MSG_SUCESSO);
			
			return prapararAlteracao();
			
		}catch(MozartValidateException ex){
			
			error( ex.getMessage() );
			addMensagemErro( ex.getMessage() );
			return SUCESSO_FORWARD;

		}catch(Exception ex){
			
			error( ex.getMessage() );
			addMensagemErro( MSG_ERRO );
			return SUCESSO_FORWARD;
		}
		
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNovoStatus() {
		return novoStatus;
	}

	public void setNovoStatus(String novoStatus) {
		this.novoStatus = novoStatus;
	}

	public String getAntigoStatus() {
		return antigoStatus;
	}

	public void setAntigoStatus(String antigoStatus) {
		this.antigoStatus = antigoStatus;
	}

	public String getObs() {
		return obs;
	}

	public void setObs(String obs) {
		this.obs = obs;
	}


	public void setDataInicioIN(Timestamp dataInicioIN) {
		this.dataInicioIN = dataInicioIN;
	}

	public void setDataFimIN(Timestamp dataFimIN) {
		this.dataFimIN = dataFimIN;
	}

	public Timestamp getDataInicioIN() {
		return dataInicioIN;
	}

	public Timestamp getDataFimIN() {
		return dataFimIN;
	}

	public String getIdMarcados() {
		return idMarcados;
	}

	public void setIdMarcados(String idMarcados) {
		this.idMarcados = idMarcados;
	}


}
