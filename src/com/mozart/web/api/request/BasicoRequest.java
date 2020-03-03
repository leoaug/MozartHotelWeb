package com.mozart.web.api.request;

import java.time.LocalDate;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonFormat.Shape;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.mozart.web.api.converter.LocalDateDeserializer;
import com.mozart.web.api.converter.LocalDateSerializer;

public abstract class BasicoRequest {
	@NotNull
	private Long idRede;
	@NotNull
	private Long idUnidade;

	@NotNull
	@JsonFormat(shape = Shape.STRING, pattern = "yyyy-MM-ddd")
	@JsonDeserialize(using = LocalDateDeserializer.class)
	@JsonSerialize(using = LocalDateSerializer.class)
	private LocalDate dataCadastro;

	public Long getIdRede() {
		return idRede;
	}

	public void setIdRede(Long idRede) {
		this.idRede = idRede;
	}

	public Long getIdUnidade() {
		return idUnidade;
	}

	public void setIdUnidade(Long idUnidade) {
		this.idUnidade = idUnidade;
	}

	public LocalDate getDataCadastro() {
		return dataCadastro;
	}

	public void setDataCadastro(LocalDate dataCadastro) {
		this.dataCadastro = dataCadastro;
	}
	
	@JsonIgnore	
	public abstract PessoaRequest getPessoa();

}