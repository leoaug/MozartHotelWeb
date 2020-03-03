package com.mozart.web.actions.crs;

import java.util.ArrayList;
import java.sql.Timestamp;
import java.util.List;

import com.mozart.model.util.MozartUtil;
import com.mozart.web.actions.BaseAction;
import com.mozart.web.util.MozartComboWeb;

public class DisponibilidadeAction extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1689092007902664857L;
	
	
	private Timestamp dataIn;
	private Timestamp dataOut;
	private String comBloqueio, ocupacaoDisponibilidade;
	private List<MozartComboWeb> listaDispoOcupacao;
	
	public DisponibilidadeAction(){
		
	}
	
	public String prepararDisponibilidade(){
		if (dataIn == null){
			dataIn = getControlaData().getFrontOffice();
			dataOut = MozartUtil.incrementarDia(dataIn);
		}
		comBloqueio = "N";
		
		listaDispoOcupacao = new ArrayList<MozartComboWeb>();
		listaDispoOcupacao.add( new MozartComboWeb("D", "Disponibilidade"));
		listaDispoOcupacao.add( new MozartComboWeb("O", "Ocupação"));
		return SUCESSO_FORWARD;
	}



	public Timestamp getDataIn() {
		return dataIn;
	}



	public void setDataIn(Timestamp dataIn) {
		this.dataIn = dataIn;
	}



	public Timestamp getDataOut() {
		return dataOut;
	}



	public void setDataOut(Timestamp dataOut) {
		this.dataOut = dataOut;
	}



	public String getComBloqueio() {
		return comBloqueio;
	}



	public void setComBloqueio(String comBloqueio) {
		this.comBloqueio = comBloqueio;
	}

	public List<MozartComboWeb> getListaDispoOcupacao() {
		return listaDispoOcupacao;
	}

	public void setListaDispoOcupacao(List<MozartComboWeb> listaDispoOcupacao) {
		this.listaDispoOcupacao = listaDispoOcupacao;
	}

	public String getOcupacaoDisponibilidade() {
		return ocupacaoDisponibilidade;
	}

	public void setOcupacaoDisponibilidade(String ocupacaoDisponibilidade) {
		this.ocupacaoDisponibilidade = ocupacaoDisponibilidade;
	}

}
