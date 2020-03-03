package com.mozart.web.api.request;

import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnore;

public class PromotorRequest extends BasicoRequest {
	private BigDecimal comissao;
	private PessoaRequest promotor;
	public BigDecimal getComissao() {
		return comissao;
	}
	public void setComissao(BigDecimal comissao) {
		this.comissao = comissao;
	}
	public PessoaRequest getPromotor() {
		return promotor;
	}
	public void setPromotor(PessoaRequest promotor) {
		this.promotor = promotor;
	}
	
	@Override
	@JsonIgnore
	public PessoaRequest getPessoa() {
		return getPromotor();
	}
	
	

}
