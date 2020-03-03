package com.mozart.web.actions.caixa;

import java.util.ArrayList;
import java.util.List;

import com.mozart.model.delegate.CaixaGeralDelegate;
import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.ejb.entity.ApartamentoEJB;
import com.mozart.model.ejb.entity.CheckinEJB;
import com.mozart.model.ejb.entity.MovimentoApartamentoEJB;
import com.mozart.model.ejb.entity.RoomListEJB;
import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;
import com.mozart.web.util.MozartWebUtil;

public class TransferenciaDespesaAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4160801607749099641L;
	
	private List<ApartamentoEJB> apartamentoOcupadoList;
	private List<MozartComboWeb> roomList;
	private String[] despesas;
	private ApartamentoEJB origem;
	private ApartamentoEJB destino;
	private Long idRoomList;
	private String motivo;
	
	
	public TransferenciaDespesaAction(){
		origem = new ApartamentoEJB();
		destino = new ApartamentoEJB();
		roomList =  new ArrayList<MozartComboWeb>();
	}

	public String preparar(){
		info("Preparando Transferencia despesas");
		try {
			
			Long idReserva = (Long) request.getSession().getAttribute("ID_RES_PAG_ANTEC");
			Long idAptoCofan = (Long) request.getSession().getAttribute("ID_APTO_COFAN_PAG_ANTEC");
			Long idAptoCheckin = (Long) request.getSession().getAttribute("ID_APTO_CHECKIN");

			ApartamentoEJB pApto = new ApartamentoEJB();
			pApto.setIdHotel( getIdHoteis()[0]);
			pApto.setStatus("O");
			origem = new ApartamentoEJB();
			destino = new ApartamentoEJB();
			motivo = "";

			apartamentoOcupadoList = CheckinDelegate.instance().pesquisarApartamento(pApto);
			
			request.getSession().removeAttribute("movimentoApartamentoList");
			
			if(idReserva != null && idReserva.longValue() != 0L){
				pApto.setIdApartamento(idAptoCofan);
				origem.setIdApartamento(idAptoCofan);
				destino.setIdApartamento(idAptoCheckin);
				motivo = "Dep. Antecipado";
				
				ApartamentoEJB apto = new ApartamentoEJB();
				apto.setIdHotel(getHotelCorrente().getIdHotel());
				apto.setIdApartamento(new Long(idAptoCheckin));

				List<RoomListEJB> list = CaixaGeralDelegate.instance()
						.obterHospedePorApartamento(apto);
				
				if (MozartUtil.isNull(list)) {
					roomList.add(new MozartComboWeb("", ""));
				} else {
					roomList = new ArrayList<MozartComboWeb>();
					for (RoomListEJB linha : list) {
						roomList.add(new MozartComboWeb( linha.getIdRoomList().toString(), 
								linha.getHospede().getNomeHospede()
								+ " " + linha.getHospede().getSobrenomeHospede()));
					}
				}
				
				MovimentoApartamentoEJB movApto = new MovimentoApartamentoEJB();
				
				origem.setIdHotel(getHotelCorrente().getIdHotel());
				
				origem.setIdApartamento(idAptoCofan);
				
				MozartWebUtil.info(MozartWebUtil.getLogin(request),
						"Obtendo despesas de:" + origem.getIdApartamento() + ".",
						this.log);

				movApto.setCheckinEJB(new CheckinEJB());
				movApto.getCheckinEJB().setApartamentoEJB(origem);
				if( ! MozartUtil.isNull(idReserva)){
					movApto.setNumDocumento(idReserva.toString());
				}
				
				List<MovimentoApartamentoEJB> listaMovimentoAtual = CaixaGeralDelegate
						.instance().obterMovimentoAtualDoApartamento(movApto);
				
				request.getSession().setAttribute("movimentoApartamentoList",
						listaMovimentoAtual);
			}
			
			
			List <ApartamentoEJB> apartamentoOrigemList = CheckinDelegate.instance().pesquisarApartamento(pApto);
			request.getSession().setAttribute("apartamentoOcupadoOrigemList", apartamentoOrigemList);
			request.getSession().setAttribute("apartamentoOcupadoDestinoList",apartamentoOcupadoList);

			if(idReserva != null && idReserva.longValue() != 0L){
				request.getSession().setAttribute("msgCofan","Identificado depósito antecipado no cofan: " + apartamentoOrigemList.get(0).toString() + " para esta reserva.");
				addActionMessage("Identificado depósito antecipado no cofan: " + apartamentoOrigemList.get(0).toString() + " para esta reserva.");
			}
			
	
		} catch (Exception ex) {
			error(ex.getMessage());
			addActionError(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}
	
	
	@SuppressWarnings("unchecked")
	public String gravar(){
		info("Gravando diárias automáticas");
		try {
			List<ApartamentoEJB> apartamentoOcupadoOrigemList = (List<ApartamentoEJB>) request.getSession().getAttribute("apartamentoOcupadoOrigemList");
			List<ApartamentoEJB> apartamentoOcupadoDestinoList = (List<ApartamentoEJB>) request.getSession().getAttribute("apartamentoOcupadoDestinoList");
			
			origem = apartamentoOcupadoOrigemList.get( apartamentoOcupadoOrigemList.indexOf( origem ));
			destino = apartamentoOcupadoDestinoList.get( apartamentoOcupadoDestinoList.indexOf( destino ));
			
			List<MovimentoApartamentoEJB> listaMovimento = (List<MovimentoApartamentoEJB>)request.getSession().getAttribute("movimentoApartamentoList");
			
			List<MovimentoApartamentoEJB> listaMovimentoATransferir = new ArrayList<MovimentoApartamentoEJB>();
			for (String id: despesas){
				MovimentoApartamentoEJB mov = new MovimentoApartamentoEJB();
				mov.setIdMovimentoApartamento( new Long( id ));
				mov = listaMovimento.get( listaMovimento.indexOf( mov ));
				mov.setNumDocumento("TR "+origem.getNumApartamento() + " " + mov.getNumDocumento());				
				listaMovimentoATransferir.add( mov );
			}
			
			destino.setIdHotel( getIdHoteis()[0]);
			destino.setUsuario( getUserSession().getUsuarioEJB() );
			CaixaGeralDelegate.instance().transferirDespesasParaApto(destino, idRoomList, motivo, listaMovimentoATransferir);
			addMensagemSucesso(MSG_SUCESSO);
			request.getSession().removeAttribute("ID_RES_PAG_ANTEC");
			request.getSession().removeAttribute("ID_APTO_COFAN_PAG_ANTEC");
			request.getSession().removeAttribute("ID_APTO_CHECKIN");
			request.getSession().removeAttribute("msgCofan");
			return preparar();
		} catch (Exception ex) {
			error(ex.getMessage());
			if (ex.getMessage() != null && ex.getMessage().indexOf("-20001") > 0){
				addMensagemSucesso( ex.getMessage() );
			}else{
				addActionError(MSG_ERRO);
			}
			return SUCESSO_FORWARD;
		}		
	}

	public List<ApartamentoEJB> getApartamentoOcupadoList() {
		return apartamentoOcupadoList;
	}

	public void setApartamentoOcupadoList(
			List<ApartamentoEJB> apartamentoOcupadoList) {
		this.apartamentoOcupadoList = apartamentoOcupadoList;
	}

	public String[] getDespesas() {
		return despesas;
	}

	public void setDespesas(String[] despesas) {
		this.despesas = despesas;
	}

	public ApartamentoEJB getOrigem() {
		return origem;
	}

	public void setOrigem(ApartamentoEJB origem) {
		this.origem = origem;
	}

	public ApartamentoEJB getDestino() {
		return destino;
	}

	public void setDestino(ApartamentoEJB destino) {
		this.destino = destino;
	}

	public Long getIdRoomList() {
		return idRoomList;
	}

	public void setIdRoomList(Long idRoomList) {
		this.idRoomList = idRoomList;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public List<MozartComboWeb> getRoomList() {
		return roomList;
	}

	public void setRoomList(List<MozartComboWeb> roomList) {
		this.roomList = roomList;
	}	
}
