package com.mozart.web.api.request;

public class EnderecoRequest {
	private String logradouro;
	private String numero;
	private String complemento;
	private String bairro;
	private Long cidade;
	private String cep;
	private EstadoRequest estado;

	public String getLogradouro() {
		return logradouro;
	}

	public void setLogradouro(String logradouro) {
		this.logradouro = logradouro;
	}

	public String getNumero() {
		return numero;
	}

	public void setNumero(String numero) {
		this.numero = numero;
	}

	public String getComplemento() {
		return complemento;
	}

	public void setComplemento(String complemento) {
		this.complemento = complemento;
	}

	public String getBairro() {
		return bairro;
	}

	public void setBairro(String bairro) {
		this.bairro = bairro;
	}

	public Long getCidade() {
		return cidade;
	}

	public void setCidade(Long cidade) {
		this.cidade = cidade;
	}

	public String getCep() {
		return cep;
	}

	public void setCep(String cep) {
		this.cep = cep;
	}

	public EstadoRequest getEstado() {
		return estado;
	}

	public void setEstado(EstadoRequest estado) {
		this.estado = estado;
	}

}
