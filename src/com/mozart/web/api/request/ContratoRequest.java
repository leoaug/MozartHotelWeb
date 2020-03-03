package com.mozart.web.api.request;

import java.math.BigDecimal;
import java.time.LocalDate;

import javax.validation.constraints.Future;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonFormat.Shape;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.mozart.web.api.converter.LocalDateDeserializer;
import com.mozart.web.api.converter.LocalDateSerializer;

public class ContratoRequest extends BasicoRequest {

	@NotNull
	private PessoaRequest cliente;
	
	@JsonFormat(shape = Shape.STRING, pattern = "yyyy-MM-ddd")
	@JsonDeserialize(using = LocalDateDeserializer.class)
	@JsonSerialize(using = LocalDateSerializer.class)
	private LocalDate dataInicio;
	
	@Future
	@JsonFormat(shape = Shape.STRING, pattern = "yyyy-MM-ddd")
	@JsonDeserialize(using = LocalDateDeserializer.class)
	@JsonSerialize(using = LocalDateSerializer.class)
	private LocalDate dataFim;
	
	private Integer diaFaturamento;
	private Integer quantidade;
	private String descricaoServico;
	private BigDecimal valorServico;
	
	private Long idTipoLancamento;

	private Long idTipoLancamentoCk;

	public PessoaRequest getCliente() {
		return cliente;
	}

	public void setCliente(PessoaRequest cliente) {
		this.cliente = cliente;
	}

	public LocalDate getDataInicio() {
		return dataInicio;
	}

	public void setDataInicio(LocalDate dataInicio) {
		this.dataInicio = dataInicio;
	}

	public LocalDate getDataFim() {
		return dataFim;
	}

	public void setDataFim(LocalDate dataFim) {
		this.dataFim = dataFim;
	}

	public Integer getDiaFaturamento() {
		return diaFaturamento;
	}

	public void setDiaFaturamento(Integer diaFaturamento) {
		this.diaFaturamento = diaFaturamento;
	}

	public String getDescricaoServico() {
		return descricaoServico;
	}

	public void setDescricaoServico(String descricaoServico) {
		this.descricaoServico = descricaoServico;
	}

	public BigDecimal getValorServico() {
		return valorServico;
	}

	public void setValorServico(BigDecimal valorServico) {
		this.valorServico = valorServico;
	}

	public Long getIdTipoLancamento() {
		return idTipoLancamento;
	}

	public void setIdTipoLancamento(Long idTipoLancamento) {
		this.idTipoLancamento = idTipoLancamento;
	}

	public Long getIdTipoLancamentoCk() {
		return idTipoLancamentoCk;
	}

	public void setIdTipoLancamentoCk(Long idTipoLancamentoCk) {
		this.idTipoLancamentoCk = idTipoLancamentoCk;
	}

	public Integer getQuantidade() {
		return quantidade;
	}

	public void setQuantidade(Integer quantidade) {
		this.quantidade = quantidade;
	}

	@JsonIgnore
	@Override
	public PessoaRequest getPessoa() {
		return getCliente();
	}
	
	

}
