package com.mozart.web.actions.custo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.NfeDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.AliquotaEJB;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.DepartamentoEJB;
import com.mozart.model.ejb.entity.FichaTecnicaPratoEJB;
import com.mozart.model.ejb.entity.FichaTecnicaPratoEJBPK;
import com.mozart.model.ejb.entity.FiscalCodigoEJB;
import com.mozart.model.ejb.entity.FiscalIncidenciaEJB;
import com.mozart.model.ejb.entity.GrupoPratoEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJBPK;
import com.mozart.model.ejb.entity.ItemRedeEJB;
import com.mozart.model.ejb.entity.ItemRedeEJBPK;
import com.mozart.model.ejb.entity.NfeCofinsCadastroEJB;
import com.mozart.model.ejb.entity.NfeCofinsCadastroStEJB;
import com.mozart.model.ejb.entity.NfeCofinsCstEJB;
import com.mozart.model.ejb.entity.NfeIICadastroEJB;
import com.mozart.model.ejb.entity.NfeIcmsCadastroEJB;
import com.mozart.model.ejb.entity.NfeIcmsModBcIcmsEJB;
import com.mozart.model.ejb.entity.NfeIcmsModBcIcmsStEJB;
import com.mozart.model.ejb.entity.NfeIcmsMotivoDesoneracaoEJB;
import com.mozart.model.ejb.entity.NfeIcmsOrigemMercadoriaEJB;
import com.mozart.model.ejb.entity.NfeIpiCadastroEJB;
import com.mozart.model.ejb.entity.NfeIpiCstEJB;
import com.mozart.model.ejb.entity.NfePisCadastroEJB;
import com.mozart.model.ejb.entity.NfePisCadastroStEJB;
import com.mozart.model.ejb.entity.NfePisCstEJB;
import com.mozart.model.ejb.entity.PratoEJB;
import com.mozart.model.ejb.entity.TipoItemEJB;
import com.mozart.model.ejb.enums.EnumCstA;
import com.mozart.model.ejb.enums.EnumCstB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.CentroCustoVO;
import com.mozart.model.vo.ItemEstoqueVO;
import com.mozart.model.vo.PratoVO;
import com.mozart.model.vo.SituacaoTributariaVO;
import com.mozart.model.vo.UnidadeNfeVO;
import com.mozart.web.actions.BaseAction;

public class RelatorioCustoAction extends BaseAction {

private static final long serialVersionUID = -4797381933648578239L;
	
	private List <CentroCustoContabilEJB> centroCustoList;
	private List <DepartamentoEJB> departamentoList;
	
	public RelatorioCustoAction (){
		centroCustoList = Collections.emptyList();
		departamentoList = Collections.emptyList();
	}
	
	private void initCombo() throws MozartSessionException {

		CentroCustoContabilEJB filtroCentroCusto = new CentroCustoContabilEJB();
		filtroCentroCusto.setIdRedeHotel( getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		centroCustoList = RedeDelegate.instance().pesquisarCentroCusto(filtroCentroCusto);  
		
		DepartamentoEJB filtro = new DepartamentoEJB();
		filtro.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		departamentoList = RedeDelegate.instance().pesquisarDepartamento(filtro);
	}

	public String prepararPesquisa() throws MozartSessionException{
		initCombo();
		request.getSession().removeAttribute(LISTA_PESQUISA);
		return SUCESSO_FORWARD;
	}

	public List<CentroCustoContabilEJB> getCentroCustoList() {
		return centroCustoList;
	}

	public void setCentroCustoList(List<CentroCustoContabilEJB> centroCustoList) {
		this.centroCustoList = centroCustoList;
	}

	public List<DepartamentoEJB> getDepartamentoList() {
		return departamentoList;
	}

	public void setDepartamentoList(List<DepartamentoEJB> departamentoList) {
		this.departamentoList = departamentoList;
	}
	
}
