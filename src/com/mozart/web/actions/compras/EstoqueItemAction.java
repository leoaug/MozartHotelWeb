package com.mozart.web.actions.compras;

import java.util.Collections;
import java.util.List;

import com.mozart.model.delegate.CheckinDelegate;
import com.mozart.model.delegate.ComprasDelegate;
import com.mozart.model.delegate.CustoDelegate;
import com.mozart.model.delegate.RedeDelegate;
import com.mozart.model.ejb.entity.AliquotaEJB;
import com.mozart.model.ejb.entity.CentroCustoContabilEJB;
import com.mozart.model.ejb.entity.FiscalCodigoEJB;
import com.mozart.model.ejb.entity.FiscalIncidenciaEJB;
import com.mozart.model.ejb.entity.HotelEJB;
import com.mozart.model.ejb.entity.ItemEstoqueEJB;
import com.mozart.model.ejb.entity.ItemRedeEJB;
import com.mozart.model.ejb.entity.ItemRedeEJBPK;
import com.mozart.model.ejb.entity.RedeHotelEJB;
import com.mozart.model.ejb.entity.TipoItemEJB;
import com.mozart.model.ejb.entity.UnidadeEstoqueEJB;
import com.mozart.model.exception.MozartSessionException;
import com.mozart.model.exception.MozartValidateException;
import com.mozart.model.util.MozartUtil;
import com.mozart.model.vo.EstoqueItemVO;
import com.mozart.model.vo.PlanoContaVO;
import com.mozart.web.actions.BaseAction;

public class EstoqueItemAction extends BaseAction {

	private static final long serialVersionUID = 1L;

	private EstoqueItemVO filtro;
	private ItemEstoqueEJB entidade;
	private ItemRedeEJB entidadeRede;
	private List<TipoItemEJB> tipoItemList;
	private List<UnidadeEstoqueEJB> unidadeEstoqueList;
	private List<CentroCustoContabilEJB> centroCustoContabilList;
	private List<PlanoContaVO> planoContaList;
	private List<ItemRedeEJB> itemRedeList;
	private List<FiscalCodigoEJB> fiscalCodigoList;
	private List<FiscalIncidenciaEJB> fiscalIncidenciaList;
	private List<AliquotaEJB> aliquotaList;

	public EstoqueItemAction() {
		filtro = new EstoqueItemVO();
		entidade = new ItemEstoqueEJB();
		entidade.setControlado("N");
		entidade.setFiscalCodigoEJB(new FiscalCodigoEJB());
		tipoItemList = Collections.emptyList();
		unidadeEstoqueList = Collections.emptyList();
		centroCustoContabilList = Collections.emptyList();
		planoContaList = Collections.emptyList();
		itemRedeList = Collections.emptyList();
		entidadeRede = new ItemRedeEJB();
		fiscalCodigoList = Collections.emptyList();
		fiscalIncidenciaList = Collections.emptyList();
		aliquotaList = Collections.emptyList();
	}

	private void initCombo() throws MozartSessionException {

		HotelEJB hotel = getHotelCorrente();
		RedeHotelEJB redeHotel = getHotelCorrente().getRedeHotelEJB();

		tipoItemList = CustoDelegate.instance().obterTipoItem(hotel);
		unidadeEstoqueList = ComprasDelegate.instance()
				.pesquisarUnidadeEstoque(redeHotel);

		CentroCustoContabilEJB filtroCentroCustoContabil = new CentroCustoContabilEJB();
		filtroCentroCustoContabil.setIdRedeHotel(getHotelCorrente()
				.getRedeHotelEJB().getIdRedeHotel());
		centroCustoContabilList = RedeDelegate.instance().pesquisarCentroCusto(
				filtroCentroCustoContabil);

		PlanoContaVO filtroPlanoConta = new PlanoContaVO();
		filtroPlanoConta.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB()
				.getIdRedeHotel());
		filtroPlanoConta.getFiltroTipoConta().setTipo("C");
		filtroPlanoConta.getFiltroTipoConta().setTipoIntervalo("2");
		filtroPlanoConta.getFiltroTipoConta().setValorInicial("Analitico");
		planoContaList = RedeDelegate.instance().pesquisarPlanoConta(
				filtroPlanoConta);

		ItemRedeEJB itemRede = new ItemRedeEJB();
		ItemRedeEJBPK pk = new ItemRedeEJBPK();

		pk.setIdRedeHotel(getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		itemRede.setId(pk);
		itemRede.getId().setIdRedeHotel(
				getHotelCorrente().getRedeHotelEJB().getIdRedeHotel());
		itemRedeList = ComprasDelegate.instance().pesquisarItemRede(itemRede);

		aliquotaList = CustoDelegate.instance().obterAliquota(hotel);
		fiscalIncidenciaList = CustoDelegate.instance()
				.obterFiscalIncidencias();
		fiscalCodigoList = CustoDelegate.instance().obterFiscalCodigoCompra(
				hotel);
	}

	public String validarItens() {

		try {
			initCombo();
			info("Iniciando validacao dos itens");
			ItemRedeEJB itemRede = new ItemRedeEJB();
			ItemRedeEJBPK pk = new ItemRedeEJBPK();

			if (MozartUtil.isNull(entidadeRede.getId())
					|| MozartUtil.isNull(entidadeRede.getId().getIdItem())) {

				entidadeRede = new ItemRedeEJB();
				entidade = new ItemEstoqueEJB();
				entidade.setControlado("N");
				request.getSession().setAttribute("ATIVAR_CAMPOS_REDE", true);

				return SUCESSO_FORWARD;

			}

			pk.setIdRedeHotel((getHotelCorrente().getRedeHotelEJB()
					.getIdRedeHotel()));
			pk.setIdItem(entidadeRede.getId().getIdItem());
			itemRede.setId(pk);
			if (itemRedeList.contains(itemRede)) {

				entidadeRede = itemRedeList.get(itemRedeList.indexOf(itemRede));
				entidade.getId().setIdItem(entidadeRede.getId().getIdItem());
				entidade.getId().setIdHotel(getHotelCorrente().getIdHotel());
				if (!MozartUtil.isNull(entidadeRede.getItemEstoqueEJBList())
						&& entidadeRede.getItemEstoqueEJBList().contains(
								entidade)) {

					entidade = (ItemEstoqueEJB) CheckinDelegate.instance()
							.obter(ItemEstoqueEJB.class, entidade.getId());

				}
				request.getSession().setAttribute("ATIVAR_CAMPOS_REDE", false);
			}

		} catch (Exception ex) {
			addMensagemErro(MSG_ERRO);
			error(ex.getMessage());
		}

		return SUCESSO_FORWARD;
	}

	public String prepararInclusao() {

		try {
			initCombo();
			request.getSession().setAttribute("ATIVAR_CAMPOS_REDE", true);
		} catch (MozartSessionException e) {

			addMensagemErro(MSG_ERRO);
			error(e.getMessage());

		}
		return SUCESSO_FORWARD;

	}

	public String prepararAlteracao() {

		return validarItens();
	}

	public String gravar() {
		try {

			entidadeRede.setUsuario(getUserSession().getUsuarioEJB());
			entidadeRede.addItemEstoqueEJB(entidade);

			if (!MozartUtil.isNull(entidade.getIdFiscalCodigo())) {
				FiscalCodigoEJB fiscal = (FiscalCodigoEJB) CheckinDelegate
						.instance().obter(FiscalCodigoEJB.class,
								entidade.getIdFiscalCodigo());

				entidade.setFiscalCodigoEJB(fiscal);
			}

			if (MozartUtil.isNull(entidadeRede.getUnidadeEstoqueCompraEJB()
					.getIdUnidadeEstoque())) {
				entidadeRede.setUnidadeEstoqueCompraEJB(null);

			}
			if (MozartUtil.isNull(entidadeRede.getUnidadeEstoqueRedeEJB()
					.getIdUnidadeEstoque())) {
				entidadeRede.setUnidadeEstoqueRedeEJB(null);

			}
			if (MozartUtil.isNull(entidadeRede.getUnidadeEstoqueRequisicaoJB()
					.getIdUnidadeEstoque())) {
				entidadeRede.setUnidadeEstoqueRequisicaoJB(null);
			}

			if (!MozartUtil.isNull(entidadeRede.getTipoItemEJB())
					&& !MozartUtil.isNull(entidadeRede.getTipoItemEJB()
							.getApelido())
					&& entidadeRede.getTipoItemEJB().getApelido().equals("I")) {
				entidadeRede.setImobilizado("S");
			} else {
				entidadeRede.setImobilizado("N");
			}

			if (MozartUtil.isNull(entidadeRede.getId().getIdItem())) {
				CheckinDelegate.instance().incluir(entidadeRede);
			} else {
				CheckinDelegate.instance().alterar(entidadeRede);
			}
			addMensagemSucesso(MSG_SUCESSO);
			entidade = new ItemEstoqueEJB();
			entidadeRede = new ItemRedeEJB();

		} catch (MozartValidateException ex) {
			error(ex.getMessage());
			addMensagemSucesso(ex.getMessage());

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);

		} finally {

			try {
				initCombo();
			} catch (MozartSessionException e) {
				error(e.getMessage());
				addMensagemErro(MSG_ERRO);
			}

		}
		return SUCESSO_FORWARD;

	}

	public String prepararPesquisa() {
		request.getSession().removeAttribute(LISTA_PESQUISA);
		request.getSession().removeAttribute("ATIVAR_CAMPOS_REDE");
		return SUCESSO_FORWARD;
	}

	public String pesquisar() {

		try {
			filtro.setIdHoteis(getIdHoteis());
			List<EstoqueItemVO> lista = ComprasDelegate.instance()
					.pesquisarEstoqueItem(filtro);
			if (MozartUtil.isNull(lista)) {
				addMensagemSucesso(MSG_PESQUISA_VAZIA);
			}
			request.getSession().setAttribute(LISTA_PESQUISA, lista);

		} catch (Exception ex) {
			error(ex.getMessage());
			addMensagemErro(MSG_ERRO);
		}
		return SUCESSO_FORWARD;
	}

	public EstoqueItemVO getFiltro() {
		return filtro;
	}

	public void setFiltro(EstoqueItemVO filtro) {
		this.filtro = filtro;
	}

	public ItemEstoqueEJB getEntidade() {
		return entidade;
	}

	public void setEntidade(ItemEstoqueEJB entidade) {
		this.entidade = entidade;
	}

	public List<TipoItemEJB> getTipoItemList() {
		return tipoItemList;
	}

	public void setTipoItemList(List<TipoItemEJB> tipoItemList) {
		this.tipoItemList = tipoItemList;
	}

	public List<UnidadeEstoqueEJB> getUnidadeEstoqueList() {
		return unidadeEstoqueList;
	}

	public void setUnidadeEstoqueList(List<UnidadeEstoqueEJB> unidadeEstoqueList) {
		this.unidadeEstoqueList = unidadeEstoqueList;
	}

	public List<CentroCustoContabilEJB> getCentroCustoContabilList() {
		return centroCustoContabilList;
	}

	public void setCentroCustoContabilList(
			List<CentroCustoContabilEJB> centroCustoContabilList) {
		this.centroCustoContabilList = centroCustoContabilList;
	}

	public List<PlanoContaVO> getPlanoContaList() {
		return planoContaList;
	}

	public void setPlanoContaList(List<PlanoContaVO> planoContaList) {
		this.planoContaList = planoContaList;
	}

	public List<ItemRedeEJB> getItemRedeList() {
		return itemRedeList;
	}

	public void setItemRedeList(List<ItemRedeEJB> itemRedeList) {
		this.itemRedeList = itemRedeList;
	}

	public ItemRedeEJB getEntidadeRede() {
		return entidadeRede;
	}

	public void setEntidadeRede(ItemRedeEJB entidadeRede) {
		this.entidadeRede = entidadeRede;
	}

	public List<FiscalCodigoEJB> getFiscalCodigoList() {
		return fiscalCodigoList;
	}

	public void setFiscalCodigoList(List<FiscalCodigoEJB> fiscalCodigoList) {
		this.fiscalCodigoList = fiscalCodigoList;
	}

	public List<FiscalIncidenciaEJB> getFiscalIncidenciaList() {
		return fiscalIncidenciaList;
	}

	public void setFiscalIncidenciaList(
			List<FiscalIncidenciaEJB> fiscalIncidenciaList) {
		this.fiscalIncidenciaList = fiscalIncidenciaList;
	}

	public List<AliquotaEJB> getAliquotaList() {
		return aliquotaList;
	}

	public void setAliquotaList(List<AliquotaEJB> aliquotaList) {
		this.aliquotaList = aliquotaList;
	}

}