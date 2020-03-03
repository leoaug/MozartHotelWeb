package com.mozart.web.exception;

import javax.servlet.ServletException;

public class MozartForaDoHorarioException extends ServletException{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2485218481201472858L;
	public MozartForaDoHorarioException() {
    }

    public MozartForaDoHorarioException(String erro) {
        super(erro);
    }

    public MozartForaDoHorarioException(Throwable erro) {
        super(erro);
    }
}
